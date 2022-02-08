WITH CHURNERSCRM AS(
    SELECT DISTINCT ACT_ACCT_CD, MAX(CST_CHRN_DT) AS MaxfechaC
    FROM `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-02-02_CRM_BULK_FILE_FINAL_HISTORIC_DATA_2021_D`
    GROUP BY ACT_ACCT_CD
    HAVING EXTRACT (MONTH FROM MaxfechaC) = EXTRACT (MONTH FROM MAX(FECHA_EXTRACCION))
),
CHURNERSPLAN AS(
    SELECT DISTINCT ACT_ACCT_CD
    , MAX(CST_CHRN_DT) AS MaxfechaP,
    CASE
    WHEN  PD_BB_PROD_ID IS NOT NULL AND PD_TV_PROD_ID IS NOT NULL AND PD_VO_PROD_ID IS NOT NULL THEN "3P"
    WHEN  PD_BB_PROD_ID IS NOT NULL AND PD_TV_PROD_ID IS NOT NULL AND PD_VO_PROD_ID IS NULL THEN "2P - BB+TV"
    WHEN  PD_BB_PROD_ID IS NOT NULL AND PD_TV_PROD_ID IS NULL AND PD_VO_PROD_ID IS NOT NULL THEN "2P - BB+VO"
    WHEN  PD_BB_PROD_ID IS NULL AND PD_TV_PROD_ID IS NOT NULL AND PD_VO_PROD_ID IS NOT NULL THEN "2P - TV+VO"
    WHEN  PD_BB_PROD_ID IS NOT NULL AND PD_TV_PROD_ID IS NULL AND PD_VO_PROD_ID IS NULL THEN "1P - BB"
    WHEN  PD_BB_PROD_ID IS NULL AND PD_TV_PROD_ID IS NOT NULL AND PD_VO_PROD_ID IS NULL THEN "1P - TV"
    WHEN  PD_BB_PROD_ID IS NULL AND PD_TV_PROD_ID IS NULL AND PD_VO_PROD_ID IS NOT NULL THEN "1P - VO"
    END AS PFLAG
    FROM `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-02-02_CRM_BULK_FILE_FINAL_HISTORIC_DATA_2021_D`
    GROUP BY ACT_ACCT_CD, PFLAG
    HAVING EXTRACT (MONTH FROM MaxfechaP) = EXTRACT (MONTH FROM MAX(FECHA_EXTRACCION))
)
SELECT DISTINCT EXTRACT (MONTH FROM MaxfechaC) as MES,
PFLAG, COUNT(DISTINCT c.ACT_ACCT_CD) AS NumChurners
FROM CHURNERSCRM c INNER JOIN CHURNERSPLAN p ON c.ACT_ACCT_CD = p.ACT_ACCT_CD AND c.MaxfechaC = p.MaxfechaP
GROUP BY MES, PFLAG
ORDER BY MES ASC, PFLAG DESC
