--DROP TABLE raw.enfermedades;
-- DROP TABLE raw.paciente;

--TABLA LUGAR DE RESIDENCIA

CREATE TABLE raw.residencia(
id BIGSERIAL PRIMARY KEY, 
entidad_res VARCHAR(100),
municipio_res VARCHAR(100)
);

--Llenado de tabla

INSERT INTO raw.residencia(entidad_res, municipio_res)
SELECT DISTINCT
entidad_res, municipio_res
FROM raw.casoscovid2021;

-- TABLA PERSONA

CREATE TABLE raw.persona ( 
id BIGSERIAL PRIMARY KEY,
edad INT, 
sexo sexoT,
migrante ESTADO_CATEGORICO,
indigena ESTADO_CATEGORICO,
sector VARCHAR(100), 
residencia_id BIGINT,

CONSTRAINT edad_plausible CHECK (edad >= 0 AND edad < 200),
FOREIGN KEY (residencia_id) references raw.lugar_de_residencia (id) ON DELETE CASCADE

);

-- TABLA PACIENTE

CREATE TABLE raw.paciente (
id BIGSERIAL PRIMARY KEY,
persona_id BIGINT, 
origen VARCHAR(100), 
entidad_um VARCHAR(100),
tipo_paciente tipo_pacienteT,
fecha_ingreso date,
fecha_sintomas date, 
intubado date, 
uci ESTADO_CATEGORICO

FOREIGN KEY (persona_id) references raw.persona (id) ON DELETE RESTRICT

);

-- TABLA PACIENTE_ENFERMEDAD

CREATE TABLE raw.paciente_enfermedad (
id BIGSERIAL PRIMARY KEY,
paciente_id BIGINT, 
enfermedad_id BIGINT


FOREIGN KEY (paciente_id) references raw.paciente (id) ON DELETE CASCADE
FOREIGN KEY (enfermedad_id) references raw.enfermedad (id) ON DELETE CASCADE
);

-- TABLA PACIENTE_CONDICION

CREATE TABLE raw.paciente_condicion (
id BISERIAL PRIMARY KEY, 
paciente_id BIGINT, 
condicion_id BIGINT

FOREIGN KEY (paciente_id) references raw.paciente (id) ON DELETE CASCADE
FOREIGN KEY (condicion_id) references raw.condicion (id) ON DELETE CASCADE
);

--TABLA ENFERMEDAD

CREATE TABLE raw.enfermedad (
id BIGSERIAL PRIMARY KEY,
diabetes ESTADO_CATEGORICO, 
epoc ESTADO_CATEGORICO, 
asma ESTADO_CATEGORICO, 
inmusupr ESTADO_CATEGORICO,
hipert ESTADO_CATEGORICO, 
cardiovasc ESTADO_CATEGORICO,
neumonia ESTADO_CATEGORICO

);

-- TABLA CONDICION

CREATE TABLE raw.enfermedad (
id BIGSERIAL PRIMARY KEY,
embarazo ESTADO_CATEGORICO, 
obesidad ESTADO_CATEGORICO, 
tabaquismo ESTADO_CATEGORICO
);

-- TABLA RESULTADO

CREATE TABLE raw.resultado (
id BIGSERIAL PRIMARY KEY,
paciente_id BIGINT, 
fecha_def date, 
resultado_lab VARCHAR(100), 
resultado_antig VARCHAR(100), 
clasificacion_final VARCHAR(100)

);

