/*Obtener el número total de jugadores de cada división.*/
select e.division, count(j.codigo) as numero_de_jugadores from equipos e
left join jugadores j on e.nombre = j.nombre_equipo
group by 1;

/*Obtener el nombre, equipo y la media de puntos de todas las temporadas de los jugadores españoles de la NBA.*/
select j.nombre as jugadores_españoles, e.nombre, avg(ed.puntos_por_partido) from jugadores j
left join equipos e on j.nombre_equipo = e.nombre
left join estadisticas ed on j.codigo = ed.jugador
where j.procedencia = 'Spain'
group by 1,2;

/*Obtener el nombre, nombre de equipo y división de los jugadores de nacionalidad brasileña. Utiliza WHERE en lugar de JOIN para la unión de tablas.*/
select j.nombre as jugadores_brasileños, e.nombre, e.division
from jugadores j, equipos e
where j.nombre_equipo = e.nombre and j.procedencia = 'Brazil';
 

/*Obtener el nombre de los jugadores, el nombre del equipo al que pertenecen y la ciudad de aquellos que han realizado algún tapón en la temporada 2003/2004.*/
select j.nombre, e.nombre, e.ciudad
from jugadores j
left join equipos e on j.nombre_equipo = e.nombre
left join partidos p on e.nombre = p.equipo_local
left join estadisticas ed on j.codigo = ed.jugador
where p.temporada = '03/04' and ed.tapones_por_partido > 0
group by 1, 2, 3;