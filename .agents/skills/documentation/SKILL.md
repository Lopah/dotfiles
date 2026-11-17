---
name: documentation
description:
  Use when writing or reviewing shell, PowerShell, C#, or configuration comments,
  Markdown docs, agent instructions, commit messages, or pull-request
  descriptions in this dotfiles repository.
---

# Documentation standard

For agents and contributors documenting this repository's installation,
configuration, tests, and changes.

## Document why, not what

Record reasons, constraints, external quirks, and consequences that a reader
cannot infer from the code. Prefer a clearer name or a smaller function when
the code itself is hard to follow.

- Put a local constraint beside the affected code or configuration key.
- Put installation prerequisites and operational steps in `README.md`.
- Put agent rules in `AGENTS.md` and multi-step agent workflows in
  `.agents/skills/<name>/SKILL.md`.
- Put the reason for a change and its risks in the commit or PR description.
- Link follow-up work to a Forgejo issue rather than leaving an untracked TODO.

Keep each explanation in one authoritative place and link to it. Read the
reference for the work being changed:

| Work | Reference |
| --- | --- |
| Shell, PowerShell, configuration, C# tests | [Code and configuration](./references/code-and-configuration.md) |
| READMEs, agent instructions, skills | [Markdown](./references/markdown.md) |
| Commits and PRs | [Commits and pull requests](./references/commits.md) |

Before finishing, check that documentation reflects the changed behavior,
commands state their prerequisites and side effects, and no text assumes
coverage on an operating system or entry point that was not tested.
