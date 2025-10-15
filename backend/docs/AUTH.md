# JWT Authentication Implementation

This document describes the JWT authentication implementation for the StoreManager API.

## Overview

The API uses JSON Web Tokens (JWT) for authentication. Users can register, login, and access protected endpoints using Bearer token authentication.

## Authentication Flow

1. **Registration** - New users register with name, email, and password
2. **Login** - Users authenticate with email and password to receive a JWT token
3. **Protected Routes** - Users include the JWT token in the Authorization header to access protected endpoints

## Endpoints

### Public Endpoints (No Authentication Required)

#### Register
```http
POST /api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john.doe@example.com",
  "password": "password123",
  "avatar": "https://example.com/avatar.jpg"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "id": "uuid",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "avatar": "https://example.com/avatar.jpg",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresAt": "2025-10-22T00:00:00Z"
  }
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "john.doe@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "id": "uuid",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "avatar": "https://example.com/avatar.jpg",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresAt": "2025-10-22T00:00:00Z"
  }
}
```

### Protected Endpoints (Authentication Required)

#### Get Current User
```http
GET /api/auth/me
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "message": "User retrieved successfully",
  "data": {
    "id": "uuid",
    "name": "John Doe",
    "email": "john.doe@example.com",
    "avatar": "https://example.com/avatar.jpg",
    "createdAt": "2025-10-15T00:00:00Z",
    "updatedAt": "2025-10-15T00:00:00Z"
  }
}
```

## Configuration

JWT settings are configured in `appsettings.json`:

```json
{
  "Jwt": {
    "Key": "YourSuperSecretKeyThatIsAtLeast32CharactersLong!",
    "Issuer": "StoreManagerAPI",
    "Audience": "StoreManagerClient",
    "ExpirationDays": "7"
  }
}
```

### Configuration Options

- **Key**: Secret key used to sign JWT tokens (must be at least 32 characters)
- **Issuer**: The issuer of the token (typically your API name)
- **Audience**: The intended audience of the token (typically your client app)
- **ExpirationDays**: Number of days until the token expires

## Security Best Practices

1. **Store JWT Key Securely**
   - Never commit production keys to version control
   - Use environment variables or Azure Key Vault for production
   - Rotate keys periodically

2. **Password Security**
   - Passwords are hashed using BCrypt before storage
   - Never store plain text passwords
   - Enforce strong password requirements

3. **Token Security**
   - Tokens expire after the configured period (default: 7 days)
   - Store tokens securely on the client (e.g., HttpOnly cookies or secure storage)
   - Never expose tokens in URLs

4. **HTTPS Only**
   - Always use HTTPS in production
   - Never transmit tokens over unencrypted connections

## Using JWT Tokens

### In HTTP Requests

Include the token in the `Authorization` header with the `Bearer` scheme:

```http
GET /api/auth/me
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### In JavaScript/TypeScript

```javascript
const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';

fetch('https://api.example.com/api/auth/me', {
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  }
})
.then(response => response.json())
.then(data => console.log(data));
```

### In Axios

```javascript
import axios from 'axios';

const api = axios.create({
  baseURL: 'https://api.example.com/api',
});

// Add token to all requests
api.interceptors.request.use(config => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Use the API
const response = await api.get('/auth/me');
```

## Validation Rules

### Registration
- **Name**: Required, max 255 characters
- **Email**: Required, valid email format, max 255 characters, must be unique
- **Password**: Required, min 6 characters, max 255 characters
- **Avatar**: Optional, max 500 characters (URL)

### Login
- **Email**: Required, valid email format
- **Password**: Required

## Error Responses

### Validation Error
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "property": "Email",
      "message": "Invalid email format"
    }
  ]
}
```

### Authentication Error
```json
{
  "success": false,
  "message": "Invalid email or password"
}
```

### Unauthorized (Missing or Invalid Token)
```json
{
  "success": false,
  "message": "Invalid or missing user token"
}
```

### User Not Found
```json
{
  "success": false,
  "message": "User not found"
}
```

## Testing with Swagger

The API includes Swagger UI with JWT authentication support:

1. Navigate to `/swagger` endpoint
2. Click the "Authorize" button
3. Enter `Bearer {your-token}` (the word "Bearer" followed by a space and your token)
4. Click "Authorize"
5. Test protected endpoints

## Implementation Details

### Key Components

1. **DTOs**
   - `LoginDto` - Login request
   - `RegisterDto` - Registration request
   - `AuthResponseDto` - Authentication response with token

2. **Services**
   - `IAuthService` / `AuthService` - Handles authentication logic
   - Password hashing with BCrypt
   - JWT token generation

3. **Controllers**
   - `AuthController` - Authentication endpoints

4. **Validators**
   - `LoginDtoValidator` - Validates login requests
   - `RegisterDtoValidator` - Validates registration requests

### JWT Claims

The generated JWT token includes the following claims:

- `sub` (Subject) - User ID (GUID)
- `email` - User email address
- `name` - User name
- `jti` (JWT ID) - Unique token identifier

## Next Steps

1. **Implement Token Refresh**
   - Add refresh token functionality for long-lived sessions
   
2. **Add Role-Based Authorization**
   - Implement user roles (Admin, Manager, User)
   - Add role-based access control to endpoints

3. **Implement Password Reset**
   - Add forgot password functionality
   - Email verification for password reset

4. **Add Email Verification**
   - Verify email addresses during registration
   - Prevent unverified users from accessing certain features

5. **Implement Rate Limiting**
   - Protect against brute force attacks
   - Limit login attempts

6. **Add Audit Logging**
   - Log authentication events
   - Track failed login attempts
