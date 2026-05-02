-- Comprobación de columna id_registro con valores únicos 

SELECT COUNT(*) AS total_tuplas,
	   COUNT(DISTINCT id_registro) AS total_id_registro
FROM raw.casoscovid2022;

-- Modificación de valores para fechas

-- Para fecha_actualizacion

SELECT DISTINCT fecha_actualizacion
FROM raw.casoscovid2022;
	-- De esta solo nos dió un solo valor que tienen todas las columnas y que en efecto esta en el formato de fecha, así que modificaremos directamente el tipo.

ALTER TABLE raw.casoscovid2022 
ALTER COLUMN fecha_actualizacion TYPE DATE
USING fecha_actualizacion::DATE;

-- Para fecha_ingreso

SELECT DISTINCT fecha_ingreso
FROM raw.casoscovid2022;
	-- Revisando fecha_ingreso igual notamos que no hay ningun valor extraño que nos impida hacer el cast 

ALTER TABLE raw.casoscovid2022
ALTER COLUMN fecha_ingreso TYPE DATE
USING fecha_ingreso::DATE;

-- Para fecha_sintomas

SELECT DISTINCT fecha_sintomas
FROM raw.casoscovid2022;

ALTER TABLE raw.casoscovid2022
ALTER COLUMN fecha_sintomas TYPE DATE
USING fecha_sintomas::DATE;

-- Para fecha_def
SELECT DISTINCT fecha_def
FROM raw.casoscovid2022;
	-- Como podemos ver para esta si tenemos 'NA' probablemente para los casos en los que no se murieron, así que los reemplazaremos por NULL.

UPDATE raw.casoscovid2022 SET fecha_def = NULL WHERE fecha_def = 'NA';
	-- Volviendo a ejecutar el query de distinct, vemos que ya esta presente el valor NULL y no 'NA'
ALTER TABLE raw.casoscovid2022
ALTER COLUMN fecha_def TYPE DATE
USING fecha_def::DATE;

-- Modificación para datos de paciente

-- Edad 
SELECT DISTINCT edad
FROM raw.casoscovid2022;

ALTER TABLE raw.casoscovid2022
ALTER COLUMN edad TYPE INTEGER
USING edad::INTEGER;

