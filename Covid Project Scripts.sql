--Select  Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage  
--From CovidDeaths
--where location ="Romania"
--order by 1, 2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid

--Select Location, date, total_cases, Population, (total_cases/population)*100 as InfectedPercentagePopulation
--From CovidDeaths
--Where location ="Romania"
--order by 1, 2

--Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectedPercentagePopulation
--From CovidDeaths
--Where location ="Romania"
--Group by Location, Population
--order by InfectedPercentagePopulation desc





--Showing countries with highest death count per population
--Select Location,  MAX(cast (total_deaths as int)) as TotalDeathCount
--From CovidDeaths
--Where continent is not ""
--Group by location 
--order by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT
--Showing continents with highest death count per population
Select location, MAX(cast (total_deaths as int)) as TotalDeathCount 
From CovidDeaths
Where continent is ""
Group by location
order by TotalDeathCount desc


--GLOBAL NUMBERS

Select  date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM (cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage  --, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
where continent is not ""
--Group by date
order by 1, 2



-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, cast(vac.new_vaccinations as int), SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccines vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not ""
order by  2, 3


-- USE CTE
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated) as(

Select dea.continent, dea.location, dea.date, dea.population, cast(vac.new_vaccinations as int), SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccines vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not ""
--order by  2, 3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Creating View to store data for later visualisations
DROP View if exists PercentPopulationVaccinated
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, cast(vac.new_vaccinations as int), SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccines vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not ""
--order by  2, 3


Select *
From PercentPopulationVaccinated


