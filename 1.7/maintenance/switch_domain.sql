use ristotecno_arreda;

/*
 * ============= AGGIORNAMENTO DOMINIO
 * Query che aggiorna il dominio del sito web e
 * abilita o disabilita l'https del sito
 */

SET @new_domain = 'dev.ristotecnoarreda.com';
SET @ssl_enabled = 0; 

update ps_configuration
set value = @new_domain
where name in ('PS_SHOP_DOMAIN', 'PS_SHOP_DOMAIN_SSL');

update ps_shop_url
set domain = @new_domain, domain_ssl = @new_domain;


update ps_configuration 
set value = @ssl_enabled
where name in ('PS_SSL_ENABLED', 'PS_SSL_ENABLED_EVERYWHERE');