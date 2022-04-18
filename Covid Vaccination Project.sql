SELECT * 
FROM PortfolioProject..CovidVaccination
ORDER BY 3,4;

--SELECT * 
--FROM PortfolioProject..CovidVaccination
--ORDER BY 3,4;

--Data Needed

SELECT Location, date, population, total_cases, new_cases, total_deaths
FROM PortfolioProject..CovidDeath
ORDER BY 1,2;


--Total Cases Vs Total Deaths

SELECT Location, date, total_cases, total_deaths, ROUND(((total_deaths/total_cases)*100),3)  AS Percentage_of_death_cases
FROM PortfolioProject..CovidDeath
WHERE Continent IS NOT NULL
ORDER BY 1,3;

--Total Cases Vs Total Deaths in USA
SELECT Location, CAST(date AS DATE) Date, CAST(total_cases AS INT) TotalCases, total_deaths, ROUND(((total_deaths/total_cases)*100),3)  AS Percent_of_cases_to_population
FROM PortfolioProject..CovidDeath
WHERE location = 'Nigeria'
AND
Continent IS NOT NULL
ORDER BY 2 DESC;

--Total Cases Vs Population
SELECT Location, date, population, total_cases,  ROUND(((total_cases/population)*100),3)  AS Percentage_of_death_cases
FROM PortfolioProject..CovidDeath
WHERE Continent IS NOT NULL
--WHERE location LIKE '%state%'
ORDER BY 1,2;

--Countries with highest death count per population
SELECT Location,  MAX(CAST(total_deaths AS INT))  AS Total_death_count
FROM PortfolioProject..CovidDeath
WHERE Continent IS NOT NULL
GROUP BY Location
ORDER BY Total_death_count DESC;


--Continents with highest death count per population
SELECT continent,  MAX(CAST(total_deaths AS INT))  AS Total_death_count
FROM PortfolioProject..CovidDeath
WHERE Continent IS NOT NULL
GROUP BY continent
ORDER BY Total_death_count DESC;

--Global Numbers
SELECT date, SUM(CAST(new_cases AS INT)) New_Cases, SUM(CAST(new_deaths AS INT)) New_Deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Percent_Cases_Deaths
FROM PortfolioProject..CovidDeath
WHERE Continent IS NOT NULL
GROUP BY date
ORDER BY date DESC, New_Cases DESC;

--Exploring Vaccinations Table
With PopvsVac(Continent, Location, Date, Population, New_vaccinations, Cummulative_Vaccination
)
as
(SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CONVERT(float,cv.new_vaccinations)) OVER(partition by cd.location ORDER BY cd.location, cd.date) Cummulative_Vaccination
FROM PortfolioProject..CovidDeath AS cd
JOIN
PortfolioProject..CovidVaccinationR AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent IS NOT NULL)
SELECT *, (Cummulative_Vaccination/Population)*100 as Percent_Vaccination
FROM PopvsVac



--TEMP TABLE
DROP TABLE if exists #PopulationvsVaccination
CREATE TABLE #PopulationvsVaccination
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric, 
Cummulative_Vaccination numeric
)

Insert into #PopulationvsVaccination
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CONVERT(float,cv.new_vaccinations)) OVER(partition by cd.location ORDER BY cd.location, cd.date) Cummulative_Vaccination
FROM PortfolioProject..CovidDeath AS cd
JOIN
PortfolioProject..CovidVaccinationR AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent IS NOT NULL

SELECT *, (Cummulative_Vaccination/Population)*100 as Percent_Vaccination
FROM #PopulationvsVaccination


--CREATE VIEW
create view PopulationvsVaccination as
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CONVERT(float,cv.new_vaccinations)) OVER(partition by cd.location ORDER BY cd.location, cd.date) Cummulative_Vaccination
FROM PortfolioProject..CovidDeath AS cd
JOIN
PortfolioProject..CovidVaccinationR AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent IS NOT NULL


SELECT * FROM PortfolioProject..CovidDeath

