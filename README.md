# Impact of COVID-19 on Tourism in Spain — Case Study

**Autor:** Valeria Medina  
**Herramientas:** SQL · Power BI · Excel  
**Fuente de datos:** Instituto Nacional de Estadística (INE) – Estadísticas de Movimientos Turísticos (FRONTUR)

--

## 🚧 Estado del proyecto
**En desarrollo:**  
- [x] Diseño de preguntas
- [x] Descripción de lo datos
- [ ] Limpieza y estructura en Excel
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

> **1. ¿Qué tan fuerte fue la caída en 2020 comparado con 2019?**
>>- *Caída absoluta*
>>- *Caída porcentual*
>>- *Caída por comunidad*


>**2. ¿En qué año comenzó la recuperación real (2021–2024)?**
>>- *Crecimiento YoY*
>>- *Comparación entre regiones*


>**3. ¿En 2024 el turismo ya superó los niveles de 2019?**
>>- *Total nacional*
>>- *Ranking por comunidad*
>>- *Cuota del turismo nacional*

> **4. Qué comunidades muestran la recuperación más rápida?**

---

## Descripción de lo datos

Usaremos los datasets proporcionados por el Instituto Nacional de Estadística relativos a servicios y hostelería.

[Estadística de movimientos turísticos en frontera](https://www.ine.es/dyngs/INEbase/operacion.htm?c=Estadistica_C&cid=1254736176996&menu=ultiDatos&idp=1254735576863)
  - Número de turistas según comunidad autónoma de destino principal
  - Número de turistas según país de residencia

[Coyuntura Turística Hotelera (EOH/IPH/IRSH)](https://www.ine.es/dyngs/INEbase/operacion.htm?c=Estadistica_C&cid=1254736177015&menu=ultiDatos&idp=1254735576863)
  - Viajeros, pernoctaciones por tipo de alojamiento por comunidades y ciudades autónomas

Al usar diferentes datasets para este proyecto, establecemos una prioridad entre cada tabla, se determinó que el orden de importancia es el siguiente:
  - Tabla 1 — Turistas por comunidad autónoma
  - Tabla 2 — (opcional) Ocupación hotelera por comunidad
  - Tabla 3 — (opcional) Turistas por país de procedencia


