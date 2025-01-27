use ristotecno;

/*
 * ==== AGGIUNGE ORDER DETAIL alla sezione PRODOTTI VENDUTI ========
 * Se ci sono errori durante il pagamento è possibile che alcuni prodotti non compaiano nella sezione prodotti venduti
 * Questo problema è dovuto al fatto che i order_detail non hanno l' id_order_invoice settato
 * oppure l'ordine non ha la invoice_date settata
 * 
 * Questa query, dato un ordine, va a settare l'id_order_invoice nei order_details dell'ordine
 * e poi setta la invoice_date nell'order
 */

set @id_roder := 19293;

select o.*, od.*
from ps_orders o
inner join ps_order_detail od
	on o.id_order = od.id_order
left outer join ps_order_detail_processing odp
	on od.id_order_detail = odp.id_order_detail
where o.id_order = @id_order;

select *
from ps_order_invoice oi
where id_order = @id_order;


START TRANSACTION;

update ps_orders o
inner join ps_order_invoice oi
	on o.id_order = oi.id_order
set o.invoice_date = oi.date_add
where o.id_order = @id_order;


update ps_order_detail od
inner join ps_orders o
	on od.id_order = o.id_order
inner join ps_order_invoice oi
	on o.id_order = oi.id_order
set od.id_order_invoice = oi.id_order_invoice
where o.id_order = @id_order;

select * from ps_orders where id_order = @id_order;
select * from ps_order_detail where id_order = @id_order;

ROLLBACK;