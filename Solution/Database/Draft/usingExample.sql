-- Пример использования в таблице App_User для хранения паролей и соли
-- Добавление пользователя с зашифрованным паролем
DECLARE
    v_salt VARCHAR2(128);
    v_encrypted_password RAW(2048);
BEGIN
    -- Генерация соли
    v_salt := generate_salt('example@example.com');

    -- Шифрование пароля
    v_encrypted_password := encrypt('user_password', v_salt);

    -- Вставка данных в таблицу App_User
    INSERT INTO App_User (LOGIN, PASSWORD)
    VALUES ('example@example.com', v_encrypted_password);

    -- Логируем соль в таблицу User_Profile для привязки к пользователю
    UPDATE User_Profile
    SET SALT = v_salt
    WHERE EMAIL = 'example@example.com';
END;
/

-- Расшифровка пароля для проверки
DECLARE
    v_salt VARCHAR2(128);
    v_encrypted_password RAW(2048);
    v_decrypted_password VARCHAR2(255);
BEGIN
    -- Получаем соль из профиля пользователя
    SELECT SALT INTO v_salt
    FROM User_Profile
    WHERE EMAIL = 'example@example.com';

    -- Получаем зашифрованный пароль
    SELECT PASSWORD INTO v_encrypted_password
    FROM App_User
    WHERE LOGIN = 'example@example.com';

    -- Расшифровываем пароль
    v_decrypted_password := decrypt(v_encrypted_password, v_salt);

    DBMS_OUTPUT.PUT_LINE('Decrypted Password: ' || v_decrypted_password);
END;
/