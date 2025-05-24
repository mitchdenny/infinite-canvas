var builder = DistributedApplication.CreateBuilder(args);

var api = builder.AddProject<Projects.InfiniteCanvas_Api>("api");

builder.Build().Run();
