----------------------------------------Процедуры для всех:----------------------------------------
alter pluggable database BANK_APP_PDB open;
alter session set container = BANK_APP_PDB;

--Получить список всех валют и их курс обмена
CREATE OR REPLACE PROCEDURE GetAllCurrencies AS 
BEGIN
    FOR rec IN (
        SELECT c.ID, c.NAME, c.CODE, r.RATE, r.RATE_DATE 
        FROM admin_user.Currency c 
        LEFT JOIN admin_user.Currency_Exchange_Rate r ON c.ID = r.SOURCE_CURR_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.ID || ', Name: ' || rec.NAME || ', Code: ' || rec.CODE || 
                             ', Rate: ' || NVL(rec.RATE, 'N/A') || ', Rate Date: ' || NVL(TO_CHAR(rec.RATE_DATE, 'DD-MON-YYYY'), 'N/A'));
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in GetAllCurrencies: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLCURRENCIES' AND type = 'PROCEDURE';

--Получить информацию о профиле пользователя
CREATE OR REPLACE PROCEDURE GetClientProfileInfo(P_USER_ID IN NUMBER) AS 
BEGIN
    FOR rec IN (
        SELECT up.ID AS Profile_ID, 
               up.USER_ID AS Profile_User_ID,  -- Псевдоним для USER_ID из User_Profile
               up.FIRST_NAME, 
               up.LAST_NAME, 
               up.MIDDLE_NAME, 
               up.ADDRESS, 
               up.BIRTH_DATE, 
               up.EMAIL, 
               up.PHONE_NUMBER, 
               up.PASSPORT_NUM, 
               au.ID AS App_User_ID,  -- Псевдоним для ID из App_User
               au.LOGIN, 
               au.PASSWORD 
        FROM admin_user.User_Profile up 
        JOIN admin_user.App_User au ON up.USER_ID = au.ID 
        WHERE up.USER_ID = P_USER_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Profile ID: ' || rec.Profile_ID || 
                             ', User Profile ID: ' || rec.Profile_User_ID || 
                             ', App User ID: ' || rec.App_User_ID || 
                             ', Login: ' || rec.LOGIN || 
                             ', First Name: ' || rec.FIRST_NAME || 
                             ', Last Name: ' || rec.LAST_NAME || 
                             ', Middle Name: ' || rec.MIDDLE_NAME || 
                             ', Address: ' || rec.ADDRESS || 
                             ', Birth Date: ' || rec.BIRTH_DATE || 
                             ', Email: ' || rec.EMAIL || 
                             ', Phone Number: ' || rec.PHONE_NUMBER || 
                             ', Passport Number: ' || rec.PASSPORT_NUM);
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
CREATE OR REPLACE PROCEDURE GetAllClientSupportRequests(P_USER_ID IN NUMBER, P_START_DATE IN DATE, P_END_DATE IN DATE) AS 
BEGIN
    FOR rec IN (
        SELECT * 
        FROM admin_user.User_Support_Request 
        WHERE ACCOUNT_ID IN (
            SELECT ID FROM admin_user.User_Account WHERE USER_ID = P_USER_ID
        ) 
        AND DATE_TIME BETWEEN P_START_DATE AND P_END_DATE
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Support Request ID: ' || rec.ID || ', Content: ' || rec.CONTENT || ', Date Time: ' || rec.DATE_TIME);
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
CREATE OR REPLACE PROCEDURE GetListOfClientAccountsByClientId(P_CLIENT_ID IN NUMBER) AS 
BEGIN
    FOR rec IN (
        SELECT * FROM admin_user.User_Account WHERE USER_ID = P_CLIENT_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Account ID: ' || rec.ID || ', Account Number: ' || rec.ACCOUNT_NUMBER || ', Amount: ' || rec.AMOUNT);
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No accounts found for Client ID: ' || P_CLIENT_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in GetListOfClientAccountsByClientId: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETLISTOFCLIENTACCOUNTSBYCLIENTID' AND type = 'PROCEDURE';

--Удалить профиль клиента
CREATE OR REPLACE PROCEDURE DeleteClientProfile(P_USER_ID IN NUMBER) AS 
    ACCOUNT_COUNT NUMBER;
BEGIN
    SELECT COUNT(*) INTO ACCOUNT_COUNT 
    FROM admin_user.User_Account 
    WHERE USER_ID = P_USER_ID AND AMOUNT != 0;

    IF ACCOUNT_COUNT > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'All accounts must have zero balance before deleting the profile.');
    ELSE
        DELETE FROM admin_user.User_Profile WHERE USER_ID = P_USER_ID;
        DELETE FROM admin_user.App_User WHERE ID = P_USER_ID;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No profile found for User ID: ' || P_USER_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in DeleteClientProfile: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'DELETECLIENTPROFILE' AND type = 'PROCEDURE';