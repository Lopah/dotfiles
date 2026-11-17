using System;
using System.Threading.Tasks;
using DotNet.Testcontainers.Builders;
using DotNet.Testcontainers.Containers;
using DotNet.Testcontainers.Images;
using Xunit;

namespace DotFiles.IntegrationTests;

public class DotFilesTestBase : IAsyncLifetime
{
    public IContainer Container { get; }

    public DotFilesTestBase()
    {
        var image = Environment.GetEnvironmentVariable("DOTFILES_TEST_IMAGE") ?? "dotfiles-integration-tests:local";
        Container = new ContainerBuilder(image)
            .WithImagePullPolicy(PullPolicy.Never)
            .WithCleanUp(true)
            .Build();
    }

    public async ValueTask InitializeAsync()
    {
        var cancellationToken = TestContext.Current.CancellationToken;
        await Container.StartAsync(cancellationToken);

        var download = await Container.ExecAsync(
            [
                "sudo", "wget", "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
            ], cancellationToken);

        Assert.True(download.ExitCode == 0, download.Stderr);

        var install = await Container.ExecAsync(
            ["sudo", "sh", "install.sh", "--unattended"], cancellationToken);

        Assert.True(install.ExitCode == 0, install.Stdout + install.Stderr);

        var installDotfiles = await Container.ExecAsync(
            ["sudo", "bash", "install"], cancellationToken);

        Assert.True(installDotfiles.ExitCode == 0, installDotfiles.Stdout + installDotfiles.Stderr);
    }

    public ValueTask DisposeAsync() => Container.DisposeAsync();
}
