create database cw12;
drop database cw12;
use cw12;
-- Tworzenie Tabeli
create table GeoEon(id_eon int not null IDENTITY(1,1),nazwa_eon varchar(30) not null,primary key (id_eon));
create table GeoEra(id_era int not null IDENTITY(1,1),id_eon int,nazwa_era varchar(30) not null, primary key (id_era),foreign key (id_eon) references GeoEon(id_eon));
create table GeoOkres(id_okres int not null IDENTITY(1,1),id_era int,nazwa_okres varchar(30) not null,primary key (id_okres),foreign key(id_era) references GeoEra(id_era));
create table GeoEpoka(id_epoka int not null IDENTITY(1,1),id_okres int,nazwa_epoka varchar(30) not null, primary key (id_epoka), foreign key(id_okres) references GeoOkres(id_okres));
create table GeoPietro(id_pietro int not null IDENTITY(1,1),id_epoka int,nazwa_pietro varchar(30) not null, primary key(id_pietro), foreign key(id_epoka) references GeoEpoka(id_epoka));

ALTER TABLE GeoEon NOCHECK CONSTRAINT ALL;
ALTER TABLE GeoEra NOCHECK CONSTRAINT ALL;
ALTER TABLE GeoOkres NOCHECK CONSTRAINT ALL;
ALTER TABLE GeoEpoka NOCHECK CONSTRAINT ALL;
ALTER TABLE GeoPietro NOCHECK CONSTRAINT ALL;

-- Uzupełnianie tabeli rekordami
insert into GeoEon(nazwa_eon)
values('FANEROZOIK');

insert into GeoEra(id_eon,nazwa_era)
values(1,'Kenozoik'),(1,'Mezozoik'),(1,'Paleozoik');

insert into GeoOkres(id_era,nazwa_okres)
values(1,'Czwartorząd'),(1,'Neogen'),(1,'Paleogen'),(2,'Kreda'),(2,'Jura'),(2,'Trias'),(3,'Perm'),(3,'Karbon'),(3,'Dewon'),(3,'Sylur'),(3,'Ordowik'),(3,'Kambr');

insert into GeoEpoka(id_okres,nazwa_epoka)
values(1,'Halocen'),(1,'Plejstocen'),
(2,'Pliocen'),(2,'Miocen'),
(3,'Oligocen'),(3,'Eocen'),(3,'Paleocen'),
(4,'Górna'),(4,'Dolna'),
(5,'Górna'),(5,'Środkowa'),(5,'Dolna'),
(6,'Górna'),(6,'Środkowa'),(6,'Dolna'),
(7,'Górny'),(7,'Dolny'),
(8,'Górny'),(8,'Dolny'),
(9,'Górny'),(9,'Środkowy'),(9,'Dolny'),
(10,'Przydol'),(10,'Ludlow'),(10,'Wenlok'),(10,'Landower'),
(11,'Górny'),(11,'Środkowy'),(11,'Dolny'),
(12,'Górny'),(12,'Środkowy'),(12,'Dolny');

insert into GeoPietro(id_epoka,nazwa_pietro)
values(1,'Megalaj'),(1,'Northgrip'),(1,'Grenland'),
(2,'Późny'),(2,'Chiban'),(2,'Kalabr'),
(3,'Gelas'),(3,'Piacent'),(3,'Zankl'),
(4,'Mesyn'),(4,'Torton'),(4,'Serrawal'),(4,'Lang'),(4,'Burdygał'),(4,'Akwitan'),
(5,'Szat'),(5,'Rupel'),
(6,'Priabon'),(6,'Barton'),(6,'Lutet'),(6,'Iprez'),
(7,'Tanet'),(7,'Zeland'),(7,'Dan'),
(8,'Mastrycht'),(8,'Kampan'),(8,'Santon'),(8,'Koniak'),(8,'Turon'),(8,'Cenoman'),
(9,'Alb'),(9,'Apt'),(9,'Barrem'),(9,'Hoteryw'),(9,'Walanżyn'),(9,'Berias'),
(10,'Tyton'),(10,'Kimeryd'),(10,'Oksford'),
(11,'Kelowej'),(11,'Baton'),(11,'Bajos'),(11,'Aalen'),
(12,'Toark'),(12,'Pliensbach'),(12,'Synemur'),(12,'Hetang'),
(13,'Retyk'),(13,'Noryk'),(13,'Karnik'),
(14,'Ladyn'),(14,'Anizyk'),
(15,'Olenek'),(15,'Ind'),
(16,'Tatar'),(16,'Kazań'),(16,'Ufa'),
(17,'Kungur'),(17,'Artinsk'),(17,'Sakmar'),(17,'Assel'),
(18,'Gzel'),(18,'Kasimov'),(18,'Moskov'),(18,'Baszkir'),
(19,'Serpuchow'),(19,'Wizen'),(19,'Turnej'),
(20,'Famen'),(20,'Fran'),
(21,'Żywet'),(21,'Eifel'),
(22,'Ems'),(22,'Prag'),(22,'Lochkow'),
(24,'Ludford'),(24,'Gorst'),
(25,'Homer'),(25,'Szejnwud'),
(26,'Telicz'),(26,'Aeron'),(26,'Ruddan'),
(27,'Aszgil'),(27,'Karadok'),
(28,'Landeil'),(28,'Lanwirn'),
(29,'Arenig'),(29,'Tremadok');


-- drop table GeoTabela;
select id_pietro, nazwa_pietro, epoka.id_epoka, nazwa_epoka, okres.id_okres, nazwa_okres, era.id_era, nazwa_era, eon.id_eon, nazwa_eon into GeoTabela
from GeoPietro as pietro
		join GeoEpoka as epoka
			on pietro.id_epoka = epoka.id_epoka
		join GeoOkres as okres
			on okres.id_okres = epoka.id_okres
		join GeoEra as era
			on era.id_era = okres.id_era
		join GeoEon as eon
			on eon.id_eon = era.id_eon;


ALTER TABLE GeoTabela
ADD PRIMARY KEY (id_pietro)


-- Tworzene i uzupełnianie tabeli z cyframi
create table Dziesiec(cyfra int ,bit int);
insert into Dziesiec(cyfra,bit)
values (0,1),(1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1);
--drop table Dziesiec;
--drop table Milion;
-- Tworzenie i uzupełnianie tabeli liczbami od 0-999999
create table Milion(liczba int,cyfra int, bit int);
insert into  Milion 
select a1.cyfra +10* a2.cyfra +100*a3.cyfra + 1000*a4.cyfra + 10000*a5.cyfra + 100000*a6.cyfra
 as liczba , a1.cyfra as cyfra, a1.bit as bit from Dziesiec a1, Dziesiec a2, Dziesiec a3, Dziesiec a4, Dziesiec a5, Dziesiec a6 ;

-- Zapytania 
SELECT COUNT(*) FROM Milion INNER JOIN GeoTabela ON ((Milion.liczba % 88)=(GeoTabela.id_pietro));

SELECT COUNT(*) FROM Milion INNER JOIN GeoPietro ON (Milion.liczba%88 =GeoPietro.id_pietro)
INNER JOIN GeoEpoka ON GeoPietro.id_epoka =GeoEpoka.id_epoka
INNER JOIN GeoOkres ON GeoEpoka.id_okres = GeoOkres.id_okres
INNER JOIN GeoEra ON GeoEra.id_era = GeoOkres.id_era
INNER JOIN GeoEon ON GeoEon.id_eon = GeoEra.id_eon;

SELECT COUNT(*) FROM Milion 
	WHERE (Milion.liczba % 88) = 
	(SELECT id_pietro FROM GeoTabela WHERE (Milion.liczba % 88) = (id_pietro));

SELECT COUNT(*) FROM Milion WHERE Milion.liczba % 88 IN
(SELECT GeoPietro.id_pietro FROM GeoPietro 
INNER JOIN GeoEpoka ON GeoPietro.id_epoka = GeoEpoka.id_epoka
INNER JOIN GeoOkres ON GeoEpoka.id_okres = GeoOkres.id_okres
INNER JOIN GeoEra ON GeoEra.id_era = GeoOkres.id_era
INNER JOIN GeoEon ON GeoEon.id_eon = GeoEra.id_eon);
