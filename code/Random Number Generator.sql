--	rand() generates a decimally random number between 0 and 1
--	If you want the number between two number
--	multiply by the top number 

--	Random number between 0 and 1
Select rand()

--	Random number betweeen 0 and 100
Select floor(rand()*101)

--	Random number between 1 and 62
Select ceiling(rand()*62)

--	Random number between 50 and 100
Select floor(rand()*50) + 50


-- References

--	Random number 
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/rand-transact-sql?view=sql-server-ver15
--	Floor
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/floor-transact-sql?view=sql-server-ver15
--	Ceiling
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/ceiling-transact-sql?view=sql-server-ver15