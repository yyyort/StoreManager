using Scalar.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference();
}


// check for environment variables
var env = app.Environment;
Console.WriteLine($"Environment: {env.EnvironmentName}");


app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
