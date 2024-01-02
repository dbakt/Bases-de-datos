use jardineria;
/* 1. Obtain the city and telephone number of the EEUU offices.*/
select ciudad, telefono from oficinas where pais = 'EEUU';

/*2. Obtain the position, name, surname and email of the head of the company.*/
select puesto, nombre, apellido1, apellido2, email from empleados where codigojefe is null;


/*3. Obtain the first and last name and position of those who are not sales representatives.*/
select nombre, apellido1, apellido2, puesto from empleados where puesto != 'Representante Ventas';


/*4. Obtain the number of clients the company has.*/
select count(*) as total_clientes from clientes; 


/*5. Obtain the name of Spanish clients.*/
select nombrecliente as clientes_españoles from clientes where pais = 'Spain';


/*6. Obtain how many clients the company has in each country.*/
select pais, count(*) as clientes_por_pais from clientes
group by pais;

/*7. Obtain how many clients the company has in the city of Madrid.*/
select ciudad, count(*) as clientes_ciudad from clientes
where ciudad = 'Madrid';

/*8. Obtain the employee code and the number of clients each sales representative serves.*/
select codigoEmpleadoRepVentas, count(codigoCliente) as clientes_representante from clientes
group by codigoEmpleadoRepVentas;


/*9. Obtain when was the first and last payment made by the client whose code is 3.*/
select min(fechaPago) as primer_pago, max(fechaPago) as ultimo_pago from pagos
where codigoCliente = 3;


/*10. Obtain the customer code of those customers who made payments in 2008*/
select codigoCliente from pagos
where year (fechaPago) = '2008'
group by codigoCliente;


/*11. Obtain the different states through which an order can go.*/
select distinct(estado) as diferentesEstadosDeUnPedido from pedidos;

/*12. Obtain the order number, customer code, required date and delivery date of orders that have not been delivered on time.*/
select codigoPedido, codigoCliente, fechaEsperada, fechaEntrega from pedidos
where fechaEntrega > fechaEsperada;

/*13. Get how many products exist in each order line.*/
select numeroLinea, sum(cantidad) as cantidad_total from detallepedidos
group by numeroLinea;

/*14. Obtain a list of the 20 most ordered product codes ordered by quantity ordered.*/
select codigoProducto as productos_mas_vendidos, sum(cantidad) as cantidad_total 
from detallepedidos
group by codigoProducto
order by sum(cantidad) desc limit 20;
 

/*15. Obtain the order number, customer code, required date and delivery date of orders whose delivery date was at least two days before the required date. (Use addDate function)*/
select codigoPedido, codigoCliente, fechaEsperada, fechaEntrega from pedidos
where fechaEsperada >= (addDate(fechaEntrega, interval 2 day));
 
/*16. Obtain the name, surname, office and position of those who are not sales representatives.*/
select nombre, apellido1, apellido2, codigoOficina, puesto from empleados
where puesto != 'Representante Ventas';

/*17. Obtain the number of clients assigned to each sales representative.*/
select codigoEmpleadoRepVentas, count(codigoCliente) as clientes_asignados from clientes
group by codigoEmpleadoRepVentas;

/*18. Obtain a list with the total price of each order.*/
select codigoPedido, SUM(preciounidad * cantidad) as precio_total from detallepedidos
group by codigoPedido;

/*19. Get how many orders each customer has in each state.*/
select codigoCliente, count(codigoPedido) as pedidos, estado from pedidos
group by codigoCliente, estado
order by codigoCliente;

/*20. Obtain a list with the office, city, region and country code of those offices that are in countries whose name begins with “E”.*/
select codigoOficina, ciudad, region, pais from oficinas
where pais like 'E%';

/*21. Get the name, range, dimensions, quantity in stock and the selling price of the five most expensive products.*/
select nombre as 5_productos_mas_caros, gama, dimensiones, cantidadEnStock, precioVenta from productos
order by precioVenta desc limit 5;

/*22. Obtain the code and billing for orders over 2000 euros.*/
select codigoPedido, sum(cantidad * preciounidad) as facturación from detallepedidos
group by codigoPedido
having sum(cantidad * preciounidad) > 2000;

/*23. Get a list of products showing total stock, range and supplier.*/
select codigoProducto, nombre, sum(cantidadEnStock) as en_stock, gama, proveedor from productos
group by codigoProducto, nombre, gama, proveedor;

/*24. Obtain the order number and customer code of those orders whose order date is the same as the delivery date.*/
select codigoCliente, count(codigoPedido) as numero_de_pedidos from pedidos
where fechaPedido = fechaEntrega
group by codigoCliente;
