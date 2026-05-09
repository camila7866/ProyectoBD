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

SELECT COUNT(*) as registros_eliminados FROM raw.casoscovid2021;

COMMIT;

-- ROLLBACK;

