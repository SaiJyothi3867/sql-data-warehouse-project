/*
==============================================================================
Quality Checks
==============================================================================
Script purpose:
    This script performs quality checks to violate the integrity,consistency,
    and accuracy pf the Gold Layer.These checks ensure:
    -Uniqueness of surrogate keys in dimension tables.
    -Referrential integrity between fact and dimension tables.
    -Validation of relationships in the data model for analytical purpose.

Usage Notes:
-Run these cheks after data loading silver layer.
-investigate and resolve any discrepancies found in the checks
============================================================================
*/

--===================================================================
--Checking 'gold.dim_customers'
--===================================================================
--Check for uniqueness of customer ket in gold.dim_customers
--Expectation:No results
select 
  customer_key,
  count(*) as duplicate_count
  from gold.dim_customers
  group by customer_key
  having count(*)>1;

--====================================================================
--Checking 'gold.product-key'
--====================================================================
--Check for uniqueness of product key in gold.dim_products
--Expectation : No results
select
  product_key,
  count(*) as duplicate_count
  from gold.dim_products
  group by product_key
  having count(*)>1;

--========================================================================
--Checking gold.fact_sales
--========================================================================
--Check the data model connectivity between fact and dimension
select * 
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key=f.customer_key
left join gold.dim_products p
on p.product_key=f.product_key
where p.product_key is null
