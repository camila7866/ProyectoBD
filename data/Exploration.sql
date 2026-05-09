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
