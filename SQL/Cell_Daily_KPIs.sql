--CREATE TABLE "RF"."Cell_Daily_KPI" AS
--INSERT INTO "RF"."Cell_Daily_KPI"
SELECT
    DATE("Timestamp"::timestamp) AS "Date",
    "eNodeB",
    "CellName",

    SUM("Period_s") AS "Period_s",
    SUM("CellUnavailTime_s") AS "CellUnavailTime_s",

    ((SUM("Period_s") - SUM("CellUnavailTime_s")) * 100.0) /
    NULLIF(SUM("Period_s"), 0) AS "Availability",

    (SUM("RRC_ConnEstabSucc") * 100.0) /
    NULLIF(SUM("RRC_ConnEstabAtt"), 0) AS "RRC_SR",

    (SUM("S1SIG_ConnEstabSucc") * 100.0) /
    NULLIF(SUM("S1SIG_ConnEstabAtt"), 0) AS "S1_SR",

    (SUM("ERAB_EstabInitSucc") * 100.0) /
    NULLIF(SUM("ERAB_EstabInitAtt"), 0) AS "ERAB_SR",

    (SUM("ERAB_RelAbnormalNbr") * 100.0) /
    NULLIF(SUM("ERAB_RelAbnormalNbr") + SUM("ERAB_RelNormalNbr"), 0) AS "ERAB_DCR",

    SUM("DRB_PdcpVolDL_kbit") /
    NULLIF(SUM("DRB_ThpTimeDL_ms"), 0) AS "DL Throughput",

    SUM("DRB_PdcpVolUL_kbit") /
    NULLIF(SUM("DRB_ThpTimeUL_ms"), 0) AS "UL Throughput",

    (SUM("PRB_UsedDL") * 100.0) /
    NULLIF(SUM("PRB_AvailDL"), 0) AS "DL PRB Uti",

    (SUM("PRB_UsedUL") * 100.0) /
    NULLIF(SUM("PRB_AvailUL"), 0) AS "UL PRB Uti",

    (SUM("HO_ExecSucc") * 100.0) /
    NULLIF(SUM("HO_ExecAtt"), 0) AS "HOSR",

    (SUM("HO_ExecFail") * 100.0) /
    NULLIF(SUM("HO_ExecAtt"), 0) AS "HOFR",

    (
        (
            (SUM("RRC_ConnEstabSucc") * 100.0) /
            NULLIF(SUM("RRC_ConnEstabAtt"), 0)
        )
        *
        (
            (SUM("S1SIG_ConnEstabSucc") * 100.0) /
            NULLIF(SUM("S1SIG_ConnEstabAtt"), 0)
        )
        *
        (
            (SUM("ERAB_EstabInitSucc") * 100.0) /
            NULLIF(SUM("ERAB_EstabInitAtt"), 0)
        )
    ) / 10000 AS "Accessibility",

    100.0 -
    (
        (SUM("ERAB_RelAbnormalNbr") * 100.0) /
        NULLIF(SUM("ERAB_RelAbnormalNbr") + SUM("ERAB_RelNormalNbr"), 0)
    ) AS "Retainability"

FROM "RF"."Counter_Data"

GROUP BY
    DATE("Timestamp"::timestamp),
    "eNodeB",
    "CellName"

ORDER BY
    "Date",
    "eNodeB",
    "CellName";
