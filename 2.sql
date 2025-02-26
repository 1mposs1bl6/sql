--таблицы
CREATE TABLE Category (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE
);

CREATE TABLE Supplier (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE,
    address TEXT,
    country TEXT,
    city TEXT
);

CREATE TABLE Producer (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE,
    address TEXT,
    country TEXT,
    city TEXT,
    region TEXT
);

CREATE TABLE Product (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE,
    category_id INTEGER,
    supplier_id INTEGER,
    producer_id INTEGER,
    price DECIMAL(10,2),
    quantity INTEGER,
    delivery_date DATE,
    FOREIGN KEY (category_id) REFERENCES Category(id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(id),
    FOREIGN KEY (producer_id) REFERENCES Producer(id)
);

--INNER JOIN:

-- 1. Товары от поставщиков панько или какие люди
SELECT p.name, c.name as category
FROM Product p
JOIN Category c ON p.category_id = c.id
JOIN Supplier s ON p.supplier_id = s.id
WHERE s.name IN ('ООО "Панько"', 'ООО "Какие люди"');

-- 2. Товары без АКМ в имени производителя и не крупы
SELECT p.name, s.name as supplier
FROM Product p
JOIN Producer pr ON p.producer_id = pr.id
JOIN Supplier s ON p.supplier_id = s.id
JOIN Category c ON p.category_id = c.id
WHERE pr.name NOT LIKE '%[АКМ]%' 
AND c.name != 'Крупы';

-- 3. Товары не из Украины,Молдовы,Польши с ценой меньше 50 и поставкой после 10.02.2025
SELECT p.name, c.name as category, s.name as supplier, pr.country
FROM Product p
JOIN Category c ON p.category_id = c.id
JOIN Supplier s ON p.supplier_id = s.id
JOIN Producer pr ON p.producer_id = pr.id
WHERE pr.country NOT IN ('Украина', 'Молдова', 'Польша')
AND p.price < 50
AND p.delivery_date >= '2025-02-10';

-- 4. кондитерские и безалкогольные товары с продажами больше 100
SELECT p.name, s.name as supplier, pr.name as producer
FROM Product p
JOIN Category c ON p.category_id = c.id
JOIN Supplier s ON p.supplier_id = s.id
JOIN Producer pr ON p.producer_id = pr.id
WHERE c.name IN ('Кондитерские', 'Безалкогольные')
AND p.quantity > 100;

-- 5.выборка по трем поставщикам
SELECT p.name, s.name as supplier, c.name as category,
       p.delivery_date, p.price * p.quantity as total_cost
FROM Product p
JOIN Supplier s ON p.supplier_id = s.id
JOIN Category c ON p.category_id = c.id
WHERE s.name IN ('Поставщик1', 'Поставщик2', 'Поставщик3')
ORDER BY p.name;

-- 6. Продажи товаров с полным адресом
SELECT p.name, pr.name as producer, 
       pr.country || ', ' || pr.city || ', ' || pr.address as full_address,
       c.name as category, p.delivery_date, p.price * p.quantity as total_cost
FROM Product p
JOIN Producer pr ON p.producer_id = pr.id
JOIN Category c ON p.category_id = c.id
WHERE pr.name IN ('Производитель1', 'Производитель2')
ORDER BY p.price * p.quantity DESC;

--OUTER JOIN:

-- 1. Производители и их товары
SELECT pr.name as producer, p.name as product
FROM Producer pr
LEFT JOIN Product p ON pr.id = p.producer_id;

-- 2. категории без товаров
SELECT c.name
FROM Category c
LEFT JOIN Product p ON c.id = p.category_id
WHERE p.id IS NULL;

-- 3. Поставщики и их поставки
SELECT s.name as supplier, p.name as product, p.delivery_date
FROM Supplier s
LEFT JOIN Product p ON s.id = p.supplier_id;

-- 4. регионы без производителей
SELECT DISTINCT r.name as region
FROM Regions r
LEFT JOIN Producer p ON r.id = p.region_id
WHERE p.id IS NULL;

-- 5.категории без товаров или фи
SELECT c.name
FROM Category c
LEFT JOIN Product p ON c.id = p.category_id
LEFT JOIN Producer pr ON p.producer_id = pr.id
WHERE pr.name = 'ООО "Или Фи"'
AND p.id IS NULL;

-- 6. производители без молочной продукции
SELECT pr.name
FROM Producer pr
LEFT JOIN Product p ON pr.id = p.producer_id
LEFT JOIN Category c ON p.category_id = c.id
WHERE c.name != 'Молочные'
OR c.name IS NULL;