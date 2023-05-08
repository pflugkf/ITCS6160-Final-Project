DROP DATABASE IF EXISTS hospital;
CREATE DATABASE hospital;
USE hospital;

DROP TABLE IF EXISTS invoice CASCADE;
DROP TABLE IF EXISTS room CASCADE;
DROP TABLE IF EXISTS patient CASCADE;
DROP TABLE IF EXISTS health_record CASCADE;
DROP TABLE IF EXISTS payment CASCADE;
DROP TABLE IF EXISTS physician CASCADE;
DROP TABLE IF EXISTS monitors CASCADE;
DROP TABLE IF EXISTS instruction CASCADE;
DROP TABLE IF EXISTS nurse CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS medication CASCADE;

CREATE TABLE invoice (
	invoice_id INT NOT NULL,
    room_cost DOUBLE,
    instruction_cost DOUBLE,
    total_cost DOUBLE,
    PRIMARY KEY(invoice_id)
);

CREATE TABLE room (
	number INT NOT NULL,
    capacity INT,
    fee DOUBLE,
    invoice_id INT,
    PRIMARY KEY (number),
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id)#asdf
);

CREATE TABLE patient (
	patient_id INT NOT NULL,
    name VARCHAR(50),
    address VARCHAR(100), 
    phone_number VARCHAR(15),
    room_number INT,
    nights INT,
    medication VARCHAR(30),
	PRIMARY KEY (patient_id),
    FOREIGN KEY (room_number) REFERENCES room(number)
);

CREATE TABLE health_record (
	record_id INT NOT NULL,
    patient_id INT NOT NULL,
    description VARCHAR(250),
    date DATETIME,
    status VARCHAR(100),
    disease VARCHAR(50),
    PRIMARY KEY (record_id, patient_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);

CREATE TABLE payment (
	payment_id INT NOT NULL,
    patient_id INT,
    date DATE,
    amount DOUBLE,
    invoice_id INT,
    PRIMARY KEY (payment_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id)#asdf
);

CREATE TABLE physician (
	id INT NOT NULL,
    name VARCHAR(50),
    certification_number INT,
    phone_number VARCHAR(15),
    address VARCHAR(100),
    field_of_expertise VARCHAR(25),
    PRIMARY KEY (id)
);

CREATE TABLE monitors (
	patient_id INT NOT NULL,
    physician_id INT NOT NULL,
    PRIMARY KEY (patient_id, physician_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (physician_id) REFERENCES physician(id)
);

CREATE TABLE instruction (
	code INT NOT NULL,
    patient_id INT,
    physician_id INT,
    date DATE,
    description VARCHAR(250),
    fee DOUBLE,
    invoice_id INT,
    PRIMARY KEY (code),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (physician_id) REFERENCES physician(id),
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id)#asdf
);

CREATE TABLE nurse (
	id INT NOT NULL,
    name VARCHAR(50),
    certification_number INT,
    phone_number VARCHAR(15),
    address VARCHAR(100),
    instruction_code INT,
    patient_status VARCHAR(100),
    execute_date DATETIME,
    PRIMARY KEY (id),
    FOREIGN KEY (instruction_code) REFERENCES instruction(code)
);

CREATE TABLE services (
	patient_id INT NOT NULL,
    physician_id INT NOT NULL,
    nurse_id INT NOT NULL,
    PRIMARY KEY (patient_id, physician_id, nurse_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (physician_id) REFERENCES physician(id),
    FOREIGN KEY (nurse_id) REFERENCES nurse(id)
);

CREATE TABLE medication (
	patient_id INT NOT NULL,
    nurse_id INT NOT NULL,
    amount INT,
    PRIMARY KEY (patient_id, nurse_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (nurse_id) REFERENCES nurse(id)
);

