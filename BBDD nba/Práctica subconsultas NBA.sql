/*1. Obtener los jugadores que pesan más que la media de peso de todos los jugadores españoles.*/
select codigo, nombre, peso
from jugadores
where peso > (select avg(peso)
from jugadores
where procedencia = 'Spain');

/*2. Obtener los puntos por partido de Pau Gasol en toda su carrera.*/
select sum(puntos_por_partido) as puntos_de_Pau
from estadisticas
where jugador = (select codigo from jugadores where nombre = 'Pau Gasol');

/*3. Obtener los puntos por partido de los jugadores de los Cavaliers en la temporada 2007/2008.*/
select jugador, puntos_por_partido
from estadisticas
where temporada = '07/08' and jugador in (select codigo from jugadores where nombre_equipo = 'Cavaliers');

/*si quisiera el nombre de los jugadores*/
select j.nombre, e.puntos_por_partido
from jugadores j
left join estadisticas e
on j.codigo = e.jugador
where e.temporada = '07/08' and j.nombre_equipo = 'Cavaliers';

/*4. Obtener el número de jugadores que tiene cada equipo de la Conferencia Oeste.*/
select nombre_equipo, count(codigo)
from jugadores
where nombre_equipo in (select nombre from equipos where conferencia = 'West')
group by nombre_equipo;

/*5. Obtener la máxima media de puntos de Lebron James en su carrera.*/
select avg(puntos_por_partido) as media_Lebron
from estadisticas
where jugador = (select codigo from jugadores where nombre = 'Lebron James');

/*Si se refiere a la maxima media de puntos por partido*/
select avg(puntos_por_partido) as media_Lebron
from estadisticas
where jugador = (select codigo from jugadores where nombre = 'Lebron James')
group by puntos_por_partido
order by 1 desc
limit 1;

/*6. Obtener la media de asistencias por partido de José Calderón en la temporada 2007/2008.*/
select avg(asistencias_por_partido)
from estadisticas
where temporada = '07/08' and jugador = (select codigo from jugadores where nombre = 'José Calderón');

/*7. Obtener la media de puntos por partido de Lebron James en las temporadas del 2003/2004 al 2005/2006.*/
select temporada, avg(puntos_por_partido)
from estadisticas
where temporada in ('03/04', '04/05', '05/06') and jugador = (select codigo from jugadores where nombre = 'Lebron James')
group by temporada;

/*8. Obtener la media de rebotes de los jugadores de la Conferencia Este.*/
select avg(rebotes_por_partido)
from estadisticas
where jugador in (select codigo from jugadores where nombre_equipo in (select nombre from equipos where conferencia = 'East'));

/*si lo quieres saber de cada jugador*/
select jugador, avg(rebotes_por_partido)
from estadisticas
where jugador in (select codigo from jugadores where nombre_equipo in (select nombre from equipos where conferencia = 'East'))
group by 1;

/*9. Obtener los rebotes por partido de los jugadores de los equipos de la ciudad de Los Ángeles en la temporada 2007/2008.*/
select jugador, rebotes_por_partido
from estadisticas
where temporada = '07/08' and jugador in (select codigo from jugadores where nombre_equipo in (select nombre from equipos where ciudad = 'Los Angeles'));

/*10. Obtener el máximo reboteador de los Suns en la temporada 2007/2008.*/
select jugador
from estadisticas 
where rebotes_por_partido = (select max(rebotes_por_partido) from estadisticas
where temporada = '07/08');

/*sin subconsulta*/
select jugador
from estadisticas 
where temporada = '07/08'
order by rebotes_por_partido desc
limit 1;
 

/*11. Obtener el número de jugadores que tiene cada equipo de la división NorthWest.*/
select nombre_equipo, count(codigo) as numero_jugadores
from jugadores
where nombre_equipo in (select nombre from equipos where division = 'NorthWest')
group by nombre_equipo;

/*12. Obtener la temporada con más puntos por partido de Kobe Bryant.*/
select temporada
from estadisticas
where puntos_por_partido = (select max(puntos_por_partido) from estadisticas where jugador = (select codigo from jugadores where nombre = 'Kobe Bryant'));

/*13. Obtener el número de bases que tiene cada equipo de la Conferencia Este. (Los bases vienen representados por la letra ‘G’ en la BBDD).*/
select nombre_equipo, count(posicion) as bases
from jugadores
where posicion = 'G' and nombre_equipo in (select nombre from equipos where conferencia = 'East')
group by nombre_equipo;

/*14. ¿Cuántas letras tiene el equipo con el nombre más largo de la NBA?. Obtener también el nombre del equipo y la ciudad de donde procede. (Usar la función LENGTH, aunque en realidad esta función lo que nos dice es el nº de caracteres que ocupa el nombre del equipo en la BBDD incluido los espacios en blanco, no su número de letras, pero haremos una excepción).*/
/*SALE EL MISMO NUMERO USANDO UNA O LA OTRA*/
select nombre, ciudad, char_length(nombre) as letras
from equipos
order by char_length(nombre) desc
limit 1;

select nombre, ciudad, length(nombre) as letras
from equipos
order by length(nombre) desc
limit 1;

/*15. Obtener la ciudad con el equipo cuya media de altura de los jugadores sea la más baja.*/
select ciudad
from equipos
where nombre = (select nombre_equipo from(select nombre_equipo, avg(altura) from jugadores group by nombre_equipo order by avg(altura) limit 1) as subconsulta);


/*Obtener los jugadores y los puntos por partido de los Timberwolves en la temporada 2003/2004.*/
select jugador, puntos_por_partido
from estadisticas
where temporada = '03/04' and jugador in (select codigo from jugadores where nombre_equipo = 'Timberwolves');

/*seria mejor con multitabla*/
select j.nombre, e.puntos_por_partido
from jugadores j 
left join estadisticas e
on j.codigo = e.jugador
where j.nombre_equipo = 'Timberwolves' and e.temporada = '03/04';


/*17. Obtener el nombre y peso de los jugadores de la NBA que hayan hecho una media de más de 25 puntos por partido en alguna temporada.*/
select nombre, peso
from jugadores
where codigo in (select jugador from (select jugador, temporada, avg(puntos_por_partido) from estadisticas group by jugador, temporada having avg(puntos_por_partido) > 25) as subconsulta);


/*18. Obtener las asistencias por partido y los tapones por partido de los jugadores de los Miami Heat en la temporada 2005/2006.*/
select jugador as jugadores_Miami_Heat, asistencias_por_partido, tapones_por_partido
from estadisticas
where temporada = '05/06' and jugador in (select codigo from jugadores where nombre_equipo = 'Heat');

 

/*19. Obtener la media de puntos por partido y la media de asistencias por partido de los Timberwolves en todas las temporadas.*/
select temporada, avg(puntos_por_partido), avg(asistencias_por_partido)
from estadisticas
where jugador in (select codigo from jugadores where nombre_equipo = 'Timberwolves')
group by temporada;

/*si es en total*/
select avg(puntos_por_partido), avg(asistencias_por_partido)
from estadisticas
where jugador in (select codigo from jugadores where nombre_equipo = 'Timberwolves');

/*20. Obtener la media de puntos por temporada de los jugadores que se llamen Steve y pesen más de 200 libras.*/
select temporada, avg(puntos_por_partido)
from estadisticas
where jugador in (select codigo from jugadores where nombre like 'Steve%' and peso > 200)
group by temporada;

/*si quiere la media de cada jugador que se llame Steve*/
select temporada, jugador, avg(puntos_por_partido)
from estadisticas
where jugador in (select codigo from jugadores where nombre like 'Steve%' and peso > 200)
group by temporada, jugador;


/*21. Obtener el nombre, la altura y el peso de los jugadores que juegan en la ciudad de Los Ángeles y que sean españoles.*/
select nombre, altura, peso
from jugadores
where procedencia = 'Spain' and nombre_equipo in (select nombre from equipos where ciudad = 'Los Angeles');

/*22. Obtener los puntos por partido de los jugadores de los Lakers en la temporada 2007/2008.*/
select jugador as jugadores_Lakers, puntos_por_partido
from estadisticas
where temporada = '07/08' and jugador in (select codigo from jugadores where nombre_equipo = 'Lakers');