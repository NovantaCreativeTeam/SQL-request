select 
	p.id_category_default as id_category,
    cl.name as category_name,
    sum(od.product_quantity) as n_product_sell,
    ROUND(SUM(od.total_price_tax_excl),2) as revenue,
    ROUND(AVG(od.product_price), 2) as avg_product_price
from ps_order_detail od
inner join ps_product p
	on od.product_id = p.id_product
inner join ps_category_lang cl
	on p.id_category_default = cl.id_category
group by p.id_category_default
order by SUM(od.total_price_tax_excl) DESC