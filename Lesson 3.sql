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
SELECT 
	category_code,
	count(id) AS number_of_rows 
FROM czechia_price cp 
GROUP BY category_code;

-- Úkol 5: Rozšiřte předchozí dotaz o dodatečné rozdělení dle let měření.
SELECT 
	category_code,
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
SELECT 
	category_code,
	sum(value) AS sum_of_average_prices
FROM czechia_price 
WHERE region_code = 'CZ064'
GROUP BY category_code;

-- Úkol 3: Sečtěte průměrné ceny potravin za všechny kategorie, u kterých měření probíhalo od (date_from) 15. 1. 2018.
SELECT 
	sum(value) AS sum_of_average_prices
FROM czechia_price
WHERE date_from = '2018-01-15';

-- Úkol 4: Vypište tři sloupce z tabulky czechia_price: kód kategorie, počet řádků pro ni a sumu hodnot průměrných cen. 
-- To vše pouze pro data v roce 2018.
SELECT 
	category_code,
	count(id) AS number_of_rows,
	sum(value) AS sum_of_average_prices
FROM czechia_price cp
WHERE date_part ('year', date_from) = 2018
GROUP BY category_code;

-- Cvičení: Další agregační funkce
-- Úkol 1: Vypište maximální hodnotu průměrné mzdy z tabulky czechia_payroll.
SELECT 
	max(value)
FROM czechia_payroll cp 
WHERE value_type_code = 5958;

-- Úkol 2: Na základě údajů v tabulce czechia_price vyberte pro každou kategorii potravin její minimum v letech 2015 až 2017.
SELECT 
	category_code,
    min(value) AS category_minumum	
FROM czechia_price
WHERE date_part('year', date_from) BETWEEN 2015 AND 2017
GROUP BY category_code;

-- Úkol 3: Vypište kód (případně i název) odvětví s historicky nejvyšší průměrnou mzdou.
SELECT
    industry_branch_code
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
