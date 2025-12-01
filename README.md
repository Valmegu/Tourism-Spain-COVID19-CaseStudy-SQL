# 🏖️ Impact of COVID-19 on Tourism in Spain — Case Study

![Data Analysis](https://img.shields.io/badge/Type-Data%20Analysis-green)
![SQLite](https://img.shields.io/badge/Made%20with-SQLite-blue)
![status](https://img.shields.io/badge/Status-In%20Progress-yellow)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

**Autor:** Valeria Medina  
**Herramientas:** SQL · Power BI · Excel  
**Fuente de datos:** Instituto Nacional de Estadística (INE) – Estadísticas de Movimientos Turísticos (FRONTUR)

---
##Estructura de datos del proyecto

```
project
│
├── data
│   ├── datos_INE_raw
│   │   └── turistas_x_comunidad_destino.csv
│   │
│   └── datos_INE_limpios
│        └── turistas_x_comunidad_destino.csv
│
├──sql
|  └── exploratory-analysis.sql
│         
|
├── LICENSE
└── README.md
```
---

## Estado del proyecto ‖ Updates
**En desarrollo:**  
- [x] Crear proyecto ‖ 27/11/25 - Proyecto creado (estructura inicial)
- [x] [Diseño de preguntas](https://github.com/Valmegu/Tourism-Spain-COVID19-CaseStudy-SQL/tree/main#descripci%C3%B3n-de-los-datos)‖ 28/11/25 - Definir datasets a usar, redactar pregunta inicial y objetivos
- [x] [Descripción de los datos](https://github.com/Valmegu/Tourism-Spain-COVID19-CaseStudy-SQL/tree/main#descripci%C3%B3n-de-los-datos) ‖ 28/11/25 - Describir origen de los datos
- [x] [Limpieza y estructura en Excel](https://github.com/Valmegu/Tourism-Spain-COVID19-CaseStudy-SQL/blob/main/README.md#preparaci%C3%B3n-y-limpieza-de-datos) ‖ 29/11/25 - Limpieza inicial en Excel
- [x] [Comprobación de datos](https://github.com/Valmegu/Tourism-Spain-COVID19-CaseStudy-SQL/blob/main/README.md#comprobaci%C3%B3n-de-datos) ‖ 01/12/25 - Combrobaciones previas al análisis
- [ ] Consultas SQL
- [ ] Dashboard en Power BI  
- [ ] Conclusiones finales

---

## Descripción 

Este proyecto personal tiene como objetivo practicar habilidades de análisis de datos, SQL y storytelling.  
A partir de los datos oficiales del Instituto Nacional de Estadística analizamos cómo la pandemia de **COVID-19 afectó al turismo en España** durante 2020 y cómo ha sido su proceso de recuperación.

El objetivo final es **medir la magnitud del descenso de turistas** y **determinar si en 2024 el país ya ha recuperado o superado los niveles previos a la pandemia**.

---

## Preguntas clave

### 1. ¿Qué tan fuerte fue la caída en 2020 comparado con 2019?
- Caída absoluta  
- Caída porcentual  
- Caída por comunidad  

### 2. ¿En qué año comenzó la recuperación real (2021–2024)?
- Crecimiento YoY  
- Comparación entre regiones  

### 3. ¿En 2024 el turismo ya superó los niveles de 2019?
- Total nacional  
- Ranking por comunidad  
- Cuota del turismo nacional  

### 4. ¿Qué comunidades muestran la recuperación más rápida?

---

## Descripción de los datos

Para este análisis Usaremos los datasets proporcionados por el Instituto Nacional de Estadística (INE) relacionadOs con el movimiento turístico y la actividad hotelera.

[Estadística de movimientos turísticos en frontera](https://www.ine.es/dyngs/INEbase/operacion.htm?c=Estadistica_C&cid=1254736176996&menu=ultiDatos&idp=1254735576863)
  - Número de turistas según comunidad autónoma de destino principal
  - Número de turistas según país de residencia

[Coyuntura Turística Hotelera (EOH/IPH/IRSH)](https://www.ine.es/dyngs/INEbase/operacion.htm?c=Estadistica_C&cid=1254736177015&menu=ultiDatos&idp=1254735576863)
  - Viajeros, pernoctaciones por tipo de alojamiento por comunidades y ciudades autónomas

Al usar diferentes datasets para este proyecto, establecemos una prioridad entre cada tabla, se determinó que el orden de importancia es el siguiente:
  - Tabla 1 — Turistas por comunidad autónoma\
Se compone de:
      - Comunidades autónomas
      - Tipo de dato
         - Dato base
         - Tasa de variación anual
      - Periodo (año)
      - Total (Total de turistar registrados)

  - Tabla 2 — (opcional) Ocupación hotelera por comunidad
  - Tabla 3 — (opcional) Turistas por país de procedencia

El objetivo es consolidar estas tablas en un modelo analítico que permita medir el impacto del COVID-19 en el sector turístico español de forma consistente y comparable.

---

## Preparación y Limpieza de datos
### Turistas por comunidad autónoma:

Nos centraremos en el usos de datos de los últimos 4 años, por comunidad autónoma y datos base. 
> [!NOTE]
> Las estimaciones por comunidad autónoma no tienen porqué coincidir con el total nacional, ya que el INE utiliza procedimientos estadísticos independientes para cada nivel territorial. Yo utilicé la suma de los totales por comunidad como proxy para el total nacional.

La limpieza inicial se realizó en Excel para:

1. Filtrar solo registros con Tipo de dato “Dato Base”\
Eliminamos datos de tipo "Variación anual"
2. Eliminar datos fuera de rango (2019 a 2024)\
De decartan valores anteriores y posteriores
3. Eliminar los totales nacionales (“Total”)\
Para evitar duplicidades y mantener consistencia a nivel regional.
4. Normalizar valores numéricos
   - Eliminar puntos de miles
   - Eliminar comas innecesarias
   - Convertir el campo Total a número entero
   - Convertir celdas vacías ('') en valores nulos (NULL)
5. Estandarizar los nombres de columnas\
(Comunidad, Periodo, Turistas, etc.)
6. Extraer código por comunidad\
No es obligatorio para este análisis, pero útil para posibles integraciones (hotelera, procedencia).
7. Guardar el dataset final como CSV UTF-8\
Para importarlo sin problemas a SQLite/DBeaver.

---

## Comprobación de datos

Antes de empezar a respoder las preguntas iniciales, se hace una última comprobación con SQL.
Se crea un dataset denominado turistas_comunidad_clean, en el que volvemos a comprobar que los valores estén en el formato necesario para realizar el análisis.
El archivo SQL utilizado se encuentra en la carpeta sql bajo el nombre de exploratory_analysis.sql

### Resultados

| Validación                   | Resultado                                      |
| ---------------------------- | ---------------------------------------------- |
| Cantidad total de filas      | **114**                                        |
| Total de comunidades         | **19** (17 CCAA + 2 ciudades autónomas)        |
| Rango de años                | **2019–2024** (6 años)                         |
| Registros esperados (19 × 6) | **114** → Todo correcto                        |
| Valores nulos o vacíos       | **4 registros** (Ceuta y Melilla en 2019–2020) |

### Valores Faltantes

|Periodo|Comunidad|Turistas |
| ------|---------|-------- |
|2019   |Ceuta    |**0**    |
|2019   |Melilla  |**0**    |
|2020   |Ceuta    |**0**    |
|2020   |Melilla  |**0**    |

Debido a que Ceuta y Melilla no cuentan con datos para 2019 y 2020, no será posible incluirlas en los análisis comparativos (caída 2020, recuperación vs 2019, etc.). Se mantienen en el dataset por transparencia, pero se excluyen en los cálculos que lo requieren.

