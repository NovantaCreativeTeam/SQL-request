use ristotecno;

/**
 * == ADD ATTACHMENT TO PRODUCT =========
 * Query to add and attachment to a product
 * the attachment should be already inserted
 * 
 */

START TRANSACTION;

SET @idLang := 1;
SET @idAttachment := 722;

INSERT INTO ps_product_attachment
select 
	p.id_product,
    @idAttachment as id_attachment
from ps_product p
inner join ps_product_lang pl
	on p.id_product = pl.id_product
    and pl.id_lang = @idLang
where p.id_product = 14403;

ROLLBACK;