package com.winnguyen1905.Activity.rest.service;

import com.winnguyen1905.Activity.common.annotation.TAccountRequest;
import com.winnguyen1905.Activity.model.dto.NotificationDto;
import com.winnguyen1905.Activity.model.viewmodel.NotificationVm;
import com.winnguyen1905.Activity.model.viewmodel.PagedResponse;

import org.springframework.data.domain.Pageable;

public interface NotificationService {
  void sendNotification(TAccountRequest accountRequest, NotificationDto notificationDto);
  PagedResponse<NotificationVm> getNotifications(TAccountRequest accountRequest, Pageable pageable);
  void readNotification(TAccountRequest accountRequest, Long id);
  void deleteNotification(TAccountRequest accountRequest, Long id);
}
