package com.winnguyen1905.Activity.model.dto;

import java.time.Instant;

import com.winnguyen1905.Activity.common.constant.ActivityCategory;
import com.winnguyen1905.Activity.common.constant.ActivityStatus;
import com.winnguyen1905.Activity.common.constant.ParticipationRole;
import com.winnguyen1905.Activity.common.constant.ParticipationStatus;

public record ParticipationDetailSearch(
    Long participantId,
    ParticipationStatus participationStatus,
    ParticipationRole participationRole,
    Instant registeredAfter,
    Instant registeredBefore) {
}
