-- basic overview
    -- to run scripts from file
    -- source filename.sql

    -- to clear screen
    system cls;

    -- to show database
    SHOW DATABASES;

    -- to select database
    USE sql_store;

    -- to show table
    SHOW TABLES;

    -- to get schema of a table
    DESCRIBE customers;

    -- to display all columns of table
    SELECT *
    FROM customers;

    -- to display particular columns
    SELECT first_name, last_name, phone
    FROM customers;

    -- WHERE clause 
    SELECT first_name, birth_date
    FROM customers
    WHERE birth_date >= "1975-01-01";

    -- ORDER BY clause
    SELECT first_name, birth_date
    FROM customers
    WHERE birth_date >= "1975-01-01"
    ORDER BY birth_date;

    /* sequence of clause matters 
    1: SELECT 
    2: FROM [OPTIONAL]
    3: WHERE [OPTIONAL]
    4: ORDER BY [OPTIONAL]
    */

system cls;
-- SELECT CLAUSE IN DEPTH
    -- change sequence of column to display
    SELECT last_name, first_name
    FROM customers
    WHERE birth_date >= "1975-01-01";

    SELECT first_name, last_name
    FROM customers
    WHERE birth_date >= "1975-01-01";

    -- arithmentic operation [+, -, /, *, %] on column where data is numeric
    /* order of execution
        * /
        + -
    */
    SELECT first_name, points, points + 10
    FROM customers
    WHERE customer_id < 10;

    -- breaking each column in new line in query for better readablity
    -- arithmetic operation are executed as per mathematics rule
    -- renaming arithmetic column for better clarity
    -- if new name contains space then use single or double qoute to encapsulate
    SELECT 
        first_name, 
        last_name, 
        phone, 
        points, 
        points + 10 * 100 AS discount,
        (points + 10) * 100 AS "new discount"
    FROM customers;

    -- retriving distinct data
    SELECT state
    FROM customers;

    SELECT DISTINCT state
    FROM customers;

    -- Exercise: 
    /*
        Return all the products with their name, unit price and new price
        new price = increase unit price by 10%
    */

    SELECT name, unit_price, unit_price * 1.1 AS "new price"
    FROM products;

system cls;

-- WHERE CLAUSE IN DEPTH
    /*
        it will iterate over whole table and 
        check in every row for particular condition and 
        if true then return that row
    */

    -- comparision operator
    /*
        >
        >=
        <
        <=
        != or <> is for not equal to 
    */
    -- customers with points greater than 3000
    SELECT *
    FROM customers
    WHERE points > 3000;

    -- customers living in VA
    SELECT *
    FROM customers
    WHERE state = 'VA';

    -- customers outside of VA
    SELECT *
    FROM customers
    WHERE state <> 'VA';

    -- customers born after 1st jan 1990
    -- date is not a string but it is enclosed in quotes
    SELECT *
    FROM customers
    WHERE birth_date > "1990-01-01";

    -- EXERCISE: get the orders placed in 2019
    DESCRIBE orders;

    SELECT *
    FROM orders
    WHERE order_date >= "2019-01-01";

system cls;

-- AND, OR and NOT operator
    -- retrive customers with more than thousand points and born after 1st jan 1990
    SELECT *
    FROM customers
    WHERE points > 1000 AND birth_date > "1990-01-01";

    -- retrive customers with atmost 1000 points and lives in VA
    SELECT *
    FROM customers
    WHERE points > 1000 AND state = 'VA';

    -- precedence order is [AND -> OR]
    SELECT *
    FROM customers
    WHERE birth_date > "1990-01-01" OR points > 1000 AND state = "VA";

    -- use of bracket to override default precedence of operators
    SELECT *
    FROM customers
    WHERE 
        birth_date > "1990-01-01" OR 
        (points > 1000 AND state = "VA");

    -- retrive customer who are born after 1st jan 1990 or points more than 1000
    -- negate the above query
    SELECT *
    FROM customers
    WHERE NOT (birth_date > "1990-01-01" OR points > 1000);

    system cls;
    -- EXERCISE: from order_item table get the items for order 6 where total price > 30
    DESCRIBE order_items;

    SELECT *
    FROM order_items
    WHERE order_id = 6 AND quantity * unit_price > 30;

system cls;

-- IN operator
    -- retrive all customers from VA, FL, GA
    SELECT *
    FROM customers
    WHERE state IN ("VA", "FL", "GA");

    -- retrive all customers outside of VA, FL, GA
    SELECT *
    FROM customers
    WHERE state NOT IN ("VA", "FL", "GA");

    -- EXERCISE: return products with quantity in stock equal to 49, 38, 72
    DESCRIBE products;
    SELECT *
    FROM products
    WHERE quantity_in_stock IN (49, 72, 38);

system cls;

-- BETWEEN Operator
    -- customers with point ranging from 1000 to 3000
    SELECT *
    FROM customers
    WHERE points BETWEEN 1000 AND 3000;

    -- retrun customers born between 1/1/1990 and 1/1/2000
    SELECT *
    FROM customers
    WHERE birth_date BETWEEN "1990-01-01" AND "2000-01-01";

system cls;

-- LIKE Operator
    -- retrive customers whose last name start with b
    -- no case sensitive 
    -- % for zero or more characters
    -- _ for single character
    SELECT *
    FROM customers
    -- starts with b
    WHERE last_name LIKE "b%";
    -- contains b
    --WHERE last_name LIKE "%b%";
    -- ends with b
    --WHERE last_name LIKE "%b";

    -- retrive customers with last name ending with y and is of 6 characters
    SELECT *
    FROM customers
    WHERE last_name LIKE "_____y";

    -- retrive customers whose addresses contain TRAIL or AVENUE
    system cls;
    DESCRIBE customers;
    SELECT *
    FROM customers
    WHERE address LIKE "%TRAIL%" OR 
          address LIKE "%AVENUE%";
    -- WHERE address LIKE IN ("%TRAIL%", "%AVENUE%"); this will not work

    -- retrive customers whose phone ends with 9
    SELECT *
    FROM customers
    WHERE phone LIKE "%9";

    -- retrive customers whose phone does not ends with 9
    -- NULL values for phone will be ignoured
    SELECT *
    FROM customers
    WHERE phone NOT LIKE "%9";
    

