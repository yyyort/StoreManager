using backend.DTOs;
using System.Net;
using System.Text.Json;

namespace backend.Middleware
{
    public class GlobalExceptionMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<GlobalExceptionMiddleware> _logger;

        public GlobalExceptionMiddleware(RequestDelegate next, ILogger<GlobalExceptionMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "An unhandled exception occurred");
                await HandleExceptionAsync(context, ex);
            }
        }

        private static async Task HandleExceptionAsync(HttpContext context, Exception exception)
        {
            context.Response.ContentType = "application/json";
            
            var response = new ApiResponse<object>();

            switch (exception)
            {
                case InvalidOperationException ex:
                    response = ApiResponse<object>.ErrorResponse(ex.Message);
                    context.Response.StatusCode = (int)HttpStatusCode.BadRequest;
                    break;
                
                case ArgumentException ex:
                    response = ApiResponse<object>.ErrorResponse(ex.Message);
                    context.Response.StatusCode = (int)HttpStatusCode.BadRequest;
                    break;
                
                case UnauthorizedAccessException:
                    response = ApiResponse<object>.ErrorResponse("Unauthorized access");
                    context.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
                    break;
                
                default:
                    response = ApiResponse<object>.ErrorResponse("An internal server error occurred");
                    context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                    break;
            }

            var jsonResponse = JsonSerializer.Serialize(response, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            });

            await context.Response.WriteAsync(jsonResponse);
        }
    }
}