-- Úkol 1: Spojte tabulky czechia_price a czechia_price_category. Vypište všechny dostupné sloupce.
SELECT *
FROM czechia_price cp 
JOIN czechia_price_category cpc
	ON cp.category_code = cpc.code; 

-- Úkol 2: Předchozí příklad upravte tak, že vhodně přejmenujete tabulky a vypíšete ID a jméno kategorie potravin a cenu.
SELECT
	cp.id, 
	cpc.name,
	cp.value
FROM czechia_price cp 
JOIN czechia_price_category cpc
	ON cp.category_code = cpc.code; 

-- Úkol 3: Přidejte k tabulce cen potravin i informaci o krajích ČR a vypište informace o cenách společně s názvem kraje.
SELECT 
	cp.*,
	cr.name
FROM czechia_price cp 
LEFT JOIN czechia_region cr 
	ON cp.region_code = cr.code;

-- Úkol 4: Využijte v příkladě z předchozího úkolu RIGHT JOIN s výměnou pořadí tabulek.
SELECT
    cp.*, 
    cr.name
FROM czechia_region AS cr
RIGHT JOIN czechia_price AS cp
    ON cp.region_code = cr.code;

-- Úkol 5: K tabulce czechia_payroll připojte všechny okolní tabulky. Využijte ERD model ke zjištění, které to jsou.
SELECT *
FROM czechia_payroll cp 
JOIN czechia_payroll_calculation cpc ON calculation_code = cpc.code 
JOIN czechia_payroll_industry_branch cpib ON industry_branch_code = cpib.code 
JOIN czechia_payroll_unit cpu ON unit_code = cpu.code 
JOIN czechia_payroll_value_type cpvt ON value_type_code = cpvt.code;

-- Úkol 6: Přepište dotaz z předchozí lekce do varianty, ve které použijete JOIN
/*SELECT
    *
FROM czechia_payroll_industry_branch
WHERE code IN (
    SELECT
        industry_branch_code
    FROM czechia_payroll
    WHERE value IN (
        SELECT
            max(value)
        FROM czechia_payroll
        WHERE value_type_code = 5958
    )
);*/
SELECT *
FROM czechia_payroll cp 
JOIN czechia_payroll_industry_branch cpib 
ON cpib.code = cp.industry_branch_code
WHERE cp.value_type_code = 5958
ORDER BY cp.value DESC
LIMIT 1;

-- Úkol 7: Spojte informace z tabulek cen a mezd (pouze informace o průměrných mzdách). 
-- Vypište z každé z nich základní informace, celé názvy odvětví a kategorií potravin a datumy měření, které vhodně naformátujete.
