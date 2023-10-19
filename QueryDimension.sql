-- BUAT TARIK DATA DR OLTP (vis stud)

--ETL StaffDimension
-- AMBIL DARI OLTP
SELECT
StaffID,
StaffName,
StaffDOB,
StaffSalary,
StaffAddress
FROM OLTP_HospitalIE..MsStaff

select*from OLAP_HospitalIE..StaffDimension --ini klo udh diconnect etl

--ETL MedicineDimension
SELECT
MedicineID, MedicineName, MedicineSellingPrice, MedicineBuyingPrice, MedicineExpiredDate
FROM OLTP_HospitalIE..MsMedicine

-- ETL CUSTOMERDIMENSION
SELECT
CustomerID, CustomerName, CustomerAddress, CustomerGender
FROM OLTP_HospitalIE..MsCustomer

select*from OLAP_HospitalIE..CustomerDimension

--ETL TimeDimension
IF EXISTS (SELECT*FROM OLAP_HospitalIE..FilterTimeStamp
WHERE TableName = 'TimeDimension')
BEGIN
	SELECT 
		AllDate.[Date],
		[Day] = DAY(AllDate.[Date]),
		[Month] = MONTH(AllDate.[Date]),
		[Quarter] = DATEPART(QUARTER, AllDate.[Date]),
		[Year] = YEAR(AllDate.[Date])
	FROM(
		SELECT [Date] =
		SalesDate
		FROM OLTP_HospitalIE..TrSalesHeader
		UNION
		SELECT 
		PurchaseDate AS [Date]
		FROM OLTP_HospitalIE..TrPurchaseHeader
		) AS AllDate
	WHERE AllDate.[Date] > (
		SELECT LastETL
		FROM OLAP_HospitalIE..FilterTimeStamp
		WHERE TableName = 'TimeDimension'
	)
END

else
begin
	SELECT 
		AllDate.[Date],
		[Day] = DAY(AllDate.[Date]),
		[Month] = MONTH(AllDate.[Date]),
		[Quarter] = DATEPART(QUARTER, AllDate.[Date]),
		[Year] = YEAR(AllDate.[Date])
	FROM(
		SELECT [Date] =
		SalesDate
		FROM OLTP_HospitalIE..TrSalesHeader
		UNION
		SELECT 
		PurchaseDate AS [Date]
		FROM OLTP_HospitalIE..TrPurchaseHeader
		) AS AllDate

END

IF EXISTS (SELECT*FROM OLAP_HospitalIE..FilterTimeStamp
WHERE TableName = 'TimeDimension')
BEGIN
	UPDATE OLAP_HospitalIE..FilterTimeStamp
	SET LastETL = GETDATE() WHERE TableName = 'TimeDimension'
END
ELSE
BEGIN
	INSERT INTO OLAP_HospitalIE..FilterTimeStamp
	VALUES('TimeDimension', GETDATE())
END

SELECT*FROM  OLAP_HospitalIE..TimeDimension
SELECT*FROM  OLAP_HospitalIE..FilterTimeStamp