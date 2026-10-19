# Architecture decision records

Use a short ADR for a consequential choice whose reasoning should remain
understandable later, such as state storage or Kubernetes bootstrap ownership.
Routine edits do not need one.

- [0001: Bootstrap controller and disposable ownership](0001-disposable-vm-workflow.md) — accepted boundaries
- [0002: Proxmox provider and credential boundary](0002-proxmox-provider.md) — provisional pin, compatibility unverified
- [0003: Single-runner private local state](0003-private-local-state.md) — accepted boundary, recovery still untested

Name records `NNNN-short-title.md` in increasing order. Keep sensitive values
out of them and link to a superseding record when a decision changes.

## Template

```markdown
# NNNN: Decision title

Date: YYYY-MM-DD
Status: proposed | accepted | superseded

## Context

What problem, constraints and evidence drive this decision?

## Alternatives

What realistic options were considered, and what are their trade-offs?

## Decision

What was chosen, why, and what is its scope?

## Consequences and validation

What benefits, costs, risks and uncertainties remain?
What has been tested, and what still needs validation?
```
