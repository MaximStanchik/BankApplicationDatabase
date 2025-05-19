----------------------------------------Процедуры только для администраторов (сотрудников банка):----------------------------------------
alter session set container = BANK_APP_PDB;

-- Получить информацию о транзакции по её идентификатору
CREATE OR REPLACE PROCEDURE GetTransactionById(
    P_TRANSACTION_ID IN NUMBER,
    P_ID OUT NUMBER,
    P_ACCOUNT_ID_FROM OUT NUMBER,
    P_ACCOUNT_ID_TO OUT NUMBER,
    P_AMOUNT OUT NUMBER,
    P_DATE_TIME OUT TIMESTAMP,
    P_CURRENCY_NAME OUT VARCHAR2,
    P_CURRENCY_CODE OUT VARCHAR2
) AS
BEGIN
    SELECT at.ID, at.ACCOUNT_ID_FROM, at.ACCOUNT_ID_TO, at.AMOUNT, at.DATE_TIME, 
           c.NAME, c.CODE
    INTO P_ID, P_ACCOUNT_ID_FROM, P_ACCOUNT_ID_TO, P_AMOUNT, P_DATE_TIME, 
         P_CURRENCY_NAME, P_CURRENCY_CODE
    FROM admin_user.Account_Transaction at
    JOIN admin_user.Currency c ON at.CURRENCY_ID = c.ID
    WHERE at.ID = P_TRANSACTION_ID;

    DBMS_OUTPUT.PUT_LINE('Transaction ID: ' || P_ID || 
                         ', From Account ID: ' || P_ACCOUNT_ID_FROM || 
                         ', To Account ID: ' || P_ACCOUNT_ID_TO || 
                         ', Amount: ' || P_AMOUNT || 
                         ' ' || P_CURRENCY_NAME || ' (' || P_CURRENCY_CODE || ')' ||
                         ', Date and Time: ' || P_DATE_TIME);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Transaction not found for the given ID.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'An unexpected error occurred: ' || SQLERRM);
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETTRANSACTIONBYID' AND type = 'PROCEDURE';

-- Получить информацию о банковской карте по её идентификатору
CREATE OR REPLACE PROCEDURE GetCardById(
    P_CARD_ID IN NUMBER
) AS
    v_id NUMBER;
    v_account_id NUMBER;
    v_card_name NVARCHAR2(100);
    v_card_number NVARCHAR2(16);
    v_description NVARCHAR2(255);
    v_status NVARCHAR2(20);
    v_payment_service_name NVARCHAR2(100);
    v_payment_service_type NVARCHAR2(50);
BEGIN
    SELECT C.ID, 
           C.ACCOUNT_ID, 
           C.CARD_NAME, 
           C.CARD_NUMBER, 
           C.DESCRIPTION, 
           C.STATUS,
           PS.NAME,
           PS.TYPE
    INTO v_id, 
         v_account_id, 
         v_card_name, 
         v_card_number, 
         v_description, 
         v_status,
         v_payment_service_name, 
         v_payment_service_type
    FROM admin_user.Card C
    JOIN admin_user.Payment_Service PS ON C.PAYMENT_SERVICE = PS.ID
    WHERE C.ID = P_CARD_ID;

    DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || 
                         ', Account ID: ' || v_account_id || 
                         ', Card Name: ' || v_card_name || 
                         ', Card Number: ' || v_card_number || 
                         ', Description: ' || v_description || 
                         ', Status: ' || v_status || 
                         ', Payment Service Name: ' || v_payment_service_name || 
                         ', Payment Service Type: ' || v_payment_service_type);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'Card not found for the given ID.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'An unexpected error occurred: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END GetCardById;

SELECT * 
FROM user_errors 
WHERE name = 'GETCARDBYID' AND type = 'PROCEDURE';

-- Добавить тип кредита
CREATE OR REPLACE PROCEDURE AddLoanType(
    P_TYPE IN NVARCHAR2,
    P_CREDIT_NAME IN NVARCHAR2,
    P_DESCRIPTION IN NVARCHAR2
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM admin_user.Credit_Type
    WHERE TYPE = P_TYPE AND CREDIT_NAME = P_CREDIT_NAME;

    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Credit type with name "' || P_CREDIT_NAME || '" already exists.');
    ELSE
        SELECT COUNT(*)
        INTO v_count
        FROM admin_user.Credit_Type
        WHERE TYPE = P_TYPE;

        IF v_count > 0 THEN
            UPDATE admin_user.Credit_Type
            SET CREDIT_NAME = P_CREDIT_NAME,
                DESCRIPTION = P_DESCRIPTION
            WHERE TYPE = P_TYPE;

        ELSE
            INSERT INTO admin_user.Credit_Type (TYPE, CREDIT_NAME, DESCRIPTION)
            VALUES (P_TYPE, P_CREDIT_NAME, P_DESCRIPTION);
        END IF;

        DBMS_OUTPUT.PUT_LINE('Procedure executed successfully.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(
            -20006,
            'An unexpected error occurred: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')'
        );
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
    ELSE
        DBMS_OUTPUT.PUT_LINE('Loan type updated successfully for ID: ' || P_CREDIT_TYPE_ID);
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
    ELSE
        DBMS_OUTPUT.PUT_LINE('Loan type deleted successfully for ID: ' || P_CREDIT_TYPE_ID);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20010, 'An unexpected error occurred: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'DELETELOANTYPE' AND type = 'PROCEDURE';

-- Изменить информацию о валюте
CREATE OR REPLACE PROCEDURE UpdateCurrencyInfo(
    P_CURRENCY_ID IN NUMBER,
    P_NAME IN VARCHAR2,
    P_CODE IN VARCHAR2,
    P_BUY IN NUMBER,
    P_SALE IN NUMBER
) AS
BEGIN
    UPDATE admin_user.Currency
    SET NAME = P_NAME, CODE = P_CODE
    WHERE ID = P_CURRENCY_ID;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20013, 'Currency not found for the given ID.');
    END IF;

    UPDATE admin_user.Currency_Exchange_Rate
    SET BUY = P_BUY, SALE = P_SALE
    WHERE CURR_ID = P_CURRENCY_ID;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20015, 'Exchange rate not found for the given Currency ID.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Currency information and exchange rates updated successfully for Currency ID: ' || P_CURRENCY_ID);

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20014, 'An unexpected error occurred: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'UPDATECURRENCYINFO' AND type = 'PROCEDURE';

--Добавить курс обмена для любой валюты (кроме доллара США)
CREATE OR REPLACE PROCEDURE AddCurrencyExchangeRate(
    p_curr_id NUMBER,
    p_buy NUMBER,
    p_sale NUMBER
) IS
BEGIN
    IF p_curr_id IS NULL OR p_curr_id <= 0 OR MOD(p_curr_id, 1) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Идентификатор валюты должен быть положительным целым числом.');
    END IF;

    IF p_curr_id = 1 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Нельзя добавлять курс обмена для доллара США.');
    END IF;

    IF p_buy <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Курс покупки должен быть положительным числом.');
    END IF;

    IF p_sale <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Курс продажи должен быть положительным числом.');
    END IF;

    INSERT INTO admin_user.Currency_Exchange_Rate (CURR_ID, BUY, SALE, POSTING_DATE)
    VALUES (p_curr_id, p_buy, p_sale, SYSDATE);

    COMMIT; 
    DBMS_OUTPUT.PUT_LINE('Курс обмена успешно добавлен для валюты с идентификатором ' || p_curr_id);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
END;

SELECT * 
FROM user_errors 
WHERE name = 'ADDCURRENCYEXCHANGERATE' AND type = 'PROCEDURE';

-- Получить информацию о кредитах клиента по идентификатору клиента
CREATE OR REPLACE PROCEDURE GetClientLoansById(P_CLIENT_ID IN NUMBER) AS 
    v_loans SYS_REFCURSOR; 
    v_id NUMBER; 
    v_credit_type_id NUMBER; 
    v_account_id NUMBER; 
    v_amount NUMBER; 
    v_debt_amount NUMBER; 
    v_remaining_amount NUMBER; 
    v_status VARCHAR2(8); 
    v_currency_code VARCHAR2(3); 
    v_issued_date DATE; 
    v_maturity_date DATE; 
    v_interest_rate NUMBER(5, 2); 
    v_payment_frequency VARCHAR2(30); 
    v_payment_amount NUMBER(15, 2); 
    v_loan_purpose VARCHAR2(255);  
    v_payment_day NUMBER; 
BEGIN 
    OPEN v_loans FOR 
        SELECT c.ID, 
               c.CREDIT_TYPE_ID, 
               c.ACCOUNT_ID, 
               c.AMOUNT, 
               c.DEBT_AMOUNT, 
               c.REMAINING_AMOUNT, 
               c.STATUS, 
               cur.CODE, 
               c.ISSUED_DATE, 
               c.MATURITY_DATE, 
               c.INTEREST_RATE, 
               c.PAYMENT_FREQUENCY, 
               c.PAYMENT_AMOUNT, 
               c.LOAN_PURPOSE,
               c.PAYMENT_DAY  
        FROM admin_user.Credits c 
        JOIN admin_user.Currency cur ON c.CURRENCY_ID = cur.ID 
        WHERE c.ACCOUNT_ID IN ( 
            SELECT ID FROM admin_user.User_Account WHERE USER_ID = P_CLIENT_ID 
        ); 

    LOOP 
        FETCH v_loans INTO v_id, 
                          v_credit_type_id, 
                          v_account_id, 
                          v_amount, 
                          v_debt_amount, 
                          v_remaining_amount, 
                          v_status, 
                          v_currency_code, 
                          v_issued_date, 
                          v_maturity_date, 
                          v_interest_rate, 
                          v_payment_frequency, 
                          v_payment_amount, 
                          v_loan_purpose,
                          v_payment_day;  
        EXIT WHEN v_loans%NOTFOUND; 
        
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id); 
        DBMS_OUTPUT.PUT_LINE('Credit Type ID: ' || v_credit_type_id); 
        DBMS_OUTPUT.PUT_LINE('Account ID: ' || v_account_id); 
        DBMS_OUTPUT.PUT_LINE('Amount: ' || v_amount || ' ' || v_currency_code); 
        DBMS_OUTPUT.PUT_LINE('Debt Amount: ' || v_debt_amount || ' ' || v_currency_code); 
        DBMS_OUTPUT.PUT_LINE('Remaining Amount: ' || v_remaining_amount || ' ' || v_currency_code); 
        DBMS_OUTPUT.PUT_LINE('Status: ' || v_status); 
        DBMS_OUTPUT.PUT_LINE('Issued Date: ' || TO_CHAR(v_issued_date, 'YYYY-MM-DD')); 
        DBMS_OUTPUT.PUT_LINE('Maturity Date: ' || TO_CHAR(v_maturity_date, 'YYYY-MM-DD')); 
        DBMS_OUTPUT.PUT_LINE('Interest Rate: ' || v_interest_rate || '%'); 
        DBMS_OUTPUT.PUT_LINE('Payment Frequency: ' || v_payment_frequency); 
        DBMS_OUTPUT.PUT_LINE('Payment Amount: ' || v_payment_amount || ' ' || v_currency_code); 
        DBMS_OUTPUT.PUT_LINE('Loan Purpose: ' || v_loan_purpose);
        DBMS_OUTPUT.PUT_LINE('Payment Day: ' || v_payment_day);  
    END LOOP; 

    CLOSE v_loans; 
EXCEPTION 
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20034, 'An unexpected error occurred while fetching client loans: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')'); 
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETCLIENTLOANSBYID' AND type = 'PROCEDURE';

-- Получить информацию о всех банковских картах клиента
CREATE OR REPLACE PROCEDURE GetAllClientCardsById(
    P_CLIENT_ID IN NUMBER
) AS
BEGIN
    FOR rec IN (
        SELECT c.ID, 
               ps.NAME AS TYPE, 
               c.ACCOUNT_ID, 
               c.CARD_NAME, 
               c.CARD_NUMBER, 
               c.DESCRIPTION, 
               c.STATUS
        FROM admin_user.Card c
        JOIN admin_user.User_Account ua ON c.ACCOUNT_ID = ua.ID
        JOIN admin_user.App_User au ON ua.USER_ID = au.ID
        JOIN admin_user.Payment_Service ps ON c.PAYMENT_SERVICE = ps.ID 
        WHERE au.ID = P_CLIENT_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.ID || 
                             ', Type: ' || rec.TYPE || 
                             ', Account ID: ' || rec.ACCOUNT_ID || 
                             ', Card Name: ' || rec.CARD_NAME || 
                             ', Card Number: ' || rec.CARD_NUMBER || 
                             ', Description: ' || rec.DESCRIPTION || 
                             ', Status: ' || rec.STATUS);
    END LOOP;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No cards found for the given client ID.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20036, 'An unexpected error occurred while fetching all client cards: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END GetAllClientCardsById;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLCLIENTCARDSBYID' AND type = 'PROCEDURE';

-- Изменить статус банковской карты по ее идентификатору (заблокирована / доступна)
CREATE OR REPLACE PROCEDURE UpdateClientCardStatus(
    P_CARD_ID IN NUMBER,
    P_STATUS IN NVARCHAR2
) AS
BEGIN
    IF P_STATUS NOT IN ('Active', 'Blocked') THEN
        RAISE_APPLICATION_ERROR(-20020, 'Invalid status. Status must be either "Active" or "Blocked".');
    END IF;

    UPDATE admin_user.Card 
    SET STATUS = P_STATUS 
    WHERE ID = P_CARD_ID;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20018, 'Card not found for the given ID.');
    END IF;
   
   	DBMS_OUTPUT.PUT_LINE('Card status updated successfully for Card ID: ' || P_CARD_ID); 

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No card found for the given ID.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred while updating card status: ' || SQLERRM);
        RAISE;  
END UpdateClientCardStatus;

SELECT * 
FROM user_errors 
WHERE name = 'UPDATECLIENTCARDSTATUS' AND type = 'PROCEDURE';

-- Получить список всех клиентов и информацию о них
CREATE OR REPLACE PROCEDURE GetAllClientInfos AS
BEGIN
    FOR rec IN (
        SELECT AU.ID AS USER_ID, 
               AU.LOGIN, 
               UP.FIRST_NAME, 
               UP.ADDRESS, 
               UP.BIRTH_DATE, 
               UP.EMAIL
        FROM admin_user.App_User AU
        LEFT JOIN admin_user.User_Profile UP ON AU.ID = UP.USER_ID
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.USER_ID ||
                             ', Login: ' || rec.LOGIN ||
                             ', First Name: ' || NVL(rec.FIRST_NAME, 'N/A') ||
                             ', Address: ' || NVL(rec.ADDRESS, 'N/A') ||
                             ', Birth Date: ' || NVL(TO_CHAR(rec.BIRTH_DATE, 'YYYY-MM-DD'), 'N/A') ||
                             ', Email: ' || NVL(rec.EMAIL, 'N/A'));
    END LOOP;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No client information found.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20028, 'An unexpected error occurred while fetching all client information: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLCLIENTINFOS' AND type = 'PROCEDURE';

-- Одобрить или отклонить заявку на получение кредита
CREATE OR REPLACE PROCEDURE ProcessLoanApplication(
    P_LOAN_ID IN NUMBER,
    P_STATUS IN NVARCHAR2,
    P_INTEREST_RATE IN NUMBER DEFAULT NULL,
    P_ISSUED_DATE OUT DATE,
    P_MATURITY_DATE OUT DATE,
    P_PAYMENT_FREQUENCY IN VARCHAR2 DEFAULT NULL,
    P_PAYMENT_AMOUNT OUT NUMBER,
    P_PAYMENT_DAY IN NUMBER DEFAULT NULL -- Новый параметр с значением по умолчанию
) AS
    v_current_status CHAR(8);
    v_amount NUMBER;
    v_loan_term NUMBER;
    v_issued_date DATE;
    v_maturity_date DATE;
    v_remaining_amount NUMBER;
    v_payment_amount NUMBER;

BEGIN
    -- Проверка входных параметров
    IF P_LOAN_ID IS NULL OR P_LOAN_ID <= 0 THEN
        RAISE_APPLICATION_ERROR(-20028, 'ID заявки на кредит не может быть NULL или отрицательным.');
    END IF;

    IF P_STATUS IS NULL OR (P_STATUS NOT IN ('Active', 'Canceled', 'Pending')) THEN
        RAISE_APPLICATION_ERROR(-20029, 'Некорректный статус. Допустимые значения: Active, Canceled, Pending.');
    END IF;

    -- Проверка P_PAYMENT_DAY только если статус Active
    IF P_STATUS = 'Active' THEN
        IF P_PAYMENT_DAY IS NULL OR P_PAYMENT_DAY < 1 OR P_PAYMENT_DAY > 28 THEN
            RAISE_APPLICATION_ERROR(-20032, 'Некорректный день платежа. Должен быть в диапазоне [1;28].');
        END IF;
    END IF;

    SELECT STATUS, AMOUNT, LOAN_TERM INTO v_current_status, v_amount, v_loan_term
    FROM admin_user.Credits WHERE ID = P_LOAN_ID;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20023, 'Заявка на кредит не найдена для данного ID.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Текущий статус кредита перед изменением: ' || v_current_status);

    IF P_INTEREST_RATE IS NOT NULL AND (P_INTEREST_RATE < 0 OR P_INTEREST_RATE > 100) THEN
        RAISE_APPLICATION_ERROR(-20030, 'Некорректная процентная ставка. Должна быть от 0 до 100.');
    END IF;

    IF P_STATUS = 'Active' THEN
        IF v_current_status = 'Pending' THEN
            v_issued_date := SYSDATE;
            v_maturity_date := ADD_MONTHS(v_issued_date, v_loan_term * 12);

            v_remaining_amount := v_amount * NVL(P_INTEREST_RATE, 5) / 100 + v_amount;

            IF P_PAYMENT_FREQUENCY IS NULL OR 
               (P_PAYMENT_FREQUENCY NOT IN ('Once a month', 'Once every three months', 'Once every six months')) THEN
                RAISE_APPLICATION_ERROR(-20031, 'Некорректная частота платежей. Допустимые значения: Once a month, Once every three months, Once every six months.');
            END IF;

            IF P_PAYMENT_FREQUENCY = 'Once every three months' THEN
                v_payment_amount := (v_remaining_amount) / (v_loan_term * 4);
            ELSIF P_PAYMENT_FREQUENCY = 'Once every six months' THEN
                v_payment_amount := (v_remaining_amount) / (v_loan_term * 2);
            ELSIF P_PAYMENT_FREQUENCY = 'Once a month' THEN
                v_payment_amount := (v_remaining_amount) / (v_loan_term * 12);
            END IF;

            UPDATE admin_user.Credits
            SET STATUS = 'Active',
                ISSUED_DATE = v_issued_date,
                MATURITY_DATE = v_maturity_date,
                INTEREST_RATE = NVL(P_INTEREST_RATE, 5),
                REMAINING_AMOUNT = v_remaining_amount,
                TOTAL_AMOUNT = v_remaining_amount,
                PAYMENT_FREQUENCY = P_PAYMENT_FREQUENCY,
                PAYMENT_AMOUNT = v_payment_amount,
                PAYMENT_DAY = P_PAYMENT_DAY -- Установка значения PAYMENT_DAY
            WHERE ID = P_LOAN_ID;

            P_ISSUED_DATE := v_issued_date;
            P_MATURITY_DATE := v_maturity_date;
            P_PAYMENT_AMOUNT := v_payment_amount;

            DBMS_OUTPUT.PUT_LINE('Кредит активирован. Дата выдачи: ' || TO_CHAR(v_issued_date, 'DD-MON-YYYY') || 
                                 ', Дата погашения: ' || TO_CHAR(v_maturity_date, 'DD-MON-YYYY') || 
                                 ', Процентная ставка: ' || NVL(P_INTEREST_RATE, 5));
        ELSE
            RAISE_APPLICATION_ERROR(-20025, 'Кредит не может быть активирован, так как его статус не Pending.');
        END IF;

    ELSIF P_STATUS = 'Canceled' THEN
        IF v_current_status = 'Pending' THEN
            UPDATE admin_user.Credits
            SET STATUS = 'Canceled'
            WHERE ID = P_LOAN_ID;

            DBMS_OUTPUT.PUT_LINE('Кредит отклонен.');
        ELSE
            RAISE_APPLICATION_ERROR(-20026, 'Кредит не может быть отклонен, так как его статус не Pending.');
        END IF;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Заявка на кредит успешно обработана.');
    COMMIT; 

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Заявка на кредит не найдена для данного ID.');
        RAISE;  
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Произошла ошибка при обработке заявки на кредит: ' || SQLERRM);
        RAISE;  
END ProcessLoanApplication;

SELECT * 
FROM user_errors 
WHERE name = 'PROCESSLOANAPPLICATION' AND type = 'PROCEDURE';

-- Получить список всех заявок на кредиты
CREATE OR REPLACE PROCEDURE GetLoanApplications IS
    v_count NUMBER; 
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM admin_user.Credits
    WHERE STATUS = 'Pending';

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No applications for loans.');
    ELSE
        FOR rec IN (
            SELECT c.ID AS CREDIT_ID, 
                   ua.ACCOUNT_NUMBER, 
                   c.AMOUNT, 
                   c.STATUS, 
                   u.LOGIN AS USER_LOGIN, 
                   ct.CREDIT_NAME AS CREDIT_NAME, 
                   ct.TYPE AS CREDIT_TYPE,
                   curr.CODE AS CURRENCY_CODE,  
                   curr.NAME AS CURRENCY_NAME, 
                   c.LOAN_PURPOSE  
            FROM admin_user.Credits c 
            JOIN admin_user.User_Account ua ON c.ACCOUNT_ID = ua.ID 
            JOIN admin_user.App_User u ON ua.USER_ID = u.ID 
            JOIN admin_user.Credit_Type ct ON c.CREDIT_TYPE_ID = ct.ID 
            JOIN admin_user.Currency curr ON ua.CURRENCY_ID = curr.ID  
            WHERE c.STATUS = 'Pending'
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Credit ID: ' || rec.CREDIT_ID || 
                                 ', Account number: ' || rec.ACCOUNT_NUMBER || 
                                 ', Amount: ' || rec.AMOUNT || ' ' || rec.CURRENCY_CODE || ' (' || rec.CURRENCY_NAME || '), ' ||
                                 'Status: ' || rec.STATUS || 
                                 ', User login: ' || rec.USER_LOGIN || 
                                 ', Credit name: ' || rec.CREDIT_NAME || 
                                 ', Credit type: ' || rec.CREDIT_TYPE ||
                                 ', Loan purpose: ' || rec.LOAN_PURPOSE);  
        END LOOP;
    END IF;
END GetLoanApplications;

SELECT * 
FROM user_errors 
WHERE name = 'GETLOANAPPLICATIONS' AND type = 'PROCEDURE';

--Добавить счет клиенту
CREATE OR REPLACE PROCEDURE AddAccountToClient(
    P_USER_ID IN NUMBER,
    P_CURRENCY_ID IN NUMBER,  
    P_AMOUNT IN NUMBER
) AS 
BEGIN
    IF P_USER_ID IS NULL THEN 
        RAISE_APPLICATION_ERROR(-20027, 'User ID cannot be null.'); 
    END IF; 
    
    IF P_CURRENCY_ID IS NULL THEN 
        RAISE_APPLICATION_ERROR(-20028, 'Currency ID cannot be null.'); 
    END IF; 
    
    IF P_AMOUNT IS NULL THEN 
        RAISE_APPLICATION_ERROR(-20029, 'Amount cannot be null.'); 
    ELSIF P_AMOUNT < 0 THEN 
        RAISE_APPLICATION_ERROR(-20030, 'Amount cannot be negative.'); 
    END IF; 

    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count 
        FROM admin_user.App_User 
        WHERE ID = P_USER_ID;

        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20031, 'User with ID ' || P_USER_ID || ' does not exist.');
        END IF;
    END;

    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count 
        FROM admin_user.Currency 
        WHERE ID = P_CURRENCY_ID;

        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20032, 'Currency with ID ' || P_CURRENCY_ID || ' does not exist.');
        END IF;
    END;

    INSERT INTO admin_user.User_Account (ACCOUNT_NUMBER, CURRENCY_ID, AMOUNT, USER_ID) 
    VALUES (
        GENERATE_ACCOUNT_NUMBER(), 
        P_CURRENCY_ID, 
        P_AMOUNT, 
        P_USER_ID
    );

    DBMS_OUTPUT.PUT_LINE('Account added successfully for user ID: ' || P_USER_ID);

EXCEPTION 
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20026, 'An unexpected error occurred while adding an account to the client: ' || SQLERRM);
END AddAccountToClient;

SELECT * 
FROM user_errors 
WHERE name = 'ADDACCOUNTTOCLIENT' AND type = 'PROCEDURE';

--Закрыть счет клиенту
CREATE OR REPLACE PROCEDURE CloseClientAccount(
    P_ACCOUNT_ID IN NUMBER, 
    P_LOGIN IN NVARCHAR2      
) AS
    ACCOUNT_BALANCE NUMBER;
    PENDING_ACTIVE_COUNT NUMBER;
BEGIN
    SELECT ua.AMOUNT 
    INTO ACCOUNT_BALANCE
    FROM admin_user.User_Account ua
    JOIN admin_user.App_User u ON ua.USER_ID = u.ID
    WHERE ua.ID = P_ACCOUNT_ID AND u.LOGIN = P_LOGIN;

    IF ACCOUNT_BALANCE = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Amount: ' || '0');
    ELSE 
    	RAISE_APPLICATION_ERROR(-20020, 'Account balance must be zero to close the account.');
    END IF;

    SELECT COUNT(*)
    INTO PENDING_ACTIVE_COUNT
    FROM admin_user.Credits
    WHERE ACCOUNT_ID = P_ACCOUNT_ID  
    AND STATUS IN ('Pending', 'Active');

    DBMS_OUTPUT.PUT_LINE('Pending/Active Credits Count: ' || PENDING_ACTIVE_COUNT);
    
    IF PENDING_ACTIVE_COUNT > 0 THEN
        RAISE_APPLICATION_ERROR(-20021, 'Account cannot be closed because there are active or pending credits.');
    END IF;

    DELETE FROM admin_user.User_Account WHERE ID = P_ACCOUNT_ID;

    DBMS_OUTPUT.PUT_LINE('Account closed successfully for account ID: ' || P_ACCOUNT_ID);

EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Account not found for the given ACCOUNT_ID and LOGIN.');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred while closing the account: ' || SQLERRM);
END CloseClientAccount;

SELECT * 
FROM user_errors 
WHERE name = 'CLOSECLIENTACCOUNT' AND type = 'PROCEDURE';

-- Добавить банковскую карту
CREATE OR REPLACE PROCEDURE AddBankCard(
    P_ACCOUNT_ID IN NUMBER,
    P_PAYMENT_SERVICE IN NUMBER,  
    P_CARD_NAME IN NVARCHAR2,
    P_CARD_NUMBER IN NUMBER,
    P_DESCRIPTION IN NVARCHAR2,
    P_STATUS IN NVARCHAR2
) AS
BEGIN
    IF P_STATUS NOT IN ('Active', 'Blocked') THEN
        RAISE_APPLICATION_ERROR(-20020, 'Invalid status. Status must be either "Active" or "Blocked".');
    END IF;

    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM admin_user.Card
        WHERE CARD_NUMBER = P_CARD_NUMBER;

        IF v_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Error: Card number already exists. Card not added for account ID: ' || P_ACCOUNT_ID);
            RETURN; 
        END IF;
    END;

    INSERT INTO admin_user.Card (ACCOUNT_ID, PAYMENT_SERVICE, CARD_NAME, CARD_NUMBER, DESCRIPTION, STATUS)
    VALUES (P_ACCOUNT_ID, P_PAYMENT_SERVICE, P_CARD_NAME, P_CARD_NUMBER, P_DESCRIPTION, P_STATUS);

    DBMS_OUTPUT.PUT_LINE('Bank card added successfully for account ID: ' || P_ACCOUNT_ID);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in AddBankCard: ' || SQLERRM);
END AddBankCard;

SELECT * 
FROM user_errors 
WHERE name = 'ADDBANKCARD' AND type = 'PROCEDURE';

-- Удалить банковскую карту
CREATE OR REPLACE PROCEDURE admin_user.DeleteBankCard(
    P_CARD_ID IN NUMBER
) AS
BEGIN
    DELETE FROM admin_user.Card WHERE ID = P_CARD_ID;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: No card found with ID: ' || P_CARD_ID);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Bank card with ID: ' || P_CARD_ID || ' deleted successfully.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in DeleteBankCard: ' || SQLERRM);
END;

SELECT * 
FROM user_errors 
WHERE name = 'ADMIN_USER.DELETEBANKCARD' AND type = 'PROCEDURE';

-- Вывод списка валют
CREATE OR REPLACE PROCEDURE GetAllCurrencies IS
    CURSOR cur IS SELECT * FROM admin_user.Currency;
    rec cur%ROWTYPE;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO rec;
        EXIT WHEN cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.ID || ', Name: ' || rec.NAME || ', Code: ' || rec.CODE);
    END LOOP;
    CLOSE cur;
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLCURRENCIES' AND type = 'PROCEDURE';

-- Вывод данных из таблицы App_User
CREATE OR REPLACE PROCEDURE GetAllAppUsers IS
    CURSOR cur IS SELECT * FROM admin_user.App_User;
    rec cur%ROWTYPE;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO rec;
        EXIT WHEN cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.ID || ', Login: ' || rec.LOGIN || ', Password: ' || rec.PASSWORD);
    END LOOP;
    CLOSE cur;
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLAPPUSERS' AND type = 'PROCEDURE';


-- Вывод данных из таблицы User_Account
CREATE OR REPLACE PROCEDURE GetAllUserAccounts IS
    CURSOR cur IS SELECT * FROM admin_user.User_Account;
    rec cur%ROWTYPE;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO rec;
        EXIT WHEN cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.ID || ', Account Number: ' || rec.ACCOUNT_NUMBER || ', Currency: ' || rec.CURRENCY || ', Amount: ' || rec.AMOUNT || ', User ID: ' || rec.USER_ID);
    END LOOP;
    CLOSE cur;
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLUSERACCOUNTS' AND type = 'PROCEDURE';

-- Вывод запросов в техподдержку 
CREATE OR REPLACE PROCEDURE GetAllUserSupportRequests IS
    CURSOR cur IS SELECT * FROM admin_user.User_Support_Requests; 
    rec cur%ROWTYPE;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO rec;
        EXIT WHEN cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.ID || 
                             ', User ID: ' || rec.USER_ID ||  -- Добавлен вывод USER_ID
                             ', Content: ' || rec.CONTENT || 
                             ', Date: ' || TO_CHAR(rec.DATE_TIME, 'YYYY-MM-DD HH24:MI:SS'));
    END LOOP;
    CLOSE cur;
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLUSERSUPPORTREQUESTS' AND type = 'PROCEDURE';

-- Получение данных о платежных сервисах
CREATE OR REPLACE PROCEDURE GetAllPaymentServices IS
    CURSOR cur IS SELECT * FROM admin_user.Payment_Service;
    rec cur%ROWTYPE;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO rec;
        EXIT WHEN cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || rec.ID || ', Name: ' || rec.NAME || ', Type: ' || rec.TYPE);
    END LOOP;
    CLOSE cur;
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLPAYMENTSERVICES' AND type = 'PROCEDURE';

-- Получение данных о всех кредитах
CREATE OR REPLACE PROCEDURE GetAllCredits IS
    CURSOR cur IS 
        SELECT c.ID, 
               ct.TYPE AS CREDIT_TYPE, 
               ct.DESCRIPTION AS CREDIT_DESCRIPTION, 
               c.ACCOUNT_ID, 
               c.AMOUNT, 
               c.ISSUED_DATE, 
               c.MATURITY_DATE, 
               c.INTEREST_RATE, 
               c.DEBT_AMOUNT, 
               c.REMAINING_AMOUNT, 
               c.STATUS, 
               c.CURRENCY_ID, 
               c.PAYMENT_AMOUNT, 
               c.PAYMENT_FREQUENCY, 
               c.LOAN_TERM, 
               c.LOAN_PURPOSE, 
               c.TOTAL_AMOUNT,
               c.PAYMENT_DAY 
        FROM admin_user.Credits c 
        JOIN admin_user.Credit_Type ct ON c.CREDIT_TYPE_ID = ct.ID;

    v_id NUMBER(10);
    v_credit_type VARCHAR2(50);
    v_credit_description VARCHAR2(255);
    v_account_id NUMBER(10);
    v_amount NUMBER(15, 2);
    v_issued_date DATE;
    v_maturity_date DATE;
    v_interest_rate NUMBER(5, 2);
    v_debt_amount NUMBER(15, 2);
    v_remaining_amount NUMBER(15, 2);
    v_status CHAR(8);
    v_currency_id NUMBER(3);
    v_payment_amount NUMBER(15, 2);
    v_payment_frequency VARCHAR2(30);
    v_loan_term NUMBER;
    v_loan_purpose VARCHAR2(255);
    v_total_amount NUMBER(15, 2);
    v_payment_day NUMBER; 

BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO v_id, v_credit_type, v_credit_description, v_account_id, v_amount, 
                      v_issued_date, v_maturity_date, v_interest_rate, v_debt_amount, 
                      v_remaining_amount, v_status, v_currency_id, v_payment_amount, 
                      v_payment_frequency, v_loan_term, v_loan_purpose, v_total_amount, 
                      v_payment_day; 

        EXIT WHEN cur%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || 
                             ', Credit Type: ' || v_credit_type || 
                             ', Description: ' || v_credit_description || 
                             ', Account ID: ' || v_account_id || 
                             ', Amount: ' || v_amount || 
                             ', Issued Date: ' || NVL(TO_CHAR(v_issued_date, 'YYYY-MM-DD HH24:MI:SS'), 'N/A') || 
                             ', Maturity Date: ' || NVL(TO_CHAR(v_maturity_date, 'YYYY-MM-DD HH24:MI:SS'), 'N/A') || 
                             ', Interest Rate: ' || NVL(v_interest_rate, 0) || 
                             ', Debt Amount: ' || NVL(v_debt_amount, 0) || 
                             ', Remaining Amount: ' || NVL(v_remaining_amount, 0) || 
                             ', Status: ' || NVL(v_status, 'N/A') || 
                             ', Currency ID: ' || NVL(v_currency_id, 0) || 
                             ', Payment Amount: ' || NVL(v_payment_amount, 0) || 
                             ', Payment Frequency: ' || NVL(v_payment_frequency, 'N/A') || 
                             ', Loan Term: ' || NVL(v_loan_term, 0) || 
                             ', Loan Purpose: ' || NVL(v_loan_purpose, 'N/A') || 
                             ', Total Amount: ' || NVL(v_total_amount, 0) || 
                             ', Payment Day: ' || NVL(v_payment_day, 0)); 
    END LOOP;
    CLOSE cur;
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETALLCREDITS' AND type = 'PROCEDURE';