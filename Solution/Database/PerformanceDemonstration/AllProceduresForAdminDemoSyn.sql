------------------------------------------------------------
-- ДЕМОНСТРАЦИЯ РАБОТОСПОСОБНОСТИ ПРОЦЕДУР АДМИНИСТРАТОРА -- 
------------------------------------------------------------

ALTER PLUGGABLE DATABASE BANK_APP_PDB OPEN;
ALTER SESSION SET CONTAINER = BANK_APP_PDB;

-- • управление пользователями (добавление, удаление, изменение, чтение) (ТЗ):

-- Удалить профиль клиента вместе с его аккаунтом (DeleteClientProfile) 
DECLARE 
    v_user_id NUMBER := 118; 
BEGIN 
    DeleteClientProfile_Syn(v_user_id); 
END;

-- Получить информацию о профиле пользователя (GetClientProfileInfo)
DECLARE
    v_user_id NUMBER := 1;
BEGIN
    GetClientProfileInfo_Syn(v_user_id);
END;

-- Получить список всех клиентов и информацию о них (GetAllClientInfos)
BEGIN
    GetAllClientInfos_Syn;
END;

-- • управление пользовательскими счетами (добавление, удаление, чтение) (ТЗ):

-- Добавить счет клиенту (AddAccountToClient)
DECLARE
    v_user_id NUMBER := 10;          
    v_currency_id NUMBER := 3;      
    v_amount NUMBER := 0;         
BEGIN
    AddAccountToClient_Syn(P_USER_ID => v_user_id, P_CURRENCY_ID => v_currency_id, P_AMOUNT => v_amount);
END;

-- Закрыть счет клиенту (CloseClientAccount)
DECLARE 
    v_account_id NUMBER := 832; 
    v_login NVARCHAR2(255) := 'user5'; 
BEGIN 
    CloseClientAccount_Syn(P_ACCOUNT_ID => v_account_id, P_LOGIN => v_login); 
END;

-- Просмотреть все счета клиента по его идентификатору (GetListOfClientAccountsByClientId)
DECLARE 
    v_client_id NUMBER := 8; 
BEGIN 
    GetListOfClientAccountsByClientId_Syn(v_client_id); 
END;

-- • управление оформленными кредитами (ТЗ):

-- Просмотреть информацию о типах кредитов (GetAllCreditTypes)
BEGIN
    GetAllCreditTypes_Syn;
END;

-- Получить информацию о кредитах клиента по идентификатору клиента (GetClientLoansById)
BEGIN 
    GetClientLoansById_Syn(
        P_CLIENT_ID => 2
    ); 
END;

-- Добавить тип кредита (AddLoanType)
DECLARE
    v_type        NVARCHAR2(100) := 'TEST';  
    v_credit_name NVARCHAR2(100) := 'New test credit'; 
    v_description NVARCHAR2(255) := 'A new credit for testing'; 
BEGIN
    AddLoanType_Syn(
        P_TYPE => v_type,
        P_CREDIT_NAME => v_credit_name,
        P_DESCRIPTION => v_description
    );
END;

-- Изменить тип кредита (UpdateLoanType)
DECLARE
    v_credit_type_id NUMBER := 35;          
    v_type NVARCHAR2(50) := 'SUPERTYPE'; 
    v_credit_name NVARCHAR2(100) := 'SUPERCREDIT'; 
    v_description NVARCHAR2(255) := 'SUPERCREDIT FOR COOL GUYS';
BEGIN
    UpdateLoanType_Syn(
        P_CREDIT_TYPE_ID => v_credit_type_id,
        P_TYPE => v_type,
        P_CREDIT_NAME => v_credit_name,
        P_DESCRIPTION => v_description
    );
END;

-- Удалить тип кредита (DeleteLoanType)
DECLARE
    v_credit_type_id NUMBER := 15; 
BEGIN
    DeleteLoanType_Syn(
        P_CREDIT_TYPE_ID => v_credit_type_id
    );
END;

-- Одобрить или отклонить заявку на получение кредита (ProcessLoanApplication)

-- Одобрить
DECLARE 
    v_loan_id NUMBER := 140; 
    v_status nvarchar2(8) := 'Active'; 
    v_payment_amount NUMBER; 
    v_issued_date DATE; 
    v_maturity_date DATE; 
    v_payment_day NUMBER := 15; 
BEGIN 
    ProcessLoanApplication_Syn(
        P_LOAN_ID => v_loan_id, 
        P_STATUS => v_status, 
        P_INTEREST_RATE => 5, 
        P_ISSUED_DATE => v_issued_date, 
        P_MATURITY_DATE => v_maturity_date,
        P_PAYMENT_FREQUENCY => 'Once a month', 
        P_PAYMENT_AMOUNT => v_payment_amount,
        P_PAYMENT_DAY => v_payment_day
    ); 
END;

-- Отклонить
DECLARE 
    v_loan_id NUMBER := 141; 
    v_status NVARCHAR2(8) := 'Canceled'; 
    v_payment_amount NUMBER; 
    v_issued_date DATE; 
    v_maturity_date DATE; 
BEGIN 
    ProcessLoanApplication_Syn(
        P_LOAN_ID => v_loan_id, 
        P_STATUS => v_status, 
        P_INTEREST_RATE => NULL,  
        P_ISSUED_DATE => v_issued_date, 
        P_MATURITY_DATE => v_maturity_date, 
        P_PAYMENT_FREQUENCY => NULL,
        P_PAYMENT_AMOUNT => v_payment_amount
    ); 
END;

-- Получить список всех заявок на кредиты (GetLoanApplications) 
BEGIN
    GetLoanApplications_Syn; 
END;

-- Получение данных о всех кредитах (GetAllCredits)
BEGIN
    GetAllCredits_Syn;
END;

-- • управление банковскими карточками (ТЗ):

-- Получить информацию о банковской карте по её идентификатору (GetCardById)
DECLARE
    v_card_id NUMBER := 1; 
BEGIN
    GetCardById_Syn(v_card_id);
END;

-- Получить информацию о всех банковских картах клиента (GetAllClientCardsById)
BEGIN 
    GetAllClientCardsById_Syn(P_CLIENT_ID => 1);
END;

-- Изменить статус банковской карты по ее идентификатору (заблокирована / доступна) (UpdateClientCardStatus)
DECLARE 
    v_card_id NUMBER := 1;  
    v_status NVARCHAR2(50) := 'Active'; 
BEGIN 
    UpdateClientCardStatus_Syn(v_card_id, v_status); 
END;

-- Добавить банковскую карту
BEGIN
    AddBankCard_Syn(
        P_ACCOUNT_ID => 1,
        P_PAYMENT_SERVICE => 1,  -- Укажите корректный ID платежной службы
        P_CARD_NAME => 'Personal test Card',
        P_CARD_NUMBER => 1234567890123422,
        P_DESCRIPTION => 'TESTCARD',
        P_STATUS => 'Active'
    );
END;

-- Удалить банковскую карту
BEGIN
    DeleteBankCard(P_CARD_ID => 52);
END;

-- • Осуществление платежей (ТЗ):

-- Получить информацию о транзакции по её идентификатору (GetTransactionById)
DECLARE
    v_transaction_id NUMBER := 1; 
    v_id NUMBER;
    v_account_id_from NUMBER;
    v_account_id_to NUMBER;
    v_amount NUMBER;
    v_date_time TIMESTAMP;
    v_currency_name VARCHAR2(100);
    v_currency_code VARCHAR2(3);
BEGIN
    GetTransactionById_Syn(v_transaction_id, v_id, v_account_id_from, v_account_id_to, v_amount, v_date_time, v_currency_name, v_currency_code);
END;

-- Получение данных о платежных сервисах
BEGIN
    GetAllPaymentServices_Syn;
END;


-- • Операции с валютами (дополнение к ТЗ):

-- Вывод курса обмена валют (GetListCurrenciesAndExchangeRates)
BEGIN
    GetListCurrenciesAndExchangeRates_Syn;
END;

--Вывод списка валют 
BEGIN
    GetAllCurrencies_Syn;
END;

--Добавить курс обмена для любой валюты (кроме доллара США)
BEGIN
    AddCurrencyExchangeRate_Syn(2, 75.5, 78.0);
END;

-- Изменить информацию о валюте (UpdateCurrencyInfo)

-- 1 Indian Rupee - INR
-- 1 British Columbia Dollar - BCD

DECLARE
    v_currency_id NUMBER := 1; 
    v_name VARCHAR2(100) := 'British Columbia Dollar'; --Indian Rupee
    v_code VARCHAR2(3) := 'BCD'; --INR
    v_buy NUMBER := 16.09;  --74.00
    v_sale NUMBER := 16.3;  --75.00
BEGIN
    UpdateCurrencyInfo_Syn(
        P_CURRENCY_ID => v_currency_id,
        P_NAME => v_name,
        P_CODE => v_code,
        P_BUY => v_buy,
        P_SALE => v_sale
    );
END;

-- • Служба поддержки (дополнение к ТЗ):

-- Получить все запросы в службу поддержки, проведенные клиентом за определенный период времени (GetAllClientSupportRequests)
DECLARE
    v_user_id NUMBER := 1;
    v_start_date DATE := TO_TIMESTAMP('2024-12-16 23:00:00', 'YYYY-MM-DD HH24:MI:SS');
    v_end_date DATE := TO_TIMESTAMP('2024-12-25 16:54:50', 'YYYY-MM-DD HH24:MI:SS');
BEGIN
    GetAllClientSupportRequests_Syn(
        P_USER_ID => v_user_id,
        P_START_DATE => v_start_date,
        P_END_DATE => v_end_date
    );
END;

-- Вывод запросов в техподдержку 
BEGIN
    GetAllUserSupportRequests_Syn;
END;

-- • Импорт/экспорт данных:

-- Экспорт данных в admin_user.Currency
BEGIN
    ExportCurrencyToJSON_Syn('JSON_FILES'); 
END;

-- Импорт данных из admin_user.Currency
BEGIN
    ImportCurrencyFromJSON_Syn;
END;

-- Экспорт данных в admin_user.PaymentService
BEGIN
    ExportPaymentServiceToJSON_Syn('JSON_FILES'); 
END;

-- Импорт данных из admin_user.PaymentService
BEGIN
    ImportPaymentServiceFromJSON_Syn;
END;

-- Экспорт данных в admin_user.Credit_Type
BEGIN
    ExportCreditTypeToJSON_Syn('JSON_FILES'); 
END;

-- Импорт данных из admin_user.Credit_Type
BEGIN
    ImportCreditTypeFromJSON_Syn;
END; 

-- Экспорт данных в admin_user.Currency_Exchange_Rate
BEGIN
    ExportCurrencyExchangeRateToJSON_Syn('JSON_FILES'); 
END;

-- Импорт данных из admin_user.Currency_Exchange_Rate
BEGIN
    ImportCurrencyExchangeRateFromJSON_Syn;
END;