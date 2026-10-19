# Private local state backup and recovery

## Preconditions

Untested procedure. Agree private absolute paths, encrypted filesystem and an
encrypted versioned backup method/destination/retention outside build01. Keep
decryption keys and bootstrap instructions recoverable from another trusted
machine. Do not put real paths, backups or keys into this repository.

Use one operator/runner and only the default Terraform workspace. No parallel
copies, shared-folder state, disabled locking or automatic jobs. File permissions
and encryption do not protect state from a compromised logged-in controller.

## Initialization discipline

1. Set umask 077. Prepare private directories with mode 0700 and private files
   with mode 0600. Place state, Terraform data, plans, inputs and inventory there.
2. Fill in both absolute paths in a private copy of `backend.tfbackend.example`.
   Confirm neither path nor a symlink resolves into the checkout. Keep the
   backend selection paired with this root; never reuse another root's metadata.
3. Use `TF_DATA_DIR` outside the checkout for every init/plan/apply/output/destroy
   command. Review inherited `TF_WORKSPACE`, `TF_CLI_ARGS*` and `TF_VAR_*`; use
   the default workspace and remove unexpected settings without printing secrets.
4. After installation is approved, initialize with the explicit backend file.
   Provider download is software installation. This command is documentation,
   not currently authorized execution:

   ```sh
   export TF_DATA_DIR=/REPLACE_PRIVATE_DIRECTORY/terraform-data/homelab
   terraform -chdir=terraform/environments/homelab init \
     -backend-config=/REPLACE_PRIVATE_DIRECTORY/local.tfbackend
   ```

5. Confirm initialized backend type/path/workspace privately, without dumping
   metadata or credentials into logs. A different backend prompt is a stop signal;
   do not accept migration or `-reconfigure` reflexively. Confirm a real provider
   lockfile has been generated/reviewed before any live plan.

## Backup

Quiesce Terraform; never copy state while a run is writing it. Back up after each
state-changing operation, including failures which wrote state, and before any
recovery action. Version backups rather than overwriting the sole good copy.

Capture the canonical state and its backup if present, the repository revision
plus reviewed uncommitted implementation if any, dependency lockfile, tool
versions, template provenance and private backend/input/inventory information.
Credentials/SSH keys require their own approved recovery or reissuance policy;
do not casually bundle tokens with state. Plans and `.terraform`/`TF_DATA_DIR`
metadata can be sensitive; protect them too, but reinitialize metadata during
recovery rather than blindly reusing it. Do not publish plan JSON or output JSON.

Encrypt before sending to the agreed off-VM destination, restrict access, verify
integrity and record time, state lineage/serial and root identity privately. The
destination and encryption utility remain unresolved; no fake backup command is
provided as if a working backup already exists.

Before first apply, rehearse encryption/decryption on a harmless fixture from a
second trusted machine, verify bytes/permissions and recovery-key access. After
first apply, prove actual state backup round-trip into an **isolated, non-running
recovery directory**; do not plan/apply from that copy. Check the recovered JSON
and lineage/serial against the saved record without logging its contents.

## Recovery

1. Stop all runs. Preserve current state, metadata and failed-run evidence before
   overwriting anything. Confirm no other operator or process is active.
2. Recover/rebuild the runner and trusted tools, code revision, approved private
   inputs and keys, or explicitly reissue credentials. Restore only the latest
   verified state into the agreed canonical path with restrictive permissions.
3. Check root identity, lineage, serial, backup age and the last known operation.
   If live infrastructure changed after that snapshot, **stop**: restoring old
   state does not undo the changes. Plan a separately reviewed reconciliation.
4. Reinitialize against the explicit backend paths; do not create a second active
   state or change lineage/serial manually. Never delete state to fix an error.
5. Obtain live-access approval before comparing state with Proxmox or running a
   refresh/plan. Investigate discrepancies and partial creations; any import,
   state surgery, orphan deletion or replacement requires a concrete reviewed
   recovery scope and applicable approval.
6. Resume only when state and actual guest ownership are understood. Back up the
   reconciled state. Moving to a remote backend later is a separate migration,
   including locking, backup and recovery verification.
