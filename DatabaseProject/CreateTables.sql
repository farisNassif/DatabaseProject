-- Database Dentist Creation
DROP database if exists dentist;
CREATE database dentist CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE dentist;

-- Patient Table Creation
CREATE TABLE patient (
   ppsn VARCHAR(7) NOT NULL, 
   name VARCHAR(30) NOT NULL,
   sex VARCHAR(1) NOT NULL,
   address VARCHAR(40) NOT NULL,
   outstanding_balance FLOAT(8,2),
   patient_images blob, 
   next_appt DATETIME,
   app_id SMALLINT(6),
   payment_type ENUM('Pending Confirmation', 'Direct Debit', 'One-time Payment', 'Installments') NOT NULL default 'Pending confirmation',
   PRIMARY KEY(ppsn)
   ) Engine=InnoDB;
   
-- Treatment Table Creation
CREATE TABLE treatment (
   treatment_id SMALLINT(6) NOT NULL AUTO_INCREMENT,
   treatment_type ENUM('Whitening', 'Extraction', 'Cleaning', 'Root Canal','Braces', 'Late Cancelation', 'Filling') NOT NULL,
   treatment_price FLOAT(6,2) NOT NULL,
   UNIQUE(treatment_type),
   PRIMARY KEY(treatment_id)
   ) Engine=InnoDB;

-- Appointments Table Creation
CREATE TABLE appointments (
   app_id SMALLINT(6) NOT NULL AUTO_INCREMENT,
   ppsn VARCHAR(7) NOT NULL, 
   treatment_id SMALLINT(6) NOT NULL,
   app_time DATETIME NOT NULL,
   UNIQUE(ppsn),
   PRIMARY KEY(app_id),
   FOREIGN KEY(treatment_id) REFERENCES treatment(treatment_id) ON UPDATE RESTRICT,
   FOREIGN KEY(ppsn) REFERENCES patient(ppsn) ON DELETE CASCADE
   ) Engine=InnoDB;
   
-- App_card Table Creation
CREATE TABLE appointment_card (
   card_id SMALLINT(5) NOT NULL AUTO_INCREMENT,
   app_id SMALLINT(6) NOT NULL,
   name VARCHAR(30),
   address VARCHAR(40),
   treatment_type VARCHAR(15),
   treatment_price FLOAT(6,2),
   app_time DATETIME,
   note VARCHAR(50),
   dentist_note VARCHAR(50),
   refered_specialist VARCHAR(20),
   UNIQUE(app_id),
   PRIMARY KEY(card_id),
   FOREIGN KEY(app_id) REFERENCES appointments(app_id) ON DELETE CASCADE
   ) Engine=InnoDB;
   
-- Payment Table Creation
CREATE TABLE payment (
   payment_id SMALLINT(6) NOT NULL AUTO_INCREMENT,
   ppsn VARCHAR(7) NOT NULL, 
   lodgement_date DATETIME NOT NULL,
   payment_method ENUM('Cash','Cheque','Post','Card'),
   payment_amt FLOAT(6,2) NOT NULL,
   credit_card_no VARCHAR(60),
   patient_has_paid BOOLEAN,
   PRIMARY KEY(payment_id)
   ) Engine=InnoDB;
   
-- Bill Table Creation
CREATE TABLE bill (
   bill_id SMALLINT(6) NOT NULL AUTO_INCREMENT,
   ppsn VARCHAR(7),
   amount FLOAT(6,2),
   PRIMARY KEY(bill_id)
   ) Engine=InnoDB;
   
-- Specialist Table Creation
CREATE TABLE specialist (
   spec_id SMALLINT(6) NOT NULL AUTO_INCREMENT,
   specialist_name VARCHAR(20),
   treatment_id SMALLINT(3) NOT NULL,
   UNIQUE(specialist_name),
   PRIMARY KEY(spec_id)
   ) Engine=InnoDB;

CREATE TABLE player_save (
   save_id SMALLINT(6) NOT NULL AUTO_INCREMENT,
   name VARCHAR(25),
   current_game VARCHAR(20),
   hand VARCHAR(70),
   PRIMARY KEY(save_id)
   ) Engine=InnoDB;

-- Creating relationship between bill & treatment_id tables
-- ALTER TABLE bill ADD INDEX(treatment_id);
ALTER TABLE bill ADD FOREIGN KEY(ppsn) REFERENCES patient(ppsn);

-- Creating relationship between specialist & treatment_id tables
ALTER TABLE specialist ADD INDEX(treatment_id);
ALTER TABLE specialist ADD FOREIGN KEY(treatment_id) REFERENCES treatment(treatment_id);

-- Creating relationship between appointment_card & refered_specialist
ALTER TABLE appointment_card ADD INDEX(refered_specialist);
ALTER TABLE appointment_card ADD FOREIGN KEY(refered_specialist) REFERENCES specialist(specialist_name);

-- Creating relationship between patient and app_id
ALTER TABLE patient ADD INDEX(app_id);
ALTER TABLE patient ADD FOREIGN KEY(app_id) REFERENCES appointments(app_id) ON DELETE SET NULL;

-- Creating relationship between payment and patient
ALTER TABLE payment ADD FOREIGN KEY(ppsn) REFERENCES patient(ppsn);