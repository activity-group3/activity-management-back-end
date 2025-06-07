package com.winnguyen1905.Activity.persistance.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.winnguyen1905.Activity.persistance.entity.EOrganizationAccount;

@Repository
public interface OrganizationRepository extends JpaRepository<EOrganizationAccount, Long> {
  Optional<EOrganizationAccount> findByName(String name);
  Optional<EOrganizationAccount> findByEmail(String email);
  Optional<EOrganizationAccount> findByPhone(String phone);
}
