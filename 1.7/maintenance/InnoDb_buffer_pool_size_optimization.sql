/**
 * Recommended InnoDB Buffer Pool Size =======
 * This query calculate the recommended size for InnoDB Buffer Pool Size
 * 
 */
 
SET @ribps := 1; 
 
SELECT 
	@@innodb_buffer_pool_size/1024/1024/1024 `Actual IBPS`,
	Total_InnoDB_Bytes*1.6/POWER(1024,3) `Minimal IBPS`,
    @ribps = CEILING(Total_InnoDB_Bytes*1.6/POWER(1024,3)) `RIBPS`
    FROM (
		SELECT SUM(data_length+index_length) Total_InnoDB_Bytes 
        FROM information_schema.tables 
        WHERE engine='InnoDB'
	) A;


SELECT @@innodb_buffer_pool_size/1024/1024/1024;
SELECT @ribps * POWER(1024,3);
-- SET GLOBAL innodb_buffer_pool_size = @ribps * POWER(1024,3);


/**
 * This query is used to calculare buffer pool size utilized by db
 */
 
SELECT (PagesData*PageSize)/POWER(1024,3) DataGB 
FROM (
	SELECT variable_value PagesData
	FROM information_schema.global_status
	WHERE variable_name='Innodb_buffer_pool_pages_data') A,
	(
		SELECT variable_value PageSize
		FROM information_schema.global_status
		WHERE variable_name='Innodb_page_size'
	) B;


