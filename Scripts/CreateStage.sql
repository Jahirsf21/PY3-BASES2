-- ======================================================================================
-- STAGING
-- ======================================================================================
/*
    Crea la base de datos de staging, donde se cargan los datos crudos extraídos de BikeStores.
    Solo se crea si no existe. También crea los esquemas y las tablas del staging.
*/
IF DB_ID(N'BikeStoresStage') IS NULL
    BEGIN
        CREATE DATABASE [BikeStoresStage];
    END


GO
-- Creación de esquemas y tablas de Staging
USE BikeStoresStage;


GO
-- Esquema production: tablas de catálogo e inventario.
IF SCHEMA_ID(N'production') IS NULL
    EXECUTE ('CREATE SCHEMA production AUTHORIZATION dbo;');


GO
-- Esquema sales: tablas de ventas.
IF SCHEMA_ID(N'sales') IS NULL
    EXECUTE ('CREATE SCHEMA sales AUTHORIZATION dbo;');


GO
-- ======================================================================================
-- TABLAS STAGING: BikeStoresStage
-- ======================================================================================
-- Marcas de productos
IF OBJECT_ID(N'[production].[brands]', N'U') IS NULL
    BEGIN
        CREATE TABLE [production].[brands] (
            [brand_id]   INT           NOT NULL,
            [brand_name] VARCHAR (255) NOT NULL
        );
    END

-- Categorías de productos
IF OBJECT_ID(N'[production].[categories]', N'U') IS NULL
    BEGIN
        CREATE TABLE [production].[categories] (
            [category_id]   INT           NOT NULL,
            [category_name] VARCHAR (255) NOT NULL
        );
    END

-- Clientes
IF OBJECT_ID(N'[sales].[customers]', N'U') IS NULL
    BEGIN
        CREATE TABLE [sales].[customers] (
            [customer_id] INT           NOT NULL,
            [first_name]  VARCHAR (255) NOT NULL,
            [last_name]   VARCHAR (255) NOT NULL,
            [city]        VARCHAR (50)  NULL,
            [state]       VARCHAR (25)  NULL,
            [zip_code]    VARCHAR (5)   NULL
        );
    END

-- Detalle de cada orden (un registro por producto vendido)
IF OBJECT_ID(N'[sales].[order_items]', N'U') IS NULL
    BEGIN
        CREATE TABLE [sales].[order_items] (
            [order_id]   INT             NOT NULL,
            [item_id]    INT             NOT NULL,
            [product_id] INT             NOT NULL,
            [quantity]   INT             NOT NULL,
            [list_price] DECIMAL (10, 2) NOT NULL,
            [discount]   DECIMAL (4, 2)  NOT NULL
        );
    END

-- Encabezado de las órdenes
IF OBJECT_ID(N'[sales].[orders]', N'U') IS NULL
    BEGIN
        CREATE TABLE [sales].[orders] (
            [order_id]      INT     NOT NULL,
            [customer_id]   INT     NULL,
            [order_status]  TINYINT NOT NULL,
            [order_date]    DATE    NOT NULL,
            [required_date] DATE    NOT NULL,
            [shipped_date]  DATE    NULL,
            [store_id]      INT     NOT NULL,
            [staff_id]      INT     NOT NULL
        );
    END

-- Productos
IF OBJECT_ID(N'[production].[products]', N'U') IS NULL
    BEGIN
        CREATE TABLE [production].[products] (
            [product_id]   INT             NOT NULL,
            [product_name] VARCHAR (255)   NOT NULL,
            [brand_id]     INT             NOT NULL,
            [category_id]  INT             NOT NULL,
            [model_year]   SMALLINT        NOT NULL,
            [list_price]   DECIMAL (10, 2) NOT NULL
        );
    END

-- Empleados de las tiendas
IF OBJECT_ID(N'[sales].[staffs]', N'U') IS NULL
    BEGIN
        CREATE TABLE [sales].[staffs] (
            [staff_id]   INT          NOT NULL,
            [first_name] VARCHAR (50) NOT NULL,
            [last_name]  VARCHAR (50) NOT NULL,
            [active]     TINYINT      NOT NULL,
            [store_id]   INT          NOT NULL,
            [manager_id] INT          NULL
        );
    END

-- Inventario de productos por tienda
IF OBJECT_ID(N'[production].[stocks]', N'U') IS NULL
    BEGIN
        CREATE TABLE [production].[stocks] (
            [store_id]   INT NOT NULL,
            [product_id] INT NOT NULL,
            [quantity]   INT NULL
        );
    END

-- Tiendas
IF OBJECT_ID(N'[sales].[stores]', N'U') IS NULL
    BEGIN
        CREATE TABLE [sales].[stores] (
            [store_id]   INT           NOT NULL,
            [store_name] VARCHAR (255) NOT NULL,
            [city]       VARCHAR (255) NULL,
            [state]      VARCHAR (10)  NULL,
            [zip_code]   VARCHAR (5)   NULL
        );
    END
