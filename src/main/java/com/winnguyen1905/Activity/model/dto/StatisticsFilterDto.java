package com.winnguyen1905.activity.model.dto;

import java.time.Instant;

import com.winnguyen1905.activity.common.constant.ActivityCategory;
import com.winnguyen1905.activity.common.constant.ActivityStatus;
import com.winnguyen1905.activity.common.constant.TimePeriod;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StatisticsFilterDto implements AbstractModel {
    // Time filter
    private TimePeriod timePeriod;
    private Instant startDate;
    private Instant endDate;

    // Category filter
    private ActivityCategory activityType;

    // Status filter
    private ActivityStatus status;
}
