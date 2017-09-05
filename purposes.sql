DROP TABLE IF EXISTS tb_levels;

CREATE OR REPLACE FUNCTION sp_create_levels(
OUT level_code text
,OUT level_name text
)
  RETURNS SETOF record AS
$BODY$

library('readxl')
fpath <- "C:/comtrade/COFOG.xlsx"
df <- read_excel(fpath, excel_sheets(fpath)[1])
return(df)

$BODY$
  LANGUAGE plr IMMUTABLE
  COST 100 ROWS 3;


SELECT
	level_code
	,level_name
INTO tb_levels
FROM
	sp_create_levels();

ALTER TABLE tb_levels ADD CONSTRAINT tb_levels_pk PRIMARY KEY (level_code);

DROP TABLE IF EXISTS tb_purpose_structures;

CREATE OR REPLACE FUNCTION sp_create_purpose_structures(
IN fname text,
OUT sort_order int
	,OUT code text
	,OUT code_level text
	,OUT level1 text
	,OUT level2 text
	,OUT level3 text
	,OUT level4 text
	,OUT level5  text
	,OUT level6 text
)
  RETURNS SETOF record AS
$BODY$

library('readxl')
fpath <- paste0("C:/comtrade/", fname, ".xlsx")
df <- read_excel(fpath, excel_sheets(fpath)[2])
return(df)

$BODY$
  LANGUAGE plr IMMUTABLE
  COST 100 ROWS 500;

WITH sub AS(
SELECT 'COFOG'::text AS purpose, * FROM	sp_create_purpose_structures('COFOG')
UNION ALL SELECT 'COICOP', * FROM sp_create_purpose_structures('COICOP')
UNION ALL SELECT 'COPNI', * FROM sp_create_purpose_structures('COPNI')
UNION ALL SELECT 'COPP', * FROM sp_create_purpose_structures('COPP')
)
SELECT
	purpose
	,sort_order
	,code
	,code_level
	,level1
	,level2
	,level3
	,level4
	,level5
	,level6
INTO tb_purpose_structures
FROM
	sub;

ALTER TABLE tb_purpose_structures ADD CONSTRAINT tb_purpose_structures_pk PRIMARY KEY (purpose, code);

DROP TABLE IF EXISTS tb_purpose_titles;

CREATE OR REPLACE FUNCTION sp_create_purpose_titles(
IN fname text
	,OUT code text
	,OUT description text
	,OUT note text
	,OUT change_date text
)
  RETURNS SETOF record AS
$BODY$

library('readxl')
fpath <- paste0("C:/comtrade/", fname, ".xlsx")
df <- read_excel(fpath, excel_sheets(fpath)[3])
return(df)

$BODY$
  LANGUAGE plr IMMUTABLE
  COST 100 ROWS 500;

WITH sub AS(
SELECT 'COFOG'::text AS purpose, * FROM	sp_create_purpose_titles('COFOG')
UNION ALL SELECT 'COICOP', * FROM sp_create_purpose_titles('COICOP')
UNION ALL SELECT 'COPNI', * FROM sp_create_purpose_titles('COPNI')
UNION ALL SELECT 'COPP', * FROM sp_create_purpose_titles('COPP')
)
SELECT
	purpose
	,code
	,description
	,note
	,change_date
INTO tb_purpose_titles
FROM
	sub;

ALTER TABLE tb_purpose_titles ADD CONSTRAINT tb_purpose_titles_pk PRIMARY KEY (purpose, code);