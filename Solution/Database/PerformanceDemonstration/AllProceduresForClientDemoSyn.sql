-----------------------------------------------------
-- ДЕМОНСТРАЦИЯ РАБОТОСПОСОБНОСТИ ПРОЦЕДУР КЛИЕНТА -- 
-----------------------------------------------------

ALTER PLUGGABLE DATABASE BANK_APP_PDB OPEN;
ALTER SESSION SET CONTAINER = BANK_APP_PDB;

-- • управление пользователями (добавление, удаление, изменение, чтение) (ТЗ):

-- Регистрация клиента (RegisterClient) 
BEGIN
   RegisterClient_Syn(
      P_LOGIN        => 'user_testing_7',
      P_PASSWORD     => 'pasWD213123',
      P_EMAIL        => 'user_testing_7@example.com',
      P_FIRST_NAME   => 'Maxim',
      P_LAST_NAME    => 'Stanchik',
      P_MIDDLE_NAME  => '',
      P_ADDRESS      => '123 Test Street',
      P_BIRTH_DATE   => TO_DATE('1990-01-01', 'YYYY-MM-DD'),
      P_PHONE_NUMBER => '1234567890',
      P_PASSPORT_NUM => '123456789'
   );
END;

-- Авторизация клиента (LoginClient) 
DECLARE
    v_is_success NUMBER;
BEGIN
    LoginClient_Syn(
        P_LOGIN => 'user_testing_7',
        P_PASSWORD => 'pasWD213123',
        P_IS_SUCCESS => v_is_success
    );
END;

-- Удалить профиль клиента вместе с его аккаунтом (DeleteClientProfile) 
DECLARE 
    v_user_id NUMBER := 116; 
BEGIN 
    DeleteClientProfile_Syn(v_user_id); 
END;

-- Получить информацию о профиле пользователя (GetClientProfileInfo)
DECLARE
    v_user_id NUMBER := 1.2;
BEGIN
    GetClientProfileInfo_Syn(v_user_id);
END;

-- • Управление пользовательскими счетами (добавление, удаление, чтение) (ТЗ):

-- Просмотреть все счета клиента по его идентификатору (GetListOfClientAccountsByClientId)
DECLARE 
    v_client_id NUMBER := 8; 
BEGIN 
    GetListOfClientAccountsByClientId_Syn(v_client_id); 
END;

-- Перевести средства с одного счета клиента на другой счет (TransferFunds) 
DECLARE
    v_account_id_from NUMBER := 498;
    v_account_id_to NUMBER := 22;
    v_amount NUMBER := 1000;
BEGIN
    TransferFunds_Syn(v_account_id_from, v_account_id_to, v_amount);
END;

-- Перевести счет в доллары США
BEGIN
    TransferFundsToUSD_Syn(P_ACCOUNT_ID => 12872);
END;

-- Перевести счет в другую валюту (кроме доллара США)
BEGIN
    ConvertFromUSD_Syn(P_ACCOUNT_ID => 12872, P_TARGET_CURRENCY_ID => 2); 
END;

-- Получить текущий баланс счета
DECLARE 
    v_balance NUMBER; 
    v_currency VARCHAR2(4); 
BEGIN 
    GetAccountBalance_Syn( 
        P_USER_ID => 4, 
        P_ACCOUNT_NUMBER => 'ACC460', 
        P_BALANCE => v_balance, 
        P_CURRENCY => v_currency 
    ); 
END;

-- Вывод курса обмена валют (GetListCurrenciesAndExchangeRates)
BEGIN
    GetListCurrenciesAndExchangeRates_Syn;
END;

-- • Осуществление платежей (ТЗ):

-- Получить историю всех транзакций клиента за указанный период времени (GetTransactionHistory) 
BEGIN
    GetTransactionHistory_Syn(
        P_CLIENT_ID => 8,
        P_START_DATE => TO_DATE('2024-12-19', 'YYYY-MM-DD'),
        P_END_DATE => TO_DATE('2024-12-30', 'YYYY-MM-DD')
    );
END;

-- • Управление оформленными кредитами (ТЗ):

-- Подать заявку на кредит (SubmitLoanApplication)
BEGIN
    SubmitLoanApplication_Syn(
        P_CLIENT_ID => 2,
        P_AMOUNT => 1000,
        P_CREDIT_TYPE_ID => 2,
        P_CURRENCY_ID => 4,
        P_ACCOUNT_ID => 474,  
        P_LOAN_PURPOSE => 'Home renovation',
        P_LOAN_TERM => 5
    );
END;

-- Просмотреть информацию о типах кредитов (GetAllCreditTypes)
BEGIN
    GetAllCreditTypes_Syn;
END;

--Оплатить кредит
BEGIN
    PayCredit_Syn(
        p_credit_id => 113,
        p_account_id => 101,
        p_payment_amount => 1000
    );
END;

-- • Служба поддержки (дополнение к ТЗ):

-- Создать запрос в службу поддержки с указанием темы и содержимого (CreateSupportRequest) 
BEGIN
    CreateSupportRequest_Syn(
        P_CLIENT_ID => 1,
        P_CONTENT => 'I need help with my account.'
    );
END;

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
