# 🛍️ One8 Sports E-Commerce Product Analytics

An end-to-end **Data Analytics portfolio project** exploring 250 product listings from the One8 Sports e-commerce website using Python, SQL Server, Pandas, NumPy, Matplotlib, and Seaborn.

## 📌 Project Overview

The objective of this project is to analyze product catalogue data to understand pricing patterns, category distribution, product availability, and catalogue characteristics.

The project demonstrates a complete analytical workflow, from web-scraped data cleaning to exploratory analysis, SQL querying, visualization, and business recommendations.

**Important:** This dataset contains product catalogue information, not actual sales or transaction records. Therefore, the analysis focuses on listed prices and catalogue characteristics rather than sales, revenue, or customer behaviour.

## 🎯 Project Objectives

* Analyze product category distribution.
* Examine product pricing patterns.
* Compare average listed prices across categories.
* Explore product availability.
* Analyze product variants and image counts.
* Identify potential catalogue-level opportunities.
* Generate actionable business recommendations.

## 🧰 Tools & Technologies

* Python
* Pandas and NumPy
* Matplotlib and Seaborn
* SQL Server
* Jupyter Notebook
* Web Scraping
* Exploratory Data Analysis (EDA)

## 📂 Repository Structure

```text
One8-Ecommerce-EDA/
│
├── data/
│   └── one8_sports_final_cleaned.csv
│
├── images/
│   └── project_visualizations/
│
├── notebooks/
│   └── One8_Sports_Analytics_2026.ipynb
│
├── sql/
│   ├── One8_Sports_Analytics.sql
│   ├── SQL_Portfolio_Queries.sql
│   └── README.md
│
├── requirements.txt
└── README.md
```

## 📊 Dataset Overview

* Total product listings: **250**
* Source: One8 Sports e-commerce website
* Data type: Product catalogue data

Key attributes include:

* Product Name
* Brand
* Category
* Price
* Availability
* Total Variants
* Total Images
* Tags
* Product URL
* Price Range

## 🔍 Key Analytical Findings

| Metric               | Finding |
| -------------------- | ------: |
| Total Products       |     250 |
| Average Listed Price |  ₹3,659 |
| Median Listed Price  |  ₹2,599 |
| Minimum Listed Price |    ₹999 |
| Maximum Listed Price |  ₹9,999 |
| T-Shirt Listings     |      61 |
| Sneakers Listings    |      52 |
| Polo Listings        |      42 |

### Additional Insights

* Sneakers have the highest average listed price, approximately ₹7,099.
* Caps have the lowest average catalogue score, approximately 8.08.
* Sneakers have the highest average catalogue score, approximately 12.67.
* The correlation between listed price and catalogue score is approximately 0.47.
* 38 potential product-level opportunities were identified.

**Note:** Catalogue score is a simple proxy calculated using total variants plus total images. It is not a validated product-quality or customer-engagement measure.

## 🧠 Project Workflow

1. Data Collection through Web Scraping
2. Data Cleaning and Preprocessing
3. Exploratory Data Analysis using Python
4. SQL Server Database Development
5. Business-Oriented SQL Analysis
6. Advanced Python Analysis
7. Data Visualization
8. Business Insights and Recommendations

## 🗄️ SQL Analysis

The SQL analysis includes 43 business-oriented queries covering different analytical areas.

A separate curated SQL portfolio file highlights selected queries that demonstrate practical SQL skills.

Explore the [`sql`](sql/) folder for the complete scripts.

## 📓 Notebook

The complete Python analysis is available here:

[One8 Sports Analytics 2026 Notebook](notebooks/One8_Sports_Analytics_2026.ipynb)

## 💡 Business Value

This project demonstrates how product catalogue data can help businesses:

* Understand their product assortment.
* Compare pricing across categories.
* Review product availability.
* Identify catalogue information gaps.
* Explore opportunities to improve product presentation.

## ⚠️ Data Limitations

This analysis is based on a snapshot of 250 product listings.

It does not contain actual sales, customer, order, or transaction data. Findings should therefore be interpreted as catalogue-level observations rather than evidence of sales performance or customer demand.

## 👨‍💻 About the Author

**Akshit Goswami**

* 🎓 BS in Data Science & Artificial Intelligence — IIT Madras
* 📍 India
* 💼 Aspiring Data Scientist
* 🧠 Interests: Data Science, Artificial Intelligence, Machine Learning (AI/ML) .
* 📊 Technical Skills: Python, SQL, Pandas, NumPy, Matplotlib and Data Visualization.
* 🔗 GitHub: https://github.com/akshitgoswamimrt-jpg
* 🔗 LinkedIn: https://www.linkedin.com/in/akshitgoswami-iitm/

