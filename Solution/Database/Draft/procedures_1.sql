------------------------------Общие процедуры для администраторов и сотрудников банка:------------------------------

-- Получить список всех валют и их курс обмена
create or replace procedure GetAllCurrencies is
begin
    select * from Currency;
end;
/

-- Получить список всех клиентов и информацию о них
create or replace procedure GetAllClientInfos is
begin
    select u.ID, u.LOGIN, p.FIRST_NAME, p.LAST_NAME, p.EMAIL
    from App_User u
    left outer join User_Profile p on u.ID = p.USER_ID;
end;
/

-- Получить все счета клиентов
create or replace procedure GetAllClientsAccounts is
begin
    select * from User_Account;
end;
/

-- Получить информацию о профиле пользователя
create or replace procedure GetClientProfileInfo(p_UserId in number) is
begin
    select * from User_Profile where USER_ID = p_UserId;
end;
/

-- Получить все запросы в службу поддержки за определённый период
create or replace procedure GetAllClientSupportRequests(p_StartDate in date, p_EndDate in date) is
begin
    select * from User_Support_Request
    where DATE_TIME between p_StartDate and p_EndDate;
end;
/

-- Получить список всех банковских карт клиента
create or replace procedure GetAllClientCards(p_UserId in number) is
begin
    select c.* 
    from Card c
    join User_Account a on c.ACCOUNT_ID = a.ID
    where a.USER_ID = p_UserId;
end;
/

-- Получить все типы кредитов
create or replace procedure GetAllCreditTypes is
begin
    select * from Credit_Type;
end;
/

-- Получить все кредиты
create or replace procedure GetAllCredits is
begin
    select * from Credits;
end;
/

------------------------------Общие процедуры для пользователей (сотрудников банка):------------------------------

-- Получить информацию о клиенте по идентификатору
create or replace procedure GetClientInfoById(p_ClientId in number) is
begin
    select * from App_User where ID = p_ClientId;
end;
/

-- Получить информацию о счёте клиента по  идентификатору клиента
create or replace procedure GetClientAccountById(p_AccountId in number) is
begin
    select * from User_Account where ID = p_AccountId;
end;
/
-- Получить информацию о кредитах клиента по идентификатору клиента
create or replace procedure GetClientCreditsById(p_ClientId in number) is
begin
    seelct cr.* 
    from Credits cr
    join User_Account ua on cr.ACCOUNT_ID = ua.ID
    where ua.USER_ID = p_ClientId;
end;
/
-- Получить информацию о всех банковских картах клиента
create or replace procedure GetClientAllCards(p_ClientId in number) is
begin
    select c.* 
    from Card c
    join User_Account ua on c.ACCOUNT_ID = ua.ID
    where ua.USER_ID = p_ClientId;
end;
/

-- Добавить новую транзакцию клиенту
create or replace procedure AddClientTransaction(
    p_AccountIdFrom in number,
    p_AccountIdTo in number,
    p_Amount in number
) is
begin
    insert into Account_Transaction (ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME)
    values (p_AccountIdFrom, p_AccountIdTo, p_Amount, SYSTIMESTAMP);
end;
/
-- Изменить статус банковской карты клиента (заблокирована / доступна)
create or replace procedure UpdateClientCardStatus(p_CardId in number, p_Status in nvarchar2) is
begin
    update Card
    set STATUS = p_Status
    where ID = p_CardId;
end;
/

------------------------------Общие процедуры для администраторов (разработчиков бд):------------------------------

--Получить информацию о транзакции по её идентификатору
create or replace procedure GetTransactionById(p_TransactionId in number) is
begin
    select * 
    from Account_Transaction 
    where ID = p_TransactionId;
end;
/
--Получить информацию о банковской карте по её идентификатору
create or replace procedure GetCardById(p_CardId in number) is
begin
    select * 
    from Card 
    where ID = p_CardId;
end;
/
--Получить тип кредита по его идентификатору
create or replace procedure GetCreditTypeById(p_CreditTypeId in number) is
begin
    select * 
    from Credit_Type 
    where ID = p_CreditTypeId;
end;
/
--Добавить тип кредита
create or replace procedure AddCreditType(
    p_Type in nvarchar2,
    p_CreditName in nvarchar2,
    p_Description in nvarchar2
) is
begin
    insert into Credit_Type (type, CREDIT_NAME, description)
    values (p_Type, p_CreditName, p_Description);
end;
/
--Изменить тип кредита
create or replace procedure UpdateCreditType(
    p_CreditTypeId in number,
    p_Type in nvarchar2,
    p_CreditName in nvarchar2,
    p_Description in nvarchar2
) is
begin
    update Credit_Type
    set type = p_Type,
        CREDIT_NAME = p_CreditName,
        description = p_Description
    where ID = p_CreditTypeId;
end;
/
--Удалить тип кредита
create or replace procedure DeleteCreditType(p_CreditTypeId in number) is
begin
    delete from Credit_Type 
    where ID = p_CreditTypeId;
end;
/
--Добавить новую валюту
create or replace procedure AddCurrency(
    p_Name in varchar2,
    p_Code in varchar2
) is
begin
    insert into Currency (NAME, CODE)
    values (p_Name, p_Code);
end;
/
--Изменить информацию о валюте 
create or replace procedure UpdateCurrency(
    p_CurrencyId in number,
    p_Name in varchar2,
    p_Code in varchar2
) is
begin
    update Currency
    set name = p_Name,
        CODE = p_Code
    where ID = p_CurrencyId;
end;
/

------------------------------Общие процедуры для клиентов:------------------------------

--Получить текущий баланс счета клиента
create or replace procedure CheckAccountBalance(p_AccountId in number) is
begin
    select AMOUNT from User_Account where ID = p_AccountId;
end;
/
--Получить историю всех транзакций клиента за указанный период
create or replace procedure GetTransactionHistory(p_AccountId in number, p_StartDate in date, p_EndDate in date) is
begin
    select * from Account_Transaction
    where ACCOUNT_ID_FROM = p_AccountId 
      and DATE_TIME between p_StartDate and p_EndDate;
end;
/
--Создать запрос в службу поддержки с указанием темы и содержимого
create or replace procedure RequestSupport(
    p_AccountId in number,
    p_Type in nvarchar2,
    p_Content in clob
) is
begin
    insert into User_Support_Request (ACCOUNT_ID, type, content, DATE_TIME)
    values (p_AccountId, p_Type, p_Content, systimestamp);
end;
/
--Подать заявку на кредит с указанием суммы и типа кредита
create or replace procedure ApplyForCredit(
    p_AccountId in number,
    p_CreditTypeId in number,
    p_Amount in number
) is
begin
    insert into Credits (ACCOUNT_ID, CREDIT_TYPE_ID, AMOUNT)
    values (p_AccountId, p_CreditTypeId, p_Amount);
end;
/

--Обменять средства с одного счета клиента на другой с использованием указанного курса обмена
create or replace procedure ExchangeCurrency(
    p_SourceAccountId in number,
    p_TargetAccountId in number,
    p_Amount in number,
    p_Rate in number
) is
begin
    update User_Account
    set AMOUNT = AMOUNT - p_Amount
    where ID = p_SourceAccountId;
    
    update User_Account
    set AMOUNT = AMOUNT + (p_Amount * p_Rate)
    where ID = p_TargetAccountId;
end;
/


