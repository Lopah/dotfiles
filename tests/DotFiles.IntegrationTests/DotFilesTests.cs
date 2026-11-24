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

    [Theory]
    [InlineData("/root/.gitconfig", "app/dotfiles/.gitconfig")]
    [InlineData("/root/.vimrc", "app/dotfiles/nvim/.vimrc")]
    [InlineData("/root/.vim/bundle", "app/dotfiles/nvim/.vim/bundle")]
    [InlineData("/root/.vim/colors", "app/dotfiles/nvim/.vim/colors")]
    [InlineData("/root/.config/neofetch/config.conf", "app/dotfiles/neofetch/.config/config.conf")]
    [InlineData("/root/.config/git/prune-merged", "app/dotfiles/git/prune-merged")]
    [InlineData("/root/.bash_profile", "app/dotfiles/.bash_profile")]
    [InlineData("/root/.bashrc", "app/dotfiles/bashrc")]
    [InlineData("/root/.zshrc", "app/dotfiles/zsh/.zshrc")]
    [InlineData("/etc/profile.d/01-global-aliases.sh", "app/dotfiles/zsh/01-global-aliases.sh")]
    public async Task DotFilesCreated(string path, string linkedTo)
    {
        var res = await _container.ExecAsync(["sudo", "readlink", path], TestContext.Current.CancellationToken);

        Assert.Equal(0, res.ExitCode);
        Assert.Contains(linkedTo, res.Stdout, System.StringComparison.OrdinalIgnoreCase);
    }
}
