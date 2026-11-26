-- ======================================================================================
-- STAGING
-- ======================================================================================
/*
    Crea la base de datos de staging, donde se cargan los datos crudos extraídos de BikeStores.
    Solo se crea si no existe. Las tablas las crea el paquete SSIS al ejecutarse.
*/
IF DB_ID(N'BikeStoresStage') IS NULL
    BEGIN
        CREATE DATABASE [BikeStoresStage];
    END


GO
-- Creación de esquemas de Staging
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
-- DATA WAREHOUSE
-- ======================================================================================
/*
    Crea la base de datos del data warehouse
    Solo se crea si no existe.
*/
IF DB_ID(N'BikeStoresDW') IS NULL
    BEGIN
        CREATE DATABASE [BikeStoresDW];
    END


GO
