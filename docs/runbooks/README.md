# Operational runbooks

Add runbooks when real operational workflows are introduced. No provisioning,
maintenance or recovery procedure has been implemented or tested yet.

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
