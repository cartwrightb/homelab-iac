# Operational runbooks

The first milestone introduces these prepared, **untested** procedures:

- [Fedora controller and template bootstrap](fedora-bootstrap.md)
- [Private local state backup/recovery](local-state.md)
- [Disposable guest lifecycle](disposable-vm.md)

Their presence does not authorize execution. Installation, credential use and
live operations still require the applicable explicit approval.

Each runbook should explain:

- Purpose, scope, prerequisites and required authorization.
- How to identify the intended target without publishing sensitive values.
- Expected effects and the steps to perform.
- How to verify success and recognize failure.
- Recovery or rollback options and their limitations.
- Validation status and known uncertainties.

Separate local static checks from commands that contact or modify live
systems. Do not execute a runbook merely because its commands are documented;
obtain the required authorization first.
