-- Таблицы
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

-- Тестовая дата
-- Вставка категорий
INSERT INTO Category (name) VALUES ('Фрукты');
INSERT INTO Category (name) VALUES ('Конфеты');
INSERT INTO Category (name) VALUES ('Молочные');
INSERT INTO Category (name) VALUES ('Крупы');
INSERT INTO Category (name) VALUES ('Напитки');

-- Вставка поставщиков
INSERT INTO Supplier (name, address, country, city) VALUES ('ООО "Панько"', 'ул. Главная 1', 'Украина', 'Киев');
INSERT INTO Supplier (name, address, country, city) VALUES ('ООО "Какие люди"', 'ул. Центральная 2', 'Россия', 'Москва');
INSERT INTO Supplier (name, address, country, city) VALUES ('Поставщик1', 'ул. Поставщиков 3', 'Беларусь', 'Минск');

-- Вставка производителей
INSERT INTO Producer (name, address, country, city, region) VALUES ('Производитель1', 'ул. Фабричная 1', 'Россия', 'Москва', 'Центральный');
INSERT INTO Producer (name, address, country, city, region) VALUES ('Производитель2', 'ул. Заводская 2', 'Беларусь', 'Минск', 'Минский');
INSERT INTO Producer (name, address, country, city, region) VALUES ('ООО "Или Фи"', 'ул. Промышленная 3', 'Украина', 'Киев', 'Киевский');

-- Вставка товаров
INSERT INTO Product (name, category_id, supplier_id, producer_id, price, quantity, delivery_date) VALUES ('Яблоки', 1, 1, 1, 45.50, 200, '2023-01-15');
INSERT INTO Product (name, category_id, supplier_id, producer_id, price, quantity, delivery_date) VALUES ('Бананы', 1, 2, 2, 60.75, 150, '2023-01-20');
INSERT INTO Product (name, category_id, supplier_id, producer_id, price, quantity, delivery_date) VALUES ('Шоколадные конфеты', 2, 3, 1, 120.00, 80, '2023-02-05');
INSERT INTO Product (name, category_id, supplier_id, producer_id, price, quantity, delivery_date) VALUES ('Карамель', 2, 1, 3, 95.25, 120, '2023-02-10');
INSERT INTO Product (name, category_id, supplier_id, producer_id, price, quantity, delivery_date) VALUES ('Молоко', 3, 2, 2, 40.00, 300, '2023-01-10');
INSERT INTO Product (name, category_id, supplier_id, producer_id, price, quantity, delivery_date) VALUES ('Сыр', 3, 3, 1, 180.50, 50, '2023-01-25');
INSERT INTO Product (name, category_id, supplier_id, producer_id, price, quantity, delivery_date) VALUES ('Рис', 4, 1, 2, 55.75, 250, '2023-02-15');
INSERT INTO Product (name, category_id, supplier_id, producer_id, price, quantity, delivery_date) VALUES ('Гречка', 4, 2, 3, 65.25, 200, '2023-02-20');
INSERT INTO Product (name, category_id, supplier_id, producer_id, price, quantity, delivery_date) VALUES ('Сок', 5, 3, 1, 85.00, 100, '2023-01-30');
INSERT INTO Product (name, category_id, supplier_id, producer_id, price, quantity, delivery_date) VALUES ('Вода', 5, 1, 2, 25.50, 400, '2023-02-25');

-- Решения задач с group by и having

-- 1
SELECT p.name, AVG(p.price) as avg_price
FROM Product p
GROUP BY p.name
HAVING AVG(p.price) > 50;

-- 2
SELECT c.name as category, COUNT(p.id) as product_count, AVG(p.price) as avg_price
FROM Product p
JOIN Category c ON p.category_id = c.id
GROUP BY c.name
HAVING AVG(p.price) > 100;

-- 3
SELECT c.name as category, COUNT(p.id) as product_count, SUM(p.price * p.quantity) as total_sales
FROM Product p
JOIN Category c ON p.category_id = c.id
WHERE c.name IN ('Фрукты', 'Конфеты')
GROUP BY c.name
HAVING SUM(p.price * p.quantity) > 0;

-- 4
SELECT 
    pr.name as producer,
    pr.country || ', ' || pr.city || ', ' || pr.address as full_address,
    COUNT(p.id) as product_count,
    SUM(p.price * p.quantity) as total_sales
FROM Product p
JOIN Producer pr ON p.producer_id = pr.id
GROUP BY pr.id
HAVING SUM(p.price * p.quantity) BETWEEN 500 AND 2000;

-- 5
SELECT c.name as category, COUNT(p.id) as product_count
FROM Category c
LEFT JOIN Product p ON c.id = p.category_id
GROUP BY c.name
HAVING COUNT(p.id) = (
    SELECT MIN(product_count)
    FROM (
        SELECT COUNT(p.id) as product_count
        FROM Category c
        LEFT JOIN Product p ON c.id = p.category_id
        GROUP BY c.name
    )
);

--6
SELECT 
    c.name as category,
    COUNT(p.id) as product_count
FROM Product p
JOIN Category c ON p.category_id = c.id
JOIN Supplier s ON p.supplier_id = s.id
WHERE p.price * p.quantity > 400
AND s.name IN ('ООО "Панько"', 'ООО "Какие люди"', 'Поставщик1')
GROUP BY c.name;