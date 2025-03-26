package com.winnguyen1905.Activity.common.constant;

public enum ClassStatus {
    ACTIVE("ACTIVE"), INACTIVE("INACTIVE");

    private final String status;

    ClassStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }
} 
