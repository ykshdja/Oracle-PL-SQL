-- Yash Khanduja, 000826385
-- Q2
CLEAR SCREEN;
SET SERVEROUTPUT ON;
SET VERIFY OFF;
DROP TABLE stats;
CREATE TABLE stats
    (nursing_unit_id VARCHAR2(10) PRIMARY KEY, 
    patients NUMBER, 
    date_time DATE);
DECLARE 
    v_num NUMBER := 0;
    v_current_date DATE;
    v_count NUMBER(38,0) := 0;
    v_nursing_unit_id ADMISSIONS.nursing_unit_id%TYPE ;
    CURSOR c_patient IS
    SELECT nursing_unit_id , COUNT(patient_id) 
    INTO v_nursing_unit_id, v_count
    FROM admissions
    WHERE discharge_date IS  NULL
    GROUP BY nursing_unit_id;
BEGIN
    v_current_date := SYSDATE;
    DELETE FROM stats;
    FOR r_patient IN c_patient
    LOOP 
    INSERT INTO stats(nursing_unit_id, patients, date_time) 
    VALUES (r_patient.nursing_unit_id, v_count, v_current_date);
         v_num:=v_num+1;
    end loop;
    DBMS_OUTPUT.PUT_LINE(v_num || ' nursing units processed.');
    
end;