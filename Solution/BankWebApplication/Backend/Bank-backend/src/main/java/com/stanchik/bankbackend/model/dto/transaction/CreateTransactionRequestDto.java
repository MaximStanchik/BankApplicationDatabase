package com.stanchik.bankbackend.model.dto.transaction;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record CreateTransactionRequestDto(Integer accountIdFrom, Integer accountIdTo, BigDecimal amount, LocalDateTime dateTime) {

};
