USE ristotecno;

/**
 * ========= PRODUCT ATTACHMENT ASSIGNMENT
 * 1. Upload all file in ps with this name: "{prefix} {product.reference or product_attribute.reference}"
 * 2. Lanch this query to assign uploaded files to relative products
 */

SET @prefix := LENGTH('Scheda tecnica - ');

START TRANSACTION;

INSERT INTO ps_product_attachment (id_product, id_attachment)
SELECT 
	products.id_product,
    al.id_attachment
FROM ps_attachment_lang al
LEFT OUTER JOIN (
	SELECT 
		p.id_product,
        IFNULL(pa.reference, p.reference) as reference
    FROM ps_product p
    LEFT OUTER JOIN ps_product_attribute pa
		ON p.id_product = pa.id_product
) AS products
ON products.reference = SUBSTRING(al.name, @prefix + 1, LENGTH(al.name) - @prefix)
WHERE al.id_attachment > 457;

ROLLBACK;

