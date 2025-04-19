-- Overview
    -- varchar will not waste memory and works like vector
    -- auto_increment will take last row data and increment it by 1
    -- auto_increment will only work on numeric values
    
-- INSERT DATA INTO TABLES
    DROP DATABASE IF EXISTS temp;
    CREATE DATABASE temp;
    USE temp;

    CREATE TABLE customers (
        -- id VARCHAR(8) AUTO_INCREMENT PRIMARY KEY,
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(20)
    );

    -- INSERT INTO customers VALUES
    -- ("atul"),
    -- ("ankit");
    -- above commented query will not work because column count must be same

    INSERT INTO customers VALUES
    (DEFAULT, "Sonal");
    
    INSERT INTO customers (id, name) VALUES
    (DEFAULT, "Salini");

    INSERT INTO customers (name) VALUES
    ("Supriya");

    SELECT * FROM customers;

    DROP DATABASE temp;

    USE sql_store;
    DESCRIBE customers;
    INSERT INTO customers (
        first_name,
        last_name,
        birth_date,
        address,
        city,
        state
    ) 
    VALUES
    (
        'John',
        'Smith',
        '1990-01-01',
        'address',
        'city',
        'CA'
    );

    SELECT * FROM customers;

-- inserting multiple rows
    DESCRIBE shippers;
    INSERT INTO shippers (
        name)
    VALUES 
        ("Shipper1"),
        ("Shipper2"),
        ("Shipper3");
    
    SELECT * FROM shippers;
    DELETE FROM shippers
    WHERE name LIKE "Shipper%";
    SELECT * FROM shippers;

    -- insert three rows in the products table
    DESCRIBE products;
    INSERT INTO products (
        name,
        quantity_in_stock,
        unit_price
    )
    VALUES
        ("Mango", 50, 15),
        ("Lichi", 500, 5),
        ("Guava", 98, 10);
    
    SELECT * FROM products;

-- insert into multiple table or hierarchical rows
    DESCRIBE orders;
    DESCRIBE order_items;

    -- in orders table first four column are not null but of them one is auto_increment and other has default
    -- so both can also be ignored that makes us to give only two column data

    INSERT INTO orders (
        customer_id,
        order_date
    )
    VALUES
        (1, '2019-01-02');

    -- built in function
    SELECT LAST_INSERT_ID();

    -- since all are required column so no need to specify column name
    INSERT INTO order_items
    VALUES
        (LAST_INSERT_ID(), 11, 2, 15);
    
    -- if data to be extracted from other table and used to insert into current table
    INSERT INTO order_items
    SELECT
        (SELECT LAST_INSERT_ID()),
        p.product_id,
        5,
        p.unit_price
    FROM products p
    WHERE name LIKE "lichi";

    SELECT * FROM order_items;

-- copying whole table
    -- by using AS clause
    CREATE TABLE order_archived AS
        SELECT * FROM orders;
        -- this will take every row from orders and put in order_archived
        -- but will ignore any constraints like primary key constraints and auto increment

    -- EXERCISE: create an archive of sql_invoicing.invoices
        -- instead of client id make it client name column and overwrite with client name
        -- also only keep those with any payment made (payment date not null)
    DESCRIBE sql_invoicing.invoices;
    DROP TABLE sql_invoicing.invoice_archived;
    CREATE TABLE sql_invoicing.invoice_archived AS
    SELECT
        i.invoice_id,
        i.number,
        c.name AS client,
        i.invoice_total,
        i.payment_total,
        i.invoice_date,
        i.due_date,
        i.payment_date
    FROM sql_invoicing.invoices i
    JOIN sql_invoicing.clients c
        -- ON i.client_id = c.client_id [correct but if column name is same then use USING clause]
        USING (client_id)
    WHERE i.payment_date IS NOT NULL;
    
    SELECT * FROM sql_invoicing.invoice_archived;

-- update single row
    USE sql_invoicing;

    -- see earlier record
    SELECT *
    FROM invoices
    WHERE invoice_id = 1;

    -- update with new value
    UPDATE invoices
    SET payment_total = 10, payment_date = '2019-03-01'
    WHERE invoice_id = 1;

    -- see new value
    SELECT *
    FROM invoices
    WHERE invoice_id = 1;

    -- reset updation because wrong invoice was updated
    UPDATE invoices
    -- SET payment_total = 0, payment_date = NULL -- it is also correct
    SET payment_total = DEFAULT, payment_date = NULL
    WHERE invoice_id = 1;

    -- see new value
    SELECT *
    FROM invoices
    WHERE invoice_id = 1;

    -- update invoice id 3 for 50% payment on due date
    SELECT *
    FROM invoices
    WHERE invoice_id = 3;
    
    UPDATE invoices
    SET
        payment_total = invoice_total*.5,
        payment_date = due_date
    WHERE invoice_id = 3;

    -- view updated data
    SELECT *
    FROM invoices
    WHERE invoice_id = 3;

-- updating multiple rows
    USE sql_invoicing;

    -- update client_id 3 payment of 50% for all his invoices on due date 
    SELECT * FROM invoices WHERE client_id = 3;

    UPDATE invoices
    SET
        payment_total = invoice_total*.5,
        payment_date = due_date
    WHERE client_id = 3; -- optional if left will update all rows
                         -- all where clause attributes like IN AND etc will also be applicable here
        -- SPECIAL NOTE FOR WORKBENCH ONLY
        -- sometimes while executing in MySQL workbench it might yell and not update
        -- because of safe update option
        -- go to edit->prefrences->SQL Editor-> Untick Safe Updates(present at bottommost)
        -- restart MySQL and go as normal

    SELECT * FROM invoices WHERE client_id = 3;

    -- EXERCISE: write a SQL statement to
    -- give any customers born before 1990 50 extra points
    USE sql_store;
    -- view before update
    SELECT first_name, birth_date, points 
    FROM customers WHERE birth_date < '1990-01-01';

    -- update points
    UPDATE customers
    SET
        points = points + 50
    WHERE birth_date < '1990-01-01';

    -- view after update
    SELECT first_name, birth_date, points 
    FROM customers WHERE birth_date < '1990-01-01';

-- using subqueries in updates
    USE sql_invoicing;
    DESCRIBE clients;
    SELECT client_id FROM clients WHERE name = "Myworks";

    -- view
    SELECT * FROM invoices WHERE client_id = (
        SELECT client_id FROM clients WHERE name = "Myworks"
    );
    
    -- for single row update
    UPDATE invoices
    SET
        payment_total = invoice_total * .5,
        payment_date = due_date
    WHERE client_id = (
        SELECT client_id FROM clients WHERE name = "Myworks"
    );

    -- for multiple rows update
    UPDATE invoices
    SET
        payment_total = invoice_total * .5,
        payment_date = due_date
    WHERE client_id IN (
        SELECT client_id FROM clients WHERE state IN ('CA', 'NY')
    );

    -- view updated data
    SELECT * FROM invoices WHERE client_id = (
        SELECT client_id FROM clients WHERE name = "Myworks"
    );

        -- before updating always check with SELECT clause that what are you going to update

    -- EXERCISE: 
    -- more than 3000 points
    -- update orders table comment to gold

    USE sql_store;

    -- 1: SELECT customer_id, points FROM customers WHERE points > 3000;
    -- view data to update
    SELECT customer_id, comments
    FROM orders 
    WHERE customer_id IN (
        SELECT customer_id 
        FROM customers 
        WHERE points > 3000
    );

    -- update
    UPDATE orders
    SET
        comments = "GOLD"
    WHERE customer_id IN (
        SELECT customer_id 
        FROM customers 
        WHERE points > 3000
    );
    
    -- show updated data
    SELECT customer_id, comments
    FROM orders 
    WHERE customer_id IN (
        SELECT customer_id 
        FROM customers 
        WHERE points > 3000
    );

-- deleting rows
    /*
    DELETE FROM invoices
    WHERE -- optional: will delete everything
    */
    -- before deliting always use SELECT clause to see what will be deleted
    USE sql_invoicing;

    DELETE FROM invoices
    WHERE client_id = (
        SELECT client_id FROM clients WHERE name = "Myworks"
    );
    
    SELECT * FROM invoices WHERE client_id = (
        SELECT client_id FROM clients WHERE name = "Myworks"
    );

