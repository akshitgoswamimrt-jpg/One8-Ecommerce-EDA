CREATE DATABASE One8_Sports_Analytics;
use One8_Sports_Analytics;

select * from one8_sports_final_cleaned
select count(*)  as total_columns from one8_sports_final_cleaned

SELECT
    COUNT(*) AS Total_Rows, COUNT(Product_Name) AS Product_Name_Count, COUNT(Brand) AS Brand_Count,
    COUNT(Category) AS Category_Count, COUNT(Price) AS Price_Count, COUNT(Available) AS Available_Count,
    COUNT(Total_Variants) AS Variants_Count,  COUNT(Total_Images) AS Images_Count, COUNT(Tags) AS Tags_Count,
    COUNT(URL) AS URL_Count, COUNT(Price_Range) AS Price_Range_Count
FROM one8_sports_final_cleaned;


SELECT  COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'one8_sports_final_cleaned';


SELECT 
    Available,
    COUNT(*) AS Product_Count
FROM one8_sports_final_cleaned
GROUP BY Available;

ALTER TABLE one8_sports_final_cleaned
ALTER COLUMN Available BIT NOT NULL;

ALTER TABLE one8_sports_final_cleaned
ALTER COLUMN Price DECIMAL(10,2) NOT NULL;


SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'one8_sports_final_cleaned';





-- Section 1: Product & Category Analysis

select category ,  count(Product_Name) as product_count , max(price) as max_price , min(price) as min_price , ROUND(AVG(Price), 2) AS avg_price 
from one8_sports_final_cleaned
group by  category
order by max_price desc 

-- Business Insight 
-- Category-wise product distribution and pricing analysis.

-- Q2: Identify the top 10 most expensive products.

SELECT TOP 10 Product_Name, Category, Price, Price_Range
FROM one8_sports_final_cleaned
ORDER BY Price DESC , Product_Name ASC
-- Business Insight:
-- Premium-priced products are concentrated in the Sneakers category.
-- Boom Rush variants dominate several of the top 10 positions.


-- Q3: Identify the 10 most affordable products.

SELECT TOP 10 Product_Name,Category,Price,Price_Range
FROM one8_sports_final_cleaned
ORDER BY Price ASC, Product_Name ASC;
-- Business Insight 
-- Caps have the lowest average listed price 

-- Q4: Compare average prices across product categories.

SELECT Category, COUNT(*) AS Product_Count, ROUND(AVG(Price), 2) AS Avg_Price
FROM one8_sports_final_cleaned
GROUP BY Category
ORDER BY Avg_Price DESC;

-- Business Insight:
-- Sneakers have the highest average listed price,
-- indicating premium product positioning.

-- Q5: Identify the product categories with the highest and lowest number of listings.
SELECT
    Category,
    COUNT(*) AS Product_Count
FROM one8_sports_final_cleaned
GROUP BY Category
ORDER BY Product_Count DESC;
-- Business Insight:
-- T-Shirts have the highest catalogue presence with 61 listings.
-- Sweatshirts and Tank Tops have the lowest presence, with 3 listings each.

-- Q6: Analyse product distribution across different price ranges.

SELECT
    Price_Range,
    COUNT(*) AS Product_Count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2
    ) AS Product_Percentage
FROM one8_sports_final_cleaned
GROUP BY Price_Range
ORDER BY Product_Count DESC;

-- Business Insight:
-- Identify the price range with the highest product concentration.
-- Analyse whether the catalogue is concentrated in budget,
-- mid-range, or premium-priced products.
-- Q7: Analyse average product variants across categories.

SELECT
    Category,
    COUNT(*) AS Product_Count,
    ROUND(AVG(CAST(Total_Variants AS DECIMAL(10,2))), 2) AS Avg_Variants,
    MAX(Total_Variants) AS Max_Variants
FROM one8_sports_final_cleaned
GROUP BY Category
ORDER BY Avg_Variants DESC;

-- Business Insight:
-- Compare average product variety across categories.
-- Identify categories with the highest and lowest variant availability.
-- Sneakers have the highest maximum variant count.
-- Caps have the lowest variant availability.


-- Q8: Analyse the average number of images available across product categories.

SELECT
    Category,
    COUNT(*) AS Product_Count,
    ROUND(AVG(CAST(Total_Images AS DECIMAL(10,2))), 2) AS Avg_Images,
    MAX(Total_Images) AS Max_Images,
    MIN(Total_Images) AS Min_Images
FROM one8_sports_final_cleaned
GROUP BY Category
ORDER BY Avg_Images DESC;

-- Business Insight:
-- Caps have the highest average image coverage (7.08 images per product).
-- Tank Tops and Jackets have the lowest average image coverage (5 images).
-- Image coverage is relatively consistent across most categories.

-- Q9: Identify the top 10 products with the highest number of images.

SELECT TOP 10 Product_Name, Category,
    Price, Total_Images
FROM one8_sports_final_cleaned
ORDER BY Total_Images DESC, Product_Name ASC;

-- Business Insight:
-- Four products have the highest image coverage, with 9 images each.
-- Caps account for 5 of the 10 products in the top 10 list.
-- Both premium sneakers and affordable caps receive high image coverage.
-- Higher visual coverage is not exclusive to high-priced products.

-- Q.10 

SELECT TOP 10 Product_Name, Category, Price, Total_Images
FROM one8_sports_final_cleaned
ORDER BY Total_Images ASC, Product_Name ASC;

-- Business Insight:
-- Identify products with the lowest visual content coverage.
-- Find products that may need additional product images.
-- Compare image coverage across different product categories.
-- Evaluate whether low image availability affects premium products.


-- Q11: Category-wise Product Availability Analysis

SELECT
    Category, COUNT(*) AS Total_Products, SUM(CASE WHEN Available = 1 THEN 1 ELSE 0 END) AS Available_Products,
    SUM(CASE  WHEN Available = 0 THEN 1 ELSE 0 END) AS Unavailable_Products,
    CAST( SUM(CASE  WHEN Available = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Availability_Percentage,
    CAST( SUM(CASE   WHEN Available = 0 THEN 1  ELSE 0 END) * 100.0 / COUNT(*)  AS DECIMAL(10,2)  ) AS Unavailability_Percentage
FROM one8_sports_final_cleaned
GROUP BY Category
ORDER BY Availability_Percentage DESC;

-- FINAL BUSINESS INSIGHTS:
-- 1. All 250 products are marked as available.
-- 2. Overall product availability is 100%.
-- 3. All 10 categories show identical availability.
-- 4. No unavailable products were identified.
-- 5. Availability analysis has limited discriminatory value
--    because the dataset contains no availability variation.

-- Q12: Category-wise Product Price Variability Analysis

SELECT
    Category, COUNT(*) AS Total_Products,  MIN(Price) AS Minimum_Price,  MAX(Price) AS Maximum_Price,  CAST(AVG(Price) AS DECIMAL(10,2))   AS Average_Price,
CAST(MAX(Price) - MIN(Price) AS DECIMAL(10,2)) AS Price_Range,  CAST(STDEV(Price) AS DECIMAL(10,2))  AS Price_Standard_Deviation
FROM one8_sports_final_cleaned
GROUP BY Category
ORDER BY Price_Standard_Deviation DESC;


-- FINAL BUSINESS INSIGHTS:
-- 1. Sneakers have the highest price variability (₹1,672.52).
-- 2. Sweatshirts and Tank Tops have zero price variability.
-- 3. Pants show the second-highest price variability (₹833.13).
-- 4. T-Shirts have relatively consistent pricing despite
--    having the highest catalogue presence.
-- 5. Leggings have the narrowest non-zero price range (₹800).
-- 6. Categories with only three products require caution
--    before drawing broader pricing conclusions.


-- Q13: Category-wise Average vs Median Price Analysis

WITH Category_Median AS ( SELECT Category, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Price) OVER (PARTITION BY Category) AS Median_Price FROM one8_sports_final_cleaned),
Category_Average AS
( SELECT Category,  COUNT(*) AS Total_Products, CAST(AVG(Price) AS DECIMAL(10,2)) AS Average_Price FROM one8_sports_final_cleaned GROUP BY Category )
SELECT DISTINCT A.Category, A.Total_Products, A.Average_Price,  CAST(M.Median_Price AS DECIMAL(10,2)) AS Median_Price,
CAST( A.Average_Price - M.Median_Price AS DECIMAL(10,2)) AS Average_Median_Difference FROM Category_Average A
JOIN Category_Median M ON A.Category = M.Category
ORDER BY Average_Median_Difference DESC;


-- FINAL BUSINESS INSIGHTS:
-- 1. T-Shirts have the highest positive mean-median difference.
-- 2. Shorts have the highest negative mean-median difference.
-- 3. Six categories have average prices above their median.
-- 4. Two categories have average prices below their median.
-- 5. Sweatshirts and Tank Tops have identical prices across
--    all three products in their respective categories.
-- 6. Mean-median differences indicate potential price
--    distribution asymmetry.


-- Q14: Above-Average Priced Products Within Each Category

WITH Product_Analysis AS ( SELECT Product_Name, Category, Price, AVG(Price) OVER(PARTITION BY Category ) AS Category_Average_Price FROM one8_sports_final_cleaned )
SELECT Product_Name, Category, Price, CAST(Category_Average_Price AS DECIMAL(10,2))  AS Category_Average_Price, CAST(Price - Category_Average_Price AS DECIMAL(10,2) ) AS Price_Difference,
CAST((Price - Category_Average_Price) * 100.0 / Category_Average_Price AS DECIMAL(10,2)) AS Premium_Percentage
FROM Product_Analysis WHERE Price > Category_Average_Price ORDER BY Premium_Percentage DESC;

-- FINAL BUSINESS INSIGHTS:
-- 1. Sneakers contain the highest visible premium percentage (40.85%).
-- 2. Boom Rush listings priced at ₹9,999 are significantly
--    above the Sneakers category average.
-- 3. Polo listings priced at ₹3,499 show a 40.15% premium.
-- 4. Premium-priced listings provide insights into category
--    level price positioning.
-- 5. Multiple colour variants may contribute separate
--    catalogue listings.
-- 6. Premium pricing does not necessarily indicate higher
--    sales, demand or profitability.


-- Q15: Category-wise Top 3 Most Expensive Products

WITH Product_Ranking AS (SELECT Product_Name, Category, Price,DENSE_RANK() OVER(PARTITION BY Category ORDER BY Price DESC) AS Price_Rank, AVG(Price) OVER(PARTITION BY Category) AS Category_Average_Price FROM dbo.one8_sports_final_cleaned)
SELECT Product_Name,Category,Price,Price_Rank,CAST(Category_Average_Price AS DECIMAL(10,2)) AS Category_Average_Price,CAST(Price - Category_Average_Price AS DECIMAL(10,2) ) AS Price_Difference
FROM Product_Ranking WHERE Price_Rank <= 3 ORDER BY Category, Price_Rank;


-- FINAL BUSINESS INSIGHTS:
-- 1. Top three distinct price ranks were identified
--    within each product category.
-- 2. Multiple products share identical price rankings.
-- 3. DENSE_RANK() preserves ties without skipping ranks.
-- 4. The query returned 126 listings due to tied rankings.
-- 5. Premium-priced products can be compared against
--    their respective category averages.
-- 6. Product rankings represent catalogue price positioning,
--    not sales performance or profitability.


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                                             
                                                                       Phase 2: Pricing & Discount Analysis 

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/


-- Q16: Discount Data Availability Audit

-- STEP 1: Check available table columns

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'one8_sports_final_cleaned'
ORDER BY ORDINAL_POSITION;

-- STEP 2: Inspect sample product records
SELECT TOP 10 *
FROM dbo.one8_sports_final_cleaned;


-- Q17: Category-wise Price Range Distribution

SELECT Category, Price_Range, COUNT(*) AS Total_Products,
    CAST(COUNT(*) * 100.0 /SUM(COUNT(*)) OVER(PARTITION BY Category)AS DECIMAL(10,2)) AS Category_Percentage,
    CAST(AVG(Price) AS DECIMAL(10,2)) AS Average_Price FROM one8_sports_final_cleaned
GROUP BY Category, Price_Range
ORDER BY Category, MIN(Price);


-- FINAL BUSINESS INSIGHTS:
-- 1. All Caps listings fall within the ₹0–2,000 segment.
-- 2. Jackets have 81.82% of listings in ₹4,001–6,000.
-- 3. Polo products are concentrated in ₹2,001–4,000 (90.48%).
-- 4. Pants show a relatively balanced price distribution.
-- 5. Sneakers have substantial representation in ₹6,001–8,000.
-- 6. Different product categories demonstrate distinct
--    catalogue pricing positions.


-- Q18: Category-wise Highest and Lowest Priced Products

WITH Product_Extremes AS (SELECT Product_Name, Category, Price, MIN(Price) OVER( PARTITION BY Category ) AS Minimum_Price, MAX(Price) OVER(PARTITION BY Category) AS Maximum_Price FROM dbo.one8_sports_final_cleaned)
SELECT Category, MIN(Minimum_Price) AS Minimum_Price, MAX(Maximum_Price) AS Maximum_Price, MAX(Maximum_Price) - MIN(Minimum_Price) AS Price_Difference FROM Product_Extremes
GROUP BY Category ORDER BY Price_Difference DESC;
-- FINAL BUSINESS INSIGHTS:
-- 1. Sneakers have the widest price range (₹5,000).
-- 2. Pants have the second-highest price range (₹2,900).
-- 3. Leggings have a relatively narrow price range (₹800).
-- 4. Sweatshirts and Tank Tops have zero price variation.
-- 5. Caps have the lowest minimum listed price (₹999).
-- 6. Different categories demonstrate different levels
--    of catalogue price diversity.


-- Q19: Product-wise Price Positioning Against Overall Average

WITH Price_Analysis AS(SELECT Product_Name, Category, Price, AVG(Price) OVER() AS Overall_Average_Price FROM one8_sports_final_cleaned)
SELECT Product_Name,Category,Price,CAST(Overall_Average_Price AS DECIMAL(10,2)) AS Overall_Average_Price,
CAST(Price - Overall_Average_Price AS DECIMAL(10,2)) AS Price_Difference,
CASE
    WHEN Price > Overall_Average_Price THEN 'Above Average'
    WHEN Price < Overall_Average_Price THEN 'Below Average'
    ELSE 'Equal to Average' END AS Price_Positioning
FROM Price_Analysis ORDER BY Price DESC;
-- BUSINESS INSIGHTS:
-- 1. Overall catalogue average price is ₹3,658.97.
-- 2. Boom Rush Sneakers occupy the premium pricing segment.
-- 3. Sneakers dominate the highest-priced product listings.
-- 4. Caps and T-Shirts represent relatively affordable segments.
-- 5. The catalogue has a ₹9,000 difference between
--    its highest and lowest listed product prices.
-- 6. Product-level price positioning helps identify
--    premium and affordable catalogue segments.


-- Q20: Category-wise Above-Average vs Below-Average
-- Product Distribution

WITH Category_Pricing AS (SELECT Product_Name, Category,Price,AVG(Price) OVER(PARTITION BY Category) AS Category_Average_Price FROM one8_sports_final_cleaned)
SELECT Category,COUNT(*) AS Total_Products,CAST(MAX(Category_Average_Price) AS DECIMAL(10,2) ) AS Category_Average_Price,
SUM( CASE 
            WHEN Price > Category_Average_Price  THEN 1 ELSE 0 ENd  ) AS Above_Average_Products,
SUM(CASE
            WHEN Price < Category_Average_Price THEN 1 ELSE 0 END) AS Below_Average_Products,
SUM(CASE
        WHEN Price = Category_Average_Price THEN 1 ELSE 0 END) AS Equal_Average_Products,
CAST(SUM(CASE WHEN Price > Category_Average_Price THEN 1 ELSE 0 END) * 100.0 / COUNT(*)AS DECIMAL(10,2)) AS Above_Average_Percentage,
CAST(SUM(CASE
            WHEN Price < Category_Average_Price THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS Below_Average_Percentage
FROM Category_Pricing GROUP BY Category ORDER BY Above_Average_Percentage DESC


-- BUSINESS INSIGHTS:
-- 1. Shorts have the highest above-average concentration (76.92%).
-- 2. Sneakers have the highest below-average concentration (73.08%).
-- 3. Jackets have 72.73% below-average product concentration.
-- 4. Leggings demonstrate balanced pricing distribution (50:50).
-- 5. Sweatshirts and Tank Tops have identical product prices.
-- 6. Out of 250 products, 108 are above average,
--    136 are below average and 6 equal their category average.

-- Q21: Category-wise Price Variability Analysis

SELECT Category, COUNT(*) AS Total_Products,  CAST(MIN(Price) AS DECIMAL(10,2)) AS Minimum_Price,
CAST(MAX(Price) AS DECIMAL(10,2)) AS Maximum_Price,CAST(AVG(Price) AS DECIMAL(10,2)) AS Average_Price,
CAST(STDEV(Price) AS DECIMAL(10,2)) AS Price_StdDev, CAST(MAX(Price) - MIN(Price) AS DECIMAL(10,2)) AS Price_Range,
CAST( STDEV(Price) * 100.0 / NULLIF(AVG(Price), 0) AS DECIMAL(10,2) ) AS CV_Percentage FROM one8_sports_final_cleaned
GROUP BY Category ORDER BY CV_Percentage DESC;


-- BUSINESS INSIGHTS:

-- 1. Sneakers have the highest pricing variability (CV: 23.56%),
--    indicating significant price differences within the category.

-- 2. Shorts have the second-highest pricing variability (CV: 22.35%),
--    suggesting multiple product pricing levels.

-- 3. Caps show relatively high pricing variability (CV: 22.00%),
--    despite having a comparatively low average price of ₹1,568.23.

-- 4. Jackets have the lowest pricing variability among categories
--    with different product prices (CV: 7.71%),
--    indicating relatively consistent pricing.

-- 5. Sweatshirts and Tank Tops have zero price variability (CV: 0%),
--    because all products within these categories have identical prices.

-- 6. Sneakers have the widest absolute price range (₹5,000),
--    followed by Pants (₹2,900).

-- 7. Overall, Sneakers, Shorts and Caps demonstrate higher
--    relative pricing variability, while Jackets show more stable pricing.

-- 8. Management can use pricing variability to evaluate
--    product segmentation and category-level pricing consistency.


-- Q22: Category-wise Median vs Average Price Analysis

WITH Category_Price_Analysis AS
(
    SELECT
        Product_Name,
        Category,
        Price,

        AVG(Price) OVER(
            PARTITION BY Category
        ) AS Average_Price,

        PERCENTILE_CONT(0.5)
        WITHIN GROUP(
            ORDER BY Price
        ) OVER(
            PARTITION BY Category
        ) AS Median_Price

    FROM dbo.one8_sports_final_cleaned
)

SELECT
    Category,

    COUNT(*) AS Total_Products,

    CAST(
        MAX(Average_Price)
        AS DECIMAL(10,2)
    ) AS Average_Price,

    CAST(
        MAX(Median_Price)
        AS DECIMAL(10,2)
    ) AS Median_Price,

    CAST(
        MAX(Average_Price) - MAX(Median_Price)
        AS DECIMAL(10,2)
    ) AS Average_Median_Difference,

    CASE
        WHEN MAX(Average_Price) > MAX(Median_Price)
            THEN 'Right-Skewed Pricing'

        WHEN MAX(Average_Price) < MAX(Median_Price)
            THEN 'Left-Skewed Pricing'

        ELSE 'Balanced Pricing'
    END AS Pricing_Distribution

FROM Category_Price_Analysis

GROUP BY Category

ORDER BY Average_Median_Difference DESC;


-- BUSINESS INSIGHTS:
-- 1. T-Shirt category shows the highest positive Average-Median difference (106.56),
--    indicating right-skewed pricing.

-- 2. Sneakers have the highest average price (7098.87),
--    while their median price is 6999.00.

-- 3. Pants, Caps and Jackets also show right-skewed pricing,
--    indicating the influence of relatively expensive products.

-- 4. Sweatshirts and Tank Tops demonstrate balanced pricing,
--    as their average and median prices are identical.

-- 5. Polo, Leggings and Shorts show left-skewed pricing,
--    with average prices lower than their median prices.

-- 6. Shorts have the largest negative Average-Median difference (-453.85).

-- 7. Average price alone may not accurately represent typical product pricing;
--    median price provides an additional perspective on price distribution.


-- Q23: Category-wise Price Quartile & IQR Analysis

WITH Category_Quartiles AS
(
    SELECT
        Product_Name,
        Category,
        Price,

        PERCENTILE_CONT(0.25)
        WITHIN GROUP (ORDER BY Price)
        OVER(PARTITION BY Category) AS Q1_Price,

        PERCENTILE_CONT(0.50)
        WITHIN GROUP (ORDER BY Price)
        OVER(PARTITION BY Category) AS Median_Price,

        PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY Price)
        OVER(PARTITION BY Category) AS Q3_Price

    FROM dbo.one8_sports_final_cleaned
)

SELECT
    Category,

    COUNT(*) AS Total_Products,

    CAST(MIN(Q1_Price) AS DECIMAL(10,2))
    AS Q1_Price,

    CAST(MIN(Median_Price) AS DECIMAL(10,2))
    AS Median_Price,

    CAST(MIN(Q3_Price) AS DECIMAL(10,2))
    AS Q3_Price,

    CAST(
        MIN(Q3_Price) - MIN(Q1_Price)
        AS DECIMAL(10,2)
    ) AS IQR,

    CAST(
        MIN(Q3_Price) - MIN(Q1_Price)
        AS DECIMAL(10,2)
    ) AS Middle_50_Percent_Price_Range

FROM Category_Quartiles

GROUP BY Category

ORDER BY IQR DESC;

-- BUSINESS INSIGHTS:
-- 1. Sneakers have the highest IQR (2750), indicating the
--    widest price variation among all categories.

-- 2. Pants have the second-highest IQR (1000), showing
--    considerable pricing diversity.

-- 3. Sneakers have the highest Q3 price (8249),
--    indicating a premium-priced product segment.

-- 4. Sweatshirts and Tank Tops have an IQR of 0,
--    indicating identical product prices within each category.

-- 5. Jackets have a relatively low IQR (250),
--    indicating more consistent product pricing.


-- Q24: Category-wise Price Outlier Detection (IQR Method)

WITH Category_Quartiles AS
(
    SELECT
        Product_Name,
        Category,
        Price,

        PERCENTILE_CONT(0.25)
        WITHIN GROUP (ORDER BY Price)
        OVER(PARTITION BY Category) AS Q1_Price,

        PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY Price)
        OVER(PARTITION BY Category) AS Q3_Price

    FROM dbo.one8_sports_final_cleaned
),

Category_Bounds AS
(
    SELECT
        Product_Name,
        Category,
        Price,
        Q1_Price,
        Q3_Price,

        Q3_Price - Q1_Price AS IQR,

        Q1_Price - 1.5 * (Q3_Price - Q1_Price)
        AS Lower_Bound,

        Q3_Price + 1.5 * (Q3_Price - Q1_Price)
        AS Upper_Bound

    FROM Category_Quartiles
)

SELECT
    Category,

    COUNT(*) AS Total_Products,

    COUNT(CASE
        WHEN Price < Lower_Bound THEN 1
    END) AS Lower_Outliers,

    COUNT(CASE
        WHEN Price > Upper_Bound THEN 1
    END) AS Upper_Outliers,

    COUNT(CASE
        WHEN Price < Lower_Bound OR Price > Upper_Bound
        THEN 1
    END) AS Total_Outliers,

    CAST(
        MIN(Lower_Bound) AS DECIMAL(10,2)
    ) AS Lower_Bound,

    CAST(
        MAX(Upper_Bound) AS DECIMAL(10,2)
    ) AS Upper_Bound,

    CAST(
        COUNT(CASE
            WHEN Price < Lower_Bound OR Price > Upper_Bound
            THEN 1
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS Outlier_Percentage

FROM Category_Bounds

GROUP BY Category

ORDER BY Total_Outliers DESC;

-- BUSINESS INSIGHTS:
-- 1. Caps have the highest number of price outliers (5),
--    with all outliers falling below the lower price boundary.

-- 2. Shorts have the highest outlier percentage (23.08%),
--    indicating significant pricing irregularities.

-- 3. Polo has 3 upper price outliers (7.14%),
--    indicating a few unusually expensive products.

-- 4. Jackets have 2 lower price outliers (18.18%),
--    suggesting some unusually affordable products.

-- 5. Sneakers, Pants, Leggings, T-Shirts, Sweatshirts
--    and Tank Tops have no detected price outliers.



-- Q25: Category-wise Price Segmentation Analysis

WITH Category_Pricing AS
(
    SELECT
        Product_Name,
        Category,
        Price,

        AVG(Price) OVER(
            PARTITION BY Category
        ) AS Category_Average_Price,

        STDEV(Price) OVER(
            PARTITION BY Category
        ) AS Category_StdDev

    FROM dbo.one8_sports_final_cleaned
),

Product_Segmentation AS
(
    SELECT
        Product_Name,
        Category,
        Price,

        Category_Average_Price,
        Category_StdDev,

        CASE
            WHEN Price < Category_Average_Price - Category_StdDev
                THEN 'Budget'

            WHEN Price > Category_Average_Price + Category_StdDev
                THEN 'Premium'

            ELSE 'Mid-Range'
        END AS Price_Segment

    FROM Category_Pricing
)

SELECT
    Category,

    COUNT(*) AS Total_Products,

    SUM(CASE
        WHEN Price_Segment = 'Budget'
        THEN 1 ELSE 0
    END) AS Budget_Products,

    SUM(CASE
        WHEN Price_Segment = 'Mid-Range'
        THEN 1 ELSE 0
    END) AS Mid_Range_Products,

    SUM(CASE
        WHEN Price_Segment = 'Premium'
        THEN 1 ELSE 0
    END) AS Premium_Products,

    CAST(
        SUM(CASE WHEN Price_Segment = 'Budget'
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS Budget_Percentage,

    CAST(
        SUM(CASE WHEN Price_Segment = 'Mid-Range'
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS Mid_Range_Percentage,

    CAST(
        SUM(CASE WHEN Price_Segment = 'Premium'
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS Premium_Percentage

FROM Product_Segmentation

GROUP BY Category

ORDER BY Premium_Percentage DESC;

-- BUSINESS INSIGHTS:
-- 1. Jackets have the highest premium product concentration (27.27%),
--    followed by Sneakers (25.00%).

-- 2. Leggings, Shorts, Sweatshirts and Tank Tops have
--    zero premium products under the defined segmentation criteria.

-- 3. Sweatshirts and Tank Tops have 100% mid-range products,
--    indicating no price variation from their category thresholds.

-- 4. Polo has the highest mid-range product concentration (83.33%),
--    showing relatively concentrated pricing around its category average.

-- 5. Sneakers have the highest number of premium products (13),
--    making them the largest premium segment by product count.


/*
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                           Phase 3: Product Availability Analysis

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- Q26: Overall Product Availability Status Analysis

SELECT
    COUNT(*) AS Total_Products,

    SUM(
        CASE
            WHEN Available = 1 THEN 1 ELSE 0
        END
    ) AS Available_Products,

    SUM(
        CASE
            WHEN Available = 0 THEN 1 ELSE 0
        END
    ) AS Unavailable_Products,

    SUM(
        CASE
            WHEN Available IS NULL THEN 1 ELSE 0
        END
    ) AS NULL_Availability_Products,

    CAST(
        SUM(CASE
            WHEN Available = 1 THEN 1 ELSE 0
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS Available_Percentage,

    CAST(
        SUM(CASE
            WHEN Available = 0 THEN 1 ELSE 0
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS Unavailable_Percentage,

    CAST(
        SUM(CASE
            WHEN Available IS NULL THEN 1 ELSE 0
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS NULL_Availability_Percentage

FROM dbo.one8_sports_final_cleaned;

-- BUSINESS INSIGHTS:
-- 1. All 250 products are marked as available (100% availability).
-- 2. No unavailable products were identified in the catalogue.
-- 3. No NULL values were found in the product availability column.
-- 4. The availability data shows complete consistency across all 250 products.
-- 5. Further inventory-level analysis is required because the dataset
--    currently shows no variation in product availability status.


-- Q27: Category-wise Product Availability Analysis

SELECT
    Category,

    COUNT(*) AS Total_Products,

    SUM(
        CASE
            WHEN Available = 1 THEN 1 ELSE 0
        END
    ) AS Available_Products,

    SUM(
        CASE
            WHEN Available = 0 THEN 1 ELSE 0
        END
    ) AS Unavailable_Products,

    CAST(
        SUM(
            CASE
                WHEN Available = 1 THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS Available_Percentage,

    CAST(
        SUM(
            CASE
                WHEN Available = 0 THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS Unavailable_Percentage

FROM dbo.one8_sports_final_cleaned

GROUP BY Category

ORDER BY Available_Percentage DESC;

-- BUSINESS INSIGHTS:
-- 1. All 10 product categories show 100% product availability.
-- 2. Sneakers have the highest product count with 52 products.
-- 3. T-Shirts have the largest catalogue presence with 61 products.
-- 4. Sweatshirts and Tank Tops have the smallest catalogue presence,
--    with only 3 products each.
-- 5. No category has unavailable products, indicating uniform
--    availability across the entire catalogue.


-- Q28: Category-wise Availability Contribution Analysis

WITH Category_Availability AS
(
    SELECT
        Category,

        COUNT(*) AS Total_Products,

        SUM(
            CASE
                WHEN Available = 1 THEN 1
                ELSE 0
            END
        ) AS Available_Products

    FROM dbo.one8_sports_final_cleaned

    GROUP BY Category
)

SELECT
    Category,

    Total_Products,

    Available_Products,

    CAST(
        Available_Products * 100.0 /
        SUM(Available_Products) OVER()
        AS DECIMAL(10,2)
    ) AS Availability_Contribution_Percentage,

    CAST(
        Total_Products * 100.0 /
        SUM(Total_Products) OVER()
        AS DECIMAL(10,2)
    ) AS Catalogue_Contribution_Percentage

FROM Category_Availability

ORDER BY Availability_Contribution_Percentage DESC;

-- BUSINESS INSIGHTS:
-- 1. T-Shirts contribute the highest share of available products (24.40%).
-- 2. Sneakers contribute the second-highest share (20.80%).
-- 3. T-Shirts, Sneakers and Polo collectively contribute 62% 
--    of the total available product catalogue.
-- 4. Sweatshirts and Tank Tops have the lowest contribution,
--    with 1.20% each.
-- 5. Availability Contribution and Catalogue Contribution are identical
--    because all 250 products are marked as available (100%).


-- Q29: Category-wise Product Availability Ranking

WITH Category_Availability AS
(
    SELECT
        Category,

        COUNT(*) AS Total_Products,

        SUM(
            CASE
                WHEN Available = 1 THEN 1
                ELSE 0
            END
        ) AS Available_Products,

        SUM(
            CASE
                WHEN Available = 0 THEN 1
                ELSE 0
            END
        ) AS Unavailable_Products

    FROM dbo.one8_sports_final_cleaned

    GROUP BY Category
)

SELECT
    Category,
    Total_Products,
    Available_Products,
    Unavailable_Products,

    DENSE_RANK() OVER(
        ORDER BY Available_Products DESC
    ) AS Availability_Rank,

    CAST(
        Available_Products * 100.0 /
        SUM(Available_Products) OVER()
        AS DECIMAL(10,2)
    ) AS Availability_Contribution_Percentage

FROM Category_Availability

ORDER BY Availability_Rank, Category;
-- BUSINESS INSIGHTS:
-- 1. T-Shirts rank 1st with 61 available products (24.40% contribution).
-- 2. Sneakers rank 2nd with 52 products (20.80% contribution).
-- 3. T-Shirts, Sneakers and Polo collectively contribute 62% 
--    of the total available catalogue.
-- 4. Sweatshirts and Tank Tops share Rank 9 because both have 
--    exactly 3 available products.
-- 5. The catalogue is heavily concentrated in T-Shirts, Sneakers 
--    and Polo compared to smaller categories.


-- Q30: Product-wise Availability Status Analysis

SELECT
    Product_Name,
    Category,
    Price,
    Available,

    CASE
        WHEN Available = 1 THEN 'Available'
        WHEN Available = 0 THEN 'Unavailable'
        ELSE 'Unknown'
    END AS Availability_Status,

    COUNT(*) OVER(
        PARTITION BY Available
    ) AS Status_Product_Count,

    CAST(
        COUNT(*) OVER(
            PARTITION BY Available
        ) * 100.0 / COUNT(*) OVER()
        AS DECIMAL(10,2)
    ) AS Status_Percentage

FROM dbo.one8_sports_final_cleaned

ORDER BY
    Available DESC,
    Category,
    Product_Name;
-- BUSINESS INSIGHTS:
-- 1. All 250 products are currently available (100% availability).
-- 2. No unavailable products were identified in the catalogue.
-- 3. Product availability is consistent across all categories.
-- 4. The business currently has zero product availability gaps.
-- 5. Maintaining 100% product availability can improve
--    customer experience and reduce potential lost sales.

-- Q31: Product-wise Availability Performance vs Category Average

WITH Category_Availability AS
(
    SELECT
        Category,
        AVG(CAST(Available AS DECIMAL(10,2))) * 100
            AS Category_Availability_Percentage
    FROM dbo.one8_sports_final_cleaned
    GROUP BY Category
),

Product_Availability AS
(
    SELECT
        Product_Name,
        Category,
        Price,
        Available,
        CASE
            WHEN Available = 1 THEN 'Available'
            WHEN Available = 0 THEN 'Unavailable'
            ELSE 'Unknown'
        END AS Availability_Status
    FROM dbo.one8_sports_final_cleaned
)

SELECT
    P.Product_Name,
    P.Category,
    P.Price,
    P.Availability_Status,

    CAST(
        C.Category_Availability_Percentage
        AS DECIMAL(10,2)
    ) AS Category_Availability_Percentage,

    CASE
        WHEN P.Available = 1 THEN 'Available'
        WHEN P.Available = 0 THEN 'Unavailable'
        ELSE 'Unknown'
    END AS Product_Status

FROM Product_Availability P

INNER JOIN Category_Availability C
    ON P.Category = C.Category

ORDER BY
    C.Category_Availability_Percentage DESC,
    P.Category,
    P.Product_Name;

-- BUSINESS INSIGHTS:
-- 1. All products have an availability status of 'Available'.
-- 2. Every category maintains a 100% availability rate.
-- 3. No individual product falls below its category availability average.
-- 4. There are no identified stock availability gaps across categories.
-- 5. The catalogue demonstrates consistent product availability,
--    although real-time inventory data is needed to verify actual stock.


-- Q32: Category-wise Available vs Unavailable Product Distribution

SELECT
    Category,

    COUNT(*) AS Total_Products,

    SUM(CASE
        WHEN Available = 1 THEN 1
        ELSE 0
    END) AS Available_Products,

    SUM(CASE
        WHEN Available = 0 THEN 1
        ELSE 0
    END) AS Unavailable_Products,

    CAST(
        SUM(CASE
            WHEN Available = 1 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS Available_Percentage,

    CAST(
        SUM(CASE
            WHEN Available = 0 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*)
        AS DECIMAL(10,2)
    ) AS Unavailable_Percentage

FROM dbo.one8_sports_final_cleaned

GROUP BY Category

ORDER BY Unavailable_Percentage DESC,
         Total_Products DESC;
-- BUSINESS INSIGHTS:
-- 1. All 10 categories maintain 100% product availability.
-- 2. T-Shirt has the highest catalogue size with 61 products.
-- 3. Sneakers rank second with 52 products.
-- 4. No category has any unavailable products.
-- 5. The catalogue demonstrates 100% availability,
--    indicating zero inventory gaps in the current dataset.


/*
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                     Phase 4: Product Characteristics & Catalogue Analysis

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/ 
-- Q33: Category-wise Product Characteristics Analysis
SELECT
    Category, COUNT(*) AS Total_Products,

    CAST(AVG(CAST(Total_Variants AS FLOAT)) AS DECIMAL(10,2)) AS Average_Variants,
    MIN(Total_Variants) AS Minimum_Variants,MAX(Total_Variants) AS Maximum_Variants,
    CAST(AVG(CAST(Total_Images AS FLOAT)) AS DECIMAL(10,2)) AS Average_Images,
    MIN(Total_Images) AS Minimum_Images,MAX(Total_Images) AS Maximum_Images
FROM dbo.one8_sports_final_cleaned
GROUP BY Category ORDER BY Average_Variants DESC;


-- BUSINESS INSIGHTS:
-- 1. Sneakers have the highest average variants (6.67), indicating greater
--    product configuration diversity within this category.
--
-- 2. Caps have only 1 variant per product on average, while maintaining
--    the highest average image coverage (7.08 images per product).
--
-- 3. Sneakers have the highest maximum variant count (12) and maximum
--    image count (9), suggesting richer catalogue representation.
--
-- 4. Sweatshirts, Tank Tops, and Jackets have exactly 6 variants per product
--    across their listings, showing consistent variant availability.
--
-- 5. T-Shirts have the largest catalogue (61 products), with an average
--    of 5.95 variants and 5.31 images per product.


-- Q34: Product-Level Catalogue Completeness Analysis

SELECT
    Product_Name,
    Category,
    Price,
    Total_Variants,
    Total_Images,

    CASE
        WHEN Total_Images <= 4 AND Total_Variants <= 5
            THEN 'Low Catalogue Coverage'

        WHEN Total_Images <= 4 OR Total_Variants <= 5
            THEN 'Moderate Catalogue Coverage'

        ELSE 'Good Catalogue Coverage'
    END AS Catalogue_Coverage

FROM dbo.one8_sports_final_cleaned

WHERE Total_Images <= 4
   OR Total_Variants <= 5

ORDER BY
    Total_Images ASC,
    Total_Variants ASC;

-- BUSINESS INSIGHTS:
-- 1. Several Caps listings have only 1 variant, indicating limited
--    product variant diversity in the visible results.
--
-- 2. Quiet Edge - Silver (Sneakers), Woven Cargos - Beige (Pants),
--    and Strike Crest Full Sleeves Polo - Maroon (Polo) have
--    4 images each despite having 6 variants.
--
-- 3. The visible Caps listings have 5 images but only 1 variant,
--    suggesting an opportunity to improve variant representation.
--
-- 4. The visible products are classified as Moderate Catalogue Coverage;
--    none of the visible rows meets the Low Catalogue Coverage criteria.

-- Q35: Price Segment vs Catalogue Characteristics Analysis

SELECT
    CASE
        WHEN Price <= 2000 THEN 'Budget'
        WHEN Price <= 4000 THEN 'Mid-Range'
        ELSE 'Premium'
    END AS Price_Segment,

    COUNT(*) AS Total_Products,

    CAST(AVG(CAST(Total_Variants AS FLOAT)) AS DECIMAL(10,2))
        AS Average_Variants,

    CAST(AVG(CAST(Total_Images AS FLOAT)) AS DECIMAL(10,2))
        AS Average_Images,

    MIN(Total_Images) AS Minimum_Images,
    MAX(Total_Images) AS Maximum_Images

FROM dbo.one8_sports_final_cleaned

GROUP BY
    CASE
        WHEN Price <= 2000 THEN 'Budget'
        WHEN Price <= 4000 THEN 'Mid-Range'
        ELSE 'Premium'
    END

ORDER BY
    CASE
        WHEN
            CASE
                WHEN Price <= 2000 THEN 'Budget'
                WHEN Price <= 4000 THEN 'Mid-Range'
                ELSE 'Premium'
            END = 'Budget' THEN 1
        WHEN
            CASE
                WHEN Price <= 2000 THEN 'Budget'
                WHEN Price <= 4000 THEN 'Mid-Range'
                ELSE 'Premium'
            END = 'Mid-Range' THEN 2
        ELSE 3
    END;
-- BUSINESS INSIGHTS:
-- 1. Premium products have the highest average variants (6.44),
--    compared with 6.00 for Mid-Range and 4.07 for Budget products.
--
-- 2. Budget products have the highest average image coverage (5.93),
--    despite having the lowest average number of variants.
--
-- 3. Mid-Range products have the lowest average image coverage (5.29).
--
-- 4. Premium products have 6.44 average variants, suggesting greater
--    variant diversity in higher-priced catalogue segments.
--
-- 5. The Budget segment contains 69 products, Mid-Range 102 products,
--    and Premium 79 products. Mid-Range is the largest segment.


-- Q36: Product Catalogue Quality Ranking

SELECT
    Product_Name,
    Category,
    Price,
    Total_Variants,
    Total_Images,

    (Total_Variants + Total_Images) AS Catalogue_Quality_Score,

    RANK() OVER (
        ORDER BY (Total_Variants + Total_Images) DESC
    ) AS Catalogue_Rank

FROM dbo.one8_sports_final_cleaned

ORDER BY Catalogue_Rank, Product_Name;

-- BUSINESS INSIGHTS:
-- 1. Seam Pavilion - Black and Seam Pavilion - White share Rank 1
--    with a Catalogue Quality Score of 17.
--
-- 2. Both top-ranked products have 12 variants and 5 images each.
--
-- 3. Seam Pavilion - Off White ranks 3rd with a score of 16,
--    supported by 11 variants and 5 images.
--
-- 4. Multiple Seam Classic colour variants share Rank 4 with
--    a score of 15, having 7 variants and 8 images each.
--
-- 5. Sneakers dominate the visible top-ranking positions,
--    indicating stronger catalogue representation in this category.


-- Q37: Category-wise Catalogue Quality Comparison

SELECT
    Category,

    COUNT(*) AS Total_Products,

    CAST(
        AVG(CAST(Total_Variants AS FLOAT))
        AS DECIMAL(10,2)
    ) AS Average_Variants,

    CAST(
        AVG(CAST(Total_Images AS FLOAT))
        AS DECIMAL(10,2)
    ) AS Average_Images,

    CAST(
        AVG(CAST(Total_Variants + Total_Images AS FLOAT))
        AS DECIMAL(10,2)
    ) AS Average_Catalogue_Score,

    RANK() OVER (
        ORDER BY AVG(
            CAST(Total_Variants + Total_Images AS FLOAT)
        ) DESC
    ) AS Category_Rank

FROM dbo.one8_sports_final_cleaned

GROUP BY Category

ORDER BY Category_Rank;

-- BUSINESS INSIGHTS:
-- 1. Sneakers rank 1 with the highest average catalogue score of 12.67,
--    supported by 6.67 average variants and 6 images.
--
-- 2. Shorts rank 2 with an average catalogue score of 11.38.
--
-- 3. Sweatshirts and Leggings share Rank 3 with an average score of 11.33.
--
-- 4. Caps rank last (10th) with an average score of 8.08,
--    primarily due to their low average variant count of 1.
--
-- 5. T-Shirts have the largest catalogue (61 products) and rank 5
--    with an average catalogue score of 11.26.
--
-- 6. Sneakers show the strongest overall catalogue representation,
--    while Caps offer a potential opportunity for variant enrichment.

/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                       Phase 5 – Advanced Business Analysis

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- Q38: Price vs Catalogue Quality Gap Analysis

WITH Product_Benchmark AS
(
    SELECT
        Product_Name,
        Category,
        Price,
        Total_Variants,
        Total_Images,

        (Total_Variants + Total_Images) AS Catalogue_Score,

        AVG(Price) OVER (
            PARTITION BY Category
        ) AS Category_Avg_Price,

        AVG(
            CAST(Total_Variants + Total_Images AS FLOAT)
        ) OVER (
            PARTITION BY Category
        ) AS Category_Avg_Catalogue_Score

    FROM dbo.one8_sports_final_cleaned
)

SELECT
    Product_Name,
    Category,
    Price,

    CAST(Category_Avg_Price AS DECIMAL(10,2))
        AS Category_Avg_Price,

    Catalogue_Score,

    CAST(Category_Avg_Catalogue_Score AS DECIMAL(10,2))
        AS Category_Avg_Catalogue_Score,

    'High Price - Low Catalogue Score' AS Business_Flag

FROM Product_Benchmark

WHERE Price > Category_Avg_Price
  AND Catalogue_Score < Category_Avg_Catalogue_Score

ORDER BY Price DESC;

-- BUSINESS INSIGHTS:
-- 1. The analysis identified 82 products with above-category-average
--    prices but below-category-average catalogue scores.
--
-- 2. Several Boom Rush sneaker listings are priced at ₹9,999,
--    compared with the Sneakers category average of ₹7,098.87.
--
-- 3. These Boom Rush listings have catalogue scores of 11–12,
--    below the Sneakers category average of 12.67.
--
-- 4. Evolve Carpenter Pants listings priced at ₹5,499 exceed
--    the Pants category average of ₹4,376.78, while their
--    catalogue score of 11 is below the category average of 11.11.
--
-- 5. These products may offer opportunities for catalogue enrichment,
--    although catalogue scores alone do not establish product value
--    or customer satisfaction.

-- Q39: Advanced Product Benchmarking

WITH Product_Benchmark AS
(
    SELECT
        Product_Name,
        Category,
        Price,
        Total_Variants,
        Total_Images,

        (Total_Variants + Total_Images) AS Catalogue_Score,

        AVG(Price) OVER (
            PARTITION BY Category
        ) AS Category_Avg_Price,

        AVG(CAST(
            Total_Variants + Total_Images AS FLOAT
        )) OVER (
            PARTITION BY Category
        ) AS Category_Avg_Catalogue_Score

    FROM dbo.one8_sports_final_cleaned
)

SELECT
    Product_Name,
    Category,
    Price,
    CAST(Category_Avg_Price AS DECIMAL(10,2))
        AS Category_Avg_Price,

    Catalogue_Score,

    CAST(Category_Avg_Catalogue_Score AS DECIMAL(10,2))
        AS Category_Avg_Catalogue_Score,

    CASE
        WHEN Price > Category_Avg_Price
             AND Catalogue_Score > Category_Avg_Catalogue_Score
            THEN 'Above Average on Both'

        WHEN Price > Category_Avg_Price
             AND Catalogue_Score < Category_Avg_Catalogue_Score
            THEN 'High Price - Low Catalogue Score'

        WHEN Price < Category_Avg_Price
             AND Catalogue_Score > Category_Avg_Catalogue_Score
            THEN 'Low Price - High Catalogue Score'

        WHEN Price < Category_Avg_Price
             AND Catalogue_Score < Category_Avg_Catalogue_Score
            THEN 'Below Average on Both'

        ELSE 'At Category Average'
    END AS Product_Benchmark_Status

FROM Product_Benchmark

ORDER BY
    Category,
    Product_Benchmark_Status,
    Price DESC;
-- BUSINESS INSIGHTS:
-- 1. Horizon Pro - Grey Black, Mach Pro - White, and
--    Prime Flo - Corduroy White outperform the Caps category
--    averages in both price and catalogue score.
--
-- 2. These three products have catalogue scores of 9,
--    exceeding the Caps category average of 8.08.
--
-- 3. Several Caps listings, including Prime Flo - Black
--    and Ease Flo - Brown, fall below category averages
--    in both price and catalogue score.
--
-- 4. Mach Pro - Black and Mach Pro - Blue are priced above
--    the Caps category average but have below-average
--    catalogue scores.
--
-- 5. The benchmarking framework identifies different product
--    positioning opportunities within the same category.


-- Q40: Category-Level Competitive Positioning

WITH Category_Benchmark AS
(
    SELECT
        Category,
        COUNT(*) AS Total_Products,

        AVG(Price) AS Average_Price,

        AVG(
            CAST(Total_Variants + Total_Images AS FLOAT)
        ) AS Average_Catalogue_Score

    FROM dbo.one8_sports_final_cleaned

    GROUP BY Category
)

SELECT
    Category,
    Total_Products,

    CAST(Average_Price AS DECIMAL(10,2))
        AS Average_Price,

    CAST(Average_Catalogue_Score AS DECIMAL(10,2))
        AS Average_Catalogue_Score,

    CASE
        WHEN Average_Price >= 5000
             AND Average_Catalogue_Score >= 11.5
            THEN 'Premium Positioning'

        WHEN Average_Price >= 5000
             AND Average_Catalogue_Score < 11.5
            THEN 'High Price - Moderate Catalogue'

        WHEN Average_Price < 5000
             AND Average_Catalogue_Score >= 11.5
            THEN 'Affordable - Strong Catalogue'

        ELSE 'Standard Positioning'
    END AS Category_Positioning

FROM Category_Benchmark

ORDER BY Average_Price DESC;
-- BUSINESS INSIGHTS:
-- 1. Sneakers have the highest average price (₹7,098.87)
--    and the highest catalogue score (12.67), achieving
--    Premium Positioning.
--
-- 2. Jackets have the second-highest average price (₹4,544.45),
--    but their average catalogue score is 11.00.
--
-- 3. T-Shirts have the largest catalogue with 61 products
--    and maintain an average catalogue score of 11.26.
--
-- 4. Caps have the lowest average price (₹1,568.23)
--    and the lowest catalogue score (8.08).
--
-- 5. Sneakers are the only category classified as
--    Premium Positioning under the defined business rules.



-- Q41: Product Portfolio Opportunity Analysis

WITH Product_Analysis AS
(
    SELECT
        Product_Name,
        Category,
        Price,
        Total_Variants,
        Total_Images,

        (Total_Variants + Total_Images) AS Catalogue_Score,

        AVG(Price) OVER (
            PARTITION BY Category
        ) AS Category_Avg_Price,

        AVG(
            CAST(Total_Variants + Total_Images AS FLOAT)
        ) OVER (
            PARTITION BY Category
        ) AS Category_Avg_Catalogue_Score

    FROM dbo.one8_sports_final_cleaned
)

SELECT
    Product_Name,
    Category,
    Price,

    CAST(Category_Avg_Price AS DECIMAL(10,2))
        AS Category_Avg_Price,

    Catalogue_Score,

    CAST(Category_Avg_Catalogue_Score AS DECIMAL(10,2))
        AS Category_Avg_Catalogue_Score,

    'Potential Portfolio Opportunity' AS Opportunity_Flag

FROM Product_Analysis

WHERE Price < Category_Avg_Price
  AND Catalogue_Score > Category_Avg_Catalogue_Score

ORDER BY
    Category,
    Catalogue_Score DESC,
    Price ASC;


-- BUSINESS INSIGHTS:
-- 1. Multiple Caps products qualify as portfolio opportunities,
--    including Zen Flo - Red Black and several Ease Flo variants.
--
-- 2. Ease Flo variants are priced at ₹999, significantly below
--    the Caps category average of ₹1,568.23, while achieving
--    catalogue scores of 9 against the category average of 8.08.
--
-- 3. Zen Flo - Red Black achieves a catalogue score of 10,
--    exceeding the Caps category average of 8.08.
--
-- 4. Essentials All Over Ribbed Leggings variants are priced
--    at ₹2,999, below the Leggings category average of ₹3,524,
--    while achieving a catalogue score of 12 against 11.33.
--
-- 5. These products may represent potential merchandising
--    opportunities based on relative price and catalogue representation.


-- Q42: Advanced Product Portfolio Segmentation

SELECT
    Product_Name,
    Category,
    Price,
    Total_Variants,
    Total_Images,

    CASE
        WHEN Price > 4000 THEN 'Premium'
        WHEN Price > 2000 THEN 'Mid-Range'
        ELSE 'Budget'
    END AS Price_Segment,

    CASE
        WHEN Total_Variants >= 6 THEN 'High Variant Coverage'
        ELSE 'Low Variant Coverage'
    END AS Variant_Segment,

    CASE
        WHEN Total_Images >= 7 THEN 'High Image Coverage'
        ELSE 'Standard Image Coverage'
    END AS Image_Segment,

    CASE
        WHEN Price > 4000
             AND Total_Variants >= 6
             AND Total_Images >= 7
            THEN 'Premium - Strong Catalogue'

        WHEN Price > 4000
             AND (Total_Variants < 6 OR Total_Images < 7)
            THEN 'Premium - Enrichment Opportunity'

        WHEN Price <= 4000
             AND Total_Variants >= 6
             AND Total_Images >= 7
            THEN 'Affordable - Strong Catalogue'

        ELSE 'Standard Portfolio'
    END AS Portfolio_Segment

FROM dbo.one8_sports_final_cleaned

ORDER BY
    Portfolio_Segment,
    Price DESC;

-- BUSINESS INSIGHTS:
-- 1. Several Polo and T-Shirt products qualify as
--    Affordable - Strong Catalogue, with 6 variants
--    and 7–8 product images.
--
-- 2. Jacquard Collar Polo variants (Red and Black) achieve
--    strong catalogue representation with scores of 14
--    (6 variants + 8 images).
--
-- 3. Several Signature 18 Graphic Tee and Signature Back
--    Circle Tee listings also demonstrate strong catalogue
--    representation at relatively affordable prices.
--
-- 4. Multiple Boom Rush sneaker listings priced at ₹9,999
--    are classified as Premium - Enrichment Opportunity
--    because they have only 5 images.
--
-- 5. Premium products may benefit from additional image
--    coverage to improve their catalogue presentation.



-- Q43: Final Integrated Business Analysis

WITH Product_Analysis AS
(
    SELECT
        Product_Name,
        Category,
        Price,
        Total_Variants,
        Total_Images,

        (Total_Variants + Total_Images) AS Catalogue_Score,

        AVG(Price) OVER (
            PARTITION BY Category
        ) AS Category_Avg_Price,

        AVG(
            CAST(Total_Variants + Total_Images AS FLOAT)
        ) OVER (
            PARTITION BY Category
        ) AS Category_Avg_Catalogue_Score

    FROM dbo.one8_sports_final_cleaned
),

Final_Benchmark AS
(
    SELECT
        *,

        CASE
            WHEN Price > Category_Avg_Price
                 AND Catalogue_Score > Category_Avg_Catalogue_Score
                THEN 'High Price - Strong Catalogue'

            WHEN Price > Category_Avg_Price
                 AND Catalogue_Score < Category_Avg_Catalogue_Score
                THEN 'High Price - Weak Catalogue'

            WHEN Price < Category_Avg_Price
                 AND Catalogue_Score > Category_Avg_Catalogue_Score
                THEN 'Low Price - Strong Catalogue'

            WHEN Price < Category_Avg_Price
                 AND Catalogue_Score < Category_Avg_Catalogue_Score
                THEN 'Low Price - Weak Catalogue'

            ELSE 'At Category Average'
        END AS Business_Position

    FROM Product_Analysis
)

SELECT
    Business_Position,

    COUNT(*) AS Total_Products,

    CAST(
        AVG(Price) AS DECIMAL(10,2)
    ) AS Average_Price,

    CAST(
        AVG(CAST(Catalogue_Score AS FLOAT))
        AS DECIMAL(10,2)
    ) AS Average_Catalogue_Score,

    CAST(
        AVG(CAST(Total_Variants AS FLOAT))
        AS DECIMAL(10,2)
    ) AS Average_Variants,

    CAST(
        AVG(CAST(Total_Images AS FLOAT))
        AS DECIMAL(10,2)
    ) AS Average_Images

FROM Final_Benchmark

GROUP BY Business_Position

ORDER BY Total_Products DESC;
-- BUSINESS INSIGHTS:
-- 1. Low Price - Weak Catalogue is the largest segment,
--    containing 87 products (34.8% of the catalogue).
--
-- 2. High Price - Weak Catalogue contains 82 products (32.8%),
--    highlighting a substantial opportunity to improve catalogue
--    representation among higher-priced products.
--
-- 3. Low Price - Strong Catalogue contains 41 products (16.4%),
--    with an average catalogue score of 12.44 and 7.02 images.
--
-- 4. High Price - Strong Catalogue contains 23 products (9.2%),
--    achieving the highest average catalogue score of 12.48.
--
-- 5. Combined, 169 products (67.6%) fall into weak catalogue
--    segments, indicating potential opportunities for catalogue
--    enrichment across both pricing segments.
--
-- 6. Strong catalogue segments average approximately 7 images
--    per product, compared with approximately 5 images in
--    weak catalogue segments.















































































































































































