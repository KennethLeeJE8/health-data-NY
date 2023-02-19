# health-data-NY

The SQL Code takes raw csv data on Health Inspections on each restaurant in the New York State and converts it into a Data Warehouse, allowing the user to access any data needed from the database. The string variables are converted into integer variables in the dataset so that it can be used for further data processing, the categories for the numerical variables are detailed in the code. 



<img width="599" alt="sql_project" src="https://user-images.githubusercontent.com/71307669/219967120-359d1671-1811-4cbe-901a-6f63627064f0.png">
This is an example of the processed Fact file that was generated from the raw csv file, only the important columns were extracted and converted into numerical values for ease of statistical processing. 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

The raw csv can be found on the [Food Service Establishment: Last Inspection](https://health.data.ny.gov/Health/Food-Service-Establishment-Last-Inspection/cnih-y5dw) page of the [NY Health Data] (https://health.data.ny.gov/) website. At the moment, the code used only works on the [Food Service Establishment: Last Inspection](https://health.data.ny.gov/Health/Food-Service-Establishment-Last-Inspection/cnih-y5dw) dataset, however, code to convert other databases on the [NY Health Data] (https://health.data.ny.gov/) website is in the works. 
