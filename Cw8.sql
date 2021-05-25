use AdventureWorks2019;
go

--Zad. 1:
begin
	select HumanResources.EmployeePayHistory.BusinessEntityID, FirstName, LastName, Rate, RateChangeDate
	from HumanResources.EmployeePayHistory inner join Person.Person
	on HumanResources.EmployeePayHistory.BusinessEntityID = Person.Person.BusinessEntityID
	where Rate < (select avg(Rate)from HumanResources.EmployeePayHistory);
end;

go

--Zad. 2:
create or alter function Wysylka(@ID int)
returns datetime
as
begin
	declare @Data datetime;
	select @Data = ShipDate from Sales.SalesOrderHeader where SalesOrderID = @ID;

	return @Data
end;
go

declare @SalesID int = 43892;
select @SalesID as 'ID', dbo.Wysylka(@SalesID) as 'Data wysylki';

go

--Zad. 3:

create or alter procedure wybieranie(@name varchar(40))
as
begin
    declare @id int= (select ProductID from Production.Product where Name = @name);
    declare @quantity int = (select sum(Quantity) from Production.ProductInventory where ProductID = @id);
	IF @quantity > 0
		select  Name, ProductID, ProductNumber, 'Dostepny' as 'Dostepnosc'
		from Production.Product where Name = @name;
	else
		select  Name, ProductID, ProductNumber, 'Niedostepny' as 'Dostepnosc'
		from Production.Product  where Name = @name;
end;

go

declare @name varchar(40) = 'Metal Bar 1';
exec wybieranie @name;


go
--Zad. 4:

create or alter function kartakredyt(@zamowienie int)
returns varchar(25)
as
begin
	declare @numer varchar(25);

	select @numer = Sales.CreditCard.CardNumber 
	from Sales.CreditCard inner join Sales.SalesOrderHeader 
	on Sales.CreditCard.CreditCardID = Sales.SalesOrderHeader.CreditCardID 
	where Sales.SalesOrderHeader.SalesOrderID = @zamowienie;

	return @numer
end;
go;
declare @numer_zamowienia INT = 43892;
select @numer_zamowienia, dbo.kartakredyt(@numer_zamowienia);

go

--Zad. 5
create or alter procedure kalk(@num1 float, @num2 float)
as 
declare @wynik float
declare @blad varchar(130)
if @num1<@num2
begin
set @blad = 'Niewlasciwie zdefiniowane zmienne, wartosc pierwsza musi byc wieksza od drugiej';
select @blad
return;
end;
else
begin
set @wynik = @num1/@num2;
select round(@wynik,2)
return;
end;

exec kalk @num1 =44, @num2=3;
go

--Zad. 6
create or alter procedure wolne(@id varchar(25))
as
begin
	select JobTitle, VacationHours / 8 AS 'wakacyjne', SickLeaveHours / 8 AS 'chorobowe'
	from AdventureWorks2019.HumanResources.Employee
	where NationalIDNumber = @id; 
end;

go

declare @id varchar(25);
exec wolne @id = 276751903;


go

--Zad. 7
create or alter procedure kalkulator_walut(@kwota float, @z varchar(10), @na varchar(10), @data_przeliczenia datetime)
as
begin
	declare @kurs float;
	declare @wynik float;
	if @z = 'USD'
		begin
			select @kurs = AverageRate from Sales.CurrencyRate where ToCurrencyCode = @na and CurrencyRateDate = @data_przeliczenia;
			set @wynik = @kurs * @kwota;
		end;
	else
		begin
			select @kurs = AverageRate from Sales.CurrencyRate where ToCurrencyCode = @z and CurrencyRateDate = @data_przeliczenia;
			set @wynik = @kwota/@kurs;
		end;
	select @z as z, @na as na, @kwota as kwota, @kurs as kurs, @wynik as wynik;
end;

go
declare @waluta1 varchar(5) = 'GBP';
declare @waluta2 varchar(5) = 'USD';
declare @kwota float = 2350;
declare @data_przeliczenia datetime = '2013-05-31 00:00:00.000'
exec kalkulator_walut @kwota, @waluta1, @waluta2, @data_przeliczenia;