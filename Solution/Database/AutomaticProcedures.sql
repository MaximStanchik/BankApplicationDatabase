alter session set container = BANK_APP_PDB;

-- Начисление задолженностей по кредитам и смена их статуса
CREATE OR REPLACE PROCEDURE ProcessActiveCredits AS
    CURSOR active_credits IS
        SELECT ID, DEBT_AMOUNT, REMAINING_AMOUNT, PAYMENT_AMOUNT, PAYMENT_DAY, MATURITY_DATE, PAYMENT_FREQUENCY
        FROM admin_user.Credits
        WHERE STATUS = 'Active';

    v_today DATE := TRUNC(SYSDATE);
BEGIN
    FOR credit IN active_credits LOOP
        IF credit.PAYMENT_DAY = TO_NUMBER(TO_CHAR(v_today, 'DD')) THEN
            IF credit.PAYMENT_FREQUENCY = 'Once a month' OR 
               (credit.PAYMENT_FREQUENCY = 'Once every three months' AND MOD(MONTHS_BETWEEN(v_today, credit.MATURITY_DATE), 3) = 0) OR
               (credit.PAYMENT_FREQUENCY = 'Once every six months' AND MOD(MONTHS_BETWEEN(v_today, credit.MATURITY_DATE), 6) = 0) THEN

                UPDATE admin_user.Credits
                SET DEBT_AMOUNT = DEBT_AMOUNT + credit.PAYMENT_AMOUNT,
                    REMAINING_AMOUNT = GREATEST(credit.REMAINING_AMOUNT - credit.PAYMENT_AMOUNT, 0)
                WHERE ID = credit.ID;

                IF (GREATEST(credit.REMAINING_AMOUNT - credit.PAYMENT_AMOUNT, 0) = 0 AND 
                    GREATEST(credit.DEBT_AMOUNT + credit.PAYMENT_AMOUNT, 0) = 0) THEN
                    UPDATE admin_user.Credits
                    SET STATUS = 'Paid'
                    WHERE ID = credit.ID;
                END IF;
            END IF;
        END IF;

        IF (credit.MATURITY_DATE <= v_today AND (credit.DEBT_AMOUNT > 0 OR credit.REMAINING_AMOUNT > 0)) THEN
            UPDATE admin_user.Credits
            SET STATUS = 'Expired',
                DEBT_AMOUNT = DEBT_AMOUNT + credit.REMAINING_AMOUNT,
                REMAINING_AMOUNT = 0
            WHERE ID = credit.ID;
        END IF;
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END ProcessActiveCredits;

SELECT * 
FROM user_errors 
WHERE name = 'PROCESSACTIVECREDITS' AND type = 'PROCEDURE';

BEGIN
    DBMS_SCHEDULER.create_program (
        program_name   => 'PROCESS_ACTIVE_CREDITS_PROG',
        program_type    => 'PLSQL_BLOCK',
        program_action  => 'BEGIN ProcessActiveCredits; END;',
        number_of_arguments => 0,
        enabled         => TRUE
    );
END;

BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'PROCESS_ACTIVE_CREDITS_JOB',
        program_name     => 'PROCESS_ACTIVE_CREDITS_PROG',
        start_date      => SYSTIMESTAMP, 
        repeat_interval  => 'FREQ=DAILY; BYHOUR=12; BYMINUTE=0; BYSECOND=0', 
        enabled         => TRUE
    );
END;

SELECT job_name, enabled, state, next_run_date
FROM user_scheduler_jobs;