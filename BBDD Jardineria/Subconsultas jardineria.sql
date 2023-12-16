/*Get the name of the most expensive product. Perform the exercise as a subquery and then as a simple query to make said query more efficient.*/
select nombre as productoMasCaro from productos
where precioVenta = (select max(precioVenta) from productos);

select nombre as productoMasCaro from productos
order by precioVenta desc
limit 1;


/*Obtain the name of the product that has sold the most units in the same order.*/
select p.nombre 
from productos p
join (select codigoPedido, codigoProducto as mas_vendido, max(cantidad) as unidades 
from detallepedidos
group by 1) as t
on p.codigoProducto = t.mas_vendido;

/*Obtain the name of customers who placed orders in 2008.*/
select c.nombreCliente, p.fechaPedido
from clientes c 
join pedidos p
using (codigoCliente)
where fechaPedido in (select fechaPedido from pedidos where year(fechaPedido) = '2008');

/*de otra manera sin subconsulta*/
select c.nombreCliente, p.fechaPedido
from clientes c 
join pedidos p
using (codigoCliente)
where year(fechaPedido) = '2008';


/*Get customers who have ordered more than 200 units of any product.*/
select *
from clientes
join pedidos p
using (codigoCliente)
join detallepedidos dp 
using (codigoPedido)
where dp.cantidad in (select cantidad from detallepedidos where cantidad > 200);

/*otra forma sin subconsulta*/
select *
from clientes
join pedidos p
using (codigoCliente)
join detallepedidos dp 
using (codigoPedido)
where dp.cantidad > 200;


/*Get clients who reside in cities where there are no offices.*/
select *
from clientes c
join empleados e
on c.codigoEmpleadoRepVentas = e.codigoEmpleado
join oficinas o 
using (codigoOficina)
where c.ciudad not in (select ciudad from oficinas);

/*Obtain the name, surname and email of the employees under Alberto Soria.*/
select concat_ws(' ', e.nombre, e.apellido1, e.apellido2) as nombre_completo
from empleados e
where (codigoJefe) = (select codigoJefe
from empleados
where nombre = 'Alberto' and apellido1 = 'Soria');

/*Obtain the name of the customers to whom an order has not been delivered on time.*/
select c.nombreCliente
from clientes c
left join (select codigoCliente, fechaEsperada, fechaEntrega from pedidos) as p
using (codigoCliente)
where p.fechaEntrega > p.fechaEsperada;

/*esta mucho mejor que la anterior, aunque sin subconsulta*/
select c.nombreCliente, p.fechaEsperada, p.fechaEntrega
from clientes c
join pedidos p
using (codigoCliente)
where fechaEntrega > fechaEsperada;

/*Obtain the name and telephone number of clients who made a payment in 2007, ordered alphabetically by name.*/
select c.nombreCliente, c.telefono
from clientes c
join pagos p
using (codigoCliente)
where codigoCliente in (select codigoCliente from pagos where year (fechaPago) = '2007');

/*sin subconsulta*/
select c.nombreCliente, c.telefono, p.idtransaccion
from clientes c
join pagos p
using (codigoCliente)
where year (p.fechaPago) = '2007'
order by 1;

/*Obtain the range, supplier and quantity of those products whose status is pending.*/
select p.gama, p.proveedor, dp.cantidad
from productos p 
join detallepedidos dp
using (codigoProducto)
join pedidos ped
using (codigoPedido)
where ped.codigoPedido in (select codigoPedido from pedidos where estado = 'pendiente');


/*otra manera sin subconsulta*/
select p.gama, p.proveedor, dp.cantidad
from productos p
join detallepedidos dp
using (codigoProducto)
join pedidos ped
using (codigoPedido)
where ped.estado = 'pendiente';