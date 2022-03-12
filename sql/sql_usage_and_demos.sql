-- ## Aggregates
-- Avg, Min, Max, Sum, Count

-- filters must based on agg. computation.
select avg(s.gpa) as avg_gpa, e.cid
from enrolled as e, student as s
where e.sid = s.sid 
group by e.cid 
having avg_gpa > 3.9;  -- having这里可以直接用上面算好的变量

-- ## String-matching operators
-- %: any substring
-- _: math any one character
where e.cid LIKE '15-%';
where s.login Like '%@c_';
-- SUBSTRING
select substring(name, 0, 5); -- get the first 5 characters
-- CONCAT STRINGS
where login = concat(lower(name), '@cs');

-- ## Date/Time operations
-- Demo: Get the # of days since the beginning of the year
select extract(DAY from DATE('2018-08-29')); -- 29, 提取出days的数量

select DATEDIFF(DATE('2018-08-29'), DATE('2018-01-01')) as days;

-- ## Store query results in another table:
-- Table must not already be definded
-- Table will have the same # of columns with the same types as the input
CREATE TABLE if not exists CourseIds (
    SELECT DISTINCT cid
    FROM enrolled
);

-- If the table exits:
INSERT INTO CourseIds (
    SELECT DISTINCT cid
    FROM enrolled
);

-- ## Order: ASC - default/ DESC

-- ## limit & offset
select ...
from ...
order by xxx
limit 20 
offset 10  -- to return a "range"
;


-- ## Nested Queries
-- 1. get the names of students in '15-445'
select name from student
where sid in (
    select sid from enrolled  -- get all the enrolled student id
    where cid = '15-445'
);

-- or:
select (
    select s.name 
    from student as s
    where s.sid = e.sid
) as sname
from enrolled as e
where cid = '15-445'
;

-- 2. Find student record with the highest id that is enrolled in at least one course
select sid, name
from student
where sid => all( -- should greater than every other sid in our table
    select sid 
    from enrolled
);

-- or:
select sid, name
from student
where sid in (  -- match from the max sids
    select max(sid)
    from enrolled
);

-- or:
select sid, name
from student
where sid in (
    select sid
    from enrolled
    order by sid DESC  -- order and get the first 1
    limit 1
);

-- 3. Find all courses that has no students enrolled in it
select *
from course
where cid not in (
    select DISTINCT cid
    from enrolled
);

select *
from course
where not exits (
    select *
    from enrolled
    where course.cid = enrolled.cid
);

-- ## Window functions

-- row_number()  # of the current row; 1,2,3
-- rarnk()  order position of the current row; 1,1,3
-- dense_rank()  1,1,2

select cid, sid
,row_number() over (partition by cid)
from enrolled
order by cid
;

select *, row_number() over (order by cid)
from enrolled
order by cid
;

-- demo: find the student with the highest grade for each course
select
*
from (
    *
    ,rank() over (partition by cid order by grade DESC) as rn
) as rank
where rank.rn = 1;

-- ## CTE
with cteName as(
    select 1
)
select * from cteName
;

-- ## CTE - recursion
with recursive cteSource (counter) as (
    (select 1)
    union all
    (select counter + 1  -- add from 1 to 9
    from cteSource
    where counter < 10)
)
select * from cteSource  -- print 1 to 9
;



