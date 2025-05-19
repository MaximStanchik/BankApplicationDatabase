package com.stanchik.bankbackend.repository;

import com.stanchik.bankbackend.model.UserSupportRequests;
import org.springframework.data.repository.CrudRepository;

public interface UserSupportRequestRepository extends CrudRepository<UserSupportRequests, Long> {
}
