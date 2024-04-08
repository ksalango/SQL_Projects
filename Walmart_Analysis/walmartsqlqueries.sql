CREATE TABLE walmart_data (
	store INT,
    weekdate DATE,
    weekly_sales FLOAT,
    holiday_flag INT,
    temperature FLOAT,
    fuel_price FLOAT,
    CPI FLOAT,
    unemployment FLOAT);
    
    
	
LOAD DATA INFILE '/Users/kamiasalango/Desktop/Walmart.csv'
INTO TABLE walmart_data
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(store, weekdate, weekly_sales, holiday_flag, 
temperature, fuel_price, CPI, unemployment);
