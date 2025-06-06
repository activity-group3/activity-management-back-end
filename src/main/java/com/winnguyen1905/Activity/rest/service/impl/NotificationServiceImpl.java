package com.winnguyen1905.Activity.rest.service.impl;

import com.winnguyen1905.Activity.common.annotation.TAccountRequest;
import com.winnguyen1905.Activity.model.dto.NotificationDto;
import com.winnguyen1905.Activity.model.viewmodel.NotificationVm;
import com.winnguyen1905.Activity.model.viewmodel.PagedResponse;
import com.winnguyen1905.Activity.persistance.entity.EAccountCredentials;
import com.winnguyen1905.Activity.persistance.entity.ENotification;
import com.winnguyen1905.Activity.persistance.repository.AccountRepository;
import com.winnguyen1905.Activity.persistance.repository.NotificationRepository;
import com.winnguyen1905.Activity.rest.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {
  private final AccountRepository accountRepository;
  private final NotificationRepository notificationRepository;

  @Override
  public void sendNotification(TAccountRequest accountRequest, NotificationDto notificationDto) {
    ENotification notification = ENotification.builder()
        .title(notificationDto.title())
        .content(notificationDto.content())
        .isRead(false)
        .notificationType(notificationDto.notificationType())
        .receiver(accountRepository.findById(notificationDto.receiverId())
            .orElseGet(null))
        .build();
    notificationRepository.save(notification);
  }

  @Override
  public PagedResponse<NotificationVm> getNotifications(TAccountRequest accountRequest, Pageable pageable) {
    EAccountCredentials account = accountRepository.findById(accountRequest.id())
        .orElseThrow(() -> new RuntimeException("Account not found"));

    // Get notifications ordered by read status and creation date
    Page<ENotification> notificationsPage = notificationRepository.findByReceiverOrderByIsReadAscCreatedAtDesc(account,
        pageable);

    return PagedResponse.<NotificationVm>builder()
        .results(notificationsPage.getContent().stream()
            .map(notification -> NotificationVm.builder()
                .id(notification.getId())
                .title(notification.getTitle())
                .content(notification.getContent())
                .isRead(notification.getIsRead())
                .createdDate(notification.getCreatedDate())
                .build())
            .toList())
        .totalPages(notificationsPage.getTotalPages())
        .totalElements(notificationsPage.getTotalElements())
        .size(notificationsPage.getSize())
        .page(notificationsPage.getNumber())
        .build();
  }

  @Override
  public void readNotification(TAccountRequest accountRequest, Long id) {
    ENotification notification = notificationRepository.findById(id)
        .orElseThrow(() -> new RuntimeException("Notification not found"));
    notification.setIsRead(true);
    notificationRepository.save(notification);
  }

  @Override
  public void deleteNotification(TAccountRequest accountRequest, Long id) {
    ENotification notification = notificationRepository.findById(id)
        .orElseThrow(() -> new RuntimeException("Notification not found"));
    notificationRepository.delete(notification);
  }
}
