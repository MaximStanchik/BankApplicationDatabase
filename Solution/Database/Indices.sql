----------------------------------------Создание индексов:----------------------------------------

alter session set container = BANK_APP_PDB;

--User_Account:

create unique index IDX_User_Account_Number on admin_user.User_Account(ACCOUNT_NUMBER);
create index IDX_User_Account_User_ID on admin_user.User_Account(USER_ID);

--User_Profile:

create unique index IDX_User_Profile_User_ID on admin_user.User_Profile(USER_ID);
create unique index IDX_User_Profile_Email on admin_user.User_Profile(EMAIL);

--Payment_Service:

create index IDX_Payment_Service_Transaction_ID on admin_user.Payment_Service(TRANSACTION_ID);

--User_Support_Request:

create index IDX_User_Support_Request_Account_ID on admin_user.User_Support_Request(ACCOUNT_ID);
create index IDX_User_Support_Request_Date_Time on admin_user.User_Support_Request(DATE_TIME);

--Card:

create index IDX_Card_Account_ID on admin_user.Card(ACCOUNT_ID);
create unique index IDX_Card_Number on admin_user.Card(CARD_NUMBER);

SELECT * FROM admin_user.Card;

--Account_Transaction:

create index IDX_Transaction_Account_From on admin_user.Account_Transaction(ACCOUNT_ID_FROM);
create index IDX_Transaction_Account_To on admin_user.Account_Transaction(ACCOUNT_ID_TO);
create index IDX_Transaction_Date_Time on admin_user.Account_Transaction(DATE_TIME);

----------------------------------------Удаление индексов:----------------------------------------

drop index IDX_User_Account_Account_Number;
drop index IDX_User_Account_User_ID;

drop index IDX_User_Profile_User_ID;
drop index IDX_User_Profile_Email;

drop index IDX_Payment_Service_Transaction_ID;

drop index IDX_User_Support_Request_Account_ID;
drop index IDX_User_Support_Request_Date_Time;

drop index IDX_Card_Account_ID;
drop index IDX_Card_Number;

drop index IDX_Transaction_Account_From;
drop index IDX_Transaction_Account_To;
drop index IDX_Transaction_Date_Time;