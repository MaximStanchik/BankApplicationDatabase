package com.stanchik.bankbackend.model.dto.user.login;

public record LoginRequestDto(String login, String password) { // Обработка запросов на вход пользователя
    // TODO: проверка на то, существует ли введенный логин вообще
    // TODO: проверка правильности введенного пароля

};
