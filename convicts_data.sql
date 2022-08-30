create database death_row;

USE death_row;

/* view the dataset */
/* this data project is done to explore data gotten from texas on murder executions */


SELECT * 
FROM Tx_deathrow_full 
LIMIT 3;
        
        
/* converting the execution column to the table primary key */
ALTER TABLE tx_deathrow_full ADD
PRIMARY KEY(Execution)

/* the needs to be cleaned as much as possible, column names needs to be renamed for easy accessbiity and readability */
/* remove space from column names */
Alter table 'tx_deathrow_full'  rename 'First Name' to 'First_Name'
Alter table 'tx_deathrow_full'  rename 'Date Received' to 'Date_Recieved'
Alter table 'tx_deathrow_full'  rename 'Age at Execution' to 'Age_at_Execution'
Alter table 'tx_deathrow_full'  rename 'Eye Color' to 'Eye_color'
Alter table 'tx_deathrow_full'  rename 'Native County' to 'Native_county'
Alter table 'tx_deathrow_full'  rename 'Last Statement' to 'Last_Statement'
Alter table 'tx_deathrow_full'  rename 'Highest Education Level' to 'Highest_Education_Level'
Alter table 'tx_deathrow_full'  rename 'Date of Offence' to 'Date_of_offence'


SELECT 
	'Last Name' 
FROM tx_deathrow_full 
LIMIT 3;

/* checking the age range of inmates that have been eecuted */
/* we are looking for people under the age of 18 who have been executed */
SELECT
	First_name, Last_name 
FROM TX_DEATHROW_FULL 
WHERE age_ex <= 18;
/* the query result shows that no one was 18 or less than that age when executed */

SELECT * 
FROM TX_DEATHROW_FULL
LIMIT 3;

SELECT 	First_name, 
		Last_name, 
        Age_ex 
FROM TX_DEATHROW_FULL 
WHERE Age_ex <= 25;
/* the record shows six convicts under the age and within the age of 25 */
/* we want to know thw race and education level of these inmates */

SELECT 	First_name, 
		Last_name, 
        Age_ex, 
        Highest_Education_Level, 
        Race 
FROM TX_DEATHROW_FULL 
WHERE Age_ex <= 25;

/* the query shows that a large percent of convicts within this age category are blacks, with high education level */

/* we want to see their last statements also, maybe there is a sense of remorse about crimes committed */
SELECT 	Execution,  
		First_name, 
		Last_name, 
		Age_ex, 
		Highest_Education_Level, 
		Race, 
		Last_Statement 
FROM TX_DEATHROW_FULL 
WHERE Age_ex <= 25;

/* we want to check Napolean Beazely and Toronto Patterson's last statement */

SELECT	First_name, 
		Last_name, 
		Last_statement 
FROM TX_DEATHROW_FULL
WHERE First_name = 'Napoleon' and Last_name = 'Beazley';

Select 	First_name, 
		Last_name, 
		Last_statement 
FROM TX_DEATHROW_FULL 
WHERE First_name = 'Toronto' and Last_name = 'Patterson';

/* their last statements were quite intriguing, on one hand Patterson was admitting innocence, while Beazely belives justice should be fairer to him.
/* we need to find the date of execution of these two convicts */
Select 	Execution, 
		First_name, 
		Last_name, 
		Execution_date 
FROM TX_DEATHROW_FULL 
WHERE Execution = 279 or Execution = 270;


/* finding convicts that are over the age of 60 at their execution date */
SELECT 	First_name, 
		Last_Name,
        Age_ex 
FROM TX_DEATHROW_FULL 
WHERE Age_ex >= 60;

/* were they arrested a long time ago, or they committed the crime a short while to their execution */
/* checking the date received minus execution date */

    
ALTER TABLE `death_row`.`tx_deathrow_full` 
CHANGE COLUMN `Date_of_Offence` `Date_of_Offence` DATE NULL DEFAULT NULL ;

ALTER TABLE `death_row`.`tx_deathrow_full` 
CHANGE COLUMN `Date_of_ Birth` `Date_of_ Birth` DATE NULL DEFAULT NULL ;


SELECT 	Execution, 
		Execution_date 
FROM TX_DEATHROW_FULL;
/* the data has some inconsistencies, some date of birth, Want to */
/* drop some of these data with some of these inconsistencies, as they would affect exploration */
SELECT * 
FROM TX_DEATHROW_FULL 
WHERE (date_of_birth is null or date_of_birth = '');


SELECT * 
From TX_DEATHROW_FULL Where (Date_of_Offence is null or Date_of_Offence = '');




DELETE 
FROM TX_DEATHROW_FULL 
WHERE (date_of_birth is null or date_of_birth = '');


DELETE 
FROM TX_DEATHROW_FULL
WHERE (Date_of_Offence is null or Date_of_Offence = '');

DELETE 
FROM Tx_deathrow_full 
WHERE (Date_Received is null or Date_Received = '');


ALTER TABLE `death_row`.`tx_deathrow_full` 
CHANGE COLUMN `Date_of_Offence` `Date_of_Offence` DATE NULL DEFAULT NULL ;

ALTER TABLE `death_row`.`tx_deathrow_full` 
CHANGE COLUMN `Date_of_Birth` `Date_of_Birth` DATE NULL DEFAULT NULL ;


ALTER TABLE `death_row`.`tx_deathrow_full` 
CHANGE COLUMN `Date_Received` `Date_Received` DATE NULL DEFAULT NULL ;



SELECT	First_Name, 
		Last_name, 
    year(Date_of_offence) - year(Date_of_Birth) as age_of_crime_commit 
FROM  TX_DEATHROW_FULL 
WHERE age_ex <= 25 

SELECT First_Name, 
		Last_name, 
        year(Date_of_offence) - year(Date_of_Birth) as age_of_crime_commit 
FROM  TX_DEATHROW_FULL;

/* select convicts who were 18 when the crime were commited */
SELECT 	First_Name, 
		Last_name, 
        County,
        year(Date_of_offence) - year(Date_of_Birth) as Age_commit, 
        race,  
        county 
FROM  TX_DEATHROW_FULL
HAVING Age_commit <=18;

SELECT*
FROM TX_DEATHROW_FULL;

/*Taking a deep dive into the education level of the convict */
/* convicts with low education level */
SELECT 	First_Name,
		Last_Name,
		Highest_Education_Level,
        Race,
        Age_Ex
FROM TX_DEATHROW_FULL
WHERE Highest_Education_Level >= 6
Order by Highest_Education_Level DESC;


/* convicts with little or no educational level */
SELECT  First_Name,
		Last_Name,
        Race,
        Highest_Education_Level,
        Age_ex
FROM TX_DEATHROW_FULL
Where Highest_Education_Level <= 6
Order by Highest_Education_Level DESC;
	
/*Convicts who spoke about their innocence */
SELECT First_Name,
	   Last_Name,
       Last_Statement
FROM TX_DEATHROW_FULL
WHERE Last_Statement like '%Innocent%';

SELECT First_Name,
	   Last_Name,
       Age_ex,
       Race,
       Last_Statement
FROM TX_DEATHROW_FULL
WHERE Last_Statement like '%Innocent%';

/*Percentage of convicts who spoke about their innocence */


SELECT County, Count(*) as total_count, Count(*)/(SELECT Count(Last_Statement)
		FROM TX_DEATHROW_FULL
		WHERE Last_Statement like '%Innocent%') as Percentage_Statement_Innocent
FROM TX_DEATHROW_FULL
Group by County;










