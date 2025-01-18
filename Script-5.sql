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
