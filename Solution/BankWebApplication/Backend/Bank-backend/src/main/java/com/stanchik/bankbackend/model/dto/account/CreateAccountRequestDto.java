package com.stanchik.bankbackend.model.dto.account;

public record CreateAccountRequestDto(Integer userId, String name, String currency) {

}
