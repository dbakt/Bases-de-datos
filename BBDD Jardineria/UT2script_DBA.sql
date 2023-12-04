/**@author Daniel Barbero Alarcón

Create a database that is a gardening replica named as "<Iniciales_alumno>jardineria," taking into account the following considerations:

    Define the primary keys that can be with the AUTO-INCREMENT option.(Always that is possible)
    To establish the behavior SGBD on the rows of the table affected by the disposal or update to those they refer to.
    Update every time you are update parent row, related ranks will be updated automatically.
    Deleted: when the Father row, related rows are updated to NULL (as long as it is possible)

    After having made a replica of the gardening database with name <Iniciales Nombre del Alumno>jardineria, requested make the following amendments on that database using the same script.*/


drop database if exists DBAjardineria;
create database DBAjardineria;
use DBAjardineria;

/*first we create the table oficinas as it does not depend on another*/
drop table if exists oficinas;
create table oficinas(
	codigoOficina varchar(10),
	ciudad varchar(30) not null,
	pais varchar(50) not null,
	region varchar(50),
	codigoPostal varchar(10) not null,
	telefono varchar(20)not null,
	lineaDireccion1 varchar(50) not null,
	lineaDireccion2 varchar(50),
	primary key (codigoOficina)
);

/*we create the table gamasproductos as it neither depends on another*/
drop table if exists gamasproductos;
create table gamasproductos(
	gama varchar(50) not null,
	descripcionTexto text,
	descripcionHTML text,
	imagen blob,
	primary key (gama)
);

/*we create the table productos*/
drop table if exists productos;
create table productos(
	codigoProducto varchar (15) not null,
	nombre varchar(70) not null,
	gama varchar(50) not null,
	dimensiones varchar(25),
	proovedor varchar(50),
	descripcion text,
	cantidadEnStock smallint not null,
	precioVenta decimal (15,2) not null,
	precioProovedor decimal (15,2),
	primary key (codigoProducto),
	foreign key (gama) references gamasproductos (gama) on update cascade
);

/*we create the table empleados*/
drop table if exists empleados;
create table empleados(
	codigoEmpleado int not null auto_increment,
	nombre varchar(50)not null,
	apellido1 varchar(50) not null,
	apellido2 varchar(50),
	extension varchar(10) not null,
	email varchar(100) not null,
	codigoOficina varchar(10) not null,
	codigoJefe int,
	puesto varchar(50),
	primary key (codigoEmpleado),
	foreign key(codigoOficina) references oficinas(codigoOficina) on update cascade,
	foreign key (codigoJefe) references empleados(codigoEmpleado) on update cascade on delete set null
	
);

/*we create the table clientes*/
drop table if exists clientes;
create table clientes(
	codigoCliente int not null auto_increment,
	nombreCliente varchar(50) not null,
	nombreContacto varchar(30),
	apellidoContacto varchar(30),
	telefono varchar (15) not null,
	fax varchar(15) not null,
	lineaDireccion1 varchar(50) not null,
	lineaDireccion2 varchar(50),
	ciudad varchar(50)not null,
	region varchar(50),
	pais varchar(50),
	codigoPostal varchar(50),
	codigoEmpleadoRepVentas int,
	limiteCredito decimal(15,2),
	primary key (codigoCliente),
	foreign key (codigoEmpleadoRepVentas) references empleados(codigoEmpleado) on update cascade on delete set null
);

/*we create the table pagos*/
drop table if exists pagos;
create table pagos(
	codigoCliente int not null,
	formaPago varchar(40) not null,
	IDTransaccion varchar (50) not null,
	fechaPago date not null,
	cantidad decimal(15,2) not null,
	primary key (IDTransaccion, codigoCliente),
	foreign key (codigoCliente) references clientes(codigoCliente) on update cascade
	
);  

/*we create the table pedidos*/
drop table if exists pedidos;
create table pedidos(
	codigoPedido int not null auto_increment,
	fechaPedido date not null,
	fechaEsperada date not null,
	fechaEntrega date,
	Estado varchar(15) not null,
	comentarios text,
	codigoCliente int not null,
	primary key (codigoPedido),
	foreign key (codigoCliente) references clientes (codigoCliente) on update cascade
);

/*we create the table detallepedidos*/
drop table if exists detallepedidos;
create table detallepedidos(
	codigoPedido int not null,
	codigoProducto varchar(15) not null,
	cantidad int not null,
	precioUnidad decimal(15,2) not null,
	numeroLinea smallint not null,
	primary key (codigoPedido, codigoProducto),
	foreign key (codigoPedido) references pedidos (codigoPedido) on update cascade,
	foreign key (codigoProducto) references productos (codigoProducto) on update cascade
);

/*
For  Clients:

Change the name of the "telefono" attribute to the name "TelefonoMovil".*/
alter table clientes  rename column telefono to telefonoMovil;

/*Add another attribute located behind the "TelefonoMovil" with the name "TelefonoFijo".*/
alter table clientes add telefonoFijo varchar(15) after telefonoMovil;

/*Change the name of the attribute "lineadireccion1" to "direccion1".*/
alter table clientes  rename column lineaDireccion1 to direccion1;

/*Change the name of the attribute "LineaDireccion2" by "Direccion2.*/
alter table clientes  rename column lineaDireccion2 to direccion2;

/*Control that the values allowed for the Pais attribute are USA, Spain, France, Australia and United Kingdom.*/
alter table clientes add constraint Const_pais check (pais in ('USA', 'Spain', 'France', 'Australia', 'United Kingdom'));

/*Assign default value from the country to "Spain."*/
alter table clientes alter pais set default 'Spain';

/*Create an index by telephoneMovil due to the number of queries do it on the client's mobile phone.*/
/*Dará error porque el indice no existe entonces sintácticamente no nos deja */
drop index if exists idx_telefonoMovil on clientes;
create index idx_telefonoMovil on clientes (telefonoMovil);

/*Create a view with the pais, nombreCliente, telefonoMovil, orderly ascending pais.*/
drop view if exists V_clientes;
create view V_clientes as select pais, nombreCliente, telefonoMovil from clientes order by pais asc;

/*For Employees:

Add the "Telephone" attribute prior to the employee's Extension*/
alter table empleados add telefono varchar(20) after apellido2;

/*Control the values permitted for employee posts are: Director General, Subdirector Marketing, Subdirector Sales, Secretaria, Representante Ventas, Director Oficina.*/
alter table empleados add constraint Const_puesto check (puesto in ('Director General', 'Subdirector Marketing', 'Subdirector Ventas', 'Secretaria', 'Representante Ventas', 'Director Oficina' ));

/*Create a view with the apellido1, apellido2, nombre, puesto Order by apellido1 upwards.*/
drop view if exists V_empleados;
create view V_empleados as select apellido1, apellido2, nombre, puesto from empleados order by apellido1 asc;

/*For Offices:

Change the name of the attribute of "LineaDireccion1" by "Direccion1"*/
alter table oficinas  rename column lineaDireccion1 to direccion1;

/*Change the name of the attribute of "LineDireccion2" by "Direccion2"*/
alter table oficinas  rename column lineaDireccion2 to direccion2;

/*Control countries where the offices are are España, EEUU, Inglaterra, Francia, Australia and Japón.*/
alter table oficinas modify pais varchar(50) not null check (pais in ('España', 'EEUU', 'Inglaterra', 'Francia', 'Australia', 'Japón'));

/* Create a view with the pais, telefono and direccion1 sorted by pais of form ascending.*/
drop view if exists V_oficinas;
create view V_oficinas as select pais, telefono, direccion1 from oficinas order by pais asc;

/*Rename the table gamasProducts by Gama*/
alter table gamasProductos  rename to gama;

/*CREATION OF USER

    Two users will be created:*/
	
/*One to manage this database with admin name<Initials Student Name> and password of your choice and password You will have all the permissions on that database*/
drop user if exists adminDBA;
create user adminDBA identified by 'adminDBA';
grant all on DBAjardineria.* to adminDBA;

/*Another one so that you can only consult the database, with username<Initials Student's Name> and pasword the one you decide.*/
drop user if exists usuarioDBA;
create user usuarioDBA identified by 'ususarioDBA';
grant select on DBAjardineria .* to usuarioDBA;

