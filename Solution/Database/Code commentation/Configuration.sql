-- Создание отдельной PDB
create pluggable database BANK_APP_PDB
  admin user admin identified by test1111 -- автоматически создание admin у которого будет роль dba
  roles = (dba)
  file_name_convert = (
	'/opt/oracle/oradata/XE/XEPDB1', 
	'/opt/oracle/oradata/XE/XEPDB1/SES_PDB'
);

--alter pluggable database BANK_APP_PDB open; -- sqlplus (dba)
--alter session set "AUDIT_SYS_OPERATIONS" = true; -- активация аудита действий системных пользователей в текущей сессии, позволяя вести учет и мониторинг их операций 

-- Создание постонного табличного пространства
create bigfile tablespace users_tbs 
datafile 'users_tbs' size 100m autoextend on;

-- Создание временного табличного пространства
create temporary tablespace temp_tbs
tempfile 'temp_tbs' size 100m autoextend on;

-- Создание профиля для пользователя (сотрудника банка)
create profile user_profile limit
  failed_login_attempts 5 -- максимум 5 неудачных попыток входа; после этого аккаунт может быть заблокирован
  sessions_per_user   10 -- ограничение на 10 одновременно открытых сессий для пользователя
  cpu_per_session     unlimited -- нет ограничения на использование CPU в каждой сессии
  cpu_per_call        3000 -- максимум 3000 единиц CPU на каждый вызов
  connect_time        45 -- максимум 45 минут времени подключения к базе данных
  idle_time           15 -- максимум 15 минут бездействия; после этого сессия будет закрыта
  logical_reads_per_session default -- логические чтения на сессию по умолчанию не ограничены
  logical_reads_per_call    default -- логические чтения на вызов по умолчанию не ограничены
  private_sga        15k -- ограничение на 15 килобайт для частного SGA (System Global Area) для сессии
  composite_limit    5000000; -- общий лимит на ресурсы для сессии установлен в 5,000,000 единиц

-- Создание профиля для администратора (разработчика БД)
create profile admin_profile limit 
  sessions_per_user   unlimited -- нет ограничения на количество сессий для пользователя
  cpu_per_session     unlimited -- нет ограничения на использование CPU в каждой сессии
  cpu_per_call        unlimited -- нет ограничения на использование CPU для каждого вызова
  connect_time        unlimited -- нет ограничения на время подключения к базе данных.
  idle_time           unlimited -- нет ограничения на время бездействия сессии.
  logical_reads_per_session default -- логические чтения на сессию по умолчанию (не ограничены)
  logical_reads_per_call    default -- логические чтения на вызов по умолчанию (не ограничены)
  private_sga        unlimited -- нет ограничения на размер частного SGA
  composite_limit    unlimited; -- нет общего ограничения на ресурсы для сессий
  
  -- Создание роли для пользователя (сотрудника банка)
create role user_role;

-- Создание роли для администратора (разработчика БД)
create role admin_role;
     
-- Назначение привилегий для роли администратора (разработчика БД)
    grant all privileges on Payment_Service to admin_role;
    grant all privileges on Credits to admin_role;
    grant all privileges on Card to admin_role;
    grant all privileges on Account_Transaction to admin_role;
    grant all privileges on Currency_Exchange_Rate to admin_role;
    grant all privileges on User_Support_Request to admin_role;
    grant all privileges on User_Profile to admin_role;
    grant all privileges on User_Account to admin_role;
    grant all privileges on App_User to admin_role;
    grant all privileges on Currency to admin_role;
    grant all privileges on Credit_Type to admin_role;

-- Назначение привилегий для роли пользователя (сотрудника БД)
    grant select on Payment_Service to admin_role;
    grant select on Credits to admin_role;
    grant select on Card to admin_role;
    grant select on Account_Transaction to admin_role;
    grant select on Currency_Exchange_Rate to admin_role;
    grant select on User_Support_Request to admin_role;
    grant select on User_Profile to admin_role;
    grant select on User_Account to admin_role;
    grant select on App_User to admin_role;
    grant select on Currency to admin_role;
    grant select on Credit_Type to admin_role;

-- Клиент - пользователь приложения
 
-- Создание администратора (разработчик БД)
create user admin_user identified by admin_password
    default tablespace users_tbs
    temporary tablespace temp_tbs
    profile admin_profile;
    
grant connect, resource, dba, admin_role to admin_user; 
-- connect -- позволяет пользователю подключаться к БД
-- resource -- позволяет пользователю создавать объекты БД
-- dba -- 

-- Создание пользователя (сотрудник банка)
create user user_user identified by user_password
    default tablespace users_tbs
    temporary tablespace TEMP_TBS
    profile user_profile;

-- Также при создании PDB автоматически создан admin у которого будет роль dba
    
grant connect, resource, user_role to user_user;

drop tablespace users_tbs including contents and datafiles;
drop tablespace temp_tbs including contents and datafiles;