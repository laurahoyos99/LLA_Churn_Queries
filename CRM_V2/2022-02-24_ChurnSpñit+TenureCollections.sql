WITH CHURNERSCRM AS(
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

MOROSOSCRM AS(
    SELECT DISTINCT RIGHT(CONCAT('0000000000',CONTRATO) ,10) AS CONTRATO, FECHA_FACTURA, TIPO_SERVICIO
    FROM `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-01-13_CR_COLLECTIONS_TOTAL_2021-01_A_2021-11_D`
    WHERE TIPO_SERVICIO IN ('INTERNET', 'FTTH (JASEC)', 'HOGARES CONECTADOS','TELEFONIA','CABLE TICA') AND RANGO_FACTURA <> "1-SIN VENCER"
    GROUP BY CONTRATO, FECHA_FACTURA, TIPO_SERVICIO
),
CRUCECOLLECTIONSCRM AS(
    SELECT DISTINCT CHURNER, CONTRATO, Maxfecha, PrimerChurn
    FROM REALCHURNERS LEFT JOIN MOROSOSCRM ON CHURNER = CONTRATO  AND ((DATE_DIFF (PrimerChurn, FECHA_FACTURA, DAY) >= 60  AND TIPO_SERVICIO IN('INTERNET', 'FTTH (JASEC)'))
    OR (DATE_DIFF (PrimerChurn, FECHA_FACTURA, DAY) >=90 AND TIPO_SERVICIO IN('HOGARES CONECTADOS','TELEFONIA','CABLE TICA')))
    GROUP BY CHURNER, CONTRATO,Maxfecha, PrimerChurn
),
CLASIFICACIONCHURN AS(
    SELECT DISTINCT CHURNER, Maxfecha, PrimerChurn,
    CASE WHEN CONTRATO IS NULL THEN CHURNER END AS VOLUNTARIO,
    CASE WHEN CONTRATO IS NOT NULL THEN CHURNER END AS INVOLUNTARIO
    FROM CRUCECOLLECTIONSCRM
    GROUP BY CHURNER, MAXFECHA, PrimerChurn, VOLUNTARIO, INVOLUNTARIO
),
TENURECHURNERS AS(
 SELECT DISTINCT RIGHT(CONCAT('0000000000',ACT_ACCT_CD) ,10) AS CONTRATOTENURE, MIN(DATE(CST_CHRN_DT)) as MinChurnDate,
 CASE   WHEN MAX(C_CUST_AGE) <= 1 THEN "1M"
        WHEN MAX(C_CUST_AGE) > 1 AND MAX(C_CUST_AGE) <= 2 THEN "1M-2M"
        WHEN MAX(C_CUST_AGE) > 2 AND MAX(C_CUST_AGE) <= 3 THEN "2M-3M"
        WHEN MAX(C_CUST_AGE) > 3 AND MAX(C_CUST_AGE) <= 4 THEN "3M-4M"
        WHEN MAX(C_CUST_AGE) > 4 AND MAX(C_CUST_AGE) <= 5 THEN "4M-5M"
        WHEN MAX(C_CUST_AGE) > 5 AND MAX(C_CUST_AGE) <= 6 THEN "5M-6M"
        WHEN MAX(C_CUST_AGE) > 6 AND MAX(C_CUST_AGE) <= 7 THEN "6M-7M"
        WHEN MAX(C_CUST_AGE) > 7 AND MAX(C_CUST_AGE) <= 8 THEN "7M-8M"
        WHEN MAX(C_CUST_AGE) > 8 AND MAX(C_CUST_AGE) <= 9 THEN "8M-9M"
        WHEN MAX(C_CUST_AGE) > 9 AND MAX(C_CUST_AGE) <= 10 THEN "9M-10M"
        WHEN MAX(C_CUST_AGE) > 10 AND MAX(C_CUST_AGE) <= 11 THEN "10M-11M"
        WHEN MAX(C_CUST_AGE) > 11 AND MAX(C_CUST_AGE) <= 12 THEN "11M-1Y"
        WHEN MAX(C_CUST_AGE) > 12 AND MAX(C_CUST_AGE) <= 24 THEN "1Y-2Y"
        WHEN MAX(C_CUST_AGE) > 24 THEN "2Y+"
        END AS TENURE
 FROM `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-02-16_FINAL_HISTORIC_CRM_FILE_2021_D` 
 GROUP BY ACT_ACCT_CD
),
CHURNTYPETENURE AS(
    SELECT DISTINCT c.*, t.Tenure
    FROM CLASIFICACIONCHURN  c INNER JOIN TENURECHURNERS t ON c.CHURNER = t.CONTRATOTENURE AND c.PrimerChurn = t.MinChurnDate
)
SELECT EXTRACT (MONTH FROM MAXFECHA) AS MES, TENURE, COUNT(DISTINCT CHURNER) AS CHURNERS, COUNT (DISTINCT VOLUNTARIO) AS VOL, COUNT (DISTINCT INVOLUNTARIO) AS INVOL
FROM CHURNTYPETENURE 
GROUP BY MES,TENURE
ORDER BY MES ASC, TENURE
