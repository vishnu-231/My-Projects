create database sql_project;
use sql_project;

-- Table 1: Job Department
CREATE TABLE JobDepartment (
Job_ID INT PRIMARY KEY,
jobdept VARCHAR(50),
name VARCHAR(100),
description TEXT,
salaryrange VARCHAR(50)
);



-- Table 2: Salary/Bonus
CREATE TABLE SalaryBonus (
salary_ID INT PRIMARY KEY,
Job_ID INT,
amount DECIMAL(10,2),
annual DECIMAL(10,2),
bonus DECIMAL(10,2),
CONSTRAINT fk_salary_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(Job_ID)
ON DELETE CASCADE ON UPDATE CASCADE
);


-- Table 3: Employee
CREATE TABLE Employee (
emp_ID INT PRIMARY KEY,
firstname VARCHAR(50),
lastname VARCHAR(50),
gender VARCHAR(10),
age INT,
contact_add VARCHAR(100),
emp_email VARCHAR(100) UNIQUE,
emp_pass VARCHAR(50),
Job_ID INT,
CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
REFERENCES JobDepartment(Job_ID)
ON DELETE SET NULL
ON UPDATE CASCADE
);


-- Table 4: Qualification
CREATE TABLE Qualification (
QualID INT PRIMARY KEY,
Emp_ID INT,
Position VARCHAR(50),
Requirements VARCHAR(255),
Date_In DATE,
CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
REFERENCES Employee(emp_ID)
ON DELETE CASCADE
ON UPDATE CASCADE
);


-- Table 5: Leaves
CREATE TABLE Leaves (
leave_ID INT PRIMARY KEY,
emp_ID INT,
date DATE,
reason TEXT,
CONSTRAINT fk_leave_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
ON DELETE CASCADE ON UPDATE CASCADE
);


-- Table 6: Payroll
CREATE TABLE Payroll (
payroll_ID INT PRIMARY KEY,
emp_ID INT,
job_ID INT,
salary_ID INT,
leave_ID INT,
date DATE,
report TEXT,
total_amount DECIMAL(10,2),
CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_payroll_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(job_ID)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_payroll_salary FOREIGN KEY (salary_ID) REFERENCES
SalaryBonus(salary_ID)
ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_payroll_leave FOREIGN KEY (leave_ID) REFERENCES Leaves(leave_ID)
ON DELETE SET NULL ON UPDATE CASCADE
);


select * from jobdepartment;
select * from salarybonus;
select * from employee;
select * from qualification;
select * from leaves;
select * from payroll;

# Analysis Questions
# 1. EMPLOYEE INSIGHTS
 #a.How many unique employees are currently in the system?
 #b.Which departments have the highest number of employees?
 #c.What is the average salary per department?
 #d.Who are the top 5 highest-paid employees?
 #e.What is the total salary expenditure across the company?
 
#a.How many unique employees are currently in the system?
 select distinct count(concat_ws(',',firstname,lastname)) as fullname  from employee;
 
 select * from employee;
 
 #b.Which departments have the highest number of employees?    
 select jobdept, count(jobdept) as dp from employee e      
 inner join jobdepartment j
 on e.Job_ID=j.Job_ID
 group by jobdept                     ## here i'm joining (inner join) for employee and jobdepartment table for department name
 order by dp desc
 limit 1;
 
 #c #c.What is the average salary per department?
 
 select j.jobdept,
 avg(s.amount) as avg_amount_per_month,
 avg(s.annual)  as avg_amount_per_year
 from employee e
 inner join salarybonus s
 on s.Job_ID=e.Job_ID
 inner join jobdepartment j
 on s.Job_ID=e.Job_ID
 group by j.jobdept;
 
 select * from payroll;
 select * from salarybonus;
 select * from salarybonus;
  #d.Who are the top 5 highest-paid employees?
  select concat_ws(',',e.firstname,e.lastname) as full_name,
  p.total_amount as  salary
  from employee e
  inner join payroll p
  on e.emp_ID=p.emp_ID
  order by salary desc;
  
  
 #e.What is the total salary expenditure across the company?


#2. JOB ROLE AND DEPARTMENT ANALYSIS 
#a How many different job roles exist in each department?
#b What is the average salary range per department?
#c Which job roles offer the highest salary?
#d Which departments have the highest total salary allocation?

#aHow many different job roles exist in each department?
select jobdept,count(name)
from jobdepartment
group by jobdept;


#b What is the average salary range per department?
select jobdept,avg(salaryrange)
from jobdepartment
group by jobdept;

#c Which job roles offer the highest salary?
select 
j.Job_ID,
j.name,
p.total_amount as salary
from jobdepartment j
inner join payroll p
on j.Job_ID=p.emp_ID
order by salary desc ;

#d Which departments have the highest total salary allocation?
select 
j.jobdept,
sum(p.total_amount) as salary_by_dep
from jobdepartment j
inner join payroll p
on j.job_ID=p.job_ID
group by j.jobdept 
order by salary_by_dep desc;

#3. QUALIFICATION AND SKILLS ANALYSIS
#a How many employees have at least one qualification listed?
#b Which positions require the most qualifications?
#c Which employees have the highest number of qualifications?


#a How many employees have at least one qualification listed?
select count( Requirements  is not null) from qualification;

#b Which positions require the most qualifications?
SELECT Position, COUNT(QualID) AS total_requirements
FROM Qualification
GROUP BY Position
ORDER BY total_requirements DESC;


#c Which employees have the highest number of qualifications?
SELECT CONCAT_WS(' ', e.firstname, e.lastname) AS emp_name,
       COUNT(q.QualID) AS total_qualifications
FROM Employee e
INNER JOIN Qualification q ON e.emp_ID = q.Emp_ID
GROUP BY e.emp_ID
ORDER BY total_qualifications DESC
LIMIT 5;


## 4. LEAVE AND ABSENCE PATTERNS
#a● Which year had the most employees taking leaves?
#b● What is the average number of leave days taken by its employees per department?
#c● Which employees have taken the most leaves?
#d● What is the total number of leave days taken company-wide?
#e● How do leave days correlate with payroll amounts?

#a● Which year had the most employees taking leaves?
select year(date),count(leave_ID) 
from leaves
group by year(date);

#b● What is the average number of leave days taken by its employees per department?
select j.jobdept,avg(l.leave_ID)
from leaves l
inner join jobdepartment j
on l.emp_ID=j.job_ID
group by j.jobdept;

#c● Which employees have taken the most leaves?
select concat_ws('-',firstname,lastname) as emp_name,count(l.leave_ID) as total_leaves
from employee e
inner join leaves l
on l.emp_ID=e.emp_ID
group by emp_name;

#d● What is the total number of leave days taken company-wide?
SELECT COUNT(*) AS total_leave_days
FROM Leaves;

#e● How do leave days correlate with payroll amounts?
select p.total_amount as payroll_amount,count(l.leave_ID) as total_leaves
from leaves l
inner join payroll p
on l.emp_ID=p.emp_ID
group by p.total_amount 
order by total_leaves desc;

#5.PAYROLL AND COMPENSATION ANALYSIS
#a ● What is the total monthly payroll processed?
#b ● What is the average bonus given per department?
#c ● Which department receives the highest total bonuses?
#d ● What is the average value of total_amount after considering leave deductions?

#a ● What is the total monthly payroll processed?
select count(emp_ID) as total_employees ,sum(total_amount) as total_payroll_to_employees from payroll;

#b ● What is the average bonus given per department?
select j.jobdept,round(avg(s.bonus),2)
from jobdepartment j
inner join salarybonus s
on s.job_ID=j.job_ID
group by j.jobdept;

#c ● Which department receives the highest total bonuses?
select j.jobdept,round(sum(s.bonus),2) as total_bonus
from jobdepartment j
inner join salarybonus s
on s.job_ID=j.job_ID
group by j.jobdept
order by total_bonus desc;

#d ● What is the average value of total_amount after considering leave deductions?
select 
avg(s.amount) as before_deduction,
avg(p.total_amount) as after
from salarybonus s
inner join payroll p
on p.salary_ID=s.salary_ID;

#6. EMPLOYEE PERFORMANCE AND GROWTH
#a● Which year had the highest number of employee promotions?
select count(s.bonus) as total_bonu_in_year,
year(p.date)
from salarybonus s
inner join payroll p
on s.salary_ID=p.salary_ID
group by year(date);




select * from jobdepartment;
select * from salarybonus;
select * from employee;
select * from qualification;
select * from leaves;
select * from payroll;






 
 




