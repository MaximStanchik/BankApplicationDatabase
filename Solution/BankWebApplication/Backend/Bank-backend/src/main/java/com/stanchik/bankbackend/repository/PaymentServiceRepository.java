package com.stanchik.bankbackend.repository;

import com.stanchik.bankbackend.model.PaymentService;
import org.springframework.data.repository.CrudRepository;

public interface PaymentServiceRepository extends CrudRepository<PaymentService, Long> {
}
