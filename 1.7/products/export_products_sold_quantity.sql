use ristotecno;

select 
	IF(	pa.reference IS NULL OR pa.reference = '', p.reference, pa.reference) as Codice,
	od.product_name as `Prodotto`,
	sum(od.product_quantity) as `Quantità`,
    sum(od.total_price_tax_excl) as `Valore generato (IVA esclusa)`,
    SUM(IF(YEAR(o.date_add) = '2019', od.product_quantity, 0)) as `Quantità 2019`,
    SUM(IF(YEAR(o.date_add) = '2020', od.product_quantity, 0)) as `Quantità 2020`,
    SUM(IF(YEAR(o.date_add) = '2021', od.product_quantity, 0)) as `Quantità 2021`,
    SUM(IF(YEAR(o.date_add) = '2022', od.product_quantity, 0)) as `Quantità 2022`,
    SUM(IF(YEAR(o.date_add) = '2023', od.product_quantity, 0)) as `Quantità 2023`,
    SUM(IF(YEAR(o.date_add) = '2024', od.product_quantity, 0)) as `Quantità 2024`
from ps_order_detail od
inner join ps_orders o
	on od.id_order = o.id_order
left outer join ps_product p
	on od.product_id = p.id_product
left outer join ps_product_lang pl
	on p.id_product = pl.id_product
left outer join ps_product_attribute pa
	on od.product_attribute_id = pa.id_product_attribute
group by od.product_id, od.product_attribute_id
order by sum(od.total_price_tax_excl) desc;