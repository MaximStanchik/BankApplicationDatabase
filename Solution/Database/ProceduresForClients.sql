----------------------------------------Процедуры только для клиентов:----------------------------------------
alter session set container = BANK_APP_PDB;

--Получить историю всех транзакций клиента за указанный период времени
CREATE OR REPLACE PROCEDURE GetTransactionHistory(
    P_CLIENT_ID IN NUMBER,
    P_START_DATE IN DATE,
    P_END_DATE IN DATE
) AS
    P_TRANSACTIONS SYS_REFCURSOR;
    P_ID NUMBER;
    P_ACCOUNT_ID_FROM NUMBER;
    P_ACCOUNT_ID_TO NUMBER;
    P_AMOUNT NUMBER;
    P_DATE_TIME TIMESTAMP;
BEGIN
    IF P_END_DATE < P_START_DATE THEN
        DBMS_OUTPUT.PUT_LINE('Error: End date cannot be earlier than start date.');
        RETURN; 
    END IF;

    OPEN P_TRANSACTIONS FOR
    SELECT at.ID, at.ACCOUNT_ID_FROM, at.ACCOUNT_ID_TO, at.AMOUNT, at.DATE_TIME
    FROM admin_user.Account_Transaction at
    JOIN admin_user.User_Account UA ON (at.ACCOUNT_ID_FROM = UA.ID OR at.ACCOUNT_ID_TO = UA.ID)
    WHERE UA.USER_ID = P_CLIENT_ID
    AND at.DATE_TIME >= P_START_DATE AND at.DATE_TIME < P_END_DATE + 1; 

    LOOP
        FETCH P_TRANSACTIONS INTO P_ID, P_ACCOUNT_ID_FROM, P_ACCOUNT_ID_TO, P_AMOUNT, P_DATE_TIME;
        EXIT WHEN P_TRANSACTIONS%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Transaction ID: ' || P_ID || 
                             ', Amount: ' || P_AMOUNT || 
                             ', From Account ID: ' || P_ACCOUNT_ID_FROM || 
                             ', To Account ID: ' || P_ACCOUNT_ID_TO || 
                             ', Date: ' || P_DATE_TIME);
    END LOOP;

    CLOSE P_TRANSACTIONS; 

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20032, 'Error in GetTransactionHistory: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;

SELECT * 
FROM user_errors 
WHERE name = 'CREATESUPPORTREQUEST' AND type = 'PROCEDURE';

--Создать запрос в службу поддержки с указанием темы и содержимого
CREATE OR REPLACE PROCEDURE CreateSupportRequest(
    P_CLIENT_ID IN NUMBER,
    P_CONTENT IN NVARCHAR2
) AS
    v_user_exists NUMBER; 
BEGIN
    SELECT COUNT(*) INTO v_user_exists
    FROM admin_user.App_User
    WHERE ID = P_CLIENT_ID;

    IF v_user_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: Client with ID ' || P_CLIENT_ID || ' does not exist.');
    END IF;

    INSERT INTO admin_user.User_Support_Requests (CONTENT, DATE_TIME, USER_ID)
    VALUES (P_CONTENT, SYSTIMESTAMP, P_CLIENT_ID);

    DBMS_OUTPUT.PUT_LINE('Support request created successfully for Client ID: ' || P_CLIENT_ID);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Client with ID ' || P_CLIENT_ID || ' not found.');
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
    P_CREDIT_TYPE_ID IN NUMBER,
    P_CURRENCY_ID IN NUMBER,
    P_ACCOUNT_ID IN NUMBER,  
    P_LOAN_PURPOSE IN VARCHAR2,  
    P_LOAN_TERM IN NUMBER 
) AS
    v_currency_id NUMBER; 
BEGIN
    IF P_AMOUNT <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Amount must be greater than 0.');
        RETURN; 
    END IF;
    IF P_CREDIT_TYPE_ID <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Credit Type ID must be greater than 0.');
        RETURN;
    END IF;
    IF P_CURRENCY_ID <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Currency ID must be greater than 0.');
        RETURN;
    END IF;

    IF P_LOAN_TERM NOT IN (1, 2, 3, 4, 5, 8, 10, 13, 15) THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid loan term. Acceptable values are 1, 2, 3, 4, 5, 8, 10, 13, 15.');
        RETURN;  
    END IF;

    SELECT CURRENCY_ID INTO v_currency_id
    FROM admin_user.User_Account
    WHERE ID = P_ACCOUNT_ID;  

    IF v_currency_id != P_CURRENCY_ID THEN
        DBMS_OUTPUT.PUT_LINE('Error: Currency ID does not match the account currency.');
        RETURN;  
    END IF;

    INSERT INTO admin_user.Credits (
        ACCOUNT_ID,
        AMOUNT,
        CREDIT_TYPE_ID,
        CURRENCY_ID,
        STATUS,
        LOAN_PURPOSE, 
        LOAN_TERM 
    ) VALUES (
        P_ACCOUNT_ID,
        P_AMOUNT,
        P_CREDIT_TYPE_ID,
        P_CURRENCY_ID,
        'Pending',
        P_LOAN_PURPOSE,  
        P_LOAN_TERM
    );

    DBMS_OUTPUT.PUT_LINE('Loan application submitted successfully.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No account found for Account ID: ' || P_ACCOUNT_ID);
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid amount or credit type ID provided for Client ID: ' || P_CLIENT_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in SubmitLoanApplication: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END SubmitLoanApplication;

SELECT * 
FROM user_errors 
WHERE name = 'SUBMITLOANAPPLICATION' AND type = 'PROCEDURE';

--Перевести средства с одного счета клиента на другой или на внешний счет
CREATE OR REPLACE PROCEDURE TransferFunds(
    P_ACCOUNT_ID_FROM IN NUMBER,
    P_ACCOUNT_ID_TO IN NUMBER,
    P_AMOUNT IN NUMBER
) AS
    v_balance_from NUMBER;
    v_currency_id_from NUMBER;
    v_currency_id_to NUMBER;
BEGIN
    SELECT CURRENCY_ID, AMOUNT INTO v_currency_id_from, v_balance_from 
    FROM admin_user.User_Account 
    WHERE ID = P_ACCOUNT_ID_FROM;

    IF P_AMOUNT <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Transfer amount must be greater than zero.');
    END IF;

    IF v_balance_from < P_AMOUNT THEN
        DBMS_OUTPUT.PUT_LINE('Insufficient funds for transfer.');
        RAISE_APPLICATION_ERROR(-20003, 'Insufficient funds for transfer.');
    END IF;

    SELECT CURRENCY_ID INTO v_currency_id_to 
    FROM admin_user.User_Account 
    WHERE ID = P_ACCOUNT_ID_TO;

    IF v_currency_id_from != v_currency_id_to THEN
        DBMS_OUTPUT.PUT_LINE('Cannot transfer funds between accounts with different currencies.');
        RAISE_APPLICATION_ERROR(-20007, 'Cannot transfer funds between accounts with different currencies.');
    END IF;

    UPDATE admin_user.User_Account 
    SET AMOUNT = AMOUNT - P_AMOUNT 
    WHERE ID = P_ACCOUNT_ID_FROM;

    UPDATE admin_user.User_Account 
    SET AMOUNT = AMOUNT + P_AMOUNT 
    WHERE ID = P_ACCOUNT_ID_TO;

    INSERT INTO admin_user.Account_Transaction (
        ACCOUNT_ID_FROM, 
        ACCOUNT_ID_TO, 
        AMOUNT, 
        DATE_TIME, 
        CURRENCY_ID
    ) VALUES (
        P_ACCOUNT_ID_FROM, 
        P_ACCOUNT_ID_TO, 
        P_AMOUNT, 
        SYSTIMESTAMP, 
        v_currency_id_from
    );

    DBMS_OUTPUT.PUT_LINE('Funds successfully transferred from Account ID ' || P_ACCOUNT_ID_FROM || ' to Account ID ' || P_ACCOUNT_ID_TO || '. Amount: ' || P_AMOUNT);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('One of the accounts not found. From ID: ' || P_ACCOUNT_ID_FROM || ', To ID: ' || P_ACCOUNT_ID_TO);
        RAISE_APPLICATION_ERROR(-20004, 'One of the accounts not found.');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid transfer amount provided.');
        RAISE_APPLICATION_ERROR(-20005, 'Invalid transfer amount provided.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in TransferFunds: ' || SQLERRM);
        RAISE_APPLICATION_ERROR(-20006, 'Error in TransferFunds: ' || SQLERRM);
END;

SELECT * 
FROM user_errors 
WHERE name = 'TRANSFERFUNDS' AND type = 'PROCEDURE';

-- Перевести счет в доллары США
CREATE OR REPLACE PROCEDURE TransferFundsToUSD(
    P_ACCOUNT_ID IN NUMBER
) AS
    v_currency_id NUMBER;
    v_exchange_rate NUMBER;
    v_converted_amount NUMBER;
    v_amount NUMBER;
    v_credit_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_credit_count
    FROM admin_user.User_Account
    WHERE ID = P_ACCOUNT_ID;

    IF v_credit_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Счет с ID ' || P_ACCOUNT_ID || ' не существует.');
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_credit_count
    FROM admin_user.Credits
    WHERE ACCOUNT_ID = P_ACCOUNT_ID;

    IF v_credit_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: К счету с ID ' || P_ACCOUNT_ID || ' привязаны кредиты. Перевод невозможен.');
        RETURN;
    END IF;

    SELECT CURRENCY_ID, AMOUNT INTO v_currency_id, v_amount
    FROM admin_user.User_Account
    WHERE ID = P_ACCOUNT_ID;

    IF v_currency_id = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Счет уже в долларах США.');
        RETURN;
    END IF;

    SELECT SALE INTO v_exchange_rate
    FROM (
        SELECT SALE
        FROM admin_user.Currency_Exchange_Rate
        WHERE CURR_ID = v_currency_id
        ORDER BY POSTING_DATE DESC
    )
    WHERE ROWNUM = 1;

    v_converted_amount := v_amount / v_exchange_rate;

    UPDATE admin_user.User_Account
    SET AMOUNT = v_converted_amount, CURRENCY_ID = 1
    WHERE ID = P_ACCOUNT_ID;

    DBMS_OUTPUT.PUT_LINE('Счет успешно переведен в доллары. Новая сумма: ' || v_converted_amount);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Не найден курс обмена для валюты с ID ' || v_currency_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка в TransferFundsToUSD: ' || SQLERRM);
END TransferFundsToUSD;

SELECT * 
FROM user_errors 
WHERE name = 'TRANSFERFUNDSTOUSD' AND type = 'PROCEDURE';

-- Перевести счет в другую валюту (кроме доллара США)
CREATE OR REPLACE PROCEDURE ConvertFromUSD(
    P_ACCOUNT_ID IN NUMBER,
    P_TARGET_CURRENCY_ID IN NUMBER
) AS
    v_current_currency_id NUMBER;
    v_exchange_rate NUMBER;
    v_converted_amount NUMBER;
    v_amount NUMBER;
    v_credit_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_credit_count
    FROM admin_user.User_Account
    WHERE ID = P_ACCOUNT_ID;

    IF v_credit_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Счет с ID ' || P_ACCOUNT_ID || ' не существует.');
        RETURN;
    END IF;

    SELECT COUNT(*) INTO v_credit_count
    FROM admin_user.Credits
    WHERE ACCOUNT_ID = P_ACCOUNT_ID;

    IF v_credit_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: К счету с ID ' || P_ACCOUNT_ID || ' привязаны кредиты. Перевод невозможен.');
        RETURN;
    END IF;

    SELECT CURRENCY_ID, AMOUNT INTO v_current_currency_id, v_amount
    FROM admin_user.User_Account
    WHERE ID = P_ACCOUNT_ID;

    IF v_current_currency_id != 1 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Счет не в долларах США, перевод невозможен. Для перевода необходимо сначала перевести счет в доллары США');
        RETURN;
    END IF;

    SELECT BUY INTO v_exchange_rate
    FROM (
        SELECT BUY
        FROM admin_user.Currency_Exchange_Rate
        WHERE CURR_ID = P_TARGET_CURRENCY_ID
        ORDER BY POSTING_DATE DESC
    )
    WHERE ROWNUM = 1;

    v_converted_amount := v_amount * v_exchange_rate;

    UPDATE admin_user.User_Account
    SET AMOUNT = v_converted_amount, CURRENCY_ID = P_TARGET_CURRENCY_ID
    WHERE ID = P_ACCOUNT_ID;

    DBMS_OUTPUT.PUT_LINE('Счет успешно переведен в валюту с ID ' || P_TARGET_CURRENCY_ID || '. Новая сумма: ' || v_converted_amount);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: Не найден курс обмена для целевой валюты с ID ' || P_TARGET_CURRENCY_ID);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка в ConvertFromUSD: ' || SQLERRM);
END ConvertFromUSD;

SELECT * 
FROM user_errors 
WHERE name = 'CONVERTFROMUSD' AND type = 'PROCEDURE';

--Оплатить кредит с счета клиента, к которому кредит привязан
CREATE OR REPLACE PROCEDURE PayCredit(
    p_credit_id IN NUMBER,
    p_account_id IN NUMBER,
    p_payment_amount IN NUMBER
) AS 
    v_initial_debt_amount NUMBER;
    v_remaining_amount NUMBER;
    v_currency_id NUMBER;
    v_account_amount NUMBER;
    v_status VARCHAR2(8);
    v_refund_amount NUMBER; 
    v_credit_owner NUMBER; 

BEGIN
    SELECT ACCOUNT_ID, STATUS 
    INTO v_credit_owner, v_status 
    FROM admin_user.Credits 
    WHERE ID = p_credit_id;
   
    IF v_credit_owner IS NULL THEN
        RAISE_APPLICATION_ERROR(-20009, 'Кредит с указанным ID не существует'); 
        RETURN; 
    ELSIF TRIM(v_status) = 'Pending' THEN
        RAISE_APPLICATION_ERROR(-20006, 'Кредит пока не выдан. Оплата невозможна'); 
        RETURN; 
    ELSIF TRIM(v_status) = 'Paid' THEN
        RAISE_APPLICATION_ERROR(-20005, 'Кредит уже полностью выплачен'); 
        RETURN; 
    END IF;

    DECLARE
        v_account_count NUMBER;
    BEGIN
        SELECT COUNT(*) 
        INTO v_account_count 
        FROM admin_user.User_Account 
        WHERE ID = p_account_id;

        IF v_account_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20008, 'Счет с указанным ID не существует.'); 
        END IF;
    END;

    IF v_credit_owner != p_account_id THEN
        RAISE_APPLICATION_ERROR(-20003, 'Кредит не привязан к данному счету.'); 
    END IF;

    SELECT DEBT_AMOUNT, REMAINING_AMOUNT, CURRENCY_ID 
    INTO v_initial_debt_amount, v_remaining_amount, v_currency_id 
    FROM admin_user.Credits 
    WHERE ID = p_credit_id;

    SELECT AMOUNT 
    INTO v_account_amount 
    FROM admin_user.User_Account 
    WHERE ID = p_account_id;

    IF p_payment_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Сумма платежа должна быть положительной.'); 
    ELSIF p_payment_amount > v_account_amount THEN
        RAISE_APPLICATION_ERROR(-20002, 'Недостаточно средств на счете для оплаты кредита.'); 
    END IF;

    UPDATE admin_user.User_Account
    SET AMOUNT = AMOUNT - p_payment_amount
    WHERE ID = p_account_id;


    IF p_payment_amount >= (v_initial_debt_amount + v_remaining_amount) THEN
        v_refund_amount := p_payment_amount - (v_initial_debt_amount + v_remaining_amount);
        UPDATE admin_user.Credits
        SET DEBT_AMOUNT = 0,
            REMAINING_AMOUNT = 0,
            STATUS = 'Paid'
        WHERE ID = p_credit_id;

        DBMS_OUTPUT.PUT_LINE('Кредит полностью выплачен');

        IF v_refund_amount > 0 THEN
            UPDATE admin_user.User_Account
            SET AMOUNT = AMOUNT + v_refund_amount
            WHERE ID = p_account_id;
            DBMS_OUTPUT.PUT_LINE('Возвращено ' || v_refund_amount || ' на счет');
        END IF;

    ELSE
        UPDATE admin_user.Credits
        SET DEBT_AMOUNT = v_initial_debt_amount - p_payment_amount
        WHERE ID = p_credit_id;

        DBMS_OUTPUT.PUT_LINE('Задолженность по кредиту уменьшена на ' || p_payment_amount || '. Текущая задолженность: ' || (v_initial_debt_amount - p_payment_amount));
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        ROLLBACK;
END PayCredit;

SELECT * 
FROM user_errors 
WHERE name = 'PAYCREDIT' AND type = 'PROCEDURE';

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
    v_salt VARCHAR2(128);
    v_encrypted_password RAW(2048);
BEGIN
    v_salt := generate_salt(P_LOGIN);
    v_encrypted_password := encrypt(P_PASSWORD, v_salt);

    SELECT COUNT(*) INTO P_IS_SUCCESS
    FROM admin_user.App_User
    WHERE LOGIN = P_LOGIN AND PASSWORD = UTL_RAW.CAST_TO_VARCHAR2(v_encrypted_password);

    IF P_IS_SUCCESS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('User successfully logged in.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Login failed: Invalid login or password.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in LoginClient: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
        P_IS_SUCCESS := 0; 
END;

SELECT * 
FROM user_errors 
WHERE name = 'LOGINCLIENT' AND type = 'PROCEDURE';

-- Регистрация клиента
CREATE OR REPLACE PROCEDURE RegisterClient(
    P_LOGIN IN NVARCHAR2,
    P_PASSWORD IN NVARCHAR2,
    P_EMAIL IN NVARCHAR2,
    P_FIRST_NAME IN NVARCHAR2,
    P_LAST_NAME IN NVARCHAR2,
    P_MIDDLE_NAME IN NVARCHAR2,
    P_ADDRESS IN NVARCHAR2,
    P_BIRTH_DATE IN DATE,
    P_PHONE_NUMBER IN NVARCHAR2,
    P_PASSPORT_NUM IN NVARCHAR2
) AS
    V_USER_ID NUMBER;
    V_COUNT_LOGIN NUMBER;
    V_COUNT_EMAIL NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_COUNT_LOGIN
    FROM admin_user.App_User
    WHERE LOGIN = P_LOGIN;

    SELECT COUNT(*) INTO V_COUNT_EMAIL
    FROM admin_user.User_Profile
    WHERE EMAIL = P_EMAIL;

    IF V_COUNT_LOGIN > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Login already exists: ' || P_LOGIN);
    ELSIF V_COUNT_EMAIL > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Email already exists: ' || P_EMAIL);
    END IF;

    SAVEPOINT BeforeInsert;

    INSERT INTO admin_user.App_User (LOGIN, PASSWORD)
    VALUES (P_LOGIN, P_PASSWORD)
    RETURNING ID INTO V_USER_ID;

    INSERT INTO admin_user.User_Profile (
        USER_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, BIRTH_DATE, EMAIL, PASSPORT_NUM, PHONE_NUMBER
    )
    VALUES (
        V_USER_ID, P_FIRST_NAME, P_LAST_NAME, P_MIDDLE_NAME, P_ADDRESS, P_BIRTH_DATE, P_EMAIL, P_PASSPORT_NUM, P_PHONE_NUMBER
    );

    DBMS_OUTPUT.PUT_LINE('Procedure executed successfully.');

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE NOT IN (-20001, -20002) THEN
            ROLLBACK TO BeforeInsert;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        RAISE; 
END;

SELECT * 
FROM user_errors 
WHERE name = 'REGISTERCLIENT' AND type = 'PROCEDURE';

-- Получить текущий баланс счета 
CREATE OR REPLACE PROCEDURE GetAccountBalance(
    P_USER_ID IN NUMBER,
    P_ACCOUNT_NUMBER IN NVARCHAR2,
    P_BALANCE OUT NUMBER,
    P_CURRENCY OUT VARCHAR2
) AS
BEGIN
    SELECT UA.AMOUNT, C.CODE 
    INTO P_BALANCE, P_CURRENCY 
    FROM admin_user.User_Account UA 
    JOIN admin_user.Currency C ON UA.CURRENCY_ID = C.ID 
    WHERE UA.ACCOUNT_NUMBER = P_ACCOUNT_NUMBER 
    AND UA.USER_ID = P_USER_ID;

    DBMS_OUTPUT.PUT_LINE('Balance: ' || P_BALANCE || ' ' || P_CURRENCY);

EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Account does not belong to the user.');
        P_BALANCE := NULL;
        P_CURRENCY := NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in GetAccountBalance: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
        P_BALANCE := NULL;
        P_CURRENCY := NULL;
END;

SELECT * 
FROM user_errors 
WHERE name = 'GETACCOUNTBALANCE' AND type = 'PROCEDURE';