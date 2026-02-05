-- Инициализация схем для ecommerce-pipeline
-- ============================================

-- Создание схем для разных слоёв DWH
CREATE SCHEMA IF NOT EXISTS stage;
CREATE SCHEMA IF NOT EXISTS ods;
CREATE SCHEMA IF NOT EXISTS dwh;

-- Информационное сообщение
DO $$
BEGIN
    RAISE NOTICE 'Схемы успешно созданы: stage, ods, dwh';
END $$;
