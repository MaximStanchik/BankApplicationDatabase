alter session set container = BANK_APP_PDB;

SELECT * FROM admin_user.Currency;
SELECT * FROM admin_user.App_User;
SELECT * FROM admin_user.User_Account;
SELECT * FROM admin_user.User_Profile;
SELECT * FROM admin_user.User_Support_Request;
SELECT * FROM admin_user.Currency_Exchange_Rate;
SELECT * FROM admin_user.Account_Transaction;
SELECT * FROM admin_user.Card;
SELECT * FROM admin_user.Credit_Type;
SELECT * FROM admin_user.Payment_Service;
SELECT * FROM admin_user.Credits;

delete FROM admin_user.Currency; 
delete FROM admin_user.App_User; 
delete FROM admin_user.User_Account; 
delete FROM admin_user.User_Profile; 
delete FROM admin_user.User_Support_Request; 
delete FROM admin_user.Currency_Exchange_Rate; 
delete FROM admin_user.Account_Transaction; 
delete FROM admin_user.Card; 
delete FROM admin_user.Credit_Type; 
delete FROM admin_user.Payment_Service; 
delete FROM admin_user.Credits; 

-- Currency:
INSERT INTO admin_user.Currency (NAME, CODE) VALUES ('British Columbia Dollar', 'BCD');
INSERT INTO admin_user.Currency (NAME, CODE) VALUES ('Euro', 'EUR');
INSERT INTO admin_user.Currency (NAME, CODE) VALUES ('Japanese Yen', 'JPY');
INSERT INTO admin_user.Currency (NAME, CODE) VALUES ('British Pound', 'GBP');
INSERT INTO admin_user.Currency (NAME, CODE) VALUES ('Australian Dollar', 'AUD');
INSERT INTO admin_user.Currency (NAME, CODE) VALUES ('Canadian Dollar', 'CAD');
INSERT INTO admin_user.Currency (NAME, CODE) VALUES ('Swiss Franc', 'CHF');
INSERT INTO admin_user.Currency (NAME, CODE) VALUES ('Chinese Yuan', 'CNY');
INSERT INTO admin_user.Currency (NAME, CODE) VALUES ('Hong Kong Dollar', 'HKD');
INSERT INTO admin_user.Currency (NAME, CODE) VALUES ('New Zealand Dollar', 'NZD');

-- App_User:
INSERT INTO admin_user.App_User (LOGIN, PASSWORD) VALUES ('user1', UTL_RAW.CAST_TO_VARCHAR2(encrypt('password1', generate_salt('user1@example.com'))));
INSERT INTO admin_user.App_User (LOGIN, PASSWORD) VALUES ('user2', UTL_RAW.CAST_TO_VARCHAR2(encrypt('password2', generate_salt('user2@example.com'))));
INSERT INTO admin_user.App_User (LOGIN, PASSWORD) VALUES ('user3', UTL_RAW.CAST_TO_VARCHAR2(encrypt('password3', generate_salt('user3@example.com'))));
INSERT INTO admin_user.App_User (LOGIN, PASSWORD) VALUES ('user4', UTL_RAW.CAST_TO_VARCHAR2(encrypt('password4', generate_salt('user4@example.com'))));
INSERT INTO admin_user.App_User (LOGIN, PASSWORD) VALUES ('user5', UTL_RAW.CAST_TO_VARCHAR2(encrypt('password5', generate_salt('user5@example.com'))));
INSERT INTO admin_user.App_User (LOGIN, PASSWORD) VALUES ('user6', UTL_RAW.CAST_TO_VARCHAR2(encrypt('password6', generate_salt('user6@example.com'))));
INSERT INTO admin_user.App_User (LOGIN, PASSWORD) VALUES ('user7', UTL_RAW.CAST_TO_VARCHAR2(encrypt('password7', generate_salt('user7@example.com'))));
INSERT INTO admin_user.App_User (LOGIN, PASSWORD) VALUES ('user8', UTL_RAW.CAST_TO_VARCHAR2(encrypt('password8', generate_salt('user8@example.com'))));
INSERT INTO admin_user.App_User (LOGIN, PASSWORD) VALUES ('user9', UTL_RAW.CAST_TO_VARCHAR2(encrypt('password9', generate_salt('user9@example.com'))));
INSERT INTO admin_user.App_User (LOGIN, PASSWORD) VALUES ('user10', UTL_RAW.CAST_TO_VARCHAR2(encrypt('password10', generate_salt('user11@example.com'))));

-- User_Account:
INSERT INTO admin_user.User_Account (ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID) VALUES ('ACC1', 1, 1000.00, 1);
INSERT INTO admin_user.User_Account (ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID) VALUES ('ACC2', 2, 2000.00, 2);
INSERT INTO admin_user.User_Account (ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID) VALUES ('ACC3', 3, 3000.00, 3);
INSERT INTO admin_user.User_Account (ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID) VALUES ('ACC4', 4, 4000.00, 4);
INSERT INTO admin_user.User_Account (ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID) VALUES ('ACC5', 5, 5000.00, 5);
INSERT INTO admin_user.User_Account (ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID) VALUES ('ACC6', 6, 6000.00, 6);
INSERT INTO admin_user.User_Account (ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID) VALUES ('ACC7', 7, 7000.00, 7);
INSERT INTO admin_user.User_Account (ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID) VALUES ('ACC8', 8, 8000.00, 8);
INSERT INTO admin_user.User_Account (ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID) VALUES ('ACC9', 9, 9000.00, 9);
INSERT INTO admin_user.User_Account (ACCOUNT_NUMBER, CURRENCY, AMOUNT, USER_ID) VALUES ('ACC10', 10, 10000.00, 10);

-- User_Support_Requests:
INSERT INTO admin_user.User_Support_Requests (CONTENT, DATE_TIME, USER_ID) VALUES 
('I forgot my password...', SYSTIMESTAMP, 1);

INSERT INTO admin_user.User_Support_Requests (CONTENT, DATE_TIME, USER_ID) VALUES 
('I have no money to pay this transaction!', SYSTIMESTAMP, 2);

INSERT INTO admin_user.User_Support_Requests (CONTENT, DATE_TIME, USER_ID) VALUES 
('I forgot my login, please, may u contact with me?', SYSTIMESTAMP, 3);

INSERT INTO admin_user.User_Support_Requests (CONTENT, DATE_TIME, USER_ID) VALUES 
('I love this project!', SYSTIMESTAMP, 4);

INSERT INTO admin_user.User_Support_Requests (CONTENT, DATE_TIME, USER_ID) VALUES 
('Why I have a profile in there?', SYSTIMESTAMP, 5);

INSERT INTO admin_user.User_Support_Requests (CONTENT, DATE_TIME, USER_ID) VALUES 
('ha ha ha ha ha ha ha ha ha ha', SYSTIMESTAMP, 6);

INSERT INTO admin_user.User_Support_Requests (CONTENT, DATE_TIME, USER_ID) VALUES 
('I can not access my profile, please, help me!', SYSTIMESTAMP, 7);

INSERT INTO admin_user.User_Support_Requests (CONTENT, DATE_TIME, USER_ID) VALUES 
('I would really appreciate your help with my problem...', SYSTIMESTAMP, 8);

INSERT INTO admin_user.User_Support_Requests (CONTENT, DATE_TIME, USER_ID) VALUES 
('The best bank application I have ever seen!', SYSTIMESTAMP, 9);

INSERT INTO admin_user.User_Support_Requests (CONTENT, DATE_TIME, USER_ID) VALUES 
('Please, contact with me!', SYSTIMESTAMP, 10);

-- Currency_Exchange_Rate:
INSERT INTO admin_user.Currency_Exchange_Rate (CURR_ID, BUY, SALE, POSTING_DATE) VALUES (1, 1, 1, TO_DATE('2024-12-22', 'YYYY-MM-DD')); -- BCD
INSERT INTO admin_user.Currency_Exchange_Rate (CURR_ID, BUY, SALE, POSTING_DATE) VALUES (2, 1.03, 1.039, TO_DATE('2024-12-22', 'YYYY-MM-DD')); -- EUR
INSERT INTO admin_user.Currency_Exchange_Rate (CURR_ID, BUY, SALE, POSTING_DATE) VALUES (3, 0.0064, 0.007, TO_DATE('2024-12-22', 'YYYY-MM-DD')); -- JPY
INSERT INTO admin_user.Currency_Exchange_Rate (CURR_ID, BUY, SALE, POSTING_DATE) VALUES (4, 1.24, 1.33, TO_DATE('2024-12-22', 'YYYY-MM-DD')); -- GBP
INSERT INTO admin_user.Currency_Exchange_Rate (CURR_ID, BUY, SALE, POSTING_DATE) VALUES (5, 0.62, 0.73, TO_DATE('2024-12-22', 'YYYY-MM-DD')); -- AUD
INSERT INTO admin_user.Currency_Exchange_Rate (CURR_ID, BUY, SALE, POSTING_DATE) VALUES (6, 0.69, 0.79, TO_DATE('2024-12-22', 'YYYY-MM-DD')); -- CAD
INSERT INTO admin_user.Currency_Exchange_Rate (CURR_ID, BUY, SALE, POSTING_DATE) VALUES (7, 1.11, 1.27, TO_DATE('2024-12-22', 'YYYY-MM-DD')); -- CHF
INSERT INTO admin_user.Currency_Exchange_Rate (CURR_ID, BUY, SALE, POSTING_DATE) VALUES (8, 0.14, 0.38, TO_DATE('2024-12-22', 'YYYY-MM-DD')); -- CNY
INSERT INTO admin_user.Currency_Exchange_Rate (CURR_ID, BUY, SALE, POSTING_DATE) VALUES (9, 0.13, 0.21, TO_DATE('2024-12-22', 'YYYY-MM-DD')); -- HKD
INSERT INTO admin_user.Currency_Exchange_Rate (CURR_ID, BUY, SALE, POSTING_DATE) VALUES (10, 0.56, 0.78, TO_DATE('2024-12-22', 'YYYY-MM-DD')); -- NZD

-- Account_Transaction:
INSERT INTO admin_user.Account_Transaction (ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME, CURRENCY_ID) VALUES 
(1, 2, ROUND(DBMS_RANDOM.VALUE(1, 10000), 2), SYSTIMESTAMP, 1);

INSERT INTO admin_user.Account_Transaction (ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME, CURRENCY_ID) VALUES 
(2, 3, ROUND(DBMS_RANDOM.VALUE(1, 10000), 2), SYSTIMESTAMP, 1);

INSERT INTO admin_user.Account_Transaction (ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME, CURRENCY_ID) VALUES 
(3, 4, ROUND(DBMS_RANDOM.VALUE(1, 10000), 2), SYSTIMESTAMP, 1);

INSERT INTO admin_user.Account_Transaction (ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME, CURRENCY_ID) VALUES 
(4, 5, ROUND(DBMS_RANDOM.VALUE(1, 10000), 2), SYSTIMESTAMP, 1);

INSERT INTO admin_user.Account_Transaction (ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME, CURRENCY_ID) VALUES 
(5, 6, ROUND(DBMS_RANDOM.VALUE(1, 10000), 2), SYSTIMESTAMP, 1);

INSERT INTO admin_user.Account_Transaction (ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME, CURRENCY_ID) VALUES 
(6, 7, ROUND(DBMS_RANDOM.VALUE(1, 10000), 2), SYSTIMESTAMP, 1);

INSERT INTO admin_user.Account_Transaction (ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME, CURRENCY_ID) VALUES 
(7, 8, ROUND(DBMS_RANDOM.VALUE(1, 10000), 2), SYSTIMESTAMP, 1);

INSERT INTO admin_user.Account_Transaction (ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME, CURRENCY_ID) VALUES 
(8, 9, ROUND(DBMS_RANDOM.VALUE(1, 10000), 2), SYSTIMESTAMP, 1);

INSERT INTO admin_user.Account_Transaction (ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME, CURRENCY_ID) VALUES 
(9, 10, ROUND(DBMS_RANDOM.VALUE(1, 10000), 2), SYSTIMESTAMP, 1);

INSERT INTO admin_user.Account_Transaction (ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME, CURRENCY_ID) VALUES 
(10, 1, ROUND(DBMS_RANDOM.VALUE(1, 10000), 2), SYSTIMESTAMP, 1);

INSERT INTO admin_user.Account_Transaction (ACCOUNT_ID_FROM, ACCOUNT_ID_TO, AMOUNT, DATE_TIME, CURRENCY_ID) VALUES 
(10, 2, ROUND(DBMS_RANDOM.VALUE(1, 10000), 2), SYSTIMESTAMP, 1);

-- Card:
INSERT INTO admin_user.Card (TYPE, ACCOUNT_ID, CARD_NAME, CARD_NUMBER, DESCRIPTION, STATUS) VALUES 
('Visa', 1, 'Golden Horizon', '1234567812345678', 'A card that takes you to new heights with every purchase', 'Active');

INSERT INTO admin_user.Card (TYPE, ACCOUNT_ID, CARD_NAME, CARD_NUMBER, DESCRIPTION, STATUS) VALUES 
('MasterCard', 2, 'Platinum Voyager', '2131231231231243', 'Your passport to exclusive travel rewards and experiences', 'Active');

INSERT INTO admin_user.Card (TYPE, ACCOUNT_ID, CARD_NAME, CARD_NUMBER, DESCRIPTION, STATUS) VALUES 
('American Express', 3, 'Elite Explorer', '4386778609323542', 'For those who seek adventure and luxury in every journey', 'Active');

INSERT INTO admin_user.Card (TYPE, ACCOUNT_ID, CARD_NAME, CARD_NUMBER, DESCRIPTION, STATUS) VALUES 
('Discover', 4, 'Cashback Champion', '7345684673578324', 'Earn rewards on every spend and enjoy cashback benefits', 'Active');

INSERT INTO admin_user.Card (TYPE, ACCOUNT_ID, CARD_NAME, CARD_NUMBER, DESCRIPTION, STATUS) VALUES 
('Visa', 5, 'Infinity Rewards', '3967257891409541', 'Unlock limitless possibilities with our premium rewards program', 'Active');

INSERT INTO admin_user.Card (TYPE, ACCOUNT_ID, CARD_NAME, CARD_NUMBER, DESCRIPTION, STATUS) VALUES 
('MasterCard', 6, 'Silver Shield', '4938718902568112', 'A reliable companion for your everyday purchases with added security', 'Active');

INSERT INTO admin_user.Card (TYPE, ACCOUNT_ID, CARD_NAME, CARD_NUMBER, DESCRIPTION, STATUS) VALUES 
('American Express', 7, 'Luxury Lifestyle', '2018397485478393', 'Indulge in exclusive benefits and premier services', 'Active');

INSERT INTO admin_user.Card (TYPE, ACCOUNT_ID, CARD_NAME, CARD_NUMBER, DESCRIPTION, STATUS) VALUES 
('Discover', 8, 'Adventure Seeker', '2192183758312459', 'For those who cherish exploration and spontaneous travels', 'Active');

INSERT INTO admin_user.Card (TYPE, ACCOUNT_ID, CARD_NAME, CARD_NUMBER, DESCRIPTION, STATUS) VALUES 
('Visa', 9, 'Dream Builder', '8218734867834321', 'Make your dreams a reality with financial freedom at your fingertips', 'Active');

INSERT INTO admin_user.Card (TYPE, ACCOUNT_ID, CARD_NAME, CARD_NUMBER, DESCRIPTION, STATUS) VALUES 
('MasterCard', 10, 'Voyage Elite', '2131468689080653', 'Experience the world in style with exclusive travel perks', 'Active');

-- Credit_Type:
INSERT INTO admin_user.Credit_Type (TYPE, CREDIT_NAME, DESCRIPTION) VALUES 
('Personal Loan', 'Personal Loan Type 1', 'Description of personal loan type 1');

INSERT INTO admin_user.Credit_Type (TYPE, CREDIT_NAME, DESCRIPTION) VALUES 
('Home Loan', 'Home Loan Type 2', 'Description of home loan type 2');

INSERT INTO admin_user.Credit_Type (TYPE, CREDIT_NAME, DESCRIPTION) VALUES 
('Car Loan', 'Car Loan Type 3', 'Description of car loan type 3');

INSERT INTO admin_user.Credit_Type (TYPE, CREDIT_NAME, DESCRIPTION) VALUES 
('Education Loan', 'Education Loan Type 4', 'Description of education loan type 4');

INSERT INTO admin_user.Credit_Type (TYPE, CREDIT_NAME, DESCRIPTION) VALUES 
('Business Loan', 'Business Loan Type 5', 'Description of business loan type 5');

INSERT INTO admin_user.Credit_Type (TYPE, CREDIT_NAME, DESCRIPTION) VALUES 
('Mortgage', 'Mortgage Type 6', 'Description of mortgage type 6');

INSERT INTO admin_user.Credit_Type (TYPE, CREDIT_NAME, DESCRIPTION) VALUES 
('Credit Card', 'Credit Card Type 7', 'Description of credit card type 7');

INSERT INTO admin_user.Credit_Type (TYPE, CREDIT_NAME, DESCRIPTION) VALUES 
('Cash Advance', 'Cash Advance Type 8', 'Description of cash advance type 8');

INSERT INTO admin_user.Credit_Type (TYPE, CREDIT_NAME, DESCRIPTION) VALUES 
('Payday Loan', 'Payday Loan Type 9', 'Description of payday loan type 9');

INSERT INTO admin_user.Credit_Type (TYPE, CREDIT_NAME, DESCRIPTION) VALUES 
('Debt Consolidation', 'Debt Consolidation Type 10', 'Description of debt consolidation type 10');

-- Payment_Service:
INSERT INTO admin_user.Payment_Service (NAME, TYPE, TRANSACTION_ID) VALUES 
('PayPal', 'Online Payment', 1);

INSERT INTO admin_user.Payment_Service (NAME, TYPE, TRANSACTION_ID) VALUES 
('Stripe', 'Online Payment', 2);

INSERT INTO admin_user.Payment_Service (NAME, TYPE, TRANSACTION_ID) VALUES 
('Square', 'Point of Sale', 3);

INSERT INTO admin_user.Payment_Service (NAME, TYPE, TRANSACTION_ID) VALUES 
('Venmo', 'Mobile Payment', 4);

INSERT INTO admin_user.Payment_Service (NAME, TYPE, TRANSACTION_ID) VALUES 
('Apple Pay', 'Mobile Payment', 5);

INSERT INTO admin_user.Payment_Service (NAME, TYPE, TRANSACTION_ID) VALUES 
('Google Pay', 'Mobile Payment', 6);

INSERT INTO admin_user.Payment_Service (NAME, TYPE, TRANSACTION_ID) VALUES 
('Amazon Pay', 'Online Payment', 7);

INSERT INTO admin_user.Payment_Service (NAME, TYPE, TRANSACTION_ID) VALUES 
('Zelle', 'Instant Payment', 8);

INSERT INTO admin_user.Payment_Service (NAME, TYPE, TRANSACTION_ID) VALUES 
('TransferWise', 'International Money Transfer', 9);

INSERT INTO admin_user.Payment_Service (NAME, TYPE, TRANSACTION_ID) VALUES 
('Revolut', 'Digital Banking', 10);

-- Credits:
-- Очистка данных из таблицы

TRUNCATE TABLE admin_user.Credits;

INSERT INTO admin_user.Credits (ID, CREDIT_TYPE_ID, ACCOUNT_ID, AMOUNT, ISSUED_DATE, MATURITY_DATE, INTEREST_RATE, DEBT_AMOUNT, REMAINING_AMOUNT, STATUS, CURRENCY_ID, PAYMENT_AMOUNT, PAYMENT_FREQUENCY, LOAN_TERM, LOAN_PURPOSE, TOTAL_AMOUNT)
VALUES (113, 1, 101, 1000, TIMESTAMP '2025-01-02 00:00:00.000', TIMESTAMP '2030-01-02 00:00:00.000', 5, 0, 1000, 'Active', 4, 1000, 100, 'Once a month', 5, 'Home renovation', 1050);

INSERT INTO admin_user.Credits (ID, CREDIT_TYPE_ID, ACCOUNT_ID, AMOUNT, ISSUED_DATE, MATURITY_DATE, INTEREST_RATE, DEBT_AMOUNT, REMAINING_AMOUNT, STATUS, CURRENCY_ID, PAYMENT_AMOUNT, PAYMENT_FREQUENCY, LOAN_TERM, LOAN_PURPOSE, TOTAL_AMOUNT)
VALUES (114, 2, 102, 2000, TIMESTAMP '2025-01-02 00:00:00.000', TIMESTAMP '2028-01-02 00:00:00.000', 4.5, 0, 2000, 'Active', 3, 2000, 200, 'Once every three months', 3, 'Car purchase', 2090);

INSERT INTO admin_user.Credits (ID, CREDIT_TYPE_ID, ACCOUNT_ID, AMOUNT, ISSUED_DATE, MATURITY_DATE, INTEREST_RATE, DEBT_AMOUNT, REMAINING_AMOUNT, STATUS, CURRENCY_ID, PAYMENT_AMOUNT, PAYMENT_FREQUENCY, LOAN_TERM, LOAN_PURPOSE, TOTAL_AMOUNT)
VALUES (115, 3, 103, 1500, TIMESTAMP '2025-01-02 00:00:00.000', TIMESTAMP '2029-01-02 00:00:00.000', 3.75, 0, 1500, 'Active', 7, 1500, 150, 'Once every six months', 4, 'Education', 1556.25);

INSERT INTO admin_user.Credits (ID, CREDIT_TYPE_ID, ACCOUNT_ID, AMOUNT, ISSUED_DATE, MATURITY_DATE, INTEREST_RATE, DEBT_AMOUNT, REMAINING_AMOUNT, STATUS, CURRENCY_ID, PAYMENT_AMOUNT, PAYMENT_FREQUENCY, LOAN_TERM, LOAN_PURPOSE, TOTAL_AMOUNT)
VALUES (116, 4, 104, 2500, TIMESTAMP '2025-01-02 00:00:00.000', TIMESTAMP '2035-01-02 00:00:00.000', 6.25, 0, 2500, 'Active', 6, 2500, 250, 'Once a month', 10, 'Business expansion', 2656.25);

INSERT INTO admin_user.Credits (ID, CREDIT_TYPE_ID, ACCOUNT_ID, AMOUNT, ISSUED_DATE, MATURITY_DATE, INTEREST_RATE, DEBT_AMOUNT, REMAINING_AMOUNT, STATUS, CURRENCY_ID, PAYMENT_AMOUNT, PAYMENT_FREQUENCY, LOAN_TERM, LOAN_PURPOSE, TOTAL_AMOUNT)
VALUES (117, 5, 105, 3000, TIMESTAMP '2025-01-02 00:00:00.000', TIMESTAMP '2040-01-02 00:00:00.000', 5.5, 0, 3000, 'Active', 7, 3000, 300, 'Once a month', 15, 'Home improvement', 3165);

INSERT INTO admin_user.Credits (ID, CREDIT_TYPE_ID, ACCOUNT_ID, AMOUNT, ISSUED_DATE, MATURITY_DATE, INTEREST_RATE, DEBT_AMOUNT, REMAINING_AMOUNT, STATUS, CURRENCY_ID, PAYMENT_AMOUNT, PAYMENT_FREQUENCY, LOAN_TERM, LOAN_PURPOSE, TOTAL_AMOUNT)
VALUES (118, 1, 106, 1200, TIMESTAMP '2025-01-02 00:00:00.000', TIMESTAMP '2028-01-02 00:00:00.000', 4, 0, 1200, 'Active', 2, 1200, 120, 'Once a month', 3, 'Travel', 1248);

INSERT INTO admin_user.Credits (ID, CREDIT_TYPE_ID, ACCOUNT_ID, AMOUNT, ISSUED_DATE, MATURITY_DATE, INTEREST_RATE, DEBT_AMOUNT, REMAINING_AMOUNT, STATUS, CURRENCY_ID, PAYMENT_AMOUNT, PAYMENT_FREQUENCY, LOAN_TERM, LOAN_PURPOSE, TOTAL_AMOUNT)
VALUES (119, 2, 107, 1800, TIMESTAMP '2025-01-02 00:00:00.000', TIMESTAMP '2030-01-02 00:00:00.000', 5.25, 0, 1800, 'Active', 9, 1800, 180, 'Once every three months', 5, 'Medical expenses', 1894.5);

INSERT INTO admin_user.Credits (ID, CREDIT_TYPE_ID, ACCOUNT_ID, AMOUNT, ISSUED_DATE, MATURITY_DATE, INTEREST_RATE, DEBT_AMOUNT, REMAINING_AMOUNT, STATUS, CURRENCY_ID, PAYMENT_AMOUNT, PAYMENT_FREQUENCY, LOAN_TERM, LOAN_PURPOSE, TOTAL_AMOUNT)
VALUES (120, 3, 108, 2200, TIMESTAMP '2025-01-02 00:00:00.000', TIMESTAMP '2029-01-02 00:00:00.000', 3.5, 0, 2200, 'Active', 10, 2200, 220, 'Once every six months', 4, 'Home purchase', 2277);

INSERT INTO admin_user.Credits (ID, CREDIT_TYPE_ID, ACCOUNT_ID, AMOUNT, ISSUED_DATE, MATURITY_DATE, INTEREST_RATE, DEBT_AMOUNT, REMAINING_AMOUNT, STATUS, CURRENCY_ID, PAYMENT_AMOUNT, PAYMENT_FREQUENCY, LOAN_TERM, LOAN_PURPOSE, TOTAL_AMOUNT)
VALUES (121, 1, 109, 1600, TIMESTAMP '2025-01-02 00:00:00.000', TIMESTAMP '2027-01-02 00:00:00.000', 6, 0, 1600, 'Active', 9, 1600, 160, 'Once a month', 2, 'Refinancing', 1696);

INSERT INTO admin_user.Credits (ID, CREDIT_TYPE_ID, ACCOUNT_ID, AMOUNT, ISSUED_DATE, MATURITY_DATE, INTEREST_RATE, DEBT_AMOUNT, REMAINING_AMOUNT, STATUS, CURRENCY_ID, PAYMENT_AMOUNT, PAYMENT_FREQUENCY, LOAN_TERM, LOAN_PURPOSE, TOTAL_AMOUNT)
VALUES (122, 2, 110, 2800, TIMESTAMP '2025-01-02 00:00:00.000', TIMESTAMP '2040-01-02 00:00:00.000', 7, 0, 2800, 'Active', 3, 2800, 280, 'Once a month', 15, 'Investment', 2996);

-- User_Profile:  
INSERT INTO admin_user.User_Profile (USER_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, BIRTH_DATE, EMAIL, PASSPORT_NUM, PHONE_NUMBER) VALUES 
(1, 'John', 'Doe', 'A.', '123 Elm St, Springfield, IL', TO_DATE('1990-01-01', 'YYYY-MM-DD'), 'john.doe@example.com', 'P12345678', '555-0101');

INSERT INTO admin_user.User_Profile (USER_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, BIRTH_DATE, EMAIL, PASSPORT_NUM, PHONE_NUMBER) VALUES 
(2, 'Jane', 'Smith', 'B.', '234 Oak St, Springfield, IL', TO_DATE('1991-02-02', 'YYYY-MM-DD'), 'jane.smith@example.com', 'P23456789', '555-0102');

INSERT INTO admin_user.User_Profile (USER_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, BIRTH_DATE, EMAIL, PASSPORT_NUM, PHONE_NUMBER) VALUES 
(3, 'Alice', 'Johnson', 'C.', '345 Pine St, Springfield, IL', TO_DATE('1992-03-03', 'YYYY-MM-DD'), 'alice.johnson@example.com', 'P34567890', '555-0103');

INSERT INTO admin_user.User_Profile (USER_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, BIRTH_DATE, EMAIL, PASSPORT_NUM, PHONE_NUMBER) VALUES 
(4, 'Bob', 'Brown', 'D.', '456 Maple St, Springfield, IL', TO_DATE('1993-04-04', 'YYYY-MM-DD'), 'bob.brown@example.com', 'P45678901', '555-0104');

INSERT INTO admin_user.User_Profile (USER_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, BIRTH_DATE, EMAIL, PASSPORT_NUM, PHONE_NUMBER) VALUES 
(5, 'Charlie', 'Davis', 'E.', '567 Cedar St, Springfield, IL', TO_DATE('1994-05-05', 'YYYY-MM-DD'), 'charlie.davis@example.com', 'P56789012', '555-0105');

INSERT INTO admin_user.User_Profile (USER_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, BIRTH_DATE, EMAIL, PASSPORT_NUM, PHONE_NUMBER) VALUES 
(6, 'Diana', 'Evans', 'F.', '678 Birch St, Springfield, IL', TO_DATE('1995-06-06', 'YYYY-MM-DD'), 'diana.evans@example.com', 'P67890123', '555-0106');

INSERT INTO admin_user.User_Profile (USER_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, BIRTH_DATE, EMAIL, PASSPORT_NUM, PHONE_NUMBER) VALUES 
(7, 'Ethan', 'Wilson', 'G.', '789 Willow St, Springfield, IL', TO_DATE('1996-07-07', 'YYYY-MM-DD'), 'ethan.wilson@example.com', 'P78901234', '555-0107');

INSERT INTO admin_user.User_Profile (USER_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, BIRTH_DATE, EMAIL, PASSPORT_NUM, PHONE_NUMBER) VALUES 
(8, 'Fiona', 'Martinez', 'H.', '890 Chestnut St, Springfield, IL', TO_DATE('1997-08-08', 'YYYY-MM-DD'), 'fiona.martinez@example.com', 'P89012345', '555-0108');

INSERT INTO admin_user.User_Profile (USER_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, BIRTH_DATE, EMAIL, PASSPORT_NUM, PHONE_NUMBER) VALUES 
(9, 'George', 'Clark', 'I.', '901 Ash St, Springfield, IL', TO_DATE('1998-09-09', 'YYYY-MM-DD'), 'george.clark@example.com', 'P90123456', '555-0109');

INSERT INTO admin_user.User_Profile (USER_ID, FIRST_NAME, LAST_NAME, MIDDLE_NAME, ADDRESS, BIRTH_DATE, EMAIL, PASSPORT_NUM, PHONE_NUMBER) VALUES 
(10, 'Hannah', 'Lewis', 'J.', '123 Fir St, Springfield, IL', TO_DATE('1999-10-10', 'YYYY-MM-DD'), 'hannah.lewis@example.com', 'P01234567', '555-0110');