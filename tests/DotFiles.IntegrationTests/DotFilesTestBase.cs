using System;
using System.IO;
using System.Threading.Tasks;
using DotNet.Testcontainers.Builders;
using DotNet.Testcontainers.Containers;
using FluentAssertions;
using Xunit;

namespace DotFiles.IntegrationTests;

public class DotFilesTestBase : IAsyncLifetime
{
    public readonly IContainer Container;

    public DotFilesTestBase()
    {
        var dockerImage = new ImageFromDockerfileBuilder()
            .WithDockerfile("tests/DotFiles.IntegrationTests/Dockerfile")
            .WithName("dotfiles")
            .WithDockerfileDirectory(
                Path.GetFullPath(
                    Path.Combine(
                        AppDomain.CurrentDomain.BaseDirectory,
                        $"..{Path.DirectorySeparatorChar}..{Path.DirectorySeparatorChar}..{Path.DirectorySeparatorChar}..{Path.DirectorySeparatorChar}..{Path.DirectorySeparatorChar}")))
            .Build();

        dockerImage.CreateAsync().GetAwaiter().GetResult();

        Container = new ContainerBuilder()
            .WithImage(dockerImage)
            .WithCleanUp(true)
            .Build();
    }

    public async Task InitializeAsync()
    {
        await Container.StartAsync();

        var download = await Container.ExecAsync(
            new[]
            {
                "sudo", "wget", "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
            });
        
        download.ExitCode.Should().Be(0);
        
        await Container.ExecAsync(new [] {"sudo", "chmod", "+x", "install.sh"});

        var install = await Container.ExecAsync(new [] {"sudo", "sh", "install.sh", "--unattended"});
        
        install.ExitCode.Should().Be(0);
        
        var installDotfiles = await Container.ExecAsync(new[] { "sudo", "sh", "install" });
        
        installDotfiles.ExitCode.Should().Be(0);
    }

    public async Task DisposeAsync()
    {
        await Container.StopAsync();
    }
}
