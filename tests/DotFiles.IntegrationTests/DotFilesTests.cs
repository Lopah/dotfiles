using System.Threading;
using System.Threading.Tasks;
using DotNet.Testcontainers.Containers;
using Xunit;

namespace DotFiles.IntegrationTests;

public class DotFilesTests(DotFilesTestBase dotFilesTestBase) : IClassFixture<DotFilesTestBase>
{
    private readonly IContainer _container = dotFilesTestBase.Container;

    [Fact]
    public async Task ZshInstalled()
    {
        var result = await _container.ExecAsync(["which", "zsh"], TestContext.Current.CancellationToken);

        Assert.Equal(0, result.ExitCode);
    }

    [Fact]
    public async Task DownloadsCreated()
    {
        var res = await _container.ExecAsync(
            ["sudo", "test", "-d", "/root/downloads"], TestContext.Current.CancellationToken);

        Assert.Equal(0, res.ExitCode);
    }

    [Fact]
    public async Task VimHistoryCreated()
    {
        var res = await _container.ExecAsync(
            ["sudo", "test", "-d", "/root/.vim/undo-history"], TestContext.Current.CancellationToken);

        Assert.Equal(0, res.ExitCode);
    }

    [Fact]
    public async Task GitConfigIncludesMachineSpecificFile()
    {
        var cancellationToken = TestContext.Current.CancellationToken;

        var write = await ExecInRootHomeAsync(
            ["git", "config", "--file", "/root/.gitconfig.local", "user.signingkey", "TESTKEY"], cancellationToken);
        Assert.Equal(0, write.ExitCode);

        var read = await ExecInRootHomeAsync(
            ["git", "config", "--global", "--includes", "--get", "user.signingkey"], cancellationToken);
        Assert.Equal(0, read.ExitCode);
        Assert.Equal("TESTKEY", read.Stdout.Trim());
    }

    [Fact]
    public async Task InteractiveZshStartsWithoutErrors()
    {
        var res = await ExecInRootHomeAsync(["zsh", "-i", "-c", "true"], TestContext.Current.CancellationToken);

        Assert.Equal(0, res.ExitCode);
        Assert.Equal(string.Empty, res.Stderr);
    }

    [Fact]
    public async Task BashLoginShellStartsWithoutErrors()
    {
        var res = await ExecInRootHomeAsync(["bash", "-l", "-c", "true"], TestContext.Current.CancellationToken);

        Assert.Equal(0, res.ExitCode);
        Assert.Equal(string.Empty, res.Stderr);
    }

    [Theory]
    [InlineData("/root/.gitconfig", "app/dotfiles/.gitconfig")]
    [InlineData("/root/.vimrc", "app/dotfiles/nvim/.vimrc")]
    [InlineData("/root/.vim/bundle", "app/dotfiles/nvim/.vim/bundle")]
    [InlineData("/root/.vim/colors", "app/dotfiles/nvim/.vim/colors")]
    [InlineData("/root/.config/neofetch/config.conf", "app/dotfiles/neofetch/.config/config.conf")]
    [InlineData("/root/.config/git/prune-merged", "app/dotfiles/git/prune-merged")]
    [InlineData("/root/.bash_profile", "app/dotfiles/.bash_profile")]
    [InlineData("/root/.bashrc", "app/dotfiles/bashrc/.bash_profile")]
    [InlineData("/root/.zshrc", "app/dotfiles/zsh/.zshrc")]
    [InlineData("/etc/profile.d/01-global-aliases.sh", "app/dotfiles/zsh/01-global-aliases.sh")]
    public async Task DotFilesCreated(string path, string linkedTo)
    {
        var res = await _container.ExecAsync(["sudo", "readlink", path], TestContext.Current.CancellationToken);

        Assert.Equal(0, res.ExitCode);
        Assert.Contains(linkedTo, res.Stdout, System.StringComparison.OrdinalIgnoreCase);
    }

    // The fixture runs the installer with sudo, so the links live in root's home.
    private Task<ExecResult> ExecInRootHomeAsync(string[] command, CancellationToken cancellationToken) =>
        _container.ExecAsync(["sudo", "env", "HOME=/root", .. command], cancellationToken);
}
