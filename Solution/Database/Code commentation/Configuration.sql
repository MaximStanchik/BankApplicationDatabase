-- �������� ��������� PDB
create pluggable database BANK_APP_PDB
  admin user admin identified by test1111 -- ������������� �������� admin � �������� ����� ���� dba
  roles = (dba)
  file_name_convert = (
	'/opt/oracle/oradata/XE/XEPDB1', 
	'/opt/oracle/oradata/XE/XEPDB1/SES_PDB'
);

--alter pluggable database BANK_APP_PDB open; -- sqlplus (dba)
--alter session set "AUDIT_SYS_OPERATIONS" = true; -- ��������� ������ �������� ��������� ������������� � ������� ������, �������� ����� ���� � ���������� �� �������� 

-- �������� ���������� ���������� ������������
create bigfile tablespace users_tbs 
datafile 'users_tbs' size 100m autoextend on;

-- �������� ���������� ���������� ������������
create temporary tablespace temp_tbs
tempfile 'temp_tbs' size 100m autoextend on;

-- �������� ������� ��� ������������ (���������� �����)
create profile user_profile limit
  failed_login_attempts 5 -- �������� 5 ��������� ������� �����; ����� ����� ������� ����� ���� ������������
  sessions_per_user   10 -- ����������� �� 10 ������������ �������� ������ ��� ������������
  cpu_per_session     unlimited -- ��� ����������� �� ������������� CPU � ������ ������
  cpu_per_call        3000 -- �������� 3000 ������ CPU �� ������ �����
  connect_time        45 -- �������� 45 ����� ������� ����������� � ���� ������
  idle_time           15 -- �������� 15 ����� �����������; ����� ����� ������ ����� �������
  logical_reads_per_session default -- ���������� ������ �� ������ �� ��������� �� ����������
  logical_reads_per_call    default -- ���������� ������ �� ����� �� ��������� �� ����������
  private_sga        15k -- ����������� �� 15 �������� ��� �������� SGA (System Global Area) ��� ������
  composite_limit    5000000; -- ����� ����� �� ������� ��� ������ ���������� � 5,000,000 ������

-- �������� ������� ��� �������������� (������������ ��)
create profile admin_profile limit 
  sessions_per_user   unlimited -- ��� ����������� �� ���������� ������ ��� ������������
  cpu_per_session     unlimited -- ��� ����������� �� ������������� CPU � ������ ������
  cpu_per_call        unlimited -- ��� ����������� �� ������������� CPU ��� ������� ������
  connect_time        unlimited -- ��� ����������� �� ����� ����������� � ���� ������.
  idle_time           unlimited -- ��� ����������� �� ����� ����������� ������.
  logical_reads_per_session default -- ���������� ������ �� ������ �� ��������� (�� ����������)
  logical_reads_per_call    default -- ���������� ������ �� ����� �� ��������� (�� ����������)
  private_sga        unlimited -- ��� ����������� �� ������ �������� SGA
  composite_limit    unlimited; -- ��� ������ ����������� �� ������� ��� ������
  
  -- �������� ���� ��� ������������ (���������� �����)
create role user_role;

-- �������� ���� ��� �������������� (������������ ��)
create role admin_role;
     
-- ���������� ���������� ��� ���� �������������� (������������ ��)
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

-- ���������� ���������� ��� ���� ������������ (���������� ��)
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

-- ������ - ������������ ����������
 
-- �������� �������������� (����������� ��)
create user admin_user identified by admin_password
    default tablespace users_tbs
    temporary tablespace temp_tbs
    profile admin_profile;
    
grant connect, resource, dba, admin_role to admin_user; 
-- connect -- ��������� ������������ ������������ � ��
-- resource -- ��������� ������������ ��������� ������� ��
-- dba -- 

-- �������� ������������ (��������� �����)
create user user_user identified by user_password
    default tablespace users_tbs
    temporary tablespace TEMP_TBS
    profile user_profile;

-- ����� ��� �������� PDB ������������� ������ admin � �������� ����� ���� dba
    
grant connect, resource, user_role to user_user;

drop tablespace users_tbs including contents and datafiles;
drop tablespace temp_tbs including contents and datafiles;