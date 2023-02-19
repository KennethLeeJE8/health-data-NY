--	Create Food database

USE [master]
GO

/****** Object:  Database [Food]    Script Date: 11/4/2021 5:04:46 PM ******/
DROP DATABASE [Food]
GO

/****** Object:  Database [Food]    Script Date: 11/4/2021 5:04:46 PM ******/
CREATE DATABASE [Food]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Food_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Food_Data.mdf' , SIZE = 109504KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'Food_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Food_Log.ldf' , SIZE = 193536KB , MAXSIZE = 2048GB , FILEGROWTH = 1024KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

USE Food
GO

--	Create FoodFile table

/****** Object:  Table [dbo].[FoodFile]    Script Date: 11/4/2021 5:03:57 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FoodFile]') AND type in (N'U'))
DROP TABLE [dbo].[FoodFile]
GO

/****** Object:  Table [dbo].[FoodFile]    Script Date: 11/4/2021 5:03:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FoodFile](
	[FACILITY][varchar] (100) NULL,
	[ADDRESS][varchar] (100) NULL,
	[LAST INSPECTED][varchar] (100) NULL,
	[VIOLATIONS][varchar] (3500) NULL,
	[TOTAL # CRITICAL VIOLATIONS][varchar] (100) NULL,
	[TOTAL #CRIT.  NOT CORRECTED ][varchar] (100) NULL,
	[TOTAL # NONCRITICAL VIOLATIONS][varchar] (100) NULL,
	[DESCRIPTION][varchar] (100) NULL,
	[LOCAL HEALTH DEPARTMENT][varchar] (100) NULL,
	[COUNTY][varchar] (100) NULL,
	[FACILITY ADDRESS][varchar] (100) NULL,
	[CITY][varchar] (100) NULL,
	[ZIP CODE][varchar] (100) NULL,
	[NYSDOH GAZETTEER (1980)][varchar] (100) NULL,
	[MUNICIPALITY][varchar] (100) NULL,
	[OPERATION NAME][varchar] (100) NULL,
	[PERMIT EXPIRATION DATE][varchar] (100) NULL,
	[PERMITTED  (D/B/A)][varchar] (100) NULL,
	[PERMITTED  CORP. NAME][varchar] (100) NULL,
	[PERM. OPERATOR LAST NAME][varchar] (100) NULL,
	[PERM. OPERATOR FIRST NAME][varchar] (100) NULL,
	[NYS HEALTH OPERATION ID][varchar] (100) NULL,
	[INSPECTION TYPE][varchar] (100) NULL,
	[INSPECTION COMMENTS][varchar] (2500) NULL,
	[FOOD SERVICE FACILITY STATE][varchar] (100) NULL,
	[Location1][varchar] (100) NULL

) ON [PRIMARY]
GO

--	Load FoodFile table from Foodfile.csv using BULK INSERT
--	**Change the path to where you stored the csv file**


bulk insert Foodfile
from 'C:\Users\kenne\Downloads\Food_Service_Establishment__Last_Inspection.csv'
with (format = 'csv')

--	References
-----------------
--	Data Definitions
--	https://health.data.ny.gov/Health/Food-Service-Establishment-Last-Inspection/cnih-y5dw
--	https://health.data.ny.gov/api/views/cnih-y5dw/files/CiE3kRhZhZMYsPcp-2BG-mV1Ob2ureoxAYUVFZe75Xw?download=true&filename=NYSDOH_FSEInspection_DataCollectionTool.pdf
--	https://health.data.ny.gov/api/views/cnih-y5dw/files/C7ywYFjUuzbISPHLCOdkdJ_pEMmxlO4rBMmM2XoOiN0?download=true&filename=NYSDOH_FSEInspection_DataDictionary.pdf
--	Create Database
--	https://docs.microsoft.com/en-us/sql/t-sql/statements/create-database-transact-sql?view=sql-server-ver15&tabs=sqlpool
--	Create table
--	https://docs.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql?view=sql-server-ver15
--	Bulk Insert
--	https://docs.microsoft.com/en-us/sql/t-sql/statements/bulk-insert-transact-sql?view=sql-server-ver15
--
--	