-- ============================================================
-- DATABASE: AirBooking System
-- Purpose: Full setup (tables, data, procedures, functions, etc.)
-- ============================================================

-- 1️⃣ Drop and recreate database
DROP DATABASE IF EXISTS dbd_airbooking;
CREATE DATABASE dbd_airbooking;
USE dbd_airbooking;

-- 2️⃣ Create tables (DDL)
SOURCE C:/Users/Rasha/Coding/monka-notes/school/DBD/assignments/sql_scripts/ddl.sql;

-- 3️⃣ Insert initial test data (DML)
SOURCE C:/Users/Rasha/Coding/monka-notes/school/DBD/assignments/sql_scripts/dml.sql;

-- 4️⃣ Create stored functions
SOURCE C:/Users/Rasha/Coding/monka-notes/school/DBD/assignments/sql_scripts/functions.sql;

-- 5️⃣ Create stored procedures
SOURCE C:/Users/Rasha/Coding/monka-notes/school/DBD/assignments/sql_scripts/procedures.sql;

-- 6️⃣ Create indexes
SOURCE C:/Users/Rasha/Coding/monka-notes/school/DBD/assignments/sql_scripts/indexes.sql;

-- 7️⃣ Create views
SOURCE C:/Users/Rasha/Coding/monka-notes/school/DBD/assignments/sql_scripts/views.sql;

-- 8️⃣ Create triggers
SOURCE C:/Users/Rasha/Coding/monka-notes/school/DBD/assignments/sql_scripts/triggers.sql;

-- 9️⃣ Create events
SOURCE C:/Users/Rasha/Coding/monka-notes/school/DBD/assignments/sql_scripts/events.sql;

-- Enable the MySQL Event Scheduler
SET GLOBAL event_scheduler = ON;

-- ============================================================
-- AirBooking Database Setup Complete
-- path: C:\Users\Rasha\Coding\monka-notes\school\DBD\assignments\sql_scripts\full_setup.sql
-- activate:
-- 1. Open MySQL Workbench: "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p
-- 2. Open this file: SOURCE C:\Users\Rasha\Coding\monka-notes\school\DBD\assignments\sql_scripts\full_setup.sql
-- ============================================================

