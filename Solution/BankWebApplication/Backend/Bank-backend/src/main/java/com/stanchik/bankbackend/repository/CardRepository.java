package com.stanchik.bankbackend.repository;

import com.stanchik.bankbackend.model.Card;
import org.springframework.data.repository.CrudRepository;

public interface CardRepository extends CrudRepository<Card, Long> {

}
