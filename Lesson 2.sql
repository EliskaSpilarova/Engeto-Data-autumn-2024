-- Cvičení: ORDER BY
-- Úkol 1: Vypište od všech poskytovatelů zdravotních služeb jméno a typ. Záznamy seřaďte podle jména vzestupně.
SELECT 
	name, 
	provider_type 
FROM healthcare_provider hp
ORDER BY name;

-- Úkol 2: Vypište od všech poskytovatelů zdravotních služeb ID, jméno a typ. 
-- Záznamy seřaďte primárně podle kódu kraje a sekundárně podle kódu okresu.
SELECT 
	provider_id,
	name,
	provider_type
FROM healthcare_provider hp 
ORDER BY region_code, district_code;

-- Úkol 3: Seřaďte na výpisu data z tabulky czechia_district sestupně podle kódu okresu.
SELECT *
FROM czechia_district cd 
ORDER BY code DESC;

-- Úkol 4: Vypište abecedně pět posledních krajů v ČR.
SELECT *
FROM czechia_region cr 
ORDER BY name desc 
LIMIT 5;

-- Úkol 5: Data z tabulky healthcare_provider vypište seřazena vzestupně dle typu poskytovatele a sestupně dle jména.
SELECT 
	name,
	provider_type 
FROM healthcare_provider hp 
ORDER BY provider_type ASC, name DESC;

-- Cvičení: CASE Expression
-- Úkol 1: Přidejte na výpisu k tabulce healthcare_provider nový sloupec is_from_Prague, 
-- který bude obsahovat 1 pro poskytovate z Prahy a 0 pro ty mimo pražské.
SELECT *,
	CASE
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END AS is_from_prague	
FROM healthcare_provider hp;

-- Úkol 2: Upravte dotaz z předchozího příkladu tak, aby obsahoval záznamy, které spadají jenom do Prahy.
SELECT *,
	CASE
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END AS is_from_prague	
FROM healthcare_provider hp
WHERE region_code = 'CZ010';

-- Úkol 3: Sestavte dotaz, který na výstupu ukáže název poskytovatele, město poskytování služeb, 
-- zeměpisnou délku a v dynamicky vypočítaném sloupci slovní informaci, jak moc na západě se poskytovatel nachází 
-- určete takto čtyři kategorie rozdělení.
SELECT
 	name, 
 	municipality, 
 	longitude,	
 	CASE
  		WHEN longitude < 14 THEN 'nejvíce na západě'
  		WHEN longitude < 16 THEN 'méně na západě'
  		WHEN longitude < 18 THEN 'více na východě'
  	ELSE 'nejvíce na východě'
 END AS czechia_position
FROM healthcare_provider;

-- Úkol 4: Vypište název a typ poskytovatele a v novém sloupci odlište, zda jeho typ je Lékárna nebo Výdejna zdravotnických prostředků.
SELECT 
	name,
	provider_type,
	CASE 
		WHEN provider_type = 'Lékárna' OR provider_type = 'Výdejna zdravotnických prostředků' THEN 1
		ELSE 0
	END AS is_desired_type
FROM healthcare_provider hp;

-- Cvičení: WHERE, IN a LIKE
-- Úkol 1: Vyberte z tabulky healthcare_provider záznamy o poskytovatelích, kteří mají ve jméně slovo nemocnice.
SELECT *
FROM healthcare_provider hp 
WHERE name LIKE '%nemocnice%';

-- Úkol 2: Vyberte z tabulky healthcare_provider jméno poskytovatelů, kteří v něm mají slovo lékárna.
-- Vytvořte další dynamicky vypsaný sloupec, který bude obsahovat 1, pokud slovem lékárna název začíná. 
-- V opačném případě bude ve sloupci 0.
SELECT name,
	CASE 
		WHEN name LIKE 'Lékárna%' THEN 1
		ELSE 0
	END AS je_to_lekarna	
FROM healthcare_provider hp 
WHERE name LIKE '%lékárna';

-- Úkol 3: Vypište jméno a město poskytovatelů, jejichž název města poskytování má délku čtyři písmena (znaky).
SELECT 
	name, 
	municipality 
FROM healthcare_provider hp 
WHERE municipality LIKE '____';

-- Úkol 4: Vypište jméno, město a okres místa poskytování u těch poskytovatelů, kteří jsou z Brna, 
-- Prahy nebo Ostravy nebo z okresů Most nebo Děčín.
SELECT 
	name, 
	municipality, 
	district_code 
FROM healthcare_provider
WHERE municipality IN ('Brno', 'Praha', 'Ostrava')
OR district_code IN ('CZ0425', 'CZ0421');

-- Úkol 5: Pomocí vnořeného SELECT vypište kódy krajů pro Jihomoravský a Středočeský kraj z tabulky czechia_region. 
-- Ty použijte pro vypsání ID, jména a kraje jen těch vyhovujících poskytovatelů z tabulky healthcare_provider.
SELECT 
	provider_id, 
	name, 
	region_code
FROM healthcare_provider AS hp 
WHERE region_code IN 
	(SELECT code FROM czechia_region AS cr WHERE name IN ('Jihomoravský kraj', 'Středočeský kraj'));

-- Úkol 6: Z tabulky czechia_district vypište jenom ty okresy, ve kterých se vyskytuje název města, 
-- které má délku čtyři písmena (znaky).
SELECT * 
FROM czechia_district AS cd 
WHERE code IN 
	(SELECT district_code FROM healthcare_provider AS hp  WHERE municipality  LIKE '____');

-- Pohledy (VIEW)
-- Úkol 1: Vytvořte pohled (VIEW) s ID, jménem, městem a okresem místa poskytování u těch poskytovatelů, kteří jsou z Brna, 
-- Prahy nebo Ostravy. Pohled pojmenujte v_healthcare_provider_subset.
CREATE OR REPLACE VIEW v_healthcare_provider_subset AS
	SELECT provider_id, name, municipality, district_code
	FROM healthcare_provider  
	WHERE municipality IN ('Brno', 'Praha', 'Ostrava');

-- Úkol 2: Vytvořte dva SELECT nad tímto pohledem. První vybere vše z něj, druhý vybere všechny poskytovatele 
-- z tabulky healthcare_provider, kteří se nenacházejí v pohledu v_healthcare_provider_subset.
CREATE OR REPLACE view v_heathcare_provider_subset as 
SELECT provider_id, name, municipality, district_code
FROM data_academy_content.healthcare_provider hp 
WHERE municipality in ('Brno', 'Praha', 'Ostrava');

-- Úkol 3: Smažte pohled z databáze.

DROP VIEW IF EXISTS v_healthcare_provider_subset;

--Bonusová cvičení: COVID-19 - ORDER BY

-- Úkol 1:
-- Vyberte sloupec country, date a confirmed z tabulky covid19_basic pro Rakousko. Seřaďte sestupně podle sloupce date.
SELECT 
	country,
	date,
	confirmed
FROM covid19_basic cb 
WHERE country = 'Austria'
ORDER BY date desc;

-- Úkol 2:
-- Vyberte pouze sloupec deaths v České republice.
SELECT
	deaths 
FROM covid19_basic cb 
WHERE country = 'Czechia';

-- Úkol 3:
-- Vyberte pouze sloupec deaths v České republice. Seřaďte sestupně podle sloupce date.
SELECT 
	deaths
FROM covid19_basic cb 
WHERE country = 'Czechia'
ORDER BY date DESC;

-- Úkol 4:
-- Zjistěte, kolik nakažených bylo k poslednímu srpnu 2020 po celém světě.
SELECT 
	sum(confirmed) 
FROM covid19_basic cb 
WHERE date = '2020-08-31';

-- Úkol 5:
-- Vyberte seznam provincií v US a seřadte jej podle názvu.
SELECT DISTINCT province
FROM covid19_detail_us cdu 
ORDER BY province;

-- Úkol 6:
-- Vyberte pouze Českou republiku, seřaďte podle datumu a vytvořte nový sloupec udávající rozdíl mezi recovered a confirmed.
SELECT 
	*,
	confirmed - recovered AS ill
FROM covid19_basic cb 
WHERE country = 'Czechia'
ORDER BY date;

-- Úkol 7:
-- Vyberte 10 zemí s největším přírůstkem k 1. 7. 2020 a seřaďte je od největšího nárůstů k nejmenšímu.
SELECT 
	country,
	confirmed
FROM covid19_basic_differences cbd _differences
WHERE date = '2020-07-01'
ORDER BY confirmed desc
LIMIT 10;

-- Úkol 8:
-- Vytvořte sloupec, kde přiřadíte 1 těm zemím, které mají přírůstek nakažených vetši než 10000 k 30. 8. 2020. 
-- Seřaďte je sestupně podle velikosti přírůstku nakažených.
SELECT 
	country,
	confirmed,
CASE
	WHEN confirmed > 10000
	THEN 1
	ELSE 0
END AS vetsi_nez_10000
FROM covid19_basic_differences cbd 
WHERE date = '2020-08-30'
ORDER BY confirmed DESC;

-- Úkol 9:
-- Zjistěte, kterým datumem začíná a končí tabulka covid19_detail_us.
SELECT DISTINCT date
FROM covid19_detail_us cdu 
ORDER BY date;

SELECT DISTINCT date
FROM covid19_detail_us cdu 
ORDER BY date desc;

-- Úkol 10:
-- Seřaďte tabulku covid19_basic podle států od A po Z a podle data sestupně.
SELECT *
FROM covid19_basic cb 
ORDER BY country, date DESC;

-- Bonusová cvičení: COVID-19 - WHERE, IN a LIKE
-- Úkol 1
-- Vytvořte view obsahující kumulativní průběh jen ve Spojených státech, Číně a Indii. Použijte syntaxi s IN.
CREATE VIEW v_view AS 
	SELECT *
	FROM covid19_basic cb 
	WHERE country IN ('USA', 'China', 'India');

-- Úkol 2
-- Vyfiltrujte z tabulky covid19_basic pouze země, které mají populaci větší než 100 milionů.
SELECT *
FROM covid19_basic cb 
WHERE country IN
	(SELECT DISTINCT country
	FROM lookup_table lt 
	WHERE population >= 100000000);

-- Úkol 3
-- Vyfiltrujte z tabulky covid19_basic pouze země, které jsou zároveň obsaženy v tabulce covid19_detail_us.
SELECT *
FROM covid19_basic cb 
WHERE country IN 
	(SELECT DISTINCT country
	FROM covid19_detail_us);

-- Úkol 4
-- Vyfiltrujte z tabulky covid19_basic seznam zemí, které měly alespoň jednou denní nárůst větší než 10 tisíc nově nakažených.
SELECT DISTINCT country
FROM covid19_basic cb 
WHERE country IN
	(SELECT DISTINCT country
	FROM covid19_basic_differences 
	WHERE confirmed >= 10000);

-- Úkol 5
-- Vyfiltrujte z tabulky covid19_basic seznam zemí, které nikdy neměly denní nárůst počtu nakažených větší než 1000.
SELECT DISTINCT country
FROM covid19_basic cb 
WHERE country NOT IN
	(SELECT country
	FROM covid19_basic_differences
	WHERE confirmed >= 1000);

-- Úkol 6
-- Vyfiltrujte z tabulky covid19_basic seznam zemí, které nezačínají písmenem A.
SELECT DISTINCT country
FROM covid19_basic cb 
WHERE country NOT LIKE 'A%';

-- Bonusová cvičení: COVID-19 - CASE Expression
-- Úkol 1
-- Vytvořte nový sloupec flag_vic_nez_10000. Zemím, které měly dne 30. 8. 2020 denní přírůstek nakažených vyšší než 10000, 
-- přiřaďte hodnotu 1, ostatním hodnotu 0. Seřaďte země sestupně podle počtu nově potvrzených případů.
SELECT 
	country,
	confirmed,
	CASE 
		WHEN confirmed > 10000 THEN 1
		ELSE 0
	END AS flag_vic_nez_10000
FROM covid19_basic_differences cbd 
WHERE date = '2020-08-30'
ORDER BY confirmed DESC;

-- Úkol 2
-- Vytvořte nový sloupec flag_evropa a označte slovem Evropa země Německo, Francie, Španělsko. Zbytek zemí označte slovem Ostatni.
SELECT *,
	CASE
		WHEN country IN ('Germany', 'France', 'Spain') THEN 'Evropa'
		ELSE 'Ostatni'
	END AS flag_evropa
FROM covid19_basic_differences cbd;

--Úkol 3
-- Vytvořte nový sloupec s názvem flag_ge. Do něj uložte pro všechny země, začínající písmeny "Ge", 
-- heslo GE zeme, ostatní země označte slovem Ostatni.
SELECT *,
	CASE 
		WHEN country = 'Ge%' THEN 'Ge zeme'
	ELSE 'Ostatni'
	END AS flag_ge
FROM covid19_basic_differences cbd;
	
-- Úkol 4
-- Využijte tabulku covid19_basic_differences a vytvořte nový sloupec category. Ten bude obsahovat tři kategorie podle počtu
-- nově potvrzených případů: 0-1000, 1000-10000 a >10000. Výslednou tabulku seřaďte podle data sestupně. 
-- Vhodně také ošetřete možnost chybějících nebo chybně zadaných dat.
SELECT *,
	CASE
		WHEN confirmed IS NULL OR confirmed >= 10000 THEN '>10000'
		WHEN confirmed >= 1000 AND confirmed < 10000 THEN '1000-10000'
		WHEN confirmed < 1000 THEN '0-1000'
		ELSE 'error'
	END AS category
FROM covid19_basic_differences cbd
ORDER BY date DESC;




	

	


	




