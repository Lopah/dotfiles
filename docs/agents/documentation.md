# Documentation profile

For agents applying the shared
[`documentation` skill](https://git.lopah.eu/lopah/agent-skills/src/branch/main/plugins/core/skills/documentation/SKILL.md)
in this dotfiles repository. Where this page and the shared skill disagree,
follow this page.

## Where knowledge lives

| Knowledge | Location |
| --- | --- |
| Installation prerequisites and operational steps | `README.md` |
| A constraint on a script or configuration key | Comment beside it |
| Agent rules | `AGENTS.md` |
| Upstream plugin or submodule documentation | Upstream; do not copy it here |

## Commits and releases

Scopes: `shell`, `vim`, `git`, `zsh`, `install`, `tests`, `forgejo`,
`agents`, `deps`.

Examples:

- `fix(install): preserve existing git configuration`
- `docs(agents): add authenticated Forgejo workflow`

In the body, call out overwritten files, system-wide changes, new
dependencies, and platform limitations. Include issue references only when
known.

## Pull requests

Use `## Validation` instead of `## Testing`, and name the rollout section
`## Before installing`: required prerequisites or migration steps.

## Domain checks

- Distinguish Linux, macOS, and Windows behavior. Document tested support;
  an entry-point script is not evidence that a platform works.
- Distinguish host installation from container validation, and identify
  elevated operations.
- A successful build does not show that the installer or shell startup
  works; report what was actually run.
