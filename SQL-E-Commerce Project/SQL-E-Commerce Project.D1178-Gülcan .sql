
--DAwSQL Session -8 

--E-Commerce Project Solution
--E-Ticaret Projesi Çözümü


--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

---1. Tüm tablolara katılın ve Combine_table adında yeni bir tablo oluşturun. (market_fact, cust_dimen, order_dimen, prod_dimen, shipping_dimen)

--SELECT  *			
--FROM dbo.market_fact A
--	JOIN dbo.cust_dimen B
--		on A.Cust_id=B.Cust_id 
--	JOIN dbo.orders_dimen C
--		ON  A.Ord_id=C.Ord_id
--	JOIN dbo.prod_dimen D
--		ON A.Prod_id=D.Prod_id
--	JOIN dbo.shipping_dimen E
--		ON A.Ship_id=E.Ship_id

    SELECT  A.*,
			B.Customer_Name,B.Customer_Segment,B.Province,B.Region,
			C.Order_Date,C.Order_Priority,
			D.Product_Category,D.Product_Sub_Category,
			E.Order_ID,E.Ship_Date,E.Ship_Mode
	INTO  [combined_table]
    FROM     dbo.market_fact A, dbo.cust_dimen B,dbo.orders_dimen C , dbo.prod_dimen D,dbo.shipping_dimen E  
    WHERE A.Cust_id=B.Cust_id 
						AND A.Ord_id=C.Ord_id
						AND A.Prod_id=D.Prod_id
						AND A.Ship_id=E.Ship_id
						;
		
select * from combined_table
--///////////////////////


--2. Find the top 3 customers who have the maximum count of orders.
---2. Maksimum sipariş sayısına sahip ilk 3 müşteriyi bulun.

SELECT Cust_id,ord_id,order_date,Customer_Name,Ord_id
FROM combined_table
ORDER BY Cust_id,Order_Date

SELECT TOP 3  Cust_id,
			Customer_Name,
			count(Ord_id)  ord_count
FROM combined_table
GROUP BY Cust_id,Customer_Name
ORDER BY ord_count DESC


--/////////////////////////////////


--3.Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.
---3. Combined_table'da, Order_Date ve Ship_Date tarih farkını içeren DaysTakenForDelivery olarak yeni bir sütun oluşturun.
--"DEĞİŞTİRME TABLOSU", "GÜNCELLEME" vb. kullanın.

SELECT *
FROM combined_table;

--SELECT  *,
--		DATEDIFF(DAY,Order_Date,Ship_Date) AS DaysTakenForDelivery
--		INTO combined_table2
--FROM combined_table;
-- BÖYLE DE YAPABİLİRDİM AMA ALTER TABLE, UPDATE DENİLDİĞİ İÇİN 2.YÖNTEMİ TERCİH ETTİM


SELECT * FROM combined_table


CREATE VIEW daystaken as
				(SELECT Cust_id,Ord_id,Ship_id,
						DATEDIFF(DAY,Order_Date,Ship_Date) AS DaysTakenForDelivery
				 FROM combined_table)
		 
ALTER TABLE combined_table ADD DaysTakenForDelivery INT;
UPDATE combined_table
		SET  DaysTakenForDelivery=B.DaysTakenForDelivery 
		FROM combined_table A
				JOIN 
					daystaken as B 
		ON A.Cust_id=B.Cust_id and a.Ship_id=b.Ship_id and a.Ord_id=b.Ord_id;

--////////////////////////////////////


--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"
--4. Siparişinin teslim edilmesi için maksimum süreyi alan müşteriyi bulun.
--"MAX" veya "TOP" kullanın

SELECT  DISTINCT Cust_id,
				 Customer_Name, 
				 DaysTakenForDelivery
FROM combined_table
ORDER BY DaysTakenForDelivery DESC

SELECT TOP 1 Cust_id,
			Customer_Name, 
			DaysTakenForDelivery
FROM combined_table
ORDER BY DaysTakenForDelivery DESC


--////////////////////////////////

--5. Count the total number of unique customers in January and how many of 
--them came back every month over the entire year in 2011
--You can use date functions and subqueries
--5. Ocak ayındaki toplam benzersiz müşteri sayısını ve 2011'de tüm yıl boyunca 
--her ay kaç tanesinin geri geldiğini sayın.
--Tarih fonksiyonlarını ve alt sorguları kullanabilirsiniz.

SELECT  DISTINCT cust_id
FROM combined_table
where datename(month, Order_Date)='January'  and YEAR(Order_Date)=2011

--BURADA MANUEL OLARAK YAPTIĞIM İŞLEMLERİ Bİ ANLAMDA KONTROL ETMİŞ OLDUM. ASLINDA İLK ÖNCE BU KISMLARI YAZARK BAŞLADIM. SONRASINDA BUNU NASIL GENELLEŞTİRİRM DİYE ALTTAKİ KODLARI YAZDIM.


--SELECT  DISTINCT Cust_id,Order_Date
--FROM combined_table
--where cust_id in  (
--				SELECT  DISTINCT cust_id
--				FROM combined_table
--				where datename(month, Order_Date)='January'  and YEAR(Order_Date)=2011 )
--AND  MONTH(Order_Date)=3 and YEAR(Order_Date)=2011

CREATE VIEW CUST_ORD_TBL as
        (SELECT DISTINCT Cust_id,
						Order_Date,
						YEAR(Order_Date) as orderyear,
						MONTH(Order_Date) as ordermonth 		
		 FROM combined_table)
 
SELECT  *FROM CUST_ORD_TBL  ORDER BY Cust_id

---TEKRAR EDEN ORD_ID LERDEN DOLAYI combined_table DA DISTINCT UYGULAYAMAYINCA İŞLEMLERİMİ KOLAYLAŞTIRMAK,
--cust_idleri unique yapıp ilerlemek için yeni bir view oluşturdum:CUST_ORD_TB. Customer ile ilgili sorularda bu viewi kullandım



WITH  comeback_everymonth AS(
				SELECT  DISTINCT Cust_id,
								Order_Date, 
								lead(MONTH(Order_Date),1) over(partition by cust_id order by order_date) AS back_cust_month
				FROM CUST_ORD_TBL
				where cust_id in  (
									SELECT DISTINCT cust_id
									FROM combined_table
									where datename(month, Order_Date)='January'  
									and YEAR(Order_Date)=2011
									)
					 and YEAR(Order_Date)=2011 )
SELECT DISTINCT  back_cust_month, 
				 COUNT( back_cust_month) over(partition by  back_cust_month ) as comingback_cust_count
FROM comeback_everymonth
WHERE  back_cust_month IS NOT NULL



--////////////////////////////////////////////


--6. write a query to return for each user acording to the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions
--6. ilk satın alma ile üçüncü satın alma arasında geçen süreye göre her kullanıcı için iade edilecek bir sorgu yazabilir,
--Müşteri Kimliğine göre artan sırada
--Pencere İşlevleriyle "MIN" kullanın

		--SELECT cust_id,ord_id,prod_id,Order_Date
		--FROM combined_table
		--where cust_id=4

		--SELECT DISTINCT cust_id,ord_id,Order_Date
		--FROM combined_table
		--where cust_id=4

CREATE VIEW Next_ord_1_3 as (
						SELECT  *,LEAD(Order_Date,2) over(partition by cust_id ORDER BY Order_Date) AS order_3
						FROM CUST_ORD_TBL
						)

SELECT Cust_id, 
	Order_Date,
	order_3 ,
	DATEDIFF(DAY,Order_Date,order_3) as order_diff
FROM Next_ord_1_3
WHERE DATEDIFF(DAY,Order_Date,order_3) IS NOT NULL
ORDER BY Cust_id


--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by all customers.
--Use CASE Expression, CTE, CAST and/or Aggregate Functions
---7. Hem 11. ürünü hem de 14. ürünü satın alan müşterileri döndüren bir sorgu yazın,
--ve bu ürünlerin tüm müşteriler tarafından satın alınan toplam ürün sayısına oranı.
--CASE İfadesi, CTE, CAST ve/veya Toplama İşlevlerini Kullanın

--SELECT cust_id,
--	SUM(Order_Quantity)
--FROM combined_table
--where Prod_id=14
--group by cust_id

--SELECT  *
--FROM combined_table
--WHERE Cust_id=56


--	SELECT  Cust_id FROM combined_table	where Prod_id=11
--INTERSECT
--	SELECT Cust_id FROM combined_table where Prod_id=14

SELECT  Cust_id,SUM(Order_Quantity) 
FROM combined_table
WHERE Cust_id IN(
					SELECT  Cust_id FROM combined_table where Prod_id=11
				INTERSECT
					SELECT Cust_id FROM combined_table where Prod_id=14)
	 AND ( Prod_id=11 OR Prod_id=14)
GROUP BY Cust_id
--HANGİ CUST KAÇ ÜRÜN ALDI BUNU GÖRDÜM 

SELECT SUM(Order_Quantity) AS prod1114_quantıty
FROM combined_table
WHERE Cust_id IN(
				SELECT  Cust_id FROM combined_table where Prod_id=11
						INTERSECT
				SELECT Cust_id FROM combined_table where Prod_id=14)
	  AND Prod_id IN (11,14);

--TOPLAN SATILAN PROD_ID 11-14 OLAN ÜRÜN SAYISINI BULDUM

SELECT SUM(Order_Quantity) AS TOTAL_QUANTITY FROM combined_table;
--TOPLAN SATILAN QUANTITY Yİ BULUP İKİ SONUCU ORANLADIM

SELECT  (
		SELECT SUM(Order_Quantity) AS prod1114_quantıty
		FROM combined_table
		WHERE Cust_id IN(
						SELECT  Cust_id FROM combined_table where Prod_id=11
								INTERSECT
						SELECT Cust_id FROM combined_table where Prod_id=14)
			  AND Prod_id IN (11,14)
	   )
       /SUM(Order_Quantity) AS TOTAL_QUANTITY_RATIO 
FROM combined_table;



--/////////////////
--CUSTOMER SEGMENTATION
--MÜŞTERİ SEGMENTASYONU

--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.

---1. Müşterilerin ziyaret günlüklerini aylık olarak tutan bir görünüm oluşturun. (Her log için üç alan tutulur: Cust_id, Year, Month)
--Bu tür tarih fonksiyonlarını kullanın. Daha sonra ihtiyaç duyabileceğiniz sütunları çağırmayı unutmayın.

SELECT  Cust_id,
		--Order_Date ,
		YEAR(Order_Date) orderyear,
		datename(MONTH,Order_Date) ordermonth,
		count(YEAR(Order_Date)) AS Count_order
FROM    (
		SELECT DISTINCT  Cust_id,Order_Date ,YEAR(Order_Date) orderyear ,MONTH(Order_Date) ordermonth
		FROM combined_table 
		) AS CUST_ORD_TBL2  
group by Cust_id, Order_Date ,YEAR(Order_Date),MONTH(Order_Date)
order by Cust_id,Order_Date


--//////////////////////////////////



  --2.Create a �view� that keeps the number of monthly visits by users. (Show separately all months from the beginning  business)
--Don't forget to call up columns you might need later.

  --2.Kullanıcıların aylık ziyaretlerinin sayısını tutan bir "görünüm" oluşturun. (İş başlangıcından itibaren tüm ayları ayrı ayrı gösterin)
--Daha sonra ihtiyaç duyabileceğiniz sütunları çağırmayı unutmayın.

SELECT * FROM CUST_ORD_TBL
order by Cust_id

SELECT cust_id,orderyear, DATENAME(MONTH,Order_Date) order_month
FROM CUST_ORD_TBL
ORDER BY Cust_id


CREATE VIEW order_pivot as  (
			SELECT * FROM
							(SELECT cust_id,
									orderyear,
									DATENAME(MONTH,Order_Date) order_month
							FROM CUST_ORD_TBL)   as A
			PIVOT 
					(
					count(order_month)
					for order_month IN 
								 (
								 [January],[February],[March],[April],[May],[June],
								 [July ],[August],[September],[October],[November],[December]
								 )
					)as pivot_order
								)

select * from order_pivot
order by Cust_id
		
--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can order the months using "DENSE_RANK" function.
--then create a new column for each month showing the next month using the order you have made above. (use "LEAD" function.)
--Don't forget to call up columns you might need later.
--3. Müşterilerin her ziyareti için, ziyaretin bir sonraki ayını ayrı bir sütun olarak oluşturun.
--"DENSE_RANK" fonksiyonunu kullanarak ayları sıralayabilirsiniz.
--daha sonra yukarıda yaptığınız sırayı kullanarak her ay için bir sonraki ayı gösteren yeni bir sütun oluşturun. ("KURŞUN" işlevini kullanın.)
--Daha sonra ihtiyaç duyabileceğiniz sütunları çağırmayı unutmayın.


--with NEXT_ORDER as (
--	 SELECT DISTINCT Cust_id,
--					 Order_Date,
--					 DENSE_RANK() over(partition by cust_id order by order_date) as dense_order
--	 FROM combined_table
--					)
--SELECT  *,
--	 lead(order_date) over(partition by cust_id order by dense_order) AS next_ord
--FROM  NEXT_ORDER


CREATE VIEW Next_Ord as (
							 SELECT DISTINCT Cust_id,
											 Order_Date,
											 DENSE_RANK() over(partition by cust_id order by order_date) as dense_order
							 FROM combined_table
						  )

SELECT  *,
	 lead(order_date) over(partition by cust_id order by dense_order) AS next_ord
FROM  Next_Ord 

					
SELECT Cust_id,Order_Date,next_ord_date
FROM (
		SELECT  *,
			 lead(order_date) over(partition by cust_id order by dense_order) AS next_ord_date
		FROM  Next_Ord ) AS next_ord_tbl
WHERE  next_ord_date  IS NOT NULL

--/////////////////////////////////



--4. Calculate monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.
--4. Her müşteri tarafından iki ardışık ziyaret arasındaki aylık zaman aralığını hesaplayın.
--Daha sonra ihtiyaç duyabileceğiniz sütunları çağırmayı unutmayın.

SELECT * 
FROM (
		SELECT  Cust_id,
				Order_Date,
				lead(order_date) over(partition by cust_id order by order_date) AS  next_ord_date,
				DATEDIFF( MONTH, Order_Date, lead(order_date) over(partition by cust_id order by order_date)) AS order_diff
		FROM CUST_ORD_TBL) AS visits_customer
WHERE  next_ord_date IS NOT NULL
--ORDER BY order_diff DESC


--///////////////////////////////////


--5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.
--For example: 
--Labeled as �churn� if the customer hasn't made another purchase for the months since they made their first purchase.
--Labeled as �regular� if the customer has made a purchase every month.
--Etc.
	
--5.Ortalama zaman boşluklarını kullanarak müşterileri kategorilere ayırın. Size en uygun etiketleme modelini seçin.
--Örneğin:
--Müşteri ilk satın alımından bu yana aylar boyunca başka bir satın alma işlemi yapmadıysa, "kayıp" olarak etiketlenir.
--Müşteri her ay bir satın alma işlemi yaptıysa "düzenli" olarak etiketlenir.
--Vb.

WITH order_labels AS(
			SELECT * 
			FROM (
					SELECT  Cust_id, Order_Date,
					lead(order_date) over(partition by cust_id order by order_date) AS next_ord_date,
					DATEDIFF( MONTH, Order_Date, lead(order_date) over(partition by cust_id order by order_date)) AS order_diff_MONTH
					FROM CUST_ORD_TBL
				 ) AS visits_customer
		   WHERE next_ord_date IS NOT NULL
         )
--SELECT avg(order_diff_MONTH) FROM TBL   --avg(order_diff_MONTH)=8 
SELECT Cust_id,
	   Order_Date,next_ord_date,
	   order_diff_MONTH,
	   CASE WHEN order_diff_MONTH IS NULL THEN 'churn'
			WHEN order_diff_MONTH =0 OR order_diff_MONTH =1  THEN 'regular'
			WHEN order_diff_MONTH BETWEEN 2 AND 8 THEN 'irregular'
			WHEN order_diff_MONTH> 8 THEN 'danger' 
	  END AS ORD_DIFF_LABELS
FROM order_labels


--/////////////////////////////////////

--AYLIK SAKLAMA ORANI
--MONTH-WISE RETENT�ON RATE


--Find month-by-month customer retention rate  since the start of the business.
--İşin başlangıcından bu yana aylık müşteri elde tutma oranını bulun.

--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps
---1. Ay bazında elde tutulan müşteri sayısını bulun. (Zaman boşluklarını kullanabilirsiniz)
--Zaman Boşluklarını Kullanın

--select * from order_pivot
--order by Cust_id
--select orderyear,sum(January) as January,sum(February) as February,sum(March ) as March ,
--				sum(April) as April ,sum(May) as May,sum(June) as June , 
--				sum(July) as July ,sum(August) as August,sum(September) as September,
--				sum(October) as October ,sum(November) as November,sum(December) as December 
--from order_pivot
--group by orderyear

--select DISTINCT Cust_id,ord_id,order_date, month(order_date)
--from combined_table
--WHERE year(order_date)=2009 and  month(order_date)=1
--ORDER BY Cust_id

--		select DISTINCT Cust_id--,order_date, month(order_date)
--		from combined_table
--		WHERE year(order_date)=2009 and  month(order_date)=1
--INTERSECT
--		select DISTINCT Cust_id--,order_date, month(order_date)
--		from combined_table
--		WHERE year(order_date)=2009 and  month(order_date)=2

CREATE VIEW  retention_rate AS 
WITH  NEXT_ORD AS  (
					select *,
							LEAD(order_date) OVER(PARTITION BY Cust_id ORDER BY order_date) next_order,
							year(LEAD(order_date) OVER(PARTITION BY Cust_id ORDER BY order_date) ) as year_ord2,
							month(LEAD(order_date) OVER(PARTITION BY Cust_id ORDER BY order_date) ) as month_ord2
					from CUST_ORD_TBL  ) 
		    SELECT *
			FROM NEXT_ORD
			WHERE  year_ord2 IS NOT NULL AND  orderyear =year_ord2 and month_ord2= 1+ordermonth
			--ORDER BY orderyear,ordermonth
            
SELECT	orderyear,
		ordermonth,
		year_ord2,
		month_ord2,
		COUNT(ordermonth) as nextmonth_ord_cust
FROM retention_rate
group by orderyear,ordermonth,year_ord2,month_ord2
ORDER BY  orderyear

--//////////////////////


--2. Calculate the month-wise retention rate.
---2. Ay bazında elde tutma oranını hesaplayın.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month
--Temel formül: o Ay Bazında Elde Tutma Oranı = 1.0 * İçinde Bulunulan Ayda Elde Tutulan Müşteri Sayısı / İçinde Bulunan Aydaki Toplam Müşteri Sayısı

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.
--İşlemleri tek bir geçici sorgu yerine parçalara bölmek daha kolaydır. Görünüm'ü kullanmanız önerilir.
--İsterseniz CTE veya Alt Sorgu da kullanabilirsiniz.


--You should pay attention to the join type and join columns between your views or tables.
--Görünümleriniz veya tablolarınız arasında birleştirme türüne ve birleştirme sütunlarına dikkat etmelisiniz.

CREATE VIEW  MONTH_WISE AS 
				 WITH  next_order AS  (
									select *,
											LEAD(order_date) OVER(PARTITION BY Cust_id ORDER BY order_date) next_order,
											year(LEAD(order_date) OVER(PARTITION BY Cust_id ORDER BY order_date) ) as year_ord2,
											month(LEAD(order_date) OVER(PARTITION BY Cust_id ORDER BY order_date) ) as month_ord2
									from CUST_ORD_TBL 
									) 
		          SELECT orderyear,
						 ordermonth,
						 year_ord2,month_ord2,
						 COUNT(ordermonth) as nextmonth_ord_cust
				  FROM next_order
				  group by orderyear,ordermonth,year_ord2,month_ord2
							


CREATE VIEW  MONTH_WISE2 AS (
							select  year(order_date) as orderyear2,
									month(order_date) as ordermonth2 ,
									count(DISTINCT Cust_id) AS TOTAL_CUST
							from combined_table
							group by year(order_date),month(order_date))
							--order by orderyear2,ordermonth2


SELECT  a.orderyear,a.ordermonth,a.month_ord2,a.nextmonth_ord_cust,
		b.TOTAL_CUST,
		(1.0*nextmonth_ord_cust/TOTAL_CUST) AS CUST_ORD_RATIO 
FROM MONTH_WISE A
	     RIGHT JOIN
			MONTH_WISE2  B 
ON  A.orderyear=B.orderyear2 AND A.month_ord2=B.ordermonth2


---///////////////////////////////////
--Good luck!