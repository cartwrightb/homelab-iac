terraform {
  backend "local" {
    # Intentionally unusable defaults. Override BOTH with private absolute paths.
    path          = "/REPLACE_WITH_PRIVATE_STATE_DIRECTORY/disposable.tfstate"
    workspace_dir = "/REPLACE_WITH_PRIVATE_STATE_DIRECTORY/workspaces"
  }
}
