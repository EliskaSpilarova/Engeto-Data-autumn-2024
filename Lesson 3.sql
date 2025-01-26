-- Cvičení: Funkce COUNT()
-- Úkol 1: Spočítejte počet řádků v tabulce czechia_price.
SELECT count(1)
FROM czechia_price cp;

-- Úkol 2: Spočítejte počet řádků v tabulce czechia_payroll s konkrétním sloupcem jako argumentem funkce count().
SELECT count(id) AS number_of_rows
FROM czechia_payroll cp;

-- Úkol 3: Z kolika záznamů v tabulce czechia_payroll jsme schopni vyvodit průměrné počty zaměstnanců?
SELECT count(id) AS rows_of_employees
FROM czechia_payroll cp 
WHERE value_type_code = 316
	AND value IS NOT NULL;

-- Úkol 4: Vypište všechny cenové kategorie a počet řádků každé z nich v tabulce czechia_price.
SELECT category_code,
	count(id) AS number_of_rows 
FROM czechia_price cp 
GROUP BY category_code;

-- Úkol 5: Rozšiřte předchozí dotaz o dodatečné rozdělení dle let měření.
SELECT category_code,
	date_part('year', date_from) AS year_row,
	count(id) AS number_of_rows 
FROM czechia_price cp 
GROUP BY 
	category_code,
	year_row
ORDER BY 
	year_row,
	category_code;

-- Cvičení: Funkce SUM()
-- Úkol 1: Sečtěte všechny průměrné počty zaměstnanců v datové sadě průměrných platů v České republice.
SELECT sum(value) AS sum_value
FROM czechia_payroll cp 
WHERE value_type_code = 316;

-- Úkol 2: Sečtěte průměrné ceny pro jednotlivé kategorie pouze v Jihomoravském kraji.
SELECT category_code,
	sum(value) AS sum_of_average_prices
FROM czechia_price 
WHERE region_code = 'CZ064'
GROUP BY category_code;

-- Úkol 3: Sečtěte průměrné ceny potravin za všechny kategorie, u kterých měření probíhalo od (date_from) 15. 1. 2018.
SELECT sum(value) AS sum_of_average_prices
FROM czechia_price
WHERE date_from = '2018-01-15';

-- Úkol 4: Vypište tři sloupce z tabulky czechia_price: kód kategorie, počet řádků pro ni a sumu hodnot průměrných cen. 
-- To vše pouze pro data v roce 2018.
SELECT category_code,
	count(id) AS number_of_rows,
	sum(value) AS sum_of_average_prices
FROM czechia_price cp
WHERE date_part ('year', date_from) = 2018
GROUP BY category_code;

-- Cvičení: Další agregační funkce
-- Úkol 1: Vypište maximální hodnotu průměrné mzdy z tabulky czechia_payroll.
SELECT max(value)
FROM czechia_payroll cp 
WHERE value_type_code = 5958;

-- Úkol 2: Na základě údajů v tabulce czechia_price vyberte pro každou kategorii potravin její minimum v letech 2015 až 2017.
SELECT category_code,
    min(value) AS category_minumum	
FROM czechia_price
WHERE date_part('year', date_from) BETWEEN 2015 AND 2017
GROUP BY category_code;

-- Úkol 3: Vypište kód (případně i název) odvětví s historicky nejvyšší průměrnou mzdou.
SELECT industry_branch_code
FROM czechia_payroll
WHERE value IN (
    SELECT
        max(value)
    FROM czechia_payroll
    WHERE value_type_code = 5958
);
 
-- Úkol 4: Pro každou kategorii potravin určete její minimum, maximum a vytvořte nový sloupec s názvem difference, 
-- ve kterém budou hodnoty "rozdíl do 10 Kč", "rozdíl do 40 Kč" a "rozdíl nad 40 Kč" na základě rozdílu minima a maxima. 
-- Podle tohoto rozdílu data seřaďte.
SELECT category_code,
	min(value),
	max(value),
	CASE 
		WHEN max(value) - min(value) <= 10 THEN 'rozdíl do 10 Kč'
		WHEN max(value) - min(value) < 40 THEN 'rozdíl do 40 Kč'
		ELSE 'rozdíl nad 40 Kč'
	END AS difference
FROM czechia_price	
GROUP BY category_code
ORDER BY difference;

-- Úkol 5: Vyberte pro každou kategorii potravin minimum, maximum a aritmetický průměr (v našem případě průměr z průměrů)
-- zaokrouhlený na dvě desetinná místa.
SELECT category_code,
	max(value),
	min(value),
	round(avg(value)::NUMERIC, 2) AS average
FROM czechia_price cp 
GROUP BY category_code; 

-- Úkol 6: Rozšiřte předchozí dotaz tak, že data budou rozdělena i podle kódu kraje a seřazena sestupně podle aritmetického průměru.
SELECT category_code,
	region_code, 
	max(value),
	min(value),
	round(avg(value)::NUMERIC, 2) AS average
FROM czechia_price cp 
GROUP BY category_code,
	region_code
ORDER BY average DESC;

-- Bonusová cvičení: COVID-19 - funkce SUM()
-- Úkol 1: Vytvořte v tabulce covid19_basic nový sloupec, kde od confirmed odečtete polovinu recovered 
-- a přejmenujete ho jako new_column. Seřaďte podle data sestupně.
SELECT 	*,
	confirmed - recovered / 2 AS new_column
FROM covid19_basic cb 
ORDER BY date DESC;

-- Úkol 2: Kolik lidí se celkem uzdravilo na celém světě k 30.8.2020?
SELECT 	sum(recovered)
FROM covid19_basic cb 
WHERE date = ('2020-08-30');

-- Úkol 3: Kolik lidí se celkem uzdravilo, a kolik se jich nakazilo na celém světě k 30.8.2020?
SELECT 	sum(recovered) AS recovered,
	sum(confirmed) AS confirmed
FROM covid19_basic cb 
WHERE date = ('2020-08-30');

-- Úkol 4: Jaký je rozdíl mezi nakaženými a vyléčenými na celém světě k 30.8.2020?
SELECT 	sum(confirmed) - sum(recovered) AS difference
FROM covid19_basic cb 
WHERE date = ('2020-08-30');

-- Úkol 5: Z tabulky covi19_basic_differences zjistěte, kolik lidí se celkem nakazilo v České republice k 30.8.2020.
SELECT sum(confirmed)
FROM covid19_basic_differences cbd 
WHERE date = ('2020-08-30') 
	AND country = 'Czechia';

-- Úkol 6: Kolik lidí se nakazilo v jednotlivých zemích během srpna 2020?
SELECT sum(confirmed),
	country
FROM covid19_basic_differences cbd 
WHERE date >= ('2020-08-01') AND date <= ('2020-08-31')
GROUP BY country;
 
-- Úkol 7: Kolik lidí se nakazilo v České republice, na Slovensku a v Rakousku mezi 20.8.2020 a 30.8.2020 včetně?
SELECT country,
	sum(confirmed)
FROM covid19_basic cb 
WHERE date >= ('2020-08-20') AND date <= ('2020-08-30')
	AND country IN 
		('Czechia', 'Slovakia', 'Austria')
GROUP BY country;

-- Úkol 8: Jaký byl největší přírůstek v jednotlivých zemích?
SELECT max(confirmed),
	country
FROM covid19_basic_differences cbd 
GROUP BY country;

-- Úkol 9: Zjistěte největší přírůstek v zemích začínajících na C.
SELECT max(confirmed),
	country
FROM covid19_basic_differences cbd 
WHERE country LIKE 'C%';
GROUP BY country;

-- Úkol 10: Zjistěte celkový přírůstek všech zemí s populací nad 50 milionů. Tabulku seřaďte podle datumu od srpna 2020.
SELECT sum(confirmed),
	country,
	date
FROM covid19_basic_differences cbd 
WHERE 
	country in
	(SELECT country
	FROM countries c 
	WHERE population > 50000000
	)
	AND date >= '2020-08-01'
GROUP BY date,
	country;
ORDER BY date 

-- Úkol 11: Zjistěte celkový počet nakažených v Arkansasu (použijte tabulku covid19_detail_us_differences).
SELECT sum(confirmed)
FROM covid19_detail_us_differences cdud 
WHERE province = 'Arkansas';

-- Úkol 12: Zjistětě nejlidnatější provincii v Brazílii.
SELECT province,
	population
FROM lookup_table lt 
	WHERE 
		country = 'Brazil'
		AND province IS NOT NULL
		AND population IS NOT NULL 
ORDER BY population DESC 
LIMIT 1;

-- Úkol 13: Zjistěte celkový a průměrný počet nakažených denně po dnech a seřaďte podle data sestupně 
-- (průměr zaokrouhlete na dvě desetinná čísla)
SELECT sum(confirmed) AS sum_confirmed,
	avg(confirmed) AS avg_confirmed,
	date
FROM covid19_basic_differences cbd 
GROUP BY date
ORDER BY date DESC;

-- Úkol 14: Zjistěte celkový počet nakažených lidí v jednotlivých provinciích USA dne 10.08.2020 (použijte tabulku covid19_detail_us).
SELECT sum(confirmed) AS total_confirmed,
	province
FROM covid19_detail_us cdu 
WHERE date = '2020-08-10'
GROUP BY province;

-- Úkol 15: Zjistěte celkový přírůstek podle datumu a země.
SELECT sum(confirmed) AS confirmed,
	date,
	country
FROM covid19_basic cb 
GROUP BY date,
	country; 

-- Bonusová cvičení: COVID-19 - funkce AVG() a COUNT()

-- Úkol 1: Zjistěte průměrnou populaci ve státech ležících severně od 60 rovnoběžky.
SELECT 
    avg(population)
FROM lookup_table lt 
WHERE lat >= 60
    AND province IS NULL;

-- Úkol 2: Zjistěte průměrnou, nejvyšší a nejnižší populaci v zemích ležících severně od 60 rovnoběžky.
-- Spočítejte, kolik takových zemích je. Vytvořte sloupec max_min_ratio, ve kterém nejvyšší populaci vydělíte nejnižší.
SELECT 
    avg(population),
    max(population),
    min(population),
    count(DISTINCT country),
    (max(population) / min(population)) AS max_min_ratio
FROM lookup_table lt 
WHERE lat >= 60;

-- Úkol 3: Zjistěte průměrnou populaci a rozlohu v zemích seskupených podle náboženství. 
-- Zjistěte také počet zemí pro každé náboženství.
SELECT round(avg(population)),
	round(avg(surface_area)),
	religion,
	count(country)
FROM countries
GROUP BY religion;

-- Úkol 4: Zjistěte počet zemí, kde se platí dolarem (jakoukoli měnou, která má v názvu dolar).
-- Zjistěte nejvyšší a nejnižší populaci mezi těmito zeměmi.
SELECT count(country),
	max(population),
	min(population)
FROM countries
WHERE lower(currency_name) LIKE '%dollar%';

-- Úkol 5: Zjistěte, kolik zemí platících Eurem leží v Evropě a kolik na jiných kontinentech.
SELECT continent,
	count(country) 
FROM countries c
WHERE currency_code = 'EUR'
GROUP BY continent;

-- Úkol 6: Zjistěte, pro kolik zemí známe průměrnou výšku jejích obyvatel.
SELECT count (1)
FROM countries c 
WHERE avg_height IS NOT NULL; 

-- Úkol 7: Zjistěte průměrnou výšku obyvatel na jednotlivých kontinentech.
SELECT sum(avg_height),
	continent
FROM countries
WHERE avg_height IS NOT null
GROUP BY continent;

-- Úkol 8: Zjistěte průměrnou hustotu zalidnění pro světový region (region_in_world). Srovnejte byčejný a vážený průměr. 
-- Váhou bude v tomto případě rozloha státu (surface_area). Výslednou tabulku uložte jako v_{jméno}_{příjmení}_population_density.
 -- Poznámka: V tomto případě nepočítáme "průměr průměrů", ale průměr zlomků (hustota zalidnění = populace / rozloha). 
 -- Vyzkoušejte si, co by se stalo, pokud bychom jako váhu použili nikoli rozlohu (jmenovatel), ale populaci (čitatel). 
 -- Jaká varianta Vám přijde vhodnější?--
CREATE OR REPLACE VIEW v_eliska_population_density AS

SELECT 
    region_in_world, 
    round(avg(population_density::numeric), 2) AS simple_avg_density, 
    round(sum(surface_area::numeric * population_density::numeric) / sum(surface_area::numeric), 2) AS weighted_avg_density
FROM countries c
WHERE 
    population_density IS NOT NULL 
    AND region_in_world IS NOT NULL
GROUP BY 
    region_in_world;

SELECT 
    vd.*,
    abs(simple_avg_density - weighted_avg_density) AS diff_avg_density
FROM v_eliska_population_density vd 
ORDER BY 
    diff_avg_density DESC;

-- Úkol 10: Vyberte název, hustotu zalidnění a rozlohu zemí v západní Evropě. 
-- Najděte stát s nejvyšší hustotou zalidnění. Spočítejte obyčejný a vážený průměr hustoty zalidnění v západní Evropě 
--kromě státu s nejvyšší hustotou. Výsledky srovnejte s oběma průměry spočítanými ze všech zemí.
SELECT 
    0 AS monaco_included,
    round(avg(population_density::numeric), 2) AS simple_avg_density ,
    round(sum(surface_area::numeric * population_density::numeric) / sum(surface_area::numeric), 2) AS weighted_avg_density
FROM countries c 
WHERE 
    region_in_world = 'Western Europe' 
    AND country != 'Monaco';
