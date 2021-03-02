CREATE TABLE book (
    id SERIAL PRIMARY KEY, 
    title VARCHAR NOT NULL,
    author_id INT REFERENCES author (id) ON DELETE SET NULL, 
    CHECK (title <> '')
); 
