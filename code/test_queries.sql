USE Food
GO

------------------------------------------------------------
-- 1) Create a query that shows how all the inspections by severity.  
--    Only show if the total number of violations for a severity is greater than 500

select SeverityDescription, count(ff.foodfileID) as [# of violations]
from (dimViolations v inner join factFoodFile FF on v.ViolationsID = ff.ViolationsID)
                      inner join dimSeverity s on s.SeverityID = v.SeverityID
group by SeverityDescription
having count(ff.foodfileID) > 500

-- 2) Create a query that shows the number of re-inspections by county

select c.CountyName, count(foodfileid) as [# of inspections]
from (dimCounty  c inner join factFoodFile ff on c.CountyID = ff.CountyID)
                   inner join dimInspectionType it on it.InspectionTypeID = ff.InspectionTypeID
where it.InspectionType = 're-inspection'
group by c.CountyName
order by count(foodfileid) desc

-- 3) How many inspections found 'insects' or 'rodents'?
select c.RegionName, c.CountyName, count(f.foodfileid) as [# of inspections]
from (dimViolations v inner join factFoodFile f on v.ViolationsID = f.ViolationsID)
	  inner join dimCounty C on c.CountyID = f.CountyID
where v.ViolationsDescription like '%insects%'
or v.ViolationsDescription like '%rodents%'
group by c.RegionName, c.CountyName
with cube