-- For the first 10 orders by CutomerId BLONP: get the Order Id, OrderDate, previous order date, and difference between the two order dates
-- return results ordered by OrderDate (ascending)

-- Detail: The previous order date for the first order should default to itself (lag time = 0) 
-- use julianday function for date arithmetic (e.g. https://stackoverflow.com/questions/289680/difference-between-2-dates-in-sqlite)
-- use lag(expr, offset, default) for grabbing previous dates https://www.sqlite.org/windowfunctions.html
-- Please round the lag time to the nearest hundredth
-- One of your rows should look like this:
-- 17361|2012-09-19 12:13:21|2012-09-18 22:37:15|0.57

SELECT
     Id
     , OrderDate
     , PrevOrderDate
     , ROUND(julianday(OrderDate) - julianday(PrevOrderDate), 2)
FROM (
     SELECT Id
          , OrderDate
          , LAG(OrderDate, 1, OrderDate) OVER (ORDER BY OrderDate ASC) AS PrevOrderDate
     FROM 'Order' 
     WHERE CustomerId = 'BLONP'
     ORDER BY OrderDate ASC
     LIMIT 10
);

-- Answer: 
-- 16766|2012-07-22 23:11:15|2012-07-22 23:11:15|0.0
-- 10265|2012-07-25|2012-07-22 23:11:15|2.03
-- 12594|2012-08-16 12:35:15|2012-07-25|22.52
-- 20249|2012-08-16 16:52:23|2012-08-16 12:35:15|0.18
-- 20882|2012-08-18 19:11:48|2012-08-16 16:52:23|2.1
-- 18443|2012-08-28 05:34:03|2012-08-18 19:11:48|9.43
-- 10297|2012-09-04|2012-08-28 05:34:03|6.77
-- 11694|2012-09-17 00:27:14|2012-09-04|13.02
-- 25613|2012-09-18 22:37:15|2012-09-17 00:27:14|1.92
-- 17361|2012-09-19 12:13:21|2012-09-18 22:37:15|0.57
