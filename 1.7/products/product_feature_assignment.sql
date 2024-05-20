use ristotecno;

SET @feature_name := 'Made in Italy';
SET @feature_value := 'Sì';
SET @id_feature := 0;
SET @id_feature_value := 0;

SET @categories := '14,11,119,120,507,77,79,80,81,82,87,91,221,88,92,222,89,93,220,90,94,78,83,84,85,86,95,99,96,100,97,101,98,597,12,19,27,28,33,34,31,32,13,16,25,22,26,29,30,20,117,118,339,24,35,39,40,301,429,474,518,36,37,38,302,436,475,519';
SET @excluded_products := '7266,12219,1947,13461,1949,1951,13468,12759,12755,12763,12279,12280,6526,6528,3721,3724,3723,3726,88';

SELECT 
	@id_feature := f.id_feature,
    @id_feature_value := fv.id_feature_value,
    fl.*
FROM ps_feature f
INNER JOIN ps_feature_lang fl
	ON f.id_feature = fl.id_feature
    AND fl.id_lang = 1
INNER JOIN ps_feature_value fv
	ON f.id_feature = fv.id_feature
INNER JOIN ps_feature_value_lang fvl
	ON fv.id_feature_value = fvl.id_feature_value
	AND fvl.id_lang = 1
WHERE fl.name = @feature_name
	AND fvl.value = @feature_value;
    
    
SELECT 
	p.id_product AS id_product
FROM ps_product p
LEFT OUTER JOIN ps_category_product cp
	ON cp.id_product = p.id_product
WHERE FIND_IN_SET(cp.id_category, @categories)
	AND NOT FIND_IN_SET(p.id_product, @excluded_products);
    
    
START TRANSACTION;

INSERT INTO ps_feature_product (id_product, id_feature, id_feature_value)
SELECT 
	p.id_product AS id_product,
    @id_feature as id_feature,
    @id_feature_value as id_feature_value
FROM ps_product p
LEFT OUTER JOIN ps_category_product cp
	ON cp.id_product = p.id_product
WHERE FIND_IN_SET(cp.id_category, @categories)
	AND NOT FIND_IN_SET(p.id_product, @excluded_products)
GROUP BY p.id_product;

COMMIT;



