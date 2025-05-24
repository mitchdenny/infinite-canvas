# Infinite Canvas with .NET Aspire

This repository demonstrates how to use .NET Aspire to build modern, distributed applications. The project leverages .NET Aspire's orchestration capabilities to simplify the development of distributed applications.

## Project Structure

The solution contains the following projects:

- **InfiniteCanvas.AppHost**: The orchestrator application that manages the lifecycle of the services.
- **InfiniteCanvas.ServiceDefaults**: Common service configuration including telemetry, health checks, and resilience policies.
- **InfiniteCanvas.Api**: A sample Web API service that provides a REST API endpoint.

## Getting Started

### Prerequisites

- .NET 9.0 SDK
- Aspire CLI (can be installed using `dotnet tool install -g Aspire.Cli --prerelease`)

### Running the Application

1. Clone the repository
2. Navigate to the InfiniteCanvas directory
3. Run the application with:

```bash
cd InfiniteCanvas
dotnet run --project InfiniteCanvas.AppHost
```

This will start the Aspire dashboard and all configured services.

## Development with Dev Containers

This repository is configured for development with Dev Containers in both Visual Studio Code and GitHub Codespaces.

- [.NET Aspire and GitHub Codespaces](https://learn.microsoft.com/dotnet/aspire/get-started/github-codespaces)
- [.NET Aspire and Visual Studio Code Dev Containers](https://learn.microsoft.com/dotnet/aspire/get-started/dev-containers)

> [!NOTE]
> For additional information about .NET Aspire, visit [.NET Aspire documentation](https://learn.microsoft.com/dotnet/aspire/).

# Code of Conduct

This project has adopted the code of conduct defined by the Contributor Covenant
to clarify expected behavior in our community.

For more information, see the [.NET Foundation Code of Conduct](https://dotnetfoundation.org/code-of-conduct).
