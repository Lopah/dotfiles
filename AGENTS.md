# Dotfiles

Working map for agents changing this repository. These instructions govern the
repo; they are not configuration to install into the user's home directory.

## Documentation

**Document why, not what.** Before writing comments, Markdown, commit messages,
or pull-request descriptions, load the repo-local `documentation` skill or read
[its standard](./.agents/skills/documentation/SKILL.md).

## Issues and pull requests

This repository uses Forgejo at <https://git.lopah.eu/lopah/dotfiles>.
For issue requirements, pull-request reviews, or tracker updates, load the
repo-local `forgejo` skill or follow
[its workflow](./.agents/skills/forgejo/SKILL.md). Retrieve the description,
linked requirements, comments, and inline review discussions before implementing
or reviewing tracker work.

## Installation boundaries

- `install.conf.yaml` owns Dotbot's link targets and installation tasks.
  `install` and `install.ps1` are the Bash and PowerShell entry points.
- Test installation in containers. Running either installer on the host can
  replace home-directory configuration, write to `/etc/profile.d`, download
  fonts, and initialize submodules. Ask before applying an installation to the
  user's machine.
- Changes to link targets, overwrite policy, or system-wide shell configuration
  affect existing installations. Preserve the explicit protection on
  `~/.gitconfig` unless the user requests a policy change.
- Check the target shell and operating system before changing startup files or
  aliases. A syntax check on macOS does not establish Linux or Windows behavior.
- `zsh/.zshrc` serves macOS, Linux, and Windows. Keep settings that need GNU
  tools, a Linux ssh-agent, or the Powerline fonts inside its non-macOS blocks.
- `.gitconfig` is shared by every machine. Machine-specific values, such as the
  signing key, gpg path, credential helpers, or an editor not installed
  everywhere, belong in the untracked `~/.gitconfig.local` that it includes.
- `dotbot` and the plugins listed in `.gitmodules` are upstream submodules.
  Change their pinned revisions only when requested; avoid editing their
  contents as part of an unrelated configuration change.

## Validation

Use the .NET SDK selected by `global.json`; `.config/mise.toml` also pins it.
The integration suite is in `tests/`. See
[the README](./README.md#integration-tests) for setup and Podman socket settings.

- For shell changes, run syntax checks with the matching interpreter:
  `bash -n install`, `bash -n .bash_profile`,
  `bash -n bashrc/.bash_profile`, `bash -n zsh/01-global-aliases.sh`, or
  `zsh -n zsh/.zshrc`, as applicable. Syntax checking avoids executing startup
  actions such as starting an SSH agent.
- For installer, link-map, or integration-test changes, run
  the image build in [the README](./README.md#integration-tests),
  `dotnet build tests -c Release`, then
  `dotnet test --solution tests/Dotfiles.IntegrationTests.sln -c Release --no-build`
  from the repository root.
  Initialize submodules first with `git submodule update --init --recursive`.
- Integration tests need a prebuilt test image, a Docker-compatible engine, and
  network access. They install the dotfiles inside an Ubuntu container. This
  exercises the Linux Bash installation, not the PowerShell entry point or every
  host OS.
- When adding or changing an installed path, update the link assertions in
  `tests/DotFiles.IntegrationTests/DotFilesTests.cs`. Keep container setup in
  `DotFilesTestBase.cs` and the test Dockerfile.
- Report the checks actually run and any environmental blockers. Documentation
  changes need link and instruction checks, not a container installation.

## Agent skills

Keep repo-local skills in `.agents/skills/`. `.claude/skills` points to that
directory so both tools use one copy. Add only workflows relevant to this repo;
keep the Forgejo login and repository selection explicit.
