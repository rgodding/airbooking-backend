-- Indexes for passenger table
CREATE INDEX idx_passenger_email ON passenger(email);
CREATE INDEX idx_passenger_lastname ON passenger(last_name);
CREATE INDEX idx_passenger_phonenumber ON passenger(phone_number);

-- Indexes for booking table
CREATE INDEX idx_booking_customer ON booking(customer_id);

-- Indexes for flight table
CREATE INDEX idx_flight_departure ON flight(departure_time);
CREATE INDEX idx_flight_arrival ON flight(arrival_time);

-- Index for route table

-- Index for aircraft table

-- Index for payment table