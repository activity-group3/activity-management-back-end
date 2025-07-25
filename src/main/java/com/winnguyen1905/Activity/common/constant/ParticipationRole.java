package com.winnguyen1905.activity.common.constant;

public enum ParticipationRole {
  PARTICIPANT("PARTICIPANT"), CONTRIBUTOR("CONTRIBUTOR");

  private final String role;

  ParticipationRole(String role) {
    this.role = role;
  }

  public String getRole() {
    return role;
  }
}
