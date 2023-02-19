USE Food
GO

-- Drop factFoodFile
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[factFoodFile]') AND type in (N'U'))
DROP TABLE [dbo].[factFoodFile]
GO
--Drop Violations Dimension
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dimDate]') AND type in (N'U'))
DROP TABLE [dbo].[dimDate]
GO
--Drop Violations Dimension
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dimViolations]') AND type in (N'U'))
DROP TABLE [dbo].[dimViolations]
GO
--Drop Severity Dimension
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dimSeverity]') AND type in (N'U'))
DROP TABLE [dbo].[dimSeverity]
GO
--Drop SubType
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dimInstitutionSubType]') AND type in (N'U'))
DROP TABLE [dbo].[dimInstitutionSubType]
GO
-- Drop Type
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dimInstitutionType]') AND type in (N'U'))
DROP TABLE [dbo].[dimInstitutionType]
GO

-- Drop dimInspectionType
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dimInspectionType]') AND type in (N'U'))
DROP TABLE [dbo].[dimInspectionType]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dimRegion]') AND type in (N'U'))
DROP TABLE [dbo].[dimRegion]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dimCounty]') AND type in (N'U'))
DROP TABLE [dbo].[dimCounty]
GO

CREATE TABLE [dbo].[dimDate] (
   [DateID] [int] NOT NULL,
   [Date] [date] NOT NULL,
   [Day] [tinyint] NOT NULL,
   [DaySuffix] [char](2) NOT NULL,
   [Weekday] [tinyint] NOT NULL,
   [WeekDayName] [varchar](10) NOT NULL,
   [WeekDayName_Short] [char](3) NOT NULL,
   [WeekDayName_FirstLetter] [char](1) NOT NULL,
   [DOWInMonth] [tinyint] NOT NULL,
   [DayOfYear] [smallint] NOT NULL,
   [WeekOfMonth] [tinyint] NOT NULL,
   [WeekOfYear] [tinyint] NOT NULL,
   [Month] [tinyint] NOT NULL,
   [MonthName] [varchar](10) NOT NULL,
   [MonthName_Short] [char](3) NOT NULL,
   [MonthName_FirstLetter] [char](1) NOT NULL,
   [Quarter] [tinyint] NOT NULL,
   [QuarterName] [varchar](6) NOT NULL,
   [Year] [int] NOT NULL,
   [MMYYYY] [char](6) NOT NULL,
   [MonthYear] [char](7) NOT NULL,
   IsWeekend BIT NOT NULL,
   IsHoliday BIT NOT NULL,
   HolidayName VARCHAR(20) NULL,
   SpecialDays VARCHAR(20) NULL,
   [FinancialYear] [int] NULL,
   [FinancialQuater] [int] NULL,
   [FinancialMonth] [int] NULL,
   [FirstDateofYear] DATE NULL,
   [LastDateofYear] DATE NULL,
   [FirstDateofQuater] DATE NULL,
   [LastDateofQuater] DATE NULL,
   [FirstDateofMonth] DATE NULL,
   [LastDateofMonth] DATE NULL,
   [FirstDateofWeek] DATE NULL,
   [LastDateofWeek] DATE NULL,
   CurrentYear SMALLINT NULL,
   CurrentQuater SMALLINT NULL,
   CurrentMonth SMALLINT NULL,
   CurrentWeek SMALLINT NULL,
   CurrentDay SMALLINT NULL,
   PRIMARY KEY CLUSTERED ([DateID] ASC)
   )

-- load dimDate table

SET NOCOUNT ON

TRUNCATE TABLE dimDate

DECLARE @CurrentDate DATE = '2000-01-01'
DECLARE @EndDate DATE = '2023-02-19'

WHILE @CurrentDate < @EndDate
BEGIN
   INSERT INTO [dbo].[dimDate] (
      [DateID],
      [Date],
      [Day],
      [DaySuffix],
      [Weekday],
      [WeekDayName],
      [WeekDayName_Short],
      [WeekDayName_FirstLetter],
      [DOWInMonth],
      [DayOfYear],
      [WeekOfMonth],
      [WeekOfYear],
      [Month],
      [MonthName],
      [MonthName_Short],
      [MonthName_FirstLetter],
      [Quarter],
      [QuarterName],
      [Year],
      [MMYYYY],
      [MonthYear],
      [IsWeekend],
      [IsHoliday],
      [FirstDateofYear],
      [LastDateofYear],
      [FirstDateofQuater],
      [LastDateofQuater],
      [FirstDateofMonth],
      [LastDateofMonth],
      [FirstDateofWeek],
      [LastDateofWeek]
      )
   SELECT DateID = YEAR(@CurrentDate) * 10000 + MONTH(@CurrentDate) * 100 + DAY(@CurrentDate),
      DATE = @CurrentDate,
      Day = DAY(@CurrentDate),
      [DaySuffix] = CASE 
         WHEN DAY(@CurrentDate) = 1
            OR DAY(@CurrentDate) = 21
            OR DAY(@CurrentDate) = 31
            THEN 'st'
         WHEN DAY(@CurrentDate) = 2
            OR DAY(@CurrentDate) = 22
            THEN 'nd'
         WHEN DAY(@CurrentDate) = 3
            OR DAY(@CurrentDate) = 23
            THEN 'rd'
         ELSE 'th'
         END,
      WEEKDAY = DATEPART(dw, @CurrentDate),
      WeekDayName = DATENAME(dw, @CurrentDate),
      WeekDayName_Short = UPPER(LEFT(DATENAME(dw, @CurrentDate), 3)),
      WeekDayName_FirstLetter = LEFT(DATENAME(dw, @CurrentDate), 1),
      [DOWInMonth] = DAY(@CurrentDate),
      [DayOfYear] = DATENAME(dy, @CurrentDate),
      [WeekOfMonth] = DATEPART(WEEK, @CurrentDate) - DATEPART(WEEK, DATEADD(MM, DATEDIFF(MM, 0, @CurrentDate), 0)) + 1,
      [WeekOfYear] = DATEPART(wk, @CurrentDate),
      [Month] = MONTH(@CurrentDate),
      [MonthName] = DATENAME(mm, @CurrentDate),
      [MonthName_Short] = UPPER(LEFT(DATENAME(mm, @CurrentDate), 3)),
      [MonthName_FirstLetter] = LEFT(DATENAME(mm, @CurrentDate), 1),
      [Quarter] = DATEPART(q, @CurrentDate),
      [QuarterName] = CASE 
         WHEN DATENAME(qq, @CurrentDate) = 1
            THEN 'First'
         WHEN DATENAME(qq, @CurrentDate) = 2
            THEN 'second'
         WHEN DATENAME(qq, @CurrentDate) = 3
            THEN 'third'
         WHEN DATENAME(qq, @CurrentDate) = 4
            THEN 'fourth'
         END,
      [Year] = YEAR(@CurrentDate),
      [MMYYYY] = RIGHT('0' + CAST(MONTH(@CurrentDate) AS VARCHAR(2)), 2) + CAST(YEAR(@CurrentDate) AS VARCHAR(4)),
      [MonthYear] = CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + UPPER(LEFT(DATENAME(mm, @CurrentDate), 3)),
      [IsWeekend] = CASE 
         WHEN DATENAME(dw, @CurrentDate) = 'Sunday'
            OR DATENAME(dw, @CurrentDate) = 'Saturday'
            THEN 1
         ELSE 0
         END,
      [IsHoliday] = 0,
      [FirstDateofYear] = CAST(CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + '-01-01' AS DATE),
      [LastDateofYear] = CAST(CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + '-12-31' AS DATE),
      [FirstDateofQuater] = DATEADD(qq, DATEDIFF(qq, 0, GETDATE()), 0),
      [LastDateofQuater] = DATEADD(dd, - 1, DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) + 1, 0)),
      [FirstDateofMonth] = CAST(CAST(YEAR(@CurrentDate) AS VARCHAR(4)) + '-' + CAST(MONTH(@CurrentDate) AS VARCHAR(2)) + '-01' AS DATE),
      [LastDateofMonth] = EOMONTH(@CurrentDate),
      [FirstDateofWeek] = DATEADD(dd, - (DATEPART(dw, @CurrentDate) - 1), @CurrentDate),
      [LastDateofWeek] = DATEADD(dd, 7 - (DATEPART(dw, @CurrentDate)), @CurrentDate)

   SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END

--Update Holiday information
UPDATE dimDate
SET [IsHoliday] = 1,
   [HolidayName] = 'Christmas'
WHERE [Month] = 12
   AND [DAY] = 25

UPDATE dimDate
SET SpecialDays = 'Valentines Day'
WHERE [Month] = 2
   AND [DAY] = 14

--Update current date information
UPDATE dimDate
SET CurrentYear = DATEDIFF(yy, GETDATE(), DATE),
   CurrentQuater = DATEDIFF(q, GETDATE(), DATE),
   CurrentMonth = DATEDIFF(m, GETDATE(), DATE),
   CurrentWeek = DATEDIFF(ww, GETDATE(), DATE),
   CurrentDay = DATEDIFF(dd, GETDATE(), DATE)

select * from dimDate

-- Create Inspection Dimension
CREATE TABLE [dbo].[dimInspectionType](
	[InspectionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[InspectionType] [varchar](50) NULL,
 CONSTRAINT [PK_dimInspectionType_InspectionTypeID] PRIMARY KEY CLUSTERED (InspectionTypeID)
)
GO

INSERT INTO dimInspectionType
VALUES
('Inspection'),
('Re-Inspection')

--	Create dimType

CREATE TABLE [dbo].[dimInstitutionType](
	InstitutionTypeID int IDENTITY(1,1) NOT NULL,
		CONSTRAINT PK_dimInstitutionType_TypeID PRIMARY KEY CLUSTERED (InstitutionTypeID),
	InstitutionTypeDescription varchar(50)
)
GO

INSERT INTO dimInstitutionType
SELECT DISTINCT LEFT(Description,CHARINDEX('-', DESCRIPTION)-2)
FROM FoodFile
GO

	--Create dimSubType


CREATE TABLE [dbo].[dimInstitutionSubType](
	InstitutionSubTypeID int IDENTITY(1,1) NOT NULL,
		CONSTRAINT PK_dimInstitutionSubType_SubTypeID PRIMARY KEY CLUSTERED (InstitutionSubTypeID),
	InstitutionSubTypeDescription varchar(50),
	InstitutionTypeID int not null,
		CONSTRAINT FK_dimInstitutionType_dimInstitutionSubType FOREIGN KEY (InstitutionTypeID)
		REFERENCES dimInstitutionType (InstitutionTypeID)
)
GO

INSERT INTO dimInstitutionSubType
--SELECT	distinct substring(description,CHARINDEX('-', DESCRIPTION)+2,100) as SubType,
	SELECT  DISTINCT RIGHT(description,(LEN(description) - CHARINDEX('-', DESCRIPTION))),
		TypeID =
			case 
				when description like '%SED Summer Feeding Prog.%' then 1
				when description like'%SOFA Food Service%' then 2
				when description like '%Institutional Food Service%' then 3
				when description like '%Food Service Establishment%' then 4
				else 5
			end
	FROM FoodFile

-- create dimSeverity dimension

CREATE TABLE [dbo].[dimSeverity](
	SeverityID int NOT NULL,
		CONSTRAINT PK_dimSeverity_SeverityID PRIMARY KEY CLUSTERED (SeverityID),
	SeverityCode varchar(30),
	SeverityDescription varchar(500)
)

INSERT INTO dimSeverity
VALUES
(1,'RED','Critical Items'),
(2,'BLUE','Non-Critical Items'),
(3,'N/A', 'No Violations')

--	create dimViolations dimension
CREATE TABLE [dbo].[dimViolations](
	ViolationsID int IDENTITY(1,1) NOT NULL,
		CONSTRAINT PK_dimViolations_ViolationsID PRIMARY KEY CLUSTERED (ViolationsID),
	ViolationsCode varchar(30),
	ViolationsDescription varchar(500),
	SeverityID int
		CONSTRAINT FK_dimSeverity_dimViolation FOREIGN KEY (SeverityID)
		REFERENCES dimSeverity(SeverityID)
)


INSERT INTO dimViolations
VALUES
('Item  1A','Unpasteurized milk and milk products used','1'),
('Item  1B','Water/ice: unsafe, unapproved sources, cross connections','1'),
('Item  1C','Home canned goods, or canned goods from unapproved processor found  on premises','1'),
('Item  1D','Canned foods found in poor conditions (leakers, severe dents, rusty, swollen cans','1'),
('Item  1E','Meat and meat products not from approved plants.','1'),
('Item  1F','Shellfish not from approved sources, improperly tagged/labeled, tags not  retained 90 days.','1'),
('Item  1G','Cracked/dirty fresh eggs, liquid or frozen eggs and powdered eggs not pasteurized.','1'),
('Item  1H','Food from unapproved source, spoiled, adulterated on premises.','1'),
('Item  2A','Prepared food products contact equipment or work surfaces which have had prior contact with raw foods and where washing and sanitizing of the food contact surface has not occurred to prevent contamination','1'),
('Item  2B','Food workers prepare raw and cooked or ready to eat food products without ''thorough handwashing and sanitary glove changing in between.','1'),
('Item  2C','Cooked or prepared foods are subject to cross','1'),
('Item  2D','Unwrapped/potentially hazardous foods are reserved.','1'),
('Item  2E','Accurate thermometers not available or used to evaluate potentially hazardous food temperatures during cooking, cooling, reheating and holding.','1'),
('Item  3B','Food workers do not wash hands thoroughly after visiting the toilet, coughing, sneezing, smoking or otherwise contaminating their hands.','1'),
('Item  3C','Food workers do not use proper utensils to eliminate bare hand contact with cooked or prepared foods.','1'),
('Item  4A','Toxic chemicals are improperly labeled, stored or used so that contamination of food can occur.','1'),
('Item  4B','Acid foods are stored in containers or pipes that consist of toxic metals.','1'),
('Item  4C','Foods or food area/public area contamination by sewage or drippage from waste lines.','1'),
('Item  5A','Potentially hazardous foods are not kept at or below 45','1'),
('Item  5B','Potentially hazardous foods are not cooled by an approved method where the food temperature can be reduced from 120oF to 70oF or less within two hours and 70oF to 45oF within four hours.','1'),
('Item  5C','Potentially hazardous foods are not stored under refrigeration except during necessary preparation or approved precooling procedures (room temperature storage).','1'),
('Item  5D','Potentially hazardous foods such as salads prepared from potatoes or macaroni are not prepared as recommended using prechilled ingredients and not  prechilled to 45','1'),
('Item  5E','Enough refrigerated storage equipment is not present, properly designed, maintained or operated so that all potentially hazardous foods are cooled properly and stored below 45','1'),
('Item  6A','Potentially hazardous foods are not kept at or above 140','1'),
('Item  6B','Enough hot holding equipment is not present, properly designed, maintained and operated to keep hot foods above 140','1'),
('Item  7A','All poultry, poultry stuffings, stuffed meats and stuffings containing meat are not heated to 165','1'),
('Item  7E','Other potentially hazardous foods requiring cooking are not heated to 140','1'),
('Item  7F','Precooked, refrigerated potentially hazardous food is not reheated to 165','1'),
('Item  7G','Commercially processed precooked potentially hazardous foods are not heated to 140','1'),
('Item  8A','Food not protected during storage, preparation, display, transportation and service, from potential sources of contamination (e.g., food uncovered, mislabeled, stored on floor, missing or inadequate sneeze guards, food containers double stacked)','2'),
('Item  8B','In use food dispensing utensils improperly stored','2'),
('Item  8C','Improper use and storage of clean, sanitized equipment and utensils','2'),
('Item  8D','Single service items reused, improperly stored, dispensed, not used when required','2'),
('Item  8E','Accurate thermometers not available or used to evaluate refrigerated or heated storage temperatures','2'),
('Item  8F','Improper thawing procedures used','2'),
('Item  9A','Inadequate personal cleanliness','2'),
('Item  9B','Tobacco is used','2'),
('Item  9C','Hair is improperly restrained','2'),
('Item  9D','Dressing rooms dirty, not provided, improperly located','2'),
('Item 10A','Food (ice) contact surfaces are improperly designed, constructed, installed, located (cracks, open seams, pitted surfaces, tin cans reused, uncleanable or corroded food contact surfaces)','2'),
('Item 10B','Non','1'),
('Item 11A','Manual facilities inadequate, technique incorrect','2'),
('Item 11B','Wiping cloths dirty, not stored properly in sanitizing solutions','2'),
('Item 11C','Food contact surfaces not washed, rinsed and sanitized after each use and following any time of operations when contamination may have occurred','2'),
('Item 11D','Non food contact surfaces of equipment not clean','2'),
('Item 12A','Hot, cold running water not provided, pressure inadequate','2'),
('Item 12B','Improperly functioning on','2'),
('Item 12C','Plumbing and sinks not properly sized, installed, maintained','2'),
('Item 12D','Toilet facilities inadequate, inconvenient, dirty, in disrepair, toilet paper missing, not self','2'),
('Item 12E','Handwashing facilities inaccessible, improperly located, dirty, in disrepair, improper fixtures, soap, and single service towels or hand drying devices missing','2'),
('Item 13A','Adequate, leakproof, non','2'),
('Item 13B','Garbage storage areas not properly constructed or maintained, creating a nuisance','2'),
('Item 14A','Insects, rodents present','2'),
('Item 14B','Effective measures not used to control entrance (rodent','2'),
('Item 14C','Pesticide application not supervised by a certified applicator','2'),
('Item 15A','Floors, walls, ceilings, not smooth, properly constructed, in disrepair, dirty surfaces','2'),
('Item 15B','Lighting and ventilation inadequate, fixtures not shielded, dirty ventilation hoods, ductwork, filters, exhaust fans','2'),
('Item 15C','Premises littered, unnecessary equipment and article present, living quarters no completely separated for food service operations, live animals, birds and pets not excluded','2'),
('Item 15D','Improper storage of cleaning equipment, linens, laundry unacceptable','2'),
('Item 16','Miscellaneous, Economic Violation, Choking Poster, Training.','2'),
('Item 4D','Other Violations Deemed a Public Health Hazard by the Permit Issuing Official {14','2'),
('No violations found','','3')



--	create dimCounty
CREATE TABLE dimCounty(
	CountyID int IDENTITY(1,1) NOT NULL,
		CONSTRAINT PK_dimCounty_CountyID PRIMARY KEY CLUSTERED (CountyID),
	CountyName varchar(50) NOT NULL,
	RegionName varchar(50)

)

INSERT INTO dimCounty
VALUES
('Albany','Capital Region'),
('Allegany','Western'),
('Broome','Southern Tier'),
('Cattaraugus','Western'),
('Cayuga','Central'),
('Chautauqua','Western'),
('Chemung','Finger Lakes'),
('Chenango','Southern Tier'),
('Clinton','North Country'),
('Columbia','Capital Region'),
('Cortland','Central'),
('Delaware','Southern Tier'),
('Dutchess','Mid-Hudson'),
('Erie','Western'),
('Essex','North Country'),
('Franklin','North Country'),
('Fulton','Mohawk Valley'),
('Genesee','Western'),
('Greene','Capital Region'),
('Hamilton','North Country'),
('Herkimer','Mohawk Valley'),
('Jefferson','North Country'),
('Lewis','North Country'),
('Livingston','Finger Lakes'),
('Madison','Central'),
('Monroe','Finger Lakes'),
('Montgomery','Mohawk Valley'),
('Nassau','Long Island'),
('Niagara','Western'),
('Oneida','Central'),
('Onondaga','Central'),
('Ontario','Finger Lakes'),
('Orange','Mid-Hudson'),
('Orleans','Western'),
('Oswego','Central'),
('Otsego','Mohawk Valley'),
('Putnam','Mid-Hudson'),
('Rensselaer','Capital Region'),
('Rockland','Mid-Hudson'),
('St.Lawrence','North Country'),
('Saratoga','Capital Region'),
('Schenectady','Capital Region'),
('Schoharie','Mohawk Valley'),
('Schuyler','Finger Lakes'),
('Seneca','Finger Lakes'),
('Steuben','Finger Lakes'),
('Suffolk','Long Island'),
('Sullivan','Mid-Hudson'),
('Tioga','Southern Tier'),
('Tompkins','Southern Tier'),
('Ulster','Mid-Hudson'),
('Warren','North Country'),
('Washington','North Country'),
('Wayne','Finger Lakes'),
('Westchester','Mid-Hudson'),
('Wyoming','Western'),
('Yates','Finger Lakes'),
('Bronx','NYC'),
('Kings (Brooklyn)','NYC'),
('New York','NYC'),
('Queens','NYC'),
('Richmond','NYC')

--	create factFoodFile

CREATE TABLE [dbo].[factFoodFile](
	FoodFileID int IDENTITY(1,1) NOT NULL,
		CONSTRAINT PK_factFoodFile_FoodFileID PRIMARY KEY CLUSTERED (FoodFileID),
	InspectionTypeID int,
		CONSTRAINT FK_dimInspectionType_factFoodFile FOREIGN KEY (InspectionTypeID)
		REFERENCES dimInspectionType (InspectionTypeID),
	InstitutionSubTypeID int,
		CONSTRAINT FK_dimInstitutionSubType_factFoodFile FOREIGN KEY (InstitutionSubTypeID)
		REFERENCES dimInstitutionSubType (InstitutionSubTypeID),
	ViolationsID int,
		CONSTRAINT FK_dimViolation_factFoodFile FOREIGN KEY (ViolationsID)
		REFERENCES dimViolations (ViolationsID),
	CountyID int,
		CONSTRAINT FK_dimCounty_factFoodFile FOREIGN KEY (CountyID)
		REFERENCES dimCounty(CountyID),
	DateID int,	
		CONSTRAINT FK_dimDate_factFoodFile FOREIGN KEY (DateID)
		REFERENCES dimDate(DateID),
	CriticalValues int,
	CriticalValuesNotCorrected int,
	NotCriticalVlaues int

)
GO

INSERT INTO factFoodFile
SELECT
	[INSPECTIONTYPEID] =
			case 
				when [INSPECTION TYPE] = 'Inspection' then 1
				else 2
			end,
		InstitutionSubTypeID =
			case 
				when Description LIKE '%Adult Feeding (Non-SOFA)%' THEN 1
				when Description LIKE '%SOFA Food Service%' THEN 2
				when Description LIKE '%SED Satellite Feeding Site%' THEN 3
				when Description LIKE '%Commissary%' THEN 4
				when Description LIKE '%Food Service Establishment%' THEN 5
				when Description LIKE '%Tavern%' THEN 6
				when Description LIKE '%SED Satellite/Preparation Site%' THEN 7
				when Description LIKE '%Delicatessen%' THEN 8
				when Description LIKE '%Institutional Food Service%' THEN 9
				when Description LIKE '%SOFA Prep Site-State Office for the Aging%' THEN 10
				when Description LIKE '%College Food Service%' THEN 11
				when Description LIKE '%Restaurant/Catering Operation%' THEN 12
				when Description LIKE '%School K-12 Food Service%' THEN 13
				when Description LIKE '%Restaurant%' THEN 14
				when Description LIKE '%SED Food Preparation Site%' THEN 15
				when Description LIKE '%Bakery%' THEN 16
				when Description LIKE '%Day Care Center Food Service%' THEN 17
				when Description LIKE '%Ice Cream Store%' THEN 18
				when Description LIKE '%Nutrition for the Indigent%' THEN 19
				when Description LIKE '%Ice Manufacturer%' THEN 20
				when Description LIKE '%Religious, Charitable, Fraternal Organization%' THEN 21
				when Description LIKE '%Children''s Camp\State Education Food Service%' THEN 22
				when Description LIKE '%Frozen Desserts%' THEN 23
				when Description LIKE '%SED Self Preparation Feeding Site%' THEN 24
				when Description LIKE '%SOFA Satellite Site -State Office for the Aging%' THEN 25
				when Description LIKE '%Institution Food Service%' THEN 26
				when Description LIKE '%Children''s Camp Food Service%' THEN 27
			end,
	ceiling(rand()*62) AS [ViolationsID],
	COUNTYID =
		CASE 
			WHEN COUNTY = ('ALBANY') THEN 1
			WHEN COUNTY = ('ALLEGANY') THEN 2
			WHEN COUNTY = ('BROOME') THEN 3
			WHEN COUNTY = ('CATTARAUGUS') THEN 4
			WHEN COUNTY = ('CAYUGA') THEN 5
			WHEN COUNTY = ('CHAUTAUQUA') THEN 6
			WHEN COUNTY = ('CHEMUNG') THEN 7
			WHEN COUNTY = ('CHENANGO')THEN 8
			WHEN COUNTY = ('CLINTON')THEN 9
			WHEN COUNTY = ('COLUMBIA') THEN 10
			WHEN COUNTY = ('CORTLAND') THEN 11
			WHEN COUNTY = ('DELAWARE')THEN 12
			WHEN COUNTY = ('DUTCHESS')THEN 13
			WHEN COUNTY = ('ERIE')THEN 14
			WHEN COUNTY = ('ESSEX')THEN 15
			WHEN COUNTY = ('FRANKLIN')THEN 16
			WHEN COUNTY = ('FULTON')THEN 17
			WHEN COUNTY = ('GENESEE')THEN 18
			WHEN COUNTY = ('GREENE')THEN 19
			WHEN COUNTY = ('HAMILTON') THEN 20
			WHEN COUNTY = ('HERKIMER') THEN 21
			WHEN COUNTY = ('JEFFERSON')THEN 22
			WHEN COUNTY = ('LEWIS')THEN 23
			WHEN COUNTY = ('(LIVINGSTON') THEN 24
			WHEN COUNTY = ('MADISON')THEN 25
			WHEN COUNTY = ('MONROE')THEN 26
			WHEN COUNTY = ('MONTGOMERY')THEN 27
			WHEN COUNTY = ('NASSAU')THEN 28
			WHEN COUNTY = ('NIAGARA')THEN 29
			WHEN COUNTY = ('ONEIDA') THEN 30
			WHEN COUNTY = ('ONONDAGA')THEN 31
			WHEN COUNTY = ('ONTARIO') THEN 33
			WHEN COUNTY = ('ORANGE') THEN 33
			WHEN COUNTY = ('ORLEANS')THEN 34
			WHEN COUNTY = ('OSWEGO')THEN 35
			WHEN COUNTY = ('OTSEGO') THEN 36
			WHEN COUNTY = ('PUTNAM')THEN 37
			WHEN COUNTY = ('RENSSELAER') THEN 38
			WHEN COUNTY = ('ROCKLAND')THEN 39
			WHEN COUNTY = ('SARATOGA') THEN 41
			WHEN COUNTY = ('SCHENECTADY') THEN 42
			WHEN COUNTY = ('SCHOHARIE')THEN 43
			WHEN COUNTY = ('SCHUYLER')THEN 44
			WHEN COUNTY = ('SENECA') THEN 45
			WHEN COUNTY = ('ST LAWRENCE') THEN 40
			WHEN COUNTY = ('STEUBEN') THEN 46
			WHEN COUNTY = ('SUFFOLK')THEN 47
			WHEN COUNTY = ('SULLIVAN') THEN 48
			WHEN COUNTY = ('TIOGA') THEN 49
			WHEN COUNTY = ('TOMPKINS') THEN 50
			WHEN COUNTY = ('ULSTER') THEN 51
			WHEN COUNTY = ('WARREN') THEN 52
			WHEN COUNTY = ('WASHINGTON') THEN 53
			WHEN COUNTY = ('WAYNE') THEN 54
			WHEN COUNTY = ('WESTCHESTER') THEN 55
			WHEN COUNTY = ('WYOMING') THEN 56
			WHEN COUNTY = ('YATES') THEN 57
			WHEN COUNTY = ('BRONX')THEN 58
			WHEN COUNTY = ('KINGS (BROOKLYN)')THEN 59
			WHEN COUNTY = ('NEW YORK')THEN 60
			WHEN COUNTY = ('QUEENS')THEN 61
			WHEN COUNTY = ('RICHMOND')THEN 62
		END,
	DateID = YEAR([LAST INSPECTED]) * 10000 + MONTH([LAST INSPECTED]) * 100 + DAY([LAST INSPECTED]),
	[TOTAL # CRITICAL VIOLATIONS],
    [TOTAL #CRIT.  NOT CORRECTED ],
    [TOTAL # NONCRITICAL VIOLATIONS]

FROM FoodFile 


-- Random number generator for Violations ID is the same for each row in the factFoodFile table
-- because the random number is applied to all the rows at the same time
-- This script loops through all the rows and assigns a random number

 --declare the variables
DECLARE @rownum AS INT = 1; -- active row to change
declare @totalrows as int;-- total rows in file
declare @violationsid as int; -- new violations id


set @totalrows = (select count(*) from factFoodFile) -- determine how many rows
print @totalrows -- print total

-- loop through each row
WHILE @rownum <= @totalrows  -- while there are still rows to process
BEGIN
	set @ViolationsID =   (SELECT ceiling(rand()*62))
	-- set a random decimal number between 0 and 1
	-- multiply this number by 62, the number of distinct violations
	-- ceiling rounds decimal up to next integer
	UPDATE factFoodFile
		set ViolationsID = @violationsid --set ViolationsID to new random number
 		from factfoodfile 
		where foodfileid = @rownum;  --for the current row
		SET @rownum = @rownum + 1;  --  increment to get the next row.
END

select * 
from factFoodFile