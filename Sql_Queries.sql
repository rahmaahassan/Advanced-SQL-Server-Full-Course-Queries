''' Use Company_SD_Full Database '''

-- Display all the employees Data.
select *
from Employee

-- Display the employee First name, last name, Salary and Department number.
select fname, lname, salary, dno
from Employee

-- Display all the projects names, locations and the department which is responsible about it.
select pname, plocation, dnum
from Project

-- If you know that the company policy is to pay an annual commission for each employee
-- with specific percent equals 10% of his/her annual salary. 
-- Display each employee full name and his annual commission in an ANNUAL COMM column (alias).
select fname + ' ' + lname as [Full Nmae], salary*1.2 as [Annual Comm]
from employee

-- Display the Department id, name and id and the name of its manager.
select Dnum, Dname, MGRSSN, Fname
from Employee e inner join Departments d
on e.SSN = d.MGRSSN 

-- Display the name of the departments and the name of the projects under its control.
select dname, pname
from Departments d inner join Project p
on d.Dnum = p.Dnum

-- Display the full data about all the dependence associated with the name of the employee they depend on him/her.
select d.*, fname + ' ' + lname as [Name]
from Employee e inner join Dependent d
on e.SSN = d.ESSN

-- Display the Id, name and location of the projects in Cairo or Alex city.
select pnumber, pname, plocation
from Project
where city = 'cairo' or city = 'alex'

-- Display the Projects full data of the projects with a name starts with "a" letter.
select *
from project
where pname like 'a%'

-- display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select fname + ' ' + lname as [Name]
from Employee
where Dno = 30 and Salary >= 1000 or salary <= 2000

-- Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.
select fname + ' ' + lname as [Name]
from Employee e, Project p, Works_for w
where e.dno = 10 and p.pname = 'Al Rabwah' and 
w.Hours >= 10 and e.SSN = w.ESSn and w.Pno = p.Pnumber

-- Find the names of the employees who directly supervised with Kamel Mohamed.
select x.fname + ' ' + x.lname as [Name]
from Employee x inner join Employee y
on x.Superssn = y.ssn 
where y.Fname = 'Kamel'

-- Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
select e.fname + ' ' + e.lname as [Name], p.pname
from employee e, project p, Departments d
where e.Dno = d.Dnum and p.Dnum = d.Dnum
order by p.pname

-- For each project located in Cairo City , find the project number, the controlling department name,
-- the department manager last name ,address and birthdate.
select p.pnumber, d.dname, e.lname as [Dept Manager Lname], e.address, e.bdate
from Project p, Departments d, Employee e
where p.City = 'cairo' and e.SSN = d.MGRSSN and p.Dnum = d.Dnum

-- Display All Data of the managers
select e.*
from Employee e, Departments d
where e.SSN = d.MGRSSN

-- Display All Employees data and the data of their dependents even if they have no dependents
select e
from Employee e, Dependent d
where d.ESSN = e.SSN

-- Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
insert into Employee values('Rahma', 'Hassan', 102672, '1999-11-21', '23 Maadi', 'F', 3000, 112233, 30)

-- Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but don’t enter any value for salary or supervisor number to him.
insert into Employee (Fname, Lname, SSN, Bdate, Address, Sex, Dno)
values('Rawan', 'Mohsen', 102660, '1999-04-15', '23 Maadi', 'F', 30)

-- Upgrade your salary by 20 % of its last value.
update Employee set Salary = salary * 1.2
where SSN = 102672

-- Display (Using Union Function)
-- The name and the gender of the dependence that's gender is Female and depending on Female Employee.
-- And the male dependence that depends on Male Employee.
SELECT d.dependent_name, d.sex
from Dependent d inner join Employee e
on d.ESSN = e.SSN
where d.Sex = 'f' and e.Sex = 'f'
union all
select d.dependent_name, d.sex
from Employee e inner join Dependent d 
on d.ESSN = e.SSN
where d.Sex = 'm' and e.Sex = 'm'

-- For each project, list the project name and the total hours per week (for all employees) spent on that project.
select p.pname, sum(w.hours)
from Project p inner join Works_for w
on p.Pnumber = w.Pno
group by p.pname

-- Display the data of the department which has the smallest employee ID over all employees' ID.
select *
from Departments
where Dnum in(
select dno
from employee 
where ssn in
(
select min(SSN) 
from Employee 
where dno is not NULL
))

-- For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
select min(e.salary) as min, max(e.salary) as max, avg(e.salary) as average, d.dname
from Employee e inner join Departments d
on e.Dno = d.Dnum
group by d.dname

-- List the full name of all managers who have no dependents.
select fname + ' ' + lname as [Name]
from Employee e inner join Departments d
on e.SSN = d.MGRSSN
except
select e.fname + ' ' + e.lname as [Name]
from Employee e inner join Dependent d
on e.SSN = d.ESSN

-- For each department, if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.
select d.dname, d.dnum, count(e.ssn) as [Number of employee]
from Employee e inner join Departments d
on d.Dnum = e.Dno
group by d.Dname, d.Dnum
having avg(e.Salary)<(select avg(salary) from Employee)

-- Retrieve a list of employees names and the projects names they are working on ordered by department number and within each department, ordered alphabetically by last name, first name.
select e.fname +' '+ e.lname as [Employee Name], p.pname
from Departments d, Employee e, Works_for w, Project p
where d.Dnum=e.Dno and e.ssn=w.essn and w.pno=p.Pnumber
order by d.dname, e.lname, e.fname

-- Try to get the max 2 salaries using subquery
select
(select max(salary)
from Employee) Max1,
(select max(salary)
from Employee
where salary not in (select max(salary) from Employee)) max2

-- Get the full name of employees that is similar to any dependent name
select e.fname +' '+ e.lname as Employee_Name
from Employee e inner join Dependent d
on e.SSN = d.ESSN
where d.Dependent_name = e.Fname+ e.Lname

-- Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.
select fname +' '+ lname as Employee_Name, SSN
from Employee
where exists (select essn from Dependent where essn = SSN)

-- In the department table insert new department called "DEPT IT" , with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'
insert into Departments 
values('IT', 100, 112233, 2006-11-01)

-- Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100), and they give you(your SSN =102672) her position (Dept. 20 manager) 
-- a. First try to update her record in the department table
-- b. Update your record to be department 20 manager.
-- c. Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
update Departments set MGRSSN = 968574
where Dnum = 100

update Departments set MGRSSN = 102672
where Dnum = 20

update Employee set Superssn = 102672
where SSN = 102660

-- Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) so try to delete his data from your database in case you know that you will be temporarily in his position.
-- Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects and handle these cases).

update Employee set Superssn = 102672
where  Superssn = 223344

update Dependent set essn = 102672
where essn = 223344

update Departments set MGRSSN = 102672
where MGRSSN = 223344

delete from Works_for where ESSn = 223344

delete from Employee where ssn = 223344

-- Try to update all salaries of employees who work in Project "Al Rabwah" by 30%
update Employee set salary = salary + salary * 0.3