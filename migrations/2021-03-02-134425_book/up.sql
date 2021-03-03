CREATE TABLE book (
    id SERIAL PRIMARY KEY, 
    title VARCHAR NOT NULL,
    author_id INT REFERENCES author (id) ON DELETE SET NULL, 
    total_pages INT NOT NULL DEFAULT 1, 
    total_chapters INT NOT NULL DEFAULT 1,
    CHECK (title <> '')
); 
