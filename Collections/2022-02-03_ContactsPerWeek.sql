WITH MORA_EXTRACT AS (
SELECT C.Contrato AS CONTRATO_ID
   , DATE_TRUNC(C.FECHA_ASIGNACION, MONTH) AS MES_ASIGNACION
    ,DATE_TRUNC(G.EFECTIVA_MES_FECHA, MONTH) AS MES_REPORTE
    , CASE 
      WHEN G.CONTRATO IS NULL THEN DATE_DIFF(C.FECHA_ASIGNACION, C.FECHA_FACTURA, DAY)
      WHEN G.CONTRATO IS NOT NULL THEN  DATE_DIFF(G.EFECTIVA_MES_FECHA, C.FECHA_FACTURA, DAY) END AS MORA
FROM `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-01-13_CR_COLLECTIONS_TOTAL_2021-01_A_2021-11_D` C
LEFT JOIN `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-01-24_CR_REPORTE_GESTION_UNICAS_CLEAN_2021_D` G
ON C.CONTRATO = G.CONTRATO AND DATE_TRUNC(G.EFECTIVA_MES_FECHA, MONTH) = DATE_TRUNC(C.FECHA_ASIGNACION, MONTH)
WHERE C.TIPO_CLIENTE = "B2C"
    AND C.ASIGNACION <> "IVR"
)
, MORA_GROUP AS (
SELECT 
    CONTRATO_ID
    , CASE
        WHEN ME.MORA BETWEEN 0 AND 20 THEN '1. SIN_MORA' 
        WHEN ME.MORA BETWEEN 21 AND 29 THEN '2. 21-29 DIAS'
        WHEN ME.MORA BETWEEN 30 AND 35 THEN '3. 30-35 DIAS'
        WHEN ME.MORA BETWEEN 36 AND 40 THEN '4. 36-40 DIAS'
        WHEN ME.MORA BETWEEN 41 AND 50 THEN '5. 41-50 DIAS'
        WHEN ME.MORA BETWEEN 51 AND 60 THEN '6. 51-60 DIAS'
        WHEN ME.MORA BETWEEN 61 AND 75 THEN '7. 61-75 DIAS'
        WHEN ME.MORA BETWEEN 76 AND 90 THEN '8. 76-90 DIAS'
        ELSE '9. +91 DIAS'
    END BUCKET_MORA
    , ME.MES_ASIGNACION
FROM MORA_EXTRACT AS ME
)
, GISSA_MES AS (
SELECT DATE_TRUNC(R.EFECTIVA_MES_FECHA, MONTH) AS MES_REPORTE
    , R.CONTRATO
FROM `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-01-24_CR_REPORTE_GESTION_UNICAS_CLEAN_2021_D` R
WHERE NOT(R.EFECTIVA_MES_DETALLE LIKE '%Masivo%')
    AND R.EFECTIVA_MES_DETALLE IN (
        'Cliente no va pagar',
'Cliente no va pagar - Otro',
'Cliente no va pagar - Fuera del país',
'Cliente no va pagar - Enfermedad',
'Cliente no va pagar - Por competencia',
'Recordatorio de Pago',
'Cliente no va pagar - Está en la cárcel',
'Cliente no va pagar - Problema Judicial - Pensión',
'Suspendido',
'Ya canceló',
'Cliente no va pagar - La deuda es de un tercero',
'Sin acuerdo por WhatsApp',
'Cliente no va pagar - Tiene muchas deudas',
'Sin acuerdo por Correo Electronico',
'Cliente no va pagar - Problemas con el servicio',
'Cliente no va pagar - A causa de COVID-19',
'Cliente no va pagar - No tiene trabajo',
'Cliente no va pagar - Insatisfacción con SAC',
'Cliente no va pagar - Insatisfacción con CLIENTE',
'Cliente Reporta Pago',
'Cliente no va pagar - Pendiente de anulación',
'Fallecido',
'Seguimiento de pago',
'Promesa de Pago'
    )
)
SELECT MG.MES_ASIGNACION 
    , MG.BUCKET_MORA 
    , COUNT(CASE WHEN GI.CONTRATO IS NOT NULL THEN MG.CONTRATO_ID END) AS CONTRATOS_CONTACTADOS
    , COUNT(DISTINCT MG.CONTRATO_ID) AS CONTRATOS_TOTALES
    , (ROUND(
        COUNT(CASE WHEN GI.CONTRATO IS NOT NULL THEN MG.CONTRATO_ID END) 
        / NULLIF(COUNT(DISTINCT MG.CONTRATO_ID), 0)
        , 2)
    )/4 AS RATIO
FROM MORA_GROUP AS MG
     LEFT JOIN GISSA_MES AS GI
        ON MG.CONTRATO_ID = GI.CONTRATO AND MG.MES_ASIGNACION = GI.MES_REPORTE
GROUP BY 1,2
ORDER BY 1,2
;
