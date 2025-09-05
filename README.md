SQL Project: Employee & Payroll Management System
1. Project Overview & Objective
This project's primary goal was to design and implement a complete Employee and Payroll Management System using SQL. The system was built from the ground up, starting with raw data and culminating in a functional database that could be queried for valuable business insights. The key objectives were to:

Design a normalized relational database schema capable of managing employee, payroll, and HR-related data.

Establish a robust data pipeline to import, clean, and load real-world data from external sources (Excel files) into MySQL tables.

Enforce data integrity using primary keys, foreign keys, and various constraints to maintain data accuracy and reliability.

Develop and execute a suite of complex SQL queries to generate actionable business intelligence for strategic decision-making in human resources and finance.

2. Database Design & Implementation
The database was designed with a focus on normalization to reduce data redundancy and improve data integrity. The schema consists of six main tables, each serving a specific function:

JobDepartment: Stores static information about job roles, salary ranges, and department names.

Primary Key: job_id

SalaryBonus: Manages salary and bonus information, separated from employee details for better scalability.

Primary Key: salary_id

Employee: The central table containing core employee details, including personal information and references to other tables.

Primary Key: employee_id

Foreign Keys: References job_id (from JobDepartment), salary_id (from SalaryBonus).

Constraints: UNIQUE constraint on email to prevent duplicate entries.

Qualification: Links employees to their qualifications, supporting a many-to-many relationship.

Primary Key: qualification_id

Foreign Key: References employee_id.

Leaves: Records employee leave requests, including reasons and dates.

Primary Key: leave_id

Foreign Key: References employee_id.

Payroll: Stores monthly payroll records, including gross pay, deductions, and net pay.

Primary Key: payroll_id

Foreign Key: References employee_id.

Key Constraints & Relationships:

Relationships were defined using Foreign Keys with ON DELETE CASCADE and ON UPDATE CASCADE to ensure that related records are automatically managed when a primary key is changed or deleted. For example, if an employee is removed, all their associated leave, payroll, and qualification records are also deleted, maintaining consistency. An ON DELETE SET NULL was also used on certain columns where the related data was not critical for the record's existence.

3. Data Analysis & Insights via SQL Queries
A wide range of queries was executed to transform raw data into valuable business insights. This section highlights the types of analysis performed:

Employee & Workforce Insights
COUNT(DISTINCT employee_id): Determined the total number of unique employees in the company.

GROUP BY & HAVING: Identified departments with the highest workforce and calculated the average salary per department.

ORDER BY & LIMIT: Found the top 5 highest-paid employees to identify top talent.

SUM(salary): Calculated the total company salary expenditure to help with budget planning.

Job Role & Department Analysis
COUNT(job_role) grouped by department_name: Analyzed the distribution of job roles across departments.

MIN(salary), MAX(salary): Identified salary ranges within each department.

JOIN Operations: Connected JobDepartment and SalaryBonus tables to identify the highest-paying job roles across the organization.

Leave & Absence Patterns
COUNT(leave_id) grouped by YEAR(start_date): Analyzed leave trends over time.

AVG(DATEDIFF(end_date, start_date)): Calculated the average leave days per department.

CORRELATION: Used joins to correlate leave days with payroll amounts to investigate the financial impact of employee absences.

Payroll & Compensation Analysis
SUM(total_salary): Calculated the total monthly payroll for the company.

JOIN & AVG(bonus): Analyzed average bonus amounts by department to understand compensation fairness and distribution.

Subqueries: Compared payroll amounts before vs. after deductions to understand the impact of taxes and other withholdings on net pay.

4. Tools & Technologies
SQL (MySQL): Utilized for database schema creation, data manipulation, and complex querying.

MySQL Workbench / Command-Line Interface (CLI): Used for visual schema design, running queries, and managing the database.

Microsoft Excel: Served as the initial data source for raw datasets, which were then cleaned and imported.

5. Final Result & Business Impact
The project successfully simulated a real-world HR & Payroll system, demonstrating strong proficiency in database design, data handling, and SQL-based analysis. The generated insights—from salary expenditure and leave patterns to employee growth and qualifications—are directly applicable to business decision-making, such as workforce planning, budget optimization, and talent management. The project serves as a robust example of leveraging SQL to transform raw data into a strategic asset.
