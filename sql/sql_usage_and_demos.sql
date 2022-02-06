-- ## Aggregates
-- Avg, Min, Max, Sum, Count

-- filters must based on agg. computation.
select avg(s.gpa) as avg_gpa, e.cid
from enrolled as e, student as s
where e.sid = s.sid 
group by e.cid 
having avg_gpa > 3.9  -- having这里可以直接用上面算好的变量

-- ## String-matching operators
-- %: any substring
-- _: math any one character

where e.cid LIKE '15-%'
where s.login Like '%@c_'

select substring(name, 0, 5) -- get the first 5 characters

where login = concat(lower(name), '@cs')

-- ## Date/Time operations
-- Demo: Get the # of days since the beginning of the year
select extract(DAY from DATE('2018-08-29')); -- 29, 提取出days的数量

select DATEDIFF(DATE('2018-08-29'), DATE('2018-01-01')) as days;

