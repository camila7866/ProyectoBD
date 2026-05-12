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

--------Vemos los 'NA','NO APLICA','NO ESPECIFICADO','SE IGNORA' de cada columna ----------------

SELECT 'id_registro' AS columna, id_registro AS valor, COUNT(*) AS frecuencia
FROM raw.casoscovid2021
WHERE UPPER(id_registro) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY id_registro
UNION ALL
SELECT 'origen', origen, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(origen) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY origen
UNION ALL
SELECT 'sector', sector, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(sector) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY sector
UNION ALL
SELECT 'entidad_um', entidad_um, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(entidad_um) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY entidad_um
UNION ALL
SELECT 'entidad_nac', entidad_nac, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(entidad_nac) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY entidad_nac
UNION ALL
SELECT 'entidad_res', entidad_res, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(entidad_res) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY entidad_res
UNION ALL
SELECT 'sexo', sexo, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(sexo) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY sexo
UNION ALL
SELECT 'municipio_res', municipio_res, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(municipio_res) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY municipio_res
UNION ALL
SELECT 'tipo_paciente', tipo_paciente, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(tipo_paciente) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY tipo_paciente
UNION ALL
SELECT 'fecha_ingreso', CAST(fecha_ingreso AS VARCHAR), COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(CAST(fecha_ingreso AS VARCHAR)) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY fecha_ingreso
UNION ALL
SELECT 'fecha_sintomas', CAST(fecha_sintomas AS VARCHAR), COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(CAST(fecha_sintomas AS VARCHAR)) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY fecha_sintomas
UNION ALL
SELECT 'fecha_def', CAST(fecha_def AS VARCHAR), COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(CAST(fecha_def AS VARCHAR)) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY fecha_def
UNION ALL
SELECT 'edad', CAST(edad AS VARCHAR), COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(CAST(edad AS VARCHAR)) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY edad
UNION ALL
SELECT 'nacionalidad', nacionalidad, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(nacionalidad) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY nacionalidad
UNION ALL
SELECT 'habla_lengua_indig', habla_lengua_indig, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(habla_lengua_indig) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY habla_lengua_indig
UNION ALL
SELECT 'indigena', indigena, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(indigena) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY indigena
UNION ALL
SELECT 'fecha_actualizacion', CAST(fecha_actualizacion AS VARCHAR), COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(CAST(fecha_actualizacion AS VARCHAR)) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY fecha_actualizacion
UNION ALL
SELECT 'toma_muestra_lab', toma_muestra_lab, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(toma_muestra_lab) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY toma_muestra_lab
UNION ALL
SELECT 'resultado_lab', resultado_lab, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(resultado_lab) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY resultado_lab
UNION ALL
SELECT 'toma_muestra_antigeno', toma_muestra_antigeno, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(toma_muestra_antigeno) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY toma_muestra_antigeno
UNION ALL
SELECT 'resultado_antigeno', resultado_antigeno, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(resultado_antigeno) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY resultado_antigeno
UNION ALL
SELECT 'clasificacion_final', clasificacion_final, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(clasificacion_final) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY clasificacion_final
UNION ALL
SELECT 'migrante', migrante, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(migrante) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY migrante
UNION ALL
SELECT 'pais_nacionalidad', pais_nacionalidad, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(pais_nacionalidad) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY pais_nacionalidad
UNION ALL
SELECT 'pais_origen', pais_origen, COUNT(*)
FROM raw.casoscovid2021
WHERE UPPER(pais_origen) IN ('NA','NO APLICA','NO ESPECIFICADO','SE IGNORA')
GROUP BY pais_origen
