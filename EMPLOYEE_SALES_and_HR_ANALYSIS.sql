create database EMPLOYEE_SALES_and_HR_ANALYSIS;
use EMPLOYEE_SALES_and_HR_ANALYSIS;

-- Q: Fetch top 5 highest-earning employees with performance rating >= 4.

select employee_name, monthly_salary, performance_rating
from employee_sales
where performance_rating >= 4
order by monthly_salary desc
limit 5;

-- Q: Get average sales per region, only for regions with avg > 200,000.
select region,monthly_sales, avg(monthly_sales) as "average_sales"
from employee_sales
group by region, monthly_sales
having avg(monthly_sales)>200000 ;

-- Q: Tag employees as 'Top', 'Average', or 'Low' based on performance_rating.
select employee_name, performance_rating,
case
   when performance_rating >=4 then "Top"
   when performance_rating between 2 and 4 then "Average"
   when performance_rating <=2 then "Low"
else "Negavtive"
end as "Performance"
from employee_sales;

-- Q: Get employees who earn more than the average salary.
select employee_name
from employee_sales
where monthly_salary > (select avg(monthly_sales)
                        from employee_sales);
                        
select * from employee_sales;
select * from department_budgets;
-- Q: Show all departments with sales totals even if they have no employees.

select department, sum(monthly_sales)
from department_budgets
left join employee_sales
on department_budgets.department_id = employee_sales.department_id
group by department;

-- Q: See how each employee ranks in terms of salary within their region.
select region, monthly_salary,
percent_rank() over (partition by region order by monthly_salary) as "rank"
from employee_sales;	

-- Q: Assign RANK to employees by sales within their department.
select employee_id, monthly_sales,
rank() over (partition by department_id order by monthly_sales) as "rank"
from employee_sales;	         
          
select * from employee_sales;
select * from department_budgets;
-- Q: Compare current and previous month's sales (assume sorted by ID).
select employee_id, monthly_sales,
lead(monthly_sales) over (order by employee_id) as "lead",
lag (monthly_sales) over (order by employee_id) as "lag"
from employee_sales;

-- Q: List all departments (with and without duplicates).
select department, department_id from department_budgets
union 
select head_of_department, annual_budget from department_budgets;

select department, department_id from department_budgets
union all
select head_of_department, annual_budget from department_budgets;

select * from employee_sales;
select * from department_budgets;
-- Q: Increase incentive_percent by 5% for top performers (rating = 5)

update employee_sales
set incentive_percent = incentive_percent + (5/100)
where performance_rating=5;

-- Q: Delete employees who haven’t handled any clients (bad data)
delete from employee_sales
where num_clients_handled <10;

-- Q: Add a new column to store if the employee is eligible for promotion.
alter table employee_sales
add column promotion float(50);

select * from employee_sales;
select * from department_budgets;

-- Q: Drop an unnecessary column.
alter table employee_sales
drop column store;

-- Q: Calculate the incentive amount using salary and incentive_percent.

select (monthly_salary+incentive_percent) as "incentive_amount"
from employee_sales;

-- Q: Get employees from departments with budgets over ₹5,000,000.
select * from employee_sales;
select * from department_budgets;

-- Q: Show number of days each employee has worked in the company.
select hire_date,
datediff (curdate(), hire_date) as "number of days"
from employee_sales;

-- Q: Calculate difference between monthly sales and salary.
select (monthly_sales-monthly_salary)
from employee_sales;

-- Q: Calculate total income (salary + incentive) for each employee.

select (monthly_salary + incentive_percent) as "total_income"
from employee_sales;

-- Q: Extract join year and month of hire for each employee.

select year(hire_date), month(hire_date)
from employee_sales;

-- ✅ 7A. CTE: Total Sales Per Department
select Department
from department_budgets
where department_id in (select department_id
					   from employee_sales
					   group by department_id);


select * from employee_sales;
select * from department_budgets;