using Aspire.Hosting;

var builder = DistributedApplication.CreateBuilder(args);

var apiService = builder.AddProject("apiservice", "../InfiniteCanvas.ApiService/InfiniteCanvas.ApiService.csproj");

builder.AddProject("webapp", "../InfiniteCanvas.Web/InfiniteCanvas.Web.csproj")
    .WithReference(apiService);

builder.Build().Run();