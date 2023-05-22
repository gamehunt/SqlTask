-- 1. Сколько медалей выиграл Jesse Owens в 1936?
-- Ответ: 4 

select count(*) from medals where athlete = 'OWENS, Jesse' and edition = 1936

-- 2. Какая страна выйграла большинство золотых медалей мужчинами в бадминтоне?
-- Ответ: INA (Индонезия), 8 медалей

select noc, count(*) as gold_medals from medals 
where medal = 'Gold' and sport = 'Badminton' and gender = 'Men'
group by noc
order by gold_medals desc
limit 1

-- 3. Какие три страны выйграли большинство медалей в последние годы (с 1984 по 2008)
-- USA (США)      - 1837 медалей
-- AUS (АВСТРАЛИЯ)  - 762 медали
-- GER (ГЕРМАНИЯ) - 691 медаль

select noc, count(*) as medal_count from medals
where edition >= 1984 and edition <= 2008
group by noc
order by medal_count desc
limit 3

-- 4. Покажите мужчин золотых медалистов по 100m. Выведите результаты по убыванию года выйгрыша. Покажите город в котором проходила олимпиала, год, имя атлета и страну за которую он выступал.
-- См. 4.txt

select city, edition, athlete, noc from medals
where gender = 'Men' and medal = 'Gold' and event = '100m'
order by edition desc

-- 5. Как много медалей было выйграно мужчинами и женщинами в истории олимпиады. Как много золотых, серебрянных и бронзовых медалей было выйграно каждым полом?
-- Мужчины: 7365 золотых 7181 серебряных 7175 бронзовых ИТОГО 21721 медаль
-- Женщины: 2485 золотых 2496 серебряных 2514 бронзовых ИТОГО 7495 медалей 

select m.gender , 
count(*),
(
	select count(*) from medals where gender = m.gender and medal = 'Gold'
) as gold,
(
	select count(*) from medals where gender = m.gender and medal = 'Silver'
) as silver,
(
	select count(*) from medals where gender = m.gender and medal = 'Bronze'
) as bronze
from medals m
group by gender

-- 6. Выведите общее кол-во медалей для каждой олимпиады
-- См. 6.txt

select city, edition, count(*) as medal_count from medals 
group by city, edition
order by edition desc

-- 7. Создайте список показывающий число всех медалей выйгранных каждой страной в течение всей истории олимпийских игр. Для каждой страны, необходимо показать год первой и последней заработанной медали.
-- Cм. 7.txt

select noc, 
min(edition) as first_medal, 
max(edition) as last_medal, 
count(*) from medals 
group by noc
order by noc asc

-- 8. Атлеты выйгравшие медали в Beijing на дистанции 100m или 200m
-- BOLT, Usain
-- CAMPBELL-BROWN, Veronica
-- CRAWFORD, Shawn
-- DIX, Walter
-- FELIX, Allyson
-- FRASER, Shelly-ann
-- SIMPSON, Sherone
-- STEWART, Kerron
-- THOMPSON, Richard#

select distinct athlete from medals where 
city = 'Beijing' and (event = '100m' or event = '200m')
order by athlete

-- 9. Найдите кол-во золотых медалей выйгранных США мужчинами и женщинами в атлетике на каждой олимпиаде.
-- Cм. 9.txt

select city, edition, 
(select count(*) from medals where 
gender = 'Men' 
and edition = m.edition  
) as men_medals,
(select count(*) from medals where 
gender = 'Women' 
and edition = m.edition  
) as women_medals
from medals m
where noc = 'USA' and sport = 'Athletics'
group by city, edition
order by edition desc

-- 10. Найдите 5 атлетов которые выйграли большинство золотых медалей.
-- LATYNINA, Larisa	18
-- PHELPS, Michael	16
-- ANDRIANOV, Nikolay	15
-- MANGIAROTTI, Edoardo	13
-- SHAKHLIN, Boris	13

select athlete, count(*) as medal_count from medals
group by athlete 
order by medal_count desc
limit 5

-- 11. Покажите суммарное количество медалей выйгранных странами в последних олимпийских играх.
-- См. 11.txt
select noc, count(*) as medal_count from medals m
inner join(
	select max(edition) as last from medals
) a
on m.edition = a.last
group by noc, edition
order by noc, edition asc

-- 12. Постройте таблицу в которой по годам всех олимпиад покажите топовых атлетов США(1 атлет на год) по общему количеству медалей. Включите дисциплину атлета.
-- См. 12.txt

select distinct on(edition) 
edition, athlete, sport, count(*) as medal_count from medals
where noc = 'USA'
group by edition, athlete, sport
order by edition desc, medal_count desc
