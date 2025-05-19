--Последовательность для генерации уникальных значений
create sequence SEQ_ACCOUNT_ID start with 1 increment by 1 nocache;

--Последовательность для транзакций
CREATE sequence SEQ_TRANSACTION_ID start with 1 increment by 1 nocache;

--Последовательность для валют
create sequence SEQ_CURRENCY_ID start with 1 increment by 1 nocache;

--Последовательность для типов кредитов
create sequence SEQ_CREDIT_TYPE_ID start with 1 increment by 1 nocache;

--Последовательность для поддержки запросов
create sequence SEQ_SUPPORT_REQUEST_ID start with 1 increment by 1 nocache;

--Последовательность для кредитов
CREATE sequence SEQ_CREDITS_ID start with 1 increment by 1 nocache;

--Последовательность для карт
CREATE sequence SEQ_CARD_ID start with 1 increment by 1 nocache;

DROP SEQUENCE SEQ_ACCOUNT_ID;
DROP SEQUENCE SEQ_TRANSACTION_ID;
DROP SEQUENCE SEQ_CURRENCY_ID;
DROP SEQUENCE SEQ_CREDIT_TYPE_ID;
DROP SEQUENCE SEQ_SUPPORT_REQUEST_ID;
DROP SEQUENCE SEQ_CREDITS_ID;
DROP SEQUENCE SEQ_CARD_ID;