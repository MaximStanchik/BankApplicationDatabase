------------------------------����� ��������� ��� ��������������� � ����������� �����:------------------------------

-- �������� ������ ���� ����� � �� ���� ������
create or replace procedure GetAllCurrencies is
begin
    select * from Currency;
end;
/

-- �������� ������ ���� �������� � ���������� � ���
create or replace procedure GetAllClientInfos is
begin
    select u.ID, u.LOGIN, p.FIRST_NAME, p.LAST_NAME, p.EMAIL
    from App_User u
    left outer join User_Profile p on u.ID = p.USER_ID;
end;
/

-- �������� ��� ����� ��������
create or replace procedure GetAllClientsAccounts is
begin
    select * from User_Account;
end;
/

-- �������� ���������� � ������� ������������
create or replace procedure GetClientProfileInfo(p_UserId in number) is
begin
    select * from User_Profile where USER_ID = p_UserId;
end;
/

-- �������� ��� ������� � ������ ��������� �� ����������� ������
create or replace procedure GetAllClientSupportRequests(p_StartDate in date, p_EndDate in date) is
begin
    select * from User_Support_Request
    where DATE_TIME between p_StartDate and p_EndDate;
end;
/

-- �������� ������ ���� ���������� ���� �������
create or replace procedure GetAllClientCards(p_UserId in number) is
begin
    select c.* 
    from Card c
    join User_Account a on c.ACCOUNT_ID = a.ID
    where a.USER_ID = p_UserId;
end;
/

-- �������� ��� ���� ��������
create or replace procedure GetAllCreditTypes is
begin
    select * from Credit_Type;
end;
/

-- �������� ��� �������
create or replace procedure GetAllCredits is
begin
    select * from Credits;
end;
/

------------------------------����� ��������� ��� ������������� (����������� �����):------------------------------

-- �������� ���������� � ������� �� ��������������
create or replace procedure GetClientInfoById(p_ClientId in number) is
begin
    select * from App_User where ID = p_ClientId;
end;
/

-- �������� ���������� � ����� ������� ��  �������������� �������
create or replace procedure GetClientAccountById(p_AccountId in number) is
begin
    select * from User_Account where ID = p_AccountId;
end;
/
-- �������� ���������� � �������� ������� �� �������������� �������
create or replace procedure GetClientCreditsById(p_ClientId in number) is
begin
    seelct cr.* 
    from Credits cr
    join User_Account ua on cr.ACCOUNT_ID = ua.ID
    where ua.USER_ID = p_ClientId;
end;
/
-- �������� ���������� � ���� ���������� ������ �������
create or replace procedure GetClientAllCards(p_ClientId in number) is
begin
    select c.* 
    from Card c
    join User_Account ua on c.ACCOUNT_ID = ua.ID
    where ua.USER_ID = p_ClientId;
end;
/

-- �������� ����� ���������� �������
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
-- �������� ������ ���������� ����� ������� (������������� / ��������)
create or replace procedure UpdateClientCardStatus(p_CardId in number, p_Status in nvarchar2) is
begin
    update Card
    set STATUS = p_Status
    where ID = p_CardId;
end;
/

------------------------------����� ��������� ��� ��������������� (������������� ��):------------------------------

--�������� ���������� � ���������� �� � ��������������
create or replace procedure GetTransactionById(p_TransactionId in number) is
begin
    select * 
    from Account_Transaction 
    where ID = p_TransactionId;
end;
/
--�������� ���������� � ���������� ����� �� � ��������������
create or replace procedure GetCardById(p_CardId in number) is
begin
    select * 
    from Card 
    where ID = p_CardId;
end;
/
--�������� ��� ������� �� ��� ��������������
create or replace procedure GetCreditTypeById(p_CreditTypeId in number) is
begin
    select * 
    from Credit_Type 
    where ID = p_CreditTypeId;
end;
/
--�������� ��� �������
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
--�������� ��� �������
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
--������� ��� �������
create or replace procedure DeleteCreditType(p_CreditTypeId in number) is
begin
    delete from Credit_Type 
    where ID = p_CreditTypeId;
end;
/
--�������� ����� ������
create or replace procedure AddCurrency(
    p_Name in varchar2,
    p_Code in varchar2
) is
begin
    insert into Currency (NAME, CODE)
    values (p_Name, p_Code);
end;
/
--�������� ���������� � ������ 
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

------------------------------����� ��������� ��� ��������:------------------------------

--�������� ������� ������ ����� �������
create or replace procedure CheckAccountBalance(p_AccountId in number) is
begin
    select AMOUNT from User_Account where ID = p_AccountId;
end;
/
--�������� ������� ���� ���������� ������� �� ��������� ������
create or replace procedure GetTransactionHistory(p_AccountId in number, p_StartDate in date, p_EndDate in date) is
begin
    select * from Account_Transaction
    where ACCOUNT_ID_FROM = p_AccountId 
      and DATE_TIME between p_StartDate and p_EndDate;
end;
/
--������� ������ � ������ ��������� � ��������� ���� � �����������
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
--������ ������ �� ������ � ��������� ����� � ���� �������
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

--�������� �������� � ������ ����� ������� �� ������ � �������������� ���������� ����� ������
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


