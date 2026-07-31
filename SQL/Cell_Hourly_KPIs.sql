--CREATE TABLE "RF"."Hourly_KPI" AS
--INSERT INTO "RF"."Hourly_KPI"
SELECT
    DATE("Timestamp"::timestamp) AS "Date",
    EXTRACT(HOUR FROM "Timestamp"::timestamp) AS "Hour",
		"eNodeB",
		"CellName",
    (("Period_s" - "CellUnavailTime_s") * 100.0) / NULLIF("Period_s", 0) AS "Availability",
		("RRC_ConnEstabSucc" * 100.0) / NULLIF("RRC_ConnEstabAtt", 0) AS "RRC_SR",
		("S1SIG_ConnEstabSucc" * 100.0) / NULLIF("S1SIG_ConnEstabAtt", 0) AS "S1_SR",
		("ERAB_EstabInitSucc" * 100.0) / NULLIF("ERAB_EstabInitAtt", 0) AS "ERAB_SR",
		("ERAB_RelAbnormalNbr" * 100.0) / NULLIF("ERAB_RelAbnormalNbr"+"ERAB_RelNormalNbr", 0) AS "ERAB_DCR",
		("DRB_PdcpVolDL_kbit" / "DRB_ThpTimeDL_ms") AS "DL Throughput",
		("DRB_PdcpVolUL_kbit" / NULLIF("DRB_ThpTimeUL_ms", 0)) AS "UL Throughput",
		("PRB_UsedDL" * 100.0) / NULLIF("PRB_AvailDL", 0) AS "DL PRB Uti",
		("PRB_UsedUL" * 100.0) / NULLIF("PRB_AvailUL", 0) AS "UL PRB Uti",
		("HO_ExecSucc" * 100.0) / NULLIF("HO_ExecAtt", 0) AS "HOSR",
		("HO_ExecFail" * 100.0) / NULLIF("HO_ExecAtt", 0) AS "HOFR",
(
    (("RRC_ConnEstabSucc" * 100.0) / NULLIF("RRC_ConnEstabAtt", 0))
    *
    (("S1SIG_ConnEstabSucc" * 100.0) / NULLIF("S1SIG_ConnEstabAtt", 0))
    *
    (("ERAB_EstabInitSucc" * 100.0) / NULLIF("ERAB_EstabInitAtt", 0))
) / 10000 AS "Accessibility",
		(100.0 - ("ERAB_RelAbnormalNbr" * 100.0) / NULLIF("ERAB_RelAbnormalNbr"+"ERAB_RelNormalNbr", 0)) As "Retainability"
FROM "RF"."Counter_Data" Order by "Timestamp" asc
