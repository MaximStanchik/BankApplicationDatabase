CREATE OR REPLACE PROCEDURE TransferFunds(
    P_ACCOUNT_ID_FROM IN NUMBER,
    P_ACCOUNT_ID_TO IN NUMBER,
    P_AMOUNT IN NUMBER,
    P_USER_ID IN NUMBER
) AS
    v_user_id_from NUMBER;
    v_user_id_to NUMBER;
    v_balance_from NUMBER;
BEGIN
    SELECT USER_ID INTO v_user_id_from FROM admin_user.User_Account WHERE ID = P_ACCOUNT_ID_FROM;
    SELECT USER_ID INTO v_user_id_to FROM admin_user.User_Account WHERE ID = P_ACCOUNT_ID_TO;

    DBMS_OUTPUT.PUT_LINE('User ID From: ' || v_user_id_from);
    DBMS_OUTPUT.PUT_LINE('User ID To: ' || v_user_id_to);
    DBMS_OUTPUT.PUT_LINE('Provided User ID: ' || P_USER_ID);

    IF v_user_id_from != P_USER_ID OR v_user_id_to != P_USER_ID THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot transfer funds between accounts that do not belong to the same user.');
    END IF;

    IF P_AMOUNT <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Transfer amount must be greater than zero.');
    END IF;

    SELECT AMOUNT INTO v_balance_from FROM admin_user.User_Account WHERE ID = P_ACCOUNT_ID_FROM;

    IF v_balance_from < P_AMOUNT THEN
        RAISE_APPLICATION_ERROR(-20003, 'Insufficient funds for transfer.');
    END IF;

    UPDATE admin_user.User_Account SET AMOUNT = AMOUNT - P_AMOUNT WHERE ID = P_ACCOUNT_ID_FROM;
    UPDATE admin_user.User_Account SET AMOUNT = AMOUNT + P_AMOUNT WHERE ID = P_ACCOUNT_ID_TO;

    INSERT INTO admin_user.Account_Transaction (ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME)
    VALUES (P_ACCOUNT_ID_FROM, P_ACCOUNT_ID_TO, P_AMOUNT, SYSTIMESTAMP);

    DBMS_OUTPUT.PUT_LINE('Funds transferred successfully.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('One of the accounts not found for Transfer. From ID: ' || P_ACCOUNT_ID_FROM || ', To ID: ' || P_ACCOUNT_ID_TO);
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Invalid transfer amount provided.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in TransferFunds: ' || SQLERRM || ' (Error Code: ' || SQLCODE || ')');
END;
