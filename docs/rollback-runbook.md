# Rollback and Incident Runbook

This runbook describes how to respond when a Terraform apply or destroy fails, or when
drift detection reports differences between configuration and the live environment.

## 1. A `Terraform Apply` run failed

1. Open the GitHub issue automatically created by the failed run (label
   `terraform-failure`). It links to the failed workflow run.
2. Open the run and read the error in the `Apply exact reviewed plan` step.
3. Do not re-run the same apply blindly. Terraform may have partially created or
   modified resources before failing.
4. Check what actually exists in Azure:
   ```powershell
   az resource list --resource-group "rg-hybridcloud-<environment>" -o table
   ```
5. Common causes and fixes:
   - **Resource already exists** (`A resource with the ID ... already exists`): add an
     `import` block for that resource in `environments/<environment>/main.tf`, validate,
     commit, then run a fresh `Terraform Plan` and `Terraform Apply`.
   - **State lock held by a previous run** (`Error acquiring the state lock`): confirm no
     other plan/apply is running, then break the lease:
     ```powershell
     az storage blob lease break `
       --account-name sttfstate<environment>01ahcps `
       --container-name tfstate `
       --blob-name <environment>.terraform.tfstate `
       --auth-mode login
     ```
   - **Authorization/permission error**: grant the missing role to the GitHub OIDC
     identity at subscription scope, wait a few minutes for propagation, then retry.
   - **Timeout**: increase `timeout-minutes` in the workflow only if the operation is
     known to need more time (e.g., VPN gateway provisioning).
6. After a fix, always start over with a **new** `Terraform Plan` run. Never apply a plan
   artifact produced before the fix.

## 2. A `Terraform Destroy Apply` run failed

Follow the same steps as above. Additionally:

- Confirm which resources were actually removed before the failure using
  `az resource list`.
- If some resources were destroyed and others were not, treat the environment as
  partially destroyed: create a fresh destroy plan to see what remains, review it
  carefully, and only then re-run destroy apply.

## 3. Drift detected by the scheduled `Terraform Drift Detection` workflow

1. Open the auto-created/updated issue (label `terraform-drift`, plus the environment
   label).
2. Review the plan summary in the issue body.
3. Decide the correct direction:
   - If the drift is an unwanted manual change in Azure, reconcile it with a reviewed
     `Terraform Plan` and `Terraform Apply` to bring the environment back to the
     configuration.
   - If the drift reflects an intentional change made outside Terraform, update the
     Terraform configuration to match, then run `Terraform Plan` to confirm no more
     changes remain, and merge that update.
4. Once reconciled, the next scheduled drift run automatically closes the issue.

## 4. Rolling back a bad change

Terraform does not have a built-in "undo". To roll back:

1. Identify the last known-good commit on `main` (for example, the commit before the
   change that caused the issue).
2. Run `Terraform Plan` with `source_ref` set to that earlier commit SHA.
3. Review the plan carefully. It will show whatever changes are needed to return to that
   configuration; this may include resource replacement, not just reverting values.
4. Only apply after review, using the plan's own run ID and commit SHA.
5. Follow up with a proper revert commit on `main` so history and the deployed state stay
   consistent, instead of leaving `main` pointed at the bad configuration.

## 5. General rules

- Never edit Terraform state files manually.
- Never commit `terraform.tfvars`, state files, or credentials.
- Never apply a plan artifact from a different commit or environment than what you
  intend to change.
- Prefer creating a new plan over re-running an old one after any fix.