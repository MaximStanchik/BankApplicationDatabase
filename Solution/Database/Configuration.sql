alter pluggable database XEPDB1 close;
alter pluggable database XEPDB1 open read only;

create pluggable database BANK_APP_PDB
  admin user admin identified by test1111
  roles = (dba)
  file_name_convert = (
      '/opt/oracle/oradata/XE/pdbseed',  
      '/opt/oracle/oradata/XE/BANK_APP_PDB'
  );
SELECT pdb_name, status FROM cdb_pdbs;

alter pluggable database BANK_APP_PDB open;

SELECT NAME, OPEN_MODE FROM V$PDBS; 

create bigfile tablespace users_tbs 
datafile 'users_tbs' size 100m autoextend on maxsize unlimited;

create temporary tablespace temp_tbs
tempfile 'temp_tbs' size 100m autoextend on maxsize unlimited;

alter session set "_ORACLE_SCRIPT" = true;

ALTER SESSION SET CONTAINER = BANK_APP_PDB;
ALTER SESSION SET CONTAINER = CDB$ROOT;

SELECT * FROM USER_ACCOUNT;

create profile user_profile limit
  failed_login_attempts 5 
  sessions_per_user   10
  cpu_per_session     unlimited 
  cpu_per_call        3000 
  connect_time        45 
  idle_time           15 
  logical_reads_per_session default 
  logical_reads_per_call    default 
  private_sga        15k
  composite_limit    5000000; 

create profile admin_profile limit 
  sessions_per_user   unlimited 
  cpu_per_session     unlimited 
  cpu_per_call        unlimited 
  connect_time        unlimited 
  idle_time           unlimited 
  logical_reads_per_session default 
  logical_reads_per_call    default 
  private_sga        unlimited 
  composite_limit    unlimited; 
  
create role user_role;
create role admin_role; 

create user admin_user identified by admin_password
    default tablespace users_tbs
    temporary tablespace temp_tbs
    profile admin_profile;

grant connect, resource, dba, admin_role to admin_user;

create user user_user identified by user_password
    default tablespace users_tbs
    temporary tablespace TEMP_TBS
    profile user_profile;
    
grant connect, resource, user_role to user_user;

ALTER SESSION SET CONTAINER = BANK_APP_PDB;
ALTER SESSION SET CONTAINER = CDB$ROOT;

SELECT username FROM dba_users WHERE username = 'USER_USER';

grant execute on GetTransactionHistory to user_user;
grant execute on CreateSupportRequest to user_user;
grant execute on SubmitLoanApplication to user_user;
grant execute on TransferFunds to user_user;
grant execute on AutoTransferFunds to user_user;
grant execute on RegisterClient to user_user;
grant execute on LoginClient to user_user;
grant execute on DeleteBankCard to user_user;
grant execute on GetAllCurrencies to user_user;
grant execute on GetClientProfileInfo to user_user;
grant execute on GetAllClientSupportRequests to user_user;
grant execute on GetAllCreditTypes to user_user;
grant execute on GetListOfClientAccountsByClientId to user_user;
grant execute on DeleteClientProfile to user_user;
grant execute on GetAccountBalance to user_user;
grant execute on GetListCurrenciesAndExchangeRates to user_user;
grant execute on PayCredit to user_user;
grant execute ON TransferFundsToUSD to user_user; 
grant execute ON ConvertFromUSD to user_user; 

CREATE OR REPLACE SYNONYM user_user.GetAccountBalance_Syn FOR GetAccountBalance;
CREATE OR REPLACE SYNONYM user_user.GetTransactionHistory_Syn FOR GetTransactionHistory;
CREATE OR REPLACE SYNONYM user_user.CreateSupportRequest_Syn FOR CreateSupportRequest;
CREATE OR REPLACE SYNONYM user_user.SubmitLoanApplication_Syn FOR SubmitLoanApplication;
CREATE OR REPLACE SYNONYM user_user.TransferFunds_Syn FOR TransferFunds;
CREATE OR REPLACE SYNONYM user_user.AutoTransferFunds_Syn FOR AutoTransferFunds;
CREATE OR REPLACE SYNONYM user_user.RegisterClient_Syn FOR RegisterClient;
CREATE OR REPLACE SYNONYM user_user.LoginClient_Syn FOR LoginClient;
CREATE OR REPLACE SYNONYM user_user.DeleteBankCard_Syn FOR DeleteBankCard;
CREATE OR REPLACE SYNONYM user_user.GetAllCurrencies_Syn FOR GetAllCurrencies;
CREATE OR REPLACE SYNONYM user_user.GetClientProfileInfo_Syn FOR GetClientProfileInfo;
CREATE OR REPLACE SYNONYM user_user.GetAllClientSupportRequests_Syn FOR GetAllClientSupportRequests;
CREATE OR REPLACE SYNONYM user_user.GetAllCreditTypes_Syn FOR GetAllCreditTypes;
CREATE OR REPLACE SYNONYM user_user.GetListOfClientAccountsByClientId_Syn FOR GetListOfClientAccountsByClientId;
CREATE OR REPLACE SYNONYM user_user.DeleteClientProfile_Syn FOR DeleteClientProfile;
CREATE OR REPLACE SYNONYM user_user.GetListCurrenciesAndExchangeRates_Syn FOR GetListCurrenciesAndExchangeRates;
CREATE OR REPLACE SYNONYM user_user.PayCredit_Syn FOR PayCredit;
CREATE OR REPLACE SYNONYM user_user.TransferFundsToUSD_Syn FOR TransferFundsToUSD;
CREATE OR REPLACE SYNONYM user_user. ConvertFromUSD_Syn FOR ConvertFromUSD;

select * from user_tab_privs where grantee = 'USER_USER';

grant execute on GetTransactionById to admin_user;
grant execute on GetCardById to admin_user;
grant execute on AddLoanType to admin_user;
grant execute on UpdateLoanType to admin_user;
grant execute on DeleteLoanType to admin_user;
grant execute on AddNewCurrency to admin_user;
grant execute on UpdateCurrencyInfo to admin_user;
grant execute on GetClientInfoById to admin_user;
grant execute on GetClientAccountById to admin_user;
grant execute on GetClientLoansById to admin_user;
grant execute on GetAllClientCardsById to admin_user;
grant execute on UpdateClientCardStatus to admin_user;
grant execute on GetAllClientsAccounts to admin_user;
grant execute on GetAllClientInfos to admin_user;
grant execute on GetAllClientCards to admin_user;
grant execute on ProcessLoanApplication to admin_user;
grant execute on GetLoanApplications to admin_user;
grant execute on AddAccountToClient to admin_user;
grant execute on CloseClientAccount to admin_user;
grant execute on GetClientProfileInfo to admin_user;
grant execute on GetAllClientSupportRequests to admin_user;
grant execute on GetAllCreditTypes to admin_user;
grant execute on GetListOfClientAccountsByClientId to admin_user;
grant execute on DeleteClientProfile to admin_user;
grant execute ON AddBankCard to admin_user;
grant execute ON DeleteBankCard to admin_user;
grant execute ON GetListCurrenciesAndExchangeRates to admin_user;
grant execute ON AddCurrencyExchangeRate to admin_user;

grant execute on GetAllCurrencies to admin_user;
grant execute on GetAllAppUsers to admin_user;
grant execute on GetAllUserAccounts to admin_user;
grant execute on GetAllUserSupportRequests to admin_user;
grant execute on GetAllCurrencyExchangeRates to admin_user;
grant execute on GetAllCards to admin_user;
grant execute on GetAllCreditTypes to admin_user;
grant execute on GetAllPaymentServices to admin_user;
grant execute on GetAllCredits to admin_user;

CREATE OR REPLACE SYNONYM admin_user.GetDecryptedUsers_Syn FOR GetDecryptedUsers;
CREATE OR REPLACE SYNONYM admin_user.GetTransactionById_Syn FOR GetTransactionById;
CREATE OR REPLACE SYNONYM admin_user.GetCardById_Syn FOR GetCardById;
CREATE OR REPLACE SYNONYM admin_user.AddLoanType_Syn FOR AddLoanType;
CREATE OR REPLACE SYNONYM admin_user.UpdateLoanType_Syn FOR UpdateLoanType;
CREATE OR REPLACE SYNONYM admin_user.DeleteLoanType_Syn FOR DeleteLoanType;
CREATE OR REPLACE SYNONYM admin_user.UpdateCurrencyInfo_Syn FOR UpdateCurrencyInfo;
CREATE OR REPLACE SYNONYM admin_user.GetClientInfoById_Syn FOR GetClientInfoById;
CREATE OR REPLACE SYNONYM admin_user.GetClientAccountById_Syn FOR GetClientAccountById;
CREATE OR REPLACE SYNONYM admin_user.GetClientLoansById_Syn FOR GetClientLoansById;
CREATE OR REPLACE SYNONYM admin_user.GetAllClientCardsById_Syn FOR GetAllClientCardsById;
CREATE OR REPLACE SYNONYM admin_user.UpdateClientCardStatus_Syn FOR UpdateClientCardStatus;
CREATE OR REPLACE SYNONYM admin_user.GetAllClientsAccounts_Syn FOR GetAllClientsAccounts;
CREATE OR REPLACE SYNONYM admin_user.GetAllClientInfos_Syn FOR GetAllClientInfos;
CREATE OR REPLACE SYNONYM admin_user.GetAllClientCards_Syn FOR GetAllClientCards;
CREATE OR REPLACE SYNONYM admin_user.ProcessLoanApplication_Syn FOR ProcessLoanApplication;
CREATE OR REPLACE SYNONYM admin_user.GetLoanApplications_Syn FOR GetLoanApplications;
CREATE OR REPLACE SYNONYM admin_user.AddAccountToClient_Syn FOR AddAccountToClient;
CREATE OR REPLACE SYNONYM admin_user.CloseClientAccount_Syn FOR CloseClientAccount;
CREATE OR REPLACE SYNONYM admin_user.GetAllCurrencies_Syn FOR GetAllCurrencies;
CREATE OR REPLACE SYNONYM admin_user.GetClientProfileInfo_Syn FOR GetClientProfileInfo;
CREATE OR REPLACE SYNONYM admin_user.GetAllClientSupportRequests_Syn FOR GetAllClientSupportRequests;
CREATE OR REPLACE SYNONYM admin_user.GetAllCreditTypes_Syn FOR GetAllCreditTypes;
CREATE OR REPLACE SYNONYM admin_user.GetListOfClientAccountsByClientId_Syn FOR GetListOfClientAccountsByClientId;
CREATE OR REPLACE SYNONYM admin_user.DeleteClientProfile_Syn FOR DeleteClientProfile;
CREATE OR REPLACE SYNONYM admin_user.AddBankCard_Syn FOR AddBankCard;
CREATE OR REPLACE SYNONYM admin_user.DeleteBankCard_Syn FOR DeleteBankCard;
CREATE OR REPLACE SYNONYM admin_user.GetListCurrenciesAndExchangeRates_Syn FOR GetListCurrenciesAndExchangeRates;
CREATE OR REPLACE SYNONYM admin_user.AddBankCard_Syn FOR AddBankCard;
CREATE OR REPLACE SYNONYM admin_user.AddCurrencyExchangeRate_Syn FOR AddCurrencyExchangeRate;

CREATE OR REPLACE SYNONYM admin_user.GetAllCurrencies_Syn FOR GetAllCurrencies;
CREATE OR REPLACE SYNONYM admin_user.GetAllAppUsers_Syn FOR GetAllAppUsers;
CREATE OR REPLACE SYNONYM admin_user.GetAllUserAccounts_Syn FOR GetAllUserAccounts;
CREATE OR REPLACE SYNONYM admin_user.GetAllUserSupportRequests_Syn FOR GetAllUserSupportRequests;
CREATE OR REPLACE SYNONYM admin_user.GetAllCurrencyExchangeRate_Syn FOR GetAllCurrencyExchangeRates;
CREATE OR REPLACE SYNONYM admin_user.GetAllCards_Syn FOR GetAllCards;
CREATE OR REPLACE SYNONYM admin_user.GetAllPaymentServices_Syn FOR GetAllPaymentServices;
CREATE OR REPLACE SYNONYM admin_user.GetAllCredits_Syn FOR GetAllCredits;

--grant execute on DBMS_CRYPTO to admin_user; 
--grant execute on DBMS_CRYPTO to admin_user; 

GRANT EXECUTE ON ExportCurrencyToJSON TO admin_user;
GRANT EXECUTE ON ImportCurrencyFromJSON TO admin_user;
GRANT EXECUTE ON ExportPaymentServiceToJSON TO admin_user;
GRANT EXECUTE ON ImportPaymentServiceFromJSON TO admin_user;
GRANT EXECUTE ON ExportCreditTypeToJSON TO admin_user;
GRANT EXECUTE ON ImportCreditTypeFromJSON TO admin_user;
GRANT EXECUTE ON ExportCurrencyExchangeRateToJSON TO admin_user;
GRANT EXECUTE ON ImportCurrencyExchangeRateFromJSON TO admin_user;

CREATE OR REPLACE SYNONYM admin_user.ExportCurrencyToJSON_Syn FOR ExportCurrencyToJSON;
CREATE OR REPLACE SYNONYM admin_user.ImportCurrencyFromJSON_Syn FOR ImportCurrencyFromJSON;
CREATE OR REPLACE SYNONYM admin_user.ExportPaymentServiceToJSON_Syn for ExportPaymentServiceToJSON;
CREATE OR REPLACE SYNONYM admin_user.ImportPaymentServiceFromJSON_Syn FOR ImportPaymentServiceFromJSON;
CREATE OR REPLACE SYNONYM admin_user.ExportCreditTypeToJSON_Syn for ExportCreditTypeToJSON;
CREATE OR REPLACE SYNONYM admin_user.ImportCreditTypeFromJSON_Syn FOR ImportCreditTypeFromJSON;
CREATE OR REPLACE SYNONYM admin_user.ExportCurrencyExchangeRateToJSON_Syn FOR ExportCurrencyExchangeRateToJSON;
CREATE OR REPLACE SYNONYM admin_user.ImportCurrencyExchangeRateFromJSON_Syn FOR ImportCurrencyExchangeRateFromJSON;

SELECT owner, object_name, object_type
FROM all_objects
WHERE object_type = 'PROCEDURE' AND object_name = 'EXPORTUSERACCOUNTSTOJSON';

select * from user_tab_privs where grantee = 'ADMIN_USER';
