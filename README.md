# 🌍 World Layoffs Analysis – SQL Data Cleaning & Exploratory Data Analysis (EDA)

## 📌 Project Overview

This project focuses on cleaning, transforming, and exploring a global layoffs dataset using **MySQL**. The objective is to identify data quality issues, standardize inconsistent records, handle missing values, and uncover meaningful insights into global workforce layoffs.

Through SQL-based data cleaning and Exploratory Data Analysis (EDA), this project explores layoff trends across companies, industries, countries, funding stages, and time periods.

## 🎯 Project Objectives

- Identify and remove duplicate records.
- Standardize inconsistent text values and date formats.
- Investigate and handle missing values.
- Explore global layoff patterns and trends.
- Identify companies and industries most affected by layoffs.
- Analyze yearly and monthly layoff trends.
- Calculate cumulative layoffs over time.
- Rank companies based on their yearly layoff figures.

## 🛠️ Technologies Used

- **Database:** MySQL
- **Language:** SQL
- **Dataset:** World Layoffs Dataset (Kaggle)

## 📂 Dataset

The project uses the World Layoffs dataset, which contains information about company layoffs across different industries and countries.

**Dataset Source:** [World Layoffs Dataset – Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022)

### Key Columns

| Column | Description |
|---|---|
| company | Company name |
| location | Company location |
| industry | Industry category |
| total_laid_off | Number of employees laid off |
| percentage_laid_off | Percentage of workforce laid off |
| date | Date of layoffs |
| stage | Company funding stage |
| country | Country where layoffs occurred |
| funds_raised_millions | Total funds raised in millions |

## 🧹 Part 1: Data Cleaning

The first stage focused on improving data quality and preparing the dataset for analysis.

### Cleaning Steps

1. **Created Staging Tables**
   - Created staging tables to preserve the original dataset.
   - Performed all cleaning operations on separate tables.

2. **Removed Duplicate Records**
   - Used `ROW_NUMBER()` with `PARTITION BY` to identify duplicate records.
   - Inspected potential duplicates before deleting them.
   - Retained one record from each duplicate group.

3. **Standardized Data**
   - Used `TRIM()` to remove unnecessary spaces from company names.
   - Standardized inconsistent industry values, including cryptocurrency-related labels.
   - Corrected inconsistent country names.
   - Converted date strings into the proper `DATE` data type using `STR_TO_DATE()`.

4. **Handled Missing Values**
   - Converted empty industry values into `NULL`.
   - Used self-joins to populate missing industry values where matching company and location records contained valid information.
   - Investigated missing layoff figures.

5. **Removed Unnecessary Records**
   - Removed records where both `total_laid_off` and `percentage_laid_off` were missing.
   - Removed the temporary `row_num` column after duplicate removal.

## 📊 Part 2: Exploratory Data Analysis (EDA)

After cleaning the dataset, SQL queries were used to explore trends, patterns, and insights.

### Analysis Performed

| Analysis | Description |
|---|---|
| Maximum Layoffs | Identified the highest number and percentage of layoffs. |
| 100% Layoffs | Identified companies that laid off their entire workforce. |
| Company Analysis | Ranked companies based on total layoffs. |
| Industry Analysis | Compared layoffs across different industries. |
| Country Analysis | Identified countries with the highest layoffs. |
| Yearly Trends | Analyzed total layoffs across different years. |
| Funding Stage Analysis | Explored layoffs across different company funding stages. |
| Monthly Trends | Examined monthly layoff patterns. |
| Rolling Total | Calculated cumulative layoffs over time. |
| Yearly Company Rankings | Identified the top five companies with the highest layoffs per year. |

## 💡 Key SQL Concepts Demonstrated

This project demonstrates practical applications of the following SQL concepts:

- Data Definition Language (DDL)
- Data Manipulation Language (DML)
- `CREATE TABLE` and `ALTER TABLE`
- `INSERT`, `UPDATE`, and `DELETE`
- Aggregate Functions (`SUM`, `MAX`, `MIN`)
- Filtering and Sorting (`WHERE`, `ORDER BY`)
- Data Grouping (`GROUP BY`)
- String Functions (`TRIM`, `SUBSTRING`)
- Date Functions (`YEAR`, `STR_TO_DATE`)
- Window Functions (`ROW_NUMBER`, `DENSE_RANK`, `SUM() OVER`)
- Common Table Expressions (CTEs)
- Self-Joins
- Data Cleaning and Exploratory Data Analysis

## 📁 Project Structure

```text
World-Layoffs-SQL-Project/
│
├── Data_Cleaning.sql
│
├── Exploratory_Data_Analysis.sql
│
└── README.md
```

## 🚀 How to Run the Project

1. Download the dataset from Kaggle.
2. Install and open MySQL Workbench or another MySQL-compatible environment.
3. Create a database named `world_layoffs`.
4. Import the original dataset into a table named `layoffs`.
5. Open and execute `Data_Cleaning.sql`.
6. Execute `Exploratory_Data_Analysis.sql` using the cleaned staging table.

**Note:** Run the data cleaning script before executing the EDA script, as the analysis uses the cleaned `layoffs_staging2` table.

## 📚 What I Learned

Through this project, I gained practical experience in:

- Working with real-world datasets in MySQL.
- Identifying and resolving common data quality issues.
- Applying SQL window functions to detect duplicates and rank records.
- Using CTEs and self-joins to simplify complex queries.
- Transforming raw data into structured and analysis-ready datasets.
- Performing Exploratory Data Analysis to identify meaningful patterns and trends.

## 👨‍💻 Author

**Rajeshwaran Abiraj**

Aspiring Data Analyst | Data Engineering Enthusiast

- [GitHub](https://github.com/Abiraj21012)
- [LinkedIn](https://www.linkedin.com/in/rajeshwaran-abiraj-a3565a255/)
- [Portfolio](https://abiraj-portfolio.vercel.app/)

---

⭐ If you find this project interesting, feel free to explore the SQL scripts and share your feedback!
