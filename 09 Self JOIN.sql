-- 09 Self JOIN

/*
1.
How many stops are in the database. 
*/
SELECT COUNT(*) AS Num 
FROM stops

/*
2.
Find the id value for the stop 'Craiglockhart' 
*/
SELECT id 
FROM stops
WHERE name='Craiglockhart' 

/*
3.
Give the id and the name for the stops on the '4' 'LRT' service. 
*/
SELECT id, name 
FROM stops
JOIN route ON stops.id=route.stop
WHERE num=4
AND company='LRT'

/*
4.
The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes. 
*/
SELECT company, num, COUNT(*)
FROM route 
WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*)=2

/*
5.
Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road. 
*/
SELECT r1.company, r1.num, r1.stop, r2.stop
FROM route AS r1
JOIN route AS r2
ON (r1.company = r2.company)
AND (r1.num = r2.num)
WHERE r1.stop = 53
AND r2.stop = 149;

/*
6.
The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown
*/
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'
AND stopb.name='London Road'

/*
7.
Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith') 
*/
SELECT DISTINCT a.company, a.num
FROM route a 
JOIN route b
ON (a.company=b.company AND a.num=b.num)
WHERE a.stop=115
AND b.stop=137

/*
8.
Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross' 
*/
SELECT DISTINCT a.company, a.num
FROM route a 
JOIN route b
ON (a.company=b.company AND a.num=b.num)
WHERE a.stop=(SELECT id FROM stops WHERE name='Craiglockhart')
AND b.stop=(SELECT id FROM stops WHERE name='Tollcross' )

/*
9.
Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services. 
*/
SELECT DISTINCT bstop.name, a.company, a.num 
FROM route AS a JOIN route AS b ON (a.company = b.company AND a.num = b.num)
			   JOIN stops AS astop ON (a.stop = astop.id)
			   JOIN stops AS bstop ON (b.stop = bstop.id)
WHERE astop.name = 'Craiglockhart'

/*
10.
Find the routes involving two buses that can go from Craiglockhart to Sighthill.
Show the bus no. and company for the first bus, the name of the stop for the transfer,
and the bus no. and company for the second bus. 
*/
SELECT DISTINCT craig.num,craig.company,name,sight.num,sight.company 
FROM
(
SELECT * FROM route a WHERE a.num IN(SELECT num FROM route WHERE route.stop=(SELECT id FROM stops WHERE name='Craiglockhart'))
AND a.company IN (SELECT company FROM route WHERE route.stop=(SELECT id FROM stops WHERE name='Craiglockhart'))
) craig
JOIN
(
SELECT * FROM route a WHERE a.num IN(SELECT num FROM route WHERE route.stop=(SELECT id FROM stops WHERE name='Sighthill'))
AND a.company IN (SELECT company FROM route WHERE route.stop=(SELECT id FROM stops WHERE name='Sighthill'))
) sight
ON (craig.stop=sight.stop)
JOIN stops ON (stops.id=sight.stop)
ORDER BY Length(craig.num) ,craig.company, Length(name)
