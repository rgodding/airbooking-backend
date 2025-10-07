-- Initial setup, reset if data exists
DROP DATABASE IF EXISTS dbd_airbooking;
CREATE DATABASE dbd_airbooking;
USE dbd_airbooking;

-- Resets tables if they exist

-- Booking & Ticket System
DROP TABLE IF EXISTS seat; -- seats on aircraft
DROP TABLE IF EXISTS ticket; -- tickets issued for bookings
DROP TABLE IF EXISTS payment; -- payments for bookings
DROP TABLE IF EXISTS booking; -- flight bookings made by passengers

-- Passenger & Luggage System
DROP TABLE IF EXISTS luggage; -- luggage checked in by passengers
DROP TABLE IF EXISTS passenger; -- people who book and take flights.

-- Flight & Route System
DROP TABLE IF EXISTS employee; -- airline employees, pilots, crew, ground staff
DROP TABLE IF EXISTS flight; -- scheduled flights
DROP TABLE IF EXISTS aircraft; -- individual flights operated by the airline
DROP TABLE IF EXISTS `route`; -- routes between airports
DROP TABLE IF EXISTS airport; -- airports served by the airline


-- Create Tables
CREATE TABLE airport (
    airport_id INT PRIMARY KEY AUTO_INCREMENT,
    airport_name VARCHAR(100) NOT NULL,
    iata_code CHAR(3) UNIQUE NOT NULL, -- IATA airport code (e.g., JFK, CPH etc.)
    icao_code CHAR(4) UNIQUE NOT NULL, -- ICAO airport code (e.g., KJFK, EKCH etc.) Maybe not needed? 
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    timezone VARCHAR(50) NOT NULL -- Maybe make a separate table for timezones? 
);

CREATE TABLE `route` (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    origin_airport_id INT NOT NULL,
    destination_airport_id INT NOT NULL,
    distance_km INT NOT NULL,
    estimated_duration_minutes INT NOT NULL,
    CONSTRAINT fk_route_origin FOREIGN KEY (origin_airport_id) REFERENCES airport(airport_id), -- Link to origin airport
    CONSTRAINT fk_route_destination FOREIGN KEY (destination_airport_id) REFERENCES airport(airport_id), -- Link to destination airport
    CONSTRAINT chk_route_different_airports CHECK (origin_airport_id <> destination_airport_id) -- Ensure origin and destination are different
);

CREATE TABLE aircraft (
    aircraft_id INT PRIMARY KEY AUTO_INCREMENT,
    model VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100) NOT NULL,
    registration_number VARCHAR(20) UNIQUE NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0), -- Total number of seats, must be positive
    last_maintenance_date DATE,
    `status` ENUM('active', 'maintenance', 'retired') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE seat (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    aircraft_id INT NOT NULL,
    seat_number VARCHAR(5) NOT NULL, -- e.g., 12A, 14C
    seat_class ENUM('economy', 'business', 'first') NOT NULL,
    `status` ENUM('available', 'booked', 'blocked') DEFAULT 'available',
    CONSTRAINT fk_seat_aircraft FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id), -- Link seat to specific aircraft
    CONSTRAINT uq_aircraft_seat UNIQUE (aircraft_id, seat_number) -- Ensure unique seat numbers per aircraft
);

CREATE TABLE passenger (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    nationality VARCHAR(50),
    passport_number VARCHAR(20) UNIQUE,
    -- Contact details, could be expanded into a separate table if needed
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20) UNIQUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    -- make address more detailed if needed
    `address` VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE flight ( 
    flight_id INT PRIMARY KEY AUTO_INCREMENT,
    route_id INT NOT NULL, -- Link to the route being flown
    aircraft_id INT NOT NULL, 
    flight_number VARCHAR(10) UNIQUE NOT NULL, -- Unique flight number (e.g., AA100, BA2500)
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    `status` ENUM('scheduled', 'delayed', 'departed', 'cancelled', 'completed') DEFAULT 'scheduled',
    base_price DECIMAL(10, 2) NOT NULL CHECK (base_price >= 0), -- Base price for the flight
    overweight_fee_per_kg DECIMAL(10, 2) DEFAULT 10.00 CHECK (overweight_fee_per_kg >= 0), -- Fee per kg for luggage over the free allowance
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_flight_route FOREIGN KEY (route_id) REFERENCES route(route_id), -- Link to route
    CONSTRAINT fk_flight_aircraft FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id), -- Link to aircraft
    CONSTRAINT chk_flight_times CHECK (arrival_time > departure_time) -- Ensure arrival is after departure
);

CREATE TABLE booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL, -- Link to customer making the booking
    booking_reference VARCHAR(20) UNIQUE NOT NULL, -- Unique booking reference code (e.g., ABC123, etc.)
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `status` ENUM('confirmed', 'cancelled', 'pending') DEFAULT 'pending',
    total_price DECIMAL(10, 2) NOT NULL CHECK (total_price >= 0), -- Total price of the booking
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_booking_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE ticket (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL, -- Link to the associated booking
    passenger_id INT NOT NULL, -- Link to the passenger for whom the ticket is issued
    flight_id INT NOT NULL, -- Link to the specific flight
    seat_id INT, -- Link to the assigned seat, can be NULL if not assigned yet
    ticket_number VARCHAR(20) UNIQUE NOT NULL, -- Unique ticket number (e.g., 1234567890)
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0), -- Price of the ticket
    `status` ENUM('booked', 'checked_in', 'cancelled', 'no-show', 'boarded') DEFAULT 'booked',
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Add foreign key constraints
    CONSTRAINT fk_ticket_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id),
    CONSTRAINT fk_ticket_passenger FOREIGN KEY (passenger_id) REFERENCES passenger(passenger_id),
    CONSTRAINT fk_ticket_flight FOREIGN KEY (flight_id) REFERENCES flight(flight_id),
    CONSTRAINT fk_ticket_seat FOREIGN KEY (seat_id) REFERENCES seat(seat_id),

    -- Ensure no double booking of the same seat on the same flight
    CONSTRAINT uq_flight_seat UNIQUE (flight_id, seat_id)
);

CREATE TABLE luggage (
    luggage_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT NOT NULL, -- Link to the associated ticket
    tag_number VARCHAR(20) UNIQUE NOT NULL, -- Unique luggage tag number
    weight_kg DECIMAL(5, 2) NOT NULL CHECK (weight_kg >= 0), -- Weight of the luggage
    fee DECIMAL(10, 2) DEFAULT 0.00 CHECK (fee >= 0), -- Any additional fee for the luggage
    luggage_status ENUM('checked_in', 'in_transit', 'delivered', 'lost') DEFAULT 'checked_in',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_luggage_ticket FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id)
);

CREATE TABLE payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL, -- Link to the associated booking
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0), -- Payment amount
    payment_method ENUM('credit_card', 'debit_card', 'paypal', 'bank_transfer') NOT NULL,
    currency VARCHAR(3) NOT NULL, -- Currency code (e.g., USD, EUR)
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `status` ENUM('completed', 'failed', 'pending', 'refunded') DEFAULT 'pending',
    transaction_reference VARCHAR(100) UNIQUE, -- Reference from payment gateway
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
);

CREATE TABLE employee (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE,
    role ENUM('pilot', 'crew', 'ground_staff', 'admin') NOT NULL,
    hire_date DATE NOT NULL,
    status ENUM('active', 'inactive', 'on_leave') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Audit Tables
CREATE TABLE booking_audit_log(
    booking_audit_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    old_status ENUM('confirmed', 'cancelled', 'pending'),
    new_status ENUM('confirmed', 'cancelled', 'pending'),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by INT, -- employee_id of the staff who made the change
    CONSTRAINT fk_audit_employee FOREIGN KEY (changed_by) REFERENCES employee(employee_id)
);