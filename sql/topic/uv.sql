-- room_id|user_id|start_time|end_time
select 
    room_id,
    max(uv) as max_user_num

(
    select 
        room_id,
        flag_time,
        sum(flag) over(partition by room_id order by flag_time) uv
    from
    (
        select
            room_id,
            start_time as flag_time,
            1 as flag
        from temp
        union all
        select
            room_id,
            end_time as flag_time,
            -1 as flag
        from temp
    ) a
) b
