package com.stanchik.bankbackend.model.dto.profile;

import java.util.Date;

public record UserProfileRequestDto(String firstName, String middleName,
                                    String lastName, String address, Date birthDate,
                                    String email, String phoneNumber, String passportNum) {
}
