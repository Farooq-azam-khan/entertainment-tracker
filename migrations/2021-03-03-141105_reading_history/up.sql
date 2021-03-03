CREATE TABLE reading_history (
    id SERIAL PRIMARY KEY, 
    book_id INT REFERENCES book (id) ON DELETE SET NULL, 
    end_page INT NOT NULL, 
    created_at TIMESTAMP DEFAULT NOW() NOT NULL
); 