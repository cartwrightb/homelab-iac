# Security and private configuration

## Public repository boundary

Keep credentials, tokens, private keys, Terraform state, saved plans and
sensitive infrastructure details out of tracked files. Use clearly fictional
values and placeholders in examples. Do not publish actual addresses,
hostnames, topology or access details in documentation or command output.

Prefer keeping real inventories, input values and backend configuration
outside the checkout. `.local/` and `inventories/private/` are ignored fallback
locations for local configuration, not secret stores.

## Ignore policy

The root `.gitignore` covers common Terraform and Packer input files, state,
plans, local credentials, private inventories and generated artifacts.
Use names such as `terraform.tfvars.example` and `image.pkrvars.hcl.example`
for sanitized examples. `.env.example` is also permitted.

Terraform root dependency lock files (`.terraform.lock.hcl`) should be
tracked. They record dependency selections, not Terraform resource state.

Ignore rules do not remove already tracked files, prevent force-adding files
or identify every secret. Saved plans with arbitrary names, inventory files
outside private paths and secrets embedded in ordinary source files may
escape these patterns. Review all file contents before committing; add
secret scanning when selecting the first CI checks.

## State and credentials

Before live provisioning, choose state storage and locking, access controls,
backup and recovery, and credential delivery. State and saved plans can
contain sensitive values even when terminal output marks them sensitive.
Do not put credentials in backend configuration committed to Git.

No backend or secret-management product has been selected. This foundation
does not establish encryption, access control or recovery for private data.

## CI trust boundary

Public CI should perform static checks without homelab access or credentials.
Do not expose secrets to untrusted pull requests. Introduce workflows and
their permissions when actual configuration needs validation.

## Accidental disclosure

If a real secret is exposed, stop reproducing it in output and arrange
revocation or rotation with the owner. Removing a file in a later commit
does not remove it from Git history. Coordinate any history rewrite or
external remediation explicitly before execution.
