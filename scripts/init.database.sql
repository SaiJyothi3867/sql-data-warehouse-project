/*
===================================================================================
Create Database and schemas
===================================================================================
Script Purpose:
  this script create a new database name'Datawarehouse' after checking if it already exists.
  If the database exists,it is dropped and recreated. Additionaly,the script sets up three schemas within the database:'bronze','silver','gold'.

  WARNING:
  Running this script will drop the entire 'Datawarehouse' database if it exists
  All data in the database will be permanently deleted.
  Proced with caution and ensure you have proper backups before rumning the script.
*/

USE master;
GO
--Drop and recreate the 'Datawarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases where name='DataWarehouse')
BEGIN 
      ALTER DATABASE datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
      DROP DATABASE Datawarehouse
END;
GO

--CREATE the 'datawarehouse' database
CREATW DATABASE Datawarehouse;
GO

USE Datawarehouse
GO

--CREATE Schemas

  CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

