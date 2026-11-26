-- ======================================================================================
-- TABLAS DEL DATA WAREHOUSE: BikeStoresDW
-- ======================================================================================
/*
    Crea las tablas de dimensiones del modelo dimensional.
*/
USE [BikeStoresDW];


GO
-- Dimensión de productos
CREATE TABLE [dbo].[DimProducts] (
    [product_key]  INT             IDENTITY (1, 1) NOT NULL,
    [product_id]   INT             NOT NULL,
    [product_name] VARCHAR (255)   NOT NULL,
    [brand_id]     INT             NOT NULL,
    [category_id]  INT             NOT NULL,
    [model_year]   SMALLINT        NOT NULL,
    [list_price]   DECIMAL (10, 2) NOT NULL,
    [start_date]   DATETIME        NOT NULL,
    [end_date]     DATETIME        NULL,
    CONSTRAINT PK_DimProducts PRIMARY KEY (product_key)
);


GO
-- Dimensión de clientes (nombre completo y ubicación)
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


GO