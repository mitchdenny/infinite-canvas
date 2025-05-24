using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Logging;
using OpenTelemetry.Logs;
using OpenTelemetry.Metrics;
using OpenTelemetry.Trace;

namespace InfiniteCanvas.ServiceDefaults;

public static class Extensions
{
    public static IServiceCollection AddServiceDefaults(this IServiceCollection services)
    {
        services.AddHealthChecks()
            .AddCheck("self", () => HealthCheckResult.Healthy());

        services.AddMetrics()
            .AddTracing()
            .AddLogging();

        return services;
    }

    public static IApplicationBuilder UseServiceDefaults(this IApplicationBuilder app)
    {
        app.UseExceptionHandler();

        app.UseHealthChecks("/health", new HealthCheckOptions
        {
            AllowCachingResponses = false
        });

        return app;
    }

    private static IServiceCollection AddMetrics(this IServiceCollection services)
    {
        services.AddOpenTelemetry()
            .WithMetrics(metrics =>
            {
                metrics.AddRuntimeInstrumentation()
                       .AddAspNetCoreInstrumentation()
                       .AddHttpClientInstrumentation()
                       .AddProcessInstrumentation();
            });

        return services;
    }

    private static IServiceCollection AddTracing(this IServiceCollection services)
    {
        services.AddOpenTelemetry()
            .WithTracing(tracing =>
            {
                tracing.AddAspNetCoreInstrumentation()
                       .AddHttpClientInstrumentation();
            });

        return services;
    }

    private static IServiceCollection AddLogging(this IServiceCollection services)
    {
        services.AddLogging(logging =>
        {
            logging.AddOpenTelemetry(options =>
            {
                options.IncludeFormattedMessage = true;
                options.IncludeScopes = true;
            });
        });
        
        return services;
    }
}