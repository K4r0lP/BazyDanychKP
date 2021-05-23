use AdventureWorks2019;
--Zad 1:
go;

begin
	select HumanResources.EmployeePayHistory.BusinessEntityID, FirstName, LastName, Rate, RateChangeDate
	from HumanResources.EmployeePayHistory INNER JOIN Person.Person
	on HumanResources.EmployeePayHistory.BusinessEntityID = Person.Person.BusinessEntityID
	where Rate < (select avg(Rate)from HumanResources.EmployeePayHistory);
end;

go;

--Zad 2:
create or alter function Wysylka(@ID INT)
returns datetime
as
begin
	declare @Data datetime;
	select @Data = ShipDate from Sales.SalesOrderHeader where SalesOrderID = @ID;

	return @Data
end;
go;

declare @SalesID int = 43892;
select @SalesID, dbo.Wysylka(@SalesID);

go;

--Zad 3:

create OR alter procedure wyswietlanie(@nazwa_pr varchar(50))
as
begin
	select ProductID, Name, ProductNumber, SafetyStockLevel from Production.Product where Name = @nazwa_pr;
end;

declare @nazwa varchar(50) = 'Bearing Ball';
exec wyswietlanie @nazwa;

go;

--Zad 4:

create or alter function kartakredyt(@zamowienie int)
returns varchar(20)
as
begin
	declare @numer varchar(20);

	select @numer = Sales.CreditCard.CardNumber 
	from Sales.CreditCard INNER JOIN Sales.SalesOrderHeader 
	on Sales.CreditCard.CreditCardID = Sales.SalesOrderHeader.CreditCardID 
	where Sales.SalesOrderHeader.SalesOrderID = @zamowienie;

	return @numer
end;
go;
declare @numer_zamowienia INT = 43659;
select @numer_zamowienia, dbo.kartakredyt(@numer_zamowienia);

go;

