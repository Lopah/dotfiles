$ErrorActionPreference = "Stop"

# dotbot reads one configuration per run: the shared one, then the Windows one.
$CONFIGS = @("install.conf.yaml", "install.windows.conf.yaml")
$DOTBOT_DIR = "dotbot"

$DOTBOT_BIN = "bin/dotbot"
$BASEDIR = $PSScriptRoot

Set-Location $BASEDIR
git -C $DOTBOT_DIR submodule sync --quiet --recursive
git submodule update --init --recursive $DOTBOT_DIR

foreach ($PYTHON in ('python', 'python3')) {
    # Python redirects to Microsoft Store in Windows 10 when not installed
    if (& { $ErrorActionPreference = "SilentlyContinue"
            ![string]::IsNullOrEmpty((&$PYTHON -V))
            $ErrorActionPreference = "Stop" }) {
        # Run every configuration even if one reports a failure, such as a
        # kept ~/.gitconfig, and report it at the end, as a single dotbot run
        # would. $ErrorActionPreference does not react to native exit codes.
        $status = 0
        foreach ($CONFIG in $CONFIGS) {
            &$PYTHON $(Join-Path $BASEDIR -ChildPath $DOTBOT_DIR | Join-Path -ChildPath $DOTBOT_BIN) -d $BASEDIR -c $CONFIG $Args
            if ($LASTEXITCODE -ne 0) { $status = $LASTEXITCODE }
        }
        exit $status
    }
}
Write-Error "Error: Cannot find Python."
