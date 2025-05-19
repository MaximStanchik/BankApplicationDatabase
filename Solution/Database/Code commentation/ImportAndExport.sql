create directory JSON_FILES as 'D:\User\Desktop\StudyAtBSTU\Course_3\Semester5\CourseProject\Solution\Database\Files';
--drop directory JSON_FILES;

--Процедура для экспорта данных:
create or replace procedure ExportUserAccountsToJSON(
    P_DIRECTORY in varchar2, -- Имя директории, созданной в Oracle
) as
    file_handle UTL_FILE.file_type;
    json_record clob;
begin
    -- Открываем файл на запись
    file_handle := UTL_FILE.FOPEN(P_DIRECTORY, 'user_accounts.json', 'w');

    -- Цикл по данным таблицы
    for rec in (select * from User_Account) loop
            -- Преобразуем текущую запись в JSON
            select JSON_OBJECT(
                           'ID' value rec.ID,
                           'ACCOUNT_NUMBER' value rec.ACCOUNT_NUMBER,
                           'CURRENCY' value rec.CURRENCY,
                           'AMOUNT' value rec.AMOUNT,
                           'USER_ID' value rec.USER_ID
                       ) into json_record from DUAL;

            -- Записываем JSON в файл
            UTL_FILE.PUT_LINE(file_handle, json_record);
        end loop;

    -- Закрываем файл
    UTL_FILE.FCLOSE(file_handle);
exception
    when others then
        -- Закрываем файл в случае ошибки
        if UTL_FILE.IS_OPEN(file_handle) then
            UTL_FILE.FCLOSE(file_handle);
        end if;
        raise;
end;
/

--Процедура для импорта данных:
create or replace procedure ImportUserAccountsFromJSON is
    v_file UTL_FILE.file_type;     -- Файл для чтения
    v_data clob;                   -- Данные из файла
    v_line varchar2(32767);        -- Строка из файла
    v_json json_array_t;           -- JSON-массив
    v_json_obj json_object_t;      -- JSON-объект
begin
    -- Открываем файл для чтения
    v_file := UTL_FILE.FOPEN('JSON_FILES', 'user_accounts.json', 'r');

    -- Читаем данные из файла в CLOB
    begin
        loop
            UTL_FILE.GET_LINE(v_file, v_line);
            v_data := v_data || v_line || CHR(10); -- Добавляем перенос строки для корректного формата JSON
        end loop;
    exception
        when NO_DATA_FOUND then
            null; -- Игнорируем исключение, так как это означает конец файла
    end;

    -- Закрываем файл
    UTL_FILE.FCLOSE(v_file);

    -- Парсим JSON-данные
    v_json := json_array_t.parse(v_data);

    -- Обработка JSON-массива
    for i in 0 .. v_json.get_size() - 1 loop
            v_json_obj := json_object_t(v_json.get(i)); -- Получаем JSON-объект

            -- Вставляем данные в таблицу User_Account
            insert into User_Account (
                ID,
                ACCOUNT_NUMBER,
                CURRENCY,
                AMOUNT,
                USER_ID
            ) values (
                         v_json_obj.get_number('ID'),
                         v_json_obj.get_string('ACCOUNT_NUMBER'),
                         v_json_obj.get_string('CURRENCY'),
                         v_json_obj.get_number('AMOUNT'),
                         v_json_obj.get_number('USER_ID')
                     );
        end loop;

    -- Фиксируем изменения
    commit;
exception
    when others then
        -- Откат в случае ошибки
        rollback;

        -- Закрытие файла, если он еще открыт
        if UTL_FILE.IS_OPEN(v_file) then
            UTL_FILE.FCLOSE(v_file);
        end if;

        -- Проброс исключения дальше
        raise;
end;
/


