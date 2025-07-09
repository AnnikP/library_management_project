SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;

-- Project Task
--Task 1. Create a New book record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic'
--'6.00', 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 
	   'To Kill a Mockingbird', 
	   'Classic', 
	   6.00, 
	   'yes', 
	   'Harper Lee',
	   'J.B Lippincott & Co.');
	   
SELECT * FROM books;

--Task 2. Update an existing members address.
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';


--Task 3. Delete a record from the issued status table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table

SELECT * FROM issued_status;

DELETE FROM issued_status
WHERE issued_id = 'IS121';

--Task 4. Retrieve All books issued by a specific employee.
--Objective: select all books issued by the employee with emp_id = 'E101'

SELECT * 
FROM issued_status
WHERE issued_emp_id = 'E101';

--Task 5. List members who have issued more than one book
--objective: use group by to find members who have issued more than one book

SELECT 
	issued_emp_id,
	COUNT(issued_id) as total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1;

--CTAS
--Task 6. Create Summary Tables: used CTAS to generate new tables based on query results - each book and total book_issued_cnt
CREATE TABLE book_cnts AS 
SELECT 
	b.isbn,
	b.book_title,
	COUNT(ist.issued_id) as no_issued
FROM books as b
JOIN 
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1, 2;

SELECT *
FROM book_cnts;

--Task 7. Retrieve all books in a specific category
SELECT *
FROM books
WHERE category = 'Classic';

--Task 8. Find total rental income by category
SELECT 
	b.category,
	SUM(b.rental_price) as tot_income,
	COUNT(*)
FROM books as b
JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1;

--Task 9. List members who registered in the last 180 days
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C139', 'Sunless', '123 Forgotton St', '2025-02-14'),
('C140', 'Nephis', '144 Fire St', '2025-04-20');

--Task 10. List employees with their branch managers name and their branch details
SELECT * FROM branch;
SELECT * FROM employees;

SELECT 
	e1.*,
	b.manager_id,
	e2.emp_name as manager
FROM employees as e1
JOIN branch as b
ON b.branch_id = e1.branch_id
JOIN employees as e2
ON b.manager_id = e2.emp_id;

--Task 11. Create a table of books with rental price above a certain threshold 7 USD
CREATE TABLE books_price_greater_than_seven AS
SELECT * FROM books
WHERE rental_price > 7.00;

SELECT * FROM books_price_greater_than_seven;

--Task 12. Retrieve the list of books not yet returned
SELECT * FROM issued_status;
SELECT * FROM return_status;

SELECT DISTINCT ist.issued_book_name 
FROM issued_status as ist
LEFT JOIN 
	return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;



