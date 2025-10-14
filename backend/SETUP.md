# Environment Setup Instructions

## Database Configuration

Before running the application, you need to set up your database connection strings.

### 1. Copy Template Files

Copy the template configuration files and rename them:

```bash
# For development
cp appsettings.Development.json.template appsettings.Development.json

# For production (optional)
cp appsettings.json.template appsettings.json
```

### 2. Configure Connection Strings

#### Development (LocalDB)
Edit `appsettings.Development.json` and ensure the LocalDB connection string is correct:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=StoreManager;Trusted_Connection=true;MultipleActiveResultSets=true"
  }
}
```

#### Production (Azure SQL Database)
Edit `appsettings.json` and update with your Azure SQL Database details:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=tcp:your-server.database.windows.net,1433;Initial Catalog=StoreManager;Persist Security Info=False;User ID=your-username;Password=your-password;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}
```

### 3. Apply Database Migrations

After setting up the connection string, apply the migrations:

```bash
dotnet ef database update
```

### 4. Run the Application

```bash
dotnet run
```

## Security Notes

- ⚠️ **Never commit `appsettings.json` or `appsettings.Development.json` to version control**
- ✅ Only commit the `.template` files
- 🔒 Keep your database credentials secure
- 🌍 Use environment variables or Azure Key Vault for production secrets

## Alternative: User Secrets (Recommended for Development)

For development, you can use ASP.NET Core User Secrets instead:

```bash
# Initialize user secrets
dotnet user-secrets init

# Set the connection string
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Server=(localdb)\\mssqllocaldb;Database=StoreManager;Trusted_Connection=true;MultipleActiveResultSets=true"
```

This way, sensitive data never touches your repository!