package com.stanchik.bankbackend.repository;

import com.stanchik.bankbackend.model.UserAccount;
import org.springframework.data.repository.CrudRepository;
public interface AccountRepository extends CrudRepository<UserAccount, Long> {
}
