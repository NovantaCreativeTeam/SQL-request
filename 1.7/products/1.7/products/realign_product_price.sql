use ristotecno;

/**
 * REALIGN PRODUCT PRICES ===========
 * Query to align product base price to have cheapest combination with 0 impact on price
 * Ps order prodoucts in frontend based on product price, but display price of default combination,
 * so the ordering not respect prices.
 
 * - This query set base price of product as price of cheapest combination, and recalculate other combination impacts.
 * - This query set cheapest combination as default combination
 */

select 
	p.id_product,
    p.reference,
    p.price,
    cc.price,
    p.price + cc.price
from ps_product p
inner join (
	select *
    from (
		select 
			id_product,
			id_product_attribute,
			price as price,
			ROW_NUMBER() OVER(partition by id_product ORDER BY price) as nrow
		from ps_product_attribute
        where id_product > 0
	) as cco
    where cco.nrow = 1 and cco.price > 0
) as cc
on p.id_product = cc.id_product;

select 
	pa.id_product,
    pa.id_product_attribute,
    pa.price,
    cc.price,
    pa.price - cc.price,
    default_on
from ps_product_attribute pa
inner join (
	select *
    from (
		select 
			id_product,
			id_product_attribute,
			price as price,
			ROW_NUMBER() OVER(partition by id_product ORDER BY price) as nrow
		from ps_product_attribute
        where id_product > 0
	) as cco
    where cco.nrow = 1 and cco.price > 0
) as cc
on pa.id_product = cc.id_product;


START TRANSACTION;

/*
 * This Query incremente parent product price of cheapest combination price
 */
update ps_product p
inner join (
    select *
    from (
		select 
			id_product,
			id_product_attribute,
			price as price,
			ROW_NUMBER() OVER(partition by id_product ORDER BY price) as nrow
		from ps_product_attribute
        where id_product > 0
	) as cco
    where cco.nrow = 1 and cco.price > 0
) as cc
ON p.id_product = cc.id_product
set p.price = p.price + cc.price;

update ps_product_shop p
inner join (
    select *
    from (
		select 
			id_product,
			id_product_attribute,
			price as price,
			ROW_NUMBER() OVER(partition by id_product ORDER BY price) as nrow
		from ps_product_attribute
        where id_product > 0
	) as cco
    where cco.nrow = 1 and cco.price > 0
) as cc
ON p.id_product = cc.id_product
set p.price = p.price + cc.price;

/*
 * This query decrease eache combination of cheapest combination value
 * In this way the cheapest combination has 0 impact on price
 */
update ps_product_attribute pa
inner join (
	select *
    from (
		select 
			id_product,
			id_product_attribute,
			price as price,
			ROW_NUMBER() OVER(partition by id_product ORDER BY price) as nrow
		from ps_product_attribute
        where id_product > 0
	) as cco
    where cco.nrow = 1 and cco.price > 0
) as cc
on pa.id_product = cc.id_product
set pa.price = pa.price - cc.price;

update ps_product_attribute_shop pa
inner join (
	select *
    from (
		select 
			id_product,
			id_product_attribute,
			price as price,
			ROW_NUMBER() OVER(partition by id_product ORDER BY price) as nrow
		from ps_product_attribute_shop
        where id_product > 0
	) as cco
    where cco.nrow = 1 and cco.price > 0
) as cc
on pa.id_product = cc.id_product
set pa.price = pa.price - cc.price;

COMMIT;