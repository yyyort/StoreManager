# StoreManager Backend API

A standardized ASP.NET Core Web API backend with Entity Framework Core and Azure SQL Database support.

## 🏗️ Architecture

### Folder Structure
```
backend/
├── Controllers/         # API Controllers
├── Models/             # Entity models
├── DTOs/               # Data Transfer Objects
├── Services/           # Business logic services
│   └── Interfaces/     # Service interfaces
├── Data/               # Database context
├── Validators/         # FluentValidation validators
├── Mappings/           # AutoMapper profiles
├── Middleware/         # Custom middleware
└── Migrations/         # EF Core migrations
```

### Technologies Used
- **ASP.NET Core 9.0** - Web API framework
- **Entity Framework Core** - ORM for database operations
- **SQL Server/Azure SQL** - Database
- **AutoMapper** - Object mapping
- **FluentValidation** - Input validation
- **BCrypt.Net** - Password hashing
- **OpenAPI/Swagger** - API documentation

## 🚀 Getting Started

### Prerequisites
- .NET 9.0 SDK
- SQL Server (LocalDB for development)
- Azure SQL Database (for production)

### Database Setup

⚠️ **Important**: Configuration files with connection strings are not included in the repository for security reasons.

1. **Follow the setup instructions**: See [SETUP.md](SETUP.md) for detailed configuration steps
2. **Copy template files** and configure your database connection strings
3. **Apply Migrations**:
   ```bash
   dotnet ef database update
   ```

**Security Note**: Never commit `appsettings.json` or `appsettings.Development.json` files with real connection strings to version control.

### Running the Application

1. **Restore packages**:
   ```bash
   dotnet restore
   ```

2. **Run the application**:
   ```bash
   dotnet run
   ```

3. **Access the API**:
   - Base URL: `http://localhost:5007`
   - Swagger UI: `http://localhost:5007/swagger` (in development)
   - API Documentation: `http://localhost:5007/swagger/v1/swagger.json`

## 📚 API Endpoints

### Users API

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/users` | Create a new user |
| GET | `/api/users` | Get all users |
| GET | `/api/users/{id}` | Get user by ID |
| GET | `/api/users/by-email/{email}` | Get user by email |

### Sample Requests

#### Create User
```http
POST /api/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john.doe@example.com",
  "password": "password123"
}
```

#### Response Format
All API responses follow a standardized format:
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { /* response data */ },
  "errors": null
}
```

## 🔧 Configuration

### Key Features Implemented

1. **Standardized Response Format**: All APIs return consistent response structure
2. **Global Exception Handling**: Centralized error handling with appropriate HTTP status codes
3. **Input Validation**: FluentValidation for request validation
4. **Password Hashing**: BCrypt for secure password storage
5. **Auto-mapping**: AutoMapper for DTO/Entity conversions
6. **CORS Support**: Configured for cross-origin requests
7. **Unique Email Constraint**: Database-level unique constraint on email
8. **Audit Fields**: CreatedAt/UpdatedAt timestamps automatically managed

### Security Features
- Passwords are hashed using BCrypt
- Email uniqueness enforced at database level
- Input validation on all endpoints
- HTTPS redirection enabled

## 📋 Database Schema

### Users Table
```sql
Users (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 DEFAULT GETUTCDATE()
)
```

## 🧪 Testing

Use the provided `backend.http` file to test the API endpoints with VS Code REST Client extension.

## 🔄 Next Steps

Consider implementing:
- JWT Authentication & Authorization
- Rate limiting
- Caching (Redis)
- Logging (Serilog)
- Health checks
- API versioning
- Unit tests
- Integration tests