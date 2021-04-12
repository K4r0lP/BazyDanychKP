-- Stworzenie bazy danych o nazwie firma, aby usunąć nalezy uzyc polecenia drop.
create database firma;
-- Stworzenie schematu o nazwie rozliczenia
create schema rozliczenia;
use rozliczenia;
-- Utworzenie 4 tabel (z autonumerowaniem)
create table pracownicy(id_pracownika int not null auto_increment,imie varchar(20) not null,nazwisko varchar(35) not null,adres varchar(25) not null,telefon int not null,primary key (id_pracownika));
create table godziny(id_godziny int not null auto_increment,data_ date not null,liczba_godzin int not null,id_pracownika int,primary key (id_godziny));
create table premie(id_premii int not null auto_increment,rodzaj varchar(15),kwota int,primary key (id_premii));
create table pensje(id_pensji int not null auto_increment,stanowisko varchar(30) not null,kwota int not null,id_premii int, primary key (id_pensji));
-- Utworzenie kluczy obcych 
alter table godziny
add foreign key (id_pracownika) references pracownicy(id_pracownika);
alter table pensje
add foreign key (id_premii) references premie(id_premii);
-- Wypełnienie tabel danymi
insert into pracownicy(imie,nazwisko,adres,telefon)
values('Franciszek','Czwórka','Kraków',555542254),('Zofia','Nowak','Kraków',872512154),('Marek','Kowalski','Warszawa',667765231),('Józef','Nowy','Gdańsk',561612124),('Ola','Leżak','Gdynia',655123234),('Zbigniew','Olejnik','Rzeszów',765642155),('Andrzej','Kondrad','Nowy Targ',872192211),('Fakir','Misjonarz','Zakopane',764542111),('Olaf','Wielki','Kielce',612621126),('Warcisław','Pięść','Kraków',555555555);

insert into godziny(data_,liczba_godzin,id_pracownika)
values('2020-12-12',198,1),('2020-11-22',167,3),('2020-10-01',205,2),('2020-09-11',188,4),('2020-09-12',177,5),('2020-09-13',166,6),('2020-05-23',222,10),('2020-11-12',140,9),('2020-11-13',199,8),('2020-12-14',108,7);

insert into premie(rodzaj,kwota)
values('Roczna',22000),('Miesięczna',1350),('Kwartalna',5650),('Miesięczna',1150),('Miesięczna',2350),('Roczna',11350),('Roczna',9350),('Miesięczna',2550),('Roczna',111350),('Kwartalna',21350);

insert into pensje(stanowisko,kwota,id_premii)
values('menadżer',17000,3),('CEO',345000,9),('menadżer',15000,1),('asystentka',9000,1),('aplikant',5000,1),('administrator',13000,1),('recepcjonistka',8000,1),('sprzątacz',4000,1),('kontraktor',21000,1),('portier',4000,1);
-- Wyświetlanie nazwiska oraz adresu z tabeli pracownicy.
select nazwisko,adres from pracownicy;
-- Mialem problem z użyciem funkcji DATEPART w mySQL
select data_,extract(week from data_), extract(month from data_)
FROM rozliczenia.godziny;
 
-- Zmiana w tabeli pensje z kwota na kwota_brutto i dodanie kwota_netto
alter table pensje change kwota kwota_brutto int;
alter table pensje add kwota_netto int;
update pensje set kwota_netto = kwota_brutto * 0.73;

select kwota_brutto,kwota_netto from pensje;

