/*
=============================================================================================
Stored Procedure: Load Silver Layer(Bronze -> Silver)
=============================================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract,Transform,Load) process to populate the 'silver' schema tables from the 'bronze' schema.
Actions Performed:
  -Truncates Silver Tables.
  -Inserts transformed and cleansed data from bronze into silver tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values

Usage Example:
EXEC silver.load_silver;
============================================================================================
*/

create or alter procedure silver.load_silver as
begin
       declare @start_time DATETIME ,@end_time DATETIME ,@batch_start_time DATETIME,@batch_end_time DATETIME;
begin try
print'===============================================';
print 'loading bronze layer';
print'===============================================';

print '----------------------------------------------';
print 'loading CRM tables';
print '----------------------------------------------';

--loading silver.crm_cust_info
SET @start_time=GETDATE();
print'>>Truncating table:silver.crm_cust_info';
 truncate table  silver.crm_cust_info ;

 print'>>Inserting data into:silver.crm_cust_info';
 insert into silver.crm_cust_info(
cst_id,
cst_key,
cst_firstname,
cst_lastname,    
cst_marital_status,
cst_gndr,
cst_create_date
)
select 
cst_id,
cst_key,
Trim(cst_firstname) as cst_first_name,
trim(cst_lastname) as cst_lastname,
case when upper(trim(cst_marital_status))='S' THEN 'Single' when
 upper(trim(cst_marital_status))='M' then 'married'
	 else 'n/a'
	 end cst_marital_status,--normalize marital status values to readable format
case when upper(trim(cst_gndr))='F' then'Female'
	 when upper(trim(cst_gndr))='M' then 'male'
	 else 'n/a'
	 end cst_gndr, --normalize gender values to readable format
cst_create_date
from(
select*,
row_number() over(partition by cst_id  order by cst_create_date desc) as flag_last
from bronze.crm_cust_info
where cst_id is not null
)t
where flag_last=1 --select the most recent record per customer
SET @end_time=GETDATE();
print '>>load duration: ' +cast(DATEDIFF(second,@start_time,@end_time) as nvarchar)+'seconds';
print '>>----------------';

--loading silver.crm_prd_info
SET @start_time=GETDATE();
print'>>Truncating table:silver.crm_prd_info';
 truncate table  silver.crm_prd_info;

 print'>>Inserting data into:silver.crm_prd_info';
INSERT INTO silver.crm_prd_info(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)

select 
prd_id,
replace(substring(prd_key,1,5),'-','_') as cat_id,  --extract category id
substring(prd_key,7,len(prd_key)) as prd_key, --extract product key
prd_nm,
isnull(prd_cost,0) as prd_cost,
case upper(trim(prd_line))
when 'M' then 'mountain'
when 'R' then 'road'
when 'S' then 'Other sales'
when 'T' then 'Touring'
else 'n/a'
end as prd_line,  --map product line codes to descriptive values
prd_start_dt,
DATEADD(
    DAY,
    -1,
    TRY_CAST(
        LEAD(prd_start_dt) OVER (
            PARTITION BY prd_key
            ORDER BY prd_start_dt
        ) AS DATE
    )
) AS prd_end_dt --calc end datw as one day before the next start date
from bronze.crm_prd_info  
SET @end_time=GETDATE();
print '>>load duration: ' +cast(DATEDIFF(second,@start_time,@end_time) as nvarchar)+'seconds';
print '>>----------------';


--loading silver.crm_sales-details
SET @start_time=GETDATE();
print'>>Truncating table:silver.crm_sales_detailsils';
truncate table  silver.crm_sales_details;
 print'>>Inserting data into:crm_sales_details';
 insert into silver.crm_sales_details(
 sls_ord_num ,
    sls_prd_key, 
    sls_cust_id , 
    sls_order_dt ,
    sls_ship_dt,
    sls_due_dt ,
    sls_sales ,
    sls_quantity,
    sls_price
)
select 
sls_ord_num ,
    sls_prd_key ,
    sls_cust_id ,
    case when sls_order_dt=0 or len(sls_order_dt)<> 8 then null
    else cast(cast(sls_order_dt as varchar) as date)
    end sls_order_dt,
 case when  sls_ship_dt=0 or len( sls_ship_dt)<> 8 then null
    else cast(cast( sls_ship_dt as varchar) as date)
    end sls_ship_dt,
    case when  sls_due_dt =0 or len( sls_due_dt )<> 8 then null
    else cast(cast( sls_due_dt as varchar) as date)
    end sls_due_dt ,
    case when sls_sales is null or sls_sales<=0 or sls_sales <> sls_quantity*abs(sls_price) then sls_quantity*abs(sls_price)
    else sls_sales 
    end as sls_sales,--recalculate sales if original value is missing or incorrect
    sls_quantity,
    case when sls_price is null or sls_price<=0 
    then sls_sales/nullif(sls_quantity,0)
    else sls_price
    end as sls_price--derive price if original value is invalid
  from bronze.crm_sales_details
  SET @end_time=GETDATE();
print '>>load duration: ' +cast(DATEDIFF(second,@start_time,@end_time) as nvarchar)+'seconds';
print '>>----------------';

  
--loading silver.erp_cust_az12
SET @start_time=GETDATE();
print'>>Truncating table:silver.erp_cust_az12'
 truncate table  silver.erp_cust_az12;

 print'>>Inserting data into:silver.erp_cust_az12';
insert into silver.erp_cust_az12(cid,bdate,gen) 
select 
case when cid like 'NAS%' then substring(cid,4,len(cid)) --remove 'NAS' prefix if present
else cid
end as cid,
case when bdate>getdate() then null 
else bdate
end as bdate, --set future birthdates to null
case when upper(trim(gen)) in ('F','FEMALE') THEN 'female'
     when upper(trim(gen)) in ('M','MALE') then 'male'
     else 'n/a'
     end as gen --normalize gender values and handle unknown cases
from bronze.erp_cust_az12
SET @end_time=GETDATE();
print '>>load duration: ' +cast(DATEDIFF(second,@start_time,@end_time) as nvarchar)+'seconds';
print '>>----------------';

--loading silver.ero_loac_a101
SET @start_time=GETDATE();
print'>>Truncating table:silver.erp_loc_a101';
 truncate table  silver.erp_loc_a101;

 print'>>Inserting data into:silver.erp_loc_a101';
insert into silver.erp_loc_a101(cid,cntry)
select
replace(cid,'-','') cid, 
case when trim(cntry)='DE' then 'GERMANY'
when trim(cntry) IN ('US','USA') then 'united states'
when trim(cntry)='' or cntry is null then 'n/a'
else trim(cntry)
end as cntry --normalize and handle missing or blank country codes
from bronze.erp_loc_a101
SET @end_time=GETDATE();
print '>>load duration: ' +cast(DATEDIFF(second,@start_time,@end_time) as nvarchar)+'seconds';
print '>>----------------';


--loading silver.erp_px_cat_g1v2
SET @start_time=GETDATE();
print'>>Truncating table:silver.erp_px_cat_g1v2'
 truncate table  silver.erp_px_cat_g1v2;

 print'>>Inserting data into:silver.erp_px_cat_g1v2';
insert into silver.erp_px_cat_g1v2(id,cat,subcat,maintenance)
select 
id,
cat,
subcat,
maintenance
from bronze.erp_px_cat_g1v2
SET @end_time=GETDATE();
print '>>load duration: ' +cast(DATEDIFF(second,@start_time,@end_time) as nvarchar)+'seconds';
print '>>----------------';

SET  @batch_end_time=GETDATE();
PRINT '================================='
PRINT  'loading silver layer is completed';
PRINT ' -total load duration: '+cast(DATEDIFF(second,@batch_start_time,@batch_end_time) as nvarchar)+'seconds';
PRINT '================================='

end try
begin catch
print'==============================================================='

print'error occured during loading silver layer'
print'error message'+error_message();
print'error message+cast(error_number() as nvarchar)';
print'error message+cast(error_state() as nvarchar)';

print'==============================================================='

end catch
end  


/
