use Inda
go
--4.1 Вывести список сотрудников, которые получают заработную плату ниже, чем у непосредственного руководителя.
select e.NAME
from Employee as e
left join Employee as b on b.ID = e.CHIEF_ID
where e.SALARY<b.SALARY
--4.2 Вывести список сотрудников, которые получают в отделе минимальную заработную плату в своем отделе.
--уточнить, можно ли выводить саму ЗП, либо нужны только данные по сотрудникам
select 
eo.NAME as Employee
,sal.NAME as Department
,sal.MinSalary as Salary
from
(
	select  d.NAME,
	MIN(e.SALARY) as MinSalary
	from Employee as e
	left join Department as d on e.DEPARTMENT_ID = d.ID
	group by d.NAME
) as sal
left join Employee as eo on eo.SALARY = sal.MinSalary
--4.3 Вывести список ID отделов, количество сотрудников в которых не превышает трех человек.
select d.ID
from Department as d
left join Employee as e on e.DEPARTMENT_ID = d.ID
group by d.ID
having COUNT(*)<=3
--4.4 Вывести список сотрудников, не имеющих назначенного руководителя, который работал бы в том же отделе.
select e.NAME
from Employee as e
left join Employee as b on b.ID = e.CHIEF_ID
where b.DEPARTMENT_ID!=e.DEPARTMENT_ID
--4.5 Найти список ID отделов с максимальной суммарной заработной платой сотрудников.
--Я же правильно понимаю, что нам нужна сумма зп в отделе, мы сортируем по максимуму среди отделов и это(и) данные выводим?
select s.ID, s.SumSalary from
(
	select d.ID, SUM(e.SALARY) as SumSalary
	from Department as d
	left join Employee as e on e.DEPARTMENT_ID = d.ID
	group by d.ID
) as s
where s.SumSalary = (
					--TODO: подумать над улучшением
					select top 1 SUM(e.SALARY) as SumSalary
					from Department as d
					left join Employee as e on e.DEPARTMENT_ID = d.ID
					group by d.ID
					order by SUM(e.SALARY) DESC
)
--4.6 Составить SQL-запрос, вычисляющий сумму всех значений всех ЗП в конкретном столбце таблицы.
--Требуется уточнение. Сумма должна быть в конкретном столбце?

--Реализовать хранимую процедуру (UPDATESALARYFORDEPARTMENT) со следующими условиями:
--5.1 Входные данные: ID отдела, PERCENT процент повышения ЗП
--5.2 Логика: данная процедура должна у всех сотрудников в рамках отдела с заданным ID (кроме начальника отдела) повышать ЗП на заданный процент (PERCENT). 
--В случае, если после повышения ЗП у кого-либо из сотрудников ЗП оказалась выше, чем у начальника отдела, то повысить ЗП для начальника до аналогичной ЗП.
--5.3 На выходе вернуть перечень сотрудников (все данные из таблицы employee) с обновленной и старой ЗП.
--только сотрудники с изменившейся зп, т.е. из того же отдела? или все сотрудники из таблицы employee?
DROP PROCEDURE UPDATESALARYFORDEPARTMENT
go
CREATE PROCEDURE UPDATESALARYFORDEPARTMENT
					@ID int,
					@PERCENT int
					AS
BEGIN
	declare @bossSalary int, @maxSalary int
	select @bossSalary = SALARY from Employee where DEPARTMENT_ID = @ID and CHIEF_ID is null
	select @maxSalary = MAX(SALARY) from Employee where DEPARTMENT_ID = @ID and CHIEF_ID is not null
    update Employee
	set SALARY = 
				--закоменчено на случай вывода всех вотрудников
				--case
				--	when CHIEF_ID is not null then cast(((SALARY*(@PERCENT+100))/100) as int)
				--	else IIF(@maxSalary>@bossSalary,cast(((@maxSalary*(@PERCENT+100))/100) as int),@bossSalary)
				--end
				case DEPARTMENT_ID
					when @ID then
					(
					case
						when CHIEF_ID is not null then cast(((SALARY*(@PERCENT+100))/100) as int)
						else IIF(@maxSalary>@bossSalary,cast(((@maxSalary*(@PERCENT+100))/100) as int),@bossSalary)
					end
					)
					else SALARY
				end
	output inserted.NAME as 'NAME'
		,deleted.SALARY as 'OldSalary'
		,inserted.SALARY as 'NewSalary'
	--where DEPARTMENT_ID = @ID	--закоменчено на случай вывода всех вотрудников
END;
