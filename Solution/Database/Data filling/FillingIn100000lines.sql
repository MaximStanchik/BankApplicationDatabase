------------------------------Процедура для вставки 100,000 строк в таблицу User_Account:------------------------------
alter session set container = BANK_APP_PDB;

DECLARE
    v_currency_id number; 
    v_user_id number;      
BEGIN
    FOR i IN 1..100000 LOOP
        SELECT ID INTO v_user_id
        FROM (
            SELECT ID FROM admin_user.App_User ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        SELECT ID INTO v_currency_id
        FROM (
            SELECT ID FROM admin_user.Currency ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        INSERT INTO admin_user.User_Account (ACCOUNT_NUMBER, CURRENCY_ID, AMOUNT, USER_ID)
        VALUES (
            'Acc' || TO_CHAR(i),  
            v_currency_id,        
            ROUND(DBMS_RANDOM.VALUE(100, 10000), 2),  
            v_user_id            
        );

        IF MOD(i, 1000) = 0 THEN
            COMMIT;
        END IF;
    END LOOP;

    COMMIT;  
END;

SELECT COUNT(*) FROM admin_user.User_Account;

SELECT * FROM admin_user.User_Account WHERE id BETWEEN 110000 AND 200000;

SELECT 
    ua.ACCOUNT_NUMBER,
    ua.AMOUNT,
    a.LOGIN,
    c.NAME AS CURRENCY_NAME
FROM 
    admin_user.User_Account ua
JOIN 
    admin_user.App_User a ON ua.USER_ID = a.ID
JOIN 
    admin_user.Currency c ON ua.CURRENCY_ID = c.ID  
WHERE 
    ua.AMOUNT > 0  
ORDER BY 
    ua.AMOUNT DESC;