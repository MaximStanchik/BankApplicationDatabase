------------------------------Процедура для вставки 100,000 строк в таблицу User_Account:------------------------------
alter session set container = BANK_APP_PDB;

DECLARE
    v_currency_id number;  -- Переменная для хранения случайного ID валюты
    v_user_id number;      -- Переменная для хранения случайного ID пользователя
BEGIN
    FOR i IN 1..100000 LOOP
        -- Получаем случайный USER_ID из таблицы App_User
        SELECT ID INTO v_user_id
        FROM (
            SELECT ID FROM App_User ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        -- Получаем случайный CURRENCY_ID из таблицы Currency
        SELECT ID INTO v_currency_id
        FROM (
            SELECT ID FROM Currency ORDER BY DBMS_RANDOM.VALUE
        )
        WHERE ROWNUM = 1;

        -- Вставляем запись в таблицу User_Account
        INSERT INTO User_Account (ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID)
        VALUES (
            'ACC' || TO_CHAR(i),  -- Генерация номера счета
            v_currency_id,        -- Используем случайный CURRENCY_ID
            ROUND(DBMS_RANDOM.VALUE(100, 10000), 2),  -- Случайная сумма
            v_user_id             -- Используем случайный USER_ID
        );

        -- Коммит каждые 1000 вставок, чтобы избежать переполнения
        IF MOD(i, 1000) = 0 THEN
            COMMIT;
        END IF;
    END LOOP;

    COMMIT;  -- Сохраняем изменения после последней вставки
END;

