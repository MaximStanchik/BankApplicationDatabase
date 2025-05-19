package com.stanchik.bankbackend.service;

import com.stanchik.bankbackend.model.UserAccount;
import com.stanchik.bankbackend.model.Currency;
import com.stanchik.bankbackend.model.AppUser;
import com.stanchik.bankbackend.model.dto.account.CreateAccountRequestDto;
import com.stanchik.bankbackend.model.dto.account.CreateAccountResponseDto;
import com.stanchik.bankbackend.repository.AccountRepository;
import com.stanchik.bankbackend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AccountService {

    private final UserRepository userRepository;
    private final AccountRepository accountRepository;
    private final CurrencyService currencyService;

    public CreateAccountResponseDto createAccount(CreateAccountRequestDto dto) {
        AppUser user = userRepository.findById(dto.userId())
                .orElseThrow(() -> new RuntimeException("User not found by ID: " + dto.userId()));
        Currency currency = currencyService.findByName(dto.currency());
        UserAccount userAccount = new UserAccount();
        userAccount.setName(dto.name());
        userAccount.setCurrency(currency.getName());
        userAccount.setUser(user);
        accountRepository.save(userAccount);
        return new CreateAccountResponseDto(true);
    }

    public UserAccount findById(Long id) {
        return accountRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("UserAccount not found by ID: " + id));
    }

}
