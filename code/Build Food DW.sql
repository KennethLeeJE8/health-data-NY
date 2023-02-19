--
--	Build Food File DW
--
--	JAM
--
--	Description
--

--	Drop Fact table

USE Food
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[factFoodFile]') AND type in (N'U'))
DROP TABLE [dbo].[factFoodFile]
GO
--	Drop Violations Dimension
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dimViolations]') AND type in (N'U'))
DROP TABLE [dbo].[dimViolations]
GO
-- Drop Severity Dimension
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dimSeverity]') AND type in (N'U'))
DROP TABLE [dbo].[dimSeverity]
GO
-- Drop SubCategory
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dimSubCategory]') AND type in (N'U'))
DROP TABLE [dbo].[dimSubCategory]
GO
-- Drop Category
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dimCategory]') AND type in (N'U'))
DROP TABLE [dbo].[dimCategory]
GO

/****** Object:  Table [dbo].[dimInspectionType]    Script Date: 11/16/2021 1:33:03 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dimInspectionType]') AND type in (N'U'))
DROP TABLE [dbo].[dimInspectionType]
GO
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


CREATE TABLE [dbo].[dimCategory](
	CategoryID int IDENTITY(1,1) NOT NULL,
		CONSTRAINT PK_dimCategory_CategoryID PRIMARY KEY CLUSTERED (CategoryID),
	CategoryDescription varchar(50)
)
GO
INSERT INTO dimCategory
VALUES
('SED Summer Feeding Prog.'),
('SOFA Food Service'),
('Institutional Food Service'),
('Food Service Establishment')

INSERT INTO dimCategory
SELECT DISTINCT LEFT(Description,CHARINDEX('-', DESCRIPTION)-2)
FROM FoodFile
GO

--	Create dimSubCategory


CREATE TABLE [dbo].[dimSubCategory](
	SubCategoryID int IDENTITY(1,1) NOT NULL,
		CONSTRAINT PK_dimSubCategory_SubCategoryID PRIMARY KEY CLUSTERED (SubCategoryID),
	SubCategoryDescription varchar(50),
	CategoryID int not null,
		CONSTRAINT FK_dimCategory_dimSubCategory FOREIGN KEY (CategoryID)
		REFERENCES dimCategory (CategoryID)
)
GO

INSERT INTO dimSubCategory
SELECT	distinct substring(description,CHARINDEX('-', DESCRIPTION)+2,100) as SubCategory,
		CategoryID =
			case 
				when description like '%SED Summer Feeding Prog.%' then 1
				when description like'%SOFA Food Service%' then 2
				when description like '%Institutional Food Service%' then 3
				when description like '%Food Service Establishment%' then 4
				else 5
			end
FROM FoodFile

CREATE TABLE [dbo].[dimSeverity](
	SeverityID int NOT NULL,
		CONSTRAINT PK_dimSeverity_SeverityID PRIMARY KEY CLUSTERED (SeverityID),
	SeverityCode varchar(30),
	SeverityDescription varchar(500)
)

INSERT INTO dimSeverity
VALUES
('1','RED','Critical Items'),
('2','BLUE','Non-Critical Items'),
('3','N/A', 'No Violations')


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

CREATE TABLE [dbo].[factFoodFile](
	FoodFileID int IDENTITY(1,1) NOT NULL,
		CONSTRAINT PK_factFoodFile_FoodFileID PRIMARY KEY CLUSTERED (FoodFileID),
	InspectionTypeID int,
		CONSTRAINT FK_dimInspectionType_factFoodFile FOREIGN KEY (InspectionTypeID)
		REFERENCES dimInspectionType (InspectionTypeID),
	CategoryID int NOT NULL,
		CONSTRAINT FK_dimCategory_factFoodFile FOREIGN KEY (CategoryID)
		REFERENCES dimCategory (CategoryID),
	ViolationsID int NOT NULL
		CONSTRAINT FK_dimViolation_factFoodFile FOREIGN KEY (ViolationsID)
		REFERENCES dimViolations (ViolationsID),
	CriticalValues int
)
GO

INSERT INTO factFoodFile
SELECT
	[INSPECTIONTYPEID] =
			case 
				when [INSPECTION TYPE] = 'Inspection' then 1
				else 2
			end,
		CategoryID =
			case 
				when description like '%SED Summer Feeding Prog.%' then 1
				when description like'%SOFA Food Service%' then 2
				when description like '%Institutional Food Service%' then 3
				when description like '%Food Service Establishment%' then 4
				else 5
			end,
	ceiling(rand()*62),
	[TOTAL # CRITICAL VIOLATIONS]
	FROM FoodFile 

--SELECT *
--FROM factFoodFile

--Handing out IDs for the column, since it didn't have unique IDs
DECLARE @val AS INT = 1;
declare @rownum as int;
declare @violationsid as int;
declare @severityID as int;

set @rownum = (select count(*) from factFoodFile)
print @rownum


WHILE @val <= @rownum
BEGIN
	set @ViolationsID =   (SELECT ceiling(rand()*62))
	UPDATE factFoodFile
	set ViolationsID = @violationsid
 	from factfoodfile 
	where foodfileid = @val;
	 	print  @val;
	 SET @val = @val + 1;
		print   @violationsid
		print @severityid
END