----------------------------------------Процедуры только для клиентов:----------------------------------------
alter session set container = BANK_APP_PDB;

--Получить текущий баланс счета
CREATE OR REPLACE PROCEDURE GetAccountBalance(
    P_ACCOUNT_ID IN NUMBER,
    P_BALANCE OUT NUMBER
) AS
BEGIN
    SELECT AMOUNT
    INTO P_BALANCE
    FROM admin_user.User_Account
    WHERE ID = P_ACCOUNT_ID;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No account found for ID: ' || P_ACCOUNT_ID);
        P_BALANCE := NULL;  -- Установим значение NULL в случае ошибки
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Multiple accounts found for ID: ' || P_ACCOUNT_ID);
        P_BALANCE := NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in GetAccountBalance: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETACCOUNTBALANCE' AND type = 'PROCEDURE';

--Получить историю всех транзакций клиента за указанный период времени
CREATE OR REPLACE PROCEDURE GetTransactionHistory(
    P_CLIENT_ID IN NUMBER,
    P_START_DATE IN DATE,
    P_END_DATE IN DATE,
    P_RESULT OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_RESULT FOR
        SELECT at.*
        FROM admin_user.Account_Transaction at
        JOIN admin_user.User_Account UA ON at.ACCOUNT_ID_FROM = UA.ID OR at.ACCOUNT_ID_TO = UA.ID
        WHERE UA.USER_ID = P_CLIENT_ID
        AND at.DATE_TIME BETWEEN P_START_DATE AND P_END_DATE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No transactions found for Client ID: ' || P_CLIENT_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in GetTransactionHistory: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'CREATESUPPORTREQUEST' AND type = 'PROCEDURE';

--Создать запрос в службу поддержки с указанием темы и содержимого
CREATE OR REPLACE PROCEDURE CreateSupportRequest(
    P_CLIENT_ID IN NUMBER,
    P_TYPE IN NVARCHAR2,
    P_CONTENT IN NVARCHAR2
) AS
BEGIN
    INSERT INTO admin_user.User_Support_Request (ID, TYPE, CONTENT, DATE_TIME, ACCOUNT_ID)
    VALUES (
        SEQ_SUPPORT_REQUEST_ID.NEXTVAL,
        P_TYPE,
        P_CONTENT,
        SYSTIMESTAMP,
        (SELECT ID FROM admin_user.User_Account WHERE USER_ID = P_CLIENT_ID FETCH FIRST ROW ONLY)
    );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No account found for Client ID: ' || P_CLIENT_ID);
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Duplicate value error while creating support request for Client ID: ' || P_CLIENT_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in CreateSupportRequest: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'CREATESUPPORTREQUEST' AND type = 'PROCEDURE';

--Подать заявку на кредит с указанием суммы и типа кредита
CREATE OR REPLACE PROCEDURE SubmitLoanApplication(
    P_CLIENT_ID IN NUMBER,
    P_AMOUNT IN NUMBER,
    P_CREDIT_TYPE_ID IN NUMBER
) AS
BEGIN
    INSERT INTO admin_user.Credits (ID, ACCOUNT_ID, AMOUNT, CREDIT_TYPE_ID, STATUS)
    VALUES (
        SEQ_CREDITS_ID.NEXTVAL,
        (SELECT ID FROM admin_user.User_Account WHERE USER_ID = P_CLIENT_ID FETCH FIRST ROW ONLY),
        P_AMOUNT,
        P_CREDIT_TYPE_ID,
        NULL
    );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No account found for Client ID: ' || P_CLIENT_ID);
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid amount or credit type ID provided for Client ID: ' || P_CLIENT_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in SubmitLoanApplication: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'SUBMITLOANAPPLICATION' AND type = 'PROCEDURE';

--Перевести средства с одного счета клиента на другой или на внешний счет
CREATE OR REPLACE PROCEDURE TransferFunds(
    P_ACCOUNT_ID_FROM IN NUMBER,
    P_ACCOUNT_ID_TO IN NUMBER,
    P_AMOUNT IN NUMBER
) AS
BEGIN
    UPDATE admin_user.User_Account
    SET AMOUNT = AMOUNT - P_AMOUNT
    WHERE ID = P_ACCOUNT_ID_FROM;

    UPDATE admin_user.User_Account
    SET AMOUNT = AMOUNT + P_AMOUNT
    WHERE ID = P_ACCOUNT_ID_TO;

    INSERT INTO admin_user.Account_Transaction (ID, ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME)
    VALUES (SEQ_TRANSACTION_ID.NEXTVAL, P_ACCOUNT_ID_FROM, P_ACCOUNT_ID_TO, P_AMOUNT, SYSTIMESTAMP);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('One of the accounts not found for Transfer. From ID: ' || P_ACCOUNT_ID_FROM || ', To ID: ' || P_ACCOUNT_ID_TO);
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid transfer amount provided.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in TransferFunds: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'TRANSFERFUNDS' AND type = 'PROCEDURE';


--Обменять средства с одного счета клиента на другой с использованием указанного курса обмена валют
CREATE OR REPLACE PROCEDURE ExchangeFunds(
    P_ACCOUNT_ID_FROM IN NUMBER,
    P_ACCOUNT_ID_TO IN NUMBER,
    P_AMOUNT IN NUMBER,
    P_EXCHANGE_RATE IN NUMBER
) AS
BEGIN
    UPDATE admin_user.User_Account
    SET AMOUNT = AMOUNT - P_AMOUNT
    WHERE ID = P_ACCOUNT_ID_FROM;

    UPDATE admin_user.User_Account
    SET AMOUNT = AMOUNT + (P_AMOUNT * P_EXCHANGE_RATE)
    WHERE ID = P_ACCOUNT_ID_TO;

    INSERT INTO admin_user.Account_Transaction (ID, ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME)
    VALUES (SEQ_TRANSACTION_ID.NEXTVAL, P_ACCOUNT_ID_FROM, P_ACCOUNT_ID_TO, P_AMOUNT, SYSTIMESTAMP);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('One of the accounts not found for Exchange. From ID: ' || P_ACCOUNT_ID_FROM || ', To ID: ' || P_ACCOUNT_ID_TO);
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid amount or exchange rate provided for Exchange.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in ExchangeFunds: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'EXCHANGEFUNDS' AND type = 'PROCEDURE';

--Изменить валюту счета
CREATE OR REPLACE PROCEDURE ChangeAccountCurrency(
    P_ACCOUNT_ID IN NUMBER,
    P_NEW_CURRENCY IN NVARCHAR2
) AS
BEGIN
    UPDATE admin_user.User_Account
    SET CURRENCY = P_NEW_CURRENCY
    WHERE ID = P_ACCOUNT_ID;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No account found for ID: ' || P_ACCOUNT_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in ChangeAccountCurrency: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'CHANGEACCOUNTCURRENCY' AND type = 'PROCEDURE';

--Автоматический перевод средств с одного счета на другой
CREATE OR REPLACE PROCEDURE AutoTransferFunds(
    P_ACCOUNT_ID_FROM IN NUMBER,
    P_ACCOUNT_ID_TO IN NUMBER,
    P_AMOUNT IN NUMBER
) AS
BEGIN
    UPDATE admin_user.User_Account
    SET AMOUNT = AMOUNT - P_AMOUNT
    WHERE ID = P_ACCOUNT_ID_FROM;

    UPDATE admin_user.User_Account
    SET AMOUNT = AMOUNT + P_AMOUNT
    WHERE ID = P_ACCOUNT_ID_TO;

    INSERT INTO admin_user.Account_Transaction (ID, ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME)
    VALUES (SEQ_TRANSACTION_ID.NEXTVAL, P_ACCOUNT_ID_FROM, P_ACCOUNT_ID_TO, P_AMOUNT, SYSTIMESTAMP);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('One of the accounts not found for Auto Transfer. From ID: ' || P_ACCOUNT_ID_FROM || ', To ID: ' || P_ACCOUNT_ID_TO);
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid transfer amount provided for Auto Transfer.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in AutoTransferFunds: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'AUTOTRANSFERFUNDS' AND type = 'PROCEDURE';

--Добавить банковскую карту
CREATE OR REPLACE PROCEDURE AddBankCard(
    P_ACCOUNT_ID IN NUMBER,
    P_CARD_NUMBER IN NVARCHAR2,
    P_STATUS IN NVARCHAR2
) AS
BEGIN
    INSERT INTO admin_user.Card (ID, ACCOUNT_ID, CARD_NUMBER, STATUS)
    VALUES (SEQ_CARD_ID.NEXTVAL, P_ACCOUNT_ID, P_CARD_NUMBER, P_STATUS);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No account found for ID: ' || P_ACCOUNT_ID);
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Duplicate card number provided for account ID: ' || P_ACCOUNT_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in AddBankCard: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'ADDBANKCARD' AND type = 'PROCEDURE';

--Удалить банковскую карту
CREATE OR REPLACE PROCEDURE DeleteBankCard(
    P_CARD_ID IN NUMBER
) AS
BEGIN
    DELETE FROM admin_user.Card
    WHERE ID = P_CARD_ID;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No card found for ID: ' || P_CARD_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in DeleteBankCard: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'DELETEBANKCARD' AND type = 'PROCEDURE';

--Авторизация клиента
CREATE OR REPLACE PROCEDURE LoginClient(  
    P_LOGIN IN NVARCHAR2, 
    P_PASSWORD IN NVARCHAR2, 
    P_IS_SUCCESS OUT NUMBER 
) AS 
BEGIN 
    SELECT COUNT(*) INTO P_IS_SUCCESS 
    FROM admin_user.App_User 
    WHERE LOGIN = P_LOGIN AND PASSWORD = P_PASSWORD; 

    -- Проверка результата и вывод сообщения
    IF P_IS_SUCCESS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Authorization successful.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Authorization failed: Invalid login or password.');
    END IF;

EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error in LoginClient: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')'); 
END;

SELECT * 
FROM user_errors 
WHERE name = 'LOGINCLIENT' AND type = 'PROCEDURE';

-- Регистрация клиента
CREATE OR REPLACE PROCEDURE RegisterClient(
    P_LOGIN        IN NVARCHAR2,
    P_PASSWORD     IN NVARCHAR2,
    P_EMAIL        IN NVARCHAR2,
    P_FIRST_NAME   IN NVARCHAR2,
    P_LAST_NAME    IN NVARCHAR2,
    P_MIDDLE_NAME  IN NVARCHAR2,
    P_ADDRESS      IN NVARCHAR2,
    P_BIRTH_DATE   IN DATE,
    P_PHONE_NUMBER IN NVARCHAR2,
    P_PASSPORT_NUM IN NVARCHAR2
) AS
    V_USER_ID NUMBER;
    V_COUNT_LOGIN NUMBER;
    V_COUNT_EMAIL NUMBER;
BEGIN
    -- Проверка существования P_LOGIN в App_User
    SELECT COUNT(*) INTO V_COUNT_LOGIN
    FROM admin_user.App_User
    WHERE LOGIN = P_LOGIN;

    -- Проверка существования P_EMAIL в User_Profile
    SELECT COUNT(*) INTO V_COUNT_EMAIL
    FROM admin_user.User_Profile
    WHERE EMAIL = P_EMAIL;

    -- Если LOGIN или EMAIL уже существуют, выбросить исключение
    IF V_COUNT_LOGIN > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Login already exists: ' || P_LOGIN);
    ELSIF V_COUNT_EMAIL > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Email already exists: ' || P_EMAIL);
    END IF;

    -- Устанавливаем точку сохранения для отката в случае ошибки
    SAVEPOINT BeforeInsert;

    -- Вставка нового пользователя в App_User
    INSERT INTO admin_user.App_User (LOGIN, PASSWORD)
    VALUES (P_LOGIN, P_PASSWORD)
    RETURNING ID INTO V_USER_ID;

    -- Вставка нового профиля в User_Profile
    INSERT INTO admin_user.User_Profile (
        USER_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, BIRTH_DATE,
        EMAIL, PASSPORT_NUM, PHONE_NUMBER
    )
    VALUES (
        V_USER_ID, P_FIRST_NAME, P_LAST_NAME, P_MIDDLE_NAME, P_ADDRESS, P_BIRTH_DATE,
        P_EMAIL, P_PASSPORT_NUM, P_PHONE_NUMBER
    );

EXCEPTION
    WHEN OTHERS THEN
        -- Откат изменений до точки сохранения
        ROLLBACK TO BeforeInsert;
        DBMS_OUTPUT.PUT_LINE('Error in RegisterClient: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
        RAISE; -- Повторно выбросить ошибку
END;

SELECT * 
FROM user_errors 
WHERE name = 'REGISTERCLIENT' AND type = 'PROCEDURE';
