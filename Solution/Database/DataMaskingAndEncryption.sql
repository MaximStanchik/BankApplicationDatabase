-- Установить контейнер для работы с базой данных
ALTER SESSION SET CONTAINER = BANK_APP_PDB;

-----------------------
-- ШИФРОВАНИЕ ДАННЫХ -- 
-----------------------

-- Функция для разделения строки (удаляет соль из расшифрованного текста)
CREATE OR REPLACE FUNCTION separate_string(p_pass VARCHAR2, p_salt VARCHAR2) RETURN VARCHAR2 IS
    result_string VARCHAR2(2000);
BEGIN
    IF INSTR(p_pass, p_salt) > 0 THEN
        result_string := SUBSTR(p_pass, 1, INSTR(p_pass, p_salt) - 1);
    ELSE
        result_string := p_pass;
    END IF;
    RETURN result_string;
END separate_string;

SELECT * 
FROM USER_ERRORS 
WHERE NAME = 'SEPARATE_STRING' AND TYPE = 'FUNCTION';

-- Функция для шифрования текста
CREATE OR REPLACE FUNCTION encrypt(p_plain_text VARCHAR2, p_salt VARCHAR2) RETURN RAW IS
    encryption_key RAW(256) := HEXTORAW('0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF');
    encrypted_raw RAW(2048);
BEGIN
    encrypted_raw := DBMS_CRYPTO.ENCRYPT(
        src => UTL_I18N.STRING_TO_RAW(p_plain_text || p_salt, 'AL32UTF8'),
        typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => encryption_key
    );
    RETURN encrypted_raw;
END encrypt;

SELECT * 
FROM USER_ERRORS 
WHERE NAME = 'ENCRYPT' AND TYPE = 'FUNCTION';

-- Функция для расшифровки текста
CREATE OR REPLACE FUNCTION decrypt(p_encrypted_text RAW, p_salt VARCHAR2) RETURN VARCHAR2 IS
    encryption_key RAW(256) := HEXTORAW('0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF');
    decrypted_raw RAW(2048);
BEGIN
    decrypted_raw := DBMS_CRYPTO.DECRYPT(
        src => p_encrypted_text,
        typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => encryption_key
    );
    RETURN separate_string(UTL_I18N.RAW_TO_CHAR(decrypted_raw, 'AL32UTF8'), p_salt);
END decrypt;

SELECT * 
FROM USER_ERRORS 
WHERE NAME = 'DECRYPT' AND TYPE = 'FUNCTION';

-- Функция для генерации соли на основе электронной почты клиента
CREATE OR REPLACE FUNCTION generate_salt(p_email VARCHAR2) RETURN VARCHAR2 IS
    v_salt VARCHAR2(128);
BEGIN
    SELECT DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW(p_email, 'AL32UTF8'), DBMS_CRYPTO.HASH_SH1)
    INTO v_salt
    FROM dual;
    RETURN v_salt;
END generate_salt;

SELECT * 
FROM USER_ERRORS 
WHERE NAME = 'GENERATE_SALT' AND TYPE = 'FUNCTION';

-- Функция для шифрования номера кредитной карты
CREATE OR REPLACE FUNCTION encrypt_credit_card(p_card_number VARCHAR2) RETURN RAW IS
    encryption_key RAW(256) := HEXTORAW('0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF');
    encrypted_raw RAW(2048);
BEGIN
    encrypted_raw := DBMS_CRYPTO.ENCRYPT(
        src => UTL_I18N.STRING_TO_RAW(p_card_number, 'AL32UTF8'),
        typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => encryption_key
    );
    RETURN encrypted_raw;
END encrypt_credit_card;

SELECT * 
FROM USER_ERRORS 
WHERE NAME = 'ENCRYPT_CREDIT_CARD' AND TYPE = 'FUNCTION';

-- Шифрование номера телефона
CREATE OR REPLACE FUNCTION encrypt_phone(p_phone VARCHAR2) RETURN RAW IS
    encryption_key RAW(256) := HEXTORAW('0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF');
    encrypted_raw RAW(2048);
BEGIN
    encrypted_raw := DBMS_CRYPTO.ENCRYPT(
        src => UTL_I18N.STRING_TO_RAW(p_phone, 'AL32UTF8'),
        typ => DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => encryption_key
    );
    RETURN encrypted_raw;
END encrypt_phone;

SELECT * 
FROM USER_ERRORS 
WHERE NAME = 'ENCRYPT_PHONE' AND TYPE = 'FUNCTION';

-- Функция для создания хэша с помощью SHA1
CREATE OR REPLACE FUNCTION short_encrypt(p_plain_text VARCHAR2) RETURN RAW IS
    v_hash RAW(20);
BEGIN
    v_hash := DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW(p_plain_text, 'AL32UTF8'), DBMS_CRYPTO.HASH_SH1);
    RETURN v_hash;
END short_encrypt;

SELECT * 
FROM USER_ERRORS 
WHERE NAME = 'SHORT_ENCRYPT' AND TYPE = 'FUNCTION';

------------------------------------
-- МАСКИРОВАНИЕ ЗНАЧЕНИЙ СТОЛБЦОВ -- 
------------------------------------

-- Маскирование номера кредитной карты
CREATE OR REPLACE FUNCTION mask_credit_card(p_card_number VARCHAR2) RETURN VARCHAR2 IS
BEGIN
    RETURN '**** **** **** ' || SUBSTR(p_card_number, -4);
END mask_credit_card;

SELECT * 
FROM USER_ERRORS 
WHERE NAME = 'MASK_CREDIT_CARD' AND TYPE = 'FUNCTION';

-- Маскирование адреса
CREATE OR REPLACE FUNCTION mask_address(p_address VARCHAR2) RETURN VARCHAR2 IS
BEGIN
    RETURN '**** ' || SUBSTR(p_address, INSTR(p_address, ' ') + 1, 50);  
END mask_address;

SELECT * 
FROM USER_ERRORS 
WHERE NAME = 'MASK_ADDRESS' AND TYPE = 'FUNCTION';

-- Маскирование номера телефона
CREATE OR REPLACE FUNCTION mask_phone(p_phone VARCHAR2) RETURN VARCHAR2 IS
BEGIN
    RETURN '***-***-' || SUBSTR(p_phone, -4);
END mask_phone;

SELECT * 
FROM USER_ERRORS 
WHERE NAME = 'MASK_PHONE' AND TYPE = 'FUNCTION';

-------------------------
-- НАСТРОЙКИ ТРИГГЕРОВ -- 
-------------------------
-- Триггер для автоматического шифрования паролей
CREATE OR REPLACE TRIGGER trg_encrypt_password
BEFORE INSERT OR UPDATE ON admin_user.App_User
FOR EACH ROW
BEGIN
  :NEW.PASSWORD := UTL_RAW.CAST_TO_VARCHAR2(encrypt(:NEW.PASSWORD, generate_salt(:NEW.LOGIN)));
END;

SELECT * 
FROM USER_ERRORS 
WHERE NAME = 'trg_encrypt_password' AND TYPE = 'TRIGGER';

-- Триггер для User_Profile
CREATE OR REPLACE TRIGGER trg_mask_user_profile
BEFORE INSERT OR UPDATE ON admin_user.User_Profile
FOR EACH ROW
BEGIN
  IF :NEW.PASSPORT_NUM IS NOT NULL THEN
    :NEW.PASSPORT_NUM := REGEXP_REPLACE(:NEW.PASSPORT_NUM, '.{6}$', '******');
  END IF;

  IF :NEW.PHONE_NUMBER IS NOT NULL THEN
    :NEW.PHONE_NUMBER := REGEXP_REPLACE(:NEW.PHONE_NUMBER, '.{4}$', '****');
  END IF;
END;

SELECT * 
FROM USER_ERRORS 
WHERE NAME = 'trg_mask_user_profile' AND TYPE = 'TRIGGER';

-- Шифрование данных в таблицах
UPDATE admin_user.User_Profile
SET LAST_NAME = LAST_NAME,  
    MIDDLE_NAME = MIDDLE_NAME,
    ADDRESS = ADDRESS,
    BIRTH_DATE = BIRTH_DATE,
    PASSPORT_NUM = PASSPORT_NUM,
    PHONE_NUMBER = PHONE_NUMBER;
      
UPDATE admin_user.App_User
SET LOGIN = LOGIN,  
    PASSWORD = PASSWORD;
   
SELECT TRIGGER_NAME, STATUS
FROM USER_TRIGGERS
WHERE TABLE_NAME IN ('USER_PROFILE', 'APP_USER');
