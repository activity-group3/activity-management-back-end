package com.winnguyen1905.activity.model.dto;

import java.time.Instant;
import com.winnguyen1905.activity.common.constant.ParticipationRole;
import com.winnguyen1905.activity.common.constant.ParticipationStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ParticipationSearchParams implements AbstractModel {
    private Long activityId;
    private Long participantId;
    private String participantName;
    private String identifyCode;
    private ParticipationStatus participationStatus;
    private ParticipationRole participationRole;
    private Instant registeredAfter;
    private Instant registeredBefore;
}
