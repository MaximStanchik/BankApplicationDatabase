-- Экспорт данных для admin_user.User_Account
BEGIN
    sys.ExportUserAccountsToJSON('JSON_FILES'); 
    DBMS_OUTPUT.PUT_LINE('Экспорт завершен успешно.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при экспорте: ' || SQLERRM);
END;

-- Импорт данных для admin_user.User_Account
BEGIN
    sys.ImportUserAccountsFromJSON;
    DBMS_OUTPUT.PUT_LINE('Импорт завершен успешно.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при импорте: ' || SQLERRM);
END;


--Экспорт данных из таблицы admin_user.User_Account
CREATE OR REPLACE PROCEDURE ExportUserAccountsToJSON(P_DIRECTORY IN VARCHAR2) AS
    file_handle UTL_FILE.file_type;
    json_record CLOB; 
    chunk_size PLS_INTEGER := 32767; 
    offset PLS_INTEGER := 1; 
    json_obj JSON_OBJECT_T;
    first_record BOOLEAN := TRUE;
BEGIN
    file_handle := UTL_FILE.FOPEN(P_DIRECTORY, 'user_accounts.json', 'w');

    UTL_FILE.PUT_LINE(file_handle, '[');

    FOR rec IN (SELECT * FROM admin_user.User_Account) LOOP
        json_obj := JSON_OBJECT_T();

        json_obj.put('ID', rec.ID);
        json_obj.put('ACCOUNT_NUMBER', rec.ACCOUNT_NUMBER);
        json_obj.put('CURRENCY', rec.CURRENCY);
        json_obj.put('AMOUNT', rec.AMOUNT);
        json_obj.put('USER_ID', rec.USER_ID);

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
EXCEPTION
    WHEN OTHERS THEN
        IF UTL_FILE.IS_OPEN(file_handle) THEN
            UTL_FILE.FCLOSE(file_handle);
        END IF;
        RAISE;
END;

SELECT * 
FROM user_errors 
WHERE name = 'EXPORTUSERACCOUNTSTOJSON' AND type = 'PROCEDURE';

--Импорт данных из таблицы admin_user.User_Account
CREATE OR REPLACE PROCEDURE ImportUserAccountsFromJSON IS
  v_file       UTL_FILE.file_type;
  v_data       CLOB := '';
  v_line       VARCHAR2(32767);
  v_json_entry VARCHAR2(32767);
  v_id         NUMBER;
  v_account_num VARCHAR2(16);
  v_currency   VARCHAR2(4);
  v_amount     VARCHAR2(30);
  v_user_id    NUMBER;
  v_exists     NUMBER := 0;
BEGIN
  v_file := UTL_FILE.FOPEN('JSON_FILES', 'user_accounts.json', 'r');
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

    DBMS_OUTPUT.PUT_LINE('Обрабатываем запись: ' || v_json_entry);

    BEGIN
      -- Извлечение ID
      BEGIN
        SELECT TO_NUMBER(REGEXP_SUBSTR(v_json_entry, '"ID"\s*:\s*(\d+)', 1, 1, NULL, 1))
        INTO v_id
        FROM dual;
      EXCEPTION
        WHEN VALUE_ERROR THEN
          v_id := NULL;
      END;

      -- Извлечение ACCOUNT_NUMBER
      v_account_num := REGEXP_SUBSTR(v_json_entry, '"ACCOUNT_NUMBER"\s*:\s*"([^"]+)"', 1, 1, NULL, 1);

      -- Извлечение CURRENCY
      v_currency := REGEXP_SUBSTR(v_json_entry, '"CURRENCY"\s*:\s*"([^"]+)"', 1, 1, NULL, 1);

      -- Извлечение AMOUNT
      v_amount := NULL;
      BEGIN
        SELECT REGEXP_SUBSTR(v_json_entry, '"AMOUNT"\s*:\s*([0-9]+(?:\.[0-9]+)?)', 1, 1, NULL, 1)
        INTO v_amount
        FROM dual;
      EXCEPTION
        WHEN VALUE_ERROR THEN
          v_amount := NULL;
      END;

      -- Извлечение USER_ID
      BEGIN
        SELECT TO_NUMBER(REGEXP_SUBSTR(v_json_entry, '"USER_ID"\s*:\s*(\d+)', 1, 1, NULL, 1))
        INTO v_user_id
        FROM dual;
      EXCEPTION
        WHEN VALUE_ERROR THEN
          v_user_id := NULL;
      END;

      -- Проверка значений перед вставкой
      IF v_id IS NOT NULL AND v_account_num IS NOT NULL AND v_currency IS NOT NULL AND v_amount IS NOT NULL THEN
        SELECT COUNT(*) INTO v_exists
        FROM admin_user.User_Account
        WHERE ID = v_id;

        IF v_exists = 0 THEN
          INSERT INTO admin_user.User_Account (ID, ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID)
          VALUES (v_id, v_account_num, v_currency, TO_NUMBER(v_amount), v_user_id);
          DBMS_OUTPUT.PUT_LINE('Запись вставлена: ID = ' || v_id);
        ELSE
          DBMS_OUTPUT.PUT_LINE('Запись уже существует: ID = ' || v_id || ', пропуск.');
        END IF;
      ELSE
        DBMS_OUTPUT.PUT_LINE('Пропуск записи из-за NULL значений: ' || v_json_entry);
      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка при обработке записи: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Запись: ' || v_json_entry);
    END;

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
WHERE name = 'IMOPRTUSERACCOUNTSFROMJSON' AND type = 'PROCEDURE';