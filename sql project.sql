
SELECT * 
FROM layoffs_db.industry_layoffs;


UPDATE industry_layoffs
SET date = STR_TO_DATE(date, '%m/%d/%Y');

ALTER TABLE industry_layoffs
MODIFY COLUMN date DATE;


SELECT MAX(total_laid_off)
FROM layoffs_db.industry_layoffs;



SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs_db.industry_layoffs
WHERE  percentage_laid_off IS NOT NULL; 


SELECT *
FROM layoffs_db.industry_layoffs
WHERE  percentage_laid_off = 1;
-- these are mostly startups it looks like who all went out of business during this time


SELECT *
FROM layoffs_db.industry_layoffs
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- BritishVolt raised the most funds and went under



-- Top 5 Companies with the biggest single Layoff

SELECT company, total_laid_off
FROM layoffs_db.industry_layoffs
ORDER BY 2 DESC
LIMIT 5;


-- Top 10 Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_db.industry_layoffs
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;



-- by location
SELECT location, SUM(total_laid_off)
FROM layoffs_db.industry_layoffs
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;


-- by country
SELECT country, SUM(total_laid_off)
FROM layoffs_db.industry_layoffs
GROUP BY country
ORDER BY 2 DESC;

-- total laid off each year
SELECT YEAR(date) , SUM(total_laid_off)
FROM layoffs_db.industry_layoffs
WHERE DATE IS NOT NULL
GROUP BY YEAR(date)
ORDER BY 1 ASC;


-- total laid off by industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_db.industry_layoffs
GROUP BY industry
ORDER BY 2 DESC;

-- total laid off and the stage the companies were at
SELECT stage, SUM(total_laid_off)
FROM layoffs_db.industry_layoffs
GROUP BY stage
ORDER BY 2 DESC;

-- Highest companies with total laid off each year
WITH Company_Year AS 
(
  SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_db.industry_layoffs
  GROUP BY company, YEAR(`date`)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;



-- total amount laid off from 2020 - 2023
WITH DATE_CTE AS 
(
SELECT SUBSTRING(`date`,1,7) as month, SUM(total_laid_off) AS total_laid_off
FROM layoffs_db.industry_layoffs
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY month
ORDER BY month ASC
)
SELECT month, total_laid_off, SUM(total_laid_off) OVER (ORDER BY month ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY 1 ASC;