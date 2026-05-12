-- 1. Inconsistencias con fechas

-- 1.1 Fecha de síntomas después de fecha de ingreso
SELECT 
    'fecha_sintomas > fecha_ingreso' as problema,
    fecha_sintomas,
    fecha_ingreso,
    id_registro
FROM raw.casoscovid2021 
WHERE fecha_sintomas > fecha_ingreso
   AND fecha_sintomas IS NOT NULL 
   AND fecha_ingreso IS NOT NULL;

-- 1.2 Fecha de ingreso después de fecha de actualización
SELECT 
    'fecha_ingreso > fecha_actualizacion' as problema,
    fecha_ingreso,
    fecha_actualizacion,
    id_registro
FROM raw.casoscovid2021 
WHERE fecha_ingreso > fecha_actualizacion
   AND fecha_ingreso IS NOT NULL 
   AND fecha_actualizacion IS NOT NULL;
--------------------------------------------------------------------ERRORES DETECTADO--------------------------------------------------------------------

-- 1.3 Fecha de defunción antes de fecha de ingreso (imposible)
SELECT 
    'fecha_def < fecha_ingreso' as problema,
    fecha_def,
    fecha_ingreso,
    id_registro
FROM raw.casoscovid2021 
WHERE fecha_def < fecha_ingreso
   AND fecha_def IS NOT NULL 
   AND fecha_ingreso IS NOT NULL;

-- 1.4 Fecha de defunción antes de fecha de síntomas
SELECT 
    'fecha_def < fecha_sintomas' as problema,
    fecha_def,
    fecha_sintomas,
    id_registro
FROM raw.casoscovid2021 
WHERE fecha_def < fecha_sintomas
   AND fecha_def IS NOT NULL 
   AND fecha_sintomas IS NOT NULL;
  
   
---------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1.5 Fecha de síntomas en el futuro
SELECT 
    'fecha_sintomas > fecha_actual' as problema,
    fecha_sintomas,
    CURRENT_DATE as fecha_actual,
    id_registro
FROM raw.casoscovid2021 
WHERE fecha_sintomas > CURRENT_DATE;

-- Veamos ahora el máximo y mínimo de todas las fechas para ver si tiene sentido
SELECT max(fecha_def) AS Max_fecha_def, min(fecha_def) AS Min_fecha_def, max(fecha_ingreso) AS Max_fecha_ingreso, min(fecha_ingreso) AS Min_fecha_ingreso, min(fecha_sintomas) AS Min_fecha_sintomas, max(fecha_sintomas) AS Max_fecha_sintomas, min(fecha_actualizacion) AS Min_fecha_actualizacion, max(fecha_actualizacion) AS Max_fecha_actualizacion
FROM raw.casoscovid2021;



-- 2. Inconsistencia con datos del paciente

--2.1 Hombre embarazado
SELECT 
    'hombre embarazado' as problema,
    sexo,
    embarazo,
    id_registro
FROM raw.casoscovid2021 
WHERE sexo = 'HOMBRE' AND embarazo = 'SI';

--2.2  Migrante mexicano que vive en México
SELECT 
    'mexicano_marcado_como_migrante_sin_pais_origen_extranjero' as problema,
    COUNT(*) as total
FROM raw.casoscovid2021 
WHERE migrante = 'SI' 
  AND nacionalidad = 'MEXICANA'
  AND (pais_origen IS NULL OR pais_nacionalidad LIKE '%MEXICO%');
  

-- 3. Errores consideracion de pruebas

SELECT 
     'Caso de SARS-COV-2 confirmado por prueba sin prueba' as problema,
     COUNT(*) as total 
FROM raw.casoscovid2021
WHERE  clasificacion_final = 'CASO DE SARS-COV-2  CONFIRMADO' AND (resultado_lab != 'POSITIVO A SARS-COV-2' and resultado_antigeno != 'POSITIVO A SARS-COV-2');

-- 3.1 Confirmados sin NINGUNA prueba positiva

SELECT 
    'confirmado_sin_prueba_positiva' AS problema,
    COUNT(*) AS total
FROM raw.casoscovid2021
WHERE clasificacion_final = 'CASO DE SARS-COV-2  CONFIRMADO' 
  AND NOT (
        resultado_lab = 'POSITIVO A SARS-COV-2'
     OR resultado_antigeno = 'POSITIVO A SARS-COV-2'
  );
  

-- 3.2 Casos negativos pero con prueba positiva
SELECT 
    'negativo_con_prueba_positiva' as problema,
    COUNT(*) as total
FROM raw.casoscovid2021
WHERE clasificacion_final = 'NEGATIVO A SARS-COV-2'
  AND (resultado_lab = 'POSITIVO A SARS-COV-2' 
       OR resultado_antigeno = 'POSITIVO A SARS-COV-2');

-- 3.3 Ver casos sospechosos sin prueba
SELECT 
    'sospechoso_sin_prueba' as problema,
    COUNT(*) as total
FROM raw.casoscovid2021
WHERE clasificacion_final = 'CASO SOSPECHOSO'
  AND resultado_lab IS NULL 
  AND resultado_antigeno IS NULL;

