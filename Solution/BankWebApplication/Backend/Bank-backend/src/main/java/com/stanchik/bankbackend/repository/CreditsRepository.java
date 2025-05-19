package com.stanchik.bankbackend.repository;
import com.stanchik.bankbackend.model.Credits;
import org.springframework.data.repository.CrudRepository;
public interface CreditsRepository extends CrudRepository<Credits, Long> {
}
