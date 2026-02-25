-- =========================
-- Customers
-- =========================
CREATE TABLE Customers (
    CustomerId SERIAL PRIMARY KEY,
    CustomerCode VARCHAR(50) UNIQUE NOT NULL,
    CustomerName VARCHAR(200) NOT NULL,
    Email VARCHAR(200),
    Phone VARCHAR(50),
    BillingAddress1 VARCHAR(200),
    BillingCity VARCHAR(100),
    BillingCountry VARCHAR(100),
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP,
    IsActive BOOLEAN NOT NULL DEFAULT TRUE
);

-- =========================
-- Vendors
-- =========================
CREATE TABLE Vendors (
    VendorId SERIAL PRIMARY KEY,
    VendorCode VARCHAR(50) UNIQUE NOT NULL,
    VendorName VARCHAR(200) NOT NULL,
    Email VARCHAR(200),
    Phone VARCHAR(50),
    AddressLine1 VARCHAR(200),
    City VARCHAR(100),
    Country VARCHAR(100),
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP,
    IsActive BOOLEAN NOT NULL DEFAULT TRUE
);

-- =========================
-- Sites
-- =========================
CREATE TABLE Sites (
    SiteId SERIAL PRIMARY KEY,
    SiteCode VARCHAR(50) UNIQUE NOT NULL,
    SiteName VARCHAR(200) NOT NULL,
    AddressLine1 VARCHAR(200),
    City VARCHAR(100),
    Country VARCHAR(100),
    TimeZone VARCHAR(100),
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP,
    IsActive BOOLEAN NOT NULL DEFAULT TRUE
);

-- =========================
-- Locations
-- =========================
CREATE TABLE Locations (
    LocationId SERIAL PRIMARY KEY,
    SiteId INT NOT NULL,
    LocationCode VARCHAR(50) NOT NULL,
    LocationName VARCHAR(200) NOT NULL,
    ParentLocationId INT,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP,
    IsActive BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT UQ_Locations_SiteCode UNIQUE (SiteId, LocationCode),
    CONSTRAINT FK_Locations_Site FOREIGN KEY (SiteId) REFERENCES Sites(SiteId),
    CONSTRAINT FK_Locations_Parent FOREIGN KEY (ParentLocationId) REFERENCES Locations(LocationId)
);

-- =========================
-- Items
-- =========================
CREATE TABLE Items (
    ItemId SERIAL PRIMARY KEY,
    ItemCode VARCHAR(100) UNIQUE NOT NULL,
    ItemName VARCHAR(200) NOT NULL,
    Category VARCHAR(100),
    UnitOfMeasure VARCHAR(50),
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP,
    IsActive BOOLEAN NOT NULL DEFAULT TRUE
);

-- =========================
-- Assets
-- =========================
CREATE TABLE Assets (
    AssetId SERIAL PRIMARY KEY,
    AssetTag VARCHAR(100) UNIQUE NOT NULL,
    AssetName VARCHAR(200) NOT NULL,
    SiteId INT NOT NULL,
    LocationId INT,
    SerialNumber VARCHAR(200),
    Category VARCHAR(100),
    Status VARCHAR(30) NOT NULL DEFAULT 'Active',
    Cost DECIMAL(18,2),
    PurchaseDate DATE,
    VendorId INT,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP,
    CONSTRAINT FK_Assets_Site FOREIGN KEY (SiteId) REFERENCES Sites(SiteId),
    CONSTRAINT FK_Assets_Location FOREIGN KEY (LocationId) REFERENCES Locations(LocationId),
    CONSTRAINT FK_Assets_Vendor FOREIGN KEY (VendorId) REFERENCES Vendors(VendorId)
);

-- =========================
-- Bills
-- =========================
CREATE TABLE Bills (
    BillId SERIAL PRIMARY KEY,
    VendorId INT NOT NULL,
    BillNumber VARCHAR(100) NOT NULL,
    BillDate DATE NOT NULL,
    DueDate DATE,
    TotalAmount DECIMAL(18,2) NOT NULL,
    Currency VARCHAR(10) NOT NULL DEFAULT 'USD',
    Status VARCHAR(30) NOT NULL DEFAULT 'Open',
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP,
    CONSTRAINT UQ_Bills_Vendor_BillNumber UNIQUE (VendorId, BillNumber),
    CONSTRAINT FK_Bills_Vendor FOREIGN KEY (VendorId) REFERENCES Vendors(VendorId)
);

-- =========================
-- Purchase Orders
-- =========================
CREATE TABLE PurchaseOrders (
    POId SERIAL PRIMARY KEY,
    PONumber VARCHAR(100) UNIQUE NOT NULL,
    VendorId INT NOT NULL,
    PODate DATE NOT NULL,
    Status VARCHAR(30) NOT NULL DEFAULT 'Open',
    SiteId INT,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP,
    CONSTRAINT FK_PurchaseOrders_Vendor FOREIGN KEY (VendorId) REFERENCES Vendors(VendorId),
    CONSTRAINT FK_PurchaseOrders_Site FOREIGN KEY (SiteId) REFERENCES Sites(SiteId)
);

-- =========================
-- Purchase Order Lines
-- =========================
CREATE TABLE PurchaseOrderLines (
    POLineId SERIAL PRIMARY KEY,
    POId INT NOT NULL,
    LineNumber INT NOT NULL,
    ItemId INT,
    ItemCode VARCHAR(100) NOT NULL,
    Description VARCHAR(200),
    Quantity DECIMAL(18,4) NOT NULL,
    UnitPrice DECIMAL(18,4) NOT NULL,
    CONSTRAINT UQ_PurchaseOrderLines UNIQUE (POId, LineNumber),
    CONSTRAINT FK_PurchaseOrderLines_PO FOREIGN KEY (POId) REFERENCES PurchaseOrders(POId),
    CONSTRAINT FK_PurchaseOrderLines_Item FOREIGN KEY (ItemId) REFERENCES Items(ItemId)
);

-- =========================
-- Sales Orders
-- =========================
CREATE TABLE SalesOrders (
    SOId SERIAL PRIMARY KEY,
    SONumber VARCHAR(100) UNIQUE NOT NULL,
    CustomerId INT NOT NULL,
    SODate DATE NOT NULL,
    Status VARCHAR(30) NOT NULL DEFAULT 'Open',
    SiteId INT,
    CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP,
    CONSTRAINT FK_SalesOrders_Customer FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId),
    CONSTRAINT FK_SalesOrders_Site FOREIGN KEY (SiteId) REFERENCES Sites(SiteId)
);

-- =========================
-- Sales Order Lines
-- =========================
CREATE TABLE SalesOrderLines (
    SOLineId SERIAL PRIMARY KEY,
    SOId INT NOT NULL,
    LineNumber INT NOT NULL,
    ItemId INT,
    ItemCode VARCHAR(100) NOT NULL,
    Description VARCHAR(200),
    Quantity DECIMAL(18,4) NOT NULL,
    UnitPrice DECIMAL(18,4) NOT NULL,
    CONSTRAINT UQ_SalesOrderLines UNIQUE (SOId, LineNumber),
    CONSTRAINT FK_SalesOrderLines_SO FOREIGN KEY (SOId) REFERENCES SalesOrders(SOId),
    CONSTRAINT FK_SalesOrderLines_Item FOREIGN KEY (ItemId) REFERENCES Items(ItemId)
);

-- =========================
-- Asset Transactions
-- =========================
CREATE TABLE AssetTransactions (
    AssetTxnId SERIAL PRIMARY KEY,
    AssetId INT NOT NULL,
    FromLocationId INT,
    ToLocationId INT,
    TxnType VARCHAR(30) NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    TxnDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Note VARCHAR(500),
    CONSTRAINT FK_AssetTransactions_Asset FOREIGN KEY (AssetId) REFERENCES Assets(AssetId),
    CONSTRAINT FK_AssetTransactions_FromLoc FOREIGN KEY (FromLocationId) REFERENCES Locations(LocationId),
    CONSTRAINT FK_AssetTransactions_ToLoc FOREIGN KEY (ToLocationId) REFERENCES Locations(LocationId)
);