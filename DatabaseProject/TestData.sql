-- The test data below describes a new patient and demonstrates how they interact with the implemented functionality of the database
-- Best executed line by line, but should still not throw errors if executed in bulk

-- Patient 'Michael Scott' wants to make an appointment, but he is not already registered
INSERT INTO patient VALUES('552AE64', 'michael scott', 'm', 'gort, galway', 0, NULL, NULL, NULL, 1);
-- Patient 'Ryan Howard' wants to make an appointment, but is also not already registered
INSERT INTO patient VALUES('993da21', 'Ryan Howard', 'm', 'kiltormer, galway', 0, NULL, NULL, NULL, 1);

-- Displaying patient information MINUS binary file to the screen, making sure 'Michael Scott' and 'Ryan Howard' are there
-- Select * from patient will also be fine, BLOBs will be inserted further down
SELECT ppsn "PPSN", name "Name", sex "Sex", address "Address", outstanding_balance "Outstanding Balance", next_appt "Next Appointment", app_id "Appointment ID", payment_type "Payment Type" from patient;

-- Can now make an Appointment for them, Michael needs a Root Canal(ID - 4) and Ryan needs an Extraction(ID - 2)
INSERT INTO appointments VALUES(0, '552AE64', 4, '2019-11-07 12:15:00');
INSERT INTO appointments VALUES(0, '993da21', 1, '2019-11-05 13:30:00');

-- Updating all patients in Patient table so their app_id and app_time(Appointment Details) are visible from there, not just the appointments table
UPDATE patient p1, appointments p2
SET p1.next_appt = p2.app_time, p1.app_id = p2.app_id
WHERE p1.ppsn = p2.ppsn; 

-- Michael would like to switch his time from 12:15:00 to 13:15:00
UPDATE appointments p1, patient p2
SET p1.app_time = '2019-11-07 13:15:00', p2.next_appt = '2019-11-07 13:15:00'
WHERE p1.ppsn = '552AE64' AND p2.ppsn = '552AE64';

-- Ryan would like to cancel his appointment, it is a late cancelation
DELETE from appointments
WHERE ppsn = '993da21';

-- Updating Patient table details to reflect cancellation
UPDATE patient 
SET next_appt = NULL
WHERE ppsn = '993da21';

-- Charging Ryan a €10 Late Cancellation fee
UPDATE patient
SET outstanding_balance = outstanding_balance + 10.00
WHERE ppsn = '993da21';

-- Creating a new row in appointment_card with Michael Scotts ID(7)
INSERT INTO appointment_card VALUES(0, 7, null, null, null, null, null, 'Hand this in when you arrive', null, null);

-- Updating any new rows in the appointment_card table to automatically fill all relevant details, will udpate any new patient not just Michael
UPDATE appointment_card p1, patient p2, appointments p3, treatment p4
SET p1.name = p2.name, p1.address = p2.address, p1.app_time = p3.app_time, p1.treatment_type = p4.treatment_type, p1.treatment_price = p4.treatment_price
WHERE p1.app_id = p3.app_id AND p3.ppsn = p2.ppsn AND p3.treatment_id = p4.treatment_id;

-- Ensuring an appointment_card for michael was created (Null values are for dentist to update later)
SELECT * from appointment_card;

-- Creating two new bills, one for Jim Halpert and one for Michael Scott
-- Michael hasn't had his appointment yet, so his bill will be 0 for now, only Jim's bill will be issued
INSERT INTO bill VALUES(0, 5555555, null);
INSERT INTO bill VALUES(0, '552AE64', null);

-- Updating the bill table with patients that still have outstanding_balance < 0
UPDATE bill p1, patient p2
SET p1.amount = p2.outstanding_balance
WHERE p1.ppsn = p2.ppsn AND p2.outstanding_balance > 0;

-- Michael now has his Appointment and gets his outstanding_balance in patient table adjusted accordingly
UPDATE patient p1, appointment_card p2, appointments p3
SET p1.outstanding_balance = p1.outstanding_balance + p2.treatment_price
WHERE p1.ppsn = '552AE64';

-- Preparing bills again, this time michael will now be billed
UPDATE bill p1, patient p2
SET p1.amount = p2.outstanding_balance
WHERE p1.ppsn = p2.ppsn AND p2.outstanding_balance > 0;

-- Michael then makes a payment on his bill, paying it off fully
INSERT INTO payment VALUES(0, '552AE64', NOW(), 'Card', 950, SHA1('557328951'), false);

-- Michaels outstanding_balance in patient is deducted by the amount he has paid in payment
-- Also setting a boolean in payment to true, so the amount won't be used again in future
-- This script will work no matter how many payments are made, due to the boolean control
UPDATE patient p1, payment p2
SET p1.outstanding_balance = p1.outstanding_balance - payment_amt, p2.patient_has_paid = 1
WHERE p1.ppsn = p2.ppsn AND patient_has_paid < 1;

-- Doctor Mulcahy wants to refer Michael to another specialist
UPDATE appointment_card
SET dentist_note = "Refer Michael to root canal specialist", refered_specialist = "Lisa Simpson"
WHERE card_id = 7;

-- She also updates his file with an image of his tooth
UPDATE patient
SET patient_images = load_file("c:/wamp64/tmp/rootcanal.jpg")
WHERE ppsn = '552AE64';

-- She also updates Pam Beeslys file with an xray
UPDATE patient
SET patient_images = load_file("c:/wamp64/tmp/xray.jpg")
WHERE ppsn = '1111111';

-- This line will now load patients without the BLOB binary data
SELECT ppsn "PPSN", name "Name", sex "Sex", address "Address", outstanding_balance "Outstanding Balance", next_appt "Next Appointment", app_id "Appointment ID", payment_type "Payment Type" from patient;
