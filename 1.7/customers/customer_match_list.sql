/*
 * ==== CUSTOMER MATCH
 * 1. Query to export all customer that have buyed something
 * 2. Query to export all customer that not buy nothing but registerd
 * 3. Query to export all non business customer
 * 4. Query to export all business customer
 * 5. Query to export all request from mofule GFORMBUILDER
 */

select 
	c.firstname as `First Name`,
    c.lastname as `Last Name`,
    IFNULL(co.iso_code, '') as `Country`,
    IFNULL(a.postcode, '') as `Zip`,
    c.email as `Email`,
	IFNULL(IF(a.phone like '0039%' or a.phone like '_0039%' or a.phone like '+39%', REPLACE(' ', '', REPLACE(a.phone, '0039', '+39')), CONCAT('+39', a.phone)), '') as `Phone`
from ps_customer c
left outer join ps_address a
	on c.id_customer = a.id_customer
    and lower(a.firstname) = lower(c.firstname)
	and lower(a.lastname) = lower(c.lastname)
left outer join ps_country co
	on a.id_country = co.id_country
left outer join ps_orders o
	on o.id_customer = c.id_customer
where o.id_order is not null
group by c.email;


select 
	c.firstname as `First Name`,
    c.lastname as `Last Name`,
    IFNULL(co.iso_code, '') as `Country`,
    IFNULL(a.postcode, '') as `Zip`,
    c.email as `Email`,
	IFNULL(IF(a.phone like '0039%' or a.phone like '_0039%' or a.phone like '+39%', REPLACE(' ', '', REPLACE(a.phone, '0039', '+39')), CONCAT('+39', a.phone)), '') as `Phone`
from ps_customer c
left outer join ps_address a
	on c.id_customer = a.id_customer
    and lower(a.firstname) = lower(c.firstname)
	and lower(a.lastname) = lower(c.lastname)
left outer join ps_country co
	on a.id_country = co.id_country
left outer join ps_orders o
	on o.id_customer = c.id_customer
where o.id_order is null
group by c.email;



select 
	a.firstname as `First Name`,
    a.lastname as `Last Name`,
    IFNULL(co.iso_code, '') as `Country`,
    IFNULL(a.postcode, '') as `Zip`,
    c.email as `Email`,  
    IF(
		a.phone is not null and a.phone <> '', 
		IF(a.phone like '0039%' or a.phone like '_0039%' or a.phone like '+39%', REPLACE(' ', '', REPLACE(a.phone, '0039', '+39')), CONCAT('+39', a.phone)), 
        ''
	) as `Phone`
from ps_address a
left outer join ps_country co
	on a.id_country = co.id_country
left outer join ps_customer c
	on c.id_customer = a.id_customer
where a.company is not null and a.company <> ''
group by c.id_customer;


select 
	a.firstname as `First Name`,
    a.lastname as `Last Name`,
    IFNULL(co.iso_code, '') as `Country`,
    IFNULL(a.postcode, '') as `Zip`,
    c.email as `Email`,  
    IF(
		a.phone is not null and a.phone <> '', 
		IF(a.phone like '0039%' or a.phone like '_0039%' or a.phone like '+39%', REPLACE(' ', '', REPLACE(a.phone, '0039', '+39')), CONCAT('+39', a.phone)), 
        ''
	) as `Phone`
from ps_address a
left outer join ps_country co
	on a.id_country = co.id_country
left outer join ps_customer c
	on c.id_customer = a.id_customer
where 
	(a.company = '' or a.company is null) and 
    a.`id_customer` not in (
		select 
			c_in.id_customer as `id_customer`
		from ps_address a_in
		left outer join ps_customer c_in
			on c_in.id_customer = a_in.id_customer
		where a_in.company is not null and a_in.company <> '' and c_in.id_customer is not null
		group by c_in.id_customer
	)
group by c.id_customer

union all

select 
	c.firstname as `First Name`,
    c.lastname as `Last Name`,
    '' as `Country`,
    '' as `Zip`,
    c.email as `Email`,  
    '' as `Phone`
from ps_customer c
left outer join ps_address a
	on c.id_customer = a.id_customer
where a.id_customer is null;


select 
	SUBSTRING_INDEX(name, ' ', 1) as `First Name`,
    substring(name from instr(name, ' ') + 1) as `Last Name`,
    '' as `Country`,
    '' as `Zip`,
    email as `Email`,
    IFNULL(IF(phone like '0039%' or phone like '_0039%' or phone like '+39%', REPLACE(' ', '', REPLACE(phone, '0039', '+39')), CONCAT('+39', phone)), '') as `Phone`
from (
	select 
		REPLACE(json_extract(jsonrequest, '$.{name}'), '"', '') AS name,
		REPLACE(json_extract(jsonrequest, '$.{email}'), '"', '') AS email,
		REPLACE(REPLACE(json_extract(jsonrequest, '$.{phone}'), '"', ''), ' ', '') AS phone
	from ps_gformrequest
) form_request;