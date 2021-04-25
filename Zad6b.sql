drop database firma;
-- drop schema rozliczenia;
-- Stworzenie bazy danych o nazwie firma, aby usunąć nalezy uzyc polecenia drop.
create database firma;

-- Stworzenie schematu o nazwie rozliczenia
drop schema ksiegowosc;
create schema ksiegowosc;
use ksiegowosc;

-- Utworzenie 5 tabel (z autonumerowaniem)
create table pracownicy(id_pracownika int not null auto_increment,imie varchar(20) not null,nazwisko varchar(35) not null,adres varchar(25) not null,telefon varchar(35),primary key (id_pracownika)) comment 'Tabela z danymi pracowników';
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
values('Franciszek','Czwórka','Kraków','555542254'),('Zofia','Nowak','Kraków','872512154'),('Marek','Kowalski','Warszawa','667765231'),('Józef','Nowy','Gdańsk','561612124'),('Ola','Leżak','Gdynia','655123234'),('Zbigniew','Olejnik','Rzeszów','765642155'),('Andrzej','Kondrad','Nowy Targ','872192211'),('Fakir','Misjonarz','Zakopane','764542111'),('Olaf','Wielki','Kielce','612621126'),('Warcisław','Pięść','Kraków','555555555');

insert into godziny(data_,liczba_godzin,id_pracownika)
values('2020-09-11',198,1),('2020-09-11',167,2),('2020-09-11',205,3),('2020-09-11',188,4),('2020-09-12',177,5),('2020-09-11',166,6),('2020-09-11',222,7),('2020-09-11',140,8),('2020-09-11',199,9),('2020-09-11',108,10);

insert into premie(rodzaj,kwota)
values('Roczna',22000),('Miesięczna',1350),('Kwartalna',5650),('Miesięczna',1150),('Miesięczna',0),('Roczna',11350),('Roczna',9350),('Miesięczna',0),('Roczna',111350),('Kwartalna',17350);

insert into pensje(stanowisko,kwota,id_premii)
values('menadżer',17000,3),('CEO',345000,9),('menadżer',15000,10),('asystentka',9000,1),('aplikant',2000,6),('administrator',13000,5),('recepcjonistka',8000,8),('sprzątacz',950,4),('kontraktor',21000,7),('portier',2800,2);

insert into wynagrodzenie(data_,id_pracownika,id_godziny,id_pensji,id_premii)
values ('2020-09-11',1,1,1,3),('2020-09-11',2,2,2,9),('2020-09-11',3,3,3,10),('2020-09-11',4,4,4,1),('2020-09-11',5,5,5,6),('2020-09-11',6,6,6,7),('2020-09-11',7,7,7,8),('2020-09-11',8,8,8,4),('2020-09-11',9,9,9,5),('2020-09-11',10,10,10,2);

select * from wynagrodzenie;
-- select * from godziny;
select * from pensje;
select * from pracownicy;
-- select * from premie;
set SQL_SAFE_UPDATES = 0;
-- a) Zmodyfikuj numer telefonu w tabeli pracownicy, dodając do niego kierunkowy dla Polski w nawiasie (+48)
update pracownicy
SET telefon = CONCAT('(+48) ', telefon );
-- b) Zmodyfikuj atrybut telefonu tabeli pracownicy tak, aby numer oddzielony był myślnikami wg wzoru: ‘555-222-333’ 
update pracownicy
set telefon = SUBSTRING(telefon, 1, 9)+'-'+ SUBSTRING(telefon, 10, 3)+'-'+ SUBSTRING(telefon, 13, 3);
select * from pracownicy;
-- c) Wyświetl dane pracownika, którego nazwisko jest najdłuższe, używając dużychliter
select  upper(nazwisko), LENGTH(nazwisko) nazwisko_len from pracownicy order by nazwisko_len desc , nazwisko desc limit 1;
-- d) Wyświetl dane pracowników i ich pensje zakodowane przy pomocy algorytmu md5 
select  md5(imie) md_imie, md5(nazwisko) md_nazwisko, md5(adres) md_adres, md5(telefon) md_telefon from pracownicy;
-- e) Wyświetl pracowników, ich pensje oraz premie. Wykorzystaj złączenie lewostronne.
select pracownicy.imie,pracownicy.nazwisko,pensje.kwota as 'pensje',premie.kwota as 'premia' from pracownicy left join (pensje left join (premie left join wynagrodzenie on premie.id_premii = wynagrodzenie.id_premii) on pensje.id_pensji = wynagrodzenie.id_pensji) 
on pracownicy.id_pracownika = wynagrodzenie.id_pracownika;
-- f) Wygeneruj raport (zapytanie), które zwróciw wyniki treść wg poniższego szablonu:
/*alter table pensje change kwota kwota_brutto int;
alter table pensje add kwota_netto int;
update pensje set kwota_netto = kwota_brutto * 0.73;
select kwota_brutto,kwota_netto from pensje;*/
select concat('Pracownik ', imie, ' ', nazwisko, ' w dniu ', wynagrodzenie.data_, ' otrzymał pensję całkowitą na kwotę ',
(pensje.kwota_brutto + premie.kwota), 'zł, gdzie wynagrodzenie zasadnicze wynosiło: ', CAST(pensje.kwota_brutto as char(10)), ' premie: ',
premie.kwota, ' nadgodziny: ', ((liczba_godzin - 160)*20)) as 'Raport'
FROM pracownicy inner join wynagrodzenie on pracownicy.id_pracownika = wynagrodzenie.id_pracownika
inner join pensje on wynagrodzenie.id_pensji = pensje.id_pensji
inner join premie on wynagrodzenie.id_premii = premie.id_premii
inner join godziny on wynagrodzenie.id_godziny = godziny.id_godziny;