package com.stanchik.bankbackend.repository;

import com.stanchik.bankbackend.model.UserProfile;
import org.springframework.data.repository.CrudRepository;

public interface UserProfileRepository extends CrudRepository<UserProfile, Long> {
}
