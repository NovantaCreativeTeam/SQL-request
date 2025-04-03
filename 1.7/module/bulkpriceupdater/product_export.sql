/**
 * ============== BULKPRICEUPDATE Query Export ===============
 * Query used by bulkpriceupdate to generate csv for Export/Import functionality
 */

select
	p.id_product, 
	IFNULL(pa.id_product_attribute, '0') as id_product_attribute,
	IF(pa.reference IS NULL OR pa.reference = '', p.reference, pa.reference) as reference,
	pl.name,
	IFNULL(GROUP_CONCAT(DISTINCT CONCAT(agl.public_name, ':', al.name) ORDER BY ag.position), '') as combination,
	ROUND(ROUND(p.price, 2) + ifnull(pa.price, 0), 2) as price,
    '' as price_new
from ps_product p
inner Join ps_product_lang pl on p.id_product = pl.id_product and pl.id_lang = 1
left outer Join ps_product_attribute pa on p.id_product = pa.id_product
left outer Join ps_product_attribute_combination pac on pa.id_product_attribute = pac.id_product_attribute
left outer Join ps_attribute a on pac.id_attribute = a.id_attribute
left outer Join ps_attribute_lang al on a.id_attribute = al.id_attribute AND al.id_lang = 1
left outer Join ps_attribute_group ag on a.id_attribute_group = ag.id_attribute_group
left outer Join ps_attribute_group_lang agl on ag.id_attribute_group = agl.id_attribute_group AND agl.id_lang = 1
left outer Join ps_category_product cp on cp.id_product = p.id_product
left outer Join ps_product_supplier ps on p.id_product = ps.id_product and IFNULL(pa.id_product_attribute, 0) = ps.id_product_attribute
group By p.id_product, pa.id_product_attribute;
