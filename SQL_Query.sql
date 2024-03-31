
#--1. List Top 3 products based on QuantityAvailable. (productid, productname, QuantityAvailable ).

use fastkart;

SELECT ProductId, ProductName, QuantityAvailable FROM Products
ORDER BY QuantityAvailable DESC
LIMIT 3;

#-- Question. 2

#--2. Display EmailId of those customers who have done more than ten purchases. (EmailId, Total_Transactions).

SELECT EmailId AS Customer_Email_ID, COUNT(QuantityPurchased) AS Total_Transactions FROM PurchaseDetails pd INNER JOIN Products p on p.productid=pd.productid
GROUP by EmailId
HAVING COUNT(QuantityPurchased) > 10;

#-- Question. 3

#--3. List the Total QuantityAvailable category wise in descending order. (Name of the category, QuantityAvailable) 

SELECT CategoryName, SUM(QuantityAvailable) AS Total_Quantity_Available FROM Categories c INNER JOIN Products p on p.CategoryId=c.CategoryId
GROUP by CategoryName
ORDER by SUM(QuantityAvailable) DESC;

#-- Question. 4

#--4.  Display ProductId, ProductName, CategoryName, Total_Purchased_Quantity for the product which has been sold maximum in terms of quantity?

SELECT p.ProductId, ProductName, CategoryName, SUM(QuantityPurchased) AS Total_Purchased_Quantity FROM PurchaseDetails pd INNER JOIN Products p on p.productid=pd.productid 
JOIN Categories c on p.CategoryId=c.CategoryId 
GROUP by p.productid
ORDER by SUM(QuantityPurchased) DESC
LIMIT 1;

#-- Question. 5

#--5. Display the number of male and female customers in fastkart. 

SELECT Gender, COUNT(Gender) AS Customer_Count FROM Users u INNER JOIN Roles r on u.RoleId=r.RoleId
WHERE RoleName = 'Customer'
GROUP BY Gender;

#-- Question. 6

#--6. Display ProductId, ProductName, Price and Item_Classes of all the products where Item_Classes are as follows:
#--   If the price of an item is less than 2,000 then “Affordable”,
#--   If the price of an item is in between 2,000 and 50,000 then “High End Stuff”,
#--   If the price of an item is more than 50,000 then “Luxury”. 

SELECT ProductId, ProductName, Price, 
CASE 
  WHEN Price < 2000 THEN 'Affordable'
  WHEN Price BETWEEN 2000 AND 50000 THEN 'High End Stuff' 
  WHEN Price > 50000 THEN 'Luxury'
END AS Item_Classes 
FROM Products
ORDER BY Price DESC;

#-- Question. 7

#--7. Write a query to display ProductId, ProductName, CategoryName, Old_Price(price) and New_Price as per the following criteria:
#--a. If the category is “Motors”, decrease the price by 3000 
#--b. If the category is “Electronics”, increase the price by 50
#--c. If the category is “Fashion”, increase the price by 150 
#--   For the rest of the categories price remains same. 

SELECT ProductId, ProductName, CategoryName, Price as Old_Price, 
CASE CategoryName
  WHEN 'Motors' THEN Price-3000
  WHEN 'Electronics' THEN Price+50
  WHEN 'Fashion' THEN Price+150
ELSE Price
END AS New_Price FROM Categories c INNER JOIN Products p on p.CategoryId=c.CategoryId;

#-- Question. 8

#--8. Display the percentage of females present among all Users. (Round up to 2 decimal places) Add “%” sign while displaying the percentage. 

SELECT CONCAT(ROUND((SELECT COUNT(Gender) FROM Users
WHERE Gender = 'F') / COUNT(Gender),2),'%') AS Percentage_of_Females FROM Users;

#-- Question. 9

#--9. Display the average balance for both card types for those records only where CVVNumber > 333 and NameOnCard ends with the alphabet “e”.

SELECT CardType, AVG(Balance) FROM CardDetails
WHERE CVVNumber > 333 AND NameOnCard LIKE '%e'
GROUP BY CardType;

#-- Question. 10

#--10.  What is the 2nd most valuable item available which does not belong to the “Motor” category. Value of an item = Price * QuantityAvailable. Display ProductName, CategoryName, value.

SELECT ProductName, CategoryName, (QuantityAvailable*Price) AS Value FROM Categories c INNER JOIN Products p on p.CategoryId=c.CategoryId
WHERE CategoryName NOT IN ('Motors')
ORDER BY Value DESC
LIMIT 1,1;
