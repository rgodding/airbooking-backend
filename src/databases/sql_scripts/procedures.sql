DELIMITER //
-- Procedure to add a new booking
CREATE PROCEDURE AddBooking (
    IN p_customer_id INT,
    IN p_total_price DECIMAL(10,2)
)
BEGIN
    DECLARE v_booking_reference VARCHAR(20);
    
    -- Generate a random booking reference that is unique
    SET v_booking_reference = CONCAT('REF', LPAD(FLOOR(RAND() * 1000000), 6, '0'));

    -- Insert the booking
    INSERT INTO booking (customer_id, booking_reference, total_price)
    VALUES (p_customer_id, v_booking_reference, p_total_price);

    -- Returns the booking reference
    SELECT v_booking_reference AS booking_reference;
END;
//
-- Procedure to add a new ticket
CREATE PROCEDURE AddTicket (
    IN p_booking_id INT,
    IN p_passenger_id INT,
    IN p_flight_id INT,
    IN p_seat_id INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    DECLARE v_ticket_number VARCHAR(20);

    -- generate unique ticket number
    SET v_ticket_number = CONCAT('TCK',
        -- Generate two random uppercase letters (A-Z) 
        CHAR(FLOOR(65 + RAND() * 26)),
        CHAR(FLOOR(65 + RAND() * 26)),
        -- Generate six random digits (0-9)
        LPAD(FLOOR(RAND() * 1000000), 6, '0')
    );

    -- Ensure the seat is not already booked for the flight
    IF EXISTS (
        SELECT 1 FROM ticket
        WHERE flight_id = p_flight_id AND seat_id = p_seat_id
    ) THEN
        -- Seat already booked, raise an error 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Seat already booked for this flight';
    ELSE
        -- Insert the ticket
        INSERT INTO ticket(booking_id, passenger_id, flight_id, seat_id, ticket_number, price)
        VALUES (p_booking_id, p_passenger_id, p_flight_id, p_seat_id, v_ticket_number, p_price);
        -- Return the ticket number
        SELECT v_ticket_number AS ticket_number;
    END IF;
END;
//

-- Procedure to add a new payment
CREATE PROCEDURE AddPayment (
    IN p_booking_id INT,
    IN p_amount DECIMAL(10,2),
    IN p_payment_method ENUM('credit_card', 'debit_card', 'paypal', 'bank_transfer'),
    IN p_currency VARCHAR(3)
)
BEGIN
    DECLARE v_transaction_ref VARCHAR(100);

    -- Generate a random transaction reference
    SET v_transaction_ref = CONCAT('TXN',
        CHAR(FLOOR(65 + RAND() * 26)),
        CHAR(FLOOR(65 + RAND() * 26)),
        LPAD(FLOOR(RAND() * 1000000), 6, '0')
    );

    -- Insert the payment
    INSERT INTO payment (booking_id, amount, payment_method, currency, transaction_reference, `status`)
    VALUES (p_booking_id, p_amount, p_payment_method, p_currency, v_transaction_ref, 'completed');

    -- Update the booking status to 'confirmed' if payment is successful
    UPDATE booking
    SET `status` = 'confirmed'
    WHERE booking_id = p_booking_id;

    -- Return the transaction reference
    SELECT v_transaction_ref AS transaction_reference;
END;
//

DELIMITER ;