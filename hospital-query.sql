#-----------------------------------------QUERIES-------------------------------------------------------
#Print names, ids of patients and staff servicing them
SELECT p.name AS patient, s.patient_id, h.name AS physician, s.physician_id, n.name AS nurse, s.nurse_id 
FROM services s
JOIN patient p ON p.patient_id = s.patient_id
JOIN physician h ON h.id = s.physician_id
JOIN nurse n ON n.id = s.nurse_id;

#List basic medical information on patient including name, disease, status, and medication. 
#Also include the patient's room number and number of nights
SELECT name, disease, status, room_number, nights, medication FROM patient p
JOIN health_record h ON h.patient_id = p.patient_id;

#List physician names, instructions they have ordered and the name of the patient the order is for
SELECT h.name AS physician, description AS instruction, p.name AS for_patient, date FROM instruction i
JOIN physician h ON i.physician_id = h.id
JOIN patient p ON i.patient_id = p.patient_id;

#Find the average patient payment amount
SELECT AVG(amount) AS average_payment FROM payment;

#Find the number of patients who are from NC
SELECT COUNT(patient_id) AS NC_Patients FROM patient WHERE address LIKE '%, NC';

#Find the name of the patient with the highest room cost
SELECT name, room_cost FROM invoice i, payment p, patient a
WHERE i.invoice_id = p.invoice_id AND a.patient_id = p.patient_id
AND room_cost = (SELECT MAX(room_cost) FROM invoice);

#Find all physicians from NC who montitor patients from NC
SELECT name, physician_id FROM monitors, physician 
WHERE patient_id IN (SELECT patient_id FROM patient WHERE address LIKE '%, NC')
AND address LIKE '%, NC' AND physician_id = id;

#List all nurses who service patients monitored by physician Jonas Salk
SELECT id, name, phone_number, address FROM nurse WHERE id IN 
(SELECT nurse_id FROM services 
WHERE physician_id = (SELECT id FROM physician WHERE name = 'Jonas Salk'));

#Find all physicians that are not monitoring any patients
SELECT * FROM physician WHERE id NOT IN (SELECT DISTINCT physician_id FROM monitors);

#List everyone in the hospital database that is from NC
SELECT name, 'Patient' AS role, address, phone_number FROM patient WHERE address LIKE '%, NC'
UNION
SELECT name, 'Physician' AS role, address, phone_number FROM physician WHERE address LIKE '%, NC'
UNION
SELECT name, 'Nurse' AS role, address, phone_number FROM nurse WHERE address LIKE '%, NC';

#List all physicians specializing in immunology
SELECT name, phone_number FROM physician WHERE field_of_expertise='Immunology';

#List the patients whose medication amount is 3 or more
SELECT name, medication, amount FROM patient p, medication m WHERE m.patient_id = p.patient_id
AND p.patient_id IN (SELECT patient_id FROM medication WHERE amount >= 3);

#List all physicians who are monitoring a patient in critical condition
SELECT p.name FROM monitors m
JOIN physician p ON m.physician_id = p.id
WHERE patient_id IN (SELECT patient_id FROM health_record WHERE status='Critical');

#List information about all patients currently staying in room 1
SELECT p.patient_id, name, description, status, nights, medication FROM patient p, health_record h
WHERE p.patient_id = h.patient_id AND room_number = 1;

#List all instructions, the name of the nurse who executed it, the execute date, and the id and 
#status of the patient it was ordered for
SELECT name, instruction_code, description, execute_date, patient_id, patient_status FROM nurse
JOIN instruction ON instruction_code = code;

#------------------------------------------VIEWS---------------------------------------------------------
#Staff database view
DROP VIEW IF EXISTS staff_directory;
CREATE VIEW staff_directory AS
SELECT name, 'Nurse' AS position, phone_number, address FROM nurse
UNION
SELECT name, CONCAT('Physician, ', field_of_expertise) AS position, phone_number, address FROM physician;

SELECT * FROM staff_directory;

#Patient database view
DROP VIEW IF EXISTS patient_directory;
CREATE VIEW patient_directory AS
SELECT p.name AS patient, disease, r.status, room_number AS room, nights, medication, 
h.name AS physician, n.name AS nurse 
FROM services s
JOIN patient p ON p.patient_id = s.patient_id
JOIN physician h ON h.id = s.physician_id
JOIN nurse n ON n.id = s.nurse_id
JOIN health_record r ON r.patient_id = p.patient_id;

SELECT * FROM patient_directory;

#Instruction list view
DROP VIEW IF EXISTS instruction_list;
CREATE VIEW instruction_list AS
SELECT code, h.name AS ordered_by, description, p.name AS patient, date FROM instruction i
JOIN physician h ON i.physician_id = h.id
JOIN patient p ON i.patient_id = p.patient_id;

SELECT * FROM instruction_list;

#-----------------------------------------TRIGGERS-----------------------------------------------------
#Create a new health record when a new patient is added
DROP TRIGGER IF EXISTS generate_record;
DELIMITER //
CREATE TRIGGER generate_record
AFTER INSERT ON patient
FOR EACH ROW
BEGIN
	IF (NEW.patient_id IS NOT NULL) THEN
		SET @new_id = (SELECT MAX(record_id) FROM health_record);
		INSERT INTO health_record (record_id, patient_id, description, date, status, disease)
		VALUE (@new_id+1, NEW.patient_id, 'Recently admitted', NOW(), 'Pending', 'Pending');
    END IF;
END//
DELIMITER ;

SELECT * FROM patient;
SELECT * FROM health_record;
INSERT INTO patient VALUE (999, 'Jane Doe', '1 University Way, Cullowhee, NC', '555-269-8439', 3, 2, 'Ibuprofen');
SELECT * FROM patient;
SELECT * FROM health_record;

#Set a new physician's id to the next highest ID number available if it is null
DROP TRIGGER IF EXISTS new_physician_id;
DELIMITER //
CREATE TRIGGER new_physician_id
BEFORE INSERT ON physician
FOR EACH ROW
BEGIN
	IF (NEW.id IS NULL) THEN
		SET @highest_id = (SELECT MAX(id) FROM physician);
        SET NEW.id = @highest_id+1;
    END IF;
END//
DELIMITER ;

SELECT * FROM physician;
INSERT INTO physician VALUE (NULL, 'David Dolittle', 787, '555-666-8169', '841 Paris Hill Court, Cranford, NJ', 'Neurology');
SELECT * FROM physician;

#If no date/time is provided on an instruction, set it to the current date/time
DROP TRIGGER IF EXISTS instruction_time_now;
DELIMITER //
CREATE TRIGGER instruction_time_now
BEFORE INSERT ON instruction
FOR EACH ROW
BEGIN
	IF (NEW.date IS NULL) THEN
        SET NEW.date = CURRENT_DATE();
    END IF;
END//
DELIMITER ;

SELECT * FROM instruction;
INSERT INTO instruction VALUE (12345, 789, 3, NULL, 'Give dose of antibiotic', 25.00, 1003);
SELECT * FROM instruction;