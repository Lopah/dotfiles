using System.Threading.Tasks;
using DotNet.Testcontainers.Containers;
using FluentAssertions;
using Xunit;

namespace DotFiles.IntegrationTests;

public class DotFilesTests : IClassFixture<DotFilesTestBase>
{
    private readonly IContainer _container;

    public DotFilesTests(DotFilesTestBase dotFilesTestBase)
    {
        _container = dotFilesTestBase.Container;
    }

    [Fact]
    public async Task ZshInstalled()
    {
        var result = await _container.ExecAsync(new[] { "which", "zsh" });

        result.ExitCode.Should().Be(0);
    }

    [Fact]
    public async Task DownloadsCreated()
    {
        var res = await _container.ExecAsync(new[] { "sudo", "test", "/root/downloads" });

        res.ExitCode.Should().Be(0);
    }

    [Fact]
    public async Task VimHistoryCreated()
    {
        var res = await _container.ExecAsync(new[] { "sudo", "test", "/root/.vim/undo-history" });
        
        res.ExitCode.Should().Be(0);
    }
    
    
    [Theory]
    [InlineData("/root/.gitconfig", "app/dotfiles/.gitconfig")]
    [InlineData("/root/.vimrc", "app/dotfiles/nvim/.vimrc")]
    [InlineData("/root/.vim/bundle", "app/dotfiles/nvim/.vim/bundle")]
    [InlineData("/root/.vim/colors", "app/dotfiles/nvim/.vim/colors")]
    [InlineData("/root/.config/neofetch/config.conf", "app/dotfiles/neofetch/.config/config.conf")]
    [InlineData("/root/.bash_profile", "app/dotfiles/.bash_profile")]
    [InlineData("/root/.bashrc", "app/dotfiles/bashrc")]
    [InlineData("/root/.zshrc", "app/dotfiles/zsh/.zshrc")]
    [InlineData("/etc/profile.d/01-global-aliases.sh", "app/dotfiles/zsh/01-global-aliases.sh")]
    public async Task DotFilesCreated(string path, string linkedTo)
    {
        var res = await _container.ExecAsync(new[] { "sudo", "readlink", path });

        res.Stdout.Should().ContainEquivalentOf(linkedTo);
        
        res.ExitCode.Should().Be(0);
    }
    
    
}
