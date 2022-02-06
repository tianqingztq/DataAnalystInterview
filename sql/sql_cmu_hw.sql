-- hw site: https://15445.courses.cs.cmu.edu/fall2021/homework1/
-- answered by TianqingZ, Feb/5/2022

--  ## Q2 [5 POINTS] (Q2_STRING_FUNCTION)
--  Get all unique ShipNames from the Order table that contain a hyphen

--  Detail: In addition, get all the characters preceding the (first) hyphen
--  Return ship names alphabetically. Your first row should look like this
--  Bottom-Dollar Markets|Bottom
SELECT
distinct ShipNames
,substr(ShipName, 0, instr(ShipName, '-')) as PreHyphen  -- INSTR() function returns the position of the first occurrence of a string in another string
from Order
where ShipNames like '%-%'
order by ShipNames ASC
;


-- ## Q3
-- Tag orders based on if their ShipCountry is in North America.
-- For our purposes, this is only 'USA', 'Mexico', and 'Canada'\

-- Detail: You should print the Order Id, ShipCountry, and another column
-- that is either 'NorthAmerica' or 'OtherPlace' depending on the Ship Country.
-- Order by the primary key (Id) ascending
-- Return 20 rows starting Order Id 15445
-- Your output should look like:
-- 15445|France|OtherPlace
SELECT
    Id
    ,ShipCountry
    ,case when ShipCountry in ("USA", "Mexico", "Canada")
    then "NorthAmerica"
    else "OtherPlace" end
from order
where id > 15445
order by id ASC
limit 20
;


-- ## Q4
-- Find the percent rate which orders are late, for each of the different shippers.
-- An order is considered late if ShippedDate > RequiredDate

-- Details: Print the following format, order by descending rate, rounded
-- to the nearest hundredths
-- United Package|23.44
select 
CompanyName
,round(
    sum(
    case when ShippedDate > RequiredDate then 1 else 0 end
    ) / count(1) * 100, 2
    ) as late_rate
from Order
inner join Shipper on Order.ShipVia = Shipper.ShipVia
group by Order.ShipVia
order by late_rate DESC
;


-- ## Q5
-- Compute some statistics about categories of products

-- Details: Get the number of products, average unit price (rounded to 2 decimal places), 
-- minimum unit price, maximum unit price, and total units on order for
-- categories containing greater than 10 products
-- Order by Category Id.
-- Your output should look like this:
-- Beverages|12|37.98|4.5|263.5|60
select 
CategoryName
,count(1) as num_products
,round(AVG(UnitPrice) ,2) as avg_uprice
,min(UnitPrice)
,max(UnitPrice)
,sum(QuantityPerUnit)
from 
Product
inner join Category 
on CategoryId = Category.Id
group by CategoryId
having count(distinct ProductName) > 10 
-- or: having num_products > 10
order by CategoryId
;


-- ## Q6
-- For each of the 8 discontinued products in the database, what is the customer's 
-- company name and contact name of the first order ever made for this product?
-- Output the customer's CompanyName and ContactName

-- Details: Print the following format, order by product name alphabetically
-- Alice Mutton|Consolidated Holdings|Elizabeth Brown
select ProductName, CompanyName, ContactName
from(
    select
    ProductName
    ,min(OderDate)   -- to get the first order
    ,CompanyName
    ,ContactName
    from
    (
        select 
        Id as pid, ProductName
        from product a
        where Discontinued = 1
    ) a
    inner join Orderdetail on a.pid = Orderdetail.ProductId
    inner join Order on Orderdetail.Id = Order.Id
    inner join Customer on Order.CustomerId = Customer.Id
    group by pid -- group by the product
)
group by ProductName ASC
;


-- ## Q7 ## !!!!
-- [HARD]
-- For the first 10 orders by CutomerId BLONP: 
-- get the Order Id, OrderDate, previous order date, and difference between the two order dates
-- return results ordered by OrderDate (ascending)

-- Detail: The previous order date for the first order should default to itself (lag time = 0) 
-- use julianday function for date arithmetic (e.g. https://stackoverflow.com/questions/289680/difference-between-2-dates-in-sqlite)
-- use lag(expr, offset, default) for grabbing previous dates https://www.sqlite.org/windowfunctions.html
-- Please round the lag time to the nearest hundredth
-- One of your rows should look like this:
-- 17361|2012-09-19 12:13:21|2012-09-18 22:37:15|0.57
select
Id
,OrderDate
,PrevOrderDate
,DATEDIFF(date(OrderDate) - date(PrevOrderDate))  -- using mysql here
from (
    select
    Id
    ,OrderDate
    ,lag(OrderDate，1, OrderDate) over (order by OrderDate ASC) as PrevOrderDate
    -- If default is also provided, then it is returned instead of NULL if the row identified by offset does not exist.
    from Order
    where CutomerId = 'BLONP'
    order by OrderDate ASC
    limit 10
)
;


-- ## Q8
-- [HARD]
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
select
CompanyName
,CustomerId
,total_expenditures
from (
    select
    CompanyName
    ,CustomerId
    ,total_expenditures
    ,ntile(4) over (order by total_expenditures ASC) as ExpenditureQuartile
    -- This function divides the partition into N groups as evenly as possible 
    -- and assigns an integer between 1 and N to each group, 
    -- in the order defined by the ORDER BY clause
    from (
        select 
        ifnull(CompanyName, 'MISSING_NAME') as CompanyName
        ,Order.CustomerId as CustomerId
        ,round(sum(Orderdetail.UnitPrice * Orderdetail.Quantity), 2) as total_expenditures
        from Order
        left join Customer on Order.CustomerId = Customer.Id
        inner join Orderdetail on Order.Id = Orderdetail.OrderId
        group by Order.CustomerId
    ) 
)
where ExpenditureQuartile = 1
Order by total_expenditures ASC
;


-- Or: with the with structure
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


-- ## Q9
-- Find the youngest employee serving each Region. If a Region is not served by
-- an employee, ignore it.

-- Details: Print the following format, order by Region Id
-- Region Description|FirstName|LastName|Birthdate, your first row should look like
-- Eastern|Steven|Buchanan|1987-03-04


SELECT RegionDescription, FirstName, LastName, bday
FROM 
(
  SELECT RegionId AS rid, MAX(Employee.Birthdate) AS bday 
  FROM Employee
    INNER JOIN EmployeeTerritory ON Employee.Id = EmployeeTerritory.EmployeeId
    INNER JOIN Territory ON TerritoryId = Territory.Id
  GROUP BY RegionId
)
INNER JOIN (
            SELECT FirstName, LastName, Birthdate, RegionId, EmployeeId
            FROM Employee
              INNER JOIN EmployeeTerritory ON Employee.Id = EmployeeTerritory.EmployeeId
              INNER JOIN Territory ON TerritoryId = Territory.Id
           )
           ON Birthdate = bday AND rid = RegionId
INNER JOIN Region ON Region.Id = RegionId
GROUP BY EmployeeId
ORDER BY rid;


-- ## Q10
-- Concatenate the ProductNames ordered by the Company 'Queen Cozinha' between
-- 2014-12-25 and 2014-12-26, print this as a string of
-- comma-separated values(like "Mishi Kobe Niku, NuNuCa Nuß-Nougat-Creme...")

-- Details: Find all Products ordered by the Company 'Queen Cozinha' between
-- 2014-12-25 and 2014-12-26 and order them by id (ascending).
-- Print a single string containing all the dup names separated by commas.   
-- Hint: You might find Recursive CTEs useful.


with product as (
    select 
    Product.Id, Product.ProductName as name
    from Customer
    inner join Order on Customer.Id = Order.CustomerId
    inner join Orderdetail on Product.id = OrderDetail.ProductId
    inner join Product on Product.id = Orderdetail.OrderId
    where CompanyName = 'Queen Cozinha'
    and date(DateOrderDate) = '2014-12-25'
    group by Product.Id
),
c as (
      select row_number() over (order by p.id asc) as seqnum, p.name as name
      from p
),
flattened as (
    select seqnum, name
    from c
    where seqnum = 1
    union all
    select c.seqnum, f.name || ',' || c.name
    from c join 
    flattened f
    on c.seqnum = f.seqnum + 1
)
select name from flattened
order by seqnum desc limit 1;









