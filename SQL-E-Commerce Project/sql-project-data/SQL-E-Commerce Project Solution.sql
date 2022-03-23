
--DAwSQL Session -8 

--E-Commerce Project Solution
--E-Ticaret Projesi Çözümü


--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

---1. Tüm tablolara katılın ve Combine_table adında yeni bir tablo oluşturun. (market_fact, cust_dimen, order_dimen, prod_dimen, shipping_dimen)




--///////////////////////


--2. Find the top 3 customers who have the maximum count of orders.
---2. Maksimum sipariş sayısına sahip ilk 3 müşteriyi bulun.




--/////////////////////////////////



--3.Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.
---3. Combined_table'da, Order_Date ve Ship_Date tarih farkını içeren DaysTakenForDelivery olarak yeni bir sütun oluşturun.
--"DEĞİŞTİRME TABLOSU", "GÜNCELLEME" vb. kullanın.



--////////////////////////////////////


--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"
--4. Siparişinin teslim edilmesi için maksimum süreyi alan müşteriyi bulun.
--"MAX" veya "TOP" kullanın



--////////////////////////////////



--5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
--You can use date functions and subqueries
--5. Ocak ayındaki toplam benzersiz müşteri sayısını ve 2011'de tüm yıl boyunca her ay kaç tanesinin geri geldiğini sayın.
--Tarih fonksiyonlarını ve alt sorguları kullanabilirsiniz.




--////////////////////////////////////////////


--6. write a query to return for each user acording to the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions
--6. ilk satın alma ile üçüncü satın alma arasında geçen süreye göre her kullanıcı için iade edilecek bir sorgu yazabilir,
--Müşteri Kimliğine göre artan sırada
--Pencere İşlevleriyle "MIN" kullanın




--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by all customers.
--Use CASE Expression, CTE, CAST and/or Aggregate Functions
---7. Hem 11. ürünü hem de 14. ürünü satın alan müşterileri döndüren bir sorgu yazın,
--ve bu ürünlerin tüm müşteriler tarafından satın alınan toplam ürün sayısına oranı.
--CASE İfadesi, CTE, CAST ve/veya Toplama İşlevlerini Kullanın



--/////////////////



--CUSTOMER SEGMENTATION
--MÜŞTERİ SEGMENTASYONU


--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.

---1. Müşterilerin ziyaret günlüklerini aylık olarak tutan bir görünüm oluşturun. (Her log için üç alan tutulur: Cust_id, Year, Month)
--Bu tür tarih fonksiyonlarını kullanın. Daha sonra ihtiyaç duyabileceğiniz sütunları çağırmayı unutmayın.




--//////////////////////////////////



  --2.Create a �view� that keeps the number of monthly visits by users. (Show separately all months from the beginning  business)
--Don't forget to call up columns you might need later.

  --2.Kullanıcıların aylık ziyaretlerinin sayısını tutan bir "görünüm" oluşturun. (İş başlangıcından itibaren tüm ayları ayrı ayrı gösterin)
--Daha sonra ihtiyaç duyabileceğiniz sütunları çağırmayı unutmayın.




--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can order the months using "DENSE_RANK" function.
--then create a new column for each month showing the next month using the order you have made above. (use "LEAD" function.)
--Don't forget to call up columns you might need later.
--3. Müşterilerin her ziyareti için, ziyaretin bir sonraki ayını ayrı bir sütun olarak oluşturun.
--"DENSE_RANK" fonksiyonunu kullanarak ayları sıralayabilirsiniz.
--daha sonra yukarıda yaptığınız sırayı kullanarak her ay için bir sonraki ayı gösteren yeni bir sütun oluşturun. ("KURŞUN" işlevini kullanın.)
--Daha sonra ihtiyaç duyabileceğiniz sütunları çağırmayı unutmayın.



--/////////////////////////////////



--4. Calculate monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.
--4. Her müşteri tarafından iki ardışık ziyaret arasındaki aylık zaman aralığını hesaplayın.
--Daha sonra ihtiyaç duyabileceğiniz sütunları çağırmayı unutmayın.






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






--/////////////////////////////////////




--MONTH-WISE RETENT�ON RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps





--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.







---///////////////////////////////////
--Good luck!