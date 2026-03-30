CREATE DATABASE gallery;
USE gallery;

CREATE TABLE artists (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE,
    death_date DATE,
    nationality VARCHAR(100),
    biography TEXT
);

CREATE TABLE artworks (
    artwork_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    year_created INT, -- only year beacuse sometimes full date is unknown
    medium VARCHAR(100),
    dimensions VARCHAR(100) -- plain text because american units unfortunately exist
);

-- many-to-many bridge
CREATE TABLE artist_artworks (
    artist_id INT,
    artwork_id INT,
    PRIMARY KEY (artist_id, artwork_id),
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
    FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id)
);

CREATE TABLE restorations (
    restoration_id INT AUTO_INCREMENT PRIMARY KEY,
    artwork_id INT NOT NULL,
    restoration_date DATE NOT NULL,
    description TEXT,
    cost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id),
    CHECK (restoration_date > '2026-01-01'),
    CHECK (cost >= 0)
);

CREATE TABLE exhibitions (
    exhibition_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE,
    description TEXT,
    CHECK (start_date > '2026-01-01')
);

-- another many-to-many bridge
CREATE TABLE exhibition_artworks (
    exhibition_id INT,
    artwork_id INT,
    display_order INT,
    PRIMARY KEY (exhibition_id, artwork_id),
    FOREIGN KEY (exhibition_id) REFERENCES exhibitions(exhibition_id),
    FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id)
);

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE, -- make sure that emails are unique
    phone VARCHAR(30),
    position VARCHAR(100) NOT NULL,
    hire_date DATE
);

-- and another one many-to-many bridge
CREATE TABLE exhibition_employees (
    exhibition_id INT,
    employee_id INT,
    role VARCHAR(100) NOT NULL,
    PRIMARY KEY (exhibition_id, employee_id),
    FOREIGN KEY (exhibition_id) REFERENCES exhibitions(exhibition_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CHECK (role IN ('curator','manager','guide'))
);

CREATE TABLE visitors (
    visitor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE, -- same as for employees
    phone VARCHAR(30)
);

CREATE TABLE ticket_types (
    ticket_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(8,2) NOT NULL,
    CHECK (price >= 0) -- make sure the ticket price is not negative
);

CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    visitor_id INT NOT NULL,
    ticket_type_id INT NOT NULL,
    exhibition_id INT NOT NULL,
    purchase_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- defualts to current timestamp
    visit_date DATE NOT NULL,
    FOREIGN KEY (visitor_id) REFERENCES visitors(visitor_id),
    FOREIGN KEY (ticket_type_id) REFERENCES ticket_types(ticket_type_id),
    FOREIGN KEY (exhibition_id) REFERENCES exhibitions(exhibition_id),
    CHECK (visit_date > '2026-01-01')
);

INSERT INTO artists (first_name, last_name, birth_date, death_date, nationality, biography) VALUES
('Pablo', 'Picasso', '1881-10-25', '1973-04-08', 'Spanish', 'Cubist pioneer.'),
('Vincent', 'van Gogh', '1853-03-30', '1890-07-29', 'Dutch', 'Post-impressionist painter.');

INSERT INTO artworks (title, year_created, medium, dimensions) VALUES
('Les Demoiselles d''Avignon', 1907, 'Oil on canvas', '243.9 cm × 233.7 cm'),
('Starry Night', 1889, 'Oil on canvas', '73.7 cm × 92.1 cm');

INSERT INTO artist_artworks (artist_id, artwork_id) VALUES
(1, 1),
(2, 2);

INSERT INTO restorations (artwork_id, restoration_date, description, cost) VALUES
(1, '2026-02-15', 'Surface cleaning and varnish removal', 1500.00),
(2, '2026-03-10', 'Frame repair and color touch-up', 2000.00);

INSERT INTO exhibitions (title, start_date, end_date, description) VALUES
('Modern Art Expo', '2026-04-01', '2026-06-01', 'A collection of modern art masterpieces.'),
('Impressionist Highlights', '2026-05-10', '2026-07-15', 'Famous impressionist works.');

INSERT INTO exhibition_artworks (exhibition_id, artwork_id, display_order) VALUES
(1, 1, 1),
(2, 2, 1);

INSERT INTO employees (first_name, last_name, email, phone, position, hire_date) VALUES
('Alice', 'Johnson', 'alice.johnson@example.com', '123-456-7890', 'Curator', '2020-01-15'),
('Bob', 'Smith', 'bob.smith@example.com', '987-654-3210', 'Guide', '2021-06-20');

INSERT INTO exhibition_employees (exhibition_id, employee_id, role) VALUES
(1, 1, 'curator'),
(2, 2, 'guide');

INSERT INTO visitors (first_name, last_name, email, phone) VALUES
('John', 'Doe', 'john.doe@example.com', '555-111-2222'),
('Jane', 'Smith', 'jane.smith@example.com', '555-333-4444');

INSERT INTO ticket_types (type_name, price) VALUES
('Adult', 20.00),
('Student', 10.00);

INSERT INTO tickets (visitor_id, ticket_type_id, exhibition_id, purchase_date, visit_date) VALUES
(1, 1, 1, CURRENT_TIMESTAMP, '2026-04-05'),
(2, 2, 2, CURRENT_TIMESTAMP, '2026-05-15');

ALTER TABLE artists ADD COLUMN record_ts DATE NOT NULL DEFAULT (CURRENT_DATE);
ALTER TABLE artworks ADD COLUMN record_ts DATE NOT NULL DEFAULT (CURRENT_DATE);
ALTER TABLE artist_artworks ADD COLUMN record_ts DATE NOT NULL DEFAULT (CURRENT_DATE);
ALTER TABLE restorations ADD COLUMN record_ts DATE NOT NULL DEFAULT (CURRENT_DATE);
ALTER TABLE exhibitions ADD COLUMN record_ts DATE NOT NULL DEFAULT (CURRENT_DATE);
ALTER TABLE exhibition_artworks ADD COLUMN record_ts DATE NOT NULL DEFAULT (CURRENT_DATE);
ALTER TABLE employees ADD COLUMN record_ts DATE NOT NULL DEFAULT (CURRENT_DATE);
ALTER TABLE exhibition_employees ADD COLUMN record_ts DATE NOT NULL DEFAULT (CURRENT_DATE);
ALTER TABLE visitors ADD COLUMN record_ts DATE NOT NULL DEFAULT (CURRENT_DATE);
ALTER TABLE ticket_types ADD COLUMN record_ts DATE NOT NULL DEFAULT (CURRENT_DATE);
ALTER TABLE tickets ADD COLUMN record_ts DATE NOT NULL DEFAULT (CURRENT_DATE);

