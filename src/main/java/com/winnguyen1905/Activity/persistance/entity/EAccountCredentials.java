package com.winnguyen1905.activity.persistance.entity;

import java.time.Instant;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.winnguyen1905.activity.common.constant.AccountRole;
import com.winnguyen1905.activity.common.constant.MajorType;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;

@Getter
@Setter
@Entity
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "account")
public class EAccountCredentials {
  @Id
  @GeneratedValue(strategy = GenerationType.AUTO)
  @Column(name = "id", updatable = false, nullable = false)
  protected Long id;

  @Column(name = "full_name")
  private String fullName;

  @Column(name = "identify_code")
  private String identifyCode;

  @Column(name = "password")
  private String password;

  @Column(name = "status")
  private Boolean isActive;

  @Column(name = "email")
  private String email;

  @Column(name = "phone")
  private String phone;

  @Column(name = "refresh_token", length = 1024)
  private String refreshToken;

  @Column(name = "role")
  @Enumerated(EnumType.STRING)
  private AccountRole role;

  @OneToOne(cascade = CascadeType.ALL, mappedBy = "account")
  private EOrganization organization;

  @OneToMany(mappedBy = "participant")
  private List<EParticipationDetail> participationDetails;

  @OneToMany(mappedBy = "receiver")
  private List<ENotification> myNotificationReceiveds;

  @OneToMany(mappedBy = "sender")
  private List<ENotification> myNotificationSents;

  @OneToMany(mappedBy = "reporter")
  private List<EReport> reports;

  @Enumerated(EnumType.STRING)
  @Column(name = "major_type")
  private MajorType major;

  // @OneToMany(mappedBy = "student")
  // private List<EStudentSemesterDetail> studentSemesterDetails;

  @JsonIgnore
  @Column(name = "created_by", nullable = true)
  private String createdBy;

  @JsonIgnore
  @Column(name = "updated_by", nullable = true)
  private String updatedBy;

  @CreationTimestamp
  @Column(name = "created_date", updatable = false)
  private Instant createdDate;

  @UpdateTimestamp
  @Column(name = "updated_date", updatable = true)
  private Instant updatedDate;
}
