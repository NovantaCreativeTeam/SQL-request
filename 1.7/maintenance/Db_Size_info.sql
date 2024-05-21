SET @db_name := "borsellini";

SELECT table_schema,
        ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" 
FROM information_schema.tables 
GROUP BY table_schema; 


SELECT
  TABLE_NAME AS `Table`,
  ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024) AS `Size (MB)`
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = @db_name
ORDER BY (DATA_LENGTH + INDEX_LENGTH) DESC;


SELECT 
	`engine`, 
    count(*) tables, 
    concat(round(sum(table_rows)/1000000,2),'M') `rows`, 
    concat(round(sum(data_length)/(1024*1024*1024),2),'G') data, 
    concat(round(sum(index_length)/(1024*1024*1024),2),'G') idx, 
    concat(round(sum(data_length+index_length)/(1024*1024*1024),2),'G') total_size 
FROM information_schema.TABLES GROUP BY engine ORDER BY sum(data_length+index_length) DESC 
LIMIT 10