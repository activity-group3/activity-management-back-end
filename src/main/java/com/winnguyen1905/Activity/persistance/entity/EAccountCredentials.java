package com.winnguyen1905.Activity.persistance.entity;

import java.time.Instant;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.winnguyen1905.Activity.common.constant.AccountRole;
import com.winnguyen1905.Activity.common.constant.MajorType;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;

@Getter
@Setter
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "account")
@Inheritance(strategy = InheritanceType.JOINED)
public class EAccountCredentials {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "id", updatable = false, nullable = false)
  protected Long id;

  @Column(name = "password", nullable = false)
  protected String password;

  @Column(name = "status", nullable = false)
  protected Boolean isActive;

  @Column(name = "last_token", length = 1024)
  protected String refreshToken;

  @Column(name = "identify_code", unique = true, nullable = false, updatable = false)
  protected String identifyCode;

  @Column(name = "role_code", nullable = false)
  @Enumerated(EnumType.STRING)
  protected AccountRole role;

  @Column(name = "email", nullable = false)
  protected String email;

  @Column(name = "phone")
  protected String phone;

  @Column(name = "full_name")
  protected String fullName;

  @Column(name = "major")
  @Enumerated(EnumType.STRING)
  protected MajorType major;

  @OneToMany(mappedBy = "participant")
  private List<EParticipationDetail> participationDetails;

  @OneToMany(mappedBy = "receiver")
  private List<ENotification> myNotificationReceiveds;

  @OneToMany(mappedBy = "sender")
  private List<ENotification> myNotificationSents;

  @OneToMany(mappedBy = "reporter")
  private List<EReport> reports;

  @JsonIgnore
  @Column(name = "created_by")
  protected Long createdBy;

  @JsonIgnore
  @Column(name = "updated_by")
  protected Long updatedBy;

  @CreationTimestamp
  @Column(name = "created_date", updatable = false)
  protected Instant createdDate;

  @UpdateTimestamp
  @Column(name = "updated_date")
  protected Instant updatedDate;

}
