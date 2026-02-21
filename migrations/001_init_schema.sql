-- Tabela de categorias e filtragem no SvelteKit
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Tabela de produtos.
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sku VARCHAR(50) UNIQUE NOT NULL, -- Código de Barras
    name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories(id),
    price DECIMAL(12, 2) DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de equilíbrio, fatia atual 
CREATE TABLE inventory (
    product_id UUID PRIMARY KEY REFERENCES products(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity >= 0), -- Armazém não pode ser negativo.
    last_update TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de transações (histórico - para fins de auditoria)
CREATE TABLE stock_logs (
    id BIGSERIAL PRIMARY KEY,
    product_id UUID REFERENCES products(id),
    change_amount INT NOT NULL, -- Chegaram 5 itens, 2 foram vendidos.
    operation_type VARCHAR(20) NOT NULL, -- 'IN', 'OUT', 'ADJUSTMENT'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
