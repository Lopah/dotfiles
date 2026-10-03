# Installation

Install via bash (**HAS TO BE RUN AS ADMINISTRATOR**):

- SSH:
  `git clone ssh://git@git.lopah.eu/lopah/dotfiles.git && cd dotfiles && ./install`

- HTTPS:
  `git clone https://git.lopah.eu/lopah/dotfiles.git && cd dotfiles && ./install`

---

Also supports PowerShell:

- SSH:
  `git clone ssh://git@git.lopah.eu/lopah/dotfiles.git && cd .\dotfiles && .\install.ps1`

- HTTPS:
  `git clone https://git.lopah.eu/lopah/dotfiles.git && cd .\dotfiles && .\install.ps1`


## Updating submodules

```bash
git submodule update --remote --merge
```

## Integration tests

The tests target .NET 10. The SDK is pinned to the locally installed version,
10.0.401, in `global.json` and `.config/mise.toml` (for mise users).

Start a Docker-compatible container engine, initialize the submodules, and run:

```bash
git submodule update --init --recursive
dotnet build tests -c Release
dotnet test tests -c Release --no-build
```

On macOS with a rootful Podman machine, configure its Docker API socket first:

```bash
export DOCKER_HOST="unix://$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')"
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/run/podman/podman.sock
```

## Forgejo automation

Workflows, issue templates, and code ownership live in `.forgejo/`.
CI uses a runner registered with the `ubuntu-22.04` label,
Node.js 24 or newer for JavaScript actions, and access to a Docker-compatible
container engine for the integration tests.
