
CREATE OR REPLACE FUNCTION partner_areas(
OUT r text
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
	r::int
	,area
INTO tb_partner_areas
FROM 
	partner_areas()
WHERE
	r <> 'all';

ALTER TABLE tb_partner_areas ADD CONSTRAINT tb_partner_areas_pk PRIMARY KEY (r);