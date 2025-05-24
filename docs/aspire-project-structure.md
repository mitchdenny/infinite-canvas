# .NET Aspire Project Structure Documentation

This document provides detailed information about the .NET Aspire project structure implemented in this repository.

## Overview

The solution is built using .NET Aspire, a cloud-ready stack for building observable, production-ready, distributed applications. The application follows a microservices architecture pattern where services are independently deployable and can be orchestrated using the .NET Aspire AppHost.

## Project Components

### InfiniteCanvas.AppHost

This is the entry point and orchestrator for the entire application. Its main responsibilities include:

- Managing the lifecycle of all services in the application
- Providing a dashboard for monitoring service health and telemetry
- Coordinating service discovery and communication

**Key Files:**
- `AppHost.cs`: Contains the main orchestration logic
- `appsettings.json`: Configuration settings for the orchestrator

### InfiniteCanvas.ServiceDefaults

This project contains shared configuration and service extensions used across all services in the application. It provides:

- Standardized telemetry setup with OpenTelemetry
- Common health check endpoints and configurations
- Service discovery mechanisms
- HTTP client resilience policies

**Key Files:**
- `Extensions.cs`: Contains extension methods that configure services with common defaults

### InfiniteCanvas.Api

This is a sample Web API project that demonstrates how to create a service within the .NET Aspire application. It includes:

- REST API endpoints
- Health check integration
- Telemetry integration via ServiceDefaults

**Key Files:**
- `Program.cs`: The entry point for the API service
- `WeatherForecast.cs`: A sample API model

## Configuration and Deployment

### Development Environment

The repository is configured with Dev Containers, making it easy to start development in a consistent environment using:

- Visual Studio Code with the Dev Containers extension
- GitHub Codespaces

### Running the Application

When you run the application using `dotnet run --project InfiniteCanvas.AppHost`, the AppHost will:

1. Start the Aspire dashboard (typically at http://localhost:15888)
2. Launch the API service 
3. Set up proper routing and service discovery

### Adding New Services

To add new services to the Aspire application:

1. Create a new project in the solution
2. Add a reference to the ServiceDefaults project
3. Add the service to the AppHost using `builder.AddProject<Projects.YourProject>("service-name")`
4. Configure any dependencies or resources needed for the service

## Monitoring and Observability

.NET Aspire provides built-in observability features:

- Health checks at `/health` and `/alive` endpoints
- OpenTelemetry integration for metrics and traces
- Dashboard visualizations for service health and performance

## Additional Resources

- [.NET Aspire Documentation](https://learn.microsoft.com/dotnet/aspire/)
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)