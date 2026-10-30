-- EXPLORATORY DATA ANALYSIS (EDA)
-- Objective: Explore layoff trends, identify patterns, and analyze layoffs across companies, industries, countries and time periods.


-- Step 1: Explore the dataset
-- Get an overview of the cleaned dataset.

SELECT *
FROM layoffs_staging2;


-- Step 2: Identify maximum lay offs
-- Find the highest number of employees laid off and the highest percentage of layoffs.

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;


-- Step 3: Idetify companies with 100% layoffs
-- Find companies that laid off their entire workforce. Sort by funds raised to identify companies that received significant funding before shutting down.

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- Step 4: Analyze total layoffs of the company
-- Calculate the total number of employees laid off by each company and identify the most affected.

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


-- Step 5: Analyze total layoff industries
-- Compare layoffs across different industries to identify which sectors were most affected.

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


-- Step 6: Analyze total layoffs by countries
-- Calculate layoffs across different countries to identify geographical patterns and trends.

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


-- Step 7: Identify the dataset by data range
-- Find the earliest and latest recorded dates to understand the time period covered.

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


-- STEP 8: Analyze yearly layoff trends
-- Calculate total layoffs for each year to identify changes over time.

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


-- Step 9: Analyze layoffs by funding stage
-- Compare total layoffs across different company funding stages to identify affected business stages.

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;

SELECT *
FROM layoffs_staging2;


-- Step 10: Analyze monthly layoffs trends
-- Extract the year and month from the date column and calculate the total layoffs for each month.
-- Exclude records with missing dates.

SELECt SUBSTRING(`date`, 1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) iS NOT NULL
GROUP BY `MONTH`
ORDER BY 1;


-- Step 11: Calculate rolling total of the layoffs
-- Use a CTE to calculate monthly layoffs first.
-- Then apply a window function to calculate the cumulative number of layoffs over time.
-- This helps identify how layoffs accumulated throughout the dataset's time period.

WITH Rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) is NOT NULL
GROUP BY month
ORDER BY 1
)
select `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS `Month`
FROM Rolling_total;


-- Step 12: Rank companies by yearly layoffs
-- Calculate total layoffs for each company per year.
-- Use DENSE_RANK() to rank companies within each year based on their total number of layoffs.
-- Retrieve the top 5 companies with the highest layoffs for each year.

WITH Company_year (company, `year`, total_laid_off) AS 
(
SELECT company, year(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, year(`date`)
), Company_year_rank AS
(
SELECT *,
DENSE_RANK() OVER(partition by `year` ORDER BY total_laid_off DESC) AS ranking
FROM Company_year
WHERE `year` is not null)
SELECT *
FROM Company_year_rank
WHERE ranking <= 5;