CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    Registration_Date DATE
);

CREATE TABLE Categories (
    Category_ID SERIAL PRIMARY KEY,
    Category_Name VARCHAR(100) NOT NULL,
    Description TEXT
);

CREATE TABLE Products (
    Product_ID SERIAL PRIMARY KEY,
    Product_Name VARCHAR(150) NOT NULL,
    Category_ID INT REFERENCES Categories(Category_ID),
    Brand VARCHAR(100),
    Price NUMERIC(10,2),
    Stock INT,
    Rating NUMERIC(3,2)
);

CREATE TABLE Employees (
    Employee_ID SERIAL PRIMARY KEY,
    Employee_Name VARCHAR(100),
    Department VARCHAR(100),
    Designation VARCHAR(100),
    Salary NUMERIC(10,2),
    Hire_Date DATE
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Employee_ID INT REFERENCES Employees(Employee_ID),
    Order_Date DATE,
    Order_Status VARCHAR(30),
    Shipping_City VARCHAR(50),
    Shipping_State VARCHAR(50),
    Total_Amount NUMERIC(12,2)
);

CREATE TABLE Order_Items (
    Order_Item_ID SERIAL PRIMARY KEY,
    Order_ID INT REFERENCES Orders(Order_ID),
    Product_ID INT REFERENCES Products(Product_ID),
    Quantity INT,
    Unit_Price NUMERIC(10,2),
    Discount NUMERIC(5,2)
);

CREATE TABLE Payments (
    Payment_ID SERIAL PRIMARY KEY,
    Order_ID INT REFERENCES Orders(Order_ID),
    Payment_Date DATE,
    Payment_Method VARCHAR(50),
    Payment_Status VARCHAR(30),
    Amount NUMERIC(12,2)
);

CREATE TABLE Reviews (
    Review_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Product_ID INT REFERENCES Products(Product_ID),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Review_Text TEXT,
    Review_Date DATE
);


INSERT INTO Customers
(Name, Email, Phone, City, State, Country, Registration_Date)

SELECT
    first_name || ' ' || last_name,
    LOWER(first_name || '.' || last_name || customer_id || '@gmail.com'),
    '9' || LPAD((100000000 + customer_id)::TEXT, 9, '0'),
    city,
    state,
    'India',
    DATE '2024-01-01' + (customer_id * 3)

FROM (
    SELECT
        customer_id,
        (ARRAY[
            'Rahul','Amit','Priya','Neha','Rohit',
            'Ankit','Pooja','Vikas','Sneha','Karan',
            'Suresh','Riya','Manish','Anjali','Deepak',
            'Kavita','Arjun','Simran','Nitin','Muskan'
        ])[((customer_id - 1) % 20) + 1] AS first_name,

        (ARRAY[
            'Kumar','Singh','Sharma','Gupta','Verma',
            'Yadav','Mehta','Patel','Roy','Das'
        ])[((customer_id - 1) % 10) + 1] AS last_name,

        (ARRAY[
            'Patna','Ranchi','Delhi','Mumbai','Kolkata',
            'Lucknow','Jaipur','Pune','Hyderabad','Bangalore',
            'Chennai','Ahmedabad','Bhopal','Kanpur','Noida',
            'Gaya','Chandigarh','Indore','Surat','Nagpur'
        ])[((customer_id - 1) % 20) + 1] AS city,

        (ARRAY[
            'Bihar','Jharkhand','Delhi','Maharashtra','West Bengal',
            'Uttar Pradesh','Rajasthan','Maharashtra','Telangana',
            'Karnataka','Tamil Nadu','Gujarat','Madhya Pradesh',
            'Uttar Pradesh','Uttar Pradesh','Bihar','Punjab',
            'Madhya Pradesh','Gujarat','Maharashtra'
        ])[((customer_id - 1) % 20) + 1] AS state

    FROM generate_series(1,200) AS customer_id
) AS customers;


INSERT INTO Categories (Category_Name, Description)
VALUES
('Electronics', 'Electronic devices and gadgets'),
('Mobiles', 'Smartphones and mobile devices'),
('Laptops', 'Laptops and notebook computers'),
('Clothing', 'Men and women clothing'),
('Footwear', 'Shoes and footwear'),
('Home Appliances', 'Electrical home appliances'),
('Furniture', 'Home and office furniture'),
('Books', 'Books and educational material'),
('Beauty', 'Beauty and personal care products'),
('Sports', 'Sports and fitness products'),
('Groceries', 'Daily grocery products'),
('Toys', 'Toys and games'),
('Jewellery', 'Jewellery and accessories'),
('Accessories', 'Fashion and electronic accessories'),
('Kitchen', 'Kitchen and cooking products');


INSERT INTO Products
(Product_Name, Category_ID, Brand, Price, Stock, Rating)

SELECT
    product_name || ' ' || product_id,
    category_id,
    brand,
    price,
    stock,
    rating

FROM (
    SELECT
        product_id,

        ((product_id - 1) % 15) + 1 AS category_id,

        (ARRAY[
            'Premium','Classic','Smart','Pro','Ultra',
            'Max','Advanced','Essential','Deluxe','Standard'
        ])[((product_id - 1) % 10) + 1]
        || ' ' ||

        (ARRAY[
            'Series','Edition','Model','Collection','Plus'
        ])[((product_id - 1) % 5) + 1] AS product_name,

        (ARRAY[
            'Apple','Samsung','OnePlus','Sony','Boat',
            'HP','Dell','Lenovo','Nike','Adidas',
            'Puma','LG','Philips','Prestige','Amazon'
        ])[((product_id - 1) % 15) + 1] AS brand,

        CASE
            WHEN ((product_id - 1) % 15) + 1 = 1
                THEN 3000 + (product_id * 731) % 70000
            WHEN ((product_id - 1) % 15) + 1 = 2
                THEN 8000 + (product_id * 517) % 60000
            WHEN ((product_id - 1) % 15) + 1 = 3
                THEN 35000 + (product_id * 911) % 100000
            WHEN ((product_id - 1) % 15) + 1 IN (4,5)
                THEN 500 + (product_id * 113) % 8000
            WHEN ((product_id - 1) % 15) + 1 IN (6,7)
                THEN 1500 + (product_id * 337) % 30000
            WHEN ((product_id - 1) % 15) + 1 = 8
                THEN 300 + (product_id * 29) % 2500
            WHEN ((product_id - 1) % 15) + 1 = 9
                THEN 200 + (product_id * 37) % 5000
            WHEN ((product_id - 1) % 15) + 1 = 10
                THEN 500 + (product_id * 61) % 10000
            WHEN ((product_id - 1) % 15) + 1 = 11
                THEN 100 + (product_id * 17) % 3000
            WHEN ((product_id - 1) % 15) + 1 = 12
                THEN 300 + (product_id * 47) % 8000
            WHEN ((product_id - 1) % 15) + 1 = 13
                THEN 1000 + (product_id * 193) % 30000
            WHEN ((product_id - 1) % 15) + 1 = 14
                THEN 200 + (product_id * 53) % 6000
            ELSE
                300 + (product_id * 71) % 7000
        END AS price,

        10 + (product_id * 17) % 190 AS stock,

        ROUND((3.2 + ((product_id * 13) % 18) / 10.0)::numeric, 1) AS rating

    FROM generate_series(1,100) AS product_id
) AS products;


INSERT INTO Employees
(Employee_Name, Department, Designation, Salary, Hire_Date)

SELECT
    (ARRAY[
        'Rajesh Kumar','Amit Sharma','Priya Singh','Neha Gupta',
        'Rakesh Verma','Anjali Roy','Vivek Kumar','Pankaj Singh',
        'Kavita Sharma','Sanjay Gupta','Ravi Kumar','Shweta Singh',
        'Manish Verma','Pooja Sharma','Gaurav Singh',
        'Nisha Gupta','Akash Kumar','Sakshi Roy','Deepak Singh',
        'Komal Sharma','Rahul Verma','Divya Gupta','Arun Kumar',
        'Meena Singh','Tarun Sharma','Kajal Verma','Mohit Kumar',
        'Riya Singh','Suresh Gupta','Anurag Sharma'
    ])[employee_id],

    (ARRAY[
        'Sales','Sales','Customer Support','Warehouse',
        'Sales','Marketing','IT','Warehouse',
        'Finance','Customer Support'
    ])[((employee_id - 1) % 10) + 1],

    (ARRAY[
        'Sales Executive','Sales Executive','Support Executive',
        'Warehouse Associate','Sales Manager','Marketing Executive',
        'IT Executive','Warehouse Manager','Accountant',
        'Support Manager'
    ])[((employee_id - 1) % 10) + 1],

    25000 + ((employee_id * 1750) % 50000),

    DATE '2021-01-01' + (employee_id * 45)

FROM generate_series(1,30) AS employee_id;

INSERT INTO Orders
(Customer_ID, Employee_ID, Order_Date, Order_Status,
 Shipping_City, Shipping_State, Total_Amount)

SELECT
    customer_id,
    employee_id,
    order_date,
    order_status,
    city,
    state,
    total_amount

FROM (
    SELECT
        order_id,

        1 + ((order_id * 17) % 200) AS customer_id,

        1 + ((order_id * 7) % 30) AS employee_id,

        DATE '2025-01-01' + ((order_id * 3) % 365) AS order_date,

        (ARRAY[
            'Delivered',
            'Delivered',
            'Delivered',
            'Delivered',
            'Shipped',
            'Processing',
            'Cancelled',
            'Returned'
        ])[((order_id - 1) % 8) + 1] AS order_status,

        (ARRAY[
            'Patna','Ranchi','Delhi','Mumbai','Kolkata',
            'Lucknow','Jaipur','Pune','Hyderabad','Bangalore',
            'Chennai','Ahmedabad','Bhopal','Kanpur','Noida'
        ])[((order_id - 1) % 15) + 1] AS city,

        (ARRAY[
            'Bihar','Jharkhand','Delhi','Maharashtra','West Bengal',
            'Uttar Pradesh','Rajasthan','Maharashtra','Telangana',
            'Karnataka','Tamil Nadu','Gujarat','Madhya Pradesh',
            'Uttar Pradesh','Uttar Pradesh'
        ])[((order_id - 1) % 15) + 1] AS state,

        ROUND((500 + (order_id * 137) % 25000)::numeric, 2) AS total_amount

    FROM generate_series(1,500) AS order_id
) AS orders;

INSERT INTO Order_Items
(Order_ID, Product_ID, Quantity, Unit_Price, Discount)

SELECT
    order_id,
    product_id,
    quantity,
    unit_price,
    discount

FROM (
    SELECT
        order_id,

        product_id,

        1 + ((item_id * 7) % 5) AS quantity,

        ROUND(
            (
                500 +
                (product_id * 731) % 70000
            )::numeric,
            2
        ) AS unit_price,

        ROUND(
            (item_id * 3 % 21)::numeric,
            2
        ) AS discount

    FROM generate_series(1,500) AS order_id
    CROSS JOIN generate_series(1,3) AS item_number

    CROSS JOIN LATERAL (
        SELECT
            ((order_id * 7 + item_number * 11) % 100) + 1
            AS product_id,

            ((order_id - 1) * 3 + item_number)
            AS item_id
    ) AS generated
) AS order_items;

INSERT INTO Payments
(Order_ID, Payment_Date, Payment_Method, Payment_Status, Amount)

SELECT
    o.Order_ID,

    o.Order_Date +
    CASE
        WHEN o.Order_Status = 'Processing' THEN 0
        ELSE 1
    END,

    (ARRAY[
        'UPI',
        'Credit Card',
        'Debit Card',
        'Net Banking',
        'Cash on Delivery',
        'Wallet'
    ])[((o.Order_ID - 1) % 6) + 1],

    CASE
        WHEN o.Order_Status = 'Cancelled'
            THEN 'Failed'

        WHEN o.Order_Status = 'Returned'
            THEN 'Refunded'

        ELSE 'Completed'
    END,

    o.Total_Amount

FROM Orders o;


INSERT INTO Reviews
(Customer_ID, Product_ID, Rating, Review_Text, Review_Date)

SELECT
    customer_id,
    product_id,
    rating,

    (ARRAY[
        'Excellent product and quality',
        'Very good product',
        'Good value for money',
        'Product is okay',
        'Average quality',
        'Amazing product',
        'Worth the price',
        'Fast delivery and good packaging',
        'Product quality could be better',
        'I am satisfied with the purchase'
    ])[((review_id - 1) % 10) + 1],

    DATE '2025-01-01' + ((review_id * 5) % 365)

FROM (
    SELECT
        review_id,

        1 + ((review_id * 13) % 200)
            AS customer_id,

        1 + ((review_id * 17) % 100)
            AS product_id,

        1 + ((review_id * 7) % 5)
            AS rating

    FROM generate_series(1,600) AS review_id
) AS reviews;

select * from employees;
select * from customers;
select * from categories;
select * from products;
select * from orders;
select * from order_items;
select * from payments;
select * from reviews;




---BASIC QUESTION ...........
--1.Display all customers.
select * from customers;

--2.Display customers from either Delhi or Mumbai.
select name from customers
where state = 'Delhi' or
state='Mumbai';

--3.Find customers whose name starts with A.
select name from customers
where name like 'A%';

--4.Display customers registered after 2025-01-01.
select * from customers
where registration_date > '2025-01-01';

--5.Display customers from Bihar or Jharkhand.
select * from customers 
where state ='Bihar'
or state='Jharkhand';

--6.Count the total number of customers.
select count(customer_id)  as total_customers 
from customers;

--7.Display all products.
select * from products;

--8.Find products with price greater than ₹50,000.
select * from products
where price > 50000;

--9.Find products with price between ₹1,000 and ₹10,000.
select * from products 
where price between 1000 and 10000;

--10.Find products with rating greater than 4.5.
select * from products ;
where rating >4.5;

--11.Display the cheapest product.
select * from products
order by price
limit 1;

--12.Find the average product price.
select avg(price) as average_product_price from products;

--13.Count the total number of products..
select count(product_id) as total_products from products;

--14.Display products from highest to lowest price.
select * from products
order by price;
--15.Display the 10 most expensive products.
select * from products
order by price desc
limit 10;

--16.Find the average price of products for each brand.
select brand , avg(price) as avg_price 
from products
group by brand;

--17.Find the maximum price for each brand.
select brand, max(price)
from products
group by brand;

