package com.winnguyen1905.activity.common.constant;

public enum AccountRole {
  ADMIN("ADMIN"), STUDENT("STUDENT"), ORGANIZATION("ORGANIZATION");

  String role;

  AccountRole(String role) {
    this.role = role;
  }
}
  