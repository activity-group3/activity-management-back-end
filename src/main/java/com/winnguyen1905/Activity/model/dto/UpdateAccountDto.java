package com.winnguyen1905.Activity.model.dto;

import com.winnguyen1905.Activity.common.constant.MajorType;
import com.winnguyen1905.Activity.common.constant.OrganizationType;

public record UpdateAccountDto(
    Long id,
    String phone,
    String email,
    String fullName,
    MajorType major,
    String organizationName,
    OrganizationType organizationType,
    String taxCode) implements AbstractModel {

}
