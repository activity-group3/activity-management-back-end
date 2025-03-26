package com.winnguyen1905.Activity.common.constant;

public enum ParticipationStatus {
    UNVERIFIED("UNVERIFIED"), VERIFIED("VERIFIED");

    private final String status;

    ParticipationStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }
} 