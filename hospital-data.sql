USE hospital;

#Invoice(invoice_id, room_cost, instruction_cost, total_cost)
INSERT INTO invoice VALUE (1001, 200.00, 30.50, 230.50);
INSERT INTO invoice VALUE (1002, 200.00, 75.00, 275.00);
INSERT INTO invoice VALUE (1003, 1500.00, 60.00, 1560.00);
INSERT INTO invoice VALUE (1004, 1499.90, 94.99, 1594.89);
INSERT INTO invoice VALUE (1005, 1049.93, 25.00, 1074.93);

#Room(number, capacity, fee, invoice_id)
INSERT INTO room VALUE (1, 4, 50.00, 1001);
INSERT INTO room VALUE (2, 2, 149.99, 1002);
INSERT INTO room VALUE (3, 2, 149.99, 1003);
INSERT INTO room VALUE (4, 2, 200.00, 1004);
INSERT INTO room VALUE (5, 1, 500.00, 1005);

#Patient(patient_id, name, address, phone_number, room_number, nights, medication)
INSERT INTO patient VALUE (123, 'Kristin Pflug', '444 Walden Station Drive, Charlotte, NC', '919-412-8526', 1, 4, 'Lansoprazole');
INSERT INTO patient VALUE (456, 'Judy Schultz', '1012 Wakehurst Drive, Cary, NC', '919-454-9458', 1, 4, 'Fenergen');
INSERT INTO patient VALUE (789, 'Jesse James', '10 Rockefeller Plaza, New York, NY', '646-459-0800', 5, 3, 'Prednisone');
INSERT INTO patient VALUE (867, 'Christopher Robin', '4000 Louis Stephens Drive, Cary, NC', '919-463-8500', 2, 10, 'Penicillin');
INSERT INTO patient VALUE (856, 'Percy Jackson', '200 Central Park West, New York, NY', '212-769-5100', 2, 7, 'Fluticasone');

#Health_Record(record_id, patient_id, description, date, status, disease)
INSERT INTO health_record 
VALUE (8675, 123, 'Patient diagnosed with Covid-19; admitted to hospital and quarantined', '2022-10-15 02:45:00', 'Stable', 'Covid-19');
INSERT INTO health_record 
VALUE (3092, 456, 'Patient suffering from obstruction due to Crohns disease', '2022-10-18 12:19:00', 'Stable', 'Crohns');
INSERT INTO health_record 
VALUE (1385, 789, 'Patient diagnosed with severe case of influenza, condition critical', '2023-03-04 16:30:00', 'Critical', 'Influenza');
INSERT INTO health_record 
VALUE (5961, 867, 'Patient admitted with pneumonia, condition critical', '2023-02-25 19:04:00', 'Critical', 'Pneumonia');
INSERT INTO health_record 
VALUE (2951, 856, 'Patient suffered head injury in school soccer match; diagnosed with mild concussion', '2023-01-17 20:20:00', 'Stable', 'Concussion');

#Payment(payment_id, patient_id, date, amount, invoice_id)
INSERT INTO payment VALUE (1, 123, '2022-10-20', 230.50, 1001);
INSERT INTO payment VALUE (2, 456, '2023-10-20', 275.00, 1002);
INSERT INTO payment VALUE (3, 789, '2023-03-25', 1560.00, 1003);
INSERT INTO payment VALUE (4, 867, '2023-03-07', 1594.89, 1004);
INSERT INTO payment VALUE (5, 856, '2023-01-31', 1074.93, 1005);

#Physician(id, name, certification_number, phone_number, address, field_of_expertise)
INSERT INTO physician VALUE (1, 'Jonas Salk', 682, '202-918-2132', '8823 Madison Drive, Atlantic City, NJ', 'Immunology');
INSERT INTO physician VALUE (2, 'Veronica Mills', 461, '516-579-3238', '866 South Mill Avenue, High Point, NC', 'Gastroenterology');
INSERT INTO physician VALUE (3, 'Monica Reese', 714, '349-555-3821', '1 University Way, Cullowhee, NC', 'Neurology');
INSERT INTO physician VALUE (4, 'Steven Colbert', 183, '218-546-5310', '710 Old Green Drive, Greer, SC', 'Ophthalmology');
INSERT INTO physician VALUE (5, 'Gilbert Grissom', 537, '505-609-7482', '9419 Anderson Road, Cary, NC', 'Immunology');

#Monitors(patient_id, physician_id)
INSERT INTO monitors VALUE (123, 1);
INSERT INTO monitors VALUE (456, 2);
INSERT INTO monitors VALUE (789, 5);
INSERT INTO monitors VALUE (867, 1);
INSERT INTO monitors VALUE (856, 3);

#Instruction(code, patient_id, physician_id, date, description, fee, invoice_id)
INSERT INTO instruction VALUE (55901, 123, 1, '2022-10-16', 'Give dose of medication in one hour', 30.50, 1001);
INSERT INTO instruction VALUE (28723, 456, 2, '2022-10-18', 'Perform blood test', 75.00, 1002);
INSERT INTO instruction VALUE (25282, 789, 5, '2023-03-07', 'Take patient temperature', 60.00, 1003);
INSERT INTO instruction VALUE (39563, 867, 1, '2023-02-26', 'Give prescribed dose of antibiotic every hour', 25.00, 1004);
INSERT INTO instruction VALUE (10038, 856, 3, '2023-01-25', 'Perform CT Scan', 94.99, 1005);

#Nurse(id, name, certification_number, phone_number, address, instruction_code, patient_status, execute_date)
INSERT INTO nurse VALUE (1, 'Florence Nightingale', 335, '275-867-5309', '274 Westminster Drive, Calhoun, GA', 28723, 'Stable', '2022-10-18 08:23:00');
INSERT INTO nurse VALUE (2, 'Rory Pond', 880, '910-533-3804', '9354 N. Berkshire Avenue, Piedmont, SC', 39563, 'Critical', '2023-02-26 14:24:00');
INSERT INTO nurse VALUE (3, 'Steven Munn', 920, '808-247-0048', '735 W. Bear Hill Avenue, Mableton, GA', 10038, 'Stable', '2023-01-25 22:05:00');
INSERT INTO nurse VALUE (4, 'Charlene Douglas', 664, '924-379-0461', '9 Oak Valley Avenue, Orlando, FL', 55901, 'Stable', '2022-10-16 12:25:00');
INSERT INTO nurse VALUE (5, 'Vanessa Hutchins', 253, '555-617-2828', '27 Airport Street, Hampton, VA', 25282, 'Critical', '2023-03-07 14:56:00');

#Services(patient_id, physician_id, nurse_id)
INSERT INTO services VALUE (123, 1, 5);
INSERT INTO services VALUE (456, 2, 4);
INSERT INTO services VALUE (789, 5, 1);
INSERT INTO services VALUE (867, 1, 3);
INSERT INTO services VALUE (856, 3, 2);

#Medication(patient_id, nurse_id, amount)
INSERT INTO medication VALUE (123, 5, 3);
INSERT INTO medication VALUE (456, 4, 2);
INSERT INTO medication VALUE (789, 1, 1);
INSERT INTO medication VALUE (867, 3, 5);
INSERT INTO medication VALUE (856, 2, 2);
