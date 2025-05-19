----------------------------------------Процедуры только для администраторов (сотрудников банка):----------------------------------------
alter session set container = BANK_APP_PDB;

-- Получить информацию о транзакции по её идентификатору
CREATE OR REPLACE PROCEDURE GetTransactionById(
    P_TRANSACTION_ID IN NUMBER,
    P_RESULT OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_RESULT FOR
        SELECT *
        FROM admin_user.Account_Transaction
        WHERE ID = P_TRANSACTION_ID;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Transaction not found for the given ID.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'An unexpected error occurred: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETTRANSACTIONBYID' AND type = 'PROCEDURE';

-- Получить информацию о банковской карте по её идентификатору
CREATE OR REPLACE PROCEDURE GetCardById(
    P_CARD_ID IN NUMBER,
    P_RESULT OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_RESULT FOR
        SELECT *
        FROM admin_user.Card
        WHERE ID = P_CARD_ID;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'Card not found for the given ID.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'An unexpected error occurred: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETCARDBYID' AND type = 'PROCEDURE';

-- Добавить тип кредита
CREATE OR REPLACE PROCEDURE AddLoanType(
    P_TYPE IN NVARCHAR2,
    P_CREDIT_NAME IN NVARCHAR2,
    P_DESCRIPTION IN NVARCHAR2
) AS
BEGIN
    INSERT INTO admin_user.Credit_Type (ID, TYPE, CREDIT_NAME, DESCRIPTION)
    VALUES (SEQ_CREDIT_TYPE_ID.NEXTVAL, P_TYPE, P_CREDIT_NAME, P_DESCRIPTION);

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20005, 'Duplicate value error while adding loan type.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20006, 'An unexpected error occurred: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'ADDLOANTYPE' AND type = 'PROCEDURE';

-- Изменить тип кредита
CREATE OR REPLACE PROCEDURE UpdateLoanType(
    P_CREDIT_TYPE_ID IN NUMBER,
    P_TYPE IN NVARCHAR2,
    P_CREDIT_NAME IN NVARCHAR2,
    P_DESCRIPTION IN NVARCHAR2
) AS
BEGIN
    UPDATE admin_user.Credit_Type
    SET TYPE = P_TYPE,
        CREDIT_NAME = P_CREDIT_NAME,
        DESCRIPTION = P_DESCRIPTION
    WHERE ID = P_CREDIT_TYPE_ID;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Loan type not found for the given ID.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20008, 'An unexpected error occurred: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'UPDATELOANTYPE' AND type = 'PROCEDURE';

-- Удалить тип кредита
CREATE OR REPLACE PROCEDURE DeleteLoanType(
    P_CREDIT_TYPE_ID IN NUMBER
) AS
BEGIN
    DELETE FROM admin_user.Credit_Type
    WHERE ID = P_CREDIT_TYPE_ID;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20009, 'Loan type not found for the given ID.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20010, 'An unexpected error occurred: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'DELETELOANTYPE' AND type = 'PROCEDURE';

-- Добавить новую валюту
CREATE OR REPLACE PROCEDURE AddNewCurrency(
    P_NAME IN VARCHAR2,
    P_CODE IN VARCHAR2
) AS
BEGIN
    INSERT INTO admin_user.Currency (ID, NAME, CODE)
    VALUES (SEQ_CURRENCY_ID.NEXTVAL, P_NAME, P_CODE);

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20011, 'Currency code already exists.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20012, 'An unexpected error occurred: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'ADDNEWCURRENCY' AND type = 'PROCEDURE';

-- Изменить информацию о валюте
CREATE OR REPLACE PROCEDURE UpdateCurrencyInfo(
    P_CURRENCY_ID IN NUMBER,
    P_NAME IN VARCHAR2,
    P_CODE IN VARCHAR2
) AS
BEGIN
    UPDATE admin_user.Currency
    SET NAME = P_NAME, CODE = P_CODE
    WHERE ID = P_CURRENCY_ID;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20013, 'Currency not found for the given ID.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20014, 'An unexpected error occurred: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'UPDATECURRENCYINFO' AND type = 'PROCEDURE';

-- Получить информацию о клиенте по идентификатору клиента
CREATE OR REPLACE PROCEDURE GetClientInfoById(
    P_CLIENT_ID IN NUMBER,
    P_RESULT OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_RESULT FOR
        SELECT *
        FROM admin_user.App_User
        WHERE ID = P_CLIENT_ID;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20015, 'Client not found for the given ID.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20016, 'An unexpected error occurred: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETCLIENTINFOBYID' AND type = 'PROCEDURE';

-- Получить информацию о счёте клиента по  идентификатору клиента
CREATE OR REPLACE PROCEDURE GetClientAccountById(
    P_CLIENT_ID IN NUMBER,
    P_RESULT OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_RESULT FOR
        SELECT *
        FROM admin_user.User_Account
        WHERE USER_ID = P_CLIENT_ID;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20031, 'No accounts found for the given client ID.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20032, 'An unexpected error occurred while fetching client accounts: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETCLIENTACCOUNTBYID' AND type = 'PROCEDURE';

-- Получить информацию о кредитах клиента по идентификатору клиента
CREATE OR REPLACE PROCEDURE GetClientLoansById(
    P_CLIENT_ID IN NUMBER,
    P_RESULT OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_RESULT FOR
        SELECT *
        FROM admin_user.Credits
        WHERE ACCOUNT_ID IN (
            SELECT ID FROM admin_user.User_Account WHERE USER_ID = P_CLIENT_ID
        );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20033, 'No loans found for the given client ID.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20034, 'An unexpected error occurred while fetching client loans: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETCLIENTLOANSBYID' AND type = 'PROCEDURE';

-- Получить информацию о всех банковских картах клиента
CREATE OR REPLACE PROCEDURE GetAllClientCardsById(
    P_CLIENT_ID IN NUMBER,
    P_RESULT OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_RESULT FOR
        SELECT *
        FROM admin_user.Card
        WHERE ACCOUNT_ID IN (
            SELECT ID FROM admin_user.User_Account WHERE USER_ID = P_CLIENT_ID
        );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20035, 'No cards found for the given client ID.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20036, 'An unexpected error occurred while fetching all client cards: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLCLIENTCARDSBYID' AND type = 'PROCEDURE';

-- Добавить новую транзакцию клиенту
CREATE OR REPLACE PROCEDURE AddLoanTransaction(
    P_ACCOUNT_ID_FROM IN NUMBER,
    P_ACCOUNT_ID_TO IN NUMBER,
    P_AMOUNT IN NUMBER
) AS
BEGIN
    INSERT INTO admin_user.Account_Transaction (ID, ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME)
    VALUES (SEQ_TRANSACTION_ID.NEXTVAL, P_ACCOUNT_ID_FROM, P_ACCOUNT_ID_TO, P_AMOUNT, SYSTIMESTAMP);

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20017, 'An unexpected error occurred while adding a loan transaction: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'ADDLOANTRANSACTION' AND type = 'PROCEDURE';

-- Изменить статус банковской карты клиента (заблокирована / доступна)
CREATE OR REPLACE PROCEDURE UpdateClientCardStatus(
    P_CARD_ID IN NUMBER,
    P_STATUS IN NVARCHAR2
) AS
BEGIN
    UPDATE admin_user.Card
    SET STATUS = P_STATUS
    WHERE ID = P_CARD_ID;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20018, 'Card not found for the given ID.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20019, 'An unexpected error occurred while updating card status: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'UPDATECLIENTCARDSTATUS' AND type = 'PROCEDURE';

-- Получить все счета клиентов
CREATE OR REPLACE PROCEDURE GetAllClientsAccounts(
    P_RESULT OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_RESULT FOR
        SELECT *
        FROM admin_user.User_Account;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20027, 'An unexpected error occurred while fetching all client accounts: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLCLIENTSACCOUNTS' AND type = 'PROCEDURE';

-- Получить список всех клиентов и информацию о них
CREATE OR REPLACE PROCEDURE GetAllClientInfos(
    P_RESULT OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_RESULT FOR
        SELECT AU.*, UP.*
        FROM admin_user.App_User AU
                 LEFT JOIN admin_user.User_Profile UP ON AU.ID = UP.USER_ID;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20028, 'An unexpected error occurred while fetching all client information: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLCLIENTINFOS' AND type = 'PROCEDURE';

-- Получить список всех банковских карт клиента по идентификатору клиента
CREATE OR REPLACE PROCEDURE GetAllClientCards(
    P_CLIENT_ID IN NUMBER,
    P_RESULT OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_RESULT FOR
        SELECT C.*
        FROM admin_user.Card C
                 JOIN admin_user.User_Account UA ON C.ACCOUNT_ID = UA.ID
        WHERE UA.USER_ID = P_CLIENT_ID;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20029, 'No cards found for the given client ID.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20030, 'An unexpected error occurred while fetching client cards: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLCLIENTCARDS' AND type = 'PROCEDURE';

-- Одобрить или отклонить заявку на получение кредита
CREATE OR REPLACE PROCEDURE ProcessLoanApplication(
    P_LOAN_ID IN NUMBER,
    P_STATUS IN NVARCHAR2
) AS
BEGIN
    UPDATE admin_user.Credits
    SET STATUS = P_STATUS
    WHERE ID = P_LOAN_ID;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20023, 'Loan application not found for the given ID.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20024, 'An unexpected error occurred while processing the loan application: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'PROCESSLOANAPPLICATION' AND type = 'PROCEDURE';

-- Получить список всех заявок на кредиты
CREATE OR REPLACE PROCEDURE GetLoanApplications(
    P_RESULT OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN P_RESULT FOR
        SELECT *
        FROM admin_user.Credits
        WHERE STATUS IS NULL; -- Заявки без статуса считаются необработанными

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20025, 'An unexpected error occurred while fetching loan applications: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETLOANAPPLICATIONS' AND type = 'PROCEDURE';

--Добавить счет клиенту
CREATE OR REPLACE PROCEDURE AddAccountToClient( --TODO: исправить
    P_USER_ID IN NUMBER,
    P_CURRENCY IN NVARCHAR2
) AS
BEGIN
    INSERT INTO admin_user.User_Account (ID, ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID)
    VALUES (
               SEQ_ACCOUNT_ID.NEXTVAL,
               GENERATE_ACCOUNT_NUMBER(),
               P_CURRENCY,
               0,
               P_USER_ID
           );

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20026, 'An unexpected error occurred while adding an account to the client: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'ADDACCOUNTTOCLIENT' AND type = 'PROCEDURE';

--Закрыть счет клиенту
CREATE OR REPLACE PROCEDURE CloseClientAccount(
    P_ACCOUNT_ID IN NUMBER
) AS
    ACCOUNT_BALANCE NUMBER;
BEGIN
    SELECT AMOUNT INTO ACCOUNT_BALANCE
    FROM admin_user.User_Account
    WHERE ID = P_ACCOUNT_ID;

    IF ACCOUNT_BALANCE != 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'Account balance must be zero to close the account.');
    ELSE
        DELETE FROM admin_user.User_Account WHERE ID = P_ACCOUNT_ID;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20021, 'Account not found for the given ID.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20022, 'An unexpected error occurred while closing the account: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'CLOSECLIENTACCOUNT' AND type = 'PROCEDURE';