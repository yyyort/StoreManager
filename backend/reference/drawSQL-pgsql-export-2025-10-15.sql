CREATE TABLE "user"(
    "id" UUID NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "avatar" VARCHAR(255) NOT NULL,
    "createdAt" DATE NOT NULL,
    "updatedAt" DATE NOT NULL
);
ALTER TABLE
    "user" ADD PRIMARY KEY("id");
CREATE TABLE "product"(
    "id" UUID NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "quantity" INTEGER NOT NULL,
    "image" VARCHAR(255) NOT NULL,
    "price" DECIMAL(8, 2) NOT NULL,
    "userId" UUID NOT NULL,
    "storeId" UUID NOT NULL,
    "categoryId" UUID NOT NULL,
    "createdAt" DATE NOT NULL,
    "updatedAt" DATE NOT NULL
);
ALTER TABLE
    "product" ADD PRIMARY KEY("id");
ALTER TABLE
    "product" ADD CONSTRAINT "product_userid_unique" UNIQUE("userId");
ALTER TABLE
    "product" ADD CONSTRAINT "product_storeid_unique" UNIQUE("storeId");
ALTER TABLE
    "product" ADD CONSTRAINT "product_categoryid_unique" UNIQUE("categoryId");
CREATE TABLE "store"(
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" DATE NOT NULL,
    "updatedAt" DATE NOT NULL
);
ALTER TABLE
    "store" ADD PRIMARY KEY("id");
ALTER TABLE
    "store" ADD CONSTRAINT "store_userid_unique" UNIQUE("userId");
CREATE TABLE "sales"(
    "id" BIGINT NOT NULL,
    "customerId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "storeId" UUID NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unitPrice" DECIMAL(8, 2) NOT NULL,
    "totalPrice" DECIMAL(8, 2) NOT NULL,
    "productId" UUID NOT NULL,
    "status" VARCHAR(255) NOT NULL,
    "createdAt" DATE NOT NULL,
    "updatedAt" DATE NOT NULL
);
ALTER TABLE
    "sales" ADD PRIMARY KEY("id");
CREATE TABLE "product_category"(
    "id" UUID NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "createdAt" DATE NOT NULL,
    "updatedAt" DATE NOT NULL
);
ALTER TABLE
    "product_category" ADD PRIMARY KEY("id");
CREATE TABLE "expenses"(
    "id" BIGINT NOT NULL,
    "customerId" UUID NOT NULL,
    "storeId" UUID NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unitPrice" DECIMAL(8, 2) NOT NULL,
    "totalPrice" DECIMAL(8, 2) NOT NULL,
    "productId" UUID NOT NULL,
    "createAt" DATE NOT NULL,
    "updatedAt" DATE NOT NULL
);
ALTER TABLE
    "expenses" ADD PRIMARY KEY("id");
CREATE TABLE "customer"(
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "storeId" UUID NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "address" VARCHAR(255) NOT NULL,
    "avatar" VARCHAR(255) NOT NULL,
    "createAt" DATE NOT NULL,
    "updateAt" DATE NOT NULL
);
ALTER TABLE
    "customer" ADD PRIMARY KEY("id");
ALTER TABLE
    "expenses" ADD CONSTRAINT "expenses_productid_foreign" FOREIGN KEY("productId") REFERENCES "product"("id");
ALTER TABLE
    "sales" ADD CONSTRAINT "sales_productid_foreign" FOREIGN KEY("productId") REFERENCES "product"("id");
ALTER TABLE
    "product" ADD CONSTRAINT "product_userid_foreign" FOREIGN KEY("userId") REFERENCES "user"("id");
ALTER TABLE
    "sales" ADD CONSTRAINT "sales_userid_foreign" FOREIGN KEY("userId") REFERENCES "user"("id");
ALTER TABLE
    "expenses" ADD CONSTRAINT "expenses_customerid_foreign" FOREIGN KEY("customerId") REFERENCES "user"("id");
ALTER TABLE
    "store" ADD CONSTRAINT "store_userid_foreign" FOREIGN KEY("userId") REFERENCES "user"("id");
ALTER TABLE
    "customer" ADD CONSTRAINT "customer_storeid_foreign" FOREIGN KEY("storeId") REFERENCES "store"("id");
ALTER TABLE
    "sales" ADD CONSTRAINT "sales_storeid_foreign" FOREIGN KEY("storeId") REFERENCES "store"("id");
ALTER TABLE
    "product" ADD CONSTRAINT "product_categoryid_foreign" FOREIGN KEY("categoryId") REFERENCES "product_category"("id");
ALTER TABLE
    "product" ADD CONSTRAINT "product_storeid_foreign" FOREIGN KEY("storeId") REFERENCES "store"("id");
ALTER TABLE
    "sales" ADD CONSTRAINT "sales_customerid_foreign" FOREIGN KEY("customerId") REFERENCES "customer"("id");
ALTER TABLE
    "customer" ADD CONSTRAINT "customer_userid_foreign" FOREIGN KEY("userId") REFERENCES "user"("id");
ALTER TABLE
    "expenses" ADD CONSTRAINT "expenses_storeid_foreign" FOREIGN KEY("storeId") REFERENCES "store"("id");