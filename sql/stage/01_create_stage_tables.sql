-- STAGE слой - сырые данные из источника
-- ============================================

-- 1. CUSTOMERS (Клиенты)
CREATE TABLE IF NOT EXISTS stage.customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(50),
    address TEXT,
    registration_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. CATEGORIES (Категории товаров)
CREATE TABLE IF NOT EXISTS stage.categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. PRODUCTS (Товары)
CREATE TABLE IF NOT EXISTS stage.products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category_id INTEGER REFERENCES stage.categories(category_id),
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    supplier VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. ORDERS (Заказы)
CREATE TABLE IF NOT EXISTS stage.orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES stage.customers(customer_id),
    order_date TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    shipping_address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. ORDER_ITEMS (Позиции заказа)
CREATE TABLE IF NOT EXISTS stage.order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES stage.orders(order_id),
    product_id INTEGER REFERENCES stage.products(product_id),
    quantity INTEGER NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. PAYMENTS (Платежи)
CREATE TABLE IF NOT EXISTS stage.payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES stage.orders(order_id) UNIQUE,
    payment_method VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    payment_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. REVIEWS (Отзывы)
CREATE TABLE IF NOT EXISTS stage.reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES stage.products(product_id),
    customer_id INTEGER REFERENCES stage.customers(customer_id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    review_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. INVENTORY (Складские остатки)
CREATE TABLE IF NOT EXISTS stage.inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES stage.products(product_id) UNIQUE,
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    reserved_quantity INTEGER NOT NULL DEFAULT 0,
    warehouse_location VARCHAR(100),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. SHIPPING (Доставка)
CREATE TABLE IF NOT EXISTS stage.shipping (
    shipping_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES stage.orders(order_id) UNIQUE,
    carrier VARCHAR(100),
    tracking_number VARCHAR(100),
    shipped_date TIMESTAMP,
    estimated_delivery TIMESTAMP,
    actual_delivery TIMESTAMP,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. PROMOTIONS (Промо-акции)
CREATE TABLE IF NOT EXISTS stage.promotions (
    promotion_id SERIAL PRIMARY KEY,
    promotion_name VARCHAR(255) NOT NULL,
    discount_type VARCHAR(50) NOT NULL,
    discount_value DECIMAL(10, 2),
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создание индексов для ускорения запросов
CREATE INDEX IF NOT EXISTS idx_orders_customer ON stage.orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_date ON stage.orders(order_date);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON stage.order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product ON stage.order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_products_category ON stage.products(category_id);
CREATE INDEX IF NOT EXISTS idx_reviews_product ON stage.reviews(product_id);
CREATE INDEX IF NOT EXISTS idx_reviews_customer ON stage.reviews(customer_id);

-- Информационное сообщение
DO $$
BEGIN
    RAISE NOTICE 'STAGE таблицы успешно созданы (10 таблиц)';
END $$;
