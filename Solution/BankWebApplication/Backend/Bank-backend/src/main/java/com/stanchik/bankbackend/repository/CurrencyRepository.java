package com.stanchik.bankbackend.repository;
import com.stanchik.bankbackend.model.Currency;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface CurrencyRepository extends CrudRepository<Currency, Long> {

    Optional<Currency> findByName(String name);

}
