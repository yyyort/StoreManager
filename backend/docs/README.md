# StoreManager API Documentation

Welcome to the StoreManager API documentation. This folder contains comprehensive guides for developers working on this project.

## 📚 Documentation Index

### Getting Started
- **[SETUP.md](SETUP.md)** - Initial project setup and configuration instructions
- **[USER_SECRETS.md](USER_SECRETS.md)** - Managing sensitive configuration with .NET User Secrets

### Database
- **[SCHEMA_IMPLEMENTATION.md](SCHEMA_IMPLEMENTATION.md)** - Database schema, models, and Entity Framework migrations

### Authentication & Security
- **[AUTH.md](AUTH.md)** - Complete authentication guide with JWT
  - API endpoints documentation
  - Security best practices
  - Code examples for frontend integration
  - Testing instructions

- **[AUTHENTICATION_FLOW.md](AUTHENTICATION_FLOW.md)** - Visual authentication flow diagrams
  - Registration flow
  - Login flow
  - Protected endpoint access
  - JWT token structure
  - Security layers

- **[AUTHENTICATION_SUMMARY.md](AUTHENTICATION_SUMMARY.md)** - Implementation summary
  - Completed tasks checklist
  - Configuration details
  - Testing guide
  - Next steps recommendations

## 🚀 Quick Start

### 1. First Time Setup

```bash
# Navigate to backend directory
cd backend

# Set up User Secrets for JWT
dotnet user-secrets init
dotnet user-secrets set "Jwt:Key" "$(openssl rand -base64 64)"
dotnet user-secrets set "Jwt:Issuer" "StoreManagerAPI"
dotnet user-secrets set "Jwt:Audience" "StoreManagerClient"
dotnet user-secrets set "Jwt:ExpirationDays" "7"

# Restore packages and build
dotnet restore
dotnet build

# Run migrations
dotnet ef database update

# Run the application
dotnet run
```

### 2. Verify Setup

```bash
# List your user secrets
dotnet user-secrets list

# Check if the app is running
curl http://localhost:5007/swagger
```

## 🔐 Security Configuration

### Development
- JWT keys and sensitive data are stored in **.NET User Secrets**
- See [USER_SECRETS.md](USER_SECRETS.md) for details

### Production
- Use environment variables or Azure Key Vault
- See [.env.example](../.env.example) for required variables

## 📖 Key Features

### Authentication
- ✅ JWT Bearer token authentication
- ✅ User registration and login
- ✅ Password hashing with BCrypt
- ✅ Token-based authorization
- ✅ Swagger UI with authentication support

### Database
- ✅ Entity Framework Core with SQL Server
- ✅ Code-First approach with migrations
- ✅ GUID-based primary keys
- ✅ Comprehensive store management schema

## 🛠️ Development Workflow

### Running the Application

```bash
# Development mode
cd backend
dotnet run

# With hot reload
dotnet watch run

# Specific profile (https)
dotnet run --launch-profile https
```

### Database Migrations

```bash
# Add a new migration
dotnet ef migrations add MigrationName

# Update database to latest migration
dotnet ef database update

# Rollback to a specific migration
dotnet ef database update PreviousMigrationName

# Remove last migration (if not applied)
dotnet ef migrations remove
```

### Testing API Endpoints

1. **Using Swagger UI**
   - Navigate to `http://localhost:5007/swagger`
   - Register a new user
   - Copy the JWT token
   - Click "Authorize" and enter: `Bearer <token>`
   - Test endpoints

2. **Using auth.http file**
   - Open `backend/auth.http` in VS Code
   - Install REST Client extension
   - Click "Send Request" on any endpoint

3. **Using curl**
   ```bash
   # Register
   curl -X POST http://localhost:5007/api/auth/register \
     -H "Content-Type: application/json" \
     -d '{"name":"Test User","email":"test@example.com","password":"password123"}'
   
   # Login
   curl -X POST http://localhost:5007/api/auth/login \
     -H "Content-Type: application/json" \
     -d '{"email":"test@example.com","password":"password123"}'
   ```

## 📁 Project Structure

```
backend/
├── Controllers/          # API endpoints
├── Data/                # DbContext and data access
├── DTOs/                # Data Transfer Objects
├── Mappings/            # AutoMapper profiles
├── Middleware/          # Custom middleware
├── Migrations/          # EF Core migrations
├── Models/              # Entity models
├── Properties/          # Launch settings
├── Services/            # Business logic
│   └── Interfaces/      # Service interfaces
├── Validators/          # FluentValidation validators
├── docs/                # Documentation (you are here)
├── reference/           # SQL schema references
├── appsettings.json     # App configuration
├── Program.cs           # Application entry point
└── backend.csproj       # Project file
```

## 🔗 API Endpoints

### Public Endpoints
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login and get JWT token

### Protected Endpoints (Require JWT)
- `GET /api/auth/me` - Get current user
- `GET /api/users` - Get all users
- `GET /api/users/{id}` - Get user by ID
- `GET /api/users/by-email/{email}` - Get user by email

## 🐛 Troubleshooting

### JWT Authentication Issues
1. Verify User Secrets are set: `dotnet user-secrets list`
2. Check the token is being sent in Authorization header
3. Ensure token hasn't expired (default: 7 days)

### Database Connection Issues
1. Verify connection string in User Secrets or appsettings
2. Ensure SQL Server is running
3. Check database exists: `dotnet ef database update`

### Build Errors
1. Clean and rebuild: `dotnet clean && dotnet build`
2. Restore packages: `dotnet restore`
3. Check for migration conflicts

## 📞 Additional Resources

- [ASP.NET Core Documentation](https://learn.microsoft.com/en-us/aspnet/core/)
- [Entity Framework Core Documentation](https://learn.microsoft.com/en-us/ef/core/)
- [JWT.io - JWT Debugger](https://jwt.io/)
- [REST Client VS Code Extension](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)

## 🎯 Next Steps

After setting up, consider implementing:

1. **Role-Based Authorization** - Add user roles (Admin, Manager, User)
2. **Refresh Tokens** - Implement token refresh mechanism
3. **Password Reset** - Add forgot password functionality
4. **Email Verification** - Verify user emails on registration
5. **Rate Limiting** - Protect against brute force attacks
6. **Audit Logging** - Track user activities
7. **API Versioning** - Implement versioned endpoints
8. **Pagination** - Add pagination to list endpoints

## 📝 Contributing

When adding new features:
1. Create appropriate DTOs and validators
2. Update AutoMapper mappings
3. Add service layer logic
4. Create controller endpoints
5. Update documentation
6. Test with Swagger or REST Client

---

**Last Updated:** October 15, 2025

For questions or issues, please refer to the specific documentation files above.
