package com.stanchik.bankbackend.model.dto.payment;

public record PaymentServiceDto(Integer id, String name, String type, Long transactionId) {
}
