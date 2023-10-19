-- CREATE TABLE OLAP
CREATE DATABASE OLAP_HospitalIE
GO

USE OLAP_HospitalIE

-- yg di create table itu dimension doang

CREATE TABLE MedicineDimension(
MedicineCode int PRIMARY KEY IDENTITY,
MedicineID int,
MedicineName VARCHAR(100),
MedicineSellingPrice BIGINT,
MedicineBuyingPrice BIGINT,
MedicineExpiredDate DATE
)

CREATE TABLE StaffDimension(
StaffCode int PRIMARY KEY IDENTITY,
StaffID INT,
StaffName VARCHAR(100),
StaffDOB DATE,
StaffSalary BIGINT,
StaffAddress VARCHAR(100),
ValidFrom DATETIME,
ValidTo DATETIME
)

CREATE TABLE CustomerDimension(
CustomerCode INT PRIMARY KEY IDENTITY,
CustomerID INT,
CustomerName VARCHAR(100),
CustomerAddress VARCHAR(100),
CustomerGender VARCHAR(6),
)


CREATE TABLE TimeDimension(
TimeCode INT PRIMARY KEY IDENTITY,
[Date] DATE,
[Day] INT,
[Month] INT,
[Quarter] INT,
[Year] INT
)


CREATE TABLE FilterTimeStamp(
TableName VARCHAR(50) PRIMARY KEY,
LastETL DATETIME
)

