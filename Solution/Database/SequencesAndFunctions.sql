alter session set container = BANK_APP_PDB;

SELECT NAME, OPEN_MODE FROM V$DATABASE;

--Последовательность для генерации уникальных номеров счетов
create sequence SEQ_ACCOUNT_NUMBER start with 1000000000000000 increment by 1;

--Функция для генерации номера счета, которое дополнительно форматируется до 16 символов с ведущими нулями.
create or replace function GENERATE_ACCOUNT_NUMBER
return nvarchar2 is account_number nvarchar2(16);
begin
  select to_char(SEQ_ACCOUNT_NUMBER.NEXTVAL) into account_number from dual;
  return account_number;
end;

SELECT * 
FROM user_errors 
WHERE name = ' ISACCOUNTOWNEDBYUSER' AND type = 'FUNCTION';

--Последовательность для поддержки запросов
create sequence SEQ_SUPPORT_REQUEST_ID start with 1 increment by 1 nocache;

--Последовательность для кредитов
CREATE sequence SEQ_CREDITS_ID start with 1 increment by 1 nocache;

--Последовательность для транзакций
CREATE sequence SEQ_TRANSACTION_ID start with 1 increment by 1 nocache;

--Последовательность для карт
CREATE sequence SEQ_CARD_ID start with 1 increment by 1 nocache;

--Последовательность для типов кредитов
create sequence SEQ_CREDIT_TYPE_ID start with 1 increment by 1 nocache;

--Последовательность для валют
create sequence SEQ_CURRENCY_ID start with 1 increment by 1 nocache;

--Последовательность для генерации уникальных значений
create sequence SEQ_ACCOUNT_ID start with 1 increment by 1 nocache;

SELECT *
FROM USER_DEPENDENCIES
WHERE REFERENCED_NAME IN (
    'SEQ_SUPPORT_REQUEST_ID',
    'SEQ_CREDITS_ID',
    'SEQ_TRANSACTION_ID',
    'SEQ_CARD_ID',
    'SEQ_CREDIT_TYPE_ID',
    'SEQ_CURRENCY_ID',
    'SEQ_ACCOUNT_ID'
);





