# Store Manager Database Schema - Implementation Summary

## Overview
Successfully converted PostgreSQL schema to MSSQL and implemented Entity Framework Core models with migrations.

## Key Changes & Improvements

### 1. Data Type Conversions (PostgreSQL → MSSQL)
- `UUID` → `UNIQUEIDENTIFIER` (Guid in C#)
- `DATE` → `DATETIME2` (DateTime in C#)
- `BIGINT` → `BIGINT IDENTITY(1,1)` for auto-incrementing IDs
- `VARCHAR` → `NVARCHAR` (Unicode support)
- `TEXT` → `NVARCHAR(500)` (with appropriate length)
- `DECIMAL(8,2)` → `DECIMAL(18,2)` (increased precision for prices)

### 2. Schema Issues Fixed
1. **Removed incorrect UNIQUE constraints** on Product table:
   - `userId`, `storeId`, `categoryId` should NOT be unique
   - Multiple products can belong to same user/store/category
   
2. **Fixed typos** in original schema:
   - `createAt` → `CreatedAt`
   - `updateAt` → `UpdatedAt`
   
3. **Corrected Expense table**:
   - `customerId` now correctly references `Customer` table (was referencing `User`)
   
4. **Removed Store.userId UNIQUE constraint**:
   - Users can own multiple stores

### 3. Performance Improvements
Added strategic indexes on:
- Foreign key columns (all relationships)
- Search columns (`Name` fields)
- Filter columns (`Status`, `CreatedAt`)

### 4. Data Integrity
- All foreign keys use `DeleteBehavior.Restrict` to prevent accidental data loss
- Required fields properly marked
- String length limits enforced
- Decimal precision appropriate for financial data

## Models Created

### Core Entities
1. **User** - System users with authentication
2. **Store** - Business locations owned by users
3. **ProductCategory** - Product categorization
4. **Product** - Items available in stores
5. **Customer** - Store customers
6. **Sale** - Sales transactions with status tracking
7. **Expense** - Business expenses tracking

### Relationships
```
User (1) ──→ (N) Store
User (1) ──→ (N) Product
User (1) ──→ (N) Customer
User (1) ──→ (N) Sale

Store (1) ──→ (N) Product
Store (1) ──→ (N) Customer
Store (1) ──→ (N) Sale
Store (1) ──→ (N) Expense

ProductCategory (1) ──→ (N) Product

Product (1) ──→ (N) Sale
Product (1) ──→ (N) Expense

Customer (1) ──→ (N) Sale
Customer (1) ──→ (N) Expense
```

## Files Created/Modified

### Models
- ✅ `Models/User.cs` (updated - added Avatar, changed Id to Guid)
- ✅ `Models/Store.cs` (new)
- ✅ `Models/ProductCategory.cs` (new)
- ✅ `Models/Product.cs` (new)
- ✅ `Models/Customer.cs` (new)
- ✅ `Models/Sale.cs` (new)
- ✅ `Models/Expense.cs` (new)

### Data Context
- ✅ `Data/ApplicationDbContext.cs` (updated with all entities and configurations)

### Migrations
- ✅ `Migrations/20251015024011_InitialStoreManagerSchema.cs`
- ✅ `Migrations/ApplicationDbContextModelSnapshot.cs`

### Reference
- ✅ `reference/mssql-schema.sql` (MSSQL schema reference)
- ✅ `reference/drawSQL-pgsql-export-2025-10-15.sql` (original PostgreSQL)

## Next Steps

### Apply Migration
```bash
cd backend
dotnet ef database update
```

### Update Existing Services/Controllers
The `UsersController` and `UserService` need to be updated since User.Id changed from `int` to `Guid`.

### Create Additional Services/Controllers
Consider creating services and controllers for:
- StoreService / StoreController
- ProductService / ProductController
- CustomerService / CustomerController
- SaleService / SaleController
- ExpenseService / ExpenseController

### Update DTOs
Create DTOs for all new models following the pattern:
- Create{Entity}Dto
- Update{Entity}Dto
- {Entity}ResponseDto

### Add Validators
Create FluentValidation validators for all new DTOs.

### Update AutoMapper Profiles
Add mappings for all new entities in `MappingProfile.cs`.

## Database Features
- ✅ Automatic timestamp management (CreatedAt/UpdatedAt)
- ✅ Proper foreign key constraints
- ✅ Indexes for performance
- ✅ Cascade delete prevention
- ✅ Unique email constraint on User
- ✅ GUID primary keys for distributed systems
- ✅ Unicode support for international characters
- ✅ Appropriate decimal precision for financial data

## Connection String
Ensure your `appsettings.json` has a valid SQL Server connection string:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=StoreManager;Trusted_Connection=True;TrustServerCertificate=True;MultipleActiveResultSets=true"
  }
}
```

## Notes
- All models include virtual navigation properties for lazy loading
- All foreign keys are required (not nullable)
- Avatar and Image fields are optional (nullable)
- Sale status defaults to "pending"
- All timestamps use UTC
