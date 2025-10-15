# Authentication Flow Diagram

## Registration Flow
```
┌─────────┐                ┌────────────────┐                ┌──────────┐                ┌──────────┐
│ Client  │                │ AuthController │                │ AuthSvc  │                │ Database │
└────┬────┘                └───────┬────────┘                └────┬─────┘                └────┬─────┘
     │                             │                              │                           │
     │  POST /api/auth/register    │                              │                           │
     │────────────────────────────>│                              │                           │
     │  {name, email, password}    │                              │                           │
     │                             │                              │                           │
     │                             │  Validate RegisterDto        │                           │
     │                             │──────────────────┐           │                           │
     │                             │                  │           │                           │
     │                             │<─────────────────┘           │                           │
     │                             │                              │                           │
     │                             │  RegisterAsync(dto)          │                           │
     │                             │─────────────────────────────>│                           │
     │                             │                              │                           │
     │                             │                              │  Check if email exists    │
     │                             │                              │──────────────────────────>│
     │                             │                              │                           │
     │                             │                              │  Email available          │
     │                             │                              │<──────────────────────────│
     │                             │                              │                           │
     │                             │                              │  Hash password (BCrypt)   │
     │                             │                              │──────────────┐            │
     │                             │                              │              │            │
     │                             │                              │<─────────────┘            │
     │                             │                              │                           │
     │                             │                              │  Create User              │
     │                             │                              │──────────────────────────>│
     │                             │                              │                           │
     │                             │                              │  User saved               │
     │                             │                              │<──────────────────────────│
     │                             │                              │                           │
     │                             │                              │  Generate JWT Token       │
     │                             │                              │──────────────┐            │
     │                             │                              │              │            │
     │                             │                              │<─────────────┘            │
     │                             │                              │                           │
     │                             │  AuthResponseDto (with token)│                           │
     │                             │<─────────────────────────────│                           │
     │                             │                              │                           │
     │  201 Created + Token        │                              │                           │
     │<────────────────────────────│                              │                           │
     │                             │                              │                           │
```

## Login Flow
```
┌─────────┐                ┌────────────────┐                ┌──────────┐                ┌──────────┐
│ Client  │                │ AuthController │                │ AuthSvc  │                │ Database │
└────┬────┘                └───────┬────────┘                └────┬─────┘                └────┬─────┘
     │                             │                              │                           │
     │  POST /api/auth/login       │                              │                           │
     │────────────────────────────>│                              │                           │
     │  {email, password}          │                              │                           │
     │                             │                              │                           │
     │                             │  Validate LoginDto           │                           │
     │                             │──────────────────┐           │                           │
     │                             │                  │           │                           │
     │                             │<─────────────────┘           │                           │
     │                             │                              │                           │
     │                             │  LoginAsync(dto)             │                           │
     │                             │─────────────────────────────>│                           │
     │                             │                              │                           │
     │                             │                              │  Find user by email       │
     │                             │                              │──────────────────────────>│
     │                             │                              │                           │
     │                             │                              │  User found               │
     │                             │                              │<──────────────────────────│
     │                             │                              │                           │
     │                             │                              │  Verify password (BCrypt) │
     │                             │                              │──────────────┐            │
     │                             │                              │              │            │
     │                             │                              │<─────────────┘            │
     │                             │                              │                           │
     │                             │                              │  Generate JWT Token       │
     │                             │                              │──────────────┐            │
     │                             │                              │              │            │
     │                             │                              │<─────────────┘            │
     │                             │                              │                           │
     │                             │  AuthResponseDto (with token)│                           │
     │                             │<─────────────────────────────│                           │
     │                             │                              │                           │
     │  200 OK + Token             │                              │                           │
     │<────────────────────────────│                              │                           │
     │                             │                              │                           │
```

## Protected Endpoint Access Flow
```
┌─────────┐                ┌────────────────┐                ┌──────────────┐            ┌──────────┐
│ Client  │                │ AuthController │                │ JWT Middleware│            │ Database │
└────┬────┘                └───────┬────────┘                └──────┬───────┘            └────┬─────┘
     │                             │                                │                         │
     │  GET /api/auth/me           │                                │                         │
     │  Authorization: Bearer TOKEN│                                │                         │
     │────────────────────────────>│                                │                         │
     │                             │                                │                         │
     │                             │  Extract & Validate Token      │                         │
     │                             │───────────────────────────────>│                         │
     │                             │                                │                         │
     │                             │                                │  Validate signature     │
     │                             │                                │  Check expiration       │
     │                             │                                │  Verify issuer/audience │
     │                             │                                │──────────────┐          │
     │                             │                                │              │          │
     │                             │                                │<─────────────┘          │
     │                             │                                │                         │
     │                             │  Token valid + Claims          │                         │
     │                             │<───────────────────────────────│                         │
     │                             │                                │                         │
     │                             │  Extract User ID from claims   │                         │
     │                             │──────────────────┐             │                         │
     │                             │                  │             │                         │
     │                             │<─────────────────┘             │                         │
     │                             │                                │                         │
     │                             │  GetUserByIdAsync(userId)      │                         │
     │                             │────────────────────────────────┼────────────────────────>│
     │                             │                                │                         │
     │                             │  User data                     │                         │
     │                             │<────────────────────────────────┼─────────────────────────│
     │                             │                                │                         │
     │  200 OK + User Data         │                                │                         │
     │<────────────────────────────│                                │                         │
     │                             │                                │                         │
```

## JWT Token Structure

```
Header.Payload.Signature

Header (Base64):
{
  "alg": "HS256",
  "typ": "JWT"
}

Payload (Base64):
{
  "sub": "user-guid-here",
  "email": "user@example.com",
  "name": "John Doe",
  "jti": "unique-token-id",
  "iss": "StoreManagerAPI",
  "aud": "StoreManagerClient",
  "exp": 1729123456
}

Signature:
HMACSHA256(
  base64UrlEncode(header) + "." + base64UrlEncode(payload),
  secret-key
)
```

## Security Layers

```
┌─────────────────────────────────────────────────────────┐
│                    Client Request                        │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│            1. HTTPS/TLS Encryption                       │
│            (Transport Layer Security)                    │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│            2. CORS Policy Check                          │
│            (Cross-Origin Resource Sharing)               │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│            3. JWT Token Validation                       │
│            - Signature verification                      │
│            - Expiration check                            │
│            - Issuer/Audience validation                  │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│            4. Authorization Check                        │
│            - User exists                                 │
│            - User has required permissions               │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│            5. Input Validation                           │
│            - FluentValidation rules                      │
│            - Data type checks                            │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│            6. Business Logic Execution                   │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│            7. Database Access                            │
│            - SQL injection prevention (EF Core)          │
│            - Parameterized queries                       │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────┐
│            Response with Data                            │
└─────────────────────────────────────────────────────────┘
```
