-- Yash Khanduja, 000826385
CLEAR SCREEN;
SET PAGESIZE 500;

PROMPT Question 1;
select first_name, last_name, province_id, city 
from patients
where city IN ('Cayuga', 'Misty', 'Red Deer');

PROMPT Question 2;
select purchase_order_id, order_date, total_amount
from PURCHASE_ORDERS
Where order_status = 'ACTIVE' and Total_Amount > (SELECT AVG(Total_Amount)
FROM PURCHASE_ORDERS
WHERE order_status = 'CLOSED');

PROMPT Question 3;
SELECT COUNT(*)
FROM PATIENTS
WHERE ALLERGIES LIKE '%nut%' OR ALLERGIES LIKE '%Nut%' OR ALLERGIES LIKE '%NUT%'OR ALLERGIES LIKE '%nUt%';

PROMPT Question 4;

SELECT item_id, item_description, item_cost*items.QUANTITY_ON_HAND AS inventory_value,
CASE 
    WHEN quantity_on_hand <= order_point
    THEN 'Order more'
    ELSE 'OK'
END AS inventory_status
FROM items
JOIN vendors
ON items.primary_vendor_id = vendors.vendor_id
WHERE vendors.city = 'London';


PROMPT Question 5;
SELECT ADMISSIONS.PATIENT_ID, M.MEDICATION_DESCRIPTION, DOSAGE 
FROM ADMISSIONS
JOIN UNIT_DOSE_ORDERS U ON ADMISSIONS.PATIENT_ID = U.PATIENT_ID
JOIN MEDICATIONS M ON M.MEDICATION_ID = U.MEDICATION_ID
WHERE DISCHARGE_DATE IS NULL
AND ADMISSIONS.NURSING_UNIT_ID = 'CCU'
AND UNIT_DOSE_ORDER_ID IS NOT NULL;


PROMPT Question 6;
SELECT P.PATIENT_ID, FIRST_NAME, LAST_NAME, COUNT(*)
FROM PATIENTS P
JOIN ENCOUNTERS EN ON P.PATIENT_ID = EN.PATIENT_ID
GROUP BY P.PATIENT_ID, P.FIRST_NAME, P.LAST_NAME
HAVING COUNT(*)>7;


PROMPT Question 7;

SELECT P.PATIENT_ID,FIRST_NAME,LAST_NAME,ENCOUNTER_DATE_TIME
FROM PATIENTS P
JOIN ENCOUNTERS EN ON P.PATIENT_ID = EN.PATIENT_ID
JOIN ADMISSIONS A ON EN.PATIENT_ID = A.PATIENT_ID
WHERE A.DISCHARGE_DATE IS NULL  
AND A.NURSING_UNIT_ID = '1SOUTH';

PROMPT Question 8;
INSERT INTO patients(first_name, last_name, gender, health_card, patient_id)
VALUES ('YASH', 'KHANDUJA', 'M', '000826385', (Select max(patient_id) from patients)+1);


PROMPT Question 9;
UPDATE patients
SET patient_height = (select avg(patient_height)
from patients 
where gender=(select gender 
from patients 
where patient_id=(Select max(patient_id) from patients)))
WHERE patient_id = (Select max(patient_id) from patients);


PROMPT Question 10;
DELETE FROM PATIENTS
WHERE P.PATIENT_ID IN (SELECT P.PATIENT_ID
FROM PATIENTS AS P
LEFT JOIN ADMISSIONS AS A ON P.PATIENT_ID = A.PATIENT_ID
WHERE A.ADMISSIONS_DATE IS NULL);





