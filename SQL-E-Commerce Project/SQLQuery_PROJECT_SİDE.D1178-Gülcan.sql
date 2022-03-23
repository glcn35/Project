-- ADD PK s to tables
ALTER TABLE dbo.cust_dimenADD PRIMARY KEY (cust_id)
ALTER TABLE dbo.prod_dimenADD PRIMARY KEY (Prod_id)
ALTER TABLE dbo.orders_dimenADD PRIMARY KEY (Ord_id)
ALTER TABLE dbo.shipping_dimenADD PRIMARY KEY (Ship_id)



-- ADD FK s to tables
ALTER TABLE dbo.market_fact ADD CONSTRAINT FK_Ship FOREIGN KEY(Ship_id) REFERENCES dbo.shipping_dimen (Ship_id)
ALTER TABLE dbo.market_fact ADD CONSTRAINT FK_Ord FOREIGN KEY(Ord_id) REFERENCES  dbo.orders_dimen (Ord_id)
ALTER TABLE dbo.market_fact ADD CONSTRAINT FK_Prod FOREIGN KEY(Prod_id) REFERENCES dbo.prod_dimen (Prod_id)
ALTER TABLE dbo.market_fact ADD CONSTRAINT FK_cust FOREIGN KEY(cust_id) REFERENCES dbo.cust_dimen (cust_id)


--ALTER TABLE dbo.market_fact ADD CONSTRAINT Prod_cust UNIQUE (Prod_id,cust_id,Ship_id,Ord_id)
--SELECT *
--FROM DBO.market_fact
--WHERE Ord_id=1062

ALTER TABLE dbo.market_fact ADD
PRIMARY KEY 
(   [ID]
 )
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY =OFF, ALLOW_ROW_LOCKS = ON,
ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE dbo.market_fact  add ID INT IDENTITY(1,1)

---DATA CLEANÝNG
SELECT *FROM dbo.shipping_dimen
UPDATE dbo.shipping_dimen
SET  Ship_id=REPLACE(Ship_id,'SHP_','') 
WHERE Ship_id IS NOT NULL

SELECT *FROM dbo.shipping_dimen
UPDATE dbo.orders_dimen
SET  Ord_id=REPLACE(Ord_id,'Ord_','') 
WHERE Ord_id IS NOT NULL


SELECT *FROM dbo.prod_dimen
UPDATE dbo.prod_dimen
SET  Prod_id=REPLACE(Prod_id,'Prod_','') 
WHERE Prod_id IS NOT NULL

SELECT *FROM dbo.cust_dimen
UPDATE dbo.cust_dimen
SET  cust_id=REPLACE(cust_id,'Cust_','') 
WHERE cust_id IS NOT NULL

SELECT *FROM dbo.market_fact
UPDATE dbo.market_fact
SET  cust_id=REPLACE(cust_id,'Cust_',''), 
	Prod_id=REPLACE(Prod_id,'Prod_','') ,
	Ord_id=REPLACE(Ord_id,'Ord_','') ,
	Ship_id=REPLACE(Ship_id,'SHP_','') 
WHERE cust_id IS NOT NULL AND Prod_id IS NOT NULL AND Ord_id IS NOT NULL AND Ship_id  IS NOT NULL 