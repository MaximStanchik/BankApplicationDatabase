package com.stanchik.bankbackend.model.dto.user.info;

public record UpdateLoginAndPasswordRequestDto(Integer userId, String newLogin, String oldPassword, String newPassword) {
}
