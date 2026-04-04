--create database art_gallery;

create schema if not exists gallery;
set search_path = gallery;

create table if not exists artists (
    artist_id int generated always as identity not null primary key,
    first_name varchar(100) not null,
    last_name varchar(100) not null,
		full_name varchar(201) generated always as (first_name || ' ' || last_name) stored,
    birth_date date,
    death_date date,
    nationality varchar(100),
    biography text
);

create table if not exists artworks (
    artwork_id int generated always as identity primary key,
    title varchar(200) not null,
    year_created int, -- only year beacuse sometimes full date is unknown
    medium varchar(100),
    dimensions varchar(100) -- plain text because american units unfortunately exist
);

-- many-to-many bridge
create table if not exists artist_artworks (
    artist_id int not null,
    artwork_id int not null,
    primary key (artist_id, artwork_id),
    foreign key (artist_id) references artists(artist_id) on delete cascade,
    foreign key (artwork_id) references artworks(artwork_id) on delete cascade
);

create table if not exists restorations (
    restoration_id int generated always as identity primary key,
    artwork_id int not null,
    restoration_date date not null,
    description text,
    cost decimal(10,2) not null,
    foreign key (artwork_id) references artworks(artwork_id),
    check (restoration_date > date '2026-01-01'),
    check (cost >= 0)
);

create table if not exists exhibitions (
    exhibition_id int generated always as identity primary key,
    title varchar(200) not null unique,
    start_date date not null,
    end_date date,
    description text,
    check (start_date > date '2026-01-01')
);

-- another many-to-many bridge
create table if not exists exhibition_artworks (
    exhibition_id int not null,
    artwork_id int not null,
    display_order int,
    primary key (exhibition_id, artwork_id),
    foreign key (exhibition_id) references exhibitions(exhibition_id) on delete cascade,
    foreign key (artwork_id) references artworks(artwork_id) on delete cascade
);

create table if not exists employees (
    employee_id int generated always as identity primary key,
    first_name varchar(100) not null,
    last_name varchar(100) not null,
    email varchar(150) unique, -- make sure that emails are unique
    phone varchar(30),
    position varchar(100) not null,
    hire_date date
);

-- and another one many-to-many bridge
create table if not exists exhibition_employees (
    exhibition_id int not null,
    employee_id int not null,
    role varchar(100) not null,
    primary key (exhibition_id, employee_id),
    foreign key (exhibition_id) references exhibitions(exhibition_id) on delete cascade,
    foreign key (employee_id) references employees(employee_id) on delete cascade,
    check (role in ('curator','manager','guide'))
);

create table if not exists visitors (
    visitor_id int generated always as identity primary key,
    first_name varchar(100) not null,
    last_name varchar(100) not null,
    email varchar(150) unique, -- same as for employees
    phone varchar(30)
);

create table if not exists ticket_types (
    ticket_type_id int generated always as identity primary key,
    type_name varchar(50) not null unique,
    price decimal(8,2) not null,
    check (price >= 0) -- make sure the ticket price is not negative
);

create table if not exists tickets (
    ticket_id int generated always as identity primary key,
    visitor_id int not null,
    ticket_type_id int not null,
    exhibition_id int not null,
    purchase_date timestamp not null default current_timestamp, -- defualts to current timestamp
    visit_date date not null,
    foreign key (visitor_id) references visitors(visitor_id),
    foreign key (ticket_type_id) references ticket_types(ticket_type_id),
    foreign key (exhibition_id) references exhibitions(exhibition_id),
    check (visit_date > date '2026-01-01')
);
