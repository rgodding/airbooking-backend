DELIMITER //
-- Flight & Route System Events

-- Update status after departure
CREATE EVENT ev_update_flight_status_departed
ON SCHEDULE EVERY 1 HOUR
DO
BEGIN
    UPDATE flight
    SET `status` = 'departed'
    WHERE `status` = 'scheduled' 
    AND departure_time < NOW();
END;
//
-- Update status after arrival
CREATE EVENT ev_update_flight_status_arrived
ON SCHEDULE EVERY 1 HOUR
DO
BEGIN
    UPDATE flight
    SET `status` = 'completed'
    WHERE `status` = 'departed' 
    AND arrival_time < NOW();
END;
//
-- Auto cancel unpaid bookings after 24 hours
CREATE EVENT ev_auto_cancel_unpaid_bookings
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    UPDATE booking
    SET `status` = 'cancelled'
    WHERE `status` = 'pending' 
    AND booking_date < NOW() - INTERVAL 24 HOUR;
END;
//

DELIMITER ;