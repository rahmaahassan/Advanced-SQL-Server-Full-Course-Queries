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


'''Use AdventureWorks DB'''

-- Display the SalesOrderID, ShipDate of the SalesOrderHeader table (Sales schema) to show SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’
Select SalesOrderID, ShipDate
from sales.SalesOrderHeader
where OrderDate between '07-29-2002' and '07-28-2014'

-- Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
select ProductID, Name
from Production.Product
where StandardCost < 110.00

-- Display ProductID, Name if its weight is unknown
select ProductID, Name
from Production.Product
where Weight is NULL

-- Display all Products with a Silver, Black, or Red Color
select ProductID, Name
from Production.Product
where Color in ('red', 'silver', 'black')

-- Display any Product with a Name starting with the letter B
select ProductID, Name
from Production.Product
where name like 'B%'

--Run the following Query
--UPDATE Production.ProductDescription
--SET Description = Chromoly steel_High of defects
--WHERE ProductDescriptionID = 3
--Then write a query that displays any Product description with underscore value in its description
update Production.ProductDescription
set Description = 'Chromoly steel_high of defects'
where ProductDescriptionID = 3

select Description
from Production.ProductDescription
where Description like '%[_]%'

-- Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader table for the period between  '7/1/2001' and '7/31/2014'
select sum(TotalDue) TotalDue
from Sales.SalesOrderHeader
where OrderDate between '07-01-2001' and '07-031-2014'

-- Display the Employees HireDate (note no repeated values are allowed)
select distinct HireDate
from HumanResources.Employee

-- Calculate the average of the unique ListPrices in the Product table
select avg(distinct ListPrice) Average
from Production.Product

-- Display the Product Name and its ListPrice within the values of 100 and 120 the list should has the following format "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)
select Name, ListPrice
from Production.Product
where ListPrice between 100 and 200
order by ListPrice

-- a)	 Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.Store table  in a newly created table named [store_Archive]
--Note: Check your database to see the new table and how many rows in it?
--b)	Try the previous query but without transferring the data? 
select rowguid, Name, SalesPersonID, Demographics into sales.Store_Archive
from Sales.Store

select rowguid, Name, SalesPersonID, Demographics 
from Sales.Store_Archive

select rowguid, Name, SalesPersonID, Demographics 
from Sales.Store

-- Using union statement, retrieve the today’s date in different styles using convert or format funtion.
select convert(varchar(20), GETDATE(), 1) as [MM/DD/YY]
union all
select convert(varchar(20), GETDATE(), 2) as [MM.DD.YY]
union all
select convert(varchar(50), GETDATE(), 3) as [MM DD YY HH:MM:SS]


'''Use ITI DB'''

--	Create a scalar function that takes date and returns Month name of that date.
create function getmname(@date date)
returns varchar(10)
as
begin
    declare @mname varchar(10)
    select @mname = format(@date , 'MMMM')
	return @mname
end 

select dbo.getmname('2019-02-01')

-- Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
create function getnum(@num1 int, @num2 int)
returns @temp table 
              (nom int)
as
begin
    while @num1 < @num2
	begin
	    set @num1 += 1
		if @num1 = @num2
		   break
		insert into @temp values(@num1)
	end
	return
end

--- drop function getnum

select* from getnum(2,7)


-- Create inline function that takes Student No and returns Department Name with Student full name.
create function getstd(@stno int)
returns table     
as
return (
     select s.st_fname + ' ' + s.st_lname full_name, d.dept_name
	 from Student s join department d
	 on d.dept_id = s.dept_id
	 where s.St_Id = @stno
	 )

select* from getstd(10)

-- Create a scalar function that takes Student ID and returns a message to user
--a.If first name and Last name are null then display 'First name & last name are null'
--b.If First name is null then display 'first name is null'
--c.If Last name is null then display 'last name is null'
--d.Else display 'First name & last name are not null'
create function getstdname(@sid int)
returns varchar(50)
begin
declare @msg varchar(50)
     select @msg = case 
	          when st_fname is null and st_lname is null then 'first name and last name are null'
			  when st_fname is null then 'first name is null'
			  when st_lname is null then 'last name is null'
			  else 'first name and last name are not null' end 
	from Student 
	where @sid = St_Id
	return @msg
end

select dbo.getstdname(13)

-- Create inline function that takes integer which represents manager ID and displays department name, Manager Name and hiring date 
create function getmng(@mid int)
returns table 
as
return (
        select d.dept_name, i.ins_name, d.manager_hiredate
		from department d join instructor i
		on d.dept_id = i.dept_id
		where @mid = d.dept_manager and d.dept_manager = i.ins_id
)

--- drop function getmng

select * from dbo.getmng(4)

--Create multi-statements table-valued function that takes a string
--If string='first name' returns student first name
--If string='last name' returns student last name 
--If string='full name' returns Full Name from student table 
--Note: Use “ISNULL” function
create function getstdinfo(@str varchar(20))
returns @table table(
                 msg varchar(20))
as
begin
     if @str = 'first name'
	 insert into @table
	 select ISNULL(St_Fname, ' ' )
	 from Student
	 if @str = 'last name'
	 insert into @table
	 select ISNULL(st_lname, ' ')
	 from Student
	 if @str = 'full name'
	 insert into @table
	 select ISNULL(st_fname, ' ') + ' ' + ISNULL(st_lname, ' ') [full name]
	 from Student
return
end

select * from getstdinfo('full name')

-- Write a query that returns the Student No and Student first name without the last char
select St_Id, SUBSTRING(St_Fname, 1, len(st_fname) -1)
from Student

-- Wirte query to delete all grades for the students Located in SD Department 
delete from Stud_Course
where St_Id in (
            	select s.St_Id
				from Department d join Student s
				on d.Dept_Id = s.Dept_Id
				where d.Dept_Name = 'SD'
				)


-- Give an example for hierarchyid Data type
create table earth_g
(
 node hierarchyid,
 g_name varchar(20),
 g_type varchar(30)
 )

insert earth_g
values
('/1/', 'asia', 'continent'),
('/2/', 'africa', 'continent'),
('/3/', 'oceania', 'continent'),

('/1/1/', 'china', 'country'),
('/1/2/', 'japan', 'country'),
('/1/3/', 'south korea', 'country'),
('/2/1/', 'south africa', 'country'),
('/2/2/', 'egypt', 'country'),
('/3/1/', 'australia', 'country'),

('/', 'earth', 'planet')

select node, Node.GetLevel(), g_name, g_type
from earth_g

-- Create a batch that inserts 3000 rows in the student table(ITI database). The values of the st_id column should be unique and between 3000 and 6000. All values of the columns st_fname, st_lname, should be set to 'Jane', ' Smith' respectively.
create table students (
                       st_id int not null,
					   st_fname varchar(15), 
					   st_lname varchar(15))

go
set showplan_text off
go
declare @id int = (select st_id from students)
declare @st_fname varchar(15) = (select st_fname from students)
declare @st_lname varchar(15) = (select st_lname from students)

set @id = 1
set @st_fname = 'Jane'
set @st_lname = 'Smith'

while @id <= 3000
begin
    insert into Students 
	values(@id, @st_fname, @st_lname)
	set @id +=1
end

select * from students
