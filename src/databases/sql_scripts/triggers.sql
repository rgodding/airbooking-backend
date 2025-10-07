DELIMITER //
-- Booking audit log trigger
DROP TRIGGER IF EXISTS trg_booking_status_update;
CREATE TRIGGER trg_booking_status_update
AFTER UPDATE ON booking
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO booking_audit_log (booking_id, old_status, new_status, changed_at, changed_by)
        VALUES (OLD.booking_id, OLD.status, NEW.status, CURRENT_TIMESTAMP, NULL); -- Assuming NULL for changed_by for now
    END IF;
END;
//

-- Seat availability trigger
DROP TRIGGER IF EXISTS trg_seat_mark_booked;
CREATE TRIGGER trg_seat_mark_booked
AFTER INSERT ON ticket
FOR EACH ROW
BEGIN
    UPDATE seat
    SET `status` = 'booked'
    WHERE seat_id = NEW.seat_id;
END;
//

-- Revert seat status on ticket deletion
DROP TRIGGER IF EXISTS trg_seat_mark_available;
CREATE TRIGGER trg_seat_mark_available
AFTER DELETE ON ticket
FOR EACH ROW
BEGIN
    UPDATE seat
    SET `status` = 'available'
    WHERE seat_id = OLD.seat_id;
END;
//

DELIMITER ;