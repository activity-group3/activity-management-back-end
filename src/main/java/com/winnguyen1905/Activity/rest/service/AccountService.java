package com.winnguyen1905.Activity.rest.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.winnguyen1905.Activity.common.constant.AccountRole;
import com.winnguyen1905.Activity.common.constant.MajorType;
import com.winnguyen1905.Activity.exception.BadRequestException;
import com.winnguyen1905.Activity.exception.ResourceNotFoundException;
import com.winnguyen1905.Activity.model.dto.AdminUpdateAccount;
import com.winnguyen1905.Activity.model.dto.RegisterRequest;
import com.winnguyen1905.Activity.model.dto.UpdateAccountDto;
import com.winnguyen1905.Activity.model.dto.AccountSearchCriteria;
import com.winnguyen1905.Activity.model.viewmodel.AccountVm;
import com.winnguyen1905.Activity.model.viewmodel.PagedResponse;
import com.winnguyen1905.Activity.persistance.entity.EAccountCredentials;
import com.winnguyen1905.Activity.persistance.entity.EOrganizationAccount;
import com.winnguyen1905.Activity.persistance.entity.EStudentAccount;
import com.winnguyen1905.Activity.persistance.repository.AccountRepository;
import com.winnguyen1905.Activity.persistance.repository.specification.AccountSpecifications;
import com.winnguyen1905.Activity.utils.JwtUtils;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class AccountService {

  private final JwtUtils jwtUtils;
  private final AccountRepository accountRepository;
  private final PasswordEncoder passwordEncoder;

  @Transactional(readOnly = true)
  public PagedResponse<AccountVm> searchAccounts(AccountSearchCriteria criteria, Pageable pageable) {
    Specification<EAccountCredentials> spec = AccountSpecifications.withCriteria(criteria);
    Page<EAccountCredentials> accountPage = accountRepository.findAll(spec, pageable);

    List<AccountVm> accounts = accountPage.getContent().stream()
        .map(this::convertToAccountVm)
        .collect(Collectors.toList());

    return PagedResponse.<AccountVm>builder()
        .results(accounts)
        .page(accountPage.getNumber())
        .size(accountPage.getSize())
        .totalElements(accountPage.getTotalElements())
        .totalPages(accountPage.getTotalPages())
        .build();
  }

  @Transactional(readOnly = true)
  public AccountVm getAccount(Long accountId) {
    EAccountCredentials account = accountRepository.findById(accountId)
        .orElseThrow(() -> new ResourceNotFoundException("Account not found with id: " + accountId));
    return convertToAccountVm(account);
  }

  @Transactional
  public void changeStatus(Long accountId) {
    EAccountCredentials account = accountRepository.findById(accountId)
        .orElseThrow(() -> new ResourceNotFoundException("Account not found with id: " + accountId));

    account.setIsActive(!account.getIsActive());
    accountRepository.save(account);
  }

  @Transactional
  public void deleteAccount(Long accountId) {
    if (!accountRepository.existsById(accountId)) {
      throw new ResourceNotFoundException("Account not found with id: " + accountId);
    }
    accountRepository.deleteById(accountId);
  }

  @Transactional
  public AccountVm updateAccount(Long accountId, UpdateAccountDto updateDto) {
    EAccountCredentials account = accountRepository.findById(accountId)
        .orElseThrow(() -> new ResourceNotFoundException("Account not found with id: " + accountId));

    // Update common fields
    account.setEmail(updateDto.email());
    account.setPhone(updateDto.phone());

    // Handle type-specific updates
    if (account instanceof EStudentAccount studentAccount) {
      updateStudentAccount(studentAccount, updateDto);
    } else if (account instanceof EOrganizationAccount orgAccount) {
      updateOrganizationAccount(orgAccount, updateDto);
    }

    EAccountCredentials updatedAccount = accountRepository.save(account);
    return convertToAccountVm(updatedAccount);
  }

  @Transactional
  public AccountVm updateAccountByAdmin(Long accountId, AdminUpdateAccount updateDto) {
    EAccountCredentials account = accountRepository.findById(accountId)
        .orElseThrow(() -> new ResourceNotFoundException("Account not found with id: " + accountId));

    // Update common fields
    account.setEmail(updateDto.email());
    account.setPhone(updateDto.phone());
    account.setIsActive(updateDto.isActive());

    if (updateDto.role() != null) {
      account.setRole(updateDto.role());
    }

    // Handle type-specific updates
    if (account instanceof EStudentAccount studentAccount) {
      updateStudentAccountByAdmin(studentAccount, updateDto);
    } else if (account instanceof EOrganizationAccount orgAccount) {
      updateOrganizationAccountByAdmin(orgAccount, updateDto);
    }

    EAccountCredentials updatedAccount = accountRepository.save(account);
    return convertToAccountVm(updatedAccount);
  }

  @Transactional
  public AccountVm createAccount(RegisterRequest registerRequest) {
    if (accountRepository.existsByIdentifyCode(registerRequest.identifyCode())) {
      throw new BadRequestException("Account with this identify code already exists");
    }

    EAccountCredentials newAccount;
    if (registerRequest.role() == AccountRole.STUDENT) {
      newAccount = createStudentAccount(registerRequest);
    } else if (registerRequest.role() == AccountRole.ORGANIZATION) {
      newAccount = createOrganizationAccount(registerRequest);
    } else {
      throw new BadRequestException("Invalid account role");
    }

    // Encode password
    newAccount.setPassword(passwordEncoder.encode(registerRequest.password()));

    EAccountCredentials savedAccount = accountRepository.save(newAccount);
    return convertToAccountVm(savedAccount);
  }

  // Helper methods
  private EStudentAccount createStudentAccount(RegisterRequest request) {
    return EStudentAccount.builder()
        .identifyCode(request.identifyCode())
        .email(request.email())
        .phone(request.phone())
        .isActive(true)
        .role(AccountRole.STUDENT)
        .fullName(request.fullName())
        .identifyCode(request.identifyCode()) // Using identify code as student code
        .major(request.major())
        .build();
  }

  private EOrganizationAccount createOrganizationAccount(RegisterRequest request) {
    return EOrganizationAccount.builder()
        .identifyCode(request.identifyCode())
        .email(request.email())
        .phone(request.phone())
        .isActive(true)
        .role(AccountRole.ORGANIZATION)
        .name(request.fullName())
        // .taxCode(request.taxCode())
        .role(request.role())
        .build();
  }

  private void updateStudentAccount(EStudentAccount account, UpdateAccountDto dto) {
    // Update student-specific fields
    if (dto.fullName() != null) {
      account.setFullName(dto.fullName());
    }
    if (dto.major() != null) {
      account.setMajor(dto.major());
    }
  }

  private void updateOrganizationAccount(EOrganizationAccount account, UpdateAccountDto dto) {
    // Update organization-specific fields
    if (dto.organizationName() != null) {
      account.setName(dto.organizationName());
    }
    if (dto.organizationType() != null) {
      account.setType(dto.organizationType());
    }
  }

  private void updateStudentAccountByAdmin(EStudentAccount account, AdminUpdateAccount dto) {
    // Update student-specific admin fields
    if (dto.fullName() != null) {
      account.setFullName(dto.fullName());
    }
    if (dto.major() != null) {
      account.setMajor(dto.major());
    }
  }

  private void updateOrganizationAccountByAdmin(EOrganizationAccount account, AdminUpdateAccount dto) {
    // Update organization-specific admin fields
    if (dto.fullName() != null) {
      account.setName(dto.fullName());
    }
    if (dto.role() != null) {
      account.setRole(dto.role());
    }
  }

  private AccountVm convertToAccountVm(EAccountCredentials account) {
    AccountVm.AccountVmBuilder builder = AccountVm.builder()
        .id(account.getId())
        .identifyCode(account.getIdentifyCode())
        .email(account.getEmail())
        .phone(account.getPhone())
        .role(account.getRole())
        .isActive(account.getIsActive());

    if (account instanceof EStudentAccount student) {
      builder.name(student.getFullName())
          .major(student.getMajor() != null ? MajorType.valueOf(student.getMajor().name()) : null)
          .role(AccountRole.STUDENT);
    } else if (account instanceof EOrganizationAccount org) {
      builder.name(org.getOrganizationName())
          .role(AccountRole.ORGANIZATION);
    }

    return builder.build();
  }
}
