##SQL Data Warehouse and Analytics Project

Welcome to the Data Warehouse and Analytics Project repository! 🚀
An end-to-end SQL Server Datawarehouse Project that integrates CRM() and ERP() data using the Medallion Architecture
(Bronze,Silver,Gold) to deliver business-ready datasets for analytics and reporting.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
##🏗️ Data Architecture
The data architecture for this project follows Medallion Architecture Bronze, Silver, and Gold layers:

![Datawarehouse Architecture](docs/datawarehouse-architecture.png)

1.**Bronze Layer:**
-Stores raw data from the CRM and ERP source systems. 
-Data is ingested directly from CSV Files into SQL Server Database.
2.**Silver Layer:** 
-This layer includes data cleansing, standardization, and normalization processesto prepare data for analysis.
-Resolves Data quality issues
3.**Gold Layer:**
Creates business-ready data modeled into a star schema required for reporting and analytics.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
##📖 Project Overview
This project involves:

Data Architecture: Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.
ETL Pipelines: Extracting, transforming, and loading data from source systems into the warehouse.
Data Modeling: Developing fact and dimension tables(gold layer) from bronze and silver layers optimized for analytical queries.
Analytics & Reporting: Creating SQL-based reports and dashboards for actionable insights.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
🛠️ Technologies and Tools used:
-SQL Server Express-Lightweight server for hosting  SQL database.
-SQL Server Management Studio(SSMS)- GUI for managing and interacting with databases.
-Git Repository-Manage, version, and collaborate on the code efficiently.
-Draw IO-Design data architecture, models, flows, and diagrams.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
🚀 Project Requirements
🎯 Project Vision

The objective of this project is to design and implement a scalable SQL Server Data Warehouse that transforms raw business data into a reliable analytical platform. By integrating data from multiple operational systems, the warehouse provides a single source of truth for business intelligence, performance analysis, and strategic decision-making.

📌 Project Objectives
📥 Multi-Source Data Acquisition
-Extract business data from independent CRM and ERP systems.
-Import structured CSV datasets into the data warehouse environment.
-Establish a consistent and repeatable data ingestion process.

🧹 Data Profiling & Quality Management
-Perform comprehensive data quality assessments before transformation.
-Eliminate duplicate and invalid records.
-Handle missing or inconsistent values.
-Standardize data formats and enforce data integrity to improve analytical reliability.

🔄 Data Transformation & Integration
-Integrate CRM and ERP datasets into a unified analytical model.
-Apply business transformation rules to improve data consistency.
-Build meaningful relationships across customers, products, sales, and supporting business entities.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

📊 Analytics-Oriented Data Modeling
Develop a dimensional model consisting of Fact and Dimension tables.
Optimize the schema for analytical queries and reporting workloads.
Support key business analyses such as:
-Sales Performance
-Customer Behavior
-Product Performance
-Revenue Trends
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
📂 Repository Structure
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file shows all different techniquies and methods of ETL
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
