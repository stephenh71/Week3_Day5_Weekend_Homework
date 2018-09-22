DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS screenings;
DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS customers;

CREATE TABLE films(
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(255)
);

CREATE TABLE customers(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(255),
  funds INT4
);

CREATE TABLE screenings(
  id SERIAL4 PRIMARY KEY,
  capacity INT4,
  film_id INT4 REFERENCES films(id),
  start_time VARCHAR(255)
  );

CREATE TABLE tickets(
  id SERIAL4 PRIMARY KEY,
  price INT4,
  customer_id INT4 REFERENCES customers(id),
  screening_id INT4 REFERENCES screenings(id)
);
