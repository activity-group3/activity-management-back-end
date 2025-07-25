package com.winnguyen1905.activity.model.viewmodel;

import java.time.Instant;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.winnguyen1905.activity.model.dto.AbstractModel;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FeedbackDetailVm implements AbstractModel {
  private Long id;
  private Long activityId;
  private String activityName;
  private Long studentId;
  private String studentName;
  private Double rating;
  private String feedbackDescription;
  @JsonFormat(shape = JsonFormat.Shape.STRING)
  private Instant createdDate;
  private Long participationId;
  private String organizationResponse;
  @JsonFormat(shape = JsonFormat.Shape.STRING)
  private Instant respondedAt;
  private Boolean hasResponse;
}
