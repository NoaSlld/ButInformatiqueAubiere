# psql -h londres -d dbnosillard -U nosillard -W
# \i fichier.sql

#2-----------------------------------------
select city
from team where
nickname = 'Grizzlies';

#3-----------------------------------------
select max(ptsHome) 
from game;

#4-----------------------------------------
select max(ptsAway) 
from game;

#5-----------------------------------------

#6-----------------------------------------
select t.nickname, t.abbreviation, t.city, g.ptsHome, g.dateGame
from team t, game g
where t.id = g.idHomeTeam and g.ptsHome = (select max(ptsHome) from game);

#7-----------------------------------------
select t.nickname, t.abbreviation, t.city, g.ptsHome, g.dateGame
from team t, game g
where t.id = g.idVisitorTeam and g.ptsHome = (select max(ptsHome) from game);

#8-----------------------------------------
#un peu plus que demandé
select count(p.name), g.threePointsPrctage, g.threePointsMade
from player p, gamedetail g
where p.id = g.idPlayer and threePointsPrctage = (select max(threePointsPrctage) from gamedetail)
order by g.threePointsMade desc;

#9-----------------------------------------
/*
select p.name, avg(g.threePointsPrctage)
from player p, gamedetail g
where p.id = g.idPlayer and (select avg(threePointsPrctage) from gamedetail);select p.name, avg(g.threePointsPrctage)

select p.name, max(g.threePointsPrctage)
from (select avg(g.threePointsPrctage), p.id as avg_tpp 
			from gamedetail g, player p 
			where p.id = g.idPlayer 
			group by p.id) as max_tpp;

select p.name, avg(g.threePointsPrctage)
from player p, gamedetail g
group by p.id
having avg(g.threePointsPrctage) = (select(max(avg(g.threePointsPrctage) 
									from gamedetail g, player p 
									group by p.id)));

select p.name, avg() as avg_tpp
from player p, gamedetail g
where g.idPlayer = p.id and avg_tpp >= ALL
group by p.id;

select p.name, max(avg_tpp)
from player p,(select p.id, avg(g.threePointsPrctage) AS avg_tpp
      from player p, gamedetail g
      where p.id = g.idPlayer
      group by p.id) As max_tpp
group by p.id;
*/

select gd.idPlayer, p.name, AVG(gd.threePointsPrctage) as avgThreePointsPercentage
from gamedetail gd, player p
where gd.idPlayer = p.id
group by gd.idPlayer, p.name
order by avgThreePointsPercentage desc
limit 1;

#10----------------------------------------
select max(gd.threePointsMade)
from gamedetail gd, game g
where gd.idGame = g.id and g.season = 2012;

#11----------------------------------------
select t.conference, t.nickname as teamName, t.city, t.yearFounded as yearJoinedNBA
from team t
where (t.conference, t.yearFounded) in (
        select conference, MAX(yearFounded) as maxYear
        from Team
        group by conference);

#12----------------------------------------
select gd.idPlayer, p.name, gd.assists, g.dateGame
from gameDetail gd, player p, game g
where gd.idPlayer = p.id and gd.idGame = g.id and gd.assists = (
        select MAX(assists)
        from GameDetail)
        limit 1;

#13 ----------------------------------------
select gd.idGame, gd.idPlayer, p.name, g.dateGame, gd.personnalFoul
from GameDetail gd, Player p, Game g
where gd.idPlayer = p.id and gd.idGame = g.id and gd.personnalFoul >= 6
order by g.dateGame asc
limit 1;exit





