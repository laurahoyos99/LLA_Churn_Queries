WITH CONTRATOSACTIVOSGEOGRAFIA AS(
    SELECT DISTINCT ACT_ACCT_CD, FECHA_EXTRACCION, ACT_CANTON_CD
    FROM `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-02-02_CRM_BULK_FILE_FINAL_HISTORIC_DATA_2021_D`
    GROUP BY ACT_ACCT_CD, FECHA_EXTRACCION,ACT_CANTON_CD
),
ACTIVOSMES AS(
    SELECT EXTRACT (MONTH FROM FECHA_EXTRACCION) AS MES, ACT_CANTON_CD AS CANTON, COUNT(DISTINCT ACT_ACCT_CD) AS NUMCONTRATOS
    FROM CONTRATOSACTIVOSGEOGRAFIA
    GROUP BY MES, CANTON
),
CHURNERSCRMGEOGRAFIA AS(
    SELECT DISTINCT ACT_ACCT_CD, MAX(CST_CHRN_DT) AS Maxfecha, ACT_CANTON_CD
    FROM `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-02-02_CRM_BULK_FILE_FINAL_HISTORIC_DATA_2021_D`
    GROUP BY ACT_ACCT_CD, ACT_CANTON_CD
    HAVING EXTRACT (MONTH FROM Maxfecha) = EXTRACT (MONTH FROM MAX(FECHA_EXTRACCION))
),
CHURNERSMES AS(
        SELECT EXTRACT (MONTH FROM Maxfecha) AS MES, ACT_CANTON_CD AS CANTON, COUNT(DISTINCT ACT_ACCT_CD) AS NUMCHURNERS
    FROM CHURNERSCRMGEOGRAFIA
    GROUP BY MES, CANTON
)
SELECT a.MES AS MES, a.CANTON as Canton, a.NUMCONTRATOS, c.NUMCHURNERS
FROM ACTIVOSMES a INNER JOIN CHURNERSMES c 
ON a.MES = c.MES AND a.CANTON = c.CANTON
GROUP BY MES, CANTON, NUMCONTRATOS,NUMCHURNERS
ORDER BY MES,CANTON
