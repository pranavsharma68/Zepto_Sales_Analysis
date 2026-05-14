drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

-- Data Exploration

-- Counting the rows

SELECT count(*) From zepto;


-- Sample Data

SELECT * FROM zepto
limit 5;

-- Is there any null values

SELECT * FROM zepto
WHERE category IS NULL
OR
name IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
availableQuantity IS NULL
OR
discountSellingPrice IS NULL
OR
weightInGms IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL
;

-- Checking product categories available 

SELECT DISTINCT(category) FROM zepto
ORDER BY category ASC;

-- Checking how many Products are in stock or out of stock 

SELECT outOfStock , count(category) FROM zepto
GROUP BY outOfStock;

-- checking product names which are present more than once in the dataset

SELECT name,count(sku_id) AS Total_SKUs from zepto
GROUP BY name
HAVING count(sku_id) > 1
Order by count(sku_id) DESC;


-- Data Cleaning

-- Checking products where Price Might be 0

SELECT * FROM zepto
Where mrp = 0 OR discountsellingprice = 0;

DELETE FROM zepto
where mrp = 0;


-- standardizing the format of the prices

UPDATE zepto
set mrp = mrp/100.0,
discountSellingPrice = discountSellingPrice / 100.0;

-- lets solve some business questions 

-- Q1 Find the top 10 best-value products based on the discount percentage.

SELECT name, discountpercent from zepto
ORDER BY discountpercent DESC
LIMIT 10;

-- Q2 what are the products with high mrp but out of stock

SELECT name, max(mrp), outOfStock from zepto
where outOfStock = 'True'
GROUP BY name, outOfStock
Order by max(mrp) DESC;

-- Q3 calcuate Estimated revenue for each category 

SELECT category , sum(discountSellingPrice * availableQuantity) As Estimated_Revenue from zepto
GROUP BY category
ORDER BY Estimated_Revenue;

-- Q4 Find all the products where mrp is greater than 500 and discount is less than 10%

SELECT Distinct(name), mrp, discountpercent from zepto
where mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;


-- Q5 Identify the top 5 categories offering the highest average discount percentage 

SELECT category,Round(AVG(discountpercent),2) AS Highest_Average_Discount_Percentage from zepto
GROUP BY category 
ORDER BY AVG(discountpercent) DESC
Limit 5;


-- Q6 Find Price per gram for products above 100g and sort by the best value

SELECT distinct(name),discountsellingprice,weightingms, Round(discountsellingprice/weightingms,2) AS Price_Per_Gram from zepto
where weightingms > 100
ORDER BY Price_Per_Gram;

-- Q7 Group the products into categories like Low, Medium, Bulk

SELECT DISTINCT name, weightingms, 
CASE WHEN weightingms < 1000 THEN 'Low'
     WHEN weightingms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS Weight_Category
	 from zepto;
--Q8 What is the total inventory weight per category 

SELECT category, SUM(weightingms* availableQuantity) AS Total_Inventory_Weight from zepto
group by category
order by SUM(weightingms) ASC;