-- 177. Nth Highest Salary [Medium]
-- https://leetcode.com/problems/nth-highest-salary/
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      # Write your MySQL query statement below.
      select Salary
      from (
          select Salary
                    ,dense_rank() over (order by Salary desc) as r
          from Employee
          ) as nested
      where r = N
      limit 1
  );
END



-- 178. Rank Scores [Medium]
-- https://leetcode.com/problems/rank-scores/submissions/
select Score
        ,dense_rank() over (order by Score desc) as 'Rank'
from Scores
order by Score desc



-- 180. Consecutive Numbers [Medium]
-- https://leetcode.com/problems/consecutive-numbers/
with rn as (
    select Num
            ,lag(Num) over (order by Id) as prev_val
            ,lead(Num) over (order by Id) as next_val
    from Logs
)

select distinct Num as ConsecutiveNums
from rn
where prev_val = next_val
and prev_val = Num



-- 184. Department Highest Salary
-- https://leetcode.com/problems/department-highest-salary/submissions/
with E as (
    select *
            ,max(Salary) over (partition by DepartmentId) as MaxSalaryDep
    from Employee
)

select Department.Name as Department
        ,E.Name as Employee
        ,Salary
from E
left join Department on Department.Id = E.DepartmentId
where Salary = MaxSalaryDep



-- 185. Department Top Three Salaries [Medium]
-- https://leetcode.com/problems/department-top-three-salaries/submissions/
with E as (
    select *
            ,dense_rank() over (partition by DepartmentId order by Salary desc) as RankSalaryDep
    from Employee
)

select Department.Name as Department
        ,E.Name as Employee
        ,Salary
from E
left join Department on Department.Id = E.DepartmentId
where RankSalaryDep <= 3



-- 262. Trips and Users [Hard]
-- https://leetcode.com/problems/trips-and-users/
select Request_at as Day
        ,round(count(case when Status in ('cancelled_by_client', 'cancelled_by_driver') then Id end)/count(*), 2) as 'Cancellation Rate'
from Trips
where Client_Id in (select Users_Id from Users where Banned = 'No')
and Driver_Id in (select Users_Id from Users where Banned = 'No')
and Request_at >= '2013-10-01'
and Request_at <= '2013-10-03'
group by Request_at
order by Request_at



-- 601. Human Traffic of Stadium [Hard]
-- https://leetcode.com/problems/human-traffic-of-stadium/
with breaks as (
    select distinct case when people >= 100 and lag(people) over () < 100 then id 
                when people >= 100 and id = 1 then id end as break_id
    from Stadium
)

,sessions_marked as (
    select id
            ,visit_date
            ,people
            ,max(break_id) as ses_id
    from Stadium s
    left join breaks b on b.break_id <= id
    group by id, visit_date, people
)

,bucket_based as (
    select id
            ,visit_date
            ,people
            ,count(*) over (partition by ses_id) lines_in_bucket
    from sessions_marked
    where people >= 100
)

select id
        ,visit_date
        ,people
from bucket_based
where lines_in_bucket >= 3
order by visit_date



-- 1179. Reformat Department Table [Easy]
-- https://leetcode.com/problems/reformat-department-table/
select id
        ,sum(case when month = 'Jan' then revenue end) as Jan_revenue
        ,sum(case when month = 'Feb' then revenue end) as Feb_revenue
        ,sum(case when month = 'Mar' then revenue end) as Mar_revenue
        ,sum(case when month = 'Apr' then revenue end) as Apr_revenue
        ,sum(case when month = 'May' then revenue end) as May_revenue
        ,sum(case when month = 'Jun' then revenue end) as Jun_revenue
        ,sum(case when month = 'Jul' then revenue end) as Jul_revenue
        ,sum(case when month = 'Aug' then revenue end) as Aug_revenue
        ,sum(case when month = 'Sep' then revenue end) as Sep_revenue
        ,sum(case when month = 'Oct' then revenue end) as Oct_revenue
        ,sum(case when month = 'Nov' then revenue end) as Nov_revenue
        ,sum(case when month = 'Dec' then revenue end) as Dec_revenue
from Department
group by id



-- 197. Rising Temperature [Easy]
-- https://leetcode.com/problems/rising-temperature/submissions/
with t as (
    select *
            ,lag(Temperature) over (order by recordDate) as TemperaturePrev
            ,lag(recordDate) over (order by recordDate) as DatePrev
    from Weather
    )
    
select id
from t
where TemperaturePrev < Temperature
and datediff(recordDate, DatePrev) = 1



-- 196. Delete Duplicate Emails
-- https://leetcode.com/problems/delete-duplicate-emails/submissions/
delete from Person
where id not in (select * from (
        select min(Id)
        from Person
        group by Email
    ) as d
)