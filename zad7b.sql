Create or alter function Fibbonacci(@n int)
returns @tab table(number int)
as
begin 
	declare @n0 int = 0
	declare @n1 int = 1
	declare @i int = 0

    insert into @tab values(@n0),(@n1)

	while (@i <= @n-2)
    begin
            insert into @tab values(@n1 + @n0)
            set @n1 = @n1 + @n0
            set @n0 = @n1 - @n0
            set @i += 1
        end
return

end;

go
create or alter procedure Fibb(@n int)
as 
begin
    select * from cw9.dbo.Fibbonacci(@n)
end;
go
declare @liczba int;
set @liczba = 10;

execute Fibb @liczba;