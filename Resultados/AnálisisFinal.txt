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
FROM raw.resultado;
