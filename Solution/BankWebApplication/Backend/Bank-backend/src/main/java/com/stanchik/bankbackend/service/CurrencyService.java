package com.stanchik.bankbackend.service;

import com.stanchik.bankbackend.model.Currency;
import com.stanchik.bankbackend.repository.CurrencyRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CurrencyService {

    private final CurrencyRepository currencyRepository;

    public Currency findByName(String name) {
        return currencyRepository.findByName(name)
                .orElseThrow(() -> new RuntimeException("Currency not found by name: " + name));
    }

}
