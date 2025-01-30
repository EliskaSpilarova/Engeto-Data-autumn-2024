-- Úkol 1: Vypište všechna data z tabulky healthcare_provider.
select * 
from healthcare_provider; 

-- Úkol 2: Vypište pouze sloupce se jménem a typem poskytovatele ze stejné tabulky jako v předchozím příkladu.
select 
	name, 
	provider_type 
from healthcare_provider; 

-- Úkol 3: Předchozí dotaz upravte tak, že vypíše pouze prvních 20 záznamů v tabulce.
select 
	name, 
	provider_type 
from healthcare_provider
limit 20;

-- Úkol 4: Vypište z tabulky healthcare_provider záznamy seřazené podle kódu kraje vzestupně.
select *
from healthcare_provider
order by region_code;

-- Úkol 5: Vypište ze stejné tabulky jako v předchozím příkladě sloupce se jménem poskytovatele,
-- kódem kraje a kódem okresu. Data seřaďte podle kódu okresu sestupně. Nakonec vyberte pouze prvních 500 záznamů.
select 
	name,
	region_code,
	district_code 
from healthcare_provider
order by district_code desc 
limit 500;

-- WHERE
-- Úkol 1: Vyberte z tabulky healthcare_provider všechny záznamy poskytovatelů zdravotních služeb, 
-- kteří poskytují služby v Praze (kraj Praha).
select *
from healthcare_provider 
where region_code = 'CZ020';

-- Úkol 2: Vyberte ze stejné tabulky název a kontaktní informace poskytovatelů, kteří nemají místo poskytování v Praze (kraj Praha).
select *
from healthcare_provider
where region_code != 'CZ020';

-- Úkol 3: Vypište názvy poskytovatelů, kódy krajů místa poskytování a místa sídla u takových poskytovatelů, 
-- u kterých se tyto hodnoty rovnají.
select 
	name,
	region_code,
	residence_region_code 
from healthcare_provider 
where region_code = residence_region_code;

-- Úkol 4: Vypište název a telefon takových poskytovatelů, kteří svůj telefon vyplnili do registru.
select *
from healthcare_provider
where phone is not null;

-- Úkol 5: Vypište název poskytovatele a kód okresu u poskytovatelů, 
-- kteří mají místo poskytování služeb v okresech Benešov a Beroun. Záznamy seřaďte vzestupně podle kódu okresu.
select 
	name,
	district_code
from healthcare_provider
where district_code in ('CZ0201', 'CZ0202')
order by district_code;

-- Bonusová cvičení: COVID-19: SELECT, ORDER BY a LIMIT
-- Úkol 1: Ukažte všechny záznamy z tabulky covid19_basic.
select *
from covid19_basic;

-- Úkol 2: Ukažte jen prvních 20 záznamů z tabulky covid19_basic.
select *
from covid19_basic
limit 20;

-- Úkol 3: Seřaďte celou tabulku covid19_basic vzestupně podle sloupce date.
select *
from covid19_basic
order by date;

-- Úkol 4: Seřaďte celou tabulku covid19_basic sestupně podle sloupce date.
select *
from covid19_basic
order by date desc;

-- Úkol 5: Vyberte jen sloupec country z tabulky covid19_basic.
select country
from covid19_basic;

--Úkol 6: Vyberte jen sloupce country a date z tabulky covid19_basic.
select 
	country,
	date
from covid19_basic;

-- Bonusová cvičení: COVID-19: WHERE
-- Úkol 1: Vyberte z tabulky covid19_basic jen záznamy s Rakouskem (Austria).
select *
from covid19_basic
where country = 'Austria';

-- Úkol 2: Vyberte jen sloupce country, date a confirmed pro Rakousko z tabulky covid19_basic.
select 
	country,
	date,
	confirmed
from covid19_basic
where country = 'Austria';

-- Úkol 3: Vyberte všechny sloupce k datu 30. 8. 2020 z tabulky covid19_basic.
select *
from covid19_basic 
where date = '2020-08-30';

-- Úkol 4: Vyberte všechny sloupce k datu 30. 8. 2020 v České republice z tabulky covid19_basic.
select *
from covid19_basic 
where date = '2020-08-30'
	and country = 'Czechia';
	
-- Úkol 5: Vyberte všechny sloupce pro Českou republiku a Rakousko z tabulky covid19_basic.
select *
from covid19_basic
where country in ('Czechia', 'Austria');

-- Úkol 6: Vyberte všechny sloupce z covid19_basic, kde počet nakažených je roven 1 000, nebo 100 000.
select *
from covid19_basic
where confirmed = 1000 
	or confirmed = 100000;
	
-- Úkol 7: Vyberte všechny sloupce z tabulky covid19_basic, ve kterých je počet nakažených mezi 10 a 20 a navíc pouze v den 30. 8. 2020.
select *
from covid19_basic 
where confirmed >= 10
	and confirmed <= 20
	and date = '2020-08-30';
	
-- Úkol 8: Vyberte všechny sloupce z covid19_basic, u kterých je počet nakažených větší než jeden milion dne 15. 8. 2020.
select *
from covid19_basic
where confirmed > 1000000
	and date = '2020-08-15';
	
-- Úkol 9: Vyberte sloupce date, country a confirmed v Anglii a Francii z tabulky covid19_basic a seřaďte je sestupně podle data.
select 
	date,
	country,
	confirmed 
from covid19_basic
where country in ('United Kingdom', 'France')
order by date desc;

-- Úkol 10: Vyberte z tabuky covid19_basic_differences přírůstky nakažených v České republice v září 2020.
select *
from covid19_basic_differences
where country = 'Czechia'
	and date >= '2020-09-01'
	and date <= '2020-09-30';
	
-- Úkol 11: Z tabulky lookup_table zjistěte počet obyvatel Rakouska.
select population
from lookup_table
where country = 'Austria';

-- Úkol 12: Z tabulky lookup_table vyberte jen země, které mají počet obyvatel větší než 500 milionů.
select country
from lookup_table
where population > 500000000;

--Úkol 13: Zjistěte počet nakažených v Indii dne 30. srpna 2020 z tabulky covid19_basic.
select confirmed
from covid19_basic 
where country = 'India'
	and date = '2020-08-30';
	
-- Úkol 14: Zjistěte počet nakažených na Floridě z tabulky covid19_detail_us dne 30. srpna 2020.
select confirmed
from covid19_detail_us
where province = 'Florida'
	and date = '2020-08-30';

-- Cvičení: Tvorba, úprava & vkládání do tabulek
-- Úkol 1: Vytvořte tabulku t_{jméno}_{příjmení}_providers_south_moravia z tabulky healthcare_provider vyberte pouze Jihomoravský kraj.
CREATE TABLE t_eliska_spilarova_providers_south_moravia AS
 SELECT *
 FROM healthcare_provider
 WHERE region_code = 'CZ064';

-- Úkol 2: Vytvořte tabulku t_{jméno}_{příjmení}_resume, kde budou sloupce date_start, date_end, job, education. 
-- Sloupcům definujte vhodné datové typy.
CREATE TABLE t_eliska_spilarova_resume (
	date_start date,
	date_end date,
	education varchar(255),
	job varchar(255)
	);

-- Úkol 3: Do tabulky t_{jméno}_{příjmení}_resume, kterou jste vytvořili v minulé části, vložte záznam se svým 
-- současným zaměstnáním nebo studiem.
INSERT INTO t_eliska_spilarova_resume
VALUES ('2020-05-01', null, 'FF UK', 'lektorka');

-- Úkol 4: K tabulce t_{jméno}_{příjmení}_resume přidejte dva sloupce: institution a role, které budou typu VARCHAR(255).
ALTER TABLE t_eliska-spilarova_resume ADD COLUMN "institution" VARCHAR(255);

ALTER TABLE t_eliska_spilarova_resume ADD COLUMN role VARCHAR(255);

-- Úkol 5: Do tabulky t_{jméno}_{příjmení}_resume doplňte informace o tom, v jaké firmě nebo škole jste v daný čas působili 
-- (sloupec institution) a na jaké pozici (sloupec role).
UPDATE t_eliska_spilarova_resume
SET institution = 'FF UK'
WHERE date_start = '2020-05-01';

UPDATE t_eliska_spilarova_resume
SET "role" = 'MA student, OR with English Literature'
WHERE date_start = '2020-05-01';

-- Úkol 6: Z tabulky t_{jméno}_{příjmení}_resume vymažte sloupce education a job.
ALTER TABLE t_eliska_spilarova_resume DROP COLUMN education;

ALTER TABLE t_eliska_spilarova_resume DROP COLUMN job;
