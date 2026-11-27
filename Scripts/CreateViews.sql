-- ======================================================================================
-- VISTAS PARA DASHBOARDS: BikeStoresDW
-- ======================================================================================
/*
    Crea las vistas que consultan los dashboards de Ventas e Inventario.
*/
USE [BikeStoresDW];


GO
-- ======================================================================================
-- DASHBOARD DE VENTAS
-- ======================================================================================
CREATE OR ALTER VIEW [dbo].[vw_Sales]
AS
-- Orden
SELECT o.[order_id] AS [id_orden],
       o.[order_status] AS [estado_orden],
       f.[item_id] AS [id_linea],
       d.[date] AS [fecha_orden],
       d.[year] AS [anio_orden],
       d.[month] AS [mes_orden],
       d.[month_name] AS [nombre_mes_orden],
       d.[quarter] AS [trimestre_orden],
       p.[product_id] AS [id_producto],
       p.[product_name] AS [producto],
       p.[brand_id] AS [id_marca],
       p.[brand_name] AS [marca],
       p.[category_id] AS [id_categoria],
       p.[category_name] AS [categoria],
       c.[customer_id] AS [id_cliente],
       c.[full_name] AS [cliente],
       c.[city] AS [ciudad_cliente],
       c.[state] AS [estado_cliente],
       s.[store_id] AS [id_tienda],
       s.[store_name] AS [tienda],
       st.[staff_id] AS [id_empleado],
       st.[full_name] AS [empleado],
       f.[quantity] AS [cantidad],
       f.[list_price] AS [precio_lista],
       f.[discount] AS [descuento],
       CAST (f.[quantity] * f.[list_price] AS DECIMAL (12, 2)) AS [monto_bruto],
       CAST (f.[quantity] * f.[list_price] * f.[discount] AS DECIMAL (12, 2)) AS [monto_descuento],
       CAST (f.[quantity] * f.[list_price] * (1 - f.[discount]) AS DECIMAL (12, 2)) AS [total_vendido]
FROM   [dbo].[FactOrders] AS f
       INNER JOIN
       [dbo].[DimOrders] AS o
       ON o.[order_key] = f.[order_key]
       INNER JOIN
       [dbo].[DimDate] AS d
       ON d.[date_key] = f.[order_date_key]
       INNER JOIN
       [dbo].[DimProducts] AS p
       ON p.[product_key] = f.[product_key]
       INNER JOIN
       [dbo].[DimCustomers] AS c
       ON c.[customer_key] = f.[customer_key]
       INNER JOIN
       [dbo].[DimStores] AS s
       ON s.[store_key] = f.[store_key]
       INNER JOIN
       [dbo].[DimStaffs] AS st
       ON st.[staff_key] = f.[staff_key];


GO
-- ======================================================================================
-- DASHBOARD DE INVENTARIO
-- ======================================================================================
CREATE OR ALTER VIEW [dbo].[vw_Inventory]
AS
SELECT d.[date] AS [fecha_corte],
       p.[product_id] AS [id_producto],
       p.[product_name] AS [producto],
       p.[brand_id] AS [id_marca],
       p.[brand_name] AS [marca],
       p.[category_id] AS [id_categoria],
       p.[category_name] AS [categoria],
       s.[store_id] AS [id_tienda],
       s.[store_name] AS [tienda],
       s.[city] AS [ciudad_tienda],
       s.[state] AS [estado_tienda],
       ISNULL(f.[quantity], 0) AS [cantidad]
FROM   [dbo].[FactInventory] AS f
       INNER JOIN
       [dbo].[DimDate] AS d
       ON d.[date_key] = f.[snapshot_date_key]
       INNER JOIN
       [dbo].[DimProducts] AS p
       ON p.[product_key] = f.[product_key]
       INNER JOIN
       [dbo].[DimStores] AS s
       ON s.[store_key] = f.[store_key]
WHERE  f.[snapshot_date_key] = (SELECT MAX(i.[snapshot_date_key])
                                FROM   [dbo].[FactInventory] AS i);

GO
