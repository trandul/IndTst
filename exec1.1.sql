--4.1 Вывести список сотрудников, которые получают заработную плату ниже, чем у непосредственного руководителя.
select e.NAME
from Employee as e
left join Employee as b on b.ID = e.CHIEF_ID
where e.SALARY<b.SALARY
--4.2 Вывести список сотрудников, которые получают в отделе минимальную заработную плату в своем отделе.
--уточнить, можно ли выводить саму ЗП, либо нужны только данные по сотрудникам
select distinct d.NAME, 
MIN(e.SALARY) as MinSalary
from Employee as e
left join Department as d on e.DEPARTMENT_ID = d.ID
group by d.name
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
					select SUM(e.SALARY) as SumSalary
					from Department as d
					left join Employee as e on e.DEPARTMENT_ID = d.ID
					group by d.ID
					order by SUM(e.SALARY) DESC
					limit 1
)


--Реализовать хранимую процедуру (UPDATESALARYFORDEPARTMENT) со следующими условиями:
--5.1 Входные данные: ID отдела, PERCENT процент повышения ЗП
--5.2 Логика: данная процедура должна у всех сотрудников в рамках отдела с заданным ID (кроме начальника отдела) повышать ЗП на заданный процент (PERCENT). 
--В случае, если после повышения ЗП у кого-либо из сотрудников ЗП оказалась выше, чем у начальника отдела, то повысить ЗП для начальника до аналогичной ЗП.
--5.3 На выходе вернуть перечень сотрудников (все данные из таблицы employee) с обновленной и старой ЗП.
--только сотрудники с изменившейся зп, т.е. из того же отдела? или все сотрудники из таблицы employee?
--можно ли использовать функцию?
CREATE OR REPLACE PROCEDURE UPDATESALARYFORDEPARTMENT (
					p_ID int,
					p_PERCENT int)
					AS $$
	declare v_bossSalary int; v_maxSalary int;
BEGIN

	select SALARY into v_bossSalary from Employee where DEPARTMENT_ID = p_ID and CHIEF_ID is null;
	select MAX(SALARY) into v_maxSalary from Employee where DEPARTMENT_ID = p_ID and CHIEF_ID is not null;
    with updated as(
	update Employee
	set SALARY = 
				case DEPARTMENT_ID
					when p_ID then
					(
					case
						when CHIEF_ID is not null then cast(((SALARY*(p_PERCENT+100))/100) as integer)
						else 
						case
							when v_maxSalary>v_bossSalary then cast(((v_maxSalary*(p_PERCENT+100))/100) as integer)
							else v_bossSalary
						end
					end
					)
					else SALARY
				end
	returning id, salary	
	)
	select e.NAME, e.SALARY, u.SALARY from Employee as e
	left join updated as u on u.id = e.id
END;
$$ LANGUAGE plpgsql;

--вариант с функцией - нет проблем с возвратом данных
CREATE OR REPLACE FUNCTION UPDATESALARYFORDEPARTMENTf (par_ID int, par_PERCENT int) RETURNS TABLE(f1 character varying, f2 integer, f3 integer)
AS $$
	declare var_bossSalary int; var_maxSalary int;
BEGIN
	select SALARY into var_bossSalary from Employee where DEPARTMENT_ID = par_ID and CHIEF_ID is null;
	select MAX(SALARY) into var_maxSalary from Employee where DEPARTMENT_ID = par_ID and CHIEF_ID is not null;
    return query
	with updated as(
	update Employee
	set SALARY = 
				case DEPARTMENT_ID
					when par_ID then
					(
					case
						when CHIEF_ID is not null then cast(((SALARY*(par_PERCENT+100))/100) as integer)
						else 
							case
								when var_maxSalary>var_bossSalary then cast(((var_maxSalary*(par_PERCENT+100))/100) as integer)
								else var_bossSalary
							end
					end
					)
					else SALARY
				end
	returning id, salary	
	)
	
	select e.NAME, e.SALARY, u.SALARY from Employee as e
	left join updated as u on u.id = e.id;
	
END
$$ LANGUAGE plpgsql;
