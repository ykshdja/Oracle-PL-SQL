/**
* Yash Khanduja, 000826385
* Lab05.sql
* I, Yash Khanduja, 000826385, certify that this material is my original work. No other person's work has been used without due acknowledgment and I have not made my work available to anyone else.
* 29th-Oct-2020
*
*/
USE CHDB

print 'Group 1:Query A'
/**
Show a count of child patients.
A child is a person who is less than 18 years of age on the day the query is run, use the GETDATE() function for the current date.
Calculate the age as accurately as possible.
*/

SELECT COUNT(*) from patients where (FLOOR(DATEDIFF(DAY, birth_date, GETDATE())/365.25)) < 18;

/**
*Find the first name, last name, and height of the tallest female patient, there may be more than one.
*
*/
print 'Group 1: Query C'

SELECT first_name, last_name , patient_height 
FROM patients
WHERE patient_height = (SELECT TOP 1 patient_height FROM patients  ORDER BY patient_height DESC)
ORDER BY first_name;

/**
*
*Show a count of patients by province except for Ontario.
*/
print 'Group 2: Query C'

SELECT count(*) FROM patients where province_id != 'ON';

/**
*
*Show a count of the male and female patients that are taller than 175 cm.
*
*/
print 'Group 2: Query D'

select count(*) from patients where patient_height > 175;


/*
*
*List the patient id, first name, last name, room number, and bed number for every current admission (no discharge date) in Short Stay (2SOUTH).
*Order the results by the last name.
*
*/

print 'Group 3: Querry A'

select p.patient_id, first_name,last_name, room, bed 
FROM patients p join admissions a ON p.patient_id = a.patient_id 
WHERE discharge_date is not null and nursing_unit_id = '2south' ORDER BY last_name;

/*
*
*List the department id, department name, manager first name, manager last name, purchase order id, and the total amount for any purchase order worth over $1,500.00. Order the results by department id.
*
*/



print 'Group 3: Query D'
SELECT p.department_id, department_name, manager_first_name, manager_last_name, purchase_order_id, total_amount 
FROM departments d join purchase_orders p ON d.department_id = p.department_id 
WHERE total_amount > 1500.00 ORDER BY department_id;

/*
*
*List the physician id, physician's first name, physician's last name, and specialty of any physician who has had an encounter with the patient named Harry Sullivan.
*
*/



print 'Group 4: Query A'

SELECT physician_id,p.first_name, p.last_name, specialty 
	FROM physicians p 
	INNER JOIN admissions a ON p.physician_id = a.attending_physician_id 
	INNER JOIN patients pt ON a.patient_id = pt.patient_height WHERE pt.first_name = 'harry' AND pt.last_name = 'sullivan';

/**
*
*List the patient id, patient first name, patient last name, nursing unit and primary diagnosis of any current admission (no discharge date) whose attending physician’s specialty is Internist.
*
*/

print 'Group 4: Query B'

SELECT p.patient_id, p.first_name, p.last_name, ad.nursing_unit_id, ad.primary_diagnosis 
	FROM patients p 
	INNER JOIN admissions ad ON p.patient_id = ad.patient_id
	INNER JOIN physicians ph ON ad.attending_physician_id = ph.physician_id WHERE ad.discharge_date IS NOT NULL AND  ph.specialty = 'internist';

	/**
	*
	*List the patient first name concatenated with a space and patient last name and aliased as patient, nursing unit, room, and medication description for any current admissions (no discharge date) who are allergic to Penicillin.
	*
	*/
print 'Group 5: Query B'
/*
 SELECT (SELECT CONCAT(p.first_name,' '), p.last_name AS patient , n.nursing_unit_id, a.room , m.medication_description
 FROM patients p, nursing_units n , admissions a, medications m
 INNER JOIN admissions a
 */

 /*
 *
 *List the patient id, primary diagnosis, and attending physician id for current admissions (no discharge date) in ICU who haven't had an encounter with their attending physician.
 *
 */
 print 'Group 6: Query B'

 /*SELECT pt.patient_id, a.primary_diagnosis, a.attending_physician_id 
 FROM patients pt, admissions a
 INNER JOIN patients pt ON ad.attending_physician = ad.patient_id
 INNER JOIN admissions ad ON ad.attending_physician_id = NULL
 */



