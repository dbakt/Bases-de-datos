/*usaré left join donde no especifique nada para mostrar todos los datos posibles*/

/*1. Get customers whose line of credit is greater than the payments you have made. Use WHERE en JOIN place for joining tables.*/
select c.codigoCliente, c.nombreCliente, c.limiteCredito, sum(p.cantidad) as pagos_realizados from clientes c, pagos p
where c.codigoCliente = p.codigoCliente
group by 1, 2, 3 
having sum(p.cantidad) < limiteCredito;

/*2. Get the name of the clients and the name of their representatives along with the city of the office to the one that belongs to the representative. Use WHERE instead of JOIN for the Joining Tables*/
select c.nombreCliente, e.nombre, o.ciudad from clientes c, empleados e, oficinas o
where c.codigoEmpleadoRepVentas = e.codigoEmpleado and e.codigoOficina = o.codigoOficina;

/*3. Get the name of the clients and the name of their representatives along with the city of the office to the one that belongs to the representative. Use JOIN instead of WHERE for joining tables.*/
select c.nombreCliente, e.nombre, o.ciudad from clientes c
join empleados e on c.codigoEmpleadoRepVentas = e.codigoEmpleado
join oficinas o using (codigoOficina);


/*4. Get a list of customers by indicating the customer's name and how many orders they have placed.*/
select c.nombreCliente, count(p.codigoPedido) as pedidos_realizados from clientes c
left join pedidos p using (codigoCliente)
group by 1;

/*5. Get a list of the Names of the customers and the total paid for each of them.*/
select c.nombreCliente, sum(p.cantidad) as total_pagado from clientes c 
left join pagos p using (codigoCliente)
group by 1;

/*6. Get the name and last names of employees as well as the customer name of those employees that represent customers who have made a payment through PayPal.*/
select concat_ws(' ', e.nombre, e.apellido1, e.apellido2) as nombre_empleado, c.nombreCliente, p.formaPago from empleados e
left join clientes c on e.codigoEmpleado = c.codigoEmpleadoRepVentas
left join pagos p using (codigoCliente)
where formaPago = 'PayPal';

/*7. Get How Many Employees It has each office, showing the name of the city where the office is located.*/
select o.ciudad as ciudad_oficina, count(e.codigoEmpleado) as numero_de_empleados from oficinas o
left join empleados e using  (codigoOficina)
group by 1;

/*Get the name, last name, office (city), and job title of the employee who does not represent any employee customer.*/
select concat_ws(' ', e.nombre, e.apellido1, e.apellido2) as nombre_empleado, o.ciudad as ciudad_oficina, e.puesto from empleados e
left join oficinas o using (codigoOficina)
left join clientes c on e.codigoEmpleado = c.codigoEmpleadoRepVentas
where c.codigoEmpleadoRepVentas is null;

/*9. Get a list of the customers and the transaction ID of those customers who made some payment in 2007.*/
select c.codigoCliente, c.nombreCliente, p.idTransaccion from clientes c 
left join pagos p using (codigoCliente)
where year (p.fechaPago) = '2007';

/*10. Get the names of the as well as the names and surnames of their representatives customers who haven't made payments.*/
select c.nombreCliente, concat_ws(' ', e.nombre, e.apellido1, e.apellido2) as nombre_empleado from clientes c
left join empleados e on c.codigoEmpleadoRepVentas = e.codigoEmpleado
left join pagos p using (codigoCliente)
where p.codigoCliente is null;

/*usando una subconsulta*/
select c.nombreCliente, concat_ws(' ', e.nombre, e.apellido1, e.apellido2) as nombre_empleado from clientes c
left join empleados e on c.codigoEmpleadoRepVentas = e.codigoEmpleado
left join pagos p using (codigoCliente)
where c.codigoCliente not in (select codigoCliente from pagos);


/*11. Get the Name, range, and text description of products that have never been ordered.*/
select p.nombre, p.gama, substr(p.descripcion, 1, 20) from productos p
left join detallepedidos dp using (codigoProducto)
where dp.codigoProducto is null;

/*con subconsulta*/
select p.nombre, p.gama, substr(p.descripcion, 1, 20) from productos p
left join detallepedidos dp using (codigoProducto)
where p.codigoProducto not in (select codigoProducto from detallepedidos);

/*Get the First name, last name, and zip code of all employees who work at Barcelona.*/
select concat_ws(' ', e.nombre, e.apellido1, e.apellido2) as nombre_empleado, o.codigoPostal from empleados e
left join oficinas o using (codigoOficina)
where o.ciudad = 'Barcelona';

/*Get the product code, text description, and the number of times it has been ordered such a product.*/
select p.codigoProducto, substr(p.descripcion, 1, 20), sum(dp.cantidad) as veces_pedido from productos p
left join detallepedidos dp using (codigoProducto)
group by 1;

/*Get the name of customers in the city of Madrid who have placed an order, and the status of the order.*/
select c.nombreCliente as clientes_de_Madrid, p.estado, count(p.estado) as numero_de_pedidos from clientes c 
join pedidos p using (codigoCliente)
group by 1,2;
