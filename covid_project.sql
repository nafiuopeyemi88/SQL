/* covid vaccinations and deaths data exploration procedures */

 Use covid_portfolio
Select*
from coviddeaths
where continent is not null
order by location, date

select Location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
where continent is not null
order by 1,2

/* explore case per death in a country*/
select Location, date, total_deaths, total_cases, total_deaths, (total_deaths/total_cases)* 100 as case_per_death
from coviddeaths
where location like '%NIGERIA%'
and total_deaths >0
order by 1,2 DESC

/* display percentage of population in selected countries affected by covid*/
select Location, total_cases, population, (total_cases/population)*100 as percent_infected
from coviddeaths
order by percent_infected DESC

-- cases per population
Select location, Population, MAX(total_cases) as HighestInfected, MAX((total_cases/population))*100 as percentage
from coviddeaths
group by location, population
order by 1,2 DESC

/* countries with highest death count per population */
Select Location, max(total_deaths), population, max((total_deaths/population))*100 as deaths_per_population
From CovidDeaths
group by location, population
order by deaths_per_population desc


/* continent with the highest deaths */
Select continent, total_deaths, max(total_deaths)
From CovidDeaths
Where continent is not null 
group by continent
order by total_deaths desc


/*countries with the highest recorded death */
Select location, max(total_deaths) as maximum_deaths
From CovidDeaths
group by location
order by maximum_deaths desc


/*continents with the highest death count */
select continent, MAX(total_deaths) as TotalDeathCount
From coviddeaths
where continent is not null
group by continent
order by TotalDeathCount





Select continent, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null 
group by continent
order by 1,2


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from CovidDeaths dea
Join CovidVaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date



Select dea.continent, 
		dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations, 
        SUM(vac.new_vaccinations) OVER (Partition by dea.Location order by dea.location, dea.date) as rollingpeople_vacc
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


/* Using CTE to perform Calculation on Partition By in previous query*/

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, 
		dea.location, dea.date, dea.population, 
		vac.new_vaccinations, SUM(vac.new_vaccinations) 
		OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)

Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

/*case per hospital bed */
select*
from covidvaccinations

select*
from coviddeaths
order by date desc

/* explore percentage of the country that has been vaccinated */
/* need t0 join the tables */

select dea.location, dea.continent, dea.total_deaths, dea.population, new_vaccinations, (new_vaccinations/population)*100 as percent_vaccinated
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
order by percent_vaccinated desc


Select dea.location, dea.continent, dea.population, median_age
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
group by location
order by location desc





