-- ============================================================
-- DML (Initial Test Data) for AirBooking System
-- ============================================================

-- 1️⃣ Airports
INSERT INTO airport (airport_name, iata_code, icao_code, city, country, timezone) VALUES
('Copenhagen Airport', 'CPH', 'EKCH', 'Copenhagen', 'Denmark', 'Europe/Copenhagen'),
('Heathrow Airport', 'LHR', 'EGLL', 'London', 'United Kingdom', 'Europe/London'),
('John F. Kennedy Intl', 'JFK', 'KJFK', 'New York', 'USA', 'America/New_York'),
('Dubai Intl', 'DXB', 'OMDB', 'Dubai', 'UAE', 'Asia/Dubai');

-- 2️⃣ Routes
INSERT INTO route (origin_airport_id, destination_airport_id, distance_km, estimated_duration_minutes) VALUES
(1, 2, 950, 90),
(2, 3, 5560, 420),
(3, 4, 11000, 720);

-- 3️⃣ Aircraft
INSERT INTO aircraft (model, manufacturer, registration_number, capacity, status) VALUES
('A320', 'Airbus', 'OY-ABC', 180, 'active'),
('Boeing 777', 'Boeing', 'G-BAAA', 396, 'active'),
('Boeing 787 Dreamliner', 'Boeing', 'N-DREAM', 242, 'active');

-- 4️⃣ Seats
INSERT INTO seat (aircraft_id, seat_number, seat_class, status) VALUES
(1, '1A', 'business', 'available'),
(1, '12C', 'economy', 'available'),
(1, '14B', 'economy', 'available'),
(2, '2A', 'business', 'available'),
(2, '21F', 'economy', 'available'),
(3, '5C', 'economy', 'available');

-- 5️⃣ Flights
INSERT INTO flight (route_id, aircraft_id, flight_number, departure_time, arrival_time, status, base_price, overweight_fee_per_kg) VALUES
(1, 1, 'SK123', '2025-10-07 08:00:00', '2025-10-07 09:45:00', 'scheduled', 150.00, 10.00),
(2, 2, 'BA420', '2025-10-08 11:00:00', '2025-10-08 18:00:00', 'scheduled', 480.00, 15.00),
(3, 3, 'DL900', '2025-10-09 21:00:00', '2025-10-10 09:00:00', 'scheduled', 850.00, 20.00);

-- 6️⃣ Customers
INSERT INTO customer (first_name, last_name, email, phone_number, address) VALUES
('Rasha', 'Ali', 'rasha.ali@example.com', '+4512345678', 'København, Denmark'),
('James', 'Brown', 'james.brown@example.com', '+4412345678', 'London, UK'),
('Emma', 'Johnson', 'emma.johnson@example.com', '+12125551234', 'New York, USA');

-- 7️⃣ Passengers
INSERT INTO passenger (first_name, last_name, date_of_birth, nationality, passport_number, email, phone_number) VALUES
('Rasha', 'Ali', '1998-04-12', 'Denmark', 'X1234567', 'rasha.ali@example.com', '+4512345678'),
('James', 'Brown', '1985-06-24', 'UK', 'Y7654321', 'james.brown@example.com', '+4412345678'),
('Emma', 'Johnson', '1990-10-11', 'USA', 'Z9988776', 'emma.johnson@example.com', '+12125551234');

-- 8️⃣ Bookings
INSERT INTO booking (customer_id, booking_reference, status, total_price) VALUES
(1, 'REF001', 'confirmed', 150.00),
(2, 'REF002', 'confirmed', 480.00),
(3, 'REF003', 'pending', 850.00);

-- 9️⃣ Tickets
INSERT INTO ticket (booking_id, passenger_id, flight_id, seat_id, ticket_number, price, status) VALUES
(1, 1, 1, 1, 'TCKAA123456', 150.00, 'booked'),
(2, 2, 2, 4, 'TCKBB654321', 480.00, 'booked'),
(3, 3, 3, 6, 'TCKCC777777', 850.00, 'booked');

-- 🔟 Luggage
INSERT INTO luggage (ticket_id, tag_number, weight_kg, fee, luggage_status) VALUES
(1, 'LUG1001', 22.0, 0.00, 'checked_in'),
(2, 'LUG1002', 25.5, 7.50, 'checked_in'),
(3, 'LUG1003', 29.0, 12.00, 'checked_in');

-- 11️⃣ Payments
INSERT INTO payment (booking_id, amount, payment_method, currency, status, transaction_reference) VALUES
(1, 150.00, 'credit_card', 'EUR', 'completed', 'TXNAA123456'),
(2, 480.00, 'paypal', 'GBP', 'completed', 'TXNBB654321'),
(3, 240.00, 'credit_card', 'USD', 'pending', 'TXNCC777777');

-- ============================================================
-- ✅ Sample data successfully inserted!
-- ============================================================
