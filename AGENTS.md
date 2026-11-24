# Dotfiles

Working map for agents changing this repository. These instructions govern the
repo; they are not configuration to install into the user's home directory.

## Documentation

**Document why, not what.** Before writing comments, Markdown, commit messages,
or pull-request descriptions, load the shared `documentation` skill (`core:documentation` in Claude Code)
or read [its standard](https://git.lopah.eu/lopah/agent-skills/src/branch/main/plugins/core/skills/documentation/SKILL.md),
with this repository's [documentation profile](./docs/agents/documentation.md).

## Issues and pull requests

This repository uses Forgejo at <https://git.lopah.eu/lopah/dotfiles>.
For issue requirements, pull-request reviews, or tracker updates, load the
shared `forgejo` skill (`core:forgejo` in Claude Code) or follow
[its workflow](https://git.lopah.eu/lopah/agent-skills/src/branch/main/plugins/core/skills/forgejo/SKILL.md). Retrieve the description,
linked requirements, comments, and inline review discussions before implementing
or reviewing tracker work.

## Installation boundaries

- `install.conf.yaml` owns the Dotbot link targets and tasks shared by every
  system. `install` (Bash) also runs `install.unix.conf.yaml` for macOS and
  Linux, and `install.ps1` (PowerShell) runs `install.windows.conf.yaml`.
  On Windows Dotbot runs commands and `if` tests through cmd.exe, so keep POSIX
  shell syntax out of the shared and Windows files.
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
- `dotbot` is an upstream submodule. Change its pinned revision only when
  requested; avoid editing its contents as part of an unrelated configuration
  change.
- Neovim plugins are managed by lazy.nvim and pinned in
  `nvim/.config/nvim/lazy-lock.json`. Update the lockfile only when requested.
  `nvim/.vimrc` is a plugin-free fallback for plain Vim that mirrors
  `init.lua`; change both together.

## Validation

Use the .NET SDK selected by `global.json`; `.config/mise.toml` also pins it.
The integration suite is in `tests/`. See
[the README](./README.md#integration-tests) for setup and Podman socket settings.

- For shell changes, run syntax checks with the matching interpreter:
  `bash -n install`, `bash -n .bash_profile`,
  `bash -n bashrc/.bash_profile`, `bash -n zsh/01-global-aliases.sh`, or
  `zsh -n zsh/.zshrc`, as applicable. Syntax checking avoids executing startup
  actions such as starting an SSH agent.
- For Neovim configuration changes, start Neovim headless with
  `XDG_CONFIG_HOME=$PWD/nvim/.config` and `XDG_DATA_HOME`, `XDG_STATE_HOME`,
  and `XDG_CACHE_HOME` pointing to a scratch directory, so the check neither
  uses nor changes the host's plugins. Open files of the affected types and
  confirm `:messages` stays empty.
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
