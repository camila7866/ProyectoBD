ALTER TABLE raw.casoscovid2021 
DROP COLUMN IF EXISTS columna,
DROP COLUMN IF EXISTS habla_lengua_indig,
DROP COLUMN IF EXISTS otro_caso,
DROP COLUMN IF EXISTS toma_muestra_lab,
DROP COLUMN IF EXISTS toma_muestra_antigeno,
DROP COLUMN IF EXISTS fecha_actualizacion,
DROP COLUMN IF EXISTS id_registro
DROP COLUMN IF EXISTS entidad_nac, 
DROP COLUMN IF EXISTS pais_nacionalidad, 
DROP COLUMN IF EXISTS pais_origen;

-- Cambiamos las fechas que dicen NA por NULL
UPDATE raw.casoscovid2021
SET fecha_def = NULL
WHERE fecha_def = 'NA';

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
ALTER COLUMN sexo TYPE tipo_pacienteT USING tipo_paciente::tipo_pacienteT,    ;

COMMIT;



START TRANSACTION;

ALTER TABLE raw.casoscovid2021
ALTER COLUMN origen TYPE VARCHAR(100),
ALTER COLUMN sector TYPE VARCHAR(100),
ALTER COLUMN entidad_um TYPE VARCHAR(100),
ALTER COLUMN sexo TYPE VARCHAR(10),
ALTER COLUMN entidad_nac TYPE VARCHAR(100),
ALTER COLUMN entidad_res TYPE VARCHAR(100),
ALTER COLUMN municipio_res TYPE VARCHAR(100),
ALTER COLUMN tipo_paciente TYPE VARCHAR(50),
ALTER COLUMN nacionalidad TYPE VARCHAR(50),
ALTER COLUMN resultado_lab TYPE VARCHAR(100),
ALTER COLUMN resultado_antigeno TYPE VARCHAR(100),
ALTER COLUMN clasificacion_final TYPE VARCHAR(100),
ALTER COLUMN pais_nacionalidad TYPE VARCHAR(100),
ALTER COLUMN pais_origen TYPE VARCHAR(100);

COMMIT;
