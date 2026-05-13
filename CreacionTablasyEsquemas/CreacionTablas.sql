--DROP TABLE raw.enfermedades;
-- DROP TABLE raw.paciente;

-------------------------------------------------------------------------------TABLA LUGAR DE RESIDENCIA--------------------------------------------------------------------------------

CREATE TABLE raw.residencia(
id BIGSERIAL PRIMARY KEY, 
entidad_res VARCHAR(100),
municipio_res VARCHAR(100)
);

--Llenado de tabla

INSERT INTO raw.residencia(entidad_res, municipio_res)
SELECT DISTINCT
entidad_res, municipio_res
FROM raw.casoscovid2021
WHERE entidad_res IS NOT NULL AND municipio_res IS NOT NULL;

------------------------------------------------------------------------------------- TABLA PERSONA ---------------------------------------------------------------------------------
-- DROP TABLE raw.persona CASCADE

CREATE TABLE raw.persona ( 
id BIGSERIAL PRIMARY KEY,
registro_id text,
edad INT, 
sexo sexoT,
migrante ESTADO_CATEGORICO,
indigena ESTADO_CATEGORICO,
sector VARCHAR(100), 
residencia_id BIGINT,

CONSTRAINT edad_plausible CHECK (edad >= 0 AND edad < 200),
FOREIGN KEY (residencia_id) references raw.residencia (id) ON DELETE CASCADE

);

--Llenado de tabla persona

-- No usamos distinct pues asumimos que cada registro era una persona distinta, pues no hay ningun criterio claro para diferenciarlas

INSERT INTO raw.persona(registro_id,edad, sexo, migrante, indigena, sector, residencia_id)
SELECT
    c.id_registro, c.edad, c.sexo, c.migrante, c.indigena, c.sector, r.id   
FROM raw.casoscovid2021 c
JOIN raw.residencia r 
    ON r.entidad_res = c.entidad_res 
    AND r.municipio_res = c.municipio_res;
    


-------------------------------------------------------------------------------- TABLA PACIENTE-------------------------------------------------------------------------------------------
--DROP TABLE raw.paciente CASCADE

CREATE TABLE raw.paciente (
id BIGSERIAL PRIMARY KEY,
registro_id text,
persona_id BIGINT, 
origen VARCHAR(100), 
entidad_um VARCHAR(100),
tipo_paciente tipo_pacienteT,
fecha_ingreso date,
fecha_sintomas date,

FOREIGN KEY (persona_id) references raw.persona (id) ON DELETE RESTRICT

);
CREATE INDEX idx_residencia_entidad_municipio ON raw.residencia(entidad_res, municipio_res);
CREATE INDEX idx_persona_demograficos ON raw.persona(edad, sexo, migrante, indigena, sector, residencia_id);
CREATE INDEX idx_casos_entidad_municipio ON raw.casoscovid2021(entidad_res, municipio_res);

--Llenado de tabla paciente

INSERT INTO raw.paciente(persona_id, registro_id, origen, entidad_um, tipo_paciente, fecha_ingreso, fecha_sintomas)
SELECT
   p.id,c.id_registro, c.origen, c.entidad_um, c.tipo_paciente, c.fecha_ingreso, c.fecha_sintomas
FROM raw.casoscovid2021 c
JOIN raw.residencia r 
    ON r.entidad_res = c.entidad_res 
    AND r.municipio_res = c.municipio_res
JOIN raw.persona p 
    ON p.registro_id = c.id_registro;
    

ALTER TABLE raw.paciente ADD CONSTRAINT paciente_persona_unique UNIQUE (persona_id);


------------------------------------------------------------------------------ TABLA COMPLICACION ------------------------------------------------------------------------------------------
--DROP TABLE raw.complicacion CASCADE;

CREATE TABLE raw.complicacion (
id BIGSERIAL PRIMARY KEY,
nombre VARCHAR(100) UNIQUE 

);

--Llenado de tabla complicaciones
INSERT INTO raw.complicacion (nombre) VALUES
('inmusupr'),('neumonia'), ('otra_com'), ('intubado'), ('uci');


------------------------------------------------------------------------- TABLA PACIENTE_COMPLICACION---------------------------------------------------------------------------------------
-- DROP TABLE raw.paciente_complicaciones

CREATE TABLE raw.paciente_complicacion (
id BIGSERIAL PRIMARY KEY,
paciente_id BIGINT NOT NULL, 
complicacion_id BIGINT NOT NULL,


FOREIGN KEY (paciente_id) references raw.paciente (id) ON DELETE CASCADE,
FOREIGN KEY (complicacion_id) references raw.complicacion (id) ON DELETE CASCADE, 
CONSTRAINT _un_paciente_complicacion UNIQUE (paciente_id, complicacion_id)
);

-- poblado de tabla

WITH complicaciones AS (
    -- Primero: relacionar paciente con sus complicaciones (solo donde valor = 'SI')
    
    
    SELECT c.id_registro, 'inmusupr' AS complicacion_nombre
    FROM raw.casoscovid2021 c
    WHERE c.inmusupr = 'SI'

    UNION ALL
    
    SELECT c.id_registro, 'neumonia' AS complicacion_nombre
    FROM raw.casoscovid2021 c
    WHERE c.neumonia = 'SI'
    
    UNION ALL
    
    SELECT c.id_registro, 'otra_com' AS complicacion_nombre
    FROM raw.casoscovid2021 c
    WHERE c.otra_com = 'SI'

	UNION ALL
    
    SELECT c.id_registro, 'intubado' AS complicacion_nombre
    FROM raw.casoscovid2021 c
    WHERE c.intubado = 'SI'

	UNION ALL
    
    SELECT c.id_registro, 'uci' AS complicacion_nombre
    FROM raw.casoscovid2021 c
    WHERE c.uci = 'SI'
    
)

-- Insertar en la tabla de asociación
INSERT INTO raw.paciente_complicacion (paciente_id, complicacion_id)
SELECT 
    p.id as paciente_id,
    c.id as complicacion_id
FROM complicaciones cp
JOIN raw.paciente p ON p.registro_id = cp.id_registro
JOIN raw.complicacion c ON c.nombre = cp.complicacion_nombre;


------------------------------------------------------------------------------- TABLA CONDICION ----------------------------------------------------------------------------------------

-- DROP TABLE raw.condicion

CREATE TABLE raw.condicion (
id BIGSERIAL PRIMARY KEY,
nombre VARCHAR(100) UNIQUE 
);

-- Insercion

INSERT INTO raw.condicion (nombre) VALUES
('epoc'),('embarazo'), ('obesidad'), ('tabaquismo'), ('diabetes') ,  ('asma'), ('hipertension'), ('cardiovascular'), ('renal_cronica');

------------------------------------------------------------------------- TABLA PACIENTE_CONDICION ---------------------------------------------------------------------------------------

CREATE TABLE raw.paciente_condicion (
id BIGSERIAL PRIMARY KEY, 
paciente_id BIGINT NOT NULL, 
condicion_id BIGINT NOT NULL,

FOREIGN KEY (paciente_id) references raw.paciente (id) ON DELETE CASCADE,
FOREIGN KEY (condicion_id) references raw.condicion (id) ON DELETE CASCADE, 
CONSTRAINT _un_paciente_condicion UNIQUE (paciente_id, condicion_id)
);


WITH condicion_paciente AS (
	
	SELECT c.id_registro, 'epoc' AS condicion_nombre
    FROM raw.casoscovid2021 c
    WHERE c.epoc = 'SI'
    
    UNION ALL
	SELECT c.id_registro,
	        'embarazo' as condicion_nombre
	    FROM raw.casoscovid2021 c
	    WHERE c.embarazo = 'SI'

	UNION ALL
    
    SELECT c.id_registro, 'hipertension' as condicion_nombre
    FROM raw.casoscovid2021 c
    WHERE c.hipertension = 'SI'
	
	UNION ALL

	SELECT c.id_registro, 'asma' as condicion_nombre
    FROM raw.casoscovid2021 c
    WHERE c.asma = 'SI'
    
    UNION ALL

	SELECT 
        c.id_registro,
        'diabetes' as condicion_nombre
    FROM raw.casoscovid2021 c
    WHERE c.diabetes = 'SI'
    
    UNION ALL
	
	SELECT c.id_registro,
	        'obesidad' as condicion_nombre
	    FROM raw.casoscovid2021 c
	    WHERE c.obesidad = 'SI'
	    
	UNION ALL
	
	SELECT c.id_registro,
	        'tabaquismo' as condicion_nombre
	    FROM raw.casoscovid2021 c
	    WHERE c.tabaquismo = 'SI'

	UNION ALL
    
    SELECT c.id_registro, 'cardiovascular' AS condicion_nombre
    FROM raw.casoscovid2021 c
    WHERE c.cardiovascular = 'SI'
    
    UNION ALL
    
    SELECT c.id_registro, 'renal_cronica' AS condicion_nombre
    FROM raw.casoscovid2021 c
    WHERE c.renal_cronica = 'SI'

)

INSERT INTO raw.paciente_condicion (paciente_id, condicion_id)
SELECT 
    p.id as paciente_id,
    c.id as condicion_id
FROM condicion_paciente cp
JOIN raw.paciente p ON p.registro_id = cp.id_registro
JOIN raw.condicion c ON c.nombre = cp.condicion_nombre;





---------------------------------------------------------------------------- TABLA RESULTADO ---------------------------------------------------------------------------------------------

-- DROP TABLE raw.resultado
CREATE TABLE raw.resultado (
id BIGSERIAL PRIMARY KEY,
paciente_id BIGINT, 
fecha_def date, 
resultado_lab VARCHAR(100), 
resultado_antig VARCHAR(100), 
clasificacion_final VARCHAR(100),

FOREIGN KEY (paciente_id) REFERENCES raw.paciente (id)

);

-- Insercion

INSERT INTO raw.resultado (paciente_id, fecha_def, resultado_lab, resultado_antig, clasificacion_final)
SELECT 
p.id, c.fecha_def, c.resultado_lab, c.resultado_antigeno, c.clasificacion_final
FROM raw.casoscovid2021 c
JOIN raw.paciente p 
ON c.id_registro = p.registro_id;

ALTER TABLE paciente DROP COLUMN registro_id;
ALTER TABLE persona DROP COLUMN registro_id;

