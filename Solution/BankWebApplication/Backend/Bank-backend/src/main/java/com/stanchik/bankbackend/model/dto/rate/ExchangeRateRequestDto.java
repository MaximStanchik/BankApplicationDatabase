package com.stanchik.bankbackend.model.dto.rate;

import java.math.BigDecimal;
import java.time.LocalDate;

public record ExchangeRateRequestDto(Integer sourceCurrId, Integer targetCurrId, BigDecimal rate, LocalDate date) {
}
