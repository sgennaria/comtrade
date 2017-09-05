DROP TABLE IF EXISTS tb_trade_flow_codes;

CREATE OR REPLACE FUNCTION sp_create_trade_flows(
OUT code text
,OUT trade_flow text
)
	RETURNS SETOF record AS
$BODY$

fpath <- "C:/comtrade/Trade Flow Codes.csv"
df <- read.csv(fpath, header = FALSE)
return(df)

$BODY$
  LANGUAGE plr IMMUTABLE
  COST 100 ROWS 4;


SELECT
	code
	,trade_flow
INTO tb_trade_flow_codes
FROM
	sp_create_trade_flows();

ALTER TABLE tb_trade_flow_codes ADD CONSTRAINT tb_trade_flow_codes_pk PRIMARY KEY (code);


DROP TABLE IF EXISTS tb_quantity_units;

CREATE OR REPLACE FUNCTION sp_create_quantity_units(
OUT code text
,OUT abbreviation text
,OUT description text
)
	RETURNS SETOF record AS
$BODY$

fpath <- "C:/comtrade/Quantity Units.csv"
df <- read.csv(fpath, header = TRUE)
return(df)

$BODY$
  LANGUAGE plr IMMUTABLE
  COST 100 ROWS 13;


SELECT
	code
	,abbreviation
	,description
INTO tb_quantity_units
FROM
	sp_create_quantity_units();

ALTER TABLE tb_quantity_units ADD CONSTRAINT tb_quantity_units_pk PRIMARY KEY (code);


DROP TABLE IF EXISTS tb_commodities;

CREATE OR REPLACE FUNCTION sp_create_commodities(
OUT classification text
,OUT code text
,OUT description text
,OUT parent_code text
,OUT level text
,OUT leaf boolean
)
  RETURNS SETOF record AS
$BODY$

library('readxl')
fpath <- "C:/comtrade/UN Comtrade Commodity Classifications.xlsx"
df <- read_excel(fpath, excel_sheets(fpath)[1])
return(df)

$BODY$
  LANGUAGE plr IMMUTABLE
  COST 100 ROWS 50000;


SELECT
	classification
	,code
	,description
	,parent_code
	,level
	,leaf
INTO tb_commodities
FROM
	sp_create_commodities();

ALTER TABLE tb_commodities ADD CONSTRAINT tb_commodities_pk PRIMARY KEY (classification, code);

DROP TABLE IF EXISTS tb_country_list;

CREATE OR REPLACE FUNCTION sp_create_county_list(
OUT city_code text
,OUT city_name text
,OUT city_full_name text
,OUT city_abbreviation text
,OUT city_comments text
,OUT city_iso2_alpha text
,OUT city_iso3_alpha text
,OUT city_start_year int
,OUT city_end_year int
)
  RETURNS SETOF record AS
$BODY$

library('readxl')
fpath <- "C:/comtrade/UN Comtrade Country List.xls" # this won't work with the xls version for some reason
df <- read_excel(fpath)
return(df)

$BODY$
  LANGUAGE plr IMMUTABLE
  COST 100 ROWS 300;


SELECT
	city_code
	,city_name
	,city_full_name
	,city_abbreviation
	,city_comments
	,city_iso2_alpha
	,city_iso3_alpha
	,city_start_year
	,city_end_year
INTO tb_country_list
FROM
	sp_create_county_list();

ALTER TABLE tb_country_list ADD CONSTRAINT tb_country_list_pk PRIMARY KEY (city_code);