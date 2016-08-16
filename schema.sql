CREATE TABLE lists (
  id serial PRIMARY KEY,
  name varchar UNIQUE NOT NULL
);

CREATE TABLE todos (
  id serial PRIMARY KEY,
  list_id int NOT NULL REFERENCES lists (id),
  name varchar NOT NULL,
  completed boolean NOT NULL DEFAULT false
);
