-- Yash Khanduja, 000826385
-- Q3
CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET VERIFY OFF;

DECLARE
    v_nursing_unit_id  admissions.nursing_unit_id%TYPE;
    v_patient_id admissions.patient_id%TYPE;
    CURSOR c_patients IS
        SELECT patient_id, room, bed 
        FROM admissions
        WHERE discharge_date is NULL and nursing_unit_id = v_nursing_unit_id
        ORDER BY room, bed;
    CURSOR c_medications IS
        SELECT m.medication_description m_desc, u.dosage u_dos
         FROM unit_dose_orders u, medications m
         WHERE u.medication_id=m.medication_id and
         u.patient_id=v_patient_id ;
         
     BEGIN
     v_nursing_unit_id:= '&sv_nursing_unit_id';
          DBMS_OUTPUT.PUT_LINE('Medication Report for: '||v_nursing_unit_id);
        DBMS_OUTPUT.PUT_LINE(chr(10));

         FOR r_patients IN c_patients
         LOOP
             v_patient_id := r_patients.patient_id;
             DBMS_OUTPUT.PUT_LINE('Patient ID: '||r_patients.patient_id||' Room: '||r_patients.room||' Bed: '||r_patients.bed);
             FOR r_medications in c_medications
             LOOP
                 DBMS_OUTPUT.PUT_LINE('    Medication: '||r_medications.m_desc||' Dosage: '||r_medications.u_dos);
               
             END LOOP;
         END LOOP;
 END;