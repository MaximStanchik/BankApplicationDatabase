----------Регситрация нового клиента----------
create or replace PROCEDURE system.REGISTER_USER(
    p_login IN VARCHAR2,
    p_password IN VARCHAR2,
    p_user_id OUT NUMBER,
    p_user_login OUT VARCHAR2
) AS
    v_user_count NUMBER;
begin

    SELECT COUNT(*)
    INTO v_user_count
    FROM App_User
    WHERE LOGIN = p_login;

    IF v_user_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'User already exists');
    END IF;

    IF LENGTH(p_login) < 3 OR LENGTH(p_password) < 6 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Login or password are not valid');
    END IF;

    INSERT INTO App_User (LOGIN, PASSWORD)
    VALUES (p_login, p_password)
    RETURNING ID, LOGIN INTO p_user_id, p_user_login;
END;
/

----------Авторизация пользователя----------
CREATE OR REPLACE PROCEDURE system.LOGIN_USER (
    p_login       IN  VARCHAR2,
    p_password    IN  VARCHAR2,
    p_user_id     OUT NUMBER,
    p_token       OUT VARCHAR2,
    p_error_msg   OUT VARCHAR2
) AS
    v_password   VARCHAR2(255);
BEGIN
    p_user_id := NULL;
    p_token := NULL;
    p_error_msg := NULL;
    
    SELECT ID, PASSWORD
    INTO p_user_id, v_password
    FROM App_User
    WHERE LOGIN = p_login;

    IF v_password = p_password THEN
        p_token := DBMS_RANDOM.STRING('U', 16);
    ELSE
        p_user_id := NULL;
        p_token := NULL;
        p_error_msg := 'User password doesn''t match';
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_error_msg := 'User not found';
    WHEN OTHERS THEN
        p_error_msg := SQLERRM;
END LOGIN_USER;
/

SELECT object_name, status
FROM user_objects
WHERE object_type = 'FUNCTION' AND object_name = 'REGISTER_USER';


DROP PROCEDURE SYSTEM.REGISTER_USER;

----------Получить информацию о транзакции по её идентификатору----------
----------Получить информацию о банковской карте по её идентификатору----------
----------Получить тип кредита по его идентификатору----------
----------Получить информацию о платёжном сервисе по его идентификатору----------
----------Получить информацию о валюте по её идентификатору----------

----------Добавить тип кредита----------
----------Изменить тип кредита----------
----------Удалить тип кредита----------
----------Добавить новую валюту----------
----------Изменить информацию о валюте ----------
