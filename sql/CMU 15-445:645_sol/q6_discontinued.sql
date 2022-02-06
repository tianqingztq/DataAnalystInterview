-- Of 8 discontinued products in the database, what is the customer's 
-- company name and contact name of the first order ever made for this product?

-- Details: Print the following format, order by product name alphabetically
-- Alice Mutton|Consolidated Holdings|Elizabeth Brown


SELECT pname, CompanyName, ContactName
FROM (
      SELECT pname, min(OrderDate), CompanyName, ContactName
      FROM (
            SELECT Id AS pid, ProductName AS pname 
            FROM Product 
            WHERE Discontinued != 0
           ) as discontinued
      INNER JOIN OrderDetail on ProductId = pid
      INNER JOIN 'Order' on 'Order'.Id = OrderDetail.OrderId
      INNER JOIN Customer on CustomerId = Customer.Id
      GROUP BY pid
    )
ORDER BY pname ASC;

-- Answer:
-- Alice Mutton|Consolidated Holdings|Elizabeth Brown
-- Chef Anton's Gumbo Mix|Piccolo und mehr|Georg Pipps
-- Guaraná Fantástica|Piccolo und mehr|Georg Pipps
-- Mishi Kobe Niku|Old World Delicatessen|Rene Phillips
-- Perth Pasties|Piccolo und mehr|Georg Pipps
-- Rössle Sauerkraut|Piccolo und mehr|Georg Pipps
-- Singaporean Hokkien Fried Mee|Vins et alcools Chevalier|Paul Henriot
-- Thüringer Rostbratwurst|Piccolo und mehr|Georg Pipps
