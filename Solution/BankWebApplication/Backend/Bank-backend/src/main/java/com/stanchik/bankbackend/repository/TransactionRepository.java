package com.stanchik.bankbackend.repository;

import com.stanchik.bankbackend.model.AccountTransaction;
import org.springframework.data.repository.CrudRepository;

public interface TransactionRepository extends CrudRepository<AccountTransaction, Long> {
}
