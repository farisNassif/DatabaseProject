-- (most)NULL values will be populated once script values are ran which will reference other tables and populate them

-- Populate patient Table
INSERT INTO patient VALUES(1111111, 'pam beesly', 'f', 'tuam, galway', 0, NULL, NULL, NULL, 2);
INSERT INTO patient VALUES(2222222, 'dwight schrute', 'm', 'loughrea, galway', 0, NULL, NULL, NULL, 2);
INSERT INTO patient VALUES(3333333, 'angela martin', 'f', 'salthill, galway', 0, NULL, NULL, NULL, 2);   
INSERT INTO patient VALUES(4444444, 'toby flenderson', 'm', 'westside, galway', 0, NULL, NULL, NULL, 3);
INSERT INTO patient VALUES(5555555, 'jim halpert', 'm', 'tuam, galway',0, NULL, NULL, NULL, 3);
INSERT INTO patient VALUES(6666666, 'andy bernard', 'm', 'ballinasloe galway',0, NULL, NULL, NULL, 1);
INSERT INTO patient VALUES(7777777, 'creed bratton', 'm', 'killimor galway',0, NULL, NULL, NULL, 3);

-- Populate treatment Table
INSERT INTO treatment VALUES(0, 'Extraction', '500');
INSERT INTO treatment VALUES(0, 'Whitening', '650');
INSERT INTO treatment VALUES(0, 'Cleaning', '95');
INSERT INTO treatment VALUES(0, 'Root Canal', '950');
INSERT INTO treatment VALUES(0, 'Braces', '350');

-- Populate appointments Table
INSERT INTO appointments VALUES(0, '1111111', 1, '2019-10-02 12:00:00');
INSERT INTO appointments VALUES(0, '3333333', 3, '2019-11-15 14:00:00');
INSERT INTO appointments VALUES(0, '7777777', 4, '2019-10-22 14:30:00');
INSERT INTO appointments VALUES(0, '2222222', 4, '2019-10-01 15:00:00');
INSERT INTO appointments VALUES(0, '4444444', 1, '2019-09-11 15:30:00');
INSERT INTO appointments VALUES(0, '5555555', 2, '2019-11-08 15:45:00');

-- Populate appointment_card Table
INSERT INTO appointment_card VALUES(0, 4, null, null, null, null, null, 'Hand this in when you arrive', null, null);
INSERT INTO appointment_card VALUES(0, 5, null, null, null, null, null, 'Hand this in when you arrive', null, null);
INSERT INTO appointment_card VALUES(0, 1, null, null, null, null, null, 'Hand this in when you arrive', null, null);
INSERT INTO appointment_card VALUES(0, 2, null, null, null, null, null, 'Hand this in when you arrive', null, null);
INSERT INTO appointment_card VALUES(0, 3, null, null, null, null, null, 'Hand this in when you arrive', null, null);
INSERT INTO appointment_card VALUES(0, 6, null, null, null, null, null, 'Hand this in when you arrive', null, null);

-- Populate payment Table 
INSERT INTO payment VALUES(0, 1111111, NOW(), 'Card', 50, SHA1('123456789'), false);
INSERT INTO payment VALUES(0, 2222222, NOW(), 'Card', 50, SHA1('987654321'), false);
INSERT INTO payment VALUES(0, 3333333, NOW(), 'Cash', 55, null, false);
INSERT INTO payment VALUES(0, 4444444, NOW(), 'Cheque', 65, null, false);
INSERT INTO payment VALUES(0, 5555555, NOW(), 'Post', 25, null, false);

-- Populate specialist Table
INSERT INTO specialist VALUES(0, 'Mary Dervan', '1');
INSERT INTO specialist VALUES(0, 'Joe Duffy', '2');
INSERT INTO specialist VALUES(0, 'Dan Harmon', '3');
INSERT INTO specialist VALUES(0, 'Lisa Simpson', '4');
INSERT INTO specialist VALUES(0, 'Jamie Daniels', '5');

-- Populate bill Table 
INSERT INTO bill VALUES(0, 1111111, null);
INSERT INTO bill VALUES(0, 2222222, null);
INSERT INTO bill VALUES(0, 3333333, null);
INSERT INTO bill VALUES(0, 4444444, null);
INSERT INTO bill VALUES(0, 6666666, null);

-- Updating next_appt and app_id in patient table
UPDATE patient p1, appointments p2
set p1.next_appt = p2.app_time, p1.app_id = p2.app_id
where p1.ppsn = p2.ppsn; 

-- Updating all data in appointment_card table from null
UPDATE appointment_card p1, patient p2, appointments p3, treatment p4
set p1.name = p2.name, p1.address = p2.address, p1.app_time = p3.app_time, p1.treatment_type = p4.treatment_type, p1.treatment_price = p4.treatment_price
where p1.app_id = p3.app_id AND p3.ppsn = p2.ppsn AND p3.treatment_id = p4.treatment_id;
	
-- Updating the outstanding_balance column for each user that will have a treatment
UPDATE patient p1, appointment_card p2, appointments p3
set p1.outstanding_balance = p1.outstanding_balance + p2.treatment_price
where p2.app_id = p3.app_id AND p1.ppsn = p3.ppsn;

-- Deducts the patients outstanding_balance by the corrosponding amount they have paid in the payment table
-- Then sets a boolean to 1 meaning a customer that has paid will not be charged again should this script be rana
UPDATE patient p1, payment p2
set p1.outstanding_balance = p1.outstanding_balance - payment_amt, p2.patient_has_paid = 1
where p1.ppsn = p2.ppsn AND patient_has_paid < 1;

-- Updating the bill table with patients that still have outstanding_balance < 0
UPDATE bill p1, patient p2
set p1.amount = p2.outstanding_balance
where p1.ppsn = p2.ppsn AND p2.outstanding_balance > 0;
