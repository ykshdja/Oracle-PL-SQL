-- Pushpendra Chauhan
-- Q2

SET SERVEROUTPUT ON;
SET VERIFY OFF;
CLEAR SCREEN;

CREATE OR REPLACE PACKAGE final_api
AS

FUNCTION get_doc
    (i_speciality IN PHYSICIANS.specialty%TYPE)
    RETURN physicians.physician_id%TYPE;

PROCEDURE discharge_patients
    (i_nursing_unit_id IN nursing_units.nursing_unit_id%type,
    o_count OUT NUMBER);
    
    
END final_api;

CREATE OR REPLACE PACKAGE BODY final_api
AS 

FUNCTION get_doc
    (i_speciality IN PHYSICIANS.specialty%TYPE)
RETURN physicians.physician_id%TYPE;

BEGIN

END;
END get_doc;
PROCEDURE discharge_patients
    (i_nursing_unit_id IN nursing_units.nursing_unit_id,
    o_count OUT NUMBER)
IS
    v_count_encounters NUMBER:=0;
BEGIN
    DECLARE 
        CURSOR for_update IS
            SELECT PATIENT_ID, discharge_date
            FROM ADMISSIONS WHERE DISCHARGE_DATE IS NULL
            AND NURSING_UNIT_ID = :nursing_unit_id;
        
        v_patient_id ADMISSIONS.patient_id%TYPE;
        
        v_encounters  Number;
    BEGIN
        OPEN for_update;
        LOOP
            FETCH for_update INTO v_patient_id;
            Select count(*) into v_encounters from ENCOUNTERS where PATIENT_ID=v_patient_id;
            
            if (v_encounters>0) then
                v_count_encounters := v_count_encounters+1;
                UPDATE 
                    ADMISSIONS
                SET 
                    DISCHARGE_DATE = sysdate
                WHERE 
                    patient_id = v_patient_id; 
                    
             END if;
            EXIT WHEN for_update%NOTFOUND; 
        End LOOP;
        CLOSE for_update;
    END;
END discharge_patients;
END final_api;
