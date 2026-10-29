-- SQL DATA CLEANING PROJECT
-- Dataset: World Layoffs
-- Objective: Clean and prepare the dataset for analysis


-- Step 1: Explore the original data
-- View the raw dataset before making any changes.

SELECT *
FROM layoffs;


-- Step 2: Create a staging table
-- Create a copy of the original table to preserve
-- the raw data and perform cleaning separately.

CREATE TABLE layoffs_staging
LIKE layoffs;

-- Verify that the staging table was created.
SELECT *
FROM layoffs_staging;

-- Copy all records from the original table.
INSERT INTO layoffs_staging
SELECT *
FROM layoffs;



-- Steo 3: Identify duplicate records
-- Use ROW_NUMBER() to number records within groups
-- that share the same selected column values.

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, percentage_laid_off, 'date')
FROM layoffs_staging;

-- Identify duplicate records using all relevant columns to avoid deleting legitimate entries.
WITH duplicate_cte AS (
	SELECT *,
    ROW_NUMBER() OVER(
    PARTITION BY Company, location, industry, total_laid_off,
    percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
    FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = "Casper";


-- Step 4: Create a cleaning data with row numbers
-- Create a second staging table with an additional
-- row_num column to identify duplicate records.

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_staging2;

-- Copy the data and assign a row number to each record within groups of identical records.
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Company, location, industry, total_laid_off,
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Remove duplicate records while retaining one record from each duplicate group.
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;


-- Step 5: Standardize text values
-- Remove unnecessary leading and trailing spaces from company names.

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT distinct industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
WHERE country LIKE "United States%";

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE "United States%";


-- Step 6: Convert date values
-- Convert date strings into MySQL DATE format for accurate date filtering and analysis.

SELECT `date`,
str_to_date(`date`, "%m/%d/%Y")
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, "%m/%d/%Y");

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- Step 7: Investigate missing values
-- Identify records where both layoff figures
-- are missing before deciding how to handle them.

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = "";

SELECT *
FROM layoffs_staging2
WHERE company = "Airbnb";

UPDATE layoffs_staging2
SET industry = null
WHERE industry = "";

SELECT *
FROM layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
where (t1.industry = "" OR t1.industry IS NULL)
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


-- Step 8: Remove records with missing value data
-- Review records where both the number of layoffs
-- and the percentage laid off are unavailable.

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


-- Step 9: Finalize the cleaned dataset
-- Remove the temporary row_num helper column.

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;