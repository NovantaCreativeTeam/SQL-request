/*
 * ======== EXPORT PRODUCTS WITH COMBINATION
 * This query export products with combination 
 * Every combination is exported in a separate row
 */

SET @id_lang = 1; 
SET @base_url = 'https://www.example.com/'; 

SELECT 
	product.id_product as id_product,
    IFNULL(combination.id_product_attribute, 0) as id_product_attribute,
    IF(	combination.attribute_reference IS NULL OR combination.attribute_reference = '', product.reference, combination.attribute_reference) as reference,
    product.ean13 as EAN,
    CONCAT(product.name, ' - ', IFNULL(combination.attribute, '')) as product_name,
    product.description_short as short_description,
    product.description as description,
    ROUND(ROUND(product.price, 2) + ifnull(combination.attribute_price, 0), 2) as price,
    product.category as category,
    img as image
FROM (
	SELECT 
		p.id_product,
        p.reference,
        pl.name,
        p.price,
        m.name as manufacturer,
        GROUP_CONCAT(DISTINCT(REPLACE(cl.name, ',', '')) SEPARATOR ', ') AS category,
        pl.description_short,
        pl.description,
        p.active,
        p.EAN13,
        IFNULL(GROUP_CONCAT(DISTINCT CONCAT(@base_url, '/', im.id_image, '-medium_default/', pl.link_rewrite, '.jpg')), '') AS img
	FROM ps_product p
	INNER JOIN ps_product_lang pl
		ON p.id_product = pl.id_product
		AND pl.id_lang = @id_lang
	LEFT OUTER JOIN ps_manufacturer m
		on p.id_manufacturer = m.id_manufacturer
	LEFT OUTER JOIN ps_category_product cp
		ON cp.id_product = p.id_product
	LEFT OUTER JOIN ps_category_lang cl
		ON cp.id_category = cl.id_category
		AND cl.id_lang = @id_lang
	LEFT OUTER JOIN (
		SELECT i.*, il.legend 
		FROM ps_image i
		INNER JOIN ps_image_lang il
			ON i.id_image = il.id_image
			AND id_lang = @id_lang
	) im
		ON p.id_product = im.id_product	
	GROUP BY p.id_product
) as product
LEFT OUTER JOIN  (
	SELECT 
		p.id_product,
        pa.id_product_attribute,
		GROUP_CONCAT(CONCAT(agl.public_name, ':', al.name)) as attribute,
		pa.reference AS attribute_reference,
		ROUND(IFNULL(pa.price, ''),2) AS attribute_price
	FROM ps_product_attribute pa
	INNER JOIN ps_product p
		ON pa.id_product = p.id_product
	INNER JOIN ps_product_attribute_combination pac
		ON pa.id_product_attribute = pac.id_product_attribute
	INNER JOIN ps_attribute a
		ON pac.id_attribute = a.id_attribute
	INNER JOIN ps_attribute_lang al
		ON a.id_attribute = al.id_attribute
		AND al.id_lang = @id_lang
	INNER JOIN ps_attribute_group ag
		ON a.id_attribute_group = ag.id_attribute_group
	INNER JOIN ps_attribute_group_lang agl
		ON ag.id_attribute_group = agl.id_attribute_group
		AND agl.id_lang = @id_lang
	GROUP BY pa.id_product_attribute
    ORDER BY LENGTH(GROUP_CONCAT(CONCAT(agl.public_name, ':', al.name))), pa.price
) as combination
	on product.id_product = combination.id_product
LEFT OUTER JOIN ps_specific_price sp
	ON product.id_product = sp.id_product
    AND IFNULL(combination.id_product_attribute, 0) = sp.id_product_attribute
    AND sp.id_group = 3
where 
	product.active = 1
ORDER BY product.id_product;
