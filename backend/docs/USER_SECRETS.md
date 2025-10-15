# .NET User Secrets Configuration

This document explains how to manage sensitive configuration data using .NET User Secrets for the StoreManager API.

## What are User Secrets?

User Secrets is a development-time feature that stores sensitive configuration data outside of your project tree, preventing accidental commits of secrets to source control. The secrets are stored on your local machine in a JSON file.

## Current Configuration

The following secrets are configured for this project:

### JWT Configuration
- **Jwt:Key** - Secure 512-bit key for signing JWT tokens
- **Jwt:Issuer** - Token issuer (StoreManagerAPI)
- **Jwt:Audience** - Token audience (StoreManagerClient)
- **Jwt:ExpirationDays** - Token expiration period (7 days)

### Database Connection
- **ConnectionStrings:DefaultConnection** - Database connection string

## User Secrets ID

This project has been initialized with the following User Secrets ID:
```
7b86c323-7b20-434c-b8f8-a00ebc0b106e
```

This ID can be found in `backend.csproj`:
```xml
<PropertyGroup>
  <UserSecretsId>7b86c323-7b20-434c-b8f8-a00ebc0b106e</UserSecretsId>
</PropertyGroup>
```

## Managing User Secrets

### List all secrets
```bash
cd backend
dotnet user-secrets list
```

### Set a secret
```bash
dotnet user-secrets set "SecretKey" "SecretValue"
```

### Set JWT configuration
```bash
# Generate a new secure key
openssl rand -base64 64

# Set the JWT key
dotnet user-secrets set "Jwt:Key" "your-generated-key-here"

# Set other JWT settings
dotnet user-secrets set "Jwt:Issuer" "StoreManagerAPI"
dotnet user-secrets set "Jwt:Audience" "StoreManagerClient"
dotnet user-secrets set "Jwt:ExpirationDays" "7"
```

### Remove a secret
```bash
dotnet user-secrets remove "SecretKey"
```

### Clear all secrets
```bash
dotnet user-secrets clear
```

## Secret Storage Location

User Secrets are stored in a JSON file on your local machine:

**Linux/macOS:**
```
~/.microsoft/usersecrets/<user-secrets-id>/secrets.json
```

**Windows:**
```
%APPDATA%\Microsoft\UserSecrets\<user-secrets-id>\secrets.json
```

For this project:
```
~/.microsoft/usersecrets/7b86c323-7b20-434c-b8f8-a00ebc0b106e/secrets.json
```

## Configuration Priority

.NET loads configuration from multiple sources in the following order (later sources override earlier ones):

1. `appsettings.json`
2. `appsettings.{Environment}.json`
3. **User Secrets** (in Development environment only)
4. Environment Variables
5. Command-line arguments

This means User Secrets will override values from `appsettings.json` and `appsettings.Development.json`.

## Setup for New Developers

If you're setting up this project for the first time:

### 1. Initialize User Secrets (if not already done)
```bash
cd backend
dotnet user-secrets init
```

### 2. Generate and set JWT key
```bash
# Generate a secure key
openssl rand -base64 64

# Copy the output and set it as the JWT key
dotnet user-secrets set "Jwt:Key" "paste-generated-key-here"
```

### 3. Set other JWT configuration
```bash
dotnet user-secrets set "Jwt:Issuer" "StoreManagerAPI"
dotnet user-secrets set "Jwt:Audience" "StoreManagerClient"
dotnet user-secrets set "Jwt:ExpirationDays" "7"
```

### 4. Set database connection (if needed)
```bash
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Server=localhost;Database=StoreManager;Trusted_Connection=True;TrustServerCertificate=True;MultipleActiveResultSets=true"
```

### 5. Verify secrets
```bash
dotnet user-secrets list
```

You should see output similar to:
```
Jwt:Key = g0ZjxcSwViV6sNsn3B/KIyAEvxOgHQKGVOa8tSy23+VH9O1A3+7evVJkqw6lF0mXvVNEa1mHR1p/****************
Jwt:Issuer = StoreManagerAPI
Jwt:Audience = StoreManagerClient
Jwt:ExpirationDays = 7
ConnectionStrings:DefaultConnection = Server=localhost;Database=StoreManager;...
```

## Production Configuration

⚠️ **Important:** User Secrets are for **DEVELOPMENT ONLY**. They are not included in production builds.

### For Production, use one of these approaches:

#### 1. Environment Variables
```bash
export Jwt__Key="your-production-key"
export Jwt__Issuer="StoreManagerAPI"
export Jwt__Audience="StoreManagerClient"
export Jwt__ExpirationDays="7"
```

Note: Use double underscores (`__`) instead of colons (`:`) for environment variables.

#### 2. Azure Key Vault
```csharp
// In Program.cs
builder.Configuration.AddAzureKeyVault(
    new Uri($"https://{keyVaultName}.vault.azure.net/"),
    new DefaultAzureCredential());
```

#### 3. Azure App Service Configuration
- Set Application Settings in the Azure Portal
- These automatically become environment variables

#### 4. Docker Secrets
```yaml
# docker-compose.yml
services:
  api:
    secrets:
      - jwt_key
secrets:
  jwt_key:
    file: ./secrets/jwt_key.txt
```

## Security Best Practices

### DO:
✅ Use User Secrets for development
✅ Generate strong, random keys (at least 256 bits for JWT)
✅ Rotate keys periodically
✅ Use different keys for development, staging, and production
✅ Store production secrets in secure vaults (Azure Key Vault, AWS Secrets Manager, etc.)

### DON'T:
❌ Commit secrets to version control
❌ Share secrets via email or messaging apps
❌ Use the same key across environments
❌ Use User Secrets in production
❌ Hard-code secrets in source code

## Generating Secure Keys

### Generate a 256-bit key (32 bytes)
```bash
openssl rand -base64 32
```

### Generate a 512-bit key (64 bytes) - Recommended
```bash
openssl rand -base64 64
```

### Generate a hex key
```bash
openssl rand -hex 32
```

## Troubleshooting

### Secret not being loaded
1. Verify you're in Development environment:
   ```bash
   echo $ASPNETCORE_ENVIRONMENT
   ```
   Should output: `Development`

2. Check the User Secrets ID in your `.csproj` file

3. List secrets to verify they're set:
   ```bash
   dotnet user-secrets list
   ```

### Cannot find secrets.json
The file is created automatically when you set your first secret. If it doesn't exist:
```bash
dotnet user-secrets set "Test" "Value"
dotnet user-secrets remove "Test"
```

### Secrets not overriding appsettings.json
Make sure:
- You're running in Development environment
- The key path matches exactly (case-sensitive)
- User Secrets are loaded after appsettings in configuration

## Example: Accessing Configuration in Code

```csharp
// In a controller or service
public class AuthService
{
    private readonly IConfiguration _configuration;
    
    public AuthService(IConfiguration configuration)
    {
        _configuration = configuration;
    }
    
    public void UseJwtSettings()
    {
        // Gets value from User Secrets in Development
        // or from appsettings.json/environment variables in Production
        var jwtKey = _configuration["Jwt:Key"];
        var issuer = _configuration["Jwt:Issuer"];
        var audience = _configuration["Jwt:Audience"];
        var expirationDays = _configuration["Jwt:ExpirationDays"];
    }
}
```

## References

- [Safe storage of app secrets in development in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/app-secrets)
- [Configuration in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/configuration/)
- [Azure Key Vault configuration provider](https://learn.microsoft.com/en-us/aspnet/core/security/key-vault-configuration)
