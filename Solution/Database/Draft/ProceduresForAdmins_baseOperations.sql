----------------------------------------Процедуры для базовых операций с таблицами (выполняются администратором):----------------------------------------

--Currency:

--Добавить валюту:
create or replace procedure InsertCurrency(
    P_NAME in varchar2,
    P_CODE in varchar2
) as
begin
insert into Currency (NAME, CODE)
values (P_NAME, P_CODE);
end;
/

--Обновить валюту:
create or replace procedure UpdateCurrency(
    P_ID in number,
    P_NAME in varchar2,
    P_CODE in varchar2
) as
begin
update Currency
set NAME = P_NAME,
    CODE = P_CODE
where ID = P_ID;
end;
/

--Удалить валюту
create or replace procedure DeleteCurrency(
    P_ID in number
) as
begin
delete from Currency
where ID = P_ID;
end;
/

--Вывести данные из таблицы Currency
create or replace procedure GetAllCurrencies(result out sys_refcursor) as
begin
    open result for select * from Currency;
end;
/


--App_User:

--Добавить пользователя:
create or replace procedure InsertUser(
    P_LOGIN in nvarchar2,
    P_PASSWORD in nvarchar2
) as
begin
insert into App_User (LOGIN, PASSWORD)
values (P_LOGIN, P_PASSWORD);
end;
/

--Обновить пользователя:
create or replace procedure UpdateUser(
    P_ID in number,
    P_LOGIN in nvarchar2,
    P_PASSWORD in nvarchar2
) as
begin
update App_User
set LOGIN = P_LOGIN,
    PASSWORD = P_PASSWORD
where ID = P_ID;
end;
/

--Удалить пользователя:
create or replace procedure DeleteUser(
    P_ID in number
) as
begin
delete from App_User
where ID = P_ID;
end;
/

--Вывод строк из таблицы App_User:
create or replace procedure GetAllUsers(result out sys_refcursor) as
begin
    open result for select * from App_User;
end;
/


--User_Account:

--Добавить счет:
create or replace procedure InsertAccount(
    P_ACCOUNT_NUMBER in nvarchar2,
    P_CURRENCY in varchar2,
    P_AMOUNT in number,
    P_USER_ID in number
) as
begin
insert into User_Account (ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID)
values (P_ACCOUNT_NUMBER, P_CURRENCY, P_AMOUNT, P_USER_ID);
end;
/

--Обновить счет:
create or replace procedure UpdateAccount(
    P_ID in number,
    P_ACCOUNT_NUMBER in nvarchar2,
    P_CURRENCY in varchar2,
    P_AMOUNT in number
) as
begin
update User_Account
set ACCOUNT_NUMBER = P_ACCOUNT_NUMBER,
    CURRENCY = P_CURRENCY,
    AMOUNT = P_AMOUNT
where ID = P_ID;
end;
/

-- Удалить счет:
create or replace procedure DeleteAccount(
    P_ID in number
) as
begin
delete from User_Account
where ID = P_ID;
end;
/

--Вывод всех строк из таблицы User_Account:
create or replace procedure GetAllAccounts(result out sys_refcursor) as
begin
    open result for select * from User_Account;
end;
/


--Card:

--Добавить карту:
create or replace procedure InsertCard(
    P_TYPE in nvarchar2,
    P_ACCOUNT_ID in number,
    P_CARD_NAME in nvarchar2,
    P_CARD_NUMBER in number,
    P_DESCRIPTION in nvarchar2,
    P_STATUS in nvarchar2
) as
begin
insert into Card (TYPE, ACCOUNT_ID, CARD_NAME, CARD_NUMBER, DESCRIPTION, STATUS)
values (P_TYPE, P_ACCOUNT_ID, P_CARD_NAME, P_CARD_NUMBER, P_DESCRIPTION, P_STATUS);
end;
/

--Обновить карту:
create or replace procedure UpdateCard(
    P_ID in number,
    P_TYPE in nvarchar2,
    P_ACCOUNT_ID in number,
    P_CARD_NAME in nvarchar2,
    P_CARD_NUMBER in number,
    P_DESCRIPTION in nvarchar2,
    P_STATUS in nvarchar2
) as
begin
update Card
set TYPE = P_TYPE,
    ACCOUNT_ID = P_ACCOUNT_ID,
    CARD_NAME = P_CARD_NAME,
    CARD_NUMBER = P_CARD_NUMBER,
    DESCRIPTION = P_DESCRIPTION,
    STATUS = P_STATUS
where ID = P_ID;
end;
/

--Удалить карту:
create or replace procedure DeleteCard(
    P_ID in number
) as
begin
delete from Card
where ID = P_ID;
end;
/

--Вывод всех строк из тыблицы Card:
create or replace procedure GetAllCards(result out sys_refcursor) as
begin
    open result for select * from Card;
end;
/

--User_Profile:

--Добавить пользователя:
create or replace procedure InsertUserProfile(
    P_USER_ID in number,
    P_FIRST_NAME in nvarchar2,
    P_LAST_NAME in nvarchar2,
    P_MIDDLE_NAME in nvarchar2,
    P_ADDRESS in nvarchar2,
    P_BIRTH_DATE in date,
    P_EMAIL in nvarchar2,
    P_PASSPORT_NUM in nvarchar2,
    P_PHONE_NUMBER in nvarchar2
) as
begin
insert into User_Profile (
    USER_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS,
    BIRTH_DATE, EMAIL, PASSPORT_NUM, PHONE_NUMBER
) values (
             P_USER_ID, P_FIRST_NAME, P_LAST_NAME, P_MIDDLE_NAME,
             P_ADDRESS, P_BIRTH_DATE, P_EMAIL, P_PASSPORT_NUM, P_PHONE_NUMBER
         );
end;
/

--Обновить профиль пользователя
create or replace procedure UpdateUserProfile(
    P_ID in number,
    P_FIRST_NAME in nvarchar2,
    P_LAST_NAME in nvarchar2,
    P_MIDDLE_NAME in nvarchar2,
    P_ADDRESS in nvarchar2,
    P_BIRTH_DATE in date,
    P_EMAIL in nvarchar2,
    P_PASSPORT_NUM in nvarchar2,
    P_PHONE_NUMBER in nvarchar2
) as
begin
    update User_Profile
    set FIRST_NAME = P_FIRST_NAME,
        LAST_NAME = P_LAST_NAME,
        MIDDLE_NAME = P_MIDDLE_NAME,
        ADDRESS = P_ADDRESS,
        BIRTH_DATE = P_BIRTH_DATE,
        EMAIL = P_EMAIL,
        PASSPORT_NUM = P_PASSPORT_NUM,
        PHONE_NUMBER = P_PHONE_NUMBER
    where ID = P_ID;
end;
/

--Удалить профиль пользователя
CREATE OR REPLACE PROCEDURE DeleteUserProfile(
    P_ID IN NUMBER
) AS
BEGIN
    DELETE FROM User_Profile
    WHERE ID = P_ID;
END;
/

--Вывод всех строк из таблицы User_Profile:
create or replace procedure GetAllUserProfiles(result out sys_refcursor) as
begin
    open result for select * from User_Profile;
end;
/


--User_Support_Request:

--Добавить запрос в службу поддержки
CREATE OR REPLACE PROCEDURE InsertSupportRequest(
    P_TYPE IN NVARCHAR2,
    P_CONTENT IN CLOB,
    P_DATE_TIME IN TIMESTAMP,
    P_ACCOUNT_ID IN NUMBER
) AS
BEGIN
    INSERT INTO User_Support_Request (TYPE, CONTENT, DATE_TIME, ACCOUNT_ID)
    VALUES (P_TYPE, P_CONTENT, P_DATE_TIME, P_ACCOUNT_ID);
END;
/

--Обновить запрос в службу поддержки:
CREATE OR REPLACE PROCEDURE UpdateSupportRequest(
    P_ID IN NUMBER,
    P_TYPE IN NVARCHAR2,
    P_CONTENT IN CLOB,
    P_DATE_TIME IN TIMESTAMP
) AS
BEGIN
    UPDATE User_Support_Request
    SET TYPE = P_TYPE,
        CONTENT = P_CONTENT,
        DATE_TIME = P_DATE_TIME
    WHERE ID = P_ID;
END;
/

--Удалить запрос в службу поддержки:
CREATE OR REPLACE PROCEDURE DeleteSupportRequest(
    P_ID IN NUMBER
) AS
BEGIN
    DELETE FROM User_Support_Request
    WHERE ID = P_ID;
END;
/

--Вывод всех строк из User_Support_Request:
create or replace procedure GetAllSupportRequests(result out sys_refcursor) as
begin
    open result for select * from User_Support_Request;
end;
/


--Currency_Exchange_Rate:

--Добавить курс обмена валют:
CREATE OR REPLACE PROCEDURE InsertCurrencyExchangeRate(
    P_SOURCE_CURR_ID IN NUMBER,
    P_TARGET_CURR_ID IN NUMBER,
    P_RATE IN NUMBER,
    P_RATE_DATE IN DATE
) AS
BEGIN
    INSERT INTO Currency_Exchange_Rate (SOURCE_CURR_ID, TARGET_CURR_ID, RATE, RATE_DATE)
    VALUES (P_SOURCE_CURR_ID, P_TARGET_CURR_ID, P_RATE, P_RATE_DATE);
END;
/

--Обновить курс обмена валют:
CREATE OR REPLACE PROCEDURE UpdateCurrencyExchangeRate(
    P_ID IN NUMBER,
    P_RATE IN NUMBER,
    P_RATE_DATE IN DATE
) AS
BEGIN
    UPDATE Currency_Exchange_Rate
    SET RATE = P_RATE,
        RATE_DATE = P_RATE_DATE
    WHERE ID = P_ID;
END;
/

--Удалить курс обмена валют:
CREATE OR REPLACE PROCEDURE DeleteCurrencyExchangeRate(
    P_ID IN NUMBER
) AS
BEGIN
    DELETE FROM Currency_Exchange_Rate
    WHERE ID = P_ID;
END;
/

--Вывод всех строк из таблицы Currency_Exchange_Rate:
create or replace procedure GetAllCurrencyExchangeRates(result out sys_refcursor) as
begin
    open result for select * from Currency_Exchange_Rate;
end;
/


--Credits:

--Добавить кредит:
CREATE OR REPLACE PROCEDURE InsertCredit(
    P_CREDIT_TYPE_ID IN NUMBER,
    P_ACCOUNT_ID IN NUMBER,
    P_AMOUNT IN NUMBER,
    P_STATUS IN CHAR
) AS
BEGIN
    INSERT INTO Credits (CREDIT_TYPE_ID, ACCOUNT_ID, AMOUNT, STATUS)
    VALUES (P_CREDIT_TYPE_ID, P_ACCOUNT_ID, P_AMOUNT, P_STATUS);
END;
/

--Обновить кредит
CREATE OR REPLACE PROCEDURE UpdateCredit(
    P_ID IN NUMBER,
    P_AMOUNT IN NUMBER,
    P_STATUS IN CHAR
) AS
BEGIN
    UPDATE Credits
    SET AMOUNT = P_AMOUNT,
        STATUS = P_STATUS
    WHERE ID = P_ID;
END;
/

--Удалить кредит
CREATE OR REPLACE PROCEDURE DeleteCredit(
    P_ID IN NUMBER
) AS
BEGIN
    DELETE FROM Credits
    WHERE ID = P_ID;
END;
/

--Вывод всех строк из таблицы Credits
create or replace procedure GetAllCredits(result out sys_refcursor) as
begin
    open result for select * from Credits;
end;
/

--Payment_Service

--Добавить платёжную систему:
CREATE OR REPLACE PROCEDURE InsertPaymentService(
    P_NAME IN NVARCHAR2,
    P_TYPE IN NVARCHAR2,
    P_TRANSACTION_ID IN NUMBER
) AS
BEGIN
    INSERT INTO Payment_Service (NAME, TYPE, TRANSACTION_ID)
    VALUES (P_NAME, P_TYPE, P_TRANSACTION_ID);
END;
/

--Обновить платежную систему:
CREATE OR REPLACE PROCEDURE UpdatePaymentService(
    P_ID IN NUMBER,
    P_NAME IN NVARCHAR2,
    P_TYPE IN NVARCHAR2
) AS
BEGIN
    UPDATE Payment_Service
    SET NAME = P_NAME,
        TYPE = P_TYPE
    WHERE ID = P_ID;
END;
/

--Удалить платежную систему:
CREATE OR REPLACE PROCEDURE DeletePaymentService(
    P_ID IN NUMBER
) AS
BEGIN
    DELETE FROM Payment_Service
    WHERE ID = P_ID;
END;
/

--Вывод всех строк из таблицы Payment_Service:
create or replace procedure GetAllPaymentServices(result out sys_refcursor) as
begin
    open result for select * from Payment_Service;
end;
/

--Credit_Type:

--Вывод всех строк из таблицы Credit_Type:
create or replace procedure GetAllCreditTypes(result out sys_refcursor) as
begin
    open result for select * from Credit_Type;
end;
/

--Account_Transaction:

--Вывод всех строк из таблицы Account_Transaction:
create or replace procedure GetAllTransactions(result out sys_refcursor) as
begin
    open result for select * from Account_Transaction;
end;
/
