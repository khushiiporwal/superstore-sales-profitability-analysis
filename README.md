# Where Does the Profit Go? A Discount Analysis of Superstore Sales (2014–2017)
End-to-end discount and profitability analysis of Superstore retail sales (2014–2017) using MySQL, Power Query, and Power BI.

## Purpose & Overview 
This project explores four years of retail transaction data to uncover the hidden relationship between discounting, product mix, and net profitability. By combining **SQL root-cause analysis** with a **interactive Power BI report**,this case study provides clear, data-backed discount guardrails to stop margin leakage without sacrificing top-line growth.
 
## Tech Stack
The end-to-end analytical pipeline was built using the following tools:
* **MySQL** – Used for data validation, exploratory analysis, CTEs, window functions (`LAG` for YoY monthly comparisons), discount tier segmentation, and order-basket sizing.
* **Power Query** – Used as the ETL layer for data cleaning.
* **Power BI Desktop** – Main visualization platform used to build the 3-page executive report.
* **DAX (Data Analysis Expressions)** – Used for calculated measures ('Profit Margin %', ‘Discount tiers’), dynamic titles, and conditional formatting.
* **Deliverables** – `.sql`scripts, `.xlsx`Power Query file, `.pbix`report, and `.png`dashboard previews.

## Data Source & Validation
* **Source:** Superstore Retail Sample Dataset - *Kaggle* (https://www.kaggle.com/datasets/vivek468/superstore-dataset-final) covering **2014–2017**.
* **Structure:** **9,994 order lines** across **5,009 unique orders**, **793 customers**, **3 categories** (*Technology, Furniture, Office Supplies*), and **17 sub-categories**.
* **Validation:** All SQL queries and Power BI measures were reconciled against exact baseline totals (**\$2,297,200.86** in sales and **\$286,397.02** in profit) prior to analysis

## Highlights 
### 1. Business Problem
While overall sales grew 51.4% over four years, two major anomalies appeared:
* **2015 Profit Paradox:** Sales fell **2.8%** (\$470.5K), yet net profit surged **24.4%** (\$61.6K) and corporate margin jumped from **10.2% to 13.1%**.
* **2017 Margin Compression:** Revenue hit a record **\$733.2K (+20.4%)**, yet overall profit margin slipped from **13.4% to 12.7%**.
* **Core Question:** *Where does revenue grow without profit following, and how much of that gap does discounting explain?*

### 2. Goal of the Project
Find where profit leaks, test whether discounting explains it, and turn the result into a recommendation. 

### 3. Key Findings
* **The 20% Profit Cliff:** Orders at **0% discount** earned a **29.5%** margin (\$321.0K profit) and **1–20%** promotions earned **11.9%** (\$100.8K). Once discounts crossed **20%**, margins turned sharply negative: **-19.7%** in **21–50%** (-\$58.8K) and **-119.2%** in **Above 50%** (-\$76.6K).
* **What Drove 2015 (+24.4% Profit on Lower Sales):** Cutting **\$41.9K** in loss-making **21–50% Machine** deals and shrinking **Above 50% Binder** clearance losses by **\$4.3K** eliminated empty revenue while regular **0–20%** sales added **+\$12.4K** in profit.
* **What Drove 2017 (Record Sales, Lower Margin):** Losses on **21%+** discounted sales rose **52%** (from -\$31.4K to -\$47.6K), driven by **Binders** Above 50% off (-\$15.8K loss, halving its margin from 20.6% to 10.5%), **Tables** in the 21–50% band (-\$10.7K loss), and **Machines** in the 21–50% band (-\$4.3K loss).

### 4. Key Insights & Business Impact
* **Eliminate `Above 50%` Clearance Deals:** Over four years, discounts above 50% lost **-\$76.6K** (~\$19K/year), concentrated in **Binders, Machines, Appliances, and Bookcases**.
* **Tighten `21–50%` Discounts (Tables & Machines):** Tables lost ~33% of sales value every year in the `21–50%` band, while Machines swung back into steep losses in 2017 when `21–50%` deals tripled.

### 5. Power BI Report walkthrough
The final report contains four pages:
* **Business Performance Overview** – Overall KPIs, sales and profit trends, and general business context.
* **Executive Overview–The Anomalies** – Highlights unusual performance changes in 2015 and 2017, along with monthly margin patterns.
* **Category, Subcategory & Discount Deep Dive** – Examines product-level performance and discount patterns.
* **Profit Margin by Discount Band Tooltip** – Compares profitability across discount bands.

## Dashboard Preview


