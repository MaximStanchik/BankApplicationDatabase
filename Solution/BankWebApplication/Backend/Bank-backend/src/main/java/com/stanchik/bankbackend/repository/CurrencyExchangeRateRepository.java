package com.stanchik.bankbackend.repository;

import com.stanchik.bankbackend.model.CurrencyExchangeRate;
import org.springframework.data.repository.CrudRepository;

public interface CurrencyExchangeRateRepository extends CrudRepository<CurrencyExchangeRate, Long> {
}
