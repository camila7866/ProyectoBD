ALTER TABLE raw.casoscovid2021 
DROP COLUMN IF EXISTS columna,
DROP COLUMN IF EXISTS habla_lengua_indig,
DROP COLUMN IF EXISTS otro_caso,
DROP COLUMN IF EXISTS toma_muestra_lab,
DROP COLUMN IF EXISTS toma_muestra_antigeno,
DROP COLUMN IF EXISTS fecha_actualizacion,
DROP COLUMN IF EXISTS entidad_nac, 
DROP COLUMN IF EXISTS pais_nacionalidad, 
DROP COLUMN IF EXISTS pais_origen, 
DROP COLUMN IF EXISTS migrante;

DROP TYPE IF EXISTS estado_categorico CASCADE;
DROP TYPE IF EXISTS sexoT CASCADE;
DROP TYPE IF EXISTS tipo_pacienteT CASCADE;

-- Cambiamos los valores que dicen NA por NULL
UPDATE raw.casoscovid2021
SET fecha_def = NULL
WHERE fecha_def = 'NA';

/* Esta sección fue eliminada ya que causaba problemas al crear las tablas pues borraba la mayoría de los registros
UPDATE raw.casoscovid2021
SET entidad_res = NULL
WHERE entidad_res= 'NA';

UPDATE raw.casoscovid2021
SET municipio_res = NULL
WHERE municipio_res= 'NA';
*/


START TRANSACTION;

-- 1. Convertir columnas de fecha
ALTER TABLE raw.casoscovid2021
ALTER COLUMN fecha_ingreso TYPE DATE USING fecha_ingreso::DATE,
ALTER COLUMN fecha_sintomas TYPE DATE USING fecha_sintomas::DATE,
ALTER COLUMN fecha_def TYPE DATE USING fecha_def::DATE;

-- 2. Convertir edad a número
ALTER TABLE raw.casoscovid2021
ALTER COLUMN edad TYPE INTEGER USING edad::INTEGER;

COMMIT;

-- Crear ENUM
CREATE TYPE estado_categorico AS ENUM (
    'SI',
    'NO',
    'SE IGNORA',
    'NO ESPECIFICADO',
    'NO APLICA'
);

CREATE TYPE sexoT AS ENUM (
    'HOMBRE', 
    'MUJER'
);

CREATE TYPE tipo_pacienteT AS ENUM (
    'AMBULATORIO', 
    'HOSPITALIZADO'
);


START TRANSACTION;

ALTER TABLE raw.casoscovid2021
ALTER COLUMN intubado TYPE estado_categorico USING intubado::estado_categorico,
ALTER COLUMN neumonia TYPE estado_categorico USING neumonia::estado_categorico,
ALTER COLUMN indigena TYPE estado_categorico USING indigena::estado_categorico,
ALTER COLUMN diabetes TYPE estado_categorico USING diabetes::estado_categorico,
ALTER COLUMN epoc TYPE estado_categorico USING epoc::estado_categorico,
ALTER COLUMN asma TYPE estado_categorico USING asma::estado_categorico,
ALTER COLUMN inmusupr TYPE estado_categorico USING inmusupr::estado_categorico,
ALTER COLUMN hipertension TYPE estado_categorico USING hipertension::estado_categorico,
ALTER COLUMN otra_com TYPE estado_categorico USING otra_com::estado_categorico,
ALTER COLUMN cardiovascular TYPE estado_categorico USING cardiovascular::estado_categorico,
ALTER COLUMN obesidad TYPE estado_categorico USING obesidad::estado_categorico,
ALTER COLUMN renal_cronica TYPE estado_categorico USING renal_cronica::estado_categorico,
ALTER COLUMN tabaquismo TYPE estado_categorico USING tabaquismo::estado_categorico,
ALTER COLUMN embarazo TYPE estado_categorico USING embarazo::estado_categorico,
ALTER COLUMN migrante TYPE estado_categorico USING migrante::estado_categorico,
ALTER COLUMN uci TYPE estado_categorico USING uci::estado_categorico, 
ALTER COLUMN sexo TYPE sexoT USING sexo::sexoT,
ALTER COLUMN tipo_paciente TYPE tipo_pacienteT USING tipo_paciente::tipo_pacienteT;

COMMIT;



START TRANSACTION;

ALTER TABLE raw.casoscovid2021
ALTER COLUMN origen TYPE VARCHAR(100),
ALTER COLUMN sector TYPE VARCHAR(100),
ALTER COLUMN entidad_um TYPE VARCHAR(100),
ALTER COLUMN entidad_res TYPE VARCHAR(100),
ALTER COLUMN municipio_res TYPE VARCHAR(100),
ALTER COLUMN nacionalidad TYPE VARCHAR(50),
ALTER COLUMN resultado_lab TYPE VARCHAR(100),
ALTER COLUMN resultado_antigeno TYPE VARCHAR(100),
ALTER COLUMN clasificacion_final TYPE VARCHAR(100);

COMMIT;

-- Eliminamos duplicados considerando como criterio de duplicados todos los atributos menos el registro_id
-- Paso 1: Crear una tabla temporal con los registros únicos
CREATE TABLE raw.casoscovid2021_sin_duplicados AS
SELECT DISTINCT ON (origen, sector, entidad_um, sexo, entidad_res, municipio_res, 
                    tipo_paciente, fecha_ingreso, fecha_sintomas, fecha_def, 
                    intubado, neumonia, edad, nacionalidad, embarazo, indigena, 
                    diabetes, epoc, asma, inmusupr, hipertension, otra_com, 
                    cardiovascular, obesidad, renal_cronica, tabaquismo, 
                    resultado_lab, resultado_antigeno, clasificacion_final, 
                    migrante, uci)
    *  
FROM raw.casoscovid2021
ORDER BY origen, sector, entidad_um, sexo, entidad_res, municipio_res, 
         tipo_paciente, fecha_ingreso, fecha_sintomas, fecha_def, 
         intubado, neumonia, edad, nacionalidad, embarazo, indigena, 
         diabetes, epoc, asma, inmusupr, hipertension, otra_com, 
         cardiovascular, obesidad, renal_cronica, tabaquismo, 
         resultado_lab, resultado_antigeno, clasificacion_final, 
         migrante, uci, id_registro; 

-- Paso 2: Reemplazar la tabla original
DROP TABLE raw.casoscovid2021;
ALTER TABLE raw.casoscovid2021_sin_duplicados RENAME TO casoscovid2021;


   -- Eliminamos aquellos en los que encontramos inconsistencias
   
BEGIN;


DELETE FROM raw.casoscovid2021 
WHERE (fecha_def < fecha_ingreso AND fecha_def IS NOT NULL AND fecha_ingreso IS NOT NULL)
   OR (fecha_def < fecha_sintomas AND fecha_def IS NOT NULL AND fecha_sintomas IS NOT NULL);

COMMIT;

-- ROLLBACK;

-- Limpiamos clasificacion_final que tiene espacios extra

UPDATE raw.casoscovid2021
SET clasificacion_final = REGEXP_REPLACE(
    clasificacion_final,
    '\s+',
    ' ',
    'g'
);




