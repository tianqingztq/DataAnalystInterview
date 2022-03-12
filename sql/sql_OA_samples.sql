-- Wayfair
-- https://www.1point3acres.com/bbs/thread-817110-1-1.html
-- 1. total number of tickets reserved for each play
select 
    a.play_id as id
    ,b.title as title
    ,count(a.id) as reserved_tickets
from reservations a
left join plays b
on a.play_id = b.id
group by a.olay_id
;

-- Recruiting problem
-- https://www.1point3acres.com/bbs/forum.php?mod=viewthread&tid=850724&ctid=234588
select 
    experience as exp
    , sum(is_max) as max
    , count(id) as count

from (
    select 
        *
        , case 
            when (sql is NULL or sql == 100) 
            and (algo is NULL or algo == 100)
            and (bug_fixing is NULL or bug_fixing == 100) 
            then 1
            else 0
        end as is_max
    from assessments
) a
group by experience
;


