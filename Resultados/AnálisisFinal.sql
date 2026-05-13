-- CASOS POSITIVOS POR ENTIDAD DE RESIDENCIA

SELECT residencia.entidad_res, COUNT(*)
FROM raw.residencia
LEFT JOIN raw.persona ON 
persona.residencia_id = residencia.id
LEFT JOIN raw.paciente ON 
paciente.persona_id = persona.id
LEFT JOIN raw.resultado ON 
resultado.paciente_id = paciente.id
WHERE raw.resultado.clasificacion_final IN ('CASO DE COVID-19 CONFIRMADO POR ASOCIACIÓN CLÍNICA EPIDEMIOLÓGICA', 'CASO DE COVID-19 CONFIRMADO POR COMITÉ DE  DICTAMINACIÓN', 'CASO DE SARS-COV-2  CONFIRMADO') AND municipio_res LIKE '%TLA%'
GROUP BY raw.residencia.entidad_res

;

-- CASOS NEGATIVOS POR ENTIDAD DE RESIDENCIA

SELECT residencia.entidad_res, COUNT(*)
FROM raw.residencia
LEFT JOIN raw.persona ON 
persona.residencia_id = residencia.id
LEFT JOIN raw.paciente ON 
paciente.persona_id = persona.id
LEFT JOIN raw.resultado ON 
resultado.paciente_id = paciente.id
WHERE raw.resultado.clasificacion_final IN ('INVÁLIDO POR LABORATORIO', 'NEGATIVO A SARS-COV-2')
GROUP BY raw.residencia.entidad_res
;

------------------------------------------ CASOS POSITIVOS POR RANGO DE EDAD---------------------------------------------------------------

WITH pacientes_con_resultados AS (
    SELECT 
        pa.id AS paciente_id,
        per.edad,
        per.sexo,
        CASE 
            WHEN per.edad BETWEEN 0 AND 10 THEN '0-10 años'
            WHEN per.edad BETWEEN 11 AND 20 THEN '11-20 años'
            WHEN per.edad BETWEEN 21 AND 30 THEN '21-30 años'
            WHEN per.edad BETWEEN 31 AND 40 THEN '31-40 años'
            WHEN per.edad BETWEEN 41 AND 50 THEN '41-50 años'
            WHEN per.edad BETWEEN 51 AND 60 THEN '51-60 años'
            WHEN per.edad BETWEEN 61 AND 70 THEN '61-70 años'
            WHEN per.edad > 70 THEN '>70 años'
        END AS grupo_etario,
        CASE 
            WHEN res.clasificacion_final IN (
                'CASO DE COVID-19 CONFIRMADO POR ASOCIACIÓN CLÍNICA EPIDEMIOLÓGICA',
                'CASO DE COVID-19 CONFIRMADO POR COMITÉ DE DICTAMINACIÓN',
                'CASO DE SARS-COV-2 CONFIRMADO'
            ) THEN 1 
            ELSE 0 
        END AS es_caso_confirmado,
        CASE 
            WHEN res.fecha_def IS NOT NULL  AND res.clasificacion_final IN (
                'CASO DE COVID-19 CONFIRMADO POR ASOCIACIÓN CLÍNICA EPIDEMIOLÓGICA',
                'CASO DE COVID-19 CONFIRMADO POR COMITÉ DE DICTAMINACIÓN',
                'CASO DE SARS-COV-2 CONFIRMADO'
            ) THEN 1
            ELSE 0
        END AS murio_por_covid
        
    FROM raw.persona per
    JOIN raw.paciente pa ON pa.persona_id = per.id
    LEFT JOIN raw.resultado res ON res.paciente_id = pa.id
)
SELECT 
    grupo_etario,
    COUNT(DISTINCT paciente_id) AS total_pacientes,
    SUM(es_caso_confirmado) AS casos_confirmados,
    -- RAZÓN: casos confirmados / total pacientes
    SUM(es_caso_confirmado) *1.000 / COUNT(DISTINCT paciente_id) AS razon_casos_por_paciente,
    -- Porcentaje
    (SUM(es_caso_confirmado) *1.000/ COUNT(DISTINCT paciente_id)) * 100 AS porcentaje_confirmados, 
    (SUM(murio_por_covid) * 1.000/ SUM(es_caso_confirmado)) *100  AS porcentaje_muertos_por_covid
FROM pacientes_con_resultados
WHERE grupo_etario IS NOT NULL
GROUP BY grupo_etario
ORDER BY grupo_etario;

------------------------------------------------------ CASOS NEGATIVOS POR RANGO EDAD-------------------------------------------------

WITH pacientes_con_resultados AS (
    SELECT 
        pa.id AS paciente_id,
        per.edad,
        per.sexo,
        CASE 
            WHEN per.edad BETWEEN 0 AND 10 THEN '0-10 años'
            WHEN per.edad BETWEEN 11 AND 20 THEN '11-20 años'
            WHEN per.edad BETWEEN 21 AND 30 THEN '21-30 años'
            WHEN per.edad BETWEEN 31 AND 40 THEN '31-40 años'
            WHEN per.edad BETWEEN 41 AND 50 THEN '41-50 años'
            WHEN per.edad BETWEEN 51 AND 60 THEN '51-60 años'
            WHEN per.edad BETWEEN 61 AND 70 THEN '61-70 años'
            WHEN per.edad > 70 THEN '>70 años'
        END AS grupo_etario,
        CASE 
            WHEN res.clasificacion_final IN (
                'INVÁLIDO POR LABORATORIO', 'NEGATIVO A SARS-COV-2'
            ) THEN 1 
            ELSE 0 
        END AS es_caso_confirmado
    FROM raw.persona per
    JOIN raw.paciente pa ON pa.persona_id = per.id
    LEFT JOIN raw.resultado res ON res.paciente_id = pa.id
)
SELECT 
    grupo_etario,
    COUNT(DISTINCT paciente_id) AS total_pacientes,
    SUM(es_caso_confirmado) AS casos_confirmados,
    -- RAZÓN: casos confirmados / total pacientes
    SUM(es_caso_confirmado) *1.000 / COUNT(DISTINCT paciente_id) AS razon_casos_por_paciente,
    -- Porcentaje
    (SUM(es_caso_confirmado) *1.000/ COUNT(DISTINCT paciente_id)) * 100 AS porcentaje_confirmados
FROM pacientes_con_resultados
WHERE grupo_etario IS NOT NULL
GROUP BY grupo_etario
ORDER BY grupo_etario;


SELECT COUNT(*)
FROM raw.paciente;

SELECT DISTINCT clasificacion_final

-------------------------------------------------------ANALISIS DE MORTALIDAD---------------------------------------------------------------------------
    
-- 1. TASA DE LETALIDAD POR ENTIDAD DE RESIDENCIA CORREGIDA
WITH casos_confirmados AS (
    SELECT 
        res.entidad_res,
        pa.id AS paciente_id,
        -- Validamos que no sea nulo y que tampoco sea la fecha de los sobrevivientes
        CASE 
            WHEN resu.fecha_def IS NOT NULL THEN 1 
            ELSE 0 
        END AS fallecido
    FROM raw.residencia res
    LEFT JOIN raw.persona per ON per.residencia_id = res.id
    LEFT JOIN raw.paciente pa ON pa.persona_id = per.id
    LEFT JOIN raw.resultado resu ON resu.paciente_id = pa.id
    WHERE resu.clasificacion_final IN (
        'CASO DE COVID-19 CONFIRMADO POR ASOCIACIÓN CLÍNICA EPIDEMIOLÓGICA',
        'CASO DE COVID-19 CONFIRMADO POR COMITÉ DE DICTAMINACIÓN', -- Con doble espacio
        'CASO DE SARS-COV-2 CONFIRMADO' -- Con doble espacio
    )
)
SELECT 
    entidad_res,
    COUNT(DISTINCT paciente_id) AS total_casos_confirmados,
    SUM(fallecido) AS total_defunciones,
    (SUM(fallecido) * 100.0 / COUNT(DISTINCT paciente_id)) AS tasa_letalidad_porcentaje
FROM casos_confirmados
WHERE entidad_res IS NOT NULL
GROUP BY entidad_res
ORDER BY tasa_letalidad_porcentaje DESC;


-- 2. TASA DE LETALIDAD POR SEXO CORREGIDA
WITH casos_confirmados_sexo AS (
    SELECT 
        per.sexo,
        pa.id AS paciente_id,
        CASE 
            WHEN resu.fecha_def IS NOT NULL THEN 1 
            ELSE 0 
        END AS fallecido
    FROM raw.persona per
    LEFT JOIN raw.paciente pa ON pa.persona_id = per.id
    LEFT JOIN raw.resultado resu ON resu.paciente_id = pa.id
    WHERE resu.clasificacion_final IN (
        'CASO DE COVID-19 CONFIRMADO POR ASOCIACIÓN CLÍNICA EPIDEMIOLÓGICA',
        'CASO DE COVID-19 CONFIRMADO POR COMITÉ DE  DICTAMINACIÓN', -- Con doble espacio
        'CASO DE SARS-COV-2  CONFIRMADO' -- Con doble espacio
    )
)
SELECT 
    sexo,
    COUNT(DISTINCT paciente_id) AS total_casos_confirmados,
    SUM(fallecido) AS total_defunciones,
    (SUM(fallecido) * 100.0 / COUNT(DISTINCT paciente_id)) AS tasa_letalidad_porcentaje
FROM casos_confirmados_sexo
WHERE sexo IS NOT NULL
GROUP BY sexo
ORDER BY tasa_letalidad_porcentaje DESC;

WITH total_muertos AS(
	SELECT COUNT(fecha_def)
	FROM resultado
	);
	
-- 3. TASA DE LETALIDAD POR ENFERMEDAD
SELECT
    enfermedad.nombre AS enfermedad,
    COUNT(*) AS total_pacientes_con_enfermedad,
    SUM(CASE WHEN resultado.fecha_def IS NOT NULL THEN 1 ELSE 0 END) AS total_defunciones,
    ROUND(100.0 * SUM(CASE WHEN resultado.fecha_def IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS porcentaje_mortalidad
FROM raw.paciente_enfermedad 
JOIN raw.enfermedad 
    ON paciente_enfermedad.enfermedad_id = enfermedad.id
JOIN raw.resultado 
    ON paciente_enfermedad.paciente_id = resultado.paciente_id
GROUP BY enfermedad.nombre
ORDER BY porcentaje_mortalidad DESC;

-- 4. TASA DE LETALIDAD POR CONDICIÓN
SELECT
    condicion.nombre AS condicion,
    COUNT(*) AS total_pacientes_con_condicion,
    SUM(CASE WHEN resultado.fecha_def IS NOT NULL THEN 1 ELSE 0 END) AS total_defunciones,
    ROUND(100.0 * SUM(CASE WHEN resultado.fecha_def IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*),2) AS porcentaje_mortalidad
FROM raw.paciente_condicion
JOIN raw.condicion
    ON paciente_condicion.condicion_id = condicion.id
JOIN raw.resultado
    ON paciente_condicion.paciente_id = resultado.paciente_id
GROUP BY condicion.nombre
ORDER BY porcentaje_mortalidad DESC;
