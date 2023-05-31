use ristotecno_arreda;

select 
	c.id_category,
    cl.*
from ps_category c
inner join ps_category_lang cl
	on c.id_category = cl.id_category
left outer join ps_category_product cp
	on c.id_category = cp.id_category
where cp.id_category is null and c.id_category not in (1,2);


START TRANSACTION;

update ps_category c
left outer join ps_category_product cp
	on c.id_category = cp.id_category
set active = 0
where cp.id_category is null and c.id_category not in (1,2);

COMMIT;

