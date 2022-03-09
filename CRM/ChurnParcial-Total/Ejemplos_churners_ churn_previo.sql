WITH CHURNERSCRM AS(
    SELECT DISTINCT ACT_ACCT_CD, MAX(DATE(CST_CHRN_DT)) AS Maxfecha
    FROM `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-02-16_FINAL_HISTORIC_CRM_FILE_2021_D`
    GROUP BY ACT_ACCT_CD
    HAVING DATE_TRUNC(Maxfecha, MONTH) = DATE_TRUNC(MAX(FECHA_EXTRACCION), MONTH)
),
CRUCECHURNERSPREVIOS AS(
    SELECT DISTINCT t.ACT_ACCT_CD as Contrato, c.ACT_ACCT_CD as ContratoChurner, DATE(t.CST_CHRN_DT) as FechasChurn, c.MaxFecha as FechaChurnFinal, Fecha_Extraccion, PD_BB_PROD_NM, PD_TV_PROD_CD, PD_VO_PROD_NM
    FROM `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-02-16_FINAL_HISTORIC_CRM_FILE_2021_D` t
    INNER JOIN CHURNERSCRM c ON c.ACT_ACCT_CD = t.ACT_ACCT_CD AND  DATE(CST_CHRN_DT) <= MaxFecha
    WHERE DATE(t.CST_CHRN_DT) = FECHA_EXTRACCION --AND DATE_DIFF(MaxFecha, DATE(t.CST_CHRN_DT), DAY) <= 90
)
SELECT *
FROM CRUCECHURNERSPREVIOS c
ORDER BY ContratoChurner, FechasChurn