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



	

	


	




