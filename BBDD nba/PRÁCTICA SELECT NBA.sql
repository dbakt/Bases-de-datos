/*1. Jugadores cuya tercera letra de su nombre sea la “v”.*/
select * from jugadores where nombre like '__v%';

/*2. Mostrar un listado de jugadores con el formato nombre(equipo) en una sola columna.*//*hay que concatenar atributos*/
select concat(nombre, ' ', '(', nombre_equipo, ')') from jugadores;

/*3. Primeros 10 jugadores por orden alfabético.*/
select * from jugadores
order by nombre asc 
limit 10;

/*4. Nombre de las divisiones de la conferencia East.*/
select division as divisiones_del_este from equipos
where conferencia = 'East';

/*5. Sacar cuántas letras tiene el nombre de cada jugador de los ‘grizzlies’. (Usar la función LENGTH).*/
select nombre, LENGTH(nombre) as numero_letras_1espacio from jugadores
where nombre_equipo = "grizzlies";

/*6. Número de jugadores argentinos en la NBA.*/
select count(codigo) as jugadores_argentinos from jugadores
where procedencia = 'Argentina';

/*7. Número de jugadores italianos y franceses en la NBA.*/
select count(codigo) as jugadores_argentinos_y_franceses from jugadores
where procedencia in ('Argentina', 'France');

/*8. Número de pivots (los pivots son representados en la BBDD con la letra C) que tiene cada equipo.*/
select count(codigo) as numero_de_pivots from jugadores 
where posicion = 'C';

/*9. ¿Cuánto mide el pívot (los pivots son representados en la BBDD con la letra C) más alto (la altura en la BBDD viene representada en pies) de la NBA?*/
select nombre as pivots, altura as altura_en_pies from jugadores
where posicion = 'C';

/*10. Número de jugadores cuyo nombre empieza por “r”.*/
select count(codigo) as jugadores_que_empiezan_por_R from jugadores
where nombre like 'r%';

/*11. Peso medio (el peso de los jugadores viene especificado en libras en la BBDD) de los jugadores de los Raptors.*/
select avg(peso) as peso_medio_en_lbs from jugadores
where nombre_equipo = 'Raptors';

/*12. Número de equipos que tiene cada conferencia.*/
select conferencia, count(nombre) as numero_de_equipos from equipos
group by 1; 

/*13. Nombre de las divisiones de la conferencia Este.*/
select nombre as divisiones_East from equipos
where conferencia = 'East';

/*14. Obtener cuántos caracteres ocupa el nombre de cada jugador de los Bulls. Usar la función LENGTH.*/
select nombre as nombre_jug_Bulls, LENGTH(nombre) as num_caracteres_yEspacio from jugadores
where nombre_equipo = 'Bulls';

/*15. Obtener la media de peso (el peso de los jugadores viene especificado en libras en la BBDD) de los jugadores de cada equipo.*/
select nombre_equipo, avg(peso) as peso_medio_por_equipo from jugadores
group by nombre_equipo; 

/*16. Obtener los equipos cuya media de peso de sus jugadores sea superior a 228 libras.*/
select nombre_equipo, avg(peso) as peso_medio from jugadores
group by 1
having avg(peso) > 228;

/*17. Obtener el número de jugadores españoles de cada equipo.*/
select count(codigo) as jugadores_españoles from jugadores
where procedencia = 'Spain';

/*18. Obtener el nombre de los equipos con más de un jugador español.*/
select nombre_equipo, count(codigo) as jugadores_españoles from jugadores
where procedencia = 'Spain'
group by 1
having count(codigo) > 1; /*cuidado con poner 2 > 1 poque siempre tomará esa condición como true y no nos mostrará lo deseado*/

/*19. Obtener la media de peso de aquellos jugadores (el peso de los jugadores viene especificado en libras en la BBDD) cuya procedencia sea de España, Francia e Italia. Muestra el resultado agrupado por país.*/
select procedencia, avg(peso) as peso_medio from jugadores
where procedencia in ('Spain', 'France', 'Italy')
group by procedencia;



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