-- Создание табличных пространств

-- Постонное табличное пространство
create bigfile tablespace users_tbs 
datafile 'users_tbs' size 100m autoextend on next 10m maxsize 3000m;

-- Временное табличное пространство
create temporary tablespace temp_tbs
tempfile 'temp_tbs' size 100m autoextend on next 10m maxsize 3000m;

-- Создание профиля для пользователя (сотрудник банка)
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

-- Создание профиля для администратора (разработчик бд)
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
 
 -- Клиент - пользователь приложения
 
 -- Создание администратора (разработчик бд)
 create user admin_user identified by admin_password
    default tablespace users_tbs
    temporary tablespace temp_tbs
    profile admin_profile;
   
-- Создание пользователя (сотрудник банка)
create user user_user identified by user_password
    default tablespace users_tbs
    temporary tablespace TEMP_TBS
    profile user_profile;

 