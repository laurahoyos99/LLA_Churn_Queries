WITH CHURNERSSO AS
(SELECT DISTINCT RIGHT(CONCAT('0000000000',NOMBRE_CONTRATO) ,10) AS CONTRATOSO, FECHA_APERTURA,
CASE WHEN SUBMOTIVO = "MOROSIDAD" THEN RIGHT(CONCAT('0000000000',NOMBRE_CONTRATO) ,10) END AS INVOLUNTARIO,
CASE WHEN SUBMOTIVO <> "MOROSIDAD" THEN RIGHT(CONCAT('0000000000',NOMBRE_CONTRATO) ,10) END AS VOLUNTARIO
 FROM `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-01-12_CR_ORDENES_SERVICIO_2021-01_A_2021-11_D`
 WHERE
  TIPO_ORDEN = "DESINSTALACION" 
  AND (ESTADO <> "CANCELADA" OR ESTADO <> "ANULADA")
 AND FECHA_APERTURA IS NOT NULL
 ),
CHURNERSCRM AS(
  SELECT DISTINCT RIGHT(CONCAT('0000000000',ACT_ACCT_CD) ,10) AS CONTRATOCRM, MAX(DATE(CST_CHRN_DT)) AS Maxfecha,Extract(Month from Max(CST_CHRN_DT)) AS MesChurnF
    FROM `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-02-16_FINAL_HISTORIC_CRM_FILE_2021_D`
    GROUP BY ACT_ACCT_CD
    HAVING EXTRACT (MONTH FROM Maxfecha) = EXTRACT (MONTH FROM MAX(FECHA_EXTRACCION))
),
FIRSTCHURN AS(
 SELECT DISTINCT RIGHT(CONCAT('0000000000',ACT_ACCT_CD) ,10) AS CONTRATOPCHURN, Min(DATE(CST_CHRN_DT)) AS PrimerChurn, Extract(Month from Min(CST_CHRN_DT)) AS MesChurnP
    FROM  `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-02-16_FINAL_HISTORIC_CRM_FILE_2021_D`
    GROUP BY ACT_ACCT_CD
    HAVING EXTRACT (YEAR FROM PrimerChurn) = 2021
),
REALCHURNERS AS(
 SELECT DISTINCT CONTRATOCRM AS CHURNER, MaxFecha, PrimerChurn, MesChurnF, MesChurnP
 FROM CHURNERSCRM c  INNER JOIN FIRSTCHURN f ON c.CONTRATOCRM = f.CONTRATOPCHURN AND f.PrimerChurn <= c.MaxFecha
   GROUP BY CHURNER, MaxFecha, PrimerChurn, MesChurnF, MesChurnP),

CRUCECHURNERS AS(
SELECT CONTRATOSO, CHURNER, VOLUNTARIO, INVOLUNTARIO, EXTRACT (MONTH FROM c.Maxfecha) AS MesC, 
EXTRACT(MONTH FROM s.FECHA_APERTURA ) AS MesS
FROM REALCHURNERS c LEFT JOIN CHURNERSSO s ON CONTRATOSO = CHURNER
AND c.PrimerChurn >= s.FECHA_APERTURA AND date_diff(c.PrimerChurn, s.FECHA_APERTURA, MONTH) <= 3
GROUP BY contratoso, CHURNER, MesC, MesS, VOLUNTARIO, INVOLUNTARIO
)
SELECT
 c.MesC
 , count(distinct CHURNER) as ChurnersCRM, Count(distinct contratoso) AS ChurnersJoinSO, Count (distinct voluntario) as Voluntarios, count (distinct involuntario) as Involuntarios
FROM CRUCECHURNERS c
GROUP BY c.MesC
Order by c.MesC