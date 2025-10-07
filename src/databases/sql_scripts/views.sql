-- DROP VIEW IF EXISTS
DROP VIEW IF EXISTS vw_ticket_details;

-- View for booking details
CREATE VIEW vw_ticket_details AS
SELECT
    -- Booking and ticket info
    b.booking_id, -- booking id
    t.ticket_id, -- ticket id
    CONCAT(p.first_name, ' ', p.last_name) AS passenger_name, -- passenger name
    s.seat_number, -- seat number
    s.seat_class, -- seat class

    -- Flight details
    f.flight_number, -- flight number
    f.departure_time, -- departure time
    f.arrival_time, -- arrival time
    a1.airport_name AS origin_airport, -- origin airport
    a2.airport_name AS destination_airport, -- destination airport

    -- Aircraft details
    ac.model AS aircraft_model -- aircraft model

FROM booking b
JOIN ticket t ON b.booking_id = t.booking_id
JOIN passenger p ON t.passenger_id = p.passenger_id
JOIN seat s ON t.seat_id = s.seat_id
JOIN flight f ON t.flight_id = f.flight_id
JOIN `route` r ON f.route_id = r.route_id
JOIN airport a1 ON r.origin_airport_id = a1.airport_id
JOIN airport a2 ON r.destination_airport_id = a2.airport_id
JOIN aircraft ac ON f.aircraft_id = ac.aircraft_id;
