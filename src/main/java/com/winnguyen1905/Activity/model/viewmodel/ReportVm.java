package com.winnguyen1905.Activity.model.viewmodel;

import java.time.Instant;

import com.winnguyen1905.Activity.common.constant.ReportType;
import com.winnguyen1905.Activity.model.dto.AbstractModel;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportVm implements AbstractModel{
    private Long id;
    private ReportType reportType;
    private Long reportedObjectId;
    private String title;
    private String description;
    private Long reporterId;
    private String reporterName;
    private Instant createdDate;
}
