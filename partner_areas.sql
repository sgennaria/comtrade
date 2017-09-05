DROP TABLE IF EXISTS tb_partner_areas;

CREATE OR REPLACE FUNCTION sp_create_partner_areas(
OUT p text
,OUT area text
)
  RETURNS SETOF record AS
$BODY$

library(rjson)
string <- "http://comtrade.un.org/data/cache/partnerAreas.json"
reporters <- fromJSON(file=string)
reporters <- as.data.frame(t(sapply(reporters$results,rbind)))
return(reporters)

$BODY$
  LANGUAGE plr IMMUTABLE
  COST 100 ROWS 1000;

SELECT 
	p::int
	,area
INTO tb_partner_areas
FROM 
	sp_create_partner_areas()
WHERE
	p <> 'all';

ALTER TABLE tb_partner_areas ADD CONSTRAINT tb_partner_areas_pk PRIMARY KEY (p);

DROP TABLE IF EXISTS tb_reporter_areas;

CREATE OR REPLACE FUNCTION sp_create_reporter_areas(
OUT r text
,OUT area text
)
  RETURNS SETOF record AS
$BODY$

library(rjson)
string <- "http://comtrade.un.org/data/cache/reporterAreas.json"
reporters <- fromJSON(file=string)
reporters <- as.data.frame(t(sapply(reporters$results,rbind)))
return(reporters)

$BODY$
  LANGUAGE plr IMMUTABLE
  COST 100 ROWS 1000;

SELECT 
	r::int
	,area
INTO tb_reporter_areas
FROM 
	sp_create_reporter_areas()
WHERE
	r <> 'all';

ALTER TABLE tb_reporter_areas ADD CONSTRAINT tb_reporter_areas_pk PRIMARY KEY (r);