----------------------------------------Процедуры для всех:----------------------------------------
alter pluggable database BANK_APP_PDB open;
alter session set container = BANK_APP_PDB;

--Получить список всех валют и их курс обмена
CREATE OR REPLACE PROCEDURE GetListCurrenciesAndExchangeRates AS 
BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_LANGUAGE = ''ENGLISH''';

    FOR rec IN (
        SELECT 
            c.ID AS Currency_ID,
            c.NAME AS Currency_Name,
            c.CODE AS Currency_Code,
            r.BUY AS Buy_Rate,
            r.SALE AS Sale_Rate,
            r.POSTING_DATE AS Rate_Date
        FROM admin_user.Currency c
        LEFT JOIN admin_user.Currency_Exchange_Rate r 
        ON c.ID = r.CURR_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            rec.Currency_Name || ' (' || rec.Currency_Code || ')' ||
            ', Buy: ' || NVL(TO_CHAR(rec.Buy_Rate, 'FM9999999990D00'), 'N/A') || 
            ', Sale: ' || NVL(TO_CHAR(rec.Sale_Rate, 'FM9999999990D00'), 'N/A') || 
            ', Rate Date: ' || NVL(TO_CHAR(rec.Rate_Date, 'DD-MON-YYYY'), 'N/A')
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in GetListCurrenciesAndExchangeRates: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETLISTCURRENCIESANDEXCHANGERATES' AND type = 'PROCEDURE';

--Получить информацию о профиле пользователя
CREATE OR REPLACE PROCEDURE GetClientProfileInfo(P_USER_ID IN NUMBER) AS
BEGIN
    IF P_USER_ID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error: P_USER_ID must be a positive integer.');
    END IF;

    FOR rec IN (
        SELECT 
            up.FIRST_NAME,
            up.BIRTH_DATE,
            up.EMAIL,
            au.LOGIN
        FROM 
            admin_user.User_Profile up
        JOIN 
            admin_user.App_User au ON up.USER_ID = au.ID
        WHERE 
            up.USER_ID = P_USER_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            
            'Login: ' || rec.LOGIN ||
            ', First Name: ' || rec.FIRST_NAME ||
            ', Birth Date: ' || TO_CHAR(rec.BIRTH_DATE, 'YYYY-MM-DD') ||
            ', Email: ' || rec.EMAIL
        );
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No profile found for User ID: ' || P_USER_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in GetClientProfileInfo: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETCLIENTPROFILEINFO' AND type = 'PROCEDURE';

--Получить все запросы в службу поддержки, проведенные клиентом за определенный период времени
CREATE OR REPLACE PROCEDURE GetAllClientSupportRequests(
    P_USER_ID IN NUMBER,
    P_START_DATE IN DATE,
    P_END_DATE IN DATE
) AS
    v_user_exists NUMBER; 
    v_requests_count NUMBER; 
BEGIN
    IF P_USER_ID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'User ID cannot be null.');
    ELSIF NOT REGEXP_LIKE(P_USER_ID, '^[0-9]+$') THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error: P_USER_ID must be a positive integer and contain only digits.');
    ELSIF P_START_DATE IS NULL OR P_END_DATE IS NULL THEN
        RAISE_APPLICATION_ERROR(-20003, 'Start date and end date cannot be null.');
    ELSIF P_START_DATE > P_END_DATE THEN
        RAISE_APPLICATION_ERROR(-20004, 'Start date cannot be later than end date.');
    END IF;

    SELECT COUNT(*) INTO v_user_exists
    FROM admin_user.App_User
    WHERE ID = P_USER_ID;

    IF v_user_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Error: User with ID ' || P_USER_ID || ' does not exist.');
    END IF;

    SELECT COUNT(*) INTO v_requests_count
    FROM admin_user.User_Support_Requests
    WHERE USER_ID = P_USER_ID
      AND DATE_TIME BETWEEN P_START_DATE AND P_END_DATE;

    IF v_requests_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No support requests found for User ID: ' || P_USER_ID || ' within the specified period.');
        RETURN;
    END IF;

    -- Основной запрос для получения данных
    FOR rec IN (
        SELECT 
            usr.ID AS Support_Request_ID,
            usr.CONTENT AS Request_Content,
            usr.DATE_TIME AS Request_Date
        FROM admin_user.User_Support_Requests usr
        WHERE usr.USER_ID = P_USER_ID
          AND usr.DATE_TIME BETWEEN P_START_DATE AND P_END_DATE
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Support Request ID: ' || rec.Support_Request_ID || 
            ', Content: ' || DBMS_LOB.SUBSTR(rec.Request_Content, 100, 1) || 
            ', Date Time: ' || TO_CHAR(rec.Request_Date, 'YYYY-MM-DD HH24:MI:SS')
        );
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No support requests found for User ID: ' || P_USER_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in GetAllClientSupportRequests: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLCLIENTSUPPORTREQUESTS' AND type = 'PROCEDURE';

--Просмотреть информацию о типах кредитов
CREATE OR REPLACE PROCEDURE GetAllCreditTypes AS 
BEGIN
    FOR rec IN (
        SELECT * FROM admin_user.Credit_Type
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Credit Type ID: ' || rec.ID || ', Type: ' || rec.TYPE || ', Name: ' || rec.CREDIT_NAME);
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in GetAllCreditTypes: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLCREDITTYPES' AND type = 'PROCEDURE';

--Просмотреть все счета клиента по его идентификатору
CREATE OR REPLACE PROCEDURE GetListOfClientAccountsByClientId(
    P_CLIENT_ID IN NUMBER
) AS
BEGIN
    FOR rec IN (
        SELECT ua.ID, ua.ACCOUNT_NUMBER, ua.AMOUNT, c.NAME AS CURRENCY_NAME, c.CODE AS CURRENCY_CODE
        FROM admin_user.User_Account ua
        JOIN admin_user.Currency c ON ua.CURRENCY_ID = c.ID
        WHERE ua.USER_ID = P_CLIENT_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Account ID: ' || rec.ID || 
                             ', Account Number: ' || rec.ACCOUNT_NUMBER || 
                             ', Amount: ' || rec.AMOUNT || 
                             ', Currency: ' || rec.CURRENCY_NAME || 
                             ' (' || rec.CURRENCY_CODE || ')');
    END LOOP;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No accounts found for Client ID: ' || P_CLIENT_ID);
    END IF;

EXCEPTION 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in GetListOfClientAccountsByClientId: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETLISTOFCLIENTACCOUNTSBYCLIENTID' AND type = 'PROCEDURE';

--Удалить профиль клиента
CREATE OR REPLACE PROCEDURE DeleteClientProfile(P_USER_ID IN NUMBER) AS
    ACCOUNT_COUNT NUMBER;
    USER_EXISTS NUMBER;
BEGIN
    IF P_USER_ID IS NULL OR P_USER_ID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'User ID must be a positive integer.');
    END IF;

    SELECT COUNT(*) INTO USER_EXISTS 
    FROM admin_user.App_User 
    WHERE ID = P_USER_ID;

    IF USER_EXISTS = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'No user found with ID: ' || P_USER_ID);
    END IF;

    SELECT COUNT(*) INTO ACCOUNT_COUNT 
    FROM admin_user.User_Account 
    WHERE USER_ID = P_USER_ID AND AMOUNT != 0;

    IF ACCOUNT_COUNT > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'All accounts must have zero balance before deleting the profile.');
    END IF;

    DELETE FROM admin_user.User_Profile WHERE USER_ID = P_USER_ID;
    DELETE FROM admin_user.App_User WHERE ID = P_USER_ID;

    DBMS_OUTPUT.PUT_LINE('Client profile deleted successfully for User ID: ' || P_USER_ID);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found for User ID: ' || P_USER_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in DeleteClientProfile: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
        RAISE;
END;

SELECT * 
FROM user_errors 
WHERE name = 'DELETECLIENTPROFILE' AND type = 'PROCEDURE';