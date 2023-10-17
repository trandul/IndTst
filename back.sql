create database Inda
go
use Inda

create table Department
(
	ID int primary key identity,
	NAME nvarchar(100)
)
create table Employee
(
	ID int primary key identity,
	DEPARTMENT_ID int references Department(ID),
	CHIEF_ID int references Employee(ID),
	NAME nvarchar(100),
	SALARY int --я бы использовал money или decimal
)
insert into Department values
(N'Отдел разработки'),
(N'Отдел внедрения'),
(N'Отдел эксплуатации')

create database SourceData
go
use SourceData
create table Names
(
	id int identity,
	name nvarchar(100),
	sex bit
)
create table LastNames
(
	id int identity,
	LastName nvarchar(100)
)
go
insert into Names values
('Степан',0),
('Василий',0),
('Сергей',0),
('Леонид',0),
('Павел',0),
('Иван',0),
('Геннадий',0),
('Тарас',0),
('Николай',0),
('Вячеслав',0),
('Эдуард',0),
('Пётр',0),
('Михаил',0),
('Фёдор',0),
('Георгий',0),
('Борис',0),
('Гамлет',0),
('Эраст',0),
('Татьяна',1),
('Нина',1),
('Зинаида',1),
('Людмила',1),
('Екатерина',1),
('Алёна',1),
('Галина',1),
('Наталья',1),
('Клавдия',1)

insert into LastNames values
('Тракторенко'),
('Задов'),
('Багратионов'),
('Сморковичев'),
('Пастушенко'),
('Ватрушкин'),
('Аполлонов')

use Inda
declare @ln nvarchar(max), @nm nvarchar(max), @counter int, @dep int
set @counter = 1;
set @dep = 1;
while @dep<=3
begin
	while @counter<=15
		begin
		select 
			@ln = s.LastName 
			from SourceData.dbo.LastNames as s
			where s.id = cast(ROUND(RAND()*100,0) as int)%6+1
		select 
			@nm = Name + ' ' + @ln + IIF(sex = 1 and right(@ln,1)!='о','a','')
		from SourceData.dbo.Names
		where id = cast(ROUND(RAND()*100,0) as int)%26+1

		insert into Employee values(@dep,IIF(@counter=1,null,cast((15*(@dep-1)+1) as int)),@nm, cast(ROUND(RAND()*100000,0) as int));
		set @counter = @counter+1;
		end;
	set @counter = 1;
	set @dep = @dep+1;
end;
