alter session set container = BANK_APP_PDB;

-- Currency:
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO CURRENCY (NAME, CODE) VALUES ('Currency ' || i, 'CUR');
    END LOOP;
    COMMIT;
END;

SELECT * FROM CURRENCY;

SELECT SEQUENCE_NAME FROM USER_SEQUENCES;

DELETE FROM USER_ACCOUNT;
COMMIT;

SELECT * FROM Currency;

-- APP_USER:
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO APP_USER (LOGIN, PASSWORD) VALUES ('USER' || i, 'PASSWORD' || i);
    END LOOP;
    COMMIT;
END;

SELECT * FROM APP_USER;

-- USER_ACCOUNT:
DECLARE
    v_currency_id number;
    v_user_id number;
BEGIN
    FOR i IN 1..100000 LOOP
        SELECT ID INTO v_user_id
        FROM (
            SELECT ID FROM APP_USER ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        SELECT ID INTO v_currency_id
        FROM (
            SELECT ID FROM CURRENCY ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        INSERT INTO USER_ACCOUNT (ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID)
        VALUES (
            'ACC' || TO_CHAR(i),
            'CUR',  -- Используем фиксированное значение
            ROUND(DBMS_RANDOM.VALUE(100, 10000), 2),
            v_user_id
        );

        IF MOD(i, 1000) = 0 THEN
            COMMIT;
        END IF;
    END LOOP;

    COMMIT;
END;

SELECT * FROM USER_ACCOUNT;
SELECT * FROM USER_ACCOUNT WHERE AMOUNT = '1013,62';
SELECT * FROM App_User;

-- USER_PROFILE: -- исправить
DECLARE
    v_user_id NUMBER;
    v_exists NUMBER; -- Переменная для проверки существования
BEGIN
    FOR i IN 1..10 LOOP
        SELECT ID INTO v_user_id
        FROM (
            SELECT ID FROM APP_USER ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        -- Проверяем, существует ли запись с таким USER_ID
        SELECT COUNT(*) INTO v_exists
        FROM USER_PROFILE
        WHERE USER_ID = v_user_id;

        IF v_exists = 0 THEN
            INSERT INTO USER_PROFILE (
                USER_ID, 
                FIRST_NAME, 
                LAST_NAME, 
                MIDDLE_NAME, 
                ADDRESS, 
                BIRTH_DATE, 
                EMAIL, 
                PHONE_NUMBER, 
                PASSPORT_NUM
            )
            VALUES (
                v_user_id,
                'FIRST_NAME' || i,
                'LAST_NAME' || i,
                'MIDDLE_NAME' || i, -- Заполнение второго имени
                'Address ' || TO_CHAR(i), -- Заполнение адреса
                SYSDATE - (20 * i), -- Заполнение даты рождения (пример)
                'user' || i || '@example.com', -- Заполнение электронной почты
                '123456789' || TO_CHAR(i), -- Заполнение номера телефона
                'P123456' || TO_CHAR(i) -- Номер паспорта
            );
        END IF;

        COMMIT;
    END LOOP;
END;

SELECT * FROM USER_PROFILE;
SELECT * FROM APP_USER;

-- USER_SUPPORT_REQUEST:
DECLARE
    v_account_id number;
BEGIN
    FOR i IN 1..10 LOOP
        SELECT ID INTO v_account_id
        FROM (
            SELECT ID FROM USER_ACCOUNT ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        INSERT INTO USER_SUPPORT_REQUEST (TYPE, CONTENT, DATE_TIME, ACCOUNT_ID)
        VALUES (
            'Support Type ' || i,
            'Content of support request ' || i,
            SYSTIMESTAMP,
            v_account_id
        );

        COMMIT;
    END LOOP;
END;

SELECT * FROM USER_SUPPORT_REQUEST;

-- CURRENCY_EXCHANGE_RATE:
DECLARE
    v_source_id number;
    v_target_id number;
BEGIN
    FOR i IN 1..10 LOOP
        SELECT ID INTO v_source_id
        FROM (
            SELECT ID FROM CURRENCY ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        SELECT ID INTO v_target_id
        FROM (
            SELECT ID FROM CURRENCY ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        INSERT INTO CURRENCY_EXCHANGE_RATE (SOURCE_CURR_ID, TARGET_CURR_ID, RATE, RATE_DATE)
        VALUES (
            v_source_id,
            v_target_id,
            ROUND(DBMS_RANDOM.VALUE(1, 100), 2),
            SYSDATE
        );

        COMMIT;
    END LOOP;
END;

SELECT * FROM CURRENCY_EXCHANGE_RATE;

-- ACCOUNT_TRANSACTION:
DECLARE
    v_account_id_from number;
    v_account_id_to number;
BEGIN
    FOR i IN 1..10 LOOP
        SELECT ID INTO v_account_id_from
        FROM (
            SELECT ID FROM USER_ACCOUNT ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        SELECT ID INTO v_account_id_to
        FROM (
            SELECT ID FROM USER_ACCOUNT ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        INSERT INTO ACCOUNT_TRANSACTION (ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME)
        VALUES (
            v_account_id_from,
            v_account_id_to,
            ROUND(DBMS_RANDOM.VALUE(100, 1000), 2),
            SYSTIMESTAMP
        );

        COMMIT;
    END LOOP;
END;

SELECT * FROM ACCOUNT_TRANSACTION;

-- CARD:
DECLARE
    v_account_id number;
BEGIN
    FOR i IN 1..10 LOOP
        SELECT ID INTO v_account_id
        FROM (
            SELECT ID FROM USER_ACCOUNT ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        -- Генерируем уникальный номер карты, который не превышает 16 цифр
        INSERT INTO CARD (TYPE, ACCOUNT_ID, CARD_NAME, CARD_NUMBER, DESCRIPTION, STATUS)
        VALUES (
            'VISA',
            v_account_id,
            'Card ' || i,
            MOD(1234567812345678 + i, 10000000000000000),  -- Убедитесь, что итоговое значение не превышает 16 цифр
            'Description for card ' || i,
            'Active'
        );

        COMMIT;
    END LOOP;
END;

SELECT * FROM CARD;

-- CREDIT_TYPE: 
BEGIN
    FOR i IN 1..5 LOOP
        INSERT INTO CREDIT_TYPE (TYPE, CREDIT_NAME, DESCRIPTION)
        VALUES (
            'Type ' || i,
            'Credit Name ' || i,
            'Description for credit type ' || i
        );
    END LOOP;
    COMMIT;
END;

SELECT * FROM CREDIT_TYPE;

-- PAYMENT_SERVICE: 
DECLARE
    v_transaction_id number;
BEGIN
    FOR i IN 1..10 LOOP
        SELECT ID INTO v_transaction_id
        FROM (
            SELECT ID FROM ACCOUNT_TRANSACTION ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        INSERT INTO PAYMENT_SERVICE (NAME, TYPE, TRANSACTION_ID)
        VALUES (
            'Payment Service ' || i,
            'Type ' || MOD(i, 3),
            v_transaction_id
        );

        COMMIT;
    END LOOP;
END;

SELECT * FROM PAYMENT_SERVICE;

-- CREDITS:
DECLARE
    v_credit_type_id number;
    v_account_id number;
BEGIN
    FOR i IN 1..10 LOOP
        SELECT ID INTO v_credit_type_id
        FROM (
            SELECT ID FROM CREDIT_TYPE ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        SELECT ID INTO v_account_id
        FROM (
            SELECT ID FROM USER_ACCOUNT ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        INSERT INTO CREDITS (CREDIT_TYPE_ID, ACCOUNT_ID, AMOUNT, STATUS)
        VALUES (
            v_credit_type_id,
            v_account_id,
            ROUND(DBMS_RANDOM.VALUE(1000, 5000), 2),
            CASE WHEN MOD(i, 2) = 0 THEN '0' ELSE '+' END
        );

        COMMIT;
    END LOOP;
END;

SELECT * FROM Credits;
