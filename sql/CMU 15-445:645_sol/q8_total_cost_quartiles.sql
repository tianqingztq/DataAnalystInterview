-- For each Customer, get the CompanyName, CustomerId, and "total expenditures".
-- Output the bottom quartile of Customers, as measured by total expenditures.

-- Details:
-- Calculate expenditure using UnitPrice and Quantity (ignore Discount).
-- Compute the quartiles for each company's total expenditures using NTILE.
-- (https://www.sqlitetutorial.net/sqlite-window-functions/sqlite-ntile/)
-- The bottom quartile is the 1st quartile, order them by increasing expenditure.

-- Note that there are orders for CustomerIds that don't appear in the Customer table.
-- You should still consider these "Customers" and output them. 
-- If the CompanyName is missing, override the NULL to 'MISSING_NAME' using IFNULL.

-- Make sure your output is formatted as follows (round expenditure to nearest hundredths):
-- Bon app|BONAP|4485708.49

WITH expenditures AS (
    SELECT
        IFNULL(c.CompanyName, 'MISSING_NAME') AS CompanyName,
        o.CustomerId,
        ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS TotalCost
    FROM 'Order' AS o
    INNER JOIN OrderDetail od on od.OrderId = o.Id
    LEFT JOIN Customer c on c.Id = o.CustomerId
    GROUP BY o.CustomerId
),
quartiles AS (
    SELECT *, NTILE(4) OVER (ORDER BY TotalCost ASC) AS ExpenditureQuartile
    FROM expenditures
)
SELECT CompanyName, CustomerId, TotalCost
FROM quartiles
WHERE ExpenditureQuartile = 1
ORDER BY TotalCost ASC

-- Answer:
-- MISSING_NAME|DUMO|1615.9
-- MISSING_NAME|OCEA|3460.2
-- MISSING_NAME|ANTO|7515.35
-- MISSING_NAME|QUEE|30226.1
-- Trail's Head Gourmet Provisioners|TRAIH|3874502.02
-- Blondesddsl père et fils|BLONP|3879728.69
-- Around the Horn|AROUT|4395636.28
-- Hungry Owl All-Night Grocers|HUNGO|4431457.1
-- Bon app|BONAP|4485708.49
-- Bólido Comidas preparadas|BOLID|4520121.88
-- Galería del gastrónomo|GALED|4533089.9
-- FISSA Fabrica Inter. Salchichas S.A.|FISSA|4554591.02
-- Maison Dewey|MAISD|4555931.37
-- Cactus Comidas para llevar|CACTU|4559046.87
-- Spécialités du monde|SPECD|4571764.89
-- Magazzini Alimentari Riuniti|MAGAA|4572382.35
-- Toms Spezialitäten|TOMSP|4628403.36
-- Split Rail Beer & Ale|SPLIR|4641383.53
-- Santé Gourmet|SANTG|4647668.15
-- Morgenstern Gesundkost|MORGK|4676234.2
-- White Clover Markets|WHITC|4681531.74
-- La corne d'abondance|LACOR|4724494.22
-- Victuailles en stock|VICTE|4726476.33
-- Lonesome Pine Restaurant|LONEP|4735780.66
