-- 182. Duplicate Emails [Easy]
-- https://leetcode.com/problems/duplicate-emails/

select Email
from Person
group by Email
having count(*) > 1


-- 181. Employees Earning More Than Their Managers [Easy]
-- https://leetcode.com/problems/employees-earning-more-than-their-managers/

select e1.Name as Employee
from Employee e1
left join Employee e2 on e2.Id = e1.ManagerId
where e1.Salary > e2.Salary


-- 183. Customers Who Never Order [Easy]
-- https://leetcode.com/problems/customers-who-never-order/

select c.Name as Customers
from Customers c
where c.Id not in (select CustomerId from Orders)