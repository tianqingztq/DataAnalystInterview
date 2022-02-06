-- Find the percent rate which orders are late, for each of the different shippers.
-- An order is considered late if ShippedDate > RequiredDate

-- Details: Print the following format, order by descending rate, rounded
-- to the nearest hundredths
-- United Package|23.44

SELECT CompanyName, round(delayCnt * 100.0 / cnt, 2) AS pct
FROM (
      SELECT ShipVia, COUNT(*) AS cnt 
      FROM 'Order'
      GROUP BY ShipVia
     ) AS totalCnt
INNER JOIN (
            SELECT ShipVia, COUNT(*) AS delaycnt 
            FROM 'Order'
            WHERE ShippedDate > RequiredDate 
            GROUP BY ShipVia
           ) AS delayCnt
          ON totalCnt.ShipVia = delayCnt.ShipVia
INNER JOIN Shipper on totalCnt.ShipVia = Shipper.Id
ORDER BY pct DESC;

-- Answer:
-- Federal Shipping|23.61
-- Speedy Express|23.46
-- United Package|23.44
