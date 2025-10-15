-- MSSQL Schema for Store Manager
-- Converted from PostgreSQL and improved
-- Changes:
-- 1. UUID -> UNIQUEIDENTIFIER
-- 2. DATE -> DATETIME2
-- 3. BIGINT auto-increment -> BIGINT IDENTITY
-- 4. Removed incorrect UNIQUE constraints on Product foreign keys
-- 5. Fixed typos (createAt -> CreatedAt, updateAt -> UpdatedAt)
-- 6. Added proper indexes for performance
-- 7. Changed Store.userId UNIQUE constraint (removed - users can have multiple stores)
-- 8. Fixed Expense.customerId to reference Customer table (not User)

-- User Table
CREATE TABLE [User] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    [Email] NVARCHAR(255) NOT NULL,
    [Password] NVARCHAR(255) NOT NULL,
    [Name] NVARCHAR(255) NOT NULL,
    [Avatar] NVARCHAR(500) NULL,
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT UQ_User_Email UNIQUE ([Email])
);
CREATE INDEX IX_User_Email ON [User]([Email]);

-- Store Table
CREATE TABLE [Store] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [Name] NVARCHAR(500) NOT NULL,
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Store_User FOREIGN KEY ([UserId]) REFERENCES [User]([Id])
);
CREATE INDEX IX_Store_UserId ON [Store]([UserId]);

-- ProductCategory Table
CREATE TABLE [ProductCategory] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    [Name] NVARCHAR(255) NOT NULL,
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
CREATE INDEX IX_ProductCategory_Name ON [ProductCategory]([Name]);

-- Product Table
CREATE TABLE [Product] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    [Name] NVARCHAR(255) NOT NULL,
    [Quantity] INT NOT NULL,
    [Image] NVARCHAR(500) NULL,
    [Price] DECIMAL(18, 2) NOT NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [StoreId] UNIQUEIDENTIFIER NOT NULL,
    [CategoryId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Product_User FOREIGN KEY ([UserId]) REFERENCES [User]([Id]),
    CONSTRAINT FK_Product_Store FOREIGN KEY ([StoreId]) REFERENCES [Store]([Id]),
    CONSTRAINT FK_Product_Category FOREIGN KEY ([CategoryId]) REFERENCES [ProductCategory]([Id])
);
CREATE INDEX IX_Product_Name ON [Product]([Name]);
CREATE INDEX IX_Product_UserId ON [Product]([UserId]);
CREATE INDEX IX_Product_StoreId ON [Product]([StoreId]);
CREATE INDEX IX_Product_CategoryId ON [Product]([CategoryId]);

-- Customer Table
CREATE TABLE [Customer] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWID(),
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [StoreId] UNIQUEIDENTIFIER NOT NULL,
    [Name] NVARCHAR(255) NOT NULL,
    [Address] NVARCHAR(500) NULL,
    [Avatar] NVARCHAR(500) NULL,
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Customer_User FOREIGN KEY ([UserId]) REFERENCES [User]([Id]),
    CONSTRAINT FK_Customer_Store FOREIGN KEY ([StoreId]) REFERENCES [Store]([Id])
);
CREATE INDEX IX_Customer_Name ON [Customer]([Name]);
CREATE INDEX IX_Customer_UserId ON [Customer]([UserId]);
CREATE INDEX IX_Customer_StoreId ON [Customer]([StoreId]);

-- Sales Table
CREATE TABLE [Sales] (
    [Id] BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [CustomerId] UNIQUEIDENTIFIER NOT NULL,
    [UserId] UNIQUEIDENTIFIER NOT NULL,
    [StoreId] UNIQUEIDENTIFIER NOT NULL,
    [ProductId] UNIQUEIDENTIFIER NOT NULL,
    [Quantity] INT NOT NULL,
    [UnitPrice] DECIMAL(18, 2) NOT NULL,
    [TotalPrice] DECIMAL(18, 2) NOT NULL,
    [Status] NVARCHAR(50) NOT NULL DEFAULT 'pending',
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Sales_Customer FOREIGN KEY ([CustomerId]) REFERENCES [Customer]([Id]),
    CONSTRAINT FK_Sales_User FOREIGN KEY ([UserId]) REFERENCES [User]([Id]),
    CONSTRAINT FK_Sales_Store FOREIGN KEY ([StoreId]) REFERENCES [Store]([Id]),
    CONSTRAINT FK_Sales_Product FOREIGN KEY ([ProductId]) REFERENCES [Product]([Id])
);
CREATE INDEX IX_Sales_CustomerId ON [Sales]([CustomerId]);
CREATE INDEX IX_Sales_UserId ON [Sales]([UserId]);
CREATE INDEX IX_Sales_StoreId ON [Sales]([StoreId]);
CREATE INDEX IX_Sales_ProductId ON [Sales]([ProductId]);
CREATE INDEX IX_Sales_Status ON [Sales]([Status]);
CREATE INDEX IX_Sales_CreatedAt ON [Sales]([CreatedAt]);

-- Expenses Table
CREATE TABLE [Expenses] (
    [Id] BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [CustomerId] UNIQUEIDENTIFIER NOT NULL,
    [StoreId] UNIQUEIDENTIFIER NOT NULL,
    [ProductId] UNIQUEIDENTIFIER NOT NULL,
    [Quantity] INT NOT NULL,
    [UnitPrice] DECIMAL(18, 2) NOT NULL,
    [TotalPrice] DECIMAL(18, 2) NOT NULL,
    [CreatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [UpdatedAt] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Expenses_Customer FOREIGN KEY ([CustomerId]) REFERENCES [Customer]([Id]),
    CONSTRAINT FK_Expenses_Store FOREIGN KEY ([StoreId]) REFERENCES [Store]([Id]),
    CONSTRAINT FK_Expenses_Product FOREIGN KEY ([ProductId]) REFERENCES [Product]([Id])
);
CREATE INDEX IX_Expenses_CustomerId ON [Expenses]([CustomerId]);
CREATE INDEX IX_Expenses_StoreId ON [Expenses]([StoreId]);
CREATE INDEX IX_Expenses_ProductId ON [Expenses]([ProductId]);
CREATE INDEX IX_Expenses_CreatedAt ON [Expenses]([CreatedAt]);
