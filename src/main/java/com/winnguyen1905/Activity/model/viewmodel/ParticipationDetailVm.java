package com.winnguyen1905.Activity.model.viewmodel;

import java.time.Instant;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.winnguyen1905.Activity.common.constant.ActivityCategory;
import com.winnguyen1905.Activity.common.constant.ActivityStatus;
import com.winnguyen1905.Activity.common.constant.ParticipationRole;
import com.winnguyen1905.Activity.common.constant.ParticipationStatus;
import com.winnguyen1905.Activity.model.dto.AbstractModel;

import lombok.Builder;

@Builder
public record ParticipationDetailVm(
    Long id,
    Long studentId,
    String studentCode,
    Long activityId,
    String activityName,
    ActivityCategory activityCategory,
    String activityVenue, @JsonFormat(shape = JsonFormat.Shape.STRING)

    Instant startDate,
    @JsonFormat(shape = JsonFormat.Shape.STRING)

    Instant endDate,
    @JsonFormat(shape = JsonFormat.Shape.STRING) Instant registrationTime,
    ActivityStatus activityStatus,
    ParticipationStatus participationStatus,
    ParticipationRole participationRole) implements AbstractModel {
}
