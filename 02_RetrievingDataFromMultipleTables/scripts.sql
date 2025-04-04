-- Some hacks to use in MYSQL
    -- LINUX: system rm -f output.txt; tee output.txt; source scripts.sql; notee;
    -- WINDOWS: system del -f output.txt; tee output.txt; source scripts.sql; notee;
    -- it will first remove output.txt file and then initialize it to record result of scripts.sql
    -- always put space after "-- " while commenting otherwise MySQL will yell at you
    

-- Retrieving Data From Multiple Tables

-- INNER JOIN
    SHOW DATABASES;
    USE sql_store;
    -- INNER JOIN where INNER is optional
    -- join customers and orders table
    DESCRIBE customers;
    DESCRIBE orders;
    
    -- retrive order id, first name and last name by joining orders and customers table
    SELECT order_id, first_name, last_name
    FROM orders
    JOIN customers 
        ON orders.customer_id = customers.customer_id;

    -- what will happen if we try to display customer id
    SELECT customer_id
    FROM orders
    JOIN customers 
        ON orders.order_id = customers.customer_id;

    -- Column 'customer_id' in field list is ambiguous
    -- because it is in both table so explicitly tell from where to pick
    SELECT orders.customer_id
    FROM orders
    JOIN customers 
        ON orders.customer_id = customers.customer_id;

    -- use of ALIAS to avoid long table names
    -- once alias is defined you will have to use alias everywhere otherwise syntax error
    SELECT o.customer_id
    FROM orders o
    JOIN customers c 
        ON o.customer_id = c.customer_id;

    -- EXCERCISE
    -- retrive order_items table with product name
    DESCRIBE order_items;
    DESCRIBE products;
    SELECT 
        order_id, 
        o.product_id, 
        p.name AS product_name, 
        quantity, 
        o.unit_price
    FROM order_items o
    JOIN products p ON o.product_id = p.product_id;

    -- here unit_price is in both order_item and products table why?
    -- because unit_price of product can change with time which will reflect in products table
    -- but unit_price of any product will be same for particular order 
    -- because it is reflecting price at which it was purchased in that order


-- JOINING ACROSS DATABASES
    SHOW DATABASES;

    -- join sql_store databases order item table with sql_inventory products table
    -- since we are using sql_store database so for sql_inventory database 
    -- we will be required to use databaseName.tableName and assume it as table of currrent database
     SELECT *
     FROM order_items o
     JOIN sql_inventory.products p
        ON o.product_id = p.product_id;

    -- SELF JOIN
        -- from sql_hr database retrive employees along with their manager name to whom they report to
        -- since in database there is only one manager Yovonnda so his data will not be displayed
        -- because he reports to non and hence reports_to is NULL so on joining it is eliminated
        USE sql_hr;
        SELECT 
            e.employee_id, 
            e.first_name, 
            e.job_title, 
            m.first_name AS manager
        FROM employees e
        JOIN employees m
            ON e.reports_to = m.employee_id;


    -- JOIN More Than Two Tables
        -- join orders table with customerr and status table
        USE sql_store;
        DESCRIBE customers;
        DESCRIBE orders;
        DESCRIBE order_statuses;

        SELECT 
            o.order_id,
            c.first_name, 
            o.order_date, 
            s.name AS status, 
            o.shipped_date,
            o.shipper_id
        FROM orders o
        JOIN order_statuses s
            ON o.status = s.order_status_id
        JOIN customers c
            ON o.customer_id = c.customer_id;

    -- EXERCISE: from sql_invoicing db make payments descriptive
    USE sql_invoicing;
    SHOW tables;
    DESCRIBE clients;
    DESCRIBE payments;
    DESCRIBE payment_methods;

    SELECT 
        p.date,
        p.invoice_id,
        p.amount,
        c.name AS client_name,
        pm.name AS payment_method
    FROM payments p
    JOIN clients c
        ON p.client_id = c.client_id
    JOIN payment_methods pm
        ON p.payment_method = pm.payment_method_id;

    -- COMPOUND JOIN (table with composite key)
        USE sql_store;
        DESCRIBE order_items;
        DESCRIBE orders;
        DESCRIBE order_item_notes;

        -- join order_items table with order_item_notes table
        -- since order_item_notes table have two column as primary key
        -- so it will only join where both are match
        SELECT *
        FROM order_items oi
        JOIN order_item_notes oin
            ON oi.order_id = oin.order_id
            AND oi.product_id = oin.product_id;


-- IMPLICIT JOIN SYNTAX
    -- i.e. using where clause
    SELECT * 
    FROM orders o, customers c
    WHERE o.customer_id = c.customer_id;

    -- if where clause is not written then it will be cross join
    -- and will give count(orders) x count(customers)
    SELECT *
    FROM orders, customers;


-- OUTER JOIN
    -- are of two types LEFT JOIN & RIGHT JOIN
    USE sql_store;
    SHOW tables;
    DESCRIBE customers;
    DESCRIBE orders;

    -- INNER JOIN will show only those customer_id who have ordered
    SELECT 
        c.customer_id,
        c.first_name,
        o.order_id
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    ORDER BY c.customer_id;

    -- what if we want to know all customers along with order id if ther is one
    SELECT
        c.customer_id,
        c.first_name,
        o.order_id
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    ORDER BY c.customer_id;

    -- RIGHT JOIN EXAMPLE but not clear due to data
    SELECT
        c.customer_id,
        c.first_name,
        o.order_id
    FROM customers c
    RIGHT JOIN orders o
        ON c.customer_id = o.customer_id
    ORDER BY c.customer_id;

    -- RIGHT JOIN another example for better clarity
    SELECT
        c.customer_id,
        c.first_name,
        o.order_id
    FROM orders o
    RIGHT JOIN customers c
        ON o.customer_id = c.customer_id
    ORDER BY c.customer_id;

    
    -- EXERCISE: product id, name, quantity
    DESCRIBE products;
    DESCRIBE order_items;

    SELECT
        p.product_id,
        p.name,
        oi.quantity
    FROM products p
    LEFT JOIN order_items oi
        ON p.product_id = oi.product_id;


-- OUTER JOIN BETWEEN MULTIPLE TABLES
    SHOW tables;
    DESCRIBE orders;
    DESCRIBE shippers;

    -- extract customer id, first name, order id and shipper name for all customers
    SELECT
        c.customer_id,
        c.first_name,
        o.order_id,
        o.shipper_id,
        s.name AS shipper_name
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN shippers s
        ON o.shipper_id = s.shipper_id;

    -- try to avoid RIGHT JOIN as best practice
    SHOW tables;
    DESCRIBE orders;
    DESCRIBE shippers;
    DESCRIBE order_statuses;

    
    SELECT
        o.order_date,
        o.order_id,
        c.first_name AS customer,
        s.name AS shipper,
        os.name AS status
    FROM orders o
    LEFT JOIN customers c
        ON o.customer_id = c.customer_id
    LEFT JOIN shippers s
        ON o.shipper_id = s.shipper_id
    LEFT JOIN order_statuses os
        ON o.status = os.order_status_id
    ORDER BY status;

    -- note that database column name are sometime same for different column while sometime it
    -- is different although refering to same thing because in relaity it like that only


-- SELF OUTER JOIN
    -- retrive employees with their managers from employees table in sql_hr
    USE sql_hr;
    SHOW tables;
    DESCRIBE employees;

    SELECT 
        e.employee_id, 
        e.first_name,
        m.first_name AS manager
    FROM employees e
    LEFT JOIN employees m
        ON e.reports_to = m.employee_id;


-- JOIN BY USING CLAUSE (can be used for both INNER & OUTER JOIN)
    -- if the attributes of the table on which we are joining
    -- are of the same title then we can take advantage of USING clause
    USE sql_store;
    DESCRIBE orders;
    DESCRIBE shippers;

    -- extract order id, customer name and shipper name for every order 
    SELECT
        o.order_id,
        c.first_name,
        s.name AS shipper
    FROM orders o
    LEFT JOIN customers c
        -- ON o.customer_id = c.customer_id
        USING (customer_id)
    LEFT JOIN shippers s
        USING (shipper_id);

    -- if join is to be done based on multiple attributes
    -- use USING(col1, col2, ...) int this format
    
    DESCRIBE order_items;
    DESCRIBE order_item_notes;

    SELECT 
        oi.order_id,
        oi.product_id,
        oi.quantity,
        oi.unit_price,
        oin.note
    FROM order_items oi
    JOIN order_item_notes oin
        USING (order_id, product_id);
    
    -- EXERCISE: use sql_invoicing and extract date, client, amount and payment type from payments table
    USE sql_invoicing;
    SHOW tables;
    DESCRIBE payments;
    DESCRIBE clients;
    DESCRIBE payment_methods;

    SELECT
        p.date,
        c.name,
        p.amount,
        pm.name
    FROM payments p
    JOIN clients c
        USING (client_id)
    JOIN payment_methods pm
        ON p.payment_method = pm.payment_method_id;


-- NATURAL JOIN
    -- we don't specify the attributes on which to join
    -- database will look and join based on common attributes

    -- from sql_store join orders and customers
    USE sql_store;
    SHOW tables;
    SELECT *
    FROM orders
    NATURAL JOIN customers;

-- CROSS JOIN
    -- it will join every row from first column to every column in the second column
    SELECT
        c.first_name AS customer,
        p.name AS product
    FROM customers c
    CROSS JOIN products p -- explicit syntax
    ORDER BY customer;

    -- implicit syntax through from clause
    SELECT
        c.first_name AS customer,
        p.name AS product
    FROM customers c, products p -- inplicit syntax
    ORDER BY customer;

    -- EXERCISE: do cross join between shippers and products
        DESCRIBE shippers;
        DESCRIBE products;

        -- using the implicit syntax
        SELECT
            p.name AS product,
            s.name AS shipper
        FROM products p, shippers s;

        -- and using the explicit syntax
        SELECT
            p.name AS product,
            s.name AS shipper
        FROM products p
        CROSS JOIN shippers s;

-- UNION
    -- join rows from multiple table
    system cls;
    SELECT *
    FROM orders;

    -- if order is placed this year then active otherwise archieve
    SELECT
        order_id,
        order_date,
        'Active' AS status -- here string literal is used for indicating status
    FROM orders
    WHERE order_date >= "2019-01-01"
        
        UNION

    SELECT
        order_id,
        order_date,
        'Archieved' AS status -- here string literal is used for indicating status
    FROM orders
    WHERE order_date < "2019-01-01";

    -- name of customers and shippers in single column 
    -- (although not real world use case but for understanding)
    SELECT
        first_name
    FROM customers

        UNION
    
    SELECT
        name
    FROM shippers;

    -- NOTE: while taking union columns returned by all sets must be same otherwise MySQL will yell
    -- NOTE: whatever the name of first set will be used as column name for all combined set after union

    -- from customers table extract customer id, first name, points and
    -- differenciate type based on points
        -- < 2000 => Bronze
        -- Between 2000 & 3000 => Silver
        -- > 3000 => Gold

    system cls;
    SELECT
        customer_id,
        first_name,
        points,
        'Bronze' AS type
    FROM customers
    WHERE points < 2000

    UNION

    SELECT
        customer_id,
        first_name,
        points,
        'Silver' AS type
    FROM customers
    WHERE points BETWEEN 2000 AND 3000

    UNION

    SELECT
        customer_id,
        first_name,
        points,
        'Gold' AS type
    FROM customers
    WHERE points > 3000
    
    ORDER BY first_name; -- if sorting is needed then it must be in last union query



