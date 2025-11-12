# Analyzing-an-Industry-layoff-dataset-using-Mysql
# AIMS AND OBJECTIVE
The aim of this project was to analyze a dataset containing data on Industry layoffs from 2020-2023 using MySQL

# KEY INSIGHTS AND FINDINGS
<img width="473" height="404" alt="image" src="https://github.com/user-attachments/assets/c6d999f7-a167-498a-9832-7d6565705f23" />
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




