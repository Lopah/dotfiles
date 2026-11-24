# Commits and pull requests

For commit messages, PR titles, and descriptions in this repository.

## Subject

Use `<type>(<scope>): <summary>`, with an optional scope. Choose a Conventional
Commits type such as `feat`, `fix`, `docs`, `test`, `build`, `ci`, `refactor`, or
`chore`. Use an imperative summary without a final period.

Choose a scope that identifies the affected area, such as `shell`, `vim`,
`install`, `tests`, `forgejo`, `agents`, or `deps`.

Examples:

```text
fix(install): preserve existing git configuration
docs(agents): add authenticated Forgejo workflow
```

Explain why the change is needed and what users will notice in the body.
Highlight overwritten files, system-wide changes, new dependencies, and
platform limitations when relevant. Include issue references only when known.

## PR description

Use this outline, omitting sections that do not apply:

```markdown
## Why

The problem or requirement.

## What changes

Behavior and installation consequences.

## Validation

Checks run, results, and any untested platforms or blockers.

## Before installing

Required prerequisites or migration steps.
```

Use the shared [Forgejo skill](https://git.lopah.eu/lopah/agent-skills/src/branch/main/plugins/core/skills/forgejo/SKILL.md) for publishing tracker updates.
Report actual validation results; a successful build alone does not establish
that the installer or shell startup behavior works.
