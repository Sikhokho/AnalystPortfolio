SELECT * 
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is null
ORDER BY 3, 4

SELECT * 
FROM PortfolioProject.dbo.CovidVaccinations
ORDER BY 3, 4

--SELECT Data to be used
SELECT location, date, total_cases, new_cases, total_cases, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--Looking at total cases vs total deaths
--Shows the likelihood of dying from contracting covid in SA
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths 
WHERE location = 'South Africa' AND total_cases <> '' AND total_deaths <> '' 
ORDER BY 1,2

--Looking at total cases vs population
--Shows the percentage of the population that has been infected
SELECT location, date, total_cases, population, (total_cases/population)*100 AS InfectionPercentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'South Africa' AND total_cases <> ''
ORDER BY 1,2

--Looking at countriess with the highest infection rate compared to population
SELECT location, MAX(total_cases) AS HighestInfectionCount, population, (MAX(total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY 4 DESC

--Looking at countries with the highest death count
SELECT location, MAX(total_deaths) AS HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY 2 DESC

--Looking at countries with the highest death count compared to population
SELECT location, MAX(total_deaths) AS HighestDeathCount, population, (MAX(total_deaths/population))*100 AS PercentPopulationDeceased
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY 4 DESC

--Looking at continents with the highest death count
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC




-- GLOBAL NUMBERS
SELECT date, SUM(new_cases)  AS TotalCases, SUM(CAST(new_deaths AS int)) AS TotalDeaths, (SUM(CAST(new_deaths AS int))/SUM(new_cases)*100) AS DeathPercentage
FROM PortfolioProject..CovidDeaths 
WHERE continent is not null AND total_cases is not null AND total_deaths is not null 
GROUP BY date
ORDER BY 1,2


SELECT SUM(new_cases)  AS TotalCases, SUM(CAST(new_deaths AS int)) AS TotalDeaths, (SUM(CAST(new_deaths AS int))/SUM(new_cases)*100) AS DeathPercentage
FROM PortfolioProject..CovidDeaths 
WHERE continent is not null AND total_cases is not null AND total_deaths is not null 
ORDER BY 1,2


--Looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
		SUM(vac.new_vaccinations) 
		OVER (PARTITION BY dea.location 
		ORDER BY dea.location, dea.date 
		ROWS UNBOUNDED PRECEDING) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON  dea.date = vac.date
	AND dea.location = vac.location
WHERE dea.continent is not null AND vac.new_vaccinations is not null
ORDER BY 2,3

--USE CTE
WITH PopVsVax (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS (SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
		SUM(vac.new_vaccinations) 
		OVER (PARTITION BY dea.location 
		ORDER BY dea.location, dea.date 
		ROWS UNBOUNDED PRECEDING) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON  dea.date = vac.date
	AND dea.location = vac.location
WHERE dea.continent is not null AND vac.new_vaccinations is not null)

SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopVsVax

-- OR USE TEMP TABLE
DROP TABLE IF EXISTS #PopulationPercentVaccinated
CREATE TABLE #PopulationPercentVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population float,
new_vaccinations float,
RollingPeopleVaccinated float
)
INSERT INTO #PopulationPercentVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
		SUM(vac.new_vaccinations) 
		OVER (PARTITION BY dea.location 
		ORDER BY dea.location, dea.date 
		ROWS UNBOUNDED PRECEDING) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON  dea.date = vac.date
	AND dea.location = vac.location
WHERE dea.continent is not null AND vac.new_vaccinations is not null

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PopulationPercentVaccinated




--CREATING VIEW FOR DATA VISUALIZATIONS IN FUTURE
CREATE VIEW [PopulationPercentVaccinated] AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
		SUM(vac.new_vaccinations) 
		OVER (PARTITION BY dea.location 
		ORDER BY dea.location, dea.date 
		ROWS UNBOUNDED PRECEDING) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON  dea.date = vac.date
	AND dea.location = vac.location
WHERE dea.continent is not null AND vac.new_vaccinations is not null

SELECT * FROM [PopulationPercentVaccinated]
