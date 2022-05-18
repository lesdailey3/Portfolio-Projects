/*
COVID 19 Data Exploration

Skills Displayed: Joins, CTE's, Temp Tables, Window Functions, Aggregate Functions, Creatings Views, Converting Data Types

*/


--Verifying data was imported correctly by inspection
--All data current to 2022-04-20
SELECT *
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4;

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4;

--Data that will be used:

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2;

-- Inspecting Total Cases vs Total Deaths
--Probability of dying to COVID in United States approximately 3-6% in beginning of pandemic and now only 1.2% 

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as case_fatality_perc
FROM PortfolioProject..CovidDeaths
WHERE Location = 'United States'
ORDER BY 1,2;

--Inspecting Total Cases to Total Population
--24% of population has had COVID in the United States

SELECT Location, date, total_cases, population, (total_cases/population) * 100 as population_contration_perc
FROM PortfolioProject..CovidDeaths
WHERE Location = 'United States'
ORDER BY 2;

--Inspecting Countries with Highest Infection Rate compared to Population
--U.S. at 24% (53rd country) where-as country with highest infection rate (Faeroe Islands) is at 70%, although their population is quite small at 49,053

SELECT Location, MAX(total_cases) AS total_case_count, population, MAX((total_cases/population)) * 100 as population_contration_perc
FROM PortfolioProject..CovidDeaths
GROUP BY Location, population
ORDER BY population_contration_perc DESC;

--Inspecting Countries with Highest Death Count 
-- United States by far has the most deaths at close to 1MM with 2nd place being around 660M, Brazil

SELECT Location, MAX(CAST(total_deaths AS INTEGER)) as total_death_count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY total_death_count DESC;

--Inspecting by Continent Total Death Count
--Top 3: Europe, North America, and Asia

SELECT location, MAX(CAST(total_deaths AS INTEGER)) as total_death_count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL AND Location NOT IN ('Upper middle income', 'Lower middle income', 'Low income', 'High income', 'International')
GROUP BY Location
ORDER BY total_death_count DESC;

--Global Values
--Inspecting cumulative sum of total cases and total deaths by day and it's effect on case_fataility percentage across the world
--Started out in high single digits for case fatality percentage and is now only about 0.5%

SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as INTEGER)) as total_deaths, SUM(CAST(new_deaths as INTEGER))/SUM(new_cases)*100 as case_fatatility_perc
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

--Inspecting Overall Case Fatality Percentage across the Globe
--1.2%

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as INTEGER)) as total_deaths, SUM(CAST(new_deaths as INTEGER))/SUM(new_cases)*100 as case_fatatility_perc
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

--Inspecting Total Population vs Vaccinations
--171% is the cum_avg_vaccinated for United States or 570MM doses of vaccines have been administered to Americans.

WITH cum_sum_vac
AS (
	SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(CAST(v.new_vaccinations AS BIGINT)) OVER(PARTITION BY d.location ORDER BY d.location, d.date) AS cum_sum_vaccinated
	FROM PortfolioProject..CovidDeaths d
	JOIN PortfolioProject..CovidVaccinations v
		ON d.location = v.location
		AND d.date = v.date
	WHERE d.continent IS NOT NULL 
	)
SELECT *, (cum_sum_vaccinated/population) * 100 as cum_avg_vaccinated
FROM cum_sum_vac;

--Temp Table Example, an alternative to completing same query as above

DROP TABLE IF EXISTS #CumSumVaccinated
CREATE TABLE #CumSumVaccinated
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME,
Population NUMERIC,
new_vaccinations NUMERIC,
cum_sum_vaccinated NUMERIC
)
INSERT INTO #CumSumVaccinated
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(CAST(v.new_vaccinations AS BIGINT)) OVER(PARTITION BY d.location ORDER BY d.location, d.date) AS cum_sum_vaccinated
FROM PortfolioProject..CovidDeaths d
JOIN PortfolioProject..CovidVaccinations v
	ON d.location = v.location
	AND d.date = v.date
WHERE d.continent IS NOT NULL 

SELECT *, (cum_sum_vaccinated/population) * 100 as cum_avg_vaccinated
FROM #CumSumVaccinated;

-- Creating Views for use in visualizations later

CREATE VIEW total_deaths_by_continent AS
SELECT location, MAX(CAST(total_deaths AS INTEGER)) as total_death_count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL AND Location NOT IN ('Upper middle income', 'Lower middle income', 'Low income', 'High income', 'International')
GROUP BY Location;

CREATE VIEW cum_avg_vaccinated AS
WITH cum_sum_vac
AS (
	SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(CAST(v.new_vaccinations AS BIGINT)) OVER(PARTITION BY d.location ORDER BY d.location, d.date) AS cum_sum_vaccinated
	FROM PortfolioProject..CovidDeaths d
	JOIN PortfolioProject..CovidVaccinations v
		ON d.location = v.location
		AND d.date = v.date
	WHERE d.continent IS NOT NULL 
	)
SELECT *, (cum_sum_vaccinated/population) * 100 as cum_avg_vaccinated
FROM cum_sum_vac;