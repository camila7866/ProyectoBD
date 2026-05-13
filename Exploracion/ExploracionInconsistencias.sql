-- Primero vemos que los datos se hayan cargado correctamente
SELECT*
FROM raw.casoscovid2021
LIMIT 100;

-- La siguiente consulta nos da a entender que no hay ninguna columna de toma_muestra_lab no realizada cuyo resultad_lab sea diferente a no aplica y 
-- si toma_muestra_lab es si todas son diferentes a no aplica, por lo que en realidad nos esta diciendo la misma información, por lo que eliminaremos toma_muestra_lab y solo nos quedaremos con el resultado

SELECT *
FROM raw.casoscovid2021
WHERE (toma_muestra_lab = 'No' AND resultado_lab != 'No aplica')
   OR (toma_muestra_lab = 'Sí' AND resultado_lab = 'No aplica');
   
-- Pasa lo mismo con este caso

SELECT *
FROM raw.casoscovid2021
WHERE (toma_muestra_antigeno = 'No' AND resultado_antigeno != 'No aplica')
   OR (toma_muestra_antigeno = 'Sí' AND resultado_antigeno = 'No aplica');

-- Nos dimos cuenta con la carga inicial de que hay varias fechas de defunción que son NA
SELECT *
FROM raw.casoscovid2021
WHERE fecha_def = 'NA'
LIMIT 10;


--Buscamos si hay alguna fecha con formato invalido

SELECT fecha_actualizacion, fecha_ingreso, fecha_sintomas, fecha_def
FROM raw.casoscovid2021
WHERE fecha_actualizacion !~ '^\d{4}-\d{2}-\d{2}$'
   OR fecha_ingreso !~ '^\d{4}-\d{2}-\d{2}$'
   OR fecha_sintomas !~ '^\d{4}-\d{2}-\d{2}$'
   OR fecha_def !~ '^\d{4}-\d{2}-\d{2}$'
LIMIT 10;

-- Minimos y maximos de fechas
SELECT MAX(fecha_ingreso) AS max_fecha_ingreso,
		MAX(fecha_sintomas) AS max_fecha_sint,
		MAX(fecha_def) AS max_fecha_def
FROM raw.casoscovid2021;

SELECT MIN(fecha_ingreso) AS primer_fecha_ingreso,
		MIN(fecha_sintomas) AS min_fecha_sint, --Es interesante ver aqui que el paciente que empezó a sentir sintomas más temprano fue el septiembre 2020, y que hay pacientes que murieron antes 
		MIN(fecha_def) AS primer_fecha_def
FROM raw.casoscovid2021;

-- Minimos y maximos de columnas numericas, aquí observamos que como son de texto no funcionan en este punto
SELECT MAX(edad) FROM raw.casoscovid2021;

SELECT MIN(edad) FROM raw.casoscovid2021;

SELECT AVG(edad) FROM raw.casoscovid2021;



-- Ahora veamos los distintos valores de las columnas categoricas

SELECT DISTINCT intubado
FROM raw.casoscovid2021; -- NO, NO APLICA, NO ESPECIFICADO, SI

SELECT DISTINCT neumonia
FROM raw.casoscovid2021; -- NO, SI

SELECT DISTINCT indigena
FROM raw.casoscovid2021; -- NO, SI, NO ESPECIFICADO

SELECT DISTINCT diabetes 
FROM raw.casoscovid2021; -- NO, SE IGNORA, SI

SELECT DISTINCT epoc
FROM raw.casoscovid2021; -- NO, SE IGNORA, SI

SELECT DISTINCT asma
FROM raw.casoscovid2021; -- NO, SE IGNORA, SI

SELECT DISTINCT inmusupr
FROM raw.casoscovid2021; -- NO, SE IGNORA, SI

SELECT DISTINCT hipertension
FROM raw.casoscovid2021; -- NO, SE IGNORA, SI

SELECT DISTINCT otra_com
FROM raw.casoscovid2021; -- NO, SE IGNORA, SI

SELECT DISTINCT cardiovascular
FROM raw.casoscovid2021; -- NO, SE IGNORA, SI

SELECT DISTINCT obesidad
FROM raw.casoscovid2021; -- NO, SE IGNORA, SI

SELECT DISTINCT renal_cronica
FROM raw.casoscovid2021; -- NO, SE IGNORA, SI

SELECT DISTINCT tabaquismo
FROM raw.casoscovid2021; -- NO, SE IGNORA, SI

-- Vemos todos los valores de las columnas restantes para ver si no hay información inconsistente
SELECT 
    'origen' as columna, origen as valor, COUNT(*) as frecuencia
FROM raw.casoscovid2021 GROUP BY origen
UNION ALL
SELECT 
    'sector', sector, COUNT(*)
FROM raw.casoscovid2021 GROUP BY sector
UNION ALL
SELECT 
    'entidad_um', entidad_um, COUNT(*)
FROM raw.casoscovid2021 GROUP BY entidad_um
UNION ALL
SELECT 
    'sexo', sexo, COUNT(*)
FROM raw.casoscovid2021 GROUP BY sexo
UNION ALL
SELECT 
    'entidad_nac', entidad_nac, COUNT(*)
FROM raw.casoscovid2021 GROUP BY entidad_nac
UNION ALL
SELECT 
    'entidad_res', entidad_res, COUNT(*)
FROM raw.casoscovid2021 GROUP BY entidad_res
UNION ALL
SELECT 
    'municipio_res', municipio_res, COUNT(*)
FROM raw.casoscovid2021 GROUP BY municipio_res
UNION ALL
SELECT 
    'tipo_paciente', tipo_paciente, COUNT(*)
FROM raw.casoscovid2021 GROUP BY tipo_paciente
UNION ALL
SELECT 
    'nacionalidad', nacionalidad, COUNT(*)
FROM raw.casoscovid2021 GROUP BY nacionalidad
UNION ALL
SELECT 
    'resultado_lab', resultado_lab, COUNT(*)
FROM raw.casoscovid2021 GROUP BY resultado_lab
UNION ALL
SELECT 
    'resultado_antigeno', resultado_antigeno, COUNT(*)
FROM raw.casoscovid2021 GROUP BY resultado_antigeno
UNION ALL
SELECT 
    'clasificacion_final', clasificacion_final, COUNT(*)
FROM raw.casoscovid2021 GROUP BY clasificacion_final
UNION ALL
SELECT 
    'pais_nacionalidad', pais_nacionalidad, COUNT(*)
FROM raw.casoscovid2021 GROUP BY pais_nacionalidad
UNION ALL
SELECT 
    'pais_origen', pais_origen, COUNT(*)
FROM raw.casoscovid2021 GROUP BY pais_origen
ORDER BY columna, valor;

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

