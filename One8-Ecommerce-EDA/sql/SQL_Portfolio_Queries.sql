/*
ONE8 SPORTS — SQL PORTFOLIO QUERIES
Curated selection: 15 representative queries from the full project script.
Database: One8_Sports_Analytics
Table: dbo.one8_sports_final_cleaned
Dataset: 250 One8 Sports product catalogue listings.

Scope note: These queries analyse catalogue listings, listed prices, availability,
product variants and images. They do NOT measure sales, revenue, demand,
conversion or profitability. Catalogue score is Total_Variants + Total_Images,
a simple exploratory proxy rather than a validated quality measure.
*/

USE One8_Sports_Analytics;
GO

-- Q4: Compare average prices across product categories.

SELECT Category, COUNT(*) AS Product_Count, ROUND(AVG(Price), 2) AS Avg_Price
FROM one8_sports_final_cleaned
GROUP BY Category
ORDER BY Avg_Price DESC;

-- Business Insight:
-- Sneakers have the highest average listed price,
-- indicating premium product positioning.

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
