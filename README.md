# Proyecto BD: Casos Nacionales COVID 2° Semestre 2022

## Integrantes

| Nombre Completo | Clave Única | GitHub |
| :--- | :--- | :--- |
| Cristopher Gongora Sanchez Castellanos | 218560 | [cristoredentor](https://github.com/cristoredentor) |
| Sandro Petricioli Gomez | 220971 | [spetricig](https://github.com/spetricig) |
| Yahya Hasen Halem Morales | 219072 | [YahyaHalem](https://github.com/YahyaHalem) |
| Camila Velasco Ortega | 217149 | [camila7866](https://github.com/camila7866) |
| Sofia Velazquez Velazquez | 222048 | [sofivelqz](https://github.com/sofivelqz) |
| Diego Haro Sandoval | 209688| [DiegoHaroS](https://github.com/DiegoHaroS) | 


## Introducción

* Esta base de datos incluye todos los casos diarios asociados a COVID-19 a nivel federal. Cuenta con contenido dividido por entidad, sexo, edad, nacionalidad, padecimientos asociados entre otros.
* Este conjunto de datos sólo contempla casos cuyo municipio de residencia o Unidad Médica sea la Ciudad de México.
* La Secretaría de Salud de la Ciudad de México recolecta los datos, muchos de ellos proporcionados por Unidades de Salud Monitoras de Enfermedades Respiratorias en México. 
* La misión principal de la Secretaría es garantizar el derecho efectivo a la salud, y sin discriminación, a los habitantes de la capital así como brindar servicios sanitarios a quienes carecen de seguridad social laboral con el objetivo de que sus habitantes tengan una vida plena y digna.
* La base de datos comprende información correspondiente al periodo del 1 de julio de 2022 al 14 de agosto de 2022. Las actualizaciones diarias se realizaban únicamente a la base del semestre en curso y se elaboró con base en los Datos Abiertos y el Diccionario de Datos provista por el Gobierno Federal. Fue creada el 8 de agosto de 2022 y su última actualización se realizó el 14 de febrero de 2023. 
* Identificar cuáles fueron los potenciales grupos de riesgo en la ciudad de méxico y la 
cantidad de ocurrencias de condiciones críticas para el padecimiento de COVID-19.
* La correlación entre ciertos fenómenos con el caso de covid no implica causalidad y puede estar sesgado a los casos concretos o a poblaciones en riesgo por factores no considerados en la base de datos.

## Datos
| Atributo | Tipo | Descripción |
|---|---|---|
| id_registro | hexadecimal | Es un id único para cada paciente. |
| origen | categórico | Nos dice si la información del paciente fue dada por las unidades de salud monitoras de enfermedades respiratorias (USMER) o no. |
| sector | categórico | Nos dice de qué sector de la población es el paciente dependiendo de su actividad. Distingue entre los trabajadores del gobierno, privados y universitarios. |
| entidad_um | categórico | Dice de qué entidad es la unidad médica. |
| entidad_nac | categórico | Entidad dónde nació el paciente. |
| entidad_res | categórico | Entidad dónde reside el paciente. |
| sexo | categórico | Sexo del paciente. |
| municipio_res | categórico | El municipio en dónde reside el paciente. |
| tipo_paciente | categórico | Nos indica si el paciente fue hospitalizado como "Hospitalizado" y si no como "Ambulatorio". Un paciente ambulatorio es el que recibió atención médica sin ser internado. |
| fecha_ingreso | date | Nos indica la fecha en la que el paciente recibió la atención médica, o en la que fue internado. |
| fecha_sintomas | date | Nos indica la fecha en la que empezaron los síntomas. |
| fecha_def | date | Nos indica la fecha de defunción del paciente. |
| intubado | categórico | Nos indica si el paciente fue intubado. |
| neumonía | categórico | Nos indica si el paciente sufrió de neumonía. |
| edad | int | Nos indica la edad del paciente. |
| nacionalidad | categórico | Nos indica la nacionalidad del paciente. |
| embarazo | categórico | Nos indica si la paciente estaba embarazada al momento de recibir la atención médica. |
| habla_lengua_indigena | categórico | Nos dice si el paciente habla alguna lengua indígena. |
| indigena | categórico | Nos dice si el paciente es de origen indígena. |
| fecha_actualización | date | Nos dice la última fecha en la que se actualizó la información del paciente. |
| asma | categórico | Nos indica si el paciente padece de asma. |
| inmusupr | categórico | Nos indica si el paciente padece de inmunosupresión. |
| hipertension | categórico | Nos indica si el paciente padece hipertensión. |
| otra_com | categórico | Nos indica si el paciente padece de otra complicación. |
| cardiovascular | categórico | Nos indica si el paciente padece de problemas cardiovasculares. |
| obesidad | categórico | Nos indica si el paciente padece de obesidad. |
| renal_cronica | categórico | Nos indica si el paciente padece de enfermedad renal crónica. |
| tabaquismo | categórico | Nos indica si el paciente padece de tabaquismo. |
| otro_caso | categórico | Nos indica si el paciente padece de otras adicciones. |
| toma_muestra_lab | categórico | Nos indica si se tomó muestra para prueba PCR de SARS-COV-2. |
| resultado_lab | categórico | Nos indica el resultado de la prueba PCR de SARS-COV-2. |
| toma_muestra_antigeno | categórico | Nos indica si se tomó muestra para prueba de antígeno de SARS-COV-2. |
| resultado_antigeno | categórico | Nos indica el resultado de la prueba de antígeno de SARS-COV-2. |
| clasificacion_final | categórico | Nos indica el tipo de caso: "Caso de COVID-19 confirmado por asociación", "Caso de COVID-19 confirmado por comité", "Caso de SARS-COV-2 confirmado por prueba", "Caso sospechoso", "Inválido por laboratorio", "Negativo a SARS-COV-2 por prueba", "No realizado por laboratorio". |
| migrante | categórico | Nos indica si el paciente es migrante. |
| pais_nacionalidad | categórico | Nos indica el país de nacionalidad del paciente. |
| pais_origen | categórico | Nos indica el país de nacimiento del paciente. |
| uci | categórico | Nos indica si el paciente fue ingresado a la unidad de cuidados intensivos. |
| diabetes | categórico | Nos indica si el paciente tiene diabetes. |
| epoc | categórico | Nos indica si el paciente tiene la Enfermedad Pulmonar Obstructiva Crónica (EPOC). |
## Fuente de datos

Para este proyecto se utilizan los datos proporcionados por el portal de datos abiertos del Gobierno de la Ciudad de México sobre materia de salud. Se puede acceder a los datos en [Casos Nacionales 1° Semestre 2021](https://datos.cdmx.gob.mx/dataset/casos-asociados-a-covid-19/resource/a8236652-a729-49bd-958a-5615ea609397?inner_span=True).

Las instrucciones de replicación del proyecto asumen que los datos se encuentran almacenados en formato CSV bajo el nombre 'raw_data.csv'.


Para cargar los datos fue necesario poner todas las columnas en tipo text, lo cual se puede observar en el archivo de raw_data_creation_and_load.sql en la carpeta data, pues varias columnas tenian NA como atributos. Por lo que lo primero que había que hacer era cambiar los NA por nulls. Después de hacer ese proceso con todas las columnas, pusimos todas las columnas con su tipo de dato correcto. Otra consideración importante fue que al descargar los datos existía una columna con los índices de cada fila, la cual era totalmente innecesaria para nuestro análisis, por lo cual la eliminamos. Esto sirvió tanto para poder cargar los datos (pues esa columna no tenía originalmente nombre y generaba problemas) como porque no nos da ninguna información relevante. 


### Estructura del repositorio

    ├── README.md                                         <- Documentación para desarrolladores de este proyecto (i.e., reporte escrito)
    ├── data
    │   ├── .gitignore
    │   └── raw_data_creation_and_load.sql                                  <-  Script de carga inicial
    │
    ├── pipeline_scripts                                  <- Scripts de SQL para ejecución del pipeline de datos
    │   ├── 01_raw_data_schema_creation_and_load.sql      <- Script de carga inicial (i.e., actividad B)
    │   ├── 02_data_cleaning.sql                          <- Script de limpieza de datos (i.e., actividad C)
    │   ├── 03_data_normalization.sql                     <- Script de normalización de relaciones (i.e., actividad D)
    │   └── 04_analytical_attributes_creation.sql         <- Script de creación de atributos analíticos (i.e., actividad E)
    │
    └── exploration_queries                               <- Scripts de SQL para exploración de datos
        ├── 01_raw_data_exploration.sql                   <- Consultas de exploración de datos en bruto (i.e., soporte de actividad B)
        ├── ...                                           <- Otras consultas en caso de ser requeridas
        └── 0N_analytical_queries.sql                     <- Consultas de interés sobre los datos normalizados (i.e., soporte de actividad E)

  
## Requerimientos para replicación del proyecto

1. Descargar los datos en bruto del proyecto de acuerdo a las instrucciones del apartado de [Fuente de datos](#fuente-de-datos).
2. Contar con 'postgres 16' o superior instalado en la computadora o servidor donde se replicará el proyecto.
3. Contar con una base de datos exclusiva para este proyecto. Todas las instrucciones del proyecto asumen que la sesión está conectada a la misma base de datos.
4. ...
5. El resto de las instrucciones asumen que el directorio de trabajo para `psql` es la raíz de este proyecto.

## Carga inicial

Dentro de psql:

1. Creación y conexión de la base de datos: <br>
```
CREATE DATABASE casoscovid2021;
```
Después: 
```
\c casoscovid2021;
```
2. Creación del esquema: <br>
Vamos a incluir el script de creación del esquema (aquí se incluye el path absoluto de la ubicación): 
```
\i '.../data/raw_data_creation_and_load.sql'
```
3. Ingesta de datos en el esquema. Se debe cambiar el FROM con la base de datos descargados<br>
```
\copy raw.casoscovid2021(columna,fecha_actualizacion,id_registro,origen,sector,entidad_um,sexo,entidad_nac,entidad_res,municipio_res,tipo_paciente,fecha_ingreso,fecha_sintomas,fecha_def,intubado,neumonia,edad,nacionalidad,embarazo,habla_lengua_indig,indigena,diabetes,epoc,asma,inmusupr,hipertension,otra_com,cardiovascular,obesidad,renal_cronica,tabaquismo,otro_caso,toma_muestra_lab,resultado_lab,toma_muestra_antigeno,resultado_antigeno,clasificacion_final,migrante,pais_nacionalidad,pais_origen,uci) FROM '.../casos_nacionales_covid-19_2022_semestre2.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',', ENCODING 'LATIN1');
```
Se deberán cargar  1745431 registros

> Esta es una buena sección para documentar los hallazgos del inciso B:
> Carga inicial y análisis preliminar.

## Limpieza de datos

Lo primero que hicimos fue transformar todas las columnas a su tipo de datos correspondiente pues para cargarlos originalmente cargamos todos los datos como tipo text, eso fue así pues varias columnas tenían NA como valor, por lo que volvimos NULLS esos valores y posteriormente los cambiamos. 

Eliminamos 4 columnas que considerabamos irrelevantes para nuestro análisis: 
- toma_muestra_lab
- toma_muestra_antigeno
- otro_caso
- habla_lengua_indigena

toma_muestra_lab y toma_muestra_antigeno las eliminamos pues nos daba información ya existente con las columnas resultado_antigeno y resultado_lab, nos dimos cuenta de que el resultado aparecia como No aplica en los casos que no habia muestra y en todos los demas casos decia sí y como la información que nos interesa es el resultado podemos quitar esas columnas.

habla_lengua_indigena lo eliminamos pues ya teníamos la columna indigena y otro caso no lo consideramos pues no lo consideramos relevante para nuestro análisis.

Después checamos si había inconsistencias con los datos, con lo cual nos dimos cuenta de que había registros con personas que habían fallecido antes de sentir síntomas o antes de ingresar al hospital, lo cual no tenía sentido, por lo que eliminamos esos registros.


> Valores únicos
En nuestro caso que tenemos muchos atributos, no analizaremos por cada uno los que tienen o no valores únicos, porque además es demasiado intuitivo los que claramente no serán valores únicos. De esta manera, los atributos que más probablemente tenga valores únicos, es id_registro. Lo comprobaremos. 

> Tipos de datos
En la carga inicial introducimos todos los datos de las columnas con tipo de datos TEXT, ya que era el único compatible en todos los casos, así que empezaremos por modificar los que explícitamente no corresponden a text. 
* En fechas, la única nulleable fue fecha_def pues no en todos los casos los pacientes murieron


## Normalización

La normalización se realiza también mediante la estrategia de refresh destructivo. Para ejecutar el proceso de
normalización se puede emplear el siguiente comando en `psql`:

```{psql}
\i pipeline_scripts/03_data_normalization.sql
```

>  Aquí es una buena sección para documentar la descomposición intuitiva de las tablas.
> También un ERD del diseño final debe ser incluido.
