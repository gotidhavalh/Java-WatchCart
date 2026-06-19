-- =============================================================
--  WatchCart MySQL Database Import Script
--
--  How to run:
--    mysql -u root -p < watchcart_db.sql
--  or inside mysql shell:
--    source /path/to/watchcart_db.sql;
-- =============================================================

CREATE DATABASE IF NOT EXISTS watchcart_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE watchcart_db;

-- =============================================================
--  TABLES
-- =============================================================

CREATE TABLE IF NOT EXISTS users (
    id            BIGINT          NOT NULL AUTO_INCREMENT,
    full_name     VARCHAR(60)     NOT NULL,
    email         VARCHAR(255)    NOT NULL,
    password      VARCHAR(255)    NOT NULL,
    phone_number  VARCHAR(20)     DEFAULT NULL,
    address       TEXT            DEFAULT NULL,
    role          VARCHAR(20)          NOT NULL DEFAULT 'USER',
    created_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS categories (
    id          BIGINT          NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100)    NOT NULL,
    description TEXT            DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_categories_name (name)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS notes (
    id      BIGINT       NOT NULL AUTO_INCREMENT,
    title   VARCHAR(200) NOT NULL,
    content TEXT         DEFAULT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS products (
    id               BIGINT           NOT NULL AUTO_INCREMENT,
    name             VARCHAR(255)     NOT NULL,
    description      TEXT             DEFAULT NULL,
    brand            VARCHAR(100)     NOT NULL,
    price            DECIMAL(10,2)    NOT NULL,
    stock_quantity   INT              NOT NULL DEFAULT 0,
    image_url        VARCHAR(500)     DEFAULT NULL,
    strap_material   VARCHAR(100)     DEFAULT NULL,
    case_material    VARCHAR(100)     DEFAULT NULL,
    case_diameter    VARCHAR(20)      DEFAULT NULL,
    movement_type    VARCHAR(20)      DEFAULT NULL,
    water_resistance VARCHAR(50)      DEFAULT NULL,
    category_id      BIGINT           DEFAULT NULL,
    created_at       DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_active        TINYINT(1)       NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    CONSTRAINT chk_products_price  CHECK (price > 0),
    CONSTRAINT chk_products_stock  CHECK (stock_quantity >= 0),
    CONSTRAINT fk_products_category FOREIGN KEY (category_id)
        REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS carts (
    id         BIGINT   NOT NULL AUTO_INCREMENT,
    user_id    BIGINT   NOT NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_carts_user (user_id),
    CONSTRAINT fk_carts_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS cart_items (
    id         BIGINT        NOT NULL AUTO_INCREMENT,
    cart_id    BIGINT        NOT NULL,
    product_id BIGINT        NOT NULL,
    quantity   INT           NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cart_items (cart_id, product_id),
    CONSTRAINT chk_cart_items_qty CHECK (quantity > 0),
    CONSTRAINT fk_cart_items_cart    FOREIGN KEY (cart_id)    REFERENCES carts(id)    ON DELETE CASCADE,
    CONSTRAINT fk_cart_items_product FOREIGN KEY (product_id) REFERENCES products(id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS orders (
    id               BIGINT        NOT NULL AUTO_INCREMENT,
    order_number     VARCHAR(50)   NOT NULL,
    user_id          BIGINT        NOT NULL,
    total_amount     DECIMAL(10,2) NOT NULL,
    status           VARCHAR(20)   NOT NULL DEFAULT 'PENDING',
    shipping_address TEXT          NOT NULL,
    payment_method   VARCHAR(50)   DEFAULT NULL,
    created_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_orders_number (order_number),
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS order_items (
    id         BIGINT        NOT NULL AUTO_INCREMENT,
    order_id   BIGINT        NOT NULL,
    product_id BIGINT        NOT NULL,
    quantity   INT           NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT chk_order_items_qty CHECK (quantity > 0),
    CONSTRAINT fk_order_items_order   FOREIGN KEY (order_id)   REFERENCES orders(id)   ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product FOREIGN KEY (product_id) REFERENCES products(id)
) ENGINE=InnoDB;

-- =============================================================
--  INDEXES
-- =============================================================
CREATE INDEX idx_products_brand     ON products(brand);
CREATE INDEX idx_products_category  ON products(category_id);
CREATE INDEX idx_products_is_active ON products(is_active);
CREATE INDEX idx_orders_user        ON orders(user_id);
CREATE INDEX idx_orders_status      ON orders(status);
CREATE INDEX idx_cart_items_cart    ON cart_items(cart_id);

-- =============================================================
--  SEED DATA — Categories
-- =============================================================
INSERT IGNORE INTO categories (name, description) VALUES
('Luxury',   'High-end premium timepieces from prestigious brands'),
('Sport',    'Rugged and water-resistant watches built for active lifestyles'),
('Casual',   'Everyday wear watches with modern and classic designs'),
('Smart',    'Feature-rich connected smartwatches'),
('Vintage',  'Classic and retro-inspired timepieces'),
('Dive',     'Professional-grade diving watches with high water resistance'),
('Pilot',    'Aviation-inspired chronograph and instrument watches'),
('Dress',    'Elegant slim watches for formal occasions');

-- =============================================================
--  SEED DATA — Products
-- =============================================================
INSERT IGNORE INTO products
  (name, description, brand, price, stock_quantity, image_url,
   strap_material, case_material, case_diameter, movement_type, water_resistance, category_id)
VALUES

-- ── Luxury ──────────────────────────────────────────────────
('Royal Oak Selfwinding',
 'The iconic octagonal bezel watch in stainless steel. Designed by Gerald Genta in 1972, this masterpiece redefined luxury sports watches.',
 'Audemars Piguet', 1895000.00, 3,
 'https://placehold.co/600x500/1a1a2e/ffffff?text=Royal+Oak',
 'Stainless Steel Bracelet', 'Stainless Steel', '41mm', 'AUTOMATIC', '50m',
 (SELECT id FROM categories WHERE name = 'Luxury')),

('Submariner Date',
 'The quintessential divers watch, tested to 300m. Impeccably robust and reliable for professional underwater use.',
 'Rolex', 985000.00, 5,
 'https://placehold.co/600x500/0d1b2a/ffffff?text=Submariner',
 'Oyster Steel Bracelet', 'Oystersteel', '41mm', 'AUTOMATIC', '300m',
 (SELECT id FROM categories WHERE name = 'Luxury')),

('Nautilus 5711',
 'Designed by Gerald Genta, the Nautilus is distinguished by its porthole-shaped case and integrated bracelet.',
 'Patek Philippe', 3250000.00, 2,
 'https://placehold.co/600x500/2c3e50/ffffff?text=Nautilus',
 'Steel Integrated Bracelet', 'Stainless Steel', '40mm', 'AUTOMATIC', '120m',
 (SELECT id FROM categories WHERE name = 'Luxury')),

-- ── Sport ────────────────────────────────────────────────────
('Speedmaster Professional Moonwatch',
 'The first watch worn on the Moon. Hand-wound chronograph with tachymeter bezel, legacy of space exploration.',
 'Omega', 425000.00, 8,
 'https://placehold.co/600x500/2d3436/ffffff?text=Speedmaster',
 'NATO Strap', 'Stainless Steel', '42mm', 'MANUAL', '50m',
 (SELECT id FROM categories WHERE name = 'Sport')),

('Seamaster Planet Ocean 600m',
 'Inspired by Omega rich history of diving watches. Ceramic bezel, Master Chronometer certified.',
 'Omega', 635000.00, 6,
 'https://placehold.co/600x500/00416a/ffffff?text=Planet+Ocean',
 'Rubber & Steel Bracelet', 'Stainless Steel', '43.5mm', 'AUTOMATIC', '600m',
 (SELECT id FROM categories WHERE name = 'Sport')),

('Daytona Cosmograph',
 'The iconic racing chronograph. Tachymetric scale for measuring average speeds up to 400km/h.',
 'Rolex', 1245000.00, 4,
 'https://placehold.co/600x500/1e272e/ffffff?text=Daytona',
 'Oysterflex Bracelet', 'Oystersteel', '40mm', 'AUTOMATIC', '100m',
 (SELECT id FROM categories WHERE name = 'Sport')),

-- ── Casual ───────────────────────────────────────────────────
('Carrera Calibre 5',
 'Sleek automatic day-date watch, a tribute to the original Carrera launched in 1963.',
 'TAG Heuer', 195000.00, 15,
 'https://placehold.co/600x500/636e72/ffffff?text=Carrera',
 'Stainless Steel Bracelet', 'Stainless Steel', '41mm', 'AUTOMATIC', '100m',
 (SELECT id FROM categories WHERE name = 'Casual')),

('Tambour Horizon V2',
 'Louis Vuitton iconic travel watch. LV OS 5.0 operating system with exclusive Tambour face.',
 'Louis Vuitton', 385000.00, 10,
 'https://placehold.co/600x500/8e44ad/ffffff?text=Tambour',
 'Leather Strap', 'Titanium', '42mm', 'QUARTZ', '30m',
 (SELECT id FROM categories WHERE name = 'Casual')),

('Classico Slim',
 'Ultra-thin Swiss-made quartz watch with a minimalist dial and sapphire crystal glass.',
 'Tissot', 18500.00, 40,
 'https://placehold.co/600x500/b2bec3/1a1a2e?text=Tissot+Slim',
 'Leather Strap', 'Stainless Steel', '38mm', 'QUARTZ', '30m',
 (SELECT id FROM categories WHERE name = 'Casual')),

('Everett',
 'Timeless design meets Swiss craftsmanship. A versatile everyday watch for the modern professional.',
 'Longines', 45000.00, 25,
 'https://placehold.co/600x500/dfe6e9/2d3436?text=Longines',
 'Alligator Leather', 'Stainless Steel', '40mm', 'AUTOMATIC', '30m',
 (SELECT id FROM categories WHERE name = 'Casual')),

-- ── Smart ────────────────────────────────────────────────────
('Watch Ultra 2',
 'The most rugged, capable and powerful Apple Watch. 49mm titanium case, up to 36-hour battery.',
 'Apple', 89900.00, 30,
 'https://placehold.co/600x500/0984e3/ffffff?text=Apple+Ultra+2',
 'Alpine Loop', 'Titanium', '49mm', 'QUARTZ', '100m',
 (SELECT id FROM categories WHERE name = 'Smart')),

('Galaxy Watch 6 Classic',
 'Rotating bezel, advanced health monitoring and Google Wear OS. Sapphire Crystal glass.',
 'Samsung', 34999.00, 50,
 'https://placehold.co/600x500/2d3436/ffffff?text=Galaxy+Watch+6',
 'Leather Strap', 'Stainless Steel', '47mm', 'QUARTZ', '50m',
 (SELECT id FROM categories WHERE name = 'Smart')),

-- ── Vintage ──────────────────────────────────────────────────
('Reverso Tribute Small Seconds',
 'The swivelling rectangular case was born in 1931 for polo players. A century of pure elegance.',
 'Jaeger-LeCoultre', 895000.00, 3,
 'https://placehold.co/600x500/f9ca24/1a1a2e?text=Reverso',
 'Calfskin Strap', 'Stainless Steel', '45.6x27.4mm', 'MANUAL', '30m',
 (SELECT id FROM categories WHERE name = 'Vintage')),

('Calatrava 5196',
 'The essence of the Patek Philippe dress watch. Simple, pure and instantly recognisable.',
 'Patek Philippe', 1985000.00, 2,
 'https://placehold.co/600x500/f0e6d3/2d3436?text=Calatrava',
 'Leather Strap', 'Yellow Gold', '37mm', 'MANUAL', '25m',
 (SELECT id FROM categories WHERE name = 'Vintage')),

-- ── Dive ─────────────────────────────────────────────────────
('Pelagos FXD',
 'Official watch of the French Navy combat swimmers. Titanium case, 500m water resistance.',
 'Tudor', 145000.00, 12,
 'https://placehold.co/600x500/00b894/ffffff?text=Pelagos',
 'Titanium & Rubber', 'Titanium', '42mm', 'AUTOMATIC', '500m',
 (SELECT id FROM categories WHERE name = 'Dive')),

('Seadweller Deepsea',
 'A feat of watchmaking: water-resistant to 3,900m. Helium escape valve and Ringlock System.',
 'Rolex', 1150000.00, 4,
 'https://placehold.co/600x500/0652DD/ffffff?text=Sea-Dweller',
 'Oyster Bracelet', 'Oystersteel', '44mm', 'AUTOMATIC', '3900m',
 (SELECT id FROM categories WHERE name = 'Dive')),

-- ── Pilot ────────────────────────────────────────────────────
('Big Pilots Watch',
 'The quintessential pilot watch. 46mm, hand-wound movement, large Arabic numerals for legibility.',
 'IWC Schaffhausen', 695000.00, 6,
 'https://placehold.co/600x500/2d3436/f9ca24?text=Big+Pilot',
 'Leather Strap', 'Stainless Steel', '46.2mm', 'AUTOMATIC', '60m',
 (SELECT id FROM categories WHERE name = 'Pilot')),

('Navitimer B01',
 'The legendary pilot chronograph. Slide rule bezel for aviation calculations. COSC certified.',
 'Breitling', 585000.00, 8,
 'https://placehold.co/600x500/1e272e/fdcb6e?text=Navitimer',
 'Stainless Steel Bracelet', 'Stainless Steel', '43mm', 'AUTOMATIC', '30m',
 (SELECT id FROM categories WHERE name = 'Pilot')),

-- ── Dress ────────────────────────────────────────────────────
('Traditionnelle',
 'Ultra-thin hand-wound movement visible through a sapphire case-back. An ode to fine watchmaking.',
 'Vacheron Constantin', 1450000.00, 3,
 'https://placehold.co/600x500/f5e6ca/2d3436?text=Traditionnelle',
 'Alligator Leather', 'Rose Gold', '38mm', 'MANUAL', '30m',
 (SELECT id FROM categories WHERE name = 'Dress')),

('Laureato 42mm',
 'Octagonal bezel fused with an integrated bracelet. High-end craftsmanship at a sporting heart.',
 'Girard-Perregaux', 785000.00, 5,
 'https://placehold.co/600x500/dfe6e9/2d3436?text=Laureato',
 'Stainless Steel', 'Stainless Steel', '42mm', 'AUTOMATIC', '100m',
 (SELECT id FROM categories WHERE name = 'Dress'));

-- =============================================================
--  SEED DATA — Admin User
--  Password: Admin@1234  (BCrypt encoded)
-- =============================================================
INSERT IGNORE INTO users (full_name, email, password, phone_number, address, role) VALUES
('Admin User',
 'admin@watchcart.com',
 '$2a$12$iL7VqxmLVZ04P3UmIqzGtOvCvnpVR3XVpxkHqTM4oUxnBLrAvI/tO',
 '+91 99999 00000',
 '1, WatchCart HQ, MG Road, Bangalore, Karnataka - 560001',
 'ADMIN');

-- =============================================================
--  SEED DATA — Sample Customer Users
--  Password for all: Test@1234  (BCrypt encoded)
-- =============================================================
INSERT IGNORE INTO users (full_name, email, password, phone_number, address, role) VALUES
('Dhaval Shah',  'dhaval@example.com', '$2a$12$RqPFgZeF.A9eDVz0bXEVgePQ/mR.lYlr5TZ0sGMBF4kqvdp5.bBSe', '+91 98765 43210', '102, Shyam Apartment, C.G. Road, Ahmedabad, Gujarat - 380009', 'USER'),
('Priya Mehta',  'priya@example.com',  '$2a$12$RqPFgZeF.A9eDVz0bXEVgePQ/mR.lYlr5TZ0sGMBF4kqvdp5.bBSe', '+91 91234 56789', '45, Lotus Tower, Bandra West, Mumbai, Maharashtra - 400050',  'USER'),
('Rajan Verma',  'rajan@example.com',  '$2a$12$RqPFgZeF.A9eDVz0bXEVgePQ/mR.lYlr5TZ0sGMBF4kqvdp5.bBSe', '+91 88000 11234', 'B-12, DLF Phase 3, Gurugram, Haryana - 122010',             'USER');

-- Create a cart for every user
INSERT IGNORE INTO carts (user_id)
SELECT id FROM users;

-- =============================================================
--  SEED DATA — Sample Orders
-- =============================================================
INSERT IGNORE INTO orders (order_number, user_id, total_amount, status, shipping_address, payment_method, created_at, updated_at)
VALUES
('WC-20240101120000-1001',
 (SELECT id FROM users WHERE email = 'dhaval@example.com'),
 425000.00, 'DELIVERED',
 '102, Shyam Apartment, C.G. Road, Ahmedabad, Gujarat - 380009',
 'CREDIT_CARD',
 DATE_SUB(NOW(), INTERVAL 30 DAY),
 DATE_SUB(NOW(), INTERVAL 25 DAY)),

('WC-20240115090000-1002',
 (SELECT id FROM users WHERE email = 'priya@example.com'),
 1265000.00, 'SHIPPED',
 '45, Lotus Tower, Bandra West, Mumbai, Maharashtra - 400050',
 'UPI',
 DATE_SUB(NOW(), INTERVAL 10 DAY),
 DATE_SUB(NOW(), INTERVAL 7 DAY));

-- Order items
INSERT IGNORE INTO order_items (order_id, product_id, quantity, unit_price)
SELECT
    o.id,
    p.id,
    1,
    p.price
FROM orders o
JOIN products p ON p.name = 'Speedmaster Professional Moonwatch'
WHERE o.order_number = 'WC-20240101120000-1001';

INSERT IGNORE INTO order_items (order_id, product_id, quantity, unit_price)
SELECT
    o.id,
    p.id,
    1,
    p.price
FROM orders o
JOIN products p ON p.name = 'Submariner Date'
WHERE o.order_number = 'WC-20240115090000-1002';

-- =============================================================
--  VERIFY
-- =============================================================
SELECT 'Categories' AS entity, COUNT(*) AS total FROM categories
UNION ALL
SELECT 'Products',  COUNT(*) FROM products
UNION ALL
SELECT 'Users',     COUNT(*) FROM users
UNION ALL
SELECT 'Orders',    COUNT(*) FROM orders;
