/*
	========== CATEGORIES TREE
    Query to export categories as a tree, with complete category path
    This query works with max 10 level depth of categories, 
    if you need more depth you need to modify query adding joins as below
    
    1. Run first query to discover you max level depth
    2. Set language you want
    3. If your level depth is less than 10, you can execute tree query
*/
 
-- 1. Run first query to discover you max level depth
SELECT MAX(level_depth) FROM ps_category;

-- 2. Set language you want
SET @id_lang := 1; 

-- 3. If your level depth is less than 10, you can execute tree query
SELECT 
	c1.id_category, 
    CONCAT(
		IF(cl10.name IS NULL, '', CONCAT(' > ', cl10.name)),
        IF(cl9.name IS NULL, '', CONCAT(' > ', cl9.name)),
        IF(cl8.name IS NULL, '', CONCAT(' > ', cl8.name)),
        IF(cl7.name IS NULL, '', CONCAT(' > ', cl7.name)),
        IF(cl6.name IS NULL, '', CONCAT(' > ', cl6.name)),
        IF(cl5.name IS NULL, '', CONCAT(' > ', cl5.name)),
		IF(cl4.name IS NULL, '', CONCAT(' > ', cl4.name)),
        IF(cl3.name IS NULL, '', CONCAT(' > ', cl3.name)),
        IF(cl2.name IS NULL, '', CONCAT(' > ', cl2.name)),
        IF(cl1.name IS NULL, '', CONCAT(' > ', cl1.name))
    ) AS category
FROM ps_category c1
LEFT OUTER JOIN ps_category_lang AS cl1 ON c1.id_category = cl1.id_category AND cl1.id_lang = @id_lang

LEFT OUTER JOIN ps_category AS c2 ON c1.id_parent = c2.id_category
LEFT OUTER JOIN ps_category_lang AS cl2 ON c2.id_category = cl2.id_category AND cl2.id_lang = @id_lang

LEFT OUTER JOIN ps_category AS c3 ON c2.id_parent = c3.id_category
LEFT OUTER JOIN ps_category_lang AS cl3 ON c3.id_category = cl3.id_category AND cl3.id_lang = @id_lang

LEFT OUTER JOIN ps_category AS c4 ON c3.id_parent = c4.id_category
LEFT OUTER JOIN ps_category_lang AS cl4 ON c4.id_category = cl4.id_category AND cl4.id_lang = @id_lang

LEFT OUTER JOIN ps_category AS c5 ON c4.id_parent = c5.id_category
LEFT OUTER JOIN ps_category_lang AS cl5 ON c5.id_category = cl5.id_category AND cl5.id_lang = @id_lang

LEFT OUTER JOIN ps_category AS c6 ON c5.id_parent = c6.id_category
LEFT OUTER JOIN ps_category_lang AS cl6 ON c6.id_category = cl6.id_category AND cl6.id_lang = @id_lang

LEFT OUTER JOIN ps_category AS c7 ON c6.id_parent = c7.id_category
LEFT OUTER JOIN ps_category_lang AS cl7 ON c7.id_category = cl7.id_category AND cl7.id_lang = @id_lang

LEFT OUTER JOIN ps_category AS c8 ON c7.id_parent = c8.id_category
LEFT OUTER JOIN ps_category_lang AS cl8 ON c8.id_category = cl8.id_category AND cl8.id_lang = @id_lang

LEFT OUTER JOIN ps_category AS c9 ON c8.id_parent = c9.id_category
LEFT OUTER JOIN ps_category_lang AS cl9 ON c9.id_category = cl9.id_category AND cl9.id_lang = @id_lang

LEFT OUTER JOIN ps_category AS c10 ON c9.id_parent = c10.id_category
LEFT OUTER JOIN ps_category_lang AS cl10 ON c10.id_category = cl10.id_category AND cl10.id_lang = @id_lang;