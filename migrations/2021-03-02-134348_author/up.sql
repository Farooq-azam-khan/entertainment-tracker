CREATE TABLE author (
    id SERIAL PRIMARY KEY, 
    name VARCHAR NOT NULL UNIQUE,
    CHECK (name <> '')
);
