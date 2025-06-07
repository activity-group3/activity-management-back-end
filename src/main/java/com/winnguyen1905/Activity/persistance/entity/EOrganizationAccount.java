package com.winnguyen1905.Activity.persistance.entity;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.winnguyen1905.Activity.common.annotation.AccountRequest;
import com.winnguyen1905.Activity.common.annotation.TAccountRequest;
import com.winnguyen1905.Activity.common.constant.OrganizationType;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.OneToMany;
import jakarta.persistence.PrimaryKeyJoinColumn;
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
@Table(name = "organization")
@PrimaryKeyJoinColumn(name = "id")
public class EOrganizationAccount extends EAccountCredentials {
  @Column(name = "org_name")
  private String name;

  @Column(name = "org_phone")
  private String phone;

  @Column(name = "org_email")
  private String email;

  @Enumerated(EnumType.STRING)
  @Column(name = "org_type")
  private OrganizationType type;

  @Column(name = "org_description")
  private String description;

  public String getOrganizationName() {
    return name;
  }

  public OrganizationType getOrganizationType() {
    return type;
  }

  @OneToMany(mappedBy = "organization")
  private List<EActivity> activities;
}
