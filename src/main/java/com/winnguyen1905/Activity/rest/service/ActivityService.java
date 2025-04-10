package com.winnguyen1905.Activity.rest.service;

import org.springframework.data.domain.Pageable;

import com.winnguyen1905.Activity.common.annotation.TAccountRequest;
import com.winnguyen1905.Activity.model.dto.ActivityDto;
import com.winnguyen1905.Activity.model.dto.ParticipationDetailDto;
import com.winnguyen1905.Activity.model.viewmodel.ActivityVm;
import com.winnguyen1905.Activity.model.viewmodel.PagedResponse;
import com.winnguyen1905.Activity.model.viewmodel.ParticipationDetailVm;

public interface ActivityService {
  void createActivity(TAccountRequest accountRequest, ActivityDto activityDto);
  void updateActivity(TAccountRequest accountRequest, ActivityDto activityDto);
  void deleteActivity(TAccountRequest accountRequest, Long activityId);
  PagedResponse<ActivityVm> getAllActivities(Pageable pageable);
  PagedResponse<ActivityVm> getJoinedActivities(TAccountRequest accountRequest, Pageable pageable);
  ParticipationDetailVm joinActivity(TAccountRequest accountRequest, ParticipationDetailDto participationDetailDto);
  
  // PagedResponse<ActivityVm> getActivitiesByStudent(TAccountRequest accountRequest, Pageable pageable);
  ActivityVm getActivityById(TAccountRequest accountRequest, Long activityId);
  // PagedResponse<ActivityVm> getActivitiesByCategory(TAccountRequest accountRequest, ActivityCategory activityCategory, Pageable pageable);
}
