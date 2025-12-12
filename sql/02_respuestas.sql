-- =============================================================================
-- Archivo: 02_respuestas.sql
-- Proyecto: Analisis_Turismo_ES
-- Autor: Valme
-- Fecha: 2025-12-11
-- Propósito: Queries SQL que generan las respuestas del análisis (P1..P4)
-- Dependencias: tabla turistas_comunidad_clean
-- Notas: Ejecutar en el orden indicado. No contiene datos personales.
-- =============================================================================

-- PREGUNTAS DE ANÁLISIS: 

-- Pregunta 1 ¿Qué tan fuerte fue la caída en 2020 comparado con 2019?

--- Caída absoluta
----Vamos a hacer una comparativa, el resultado debe ser por comunidad, 2019, 2020, (2020-2019)
SELECT
	c.comunidad,
	y2019.turistas  AS turistas_2019,
	y2020.turistas AS turistas_2020,
	(y2020.turistas - y2019.turistas ) AS caida
FROM 
	(SELECT DISTINCT comunidad FROM turistas_comunidad_clean) c
LEFT JOIN turistas_comunidad_clean y2019
	ON y2019.comunidad = c.comunidad AND y2019.periodo = 2019
LEFT JOIN turistas_comunidad_clean  y2020
	ON y2020.comunidad = c.comunidad  AND y2020.periodo = 2020
WHERE y2019.turistas <> 0 -- TOP PERDEDORES: CATALUNNA, ISLAS BALEARES, CANARIAS ANDALUCIA, CV Y MADRID
ORDER BY caida ASC 


--- Caída porcentual
---- Calculamos de cuanto % fue la caida según la comunidad, veremos los verdaderos perdedores
SELECT
	c.comunidad,
	y2019.turistas  AS turistas_2019,
	y2020.turistas AS turistas_2020,
	ROUND(((y2020.turistas - y2019.turistas) * 100) / y2019.turistas, 2)  AS caida
FROM 
	(SELECT DISTINCT comunidad FROM turistas_comunidad_clean) c
LEFT JOIN turistas_comunidad_clean y2019
	ON y2019.comunidad = c.comunidad AND y2019.periodo = 2019
LEFT JOIN turistas_comunidad_clean  y2020
	ON y2020.comunidad = c.comunidad  AND y2020.periodo = 2020
WHERE y2019.turistas <> 0
ORDER BY caida ASC -- TOP PERDEDORES: ISLAS BALEARES, CATALUNNA, MADRID, ANDALUCIA, MURCIA


--- Caída por comunidad 

---- Calculamos el % de caida de cada cominidad. Datos usados en POWER BI

SELECT
	c.comunidad,
	y2019.turistas  AS turistas_2019,
	y2020.turistas AS turistas_2020,
	(y2020.turistas - y2019.turistas ) AS caida_absoluta, -- Caida absoluta
	ROUND(((y2020.turistas - y2019.turistas ) * 100) / y2019.turistas, 2)  AS caida_porcentual -- caida porcentual
FROM 
	(SELECT DISTINCT comunidad FROM turistas_comunidad_clean) c
LEFT JOIN turistas_comunidad_clean y2019
	ON y2019.comunidad = c.comunidad AND y2019.periodo = 2019
LEFT JOIN turistas_comunidad_clean  y2020
	ON y2020.comunidad = c.comunidad  AND y2020.periodo = 2020
WHERE y2019.turistas <> 0 -- TOP PERDEDORES: CATALUNNA, ISLAS BALEARES, CANARIAS ANDALUCIA, CV Y MADRID
ORDER BY caida_porcentual  ASC 

---------------------------------------------------------------------------------------------------------------------------------------------------

-- Pregunta 2: ¿En qué año comenzó la recuperación real (2021–2024)?

--- Crecimiento YOY
---- SUMA DE TOTALES POR PERIODOS

SELECT
	t.periodo,
	sum(t.turistas) AS total_turistas
FROM turistas_comunidad_clean t
GROUP BY t.periodo;

--- Comparación comunidad autónoma (2024 vs 2019)
---- Vamos a responder esta pregunta creando 2 vistas: Indices y Resumen
----- 1. Indices: Nos ostrará la evolución histórica por comunidad de la cantidad de turistas desde el 2019 hasta el 2024

DROP VIEW IF EXISTS v_indices; --Eliminará la vista Indices si ya existe

CREATE VIEW v_indices AS --CREA V_INDICES DE NUEVO Y LA DEFINE
WITH base2019 AS ( ---1RA TABLA: VALOR BASE DE 2019, SE USARÁ PARA COMPARAR EL RESTO DE PERIODOS, ES EL VALOR "IDEAL"
	SELECT 
		comunidad, 
		turistas AS turistas_2019
	FROM turistas_comunidad_clean
	WHERE periodo = 2019
),
with_prev AS ( --VALOR DEL AÑO ANTERIOR: RECUPERA LOS DATOS DEL AÑO ANTERIOR POR COMUNIDAD
	SELECT 
		t.*,
		LAG(t.turistas) OVER (PARTITION BY t.comunidad ORDER By t.periodo) AS turistas_prev
	FROM turistas_comunidad_clean t
)
SELECT --ESTE ES EL SELECT PRINCIPAL DE V_INDICES. AQUI TERMINAREMOS LOS CÁLCULOS
	wp.comunidad,
	wp.periodo,
	wp.turistas,
	wp.turistas_prev,
	CASE  --Calulará el crecimiento o decrecimiento de la cantidad de turistas con respecto al año anterior
		WHEN wp.turistas_prev IS NULL OR wp.turistas_prev = 0 THEN NULL
		ELSE ROUND((wp.turistas - wp.turistas_prev) * 100.0 / wp.turistas_prev, 2)
  	END AS porc_vs_ant,
  	b.turistas_2019,
  	CASE --ESTO NOS DA UN INDICE DE RECUPERACIÓN CON RESPECTO A EL 2019, 100 = RECUPERADO
    	WHEN b.turistas_2019 IS NULL OR b.turistas_2019 = 0 OR wp.periodo = 2019 THEN NULL
    	ELSE ROUND((CAST(wp.turistas AS REAL) / b.turistas_2019) * 100, 2)
  	END AS index_vs_2019_pct
FROM with_prev wp
LEFT JOIN base2019 b ON b.comunidad = wp.comunidad;

SELECT * FROM v_indices ORDER BY comunidad, periodo; --Esto hace visible la tabla!

----- 2.Resumen: Tiene como objetivo darnos un resumen por comunidad de cuando logran recuperarse y mostrar la diferencia entre ambas
----- Tomamos estos resultados para hacer el gráfico en POWER BI

DROP VIEW IF EXISTS v_resumen; -- BORRA SI YA EXISTE

CREATE VIEW v_resumen AS --CREAMOS LA VISTA RESUMEN RECUPERANDO TODOS LOS DATOS DE v_indices
WITH datos 
	AS (
		SELECT 
			* 
		FROM v_indices
	)
SELECT
	comunidad,
	-- Primer año con crecimiento interanual positivo
  MIN(CASE WHEN porc_vs_ant > 0 THEN periodo END) AS periodo_positivo,
  -- Primer año que supera 2019 (excluyendo 2019 para evitar falsos positivos)
  MIN(CASE 
        WHEN index_vs_2019_pct >= 100 
             AND periodo > 2019 THEN periodo 
      END) AS mas_que_2019,
  --Porcentaje de recuperación. 100% = Turistas registrados en el 2019
  MAX(CASE WHEN periodo = 2024 THEN index_vs_2019_pct END) AS porcentaje_recuperacion,
  --Resumir estado según porcentaje de recuperación como Recuperado(>= 100%) o No recuperado (<100%)
  CASE
    WHEN MAX(CASE WHEN periodo = 2024 THEN index_vs_2019_pct END) IS NULL 
      THEN 'SIN DATOS'
    WHEN MAX(CASE WHEN periodo = 2024 THEN index_vs_2019_pct END) >= 100 
      THEN 'RECUPERADO'
    ELSE 'NO RECUPERADO'
  END AS estado_actual,
  ROUND(index_vs_2019_pct, 2) AS index_2024_num,
  ROUND(index_vs_2019_pct / 100.0, 4) AS index_2024_ratio
FROM datos
GROUP BY comunidad
ORDER BY estado_actual, porcentaje_recuperacion;

SELECT * FROM v_resumen; --MUESTRA NUESTROS DATOS RESUMEN

---------------------------------------------------------------------------------------------------------------------------------------------------

-- Pregunta 3: ¿Cómo quedó distribuido el turismo español en 2024 comparado con 2019?
--- Vamos a calcular como ha variado la cuota nacional de turistas con respecto al 2019 y destacar cómo ha crecido o reducido la cuota de cada comunidad 

SELECT 
    comunidad,
    SUM(CASE WHEN periodo = 2019 THEN turistas END) AS turistas_2019,
    SUM(CASE WHEN periodo = 2024 THEN turistas END) AS turistas_2024,
    ROUND(SUM(CASE WHEN periodo = 2019 THEN turistas END) * 1.0 / (SELECT SUM(turistas) FROM turistas_comunidad_clean WHERE periodo = 2019) * 100, 2) AS pct_2019,
    ROUND(SUM(CASE WHEN periodo = 2024 THEN turistas END) * 1.0 / (SELECT SUM(turistas) FROM turistas_comunidad_clean WHERE periodo = 2024) * 100, 2) AS pct_2024,
    ROUND(SUM(CASE WHEN periodo = 2024 THEN turistas END) * 1.0 / 
    	(SELECT SUM(turistas) FROM turistas_comunidad_clean WHERE periodo = 2024) * 100, 2) 
    		- ROUND(SUM(CASE WHEN periodo = 2019 THEN turistas END) * 1.0 / 
    			(SELECT SUM(turistas) FROM turistas_comunidad_clean WHERE periodo = 2019) * 100, 2) AS cuota_2024 
FROM turistas_comunidad_clean
GROUP BY comunidad
ORDER BY turistas_2024 DESC;