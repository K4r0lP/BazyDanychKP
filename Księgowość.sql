-- drop database firma;
-- drop schema rozliczenia;
-- Stworzenie bazy danych o nazwie firma, aby usunąć nalezy uzyc polecenia drop.
-- create database firma;

-- Stworzenie schematu o nazwie rozliczenia
drop schema ksiegowosc;
create schema ksiegowosc;
use ksiegowosc;

-- Utworzenie 5 tabel (z autonumerowaniem)
create table pracownicy(id_pracownika int not null auto_increment,imie varchar(20) not null,nazwisko varchar(35) not null,adres varchar(25) not null,telefon int not null,primary key (id_pracownika)) comment 'Tabela z danymi pracowników';
create table godziny(id_godziny int not null auto_increment,data_ date ,liczba_godzin int not null,id_pracownika int,primary key (id_godziny,data_),foreign key (id_pracownika) references pracownicy(id_pracownika))comment 'Tabela z danymi o godzinach pracowników';
create table premie(id_premii int not null auto_increment,rodzaj varchar(15),kwota int,primary key (id_premii))comment 'Tabela z danymi o premiach pracowników';
create table pensje(id_pensji int not null auto_increment,stanowisko varchar(30) not null,kwota int not null,id_premii int, primary key (id_pensji),foreign key (id_premii) references premie(id_premii))comment 'Tabela z danymi o pensjach pracowników';
create table wynagrodzenie(id_wynagrodzenia int not null auto_increment,data_ date ,id_pracownika int,id_godziny int,id_pensji int,id_premii int, primary key(id_wynagrodzenia),
foreign key(id_pracownika) references pracownicy(id_pracownika), 
foreign key(id_godziny) references godziny(id_godziny), 
foreign key(id_pensji) references pensje(id_pensji), 
foreign key(id_premii) references premie(id_premii))comment 'Tabela z danymi o premiach pracowników';


-- Wypełnienie tabel danymi
insert into pracownicy(imie,nazwisko,adres,telefon)
values('Franciszek','Czwórka','Kraków',555542254),('Zofia','Nowak','Kraków',872512154),('Marek','Kowalski','Warszawa',667765231),('Józef','Nowy','Gdańsk',561612124),('Ola','Leżak','Gdynia',655123234),('Zbigniew','Olejnik','Rzeszów',765642155),('Andrzej','Kondrad','Nowy Targ',872192211),('Fakir','Misjonarz','Zakopane',764542111),('Olaf','Wielki','Kielce',612621126),('Warcisław','Pięść','Kraków',555555555);

insert into godziny(data_,liczba_godzin,id_pracownika)
values('2020-09-11',198,1),('2020-09-11',167,2),('2020-09-11',205,3),('2020-09-11',188,4),('2020-09-12',177,5),('2020-09-11',166,6),('2020-09-11',222,7),('2020-09-11',140,8),('2020-09-11',199,9),('2020-09-11',108,10);

insert into premie(rodzaj,kwota)
values('Roczna',22000),('Miesięczna',1350),('Kwartalna',5650),('Miesięczna',1150),('Miesięczna',0),('Roczna',11350),('Roczna',9350),('Miesięczna',0),('Roczna',111350),('Kwartalna',17350);

insert into pensje(stanowisko,kwota,id_premii)
values('menadżer',17000,3),('CEO',345000,9),('menadżer',15000,10),('asystentka',9000,1),('aplikant',2000,6),('administrator',13000,5),('recepcjonistka',8000,8),('sprzątacz',950,4),('kontraktor',21000,7),('portier',2800,2);

insert into wynagrodzenie(data_,id_pracownika,id_godziny,id_pensji,id_premii)
values ('2020-09-11',1,1,1,3),('2020-09-11',2,2,2,9),('2020-09-11',3,3,3,10),('2020-09-11',4,4,4,1),('2020-09-11',5,5,5,6),('2020-09-11',6,6,6,7),('2020-09-11',7,7,7,8),('2020-09-11',8,8,8,4),('2020-09-11',9,9,9,5),('2020-09-11',10,10,10,2);

select * from wynagrodzenie;
select * from godziny;
select * from pensje;
select * from pracownicy;
select * from premie;

-- a)Wyświetlanie nazwiska oraz id z tabeli pracownicy.
select id_pracownika,adres from pracownicy; 
-- b)Wyświetlanie id pracowników, których płaca jest większa niż 1000.
select pracownicy.id_pracownika, pensje.kwota 
from pracownicy inner join (pensje inner join wynagrodzenie on pensje.id_pensji = wynagrodzenie.id_pensji) on pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
where pensje.kwota > 1000.00;
-- c)Wyświetlanie id pracowników nieposiadających premii,których płaca jest większa niż 2000.
select pracownicy.id_pracownika
from pracownicy inner join (pensje inner join (premie inner join wynagrodzenie on premie.id_premii = wynagrodzenie.id_premii) on pensje.id_pensji = wynagrodzenie.id_pensji) 
on pracownicy.id_pracownika = wynagrodzenie.id_pracownika
where premie.kwota < 1500 and pensje.kwota > 2000;
-- d)Wyświetlanie pracowników, których pierwsza litera imienia zaczyna się na literę ‘J’.
select * from pracownicy WHERE imie LIKE 'j%';
-- e)Wyświetlanie pracowników, których nazwisko zawiera literę ‘n’ oraz imię kończy się na literę ‘a’.
select * from pracownicy WHERE imie LIKE '%a' and nazwisko like '%n%';
-- f)Wyświetlanie imię i nazwisko pracowników oraz liczbę ich nadgodzin, przyjmując, iż standardowy czas pracy to 160 h miesięcznie.
select imie,nazwisko,liczba_godzin - 160 as nadgodziny
from pracownicy inner join godziny on pracownicy.id_pracownika = godziny.id_pracownika
where godziny.liczba_godzin > 160;
-- g)Wyświetlanie imię i nazwisko pracowników, których pensja zawiera się w przedziale 1500 –3000PLN.
select pracownicy.imie, pracownicy.nazwisko, pensje.kwota
from pracownicy inner join (pensje inner join wynagrodzenie on pensje.id_pensji = wynagrodzenie.id_pensji) on pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
where pensje.kwota between 1500 and 3000;
-- h)Wyświetl imię i nazwisko pracowników, którzy pracowali w nadgodzinachi nie otrzymali premii.
select imie, nazwisko from ksiegowosc.pracownicy inner join (ksiegowosc.godziny inner join
(ksiegowosc.premie inner join ksiegowosc.wynagrodzenia on ksiegowosc.premie.id_premii = ksiegowosc.wynagrodzenia.id_premii)
on ksiegowosc.godziny.id_godziny = ksiegowosc.wynagrodzenia.id_godziny) 
on ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenia.id_pracownika
where ksiegowosc.godziny.liczba_godzin > 160 and ksiegowosc.premie.kwota = 0 ;
-- i)Uszereguj pracowników według pensji.
select * 
from pracownicy
inner join (pensje inner join wynagrodzenie on pensje.id_pensji = wynagrodzenie.id_pensji) on pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
order by pensje.kwota;
-- j)Uszereguj pracowników według pensji i premii malejąco.
select * from pracownicy inner join (pensje inner join (premie inner join wynagrodzenie on premie.id_premii = wynagrodzenie.id_premii) on pensje.id_pensji = wynagrodzenie.id_pensji) 
on pracownicy.id_pracownika = wynagrodzenie.id_pracownika
order by pensje.kwota desc ,premie.kwota desc;
-- k)Zlicz i pogrupuj pracowników według pola ‘stanowisko’.
select stanowisko,count(pensje.stanowisko)
from pensje
group by stanowisko;
-- l)Policz średnią, minimalną i maksymalną płacę dla stanowiska ‘kierownik’ (jeżeli takiego nie masz, to przyjmij dowolne inne).
select max(pensje.kwota),min(pensje.kwota),avg(pensje.kwota)
from pensje
where stanowisko = 'menadżer';
-- m)Policz sumę wszystkich wynagrodzeń.
select sum(pensje.kwota)
from pensje;
-- n)Policz sumę wynagrodzeń w ramach danego stanowiska.
select stanowisko,sum(pensje.kwota)
from pensje
group by stanowisko;
-- o)Wyznacz liczbę premii przyznanych dla pracowników danego stanowiska.
select stanowisko, count(premie.kwota) 
from premie inner join (pensje inner join wynagrodzenie on pensje.id_pensji = wynagrodzenie.id_pensji) on premie.id_premii = wynagrodzenie.id_premii
group by stanowisko;
-- p)Usuń wszystkich pracowników mających pensję mniejszą niż 1200 zł.
SET FOREIGN_KEY_CHECKS=0; -- to disable them
delete pensje,premie,godziny
from pracownicy inner join (pensje inner join (premie inner join(godziny inner join wynagrodzenie on godziny.id_godziny = wynagrodzenie.id_godziny)on premie.id_premii = wynagrodzenie.id_premii) on pensje.id_pensji = wynagrodzenie.id_pensji)
-- FROM pracownicy inner join (pensje inner join (premie inner join (godziny inner join wynagrodzenie on godziny.id_godziny = wynagrodzenie.id_godziny) pensje.id_pensji = wynagrodzenie.id_pensji))
WHERE pensje.kwota <1200;
SET FOREIGN_KEY_CHECKS=1; -- to re-enable them