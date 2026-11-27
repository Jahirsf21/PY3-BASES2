-- ======================================================================================
-- TABLAS DEL DATA WAREHOUSE: BikeStoresDW
-- ======================================================================================
/*
    Crea las tablas de dimensiones del modelo dimensional.
    Solo crea las tablas que aún no existen.
*/
USE [BikeStoresDW];


GO
-- Dimensión de productos
IF OBJECT_ID(N'[dbo].[DimProducts]', N'U') IS NULL
    BEGIN
        CREATE TABLE [dbo].[DimProducts] (
            [product_key]   INT             IDENTITY (1, 1) NOT NULL,
            [product_id]    INT             NOT NULL,
            [product_name]  VARCHAR (255)   NOT NULL,
            [brand_id]      INT             NOT NULL,
            [brand_name]    VARCHAR (255)   NOT NULL,
            [category_id]   INT             NOT NULL,
            [category_name] VARCHAR (255)   NOT NULL,
            [model_year]    SMALLINT        NOT NULL,
            [list_price]    DECIMAL (10, 2) NOT NULL,
            [start_date]    DATETIME        NOT NULL,
            [end_date]      DATETIME        NULL,
            CONSTRAINT PK_DimProducts PRIMARY KEY (product_key)
        );
    END


GO
-- Dimensión de clientes
IF OBJECT_ID(N'[dbo].[DimCustomers]', N'U') IS NULL
    BEGIN
        CREATE TABLE [dbo].[DimCustomers] (
            [customer_key] INT           IDENTITY (1, 1) NOT NULL,
            [customer_id]  INT           NOT NULL,
            [full_name]    VARCHAR (511) NOT NULL,
            [city]         VARCHAR (50)  NULL,
            [state]        VARCHAR (25)  NULL,
            [zip_code]     VARCHAR (5)   NULL,
            [start_date]   DATETIME      NOT NULL,
            [end_date]     DATETIME      NULL,
            CONSTRAINT PK_DimCustomers PRIMARY KEY (customer_key)
        );
    END


GO
-- Dimensión de tiendas
IF OBJECT_ID(N'[dbo].[DimStores]', N'U') IS NULL
    BEGIN
        CREATE TABLE [dbo].[DimStores] (
            [store_key]  INT           IDENTITY (1, 1) NOT NULL,
            [store_id]   INT           NOT NULL,
            [store_name] VARCHAR (255) NOT NULL,
            [city]       VARCHAR (255) NULL,
            [state]      VARCHAR (10)  NULL,
            [zip_code]   VARCHAR (5)   NULL,
            CONSTRAINT PK_DimStores PRIMARY KEY (store_key)
        );
    END


GO
-- Dimensión de empleados
IF OBJECT_ID(N'[dbo].[DimStaffs]', N'U') IS NULL
    BEGIN
        CREATE TABLE [dbo].[DimStaffs] (
            [staff_key]  INT           IDENTITY (1, 1) NOT NULL,
            [staff_id]   INT           NOT NULL,
            [full_name]  VARCHAR (101) NOT NULL,
            [active]     TINYINT       NOT NULL,
            [store_id]   INT           NOT NULL,
            [manager_id] INT           NULL,
            CONSTRAINT PK_DimStaffs PRIMARY KEY (staff_key)
        );
    END


GO
-- Dimensión de órdenes
IF OBJECT_ID(N'[dbo].[DimOrders]', N'U') IS NULL
    BEGIN
        CREATE TABLE [dbo].[DimOrders] (
            [order_key]    INT     IDENTITY (1, 1) NOT NULL,
            [order_id]     INT     NOT NULL,
            [order_status] TINYINT NOT NULL,
            CONSTRAINT PK_DimOrders PRIMARY KEY (order_key)
        );
    END


GO
-- Dimensión de fechas
IF OBJECT_ID(N'[dbo].[DimDate]', N'U') IS NULL
    BEGIN
        CREATE TABLE [dbo].[DimDate] (
            [date_key]     INT          NOT NULL,
            [date]         DATE         NOT NULL,
            [day_of_month] TINYINT      NOT NULL,
            [day_name]     VARCHAR (15) NOT NULL,
            [week_of_year] TINYINT      NOT NULL,
            [month]        TINYINT      NOT NULL,
            [month_name]   VARCHAR (15) NOT NULL,
            [quarter]      TINYINT      NOT NULL,
            [year]         SMALLINT     NOT NULL,
            [month_year]   VARCHAR (10) NOT NULL,
            [is_weekday]   BIT          NOT NULL,
            CONSTRAINT PK_DimDate PRIMARY KEY (date_key)
        );
    END


GO
-- Tabla de hechos de órdenes (una fila por item de cada orden)
IF OBJECT_ID(N'[dbo].[FactOrders]', N'U') IS NULL
    BEGIN
        CREATE TABLE [dbo].[FactOrders] (
            [sales_key]         INT             IDENTITY (1, 1) NOT NULL,
            [order_key]         INT             NOT NULL,
            [item_id]           INT             NOT NULL,
            [product_key]       INT             NOT NULL,
            [customer_key]      INT             NOT NULL,
            [store_key]         INT             NOT NULL,
            [staff_key]         INT             NOT NULL,
            [order_date_key]    INT             NOT NULL,
            [required_date_key] INT             NOT NULL,
            [shipped_date_key]  INT             NULL,
            [quantity]          INT             NOT NULL,
            [list_price]        DECIMAL (10, 2) NOT NULL,
            [discount]          DECIMAL (4, 2)  NOT NULL,
            CONSTRAINT PK_FactOrders PRIMARY KEY (sales_key),
            CONSTRAINT UQ_FactOrders UNIQUE (order_key, item_id),
            CONSTRAINT FK_FactOrders_DimOrders FOREIGN KEY (order_key) REFERENCES [dbo].[DimOrders] (order_key),
            CONSTRAINT FK_FactOrders_DimProducts FOREIGN KEY (product_key) REFERENCES [dbo].[DimProducts] (product_key),
            CONSTRAINT FK_FactOrders_DimCustomers FOREIGN KEY (customer_key) REFERENCES [dbo].[DimCustomers] (customer_key),
            CONSTRAINT FK_FactOrders_DimStores FOREIGN KEY (store_key) REFERENCES [dbo].[DimStores] (store_key),
            CONSTRAINT FK_FactOrders_DimStaffs FOREIGN KEY (staff_key) REFERENCES [dbo].[DimStaffs] (staff_key),
            CONSTRAINT FK_FactOrders_OrderDate FOREIGN KEY (order_date_key) REFERENCES [dbo].[DimDate] (date_key),
            CONSTRAINT FK_FactOrders_RequiredDate FOREIGN KEY (required_date_key) REFERENCES [dbo].[DimDate] (date_key),
            CONSTRAINT FK_FactOrders_ShippedDate FOREIGN KEY (shipped_date_key) REFERENCES [dbo].[DimDate] (date_key)
        );
    END
