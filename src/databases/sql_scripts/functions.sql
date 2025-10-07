DELIMITER //

-- Drop old versions if they exist
DROP FUNCTION IF EXISTS CalculateLuggageFee;
DROP FUNCTION IF EXISTS CalculateFlightDuration;
DROP FUNCTION IF EXISTS CalculateTotalBookingPrice;

-- Function to calculate luggage fee based on overweight
-- (Weight, FlightID) -> Fee
CREATE FUNCTION CalculateLuggageFee (
    p_weight DECIMAL(5,2), 
    p_flight_id INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_fee_rate DECIMAL(10,2);
    DECLARE v_allowance DECIMAL(5,2) DEFAULT 23.00; -- Free allowance in kg
    DECLARE v_fee DECIMAL(10,2) DEFAULT 0.00;
    -- get the overweight fee rate for the flight
    SELECT overweight_fee_per_kg
    INTO v_fee_rate
    FROM flight
    WHERE flight_id = p_flight_id
    LIMIT 1;
    -- Calculate fee based on allowed weight
    IF p_weight <= v_allowance THEN
        SET v_fee = 0.00;
    ELSE
        SET v_fee = (p_weight - v_allowance) * v_fee_rate;
    END IF;
    RETURN v_fee;
END;
//


-- Function to calculate flight duration in minutes
CREATE FUNCTION CalculateFlightDuration (p_flight_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_duration INT;
    SELECT TIMESTAMPDIFF(MINUTE, departure_time, arrival_time)
    INTO v_duration
    FROM flight
    WHERE flight_id = p_flight_id;

    RETURN v_duration;
END;
//

-- Function to calculate total booking price including luggage fees
CREATE FUNCTION CalculateTotalBookingPrice (p_booking_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_total_price DECIMAL(10,2) DEFAULT 0.00;
    SELECT
        COALESCE(SUM(t.price), 0) + COALESCE(SUM(l.fee), 0)
	INTO v_total_price
    FROM ticket t
    LEFT JOIN luggage l ON t.ticket_id = l.ticket_id
    WHERE t.booking_id = p_booking_id;

    -- Return the total price
    RETURN v_total_price;
END;
//

DELIMITER ;