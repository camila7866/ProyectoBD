conda install psycopg2
import psycopg2
import pandas as pd

conn = psycopg2.connect(
    host="localhost",
    database="tu_database",
    user="usuario",
    password="tu_contraseña"
)

query = """
SELECT residencia.entidad_res, COUNT(*)
FROM raw.residencia 
LEFT JOIN raw.persona ON 
persona.residencia_id = residencia.id
LEFT JOIN raw.paciente ON 
paciente.persona_id = persona.id 
LEFT JOIN raw.resultado ON 
resultado.paciente_id = paciente.id
WHERE raw.resultado.clasificacion_final IN ('CASO DE SARS-COV-2  CONFIRMADO', 'CASO DE COVID-19 CONFIRMADO POR COMITÉ DE  DICTAMINACIÓN', 'CASO DE COVID-19 CONFIRMADO POR ASOCIACIÓN CLÍNICA EPIDEMIOLÓGICA')
GROUP BY raw.residencia.entidad_res;
"""

df_sql = pd.read_sql(query, conn)

mexico_municipios["NOM_ENT"] = (
    mexico_municipios["NOM_ENT"]
    .str.upper()
)

df_sql["entidad_res"] = (
    df_sql["entidad_res"]
    .str.upper()
)

import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(18,18))

mexico_municipios.plot(
    ax=ax,
    color="#f5f5f5",
    edgecolor="black",
    linewidth=0.15
)

mapa.plot(
    column="count",
    cmap="Reds",
    legend=True,
    legend_kwds={
        "shrink": 0.4   # hace más pequeña la barra
    },
    ax=ax,
    edgecolor="black",
    linewidth=0.3
)

ax.set_axis_off()

plt.savefig(
    "mapa_mexico.png",
    dpi=300,
    bbox_inches="tight"
)


plt.show()
