-- Employee + department + job
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    j.job_title,
    e.salary
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN jobs j
ON e.job_id = j.job_id;

-- Department salary vs company average
SELECT 
    d.department_name,
    AVG(e.salary) AS department_avg_salary,
    (SELECT AVG(salary) FROM employees) AS company_avg_salary
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
GROUP BY d.department_name;

-- Highest salary employee per department
WITH ranked_employees AS (
SELECT 
employee_id,
first_name,
last_name,
department_id,
salary,
RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) rnk
FROM employees
)
SELECT *
FROM ranked_employees
WHERE rnk = 1;

-- Employees and their managers
SELECT 
e.employee_id,
CONCAT(e.first_name,' ',e.last_name) AS employee_name,
CONCAT(m.first_name,' ',m.last_name) AS manager_name
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.employee_id;

-- Manager headcount
SELECT 
m.employee_id AS manager_id,
CONCAT(m.first_name,' ',m.last_name) AS manager_name,
COUNT(e.employee_id) AS headcount
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id
GROUP BY m.employee_id,m.first_name,m.last_name
ORDER BY headcount DESC;

-- Employee tenure
SELECT 
employee_id,
first_name,
last_name,
hire_date,
ROUND(DATEDIFF(CURDATE(),hire_date)/365,1) AS tenure_years
FROM employees
ORDER BY tenure_years DESC;

-- Employees with multiple job roles
SELECT 
e.employee_id,
e.first_name,
e.last_name,
COUNT(DISTINCT jh.job_id) AS previous_jobs
FROM employees e
JOIN job_history jh
ON e.employee_id = jh.employee_id
GROUP BY e.employee_id,e.first_name,e.last_name
ORDER BY previous_jobs DESC;

-- Salary ranking inside department
SELECT 
employee_id,
first_name,
last_name,
department_id,
salary,
RANK() OVER(
PARTITION BY department_id
ORDER BY salary DESC
) AS salary_rank
FROM employees;

-- Salary quartiles
SELECT 
employee_id,
first_name,
salary,
NTILE(4) OVER(ORDER BY salary DESC) AS salary_quartile
FROM employees;

-- Running total salaries
SELECT 
employee_id,
first_name,
salary,
SUM(salary) OVER(ORDER BY salary) AS running_salary
FROM employees;
