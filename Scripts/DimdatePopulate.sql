-- ======================================================================================
-- POBLADO DE LA DIMENSIÓN DE FECHAS: BikeStoresDW.dbo.DimDate
-- ======================================================================================
/*
    Genera una fila por día de 2016 a 2018.
*/
USE [BikeStoresDW];


GO
SET NOCOUNT ON;

DECLARE @StartDate AS DATE = '2016-01-01';

DECLARE @EndDate AS DATE = '2019-01-01';

DECLARE @CurrentDate AS DATE = @StartDate;

WHILE @CurrentDate < @EndDate
    BEGIN
        IF NOT EXISTS (SELECT 1
                       FROM   [dbo].[DimDate]
                       WHERE  [date_key] = CONVERT (INT, CONVERT (CHAR (8), @CurrentDate, 112)))
            BEGIN
                INSERT INTO [dbo].[DimDate] (
                    [date_key],
                    [date],
                    [day_of_month],
                    [day_name],
                    [week_of_year],
                    [month],
                    [month_name],
                    [quarter],
                    [year],
                    [month_year],
                    [is_weekday]
                )
                SELECT CONVERT (INT, CONVERT (CHAR (8), @CurrentDate, 112)),
                       @CurrentDate,
                       DATEPART(DD, @CurrentDate),
                       DATENAME(DW, @CurrentDate),
                       DATEPART(WW, @CurrentDate),
                       DATEPART(MM, @CurrentDate),
                       DATENAME(MM, @CurrentDate),
                       DATEPART(QQ, @CurrentDate),
                       DATEPART(YY, @CurrentDate),
                       LEFT (
                           DATENAME (
                               MM,
                               @CurrentDate
                           ),
                           3
                       ) + '-' + CONVERT (VARCHAR (4), DATEPART(YY, @CurrentDate)),
                       CASE WHEN DATEPART(DW, @CurrentDate) IN (
                           1,
                           7
                       ) THEN 0 ELSE 1 END;
            END
        SET @CurrentDate = DATEADD(DD, 1, @CurrentDate);
    END


GO
