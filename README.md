---


# Proyecto BD: Casos Nacionales 2° Semestre 2022

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

> Esta es una buena sección para el el inciso A: Introducción al conjunto de datos y al
> problema a estudiar considerando aspectos éticos del conjunto de datos empleado.


- Descripción general de los datos
- ¿Quién los recolecta?
- ¿Cuál es el propósito de su recolección?
- ¿Dónde se pueden obtener?
- ¿Con qué frecuencia se actualizan?
- ¿Cuántas tuplas y cuántos atributos tiene el set de datos?
- ¿Qué significa cada atributo del set?
- ¿Qué atributos son numéricos?
- ¿Qué atributos son categóricos?
- ¿Qué atributos son de tipo texto?
- ¿Qué atributos son de tipo temporal y/o fecha?
- ¿Cuál es el objetivo buscado con el set de datos? ¿Para qué se usará por el equipo?
- ¿Qué consideraciones éticas conlleva el análisis y explotación de dichos datos?
  
## Descripción del Proyecto 
* El set de datos lo obtuvimos del censo de población y vivienda del INEGI realizado en 2020. La INEGI hace la encuesta para contar con información de las carecterísticas demográficas, socioeconómicas y de vivienda de la población para poder crear planes y proyectos que beneficien su calidad de vida. Los datos del censo se actualizan cada 10 años. Obtuvimos los datos de https://www.inegi.org.mx/app/scitel/Default?ev=9. La base de datos contiene 20 atributos y ??? registros. Los atributos de entidad federativa (NOM_ENT), nombre del municipio (NOM_MUN) y nombre de la localidad (NOM_LOC) son los únicos que son de texto. Todos los demás atributos son númericos. Nuestro objetivo con estos datos es ver las diferencias de acceso a la salud y servicios básicos disponibles por edad, ocupación y zona geográfica. Lo usaremos para definir que entidades necesitan reforzar su acceso a la salud por la nueva epidemia de sarampión.
* Dentro del proyecto consideramos solo ciertas entidades del país en el area metropolitana para evitar la menor cantidad de sesgos en las cifras reportadas, pues en otros estados donde puede haber ciertas comunidades no cuantificadas.
El equipo debe detallar qué actividades de limpieza se deben efectuar al set de datos para su uso, siempre teniendo en mente el objetivo planteado para el proyecto. En el README se debe incluir una sección con las actividades realizadas, explicar cualquier operación no trivial usada y explicar por qué fue necesaria dicha actividad de limpieza.
Además se debe tener en el repositorio al menos un script para efectuar la limpieza con los datos en bruto.
## Fuente de datos

Para este proyecto se utilizan los datos proporcionados por el portal de datos de Chicago sobre inspecciones a restaurantes. Se puede acceder a los datos en [este link](#).

Las instrucciones de replicación del proyecto asumen que los datos se encuentran almacenados en formato CSV bajo el nombre `./data/raw_data.csv`.

## Documentación

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
