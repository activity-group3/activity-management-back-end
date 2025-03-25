package com.winnguyen1905.Activity.common.annotation;

import java.io.Serializable;
import java.util.UUID;

import com.winnguyen1905.Activity.common.constant.AccountRole;

import lombok.Builder;

@Builder
public record TAccountRequest(
    UUID id,
    AccountRole role,
    UUID socketClientId) implements Serializable {
}
