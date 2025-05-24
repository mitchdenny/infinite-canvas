# Infinite Canvas - .NET Aspire Project

This is a .NET Aspire-based project that demonstrates a distributed application architecture using the latest .NET technologies. The project is set up to work with Dev Containers in both Visual Studio Code and GitHub Codespaces.

## Project Structure

- **InfiniteCanvas.AppHost**: The orchestrator project that manages the application components
- **InfiniteCanvas.ServiceDefaults**: Shared service configurations and defaults
- **InfiniteCanvas.ApiService**: A sample API service that provides weather forecasts
- **InfiniteCanvas.Web**: A web frontend that consumes the API service

## Getting Started

### Prerequisites

- .NET 8.0 SDK or higher
- Docker (for containerized development)

### Running the Application

To run the application locally:

```bash
cd InfiniteCanvas.AppHost
dotnet run
```

This will start the Aspire dashboard and launch all the services.

## Development with Dev Containers

This project supports development using Dev Containers in both Visual Studio Code and GitHub Codespaces.

- [.NET Aspire and GitHub Codespaces](https://learn.microsoft.com/dotnet/aspire/get-started/github-codespaces)
- [.NET Aspire and Visual Studio Code Dev Containers](https://learn.microsoft.com/dotnet/aspire/get-started/dev-containers)

## Code of Conduct

This project has adopted the code of conduct defined by the Contributor Covenant
to clarify expected behavior in our community.

For more information, see the [.NET Foundation Code of Conduct](https://dotnetfoundation.org/code-of-conduct).
