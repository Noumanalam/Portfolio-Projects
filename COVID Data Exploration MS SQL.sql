select * from CovidDeaths
order by 3,4 

select * from CovidVaccinations
order by 3,4

select Location,date,total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2

-- Looking at total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country

select Location,date,total_cases, total_deaths, (total_deaths/total_cases)* 100 as Deathpercentage
from CovidDeaths
where location like '%pakistan%'
and continentus is not null
order by 1,2

-- Looking at total cases vs population

-- Shows what percentage of population got Covid

select Location,date, population,total_cases, (total_cases/population)* 100 as Percentpopulationinfected
from CovidDeaths
where location like '%pakistan%'
order by 1,2

-- Looking at country's with hightest infection rate compared to population

select Location, population,max(total_cases) as Highestinfectioncount, max((total_cases/population))* 100 as 
Percentpopulationinfected
from CovidDeaths
--where location like '%pakistan%'
group by location, population
order by Percentpopulationinfected desc

-- showing the country with hightest death count per popuplation

select Location,max(cast(total_deaths as int)) as totaldeathcount
from CovidDeaths
--where location like '%pakistan%'
where continent is not null
group by location
order by totaldeathcount desc


--LET's break things down by continent


--  showing continents with highest death count per population

select continent,max(cast(total_deaths as int)) as totaldeathcount
from CovidDeaths
--where location like '%pakistan%'
where continent is not null
group by continent
order by totaldeathcount desc

-- Global numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)* 100 as Deathpercentage
from CovidDeaths
--where location like '%pakistan%'
where continent is not null
--group by date
order by 1,2

--Looking at total population vs Vaccination

select CovidDeaths.continent, CovidDeaths.location,CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations
, sum(cast(covidVaccinations.new_vaccinations as int)) over (partition by covidDeaths.location order by covidDeaths.Location,
CovidDeaths.date) as  Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
from CovidDeaths
join CovidVaccinations 
 on CovidDeaths.location= CovidVaccinations.location
 and CovidDeaths.date = CovidVaccinations.date
 where CovidDeaths.continent is not null
 order by 2,3

 -- USE CTE
 with popvsvac (continent, location, date, population,new_vaccinations, Rollingpeoplevaccinated)
 as
 (
 select CovidDeaths.continent, CovidDeaths.location,CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations
, sum(cast(covidVaccinations.new_vaccinations as int)) over (partition by covidDeaths.location order by covidDeaths.Location,
CovidDeaths.date) as  Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
from CovidDeaths
join CovidVaccinations 
 on CovidDeaths.location= CovidVaccinations.location
 and CovidDeaths.date = CovidVaccinations.date
 where CovidDeaths.continent is not null
 --order by 2,3
 )
 select *, (Rollingpeoplevaccinated/population)*100
 from popvsvac


 --Temptable 

 drop table if exists  #percentpopulationVaccinated
create table #percentpopulationVaccinated
(
continent nvarchar(255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccination numeric,
Rollingpeoplevaccinated numeric
)

 insert into #percentpopulationVaccinated
 select CovidDeaths.continent, CovidDeaths.location,CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations
, sum(cast(covidVaccinations.new_vaccinations as int)) over (partition by covidDeaths.location order by covidDeaths.Location,
CovidDeaths.date) as  Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
from CovidDeaths
join CovidVaccinations 
 on CovidDeaths.location= CovidVaccinations.location
 and CovidDeaths.date = CovidVaccinations.date
-- where CovidDeaths.continent is not null
 --order by 2,3

 select *, (Rollingpeoplevaccinated/population)*100
 from #percentpopulationVaccinated


 -- creating view to store data for later visualizaions
 Create view percentpopulationVaccinated
 as
  select CovidDeaths.continent, CovidDeaths.location,CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations
, sum(cast(covidVaccinations.new_vaccinations as int)) over (partition by covidDeaths.location order by covidDeaths.Location,
CovidDeaths.date) as  Rollingpeoplevaccinated
--, (Rollingpeoplevaccinated/population)*100
from CovidDeaths
join CovidVaccinations 
 on CovidDeaths.location= CovidVaccinations.location
 and CovidDeaths.date = CovidVaccinations.date
where CovidDeaths.continent is not null
 --order by 2,3

 select * from percentpopulationVaccinated