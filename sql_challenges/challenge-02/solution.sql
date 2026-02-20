-- lession 6
SELECT Domestic_sales, International_sales, Title FROM Boxoffice JOIN Movies ON Boxoffice.Movie_id = Movies.id;

SELECT Domestic_sales, International_sales, Title FROM Boxoffice JOIN Movies ON Movie_id = Id WHERE Domestic_sales < International_Sales;

SELECT Title, Rating FROM Movies JOIN Boxoffice ON Id = Movie_id ORDER BY Rating DESC;

-- lession 7
SELECT DISTINCT Building_name FROM Buildings JOIN Employees ON Buildings.Building_name = Employees.Building WHERE Employees.Building;

SELECT * FROM Buildings;

SELECT DISTINCT Building_name, Role FROM Buildings LEFT JOIN Employees ON Buildings.Building_name = Employees.Building;

-- question
SELECT  p.page_id FROM pages p LEFT JOIN page_likes pl ON p.page_id = pl.page_id WHERE pl.page_id IS NOT NULL ORDER BY p.page_id DESC;