SELECT
	*
FROM
	PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

SELECT
	*
FROM
	PortfolioProject..CovidVaccinations
ORDER BY 3,4

SELECT Location, date, total_Cases, new_Cases, population
FROM
	PortfolioProject..CovidDeaths
ORDER BY 1,2

-- TOTAL CASES VS TOTAL DEATHS IN THE UK for COVID

SELECT Location, date, total_Cases, total_Deaths, (total_deaths/total_Cases)*100 AS DeathPercentage
FROM
	PortfolioProject..CovidDeaths
WHERE location like '%Kingdom%'
ORDER BY 1,2

-- TOTAL CASES VS Population for COVID

SELECT Location, date, population, total_Cases, (total_cases/population)*100 AS PercentOfPopulationInfected
FROM
	PortfolioProject..CovidDeaths
WHERE location like '%Kingdom%'
ORDER BY 1,2

-- COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

SELECT Location, population, MAX(total_Cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentOfPopulationInfected
FROM
	PortfolioProject..CovidDeaths
--WHERE location like '%Kingdom%'
GROUP BY Location, Population
ORDER BY PercentOfPopulationInfected desc

-- COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

SELECT Location, MAX(cast(total_deaths as INT)) AS TotalDeathCount
FROM
	PortfolioProject..CovidDeaths
--WHERE location like '%Kingdom%'
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc

-- CONTINENTS WITH HIGHEST DEATH COUNT PER POPULATION

SELECT continent, MAX(cast(total_deaths as INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%Kingdom%'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

--GLOBAL NUMBERS

SELECT SUM(new_Cases) as TotalCases, SUM(cast(new_Deaths as INT)) as TotalDeaths,
	SUM(cast(new_deaths as INT))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%Kingdom%'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2

-- TOTAL POPULATION VS VACCINATION

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location, dea. date)
	as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
	JOIN PortfolioProject..CovidVaccinations vac 
		ON dea.location = vac.location 
		and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

-- USE CTEs

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location, dea. date)
	as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
	JOIN PortfolioProject..CovidVaccinations vac 
		ON dea.location = vac.location 
		and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

--TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location, dea. date)
	as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
	JOIN PortfolioProject..CovidVaccinations vac 
		ON dea.location = vac.location 
		and dea.date = vac.date
WHERE dea.continent is not null

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

-- CREATE VIEW TO STORE DATA FOR FUTURE VISUALISATION

DROP View if exists PercentPopulationVaccinated

CREATE view PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,	SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.location, dea. date)
	as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
	JOIN PortfolioProject..CovidVaccinations vac 
		ON dea.location = vac.location 
		and dea.date = vac.date
WHERE dea.continent is not null

SELECT * 
FROM PercentPopulationVaccinated