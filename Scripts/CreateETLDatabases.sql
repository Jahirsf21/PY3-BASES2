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
-- ======================================================================================
-- DATA WAREHOUSE
-- ======================================================================================
/*
    Crea la base de datos del data warehouse (modelo dimensional).
    Solo se crea si no existe. Las tablas las crea el paquete SSIS al ejecutarse.
*/
IF DB_ID(N'BikeStores_DW') IS NULL
    BEGIN
        CREATE DATABASE [BikeStores_DW];
    END


GO
