--Настройки 
alter pluggable database BANK_APP_PDB open; 
alter session set container = BANK_APP_PDB;

--Создание дирректории
CREATE OR REPLACE DIRECTORY JSON_FILES AS '/home/oracle/files/';
GRANT READ, WRITE ON DIRECTORY JSON_FILES TO admin_user; 

SELECT * FROM all_directories WHERE directory_name = 'JSON_FILES';

--Экспорт данных из таблицы Currency
CREATE OR REPLACE PROCEDURE ExportCurrencyToJSON(P_DIRECTORY IN VARCHAR2) AS
    file_handle UTL_FILE.file_type;
    json_record CLOB; 
    chunk_size PLS_INTEGER := 32767; 
    offset PLS_INTEGER := 1; 
    json_obj JSON_OBJECT_T;
    first_record BOOLEAN := TRUE;
BEGIN
    file_handle := UTL_FILE.FOPEN(P_DIRECTORY, 'currencies.json', 'w');

    UTL_FILE.PUT_LINE(file_handle, '[');

    FOR rec IN (SELECT ID, NAME, CODE FROM admin_user.Currency) LOOP
        json_obj := JSON_OBJECT_T();

        json_obj.put('ID', rec.ID);
        json_obj.put('NAME', rec.NAME);
        json_obj.put('CODE', rec.CODE);

        IF NOT first_record THEN
            json_record := ',' || json_obj.to_clob();
        ELSE
            first_record := FALSE;
            json_record := json_obj.to_clob();
        END IF;

        offset := 1;
        WHILE offset <= DBMS_LOB.GETLENGTH(json_record) LOOP
            UTL_FILE.PUT(file_handle, DBMS_LOB.SUBSTR(json_record, chunk_size, offset));
            offset := offset + chunk_size;
        END LOOP;
        
        UTL_FILE.NEW_LINE(file_handle);
    END LOOP;

    UTL_FILE.PUT_LINE(file_handle, ']');
    UTL_FILE.FCLOSE(file_handle);
   
   	DBMS_OUTPUT.PUT_LINE('Экспорт данных успешно завершён в ' || P_DIRECTORY || '/currencies.json');
  
EXCEPTION
    WHEN OTHERS THEN
        IF UTL_FILE.IS_OPEN(file_handle) THEN
            UTL_FILE.FCLOSE(file_handle);
        END IF;
        RAISE;
END;

SELECT * 
FROM user_errors 
WHERE name = 'EXPORTCURRENCYTOJSON' AND type = 'PROCEDURE';

--Импорт данных из таблицы Currency
CREATE OR REPLACE PROCEDURE ImportCurrencyFromJSON IS
    v_file       UTL_FILE.file_type;
    v_data       CLOB := '';
    v_line       VARCHAR2(32767);
    v_json_entry VARCHAR2(32767);
    v_id         NUMBER;
    v_name       VARCHAR2(100);
    v_code       VARCHAR2(3);
    v_exists     NUMBER := 0;
BEGIN
    v_file := UTL_FILE.FOPEN('JSON_FILES', 'currencies.json', 'r');
    DBMS_OUTPUT.PUT_LINE('Начало чтения файла...');

    LOOP
        BEGIN
            UTL_FILE.GET_LINE(v_file, v_line);
            v_data := v_data || v_line;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                EXIT;
        END;
    END LOOP;

    UTL_FILE.FCLOSE(v_file);

    DBMS_OUTPUT.PUT_LINE('Содержимое файла: ' || v_data);

    IF v_data LIKE '[%' AND v_data LIKE '%]' THEN
        v_data := SUBSTR(v_data, 2, LENGTH(v_data) - 2);
    END IF;

    WHILE INSTR(v_data, '{') > 0 LOOP
        v_json_entry := SUBSTR(v_data, INSTR(v_data, '{'), INSTR(v_data, '}') - INSTR(v_data, '{') + 1);
        v_data := SUBSTR(v_data, INSTR(v_data, '}') + 1);

        v_id := TO_NUMBER(REGEXP_SUBSTR(v_json_entry, '"ID"\s*:\s*(\d+)', 1, 1, NULL, 1));
        v_name := REGEXP_SUBSTR(v_json_entry, '"NAME"\s*:\s*"([^"]+)"', 1, 1, NULL, 1);
        v_code := REGEXP_SUBSTR(v_json_entry, '"CODE"\s*:\s*"([^"]+)"', 1, 1, NULL, 1);

        IF v_id IS NOT NULL AND v_name IS NOT NULL AND v_code IS NOT NULL THEN
            SELECT COUNT(*) INTO v_exists
            FROM admin_user.Currency
            WHERE ID = v_id;

            IF v_exists = 0 THEN
                INSERT INTO admin_user.Currency (ID, NAME, CODE)
                VALUES (v_id, v_name, v_code);
                DBMS_OUTPUT.PUT_LINE('Запись вставлена: ID = ' || v_id);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Запись уже существует: ID = ' || v_id || ', пропуск.');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Пропуск записи из-за NULL значений: ' || v_json_entry);
        END IF;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Импорт данных завершен успешно.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        RAISE;
END;

SELECT * 
FROM user_errors 
WHERE name = 'IMPORTCURRENCYFROMJSON' AND type = 'PROCEDURE';

-- Процедура экспорта данных из таблицы Payment_Service в JSON
CREATE OR REPLACE PROCEDURE ExportPaymentServiceToJSON(P_DIRECTORY IN VARCHAR2) AS
    file_handle UTL_FILE.file_type;
    json_record CLOB;
    chunk_size PLS_INTEGER := 32767;
    offset PLS_INTEGER := 1;
    json_obj JSON_OBJECT_T;
    first_record BOOLEAN := TRUE;
BEGIN
    file_handle := UTL_FILE.FOPEN(P_DIRECTORY, 'payment_services.json', 'w');

    UTL_FILE.PUT_LINE(file_handle, '[');

    FOR rec IN (SELECT ID, NAME, TYPE FROM admin_user.Payment_Service) LOOP
        json_obj := JSON_OBJECT_T();

        json_obj.put('ID', rec.ID);
        json_obj.put('NAME', rec.NAME);
        json_obj.put('TYPE', rec.TYPE);

        IF NOT first_record THEN
            json_record := ',' || json_obj.to_clob();
        ELSE
            first_record := FALSE;
            json_record := json_obj.to_clob();
        END IF;

        offset := 1;
        WHILE offset <= DBMS_LOB.GETLENGTH(json_record) LOOP
            UTL_FILE.PUT(file_handle, DBMS_LOB.SUBSTR(json_record, chunk_size, offset));
            offset := offset + chunk_size;
        END LOOP;
        UTL_FILE.NEW_LINE(file_handle);
    END LOOP;

    UTL_FILE.PUT_LINE(file_handle, ']');
    UTL_FILE.FCLOSE(file_handle);
   	DBMS_OUTPUT.PUT_LINE('Экспорт данных успешно завершён в ' || P_DIRECTORY || '/payment_services.json');
EXCEPTION
    WHEN OTHERS THEN
        IF UTL_FILE.IS_OPEN(file_handle) THEN
            UTL_FILE.FCLOSE(file_handle);
        END IF;
        RAISE;
END;

SELECT * 
FROM user_errors 
WHERE name = 'EXPORTPAYMENTSERVICETOJSON' AND type = 'PROCEDURE';

--Процедура импорта данных из JSON в таблицу Payment_Service
CREATE OR REPLACE PROCEDURE ImportPaymentServiceFromJSON IS
    v_file       UTL_FILE.file_type;
    v_data       CLOB := '';
    v_line       VARCHAR2(32767);
    v_json_entry VARCHAR2(32767);
    v_id         NUMBER;
    v_name       NVARCHAR2(100);
    v_type       NVARCHAR2(50);
    v_exists     NUMBER := 0;
BEGIN
    v_file := UTL_FILE.FOPEN('JSON_FILES', 'payment_services.json', 'r');
    DBMS_OUTPUT.PUT_LINE('Начало чтения файла...');

    LOOP
        BEGIN
            UTL_FILE.GET_LINE(v_file, v_line);
            v_data := v_data || v_line;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                EXIT;
        END;
    END LOOP;

    UTL_FILE.FCLOSE(v_file);

    DBMS_OUTPUT.PUT_LINE('Содержимое файла: ' || v_data);

    IF v_data LIKE '[%' AND v_data LIKE '%]' THEN
        v_data := SUBSTR(v_data, 2, LENGTH(v_data) - 2);
    END IF;

    WHILE INSTR(v_data, '{') > 0 LOOP
        v_json_entry := SUBSTR(v_data, INSTR(v_data, '{'), INSTR(v_data, '}') - INSTR(v_data, '{') + 1);
        v_data := SUBSTR(v_data, INSTR(v_data, '}') + 1);

        v_id := TO_NUMBER(REGEXP_SUBSTR(v_json_entry, '"ID"\s*:\s*(\d+)', 1, 1, NULL, 1));
        v_name := REGEXP_SUBSTR(v_json_entry, '"NAME"\s*:\s*"([^"]+)"', 1, 1, NULL, 1);
        v_type := REGEXP_SUBSTR(v_json_entry, '"TYPE"\s*:\s*"([^"]+)"', 1, 1, NULL, 1);

        IF v_id IS NOT NULL AND v_name IS NOT NULL AND v_type IS NOT NULL THEN
            SELECT COUNT(*) INTO v_exists
            FROM admin_user.Payment_Service
            WHERE ID = v_id;

            IF v_exists = 0 THEN
                INSERT INTO admin_user.Payment_Service (ID, NAME, TYPE)
                VALUES (v_id, v_name, v_type);
                DBMS_OUTPUT.PUT_LINE('Запись вставлена: ID = ' || v_id);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Запись уже существует: ID = ' || v_id || ', пропуск.');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Пропуск записи из-за NULL значений: ' || v_json_entry);
        END IF;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Импорт данных завершен успешно.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        RAISE;
END;

SELECT * 
FROM user_errors 
WHERE name = 'IMPORTPAYMENTSERVICEFROMJSON' AND type = 'PROCEDURE';

--Процедура экспорта данных из таблицы Credit_Type в JSON
CREATE OR REPLACE PROCEDURE ExportCreditTypeToJSON(P_DIRECTORY IN VARCHAR2) AS
    file_handle UTL_FILE.file_type;
    json_record CLOB;
    chunk_size PLS_INTEGER := 32767;
    offset PLS_INTEGER := 1;
    json_obj JSON_OBJECT_T;
    first_record BOOLEAN := TRUE;
BEGIN
    file_handle := UTL_FILE.FOPEN(P_DIRECTORY, 'credit_types.json', 'w');

    UTL_FILE.PUT_LINE(file_handle, '[');

    FOR rec IN (SELECT ID, TYPE, CREDIT_NAME, DESCRIPTION FROM admin_user.Credit_Type) LOOP
        json_obj := JSON_OBJECT_T();

        json_obj.put('ID', rec.ID);
        json_obj.put('TYPE', rec.TYPE);
        json_obj.put('CREDIT_NAME', rec.CREDIT_NAME);
        json_obj.put('DESCRIPTION', rec.DESCRIPTION);

        IF NOT first_record THEN
            json_record := ',' || json_obj.to_clob();
        ELSE
            first_record := FALSE;
            json_record := json_obj.to_clob();
        END IF;

        offset := 1;
        WHILE offset <= DBMS_LOB.GETLENGTH(json_record) LOOP
            UTL_FILE.PUT(file_handle, DBMS_LOB.SUBSTR(json_record, chunk_size, offset));
            offset := offset + chunk_size;
        END LOOP;
        
        UTL_FILE.NEW_LINE(file_handle);
    END LOOP;

    UTL_FILE.PUT_LINE(file_handle, ']');
    UTL_FILE.FCLOSE(file_handle);
  	DBMS_OUTPUT.PUT_LINE('Экспорт данных успешно завершён в ' || P_DIRECTORY || '/credit_types.json');
EXCEPTION
    WHEN OTHERS THEN
        IF UTL_FILE.IS_OPEN(file_handle) THEN
            UTL_FILE.FCLOSE(file_handle);
        END IF;
        RAISE;
END;

SELECT * 
FROM user_errors 
WHERE name = 'EXPORTCREDITTYPETOJSON' AND type = 'PROCEDURE';

--Процедура импорта данных из JSON в таблицу Credit_Type
CREATE OR REPLACE PROCEDURE ImportCreditTypeFromJSON IS
    v_file       UTL_FILE.file_type;
    v_data       CLOB := '';
    v_line       VARCHAR2(32767);
    v_json_entry VARCHAR2(32767);
    v_id         NUMBER;
    v_type       NVARCHAR2(50);
    v_credit_name NVARCHAR2(100);
    v_description NVARCHAR2(255);
    v_exists     NUMBER := 0;
BEGIN
    v_file := UTL_FILE.FOPEN('JSON_FILES', 'credit_types.json', 'r');
    DBMS_OUTPUT.PUT_LINE('Начало чтения файла...');

    LOOP
        BEGIN
            UTL_FILE.GET_LINE(v_file, v_line);
            v_data := v_data || v_line;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                EXIT;
        END;
    END LOOP;

    UTL_FILE.FCLOSE(v_file);

    DBMS_OUTPUT.PUT_LINE('Содержимое файла: ' || v_data);

    IF v_data LIKE '[%' AND v_data LIKE '%]' THEN
        v_data := SUBSTR(v_data, 2, LENGTH(v_data) - 2);
    END IF;

    WHILE INSTR(v_data, '{') > 0 LOOP
        v_json_entry := SUBSTR(v_data, INSTR(v_data, '{'), INSTR(v_data, '}') - INSTR(v_data, '{') + 1);
        v_data := SUBSTR(v_data, INSTR(v_data, '}') + 1);

        v_id := TO_NUMBER(REGEXP_SUBSTR(v_json_entry, '"ID"\s*:\s*(\d+)', 1, 1, NULL, 1));
        v_type := REGEXP_SUBSTR(v_json_entry, '"TYPE"\s*:\s*"([^"]+)"', 1, 1, NULL, 1);
        v_credit_name := REGEXP_SUBSTR(v_json_entry, '"CREDIT_NAME"\s*:\s*"([^"]+)"', 1, 1, NULL, 1);
        v_description := REGEXP_SUBSTR(v_json_entry, '"DESCRIPTION"\s*:\s*"([^"]+)"', 1, 1, NULL, 1);

        IF v_type IS NOT NULL AND v_credit_name IS NOT NULL AND v_description IS NOT NULL THEN
            SELECT COUNT(*) INTO v_exists
            FROM admin_user.Credit_Type
            WHERE CREDIT_NAME = v_credit_name;

            IF v_exists = 0 THEN
                INSERT INTO admin_user.Credit_Type (TYPE, CREDIT_NAME, DESCRIPTION)
                VALUES (v_type, v_credit_name, v_description);
                DBMS_OUTPUT.PUT_LINE('Запись вставлена: CREDIT_NAME = ' || v_credit_name);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Запись уже существует: CREDIT_NAME = ' || v_credit_name || ', пропуск.');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Пропуск записи из-за NULL значений: ' || v_json_entry);
        END IF;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Импорт данных завершен успешно.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        RAISE;
END;

SELECT * 
FROM user_errors 
WHERE name = 'IMPORTCREDITTYPEFROMJSON' AND type = 'PROCEDURE';

-- Процедура экспорта данных из таблицы Currency_Exchange_Rate
CREATE OR REPLACE PROCEDURE ExportCurrencyExchangeRateToJSON(P_DIRECTORY IN VARCHAR2) AS
    file_handle UTL_FILE.file_type;
    json_record CLOB;
    chunk_size PLS_INTEGER := 32767;
    offset PLS_INTEGER := 1;
    json_obj JSON_OBJECT_T;
    first_record BOOLEAN := TRUE;
BEGIN
    file_handle := UTL_FILE.FOPEN(P_DIRECTORY, 'currency_exchange_rates.json', 'w');

    UTL_FILE.PUT_LINE(file_handle, '[');

    FOR rec IN (SELECT ID, CURR_ID, BUY, SALE, POSTING_DATE FROM admin_user.Currency_Exchange_Rate) LOOP
        json_obj := JSON_OBJECT_T();

        json_obj.put('ID', rec.ID);
        json_obj.put('CURR_ID', rec.CURR_ID);
        json_obj.put('BUY', rec.BUY);
        json_obj.put('SALE', rec.SALE);
        json_obj.put('POSTING_DATE', TO_CHAR(rec.POSTING_DATE, 'YYYY-MM-DD'));

        IF NOT first_record THEN
            json_record := ',' || json_obj.to_clob();
        ELSE
            first_record := FALSE;
            json_record := json_obj.to_clob();
        END IF;

        offset := 1;
        WHILE offset <= DBMS_LOB.GETLENGTH(json_record) LOOP
            UTL_FILE.PUT(file_handle, DBMS_LOB.SUBSTR(json_record, chunk_size, offset));
            offset := offset + chunk_size;
        END LOOP;

        UTL_FILE.NEW_LINE(file_handle);
    END LOOP;

    UTL_FILE.PUT_LINE(file_handle, ']');
    UTL_FILE.FCLOSE(file_handle);
    DBMS_OUTPUT.PUT_LINE('Экспорт данных успешно завершён в ' || P_DIRECTORY || '/currency_exchange_rates.json');
EXCEPTION
    WHEN OTHERS THEN
        IF UTL_FILE.IS_OPEN(file_handle) THEN
            UTL_FILE.FCLOSE(file_handle);
        END IF;
        RAISE;
END;

SELECT * 
FROM user_errors 
WHERE name = 'EXPORTCURRENCYEXCHANGERATETOJSON' AND type = 'PROCEDURE';

--Процедура импорта данных из JSON в таблицу Currency_Exchange_Rate
CREATE OR REPLACE PROCEDURE ImportCurrencyExchangeRateFromJSON IS
    v_file             UTL_FILE.file_type;
    v_data             CLOB := '';
    v_line             VARCHAR2(32767);
    v_json_entry       VARCHAR2(32767);
    v_curr_id          NUMBER;
    v_buy              NUMBER;
    v_sale             NUMBER;
    v_posting_date     DATE;
    v_exists           NUMBER := 0;
BEGIN
    v_file := UTL_FILE.FOPEN('JSON_FILES', 'currency_exchange_rates.json', 'r');
    DBMS_OUTPUT.PUT_LINE('Начало чтения файла...');

    LOOP
        BEGIN
            UTL_FILE.GET_LINE(v_file, v_line);
            v_data := v_data || v_line;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                EXIT;
        END;
    END LOOP;

    UTL_FILE.FCLOSE(v_file);

    DBMS_OUTPUT.PUT_LINE('Содержимое файла: ' || v_data);

    IF v_data LIKE '[%' AND v_data LIKE '%]' THEN
        v_data := SUBSTR(v_data, 2, LENGTH(v_data) - 2);
    END IF;

    WHILE INSTR(v_data, '{') > 0 LOOP
        v_json_entry := SUBSTR(v_data, INSTR(v_data, '{'), INSTR(v_data, '}') - INSTR(v_data, '{') + 1);
        v_data := SUBSTR(v_data, INSTR(v_data, '}') + 1);

        v_curr_id := TO_NUMBER(REGEXP_SUBSTR(v_json_entry, '"CURR_ID"\s*:\s*(\d+)', 1, 1, NULL, 1));
        v_buy := TO_NUMBER(REGEXP_SUBSTR(v_json_entry, '"BUY"\s*:\s*([0-9]+(?:\.[0-9]+)?)', 1, 1, NULL, 1));
        v_sale := TO_NUMBER(REGEXP_SUBSTR(v_json_entry, '"SALE"\s*:\s*([0-9]+(?:\.[0-9]+)?)', 1, 1, NULL, 1));
        v_posting_date := TO_DATE(REGEXP_SUBSTR(v_json_entry, '"POSTING_DATE"\s*:\s*"([^"]+)"', 1, 1, NULL, 1), 'YYYY-MM-DD');

        IF v_curr_id IS NOT NULL AND v_buy IS NOT NULL AND v_sale IS NOT NULL AND v_posting_date IS NOT NULL THEN
            SELECT COUNT(*) INTO v_exists
            FROM admin_user.Currency_Exchange_Rate
            WHERE CURR_ID = v_curr_id AND POSTING_DATE = v_posting_date;

            IF v_exists = 0 THEN
                INSERT INTO admin_user.Currency_Exchange_Rate (CURR_ID, BUY, SALE, POSTING_DATE)
                VALUES (v_curr_id, v_buy, v_sale, v_posting_date);
                DBMS_OUTPUT.PUT_LINE('Запись вставлена: CURR_ID = ' || v_curr_id);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Запись уже существует: CURR_ID = ' || v_curr_id || ', пропуск.');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Пропуск записи из-за NULL значений: ' || v_json_entry);
        END IF;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Импорт данных завершен успешно.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        RAISE;
END;

SELECT * 
FROM user_errors 
WHERE name = 'IMPORTCURRENCYEXCHANGERATEFROMJSON' AND type = 'PROCEDURE';