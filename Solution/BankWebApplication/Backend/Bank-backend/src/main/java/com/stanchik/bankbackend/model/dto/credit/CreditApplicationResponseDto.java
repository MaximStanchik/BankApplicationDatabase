package com.stanchik.bankbackend.model.dto.credit;

import java.math.BigDecimal;

public record CreditApplicationResponseDto(Boolean isApproved, BigDecimal amount) {
}
