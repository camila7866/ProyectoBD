---


# Proyecto BD: Casos Nacionales COVID 2° Semestre 2022

## Integrantes

| Nombre Completo | Clave Única | GitHub |
| :--- | :--- | :--- |
| Cristopher Gongora Sanchez Castellanos | 218560 | [cristoredentor](https://github.com/cristoredentor) |
| Sandro Petricioli Gomez | 220971 | [spetricig](https://github.com/spetricig) |
| Yahya Hasen Halem Morales | 219072 | [YahyaHalem](https://github.com/YahyaHalem) |
| Camila Velasco Ortega | 217149 | [camila7866](https://github.com/camila7866) |
| Sofia Velazquez Velazquez | 222048 | [sofivelqz](https://github.com/sofivelqz) |
| Diego Haro Sandoval | | |


## Introducción

* Esta base de datos incluye todos los casos diarios asociados a COVID-19 a nivel federal. Cuenta con contenido desagregado por entidad, sexo, edad, nacionalidad, padecimientos asociados entre otros.
* Este conjunto de datos sólo contempla casos cuyo municipio de residencia sea la Ciudad de México o casos cuya Unidad Médica sea la Ciudad de México.
* La Secretaría de Salud de la Ciudad de México recolecta los datos. 
* La misión principal de la Secretaría es garantizar el derecho efectivo a la salud, y sin discriminación, a los habitantes de la capital así como brindar servicios sanitarios a quienes carecen de seguridad social laboral con el objetivo de que sus habitantes tengan una vida plena y digna.
* La base de datos comprende información correspondiente al periodo del 1 de julio de 2022 al 14 de agosto de 2022. Las actualizaciones diarias se realizaban únicamente a la base del semestre en curso y se elaboró con base en los Datos Abiertos y el Diccionario de Datos provista por el Gobierno Federal. Fue creada el 8 de agosto de 2022 y su última actualización se realizó el 14 de febrero de 2023. 
* Identificar cuáles fueron los potenciales grupos de riesgo en la ciudad de méxico y la 
cantidad de ocurrencias de condiciones críticas para el padecimiento de COVID-19.
* La correlación entre ciertos fenómenos con el caso de covid no implica causalidad y puede estar sesgado a los casos concretos o a poblaciones en riesgo por factores no considerados en la base de datos.

## Fuente de datos

Para este proyecto se utilizan los datos proporcionados por el portal de datos abiertos del Gobierno de la Ciudad de México sobre materia de salud. Se puede acceder a los datos en [Casos Nacionales 2° Semestre 2022](https://datos.cdmx.gob.mx/dataset/casos-asociados-a-covid-19/resource/8deb6e03-eb3c-476e-bb9a-f9eaf6b02a08).

Las instrucciones de replicación del proyecto asumen que los datos se encuentran almacenados en formato CSV bajo el nombre `./data/raw_data.csv`.

## Documentación
> El equipo debe detallar qué actividades de limpieza se deben efectuar al set de datos para su uso, siempre teniendo en mente el objetivo planteado para el proyecto. En el README se debe incluir una sección con las actividades realizadas, explicar cualquier eración no trivial usada y explicar por qué fue necesaria dicha actividad de limpieza.
Además se debe tener en el repositorio al menos un script para efectuar la limpieza
con los datos en bruto.

Para cargar los datos fue necesario poner todas las columnas en tipo text, pues varias columnas tenian NA como atributos. Por lo que lo primero que habra que hacer es cambiar los NA por nulls. Después de hacer ese proceso con todas las columnas ponemos todas las columnas en su tipo de dato correcto


### Estructura del repositorio

    ├── README.md                                         <- Documentación para desarrolladores de este proyecto (i.e., reporte escrito)
    ├── data
    │   ├── .gitignore
    │   └── raw_data.csv                                  <- Datos en formato CSV como vienen de la fuente original
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


> B) Carga inicial y análisis preliminar
Se debe documentar en el repositorio cómo realizar la carga inicial del set de datos a una base de datos de tipo Postgres. Así mismo, se deben agregar los scripts
pertinentes para la creación del esquema inicial de la carga.
También, mediante el uso de consultas SQL, que deben ser incluidas en un script en el repositorio, se deberá realizar un análisis exploratorio de los datos. Algunas
sugerencias son:
- ¿Existen columnas con valores únicos?
- Mínimos y máximos de fechas
- Mínimos, máximos y promedios de valores numéricos
- Duplicados en atributos categóricos
- Columnas redundantes
- Conteo de tuplas por cada categoría
- Conteo de valores nulos
- ¿Existen inconsistencias en el set de datos?

  
## Requerimientos para replicación del proyecto

1. Descargar los datos en bruto del proyecto de acuerdo a las instrucciones del apartado de [Fuente de datos](#fuente-de-datos).
2. Contar con `postgres 16` o superior instalado en la computadora o servidor donde se replicará el proyecto.
3. Contar con una base de datos exclusiva para este proyecto. Todas las instrucciones del proyecto asumen que la sesión está conectada a la misma base de datos.
4. ...
5. El resto de las instrucciones asumen que el directorio de trabajo para `psql` es la raíz de este proyecto.

## Carga inicial

En primer lugar se deberá crear una base de datos exclusiva para este proyecto. Para ello se puede ejecutar el siguiente comando en `psql`:

```sql
CREATE DATABASE inspections;
```

Posteriormente, debemos conectarnos a dicha base de datos empleado:

```sql
\c inspections
```

Finalmente, para cargar los datos en bruto se debe ejecutar el siguiente comando en una sesión de línea de comandos `psql`:
