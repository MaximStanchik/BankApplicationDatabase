package com.stanchik.bankbackend.model.dto.credit;

import java.math.BigDecimal;

public record CreditApplicationRequestDto(Integer creditTypeId, Integer accountId, BigDecimal amount) {
}
