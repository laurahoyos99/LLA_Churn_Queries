WITH ACTIVOSPLANBB AS(
 SELECT DISTINCT ACT_ACCT_CD, FECHA_EXTRACCION AS FECHA,
    CASE
    WHEN  PD_BB_PROD_NM IN (
        '3A_INTERNET CT 30MBPS/3MBPS V3',
        'I0132B_CT INTERNET 30MB/3MB',
        'I0132_CT INTERNET 30MB/3MB',
        'I0131_CT INTERNET 30MB/2MB',
        '3A_COLABORADOR 30MBPS/3MBPS V3A',
        '3030A_INTERNET CT 30MBPS/3MBPS GRUPO 1 V2',
        '3030B_INTERNET CT 30MBPS/3MBPS GRUPO 2 V2',
        '3_COLABORADOR 30MBPS/3MBPS V3',
        '3030C_INTERNET CT 30MBPS/3MBPS GRUPO 3 V2',
        'I0124B_INTERNET CT 35MBPS/5MBPS',
        'I0117_INTERNET CT 35MBPS/5MBPS',
        'I0112_INTERNET CT 35MBPS/3MBPS') THEN "30-35"
    WHEN PD_BB_PROD_NM IN (
        'I0121_INTERNET CT 75MBPS/5MBPS',
        '2021A_INTERNET CT 45MBPS/3MBPS',
        'I0139_INTERNET CT 50MBPS/5MBPS V2',
        'I0133_CT INTERNET 50MB/3MB',
        'I0136_CT INTERNET 50MB/5MB',
        'I0118_INTERNET CT 50MBPS/5MBPS',
        'I0118B_INTERNET CT 50MBPS/5MBPS') THEN "45-75"
    WHEN PD_BB_PROD_NM IN(
        'I0141_INTERNET CT 100MBPS/5MBPS V3',
        'I0140_INTERNET CT 100MBPS/5MBPS V2',
        'I0141_COLABORADOR 100MBPS/5MBPS V3',
        '3030A_INTERNET CT 100MBPS/5MBPS GRUPO 1 V2',
        '3030B_INTERNET CT 100MBPS/5MBPS GRUPO 2 V2',
        '3030C_INTERNET CT 100MBPS/5MBPS GRUPO 3 V2',
        'I0119_INTERNET CT 100MBPS/5MBPS') THEN "100"
    WHEN PD_BB_PROD_NM IN(
        'I0134_CT INTERNET 100MB/5MB',
        'I0114_INTERNET CT 100MBPS/3MBPS',
        'I0135_CT INTERNET 120MB/5MB',
        'I0135B_CT INTERNET 120MB/5MB',
        '3_INTERNET CT 150MBPS/5MBPS V3',
        'I0141_INTERNET CT 200MBPS/10MBPS V3',
        'I0141_COLABORADOR 200MBPS/10MBPS V3',
        '3030B_INTERNET CT 200MBPS/10MBPS GRUPO 2 V2',
        '3_INTERNET CT 200MBPS/10MBPS V3A',
        '3030A_INTERNET CT 200MBPS/10MBPS GRUPO 1 V2') THEN "101-200"
    WHEN PD_BB_PROD_NM IN(
        '3030C_INTERNET CT 200MBPS/10MBPS GRUPO 3 V2',
        '2021B_INTERNET CT 225MBPS/10MBPS',
        '2021C_INTERNET CT 300MBPS/10MBPS') THEN "201-300"
    WHEN PD_BB_PROD_NM IN(
        'RACSA INTERNET 256/64 KBPS',
        'INTERNET CT 512/128 KBPS',
        'RACSA INTERNET 512/128 KBPS',
        '005_INTERNET CT 1 MEGA/256 KBPS',
        'I0101_INTERNET CT 1MBPS/512KBPS',
        'RACSA INTERNET 1 MEGA/256 KBPS',
        'INTERNET CT 1.5 MEGAS/256 KBPS',
        'RACSA INTERNET 1.5 MEGAS/256 KBPS',
        'I0102_INTERNET CT 2MBPS/1MBPS',
        '006_INTERNET CT 2 MEGAS/512 KBPS',
        'I0102A_INTERNET CT 2MBPS/1MBPS GRUPO 1',
        'I0102B_INTERNET CT 2MBPS/1MBPS GRUPO 2',
        'I0102C_INTERNET CT 2MBPS/1MBPS GRUPO 3',
        'I0103_INTERNET CT 3MBPS/1MBPS',
        'I0125_CT INTERNET 3MB/1MB',
        '007_INTERNET CT 3MEGAS/512 KBPS',
        'INTERNET CT 3 MEGAS/256 KBPS',
        'I0103A_INTERNET CT 3MBPS/1MBPS GRUPO 1',
        'I0103B_INTERNET CT 3MBPS/1MBPS GRUPO 2',
        'I0103C_INTERNET CT 3MBPS/1MBPS GRUPO 3',
        'RACSA INTERNET 3 MEGAS/256 KBPS',
        'RACSA INTERNET 4 MEGAS/1 MEGA KBPS',
        'RACSA INTERNET 4 MEGAS/768 KBPS',
        '3030A_INTERNET CT 5MBPS/1MBPS GRUPO 1 V2',
        '3030B_INTERNET CT 5MBPS/1MBPS GRUPO 2 V2',
        '3030C_INTERNET CT 5MBPS/1MBPS GRUPO 3 V2',
        'I0126_CT INTERNET 5MB/1MB',
        'I0104_INTERNET CT 5MBPS/1.5MBPS',
        '009_INTERNET CT 5 MEGAS/512 KBPS',
        'I0109A_INTERNET CT 5MBPS/1MBPS GRUPO 1',
        'I0104A_INTERNET CT 5MBPS/1.5MBPS GRUPO 1',
        'I0109B_INTERNET CT 5MBPS/1MBPS GRUPO 2',
        '2020B_INTERNET CT 5MBPS/1MBPS GRUPO 2 V1',
        'I0104B_INTERNET CT 5MBPS/1.5MBPS GRUPO 2',
        'I0104C_INTERNET CT 5MBPS/1.5MBPS GRUPO 3',
        '2020C_INTERNET CT 5MBPS/1MBPS GRUPO 3 V1',
        '2020A_INTERNET CT 5MBPS/1MBPS GRUPO 1 V1',
        'I0109C_INTERNET CT 5MBPS/1MBPS GRUPO 3',
        'I0105_INTERNET CT 6MBPS/1.5MBPS',
        'I0106B_INTERNET CT 8MBPS/2MBPS',
        'I0106_INTERNET CT 8MBPS/1.5MBPS',
        'I0106A_INTERNET CT 8MBPS/1.5MBPS GRUPO 1',
        'I0106B_INTERNET CT 8MBPS/1.5MBPS GRUPO 2',
        'I0106C_INTERNET CT 8MBPS/1.5MBPS GRUPO 3',
        'I0127_CT INTERNET 10MB/1.5MB',
        'I0107_INTERNET CT 10MBPS/2MBPS',
        'I0110A_INTERNET CT 10MBPS/1.5MBPS GRUPO 1',
        'I0110B_INTERNET CT 10MBPS/1.5MBPS GRUPO 2',
        'I0110C_INTERNET CT 10MBPS/1.5MBPS GRUPO 3',
        'I0107A_INTERNET CT 10MBPS/2MBPS GRUPO 1',
        '010_INTERNET CT 10 MEGAS/1 MEGA',
        'I0107B_INTERNET CT 10MBPS/2MBPS GRUPO 2',
        'I0108_INTERNET CT 12MBPS/2MBPS',
        'I0138_INTERNET CT 15MBPS/3MBPS V2',
        'I0137_INTERNET CT 15MBPS/3MBPS V1',
        'I0141_INTERNET CT 15MBPS/3MBPS V3',
        'I0115_INTERNET CT 15MBPS/3MBPS',
        'I0128_CT INTERNET 15MB/1.5MB',
        '011_INTERNET CT 15 MEGAS/1 MBPS',
        'I0138A_INTERNET CT 15MBPS/3MBPS V2 GRUPO 1',
        'I0138B_INTERNET CT 15MBPS/3MBPS V2 GRUPO 2',
        'I0111A_INTERNET CT 15MBPS/1.5MBPS GRUPO 1',
        'I0111B_INTERNET CT 15MBPS/1.5MBPS GRUPO 2',
        'I0141_COLABORADOR 15MBPS/3MBPS V3',
        'I0138C_INTERNET CT 15MBPS/3MBPS V2 GRUPO3',
        'I0111C_INTERNET CT 15MBPS/1.5MBPS GRUPO 3',
        'I0109_INTERNET CT 15MBPS/2MBPS',
        'I0129_CT INTERNET 20MB/2MB',
        'I0112A_INTERNET CT 20MBPS/2MBPS GRUPO 1',
        'I0116_INTERNET CT 20MBPS/3MBPS',
        'I0112B_INTERNET CT 20MBPS/2MBPS GRUPO 2',
        'I0116B_INTERNET CT 20MBPS/3MBPS',
        'I0110_INTERNET CT 20MBPS/2MBPS',
        'RACSA INTERNET 2 MEGAS/512 KBPS',
        'I0112C_INTERNET CT 20MBPS/2MBPS GRUPO 3',
        'I0130_CT INTERNET 25MB/2MB',
        'I0120_INTERNET CT 25MBPS/5MBPS',
        'I0111_INTERNET CT 25MBPS/3MBPS') THEN "Menor a 30"
        ELSE "ND" END AS VELOCIDADBB
    FROM `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-02-02_CRM_BULK_FILE_FINAL_HISTORIC_DATA_2021_D`
    WHERE PD_BB_PROD_NM IS NOT NULL
GROUP BY ACT_ACCT_CD, VELOCIDADBB, FECHA),
CRUCEACTIVOS AS(
    SELECT DISTINCT a.ACT_ACCT_CD, FECHA, VELOCIDADBB,  min(date(ACT_ACCT_INST_DT)) as MinInst
    FROM ACTIVOSPLANBB a INNER JOIN `gcp-bia-tmps-vtr-dev-01.gcp_temp_cr_dev_01.2022-02-02_CRM_BULK_FILE_FINAL_HISTORIC_DATA_2021_D` t
    ON a.ACT_ACCT_CD = t.ACT_ACCT_CD AND a.FECHA = t.FECHA_EXTRACCION
    GROUP BY ACT_ACCT_CD, FECHA, VELOCIDADBB
),
TENUREACTIVOS AS(
    SELECT DISTINCT ACT_ACCT_CD, FECHA,VELOCIDADBB,
    CASE WHEN DATE_DIFF(FECHA,MinInst, DAY)<=90 AND MinInst < FECHA THEN "<3M"
    WHEN DATE_DIFF(FECHA,MinInst, DAY)<=180 AND DATE_DIFF(FECHA,MinInst, DAY)>90 THEN "03-6M"
    WHEN DATE_DIFF(FECHA,MinInst, DAY)<=270 AND DATE_DIFF(FECHA,MinInst, DAY)>180 THEN "06-9M"
    WHEN DATE_DIFF(FECHA,MinInst, DAY)<=360 AND DATE_DIFF(FECHA,MinInst, DAY)>270 THEN "09-1A"
    WHEN DATE_DIFF(FECHA,MinInst, DAY)<=720 AND DATE_DIFF(FECHA,MinInst, DAY)>360 THEN "1-2 A"
    WHEN DATE_DIFF(FECHA,MinInst, DAY)<=1080 AND DATE_DIFF(FECHA,MinInst, DAY)>720 THEN "2-3 A"
    WHEN DATE_DIFF(FECHA,MinInst, DAY)<=1440 AND DATE_DIFF(FECHA,MinInst, DAY)>1080 THEN "3-4 A"
    WHEN DATE_DIFF(FECHA,MinInst, DAY)>1440 THEN "+4A" END AS TENURE
    FROM CRUCEACTIVOS
)
SELECT EXTRACT (MONTH FROM FECHA)AS MES, VELOCIDADBB, TENURE, COUNT (DISTINCT ACT_ACCT_CD) as NumContratos
FROM TENUREACTIVOS
GROUP BY MES, VELOCIDADBB, TENURE
ORDER BY MES, VELOCIDADBB, TENURE
