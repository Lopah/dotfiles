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

Install the SDK pinned in [global.json](./global.json), or use
[mise](./.config/mise.toml). The tests target .NET 11 with its default C# 15
language version and use xUnit v3 with Microsoft.Testing.Platform.

Start Docker with its CLI available, then run from the repository root.
The installer runs only inside the disposable test container, not on the host.

```bash
git submodule update --init --recursive
docker build --progress=plain --tag dotfiles-integration-tests:local \
  --file tests/DotFiles.IntegrationTests/Dockerfile .
dotnet build tests -c Release
dotnet test --solution tests/Dotfiles.IntegrationTests.sln -c Release --no-build
```

Rebuild the image after changing installed files or submodules; tests use the
built image without pulling from a registry. Set `DOTFILES_TEST_IMAGE` to use
a different local image tag. Image setup is separate so package-manager failures
appear in the build log rather than as failed test fixtures.

With Podman, replace `docker build --progress=plain` with `podman build`.
On macOS with a rootful Podman machine, configure its Docker API socket before
running the tests:

```bash
export DOCKER_HOST="unix://$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')"
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/run/podman/podman.sock
```

After testing, remove the local image with
`docker image rm dotfiles-integration-tests:local` (or `podman image rm`).

## Forgejo automation

Workflows, issue templates, and code ownership live in `.forgejo/`.
CI uses a runner registered with the `ubuntu-22.04` label,
Node.js 24 or newer for JavaScript actions, and the Docker CLI connected to a
Docker-compatible container engine for the integration tests. The image build
and .NET tests must use the same engine.
