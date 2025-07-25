-- Account Management Stored Procedures and Triggers
USE activity;
DELIMITER //

-- Drop all existing procedures and triggers first
-- Account Procedures
DROP PROCEDURE IF EXISTS get_account_statistics_by_role//
DROP PROCEDURE IF EXISTS get_student_statistics_by_major//
DROP PROCEDURE IF EXISTS get_account_participation_stats//
DROP PROCEDURE IF EXISTS get_account_activity_metrics//

-- Account Triggers
DROP TRIGGER IF EXISTS before_account_insert_email//
DROP TRIGGER IF EXISTS before_account_insert_phone//
DROP TRIGGER IF EXISTS before_account_insert_identify//
DROP TRIGGER IF EXISTS before_account_insert_email_unique//
DROP TRIGGER IF EXISTS before_account_insert_identify_unique//
DROP TRIGGER IF EXISTS before_account_insert_role//

-- Activity Procedures
DROP PROCEDURE IF EXISTS update_activity_status//
DROP PROCEDURE IF EXISTS calculate_activity_statistics//
DROP PROCEDURE IF EXISTS get_organization_metrics//
DROP PROCEDURE IF EXISTS get_activity_trends//

-- Activity Triggers
DROP TRIGGER IF EXISTS before_activity_insert//
DROP TRIGGER IF EXISTS after_activity_date_update//

-- Schedule Procedures
DROP PROCEDURE IF EXISTS get_schedule_statistics_by_status//
DROP PROCEDURE IF EXISTS check_schedule_conflicts//
DROP PROCEDURE IF EXISTS get_schedule_statistics_by_period//

-- Schedule Triggers
DROP TRIGGER IF EXISTS before_schedule_insert_time_validation//
DROP TRIGGER IF EXISTS before_schedule_insert_overlap_check//
DROP TRIGGER IF EXISTS after_schedule_status_update//

-- Notification Procedures
DROP PROCEDURE IF EXISTS get_notification_statistics_by_type//
DROP PROCEDURE IF EXISTS get_user_notification_metrics//
DROP PROCEDURE IF EXISTS get_notification_engagement_metrics//

-- Notification Triggers
DROP TRIGGER IF EXISTS before_notification_insert_type_validation//
DROP TRIGGER IF EXISTS before_notification_insert_default_read//
DROP TRIGGER IF EXISTS before_notification_insert_duplicate_check//

-- Report Procedures
DROP PROCEDURE IF EXISTS get_report_statistics_by_type//
DROP PROCEDURE IF EXISTS get_reporter_statistics//
DROP PROCEDURE IF EXISTS get_reported_object_statistics//

-- Report Triggers
DROP TRIGGER IF EXISTS before_report_insert_type_validation//
DROP TRIGGER IF EXISTS before_report_insert_duplicate_check//
DROP TRIGGER IF EXISTS before_report_insert_object_validation//

-- Now create all procedures and triggers

-- 1. Account Statistics Procedures
CREATE PROCEDURE get_account_statistics_by_role()
READS SQL DATA
BEGIN
    SELECT 
        role,
        COUNT(*) as total_accounts,
        SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_accounts,
        SUM(CASE WHEN is_active = 0 THEN 1 ELSE 0 END) as inactive_accounts,
        COUNT(DISTINCT major_type) as unique_majors
    FROM account
    GROUP BY role;
END//

CREATE PROCEDURE get_student_statistics_by_major()
BEGIN
    SELECT 
        major_type,
        COUNT(*) as total_students,
        SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_students,
        COUNT(DISTINCT identify_code) as unique_identities
    FROM account
    WHERE role = 'STUDENT'
    GROUP BY major_type;
END//

CREATE PROCEDURE get_account_participation_stats(
    IN p_start_date TIMESTAMP,
    IN p_end_date TIMESTAMP
)
BEGIN
    SELECT 
        a.role,
        COUNT(DISTINCT a.id) as total_accounts,
        COUNT(DISTINCT pd.id) as total_participations,
        COUNT(DISTINCT CASE WHEN pd.created_date BETWEEN p_start_date AND p_end_date THEN pd.id END) as new_participations,
        COALESCE(AVG(pd_count.participation_count), 0) as avg_participations_per_account
    FROM account a
    LEFT JOIN participation_detail pd ON a.id = pd.participant_id
    LEFT JOIN (
        SELECT participant_id, COUNT(*) as participation_count
        FROM participation_detail
        GROUP BY participant_id
    ) pd_count ON a.id = pd_count.participant_id
    GROUP BY a.role;
END//

CREATE PROCEDURE get_account_activity_metrics(
    IN p_account_id BIGINT
)
BEGIN
    SELECT 
        COUNT(DISTINCT pd.id) as total_participations,
        COUNT(DISTINCT n.id) as total_notifications,
        COUNT(DISTINCT r.id) as total_reports,
        COUNT(DISTINCT CASE WHEN pd.created_date >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 30 DAY) THEN pd.id END) as recent_participations,
        COUNT(DISTINCT CASE WHEN n.created_date >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 30 DAY) THEN n.id END) as recent_notifications
    FROM account a
    LEFT JOIN participation_detail pd ON a.id = pd.participant_id
    LEFT JOIN notification n ON a.id = n.receiver_id
    LEFT JOIN report r ON a.id = r.reporter_id
    WHERE a.id = p_account_id;
END//

-- Account Triggers
CREATE TRIGGER before_account_insert_email
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    IF NEW.email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid email format';
    END IF;
END//

CREATE TRIGGER before_account_insert_phone
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    IF NEW.phone NOT REGEXP '^[0-9]{10,15}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid phone number format';
    END IF;
END//

CREATE TRIGGER before_account_insert_identify
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    IF NEW.identify_code NOT REGEXP '^[A-Za-z0-9]{8,20}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid identify code format';
    END IF;
END//

CREATE TRIGGER before_account_insert_email_unique
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    DECLARE email_count INT DEFAULT 0;
    SELECT COUNT(*) INTO email_count FROM account WHERE email = NEW.email;
    IF email_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email already exists';
    END IF;
END//

CREATE TRIGGER before_account_insert_identify_unique
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    DECLARE identify_count INT DEFAULT 0;
    SELECT COUNT(*) INTO identify_count FROM account WHERE identify_code = NEW.identify_code;
    IF identify_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Identify code already exists';
    END IF;
END//

CREATE TRIGGER before_account_insert_role
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    IF NEW.role = 'STUDENT' AND NEW.major_type IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student accounts must have a major type';
    END IF;
    
    IF NEW.role = 'ORGANIZATION' AND NEW.major_type IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Organization accounts cannot have a major type';
    END IF;
END//

-- Activity Management Stored Procedures and Triggers
CREATE PROCEDURE update_activity_status()
BEGIN
    UPDATE activity 
    SET status = 'IN_PROGRESS'
    WHERE start_date <= CURRENT_TIMESTAMP 
    AND end_date > CURRENT_TIMESTAMP
    AND status = 'PUBLISHED';

    UPDATE activity 
    SET status = 'COMPLETED'
    WHERE end_date < CURRENT_TIMESTAMP
    AND status IN ('PUBLISHED', 'IN_PROGRESS');
END//

CREATE PROCEDURE calculate_activity_statistics(
    IN p_start_date TIMESTAMP,
    IN p_end_date TIMESTAMP
)
BEGIN
    SELECT 
        a.activity_category,
        COUNT(*) as total_activities,
        SUM(a.current_participants) as total_participants,
        AVG(a.current_participants) as avg_participants,
        SUM(a.capacity_limit) as total_capacity,
        CASE 
            WHEN SUM(a.capacity_limit) = 0 THEN 0
            ELSE (SUM(a.current_participants) * 100.0 / SUM(a.capacity_limit))
        END as participation_rate
    FROM activity a
    WHERE a.start_date BETWEEN p_start_date AND p_end_date
    GROUP BY a.activity_category;
END//

CREATE PROCEDURE get_organization_metrics(
    IN p_organization_id BIGINT,
    IN p_start_date TIMESTAMP,
    IN p_end_date TIMESTAMP
)
BEGIN
    SELECT 
        COUNT(*) as total_activities,
        SUM(a.current_participants) as total_participants,
        AVG(a.current_participants) as avg_participants_per_activity,
        SUM(a.capacity_limit) as total_capacity,
        CASE 
            WHEN SUM(a.capacity_limit) = 0 THEN 0
            ELSE (SUM(a.current_participants) * 100.0 / SUM(a.capacity_limit))
        END as overall_participation_rate,
        COUNT(CASE WHEN a.status = 'COMPLETED' THEN 1 END) as completed_activities,
        COUNT(CASE WHEN a.status = 'IN_PROGRESS' THEN 1 END) as ongoing_activities,
        COUNT(CASE WHEN a.status = 'PUBLISHED' THEN 1 END) as upcoming_activities
    FROM activity a
    WHERE a.organization_id = p_organization_id
    AND a.start_date BETWEEN p_start_date AND p_end_date;
END//

CREATE PROCEDURE get_activity_trends(
    IN p_start_date TIMESTAMP,
    IN p_end_date TIMESTAMP
)
BEGIN
    SELECT 
        DATE_FORMAT(start_date, '%Y-%m') as month,
        activity_category,
        COUNT(*) as activity_count,
        SUM(current_participants) as total_participants,
        AVG(current_participants) as avg_participants
    FROM activity
    WHERE start_date BETWEEN p_start_date AND p_end_date
    GROUP BY DATE_FORMAT(start_date, '%Y-%m'), activity_category
    ORDER BY month, activity_category;
END//

-- Activity Triggers
CREATE TRIGGER before_activity_insert
BEFORE INSERT ON activity
FOR EACH ROW
BEGIN
    IF NEW.start_date >= NEW.end_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Start date must be before end date';
    END IF;
    
    IF NEW.registration_deadline >= NEW.start_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Registration deadline must be before start date';
    END IF;
END//

CREATE TRIGGER after_activity_date_update
AFTER UPDATE ON activity
FOR EACH ROW
BEGIN
    IF NEW.start_date != OLD.start_date OR NEW.end_date != OLD.end_date THEN
        INSERT INTO activity_log (activity_id, change_type, change_date) 
        VALUES (NEW.id, 'DATE_UPDATED', NOW())
        ON DUPLICATE KEY UPDATE change_date = NOW();
    END IF;
END//

-- Activity Schedule Management Stored Procedures and Triggers
CREATE PROCEDURE get_schedule_statistics_by_status()
BEGIN
    SELECT 
        status,
        COUNT(*) as total_schedules,
        COUNT(DISTINCT activity_id) as unique_activities,
        AVG(TIMESTAMPDIFF(HOUR, start_time, end_time)) as avg_duration_hours
    FROM event_schedule
    GROUP BY status;
END//

CREATE PROCEDURE check_schedule_conflicts(
    IN p_activity_id BIGINT,
    IN p_start_time TIMESTAMP,
    IN p_end_time TIMESTAMP
)
BEGIN
    SELECT 
        es.id,
        es.activity_id,
        es.start_time,
        es.end_time,
        es.location
    FROM event_schedule es
    WHERE es.activity_id != p_activity_id
    AND es.status != 'CANCELLED'
    AND (
        (p_start_time BETWEEN es.start_time AND es.end_time)
        OR (p_end_time BETWEEN es.start_time AND es.end_time)
        OR (es.start_time BETWEEN p_start_time AND p_end_time)
    );
END//

CREATE PROCEDURE get_schedule_statistics_by_period(
    IN p_period VARCHAR(10),
    IN p_start_date TIMESTAMP,
    IN p_end_date TIMESTAMP
)
BEGIN
    SELECT 
        DATE_FORMAT(start_time, 
            CASE p_period
                WHEN 'DAY' THEN '%Y-%m-%d'
                WHEN 'WEEK' THEN '%Y-%u'
                WHEN 'MONTH' THEN '%Y-%m'
                WHEN 'QUARTER' THEN '%Y-%q'
                WHEN 'YEAR' THEN '%Y'
                ELSE '%Y-%m-%d'
            END
        ) as period,
        COUNT(*) as total_schedules,
        COUNT(DISTINCT activity_id) as unique_activities,
        COUNT(CASE WHEN status = 'COMPLETED' THEN id END) as completed_schedules,
        COUNT(CASE WHEN status = 'CANCELLED' THEN id END) as cancelled_schedules,
        AVG(TIMESTAMPDIFF(HOUR, start_time, end_time)) as avg_duration_hours
    FROM event_schedule
    WHERE start_time BETWEEN p_start_date AND p_end_date
    GROUP BY period
    ORDER BY period;
END//

-- Activity Schedule Triggers
CREATE TRIGGER before_schedule_insert_time_validation
BEFORE INSERT ON event_schedule
FOR EACH ROW
BEGIN
    IF NEW.start_time >= NEW.end_time THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'End time must be after start time';
    END IF;
END//

CREATE TRIGGER before_schedule_insert_overlap_check
BEFORE INSERT ON event_schedule
FOR EACH ROW
BEGIN
    DECLARE overlap_count INT DEFAULT 0;
    SELECT COUNT(*) INTO overlap_count
    FROM event_schedule
    WHERE activity_id = NEW.activity_id
    AND status != 'CANCELLED'
    AND (
        (NEW.start_time BETWEEN start_time AND end_time)
        OR (NEW.end_time BETWEEN start_time AND end_time)
        OR (start_time BETWEEN NEW.start_time AND NEW.end_time)
    );
    
    IF overlap_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Schedule overlaps with existing schedule for this activity';
    END IF;
END//

CREATE TRIGGER after_schedule_status_update
AFTER UPDATE ON event_schedule
FOR EACH ROW
BEGIN
    IF NEW.status != OLD.status THEN
        UPDATE activity a
        SET a.status = 
            CASE 
                WHEN EXISTS (
                    SELECT 1 FROM event_schedule 
                    WHERE activity_id = a.id 
                    AND status = 'IN_PROGRESS'
                ) THEN 'IN_PROGRESS'
                WHEN EXISTS (
                    SELECT 1 FROM event_schedule 
                    WHERE activity_id = a.id 
                    AND status = 'WAITING_TO_START'
                ) THEN 'WAITING_TO_START'
                WHEN NOT EXISTS (
                    SELECT 1 FROM event_schedule 
                    WHERE activity_id = a.id 
                    AND status IN ('IN_PROGRESS', 'WAITING_TO_START')
                ) THEN 'COMPLETED'
                ELSE a.status
            END
        WHERE a.id = NEW.activity_id;
    END IF;
END//

-- Notification Management Stored Procedures and Triggers
CREATE PROCEDURE get_notification_statistics_by_type()
BEGIN
    SELECT 
        notification_type,
        COUNT(*) as total_notifications,
        COUNT(DISTINCT receiver_id) as unique_receivers,
        SUM(CASE WHEN is_read = 1 THEN 1 ELSE 0 END) as read_count,
        SUM(CASE WHEN is_read = 0 THEN 1 ELSE 0 END) as unread_count,
        AVG(TIMESTAMPDIFF(HOUR, created_date, NOW())) as avg_age_hours
    FROM notification
    GROUP BY notification_type;
END//

CREATE PROCEDURE get_user_notification_metrics(
    IN p_user_id BIGINT,
    IN p_start_date TIMESTAMP,
    IN p_end_date TIMESTAMP
)
BEGIN
    SELECT 
        COUNT(*) as total_notifications,
        SUM(CASE WHEN is_read = 1 THEN 1 ELSE 0 END) as read_count,
        SUM(CASE WHEN is_read = 0 THEN 1 ELSE 0 END) as unread_count,
        AVG(TIMESTAMPDIFF(HOUR, created_date, NOW())) as avg_response_time_hours,
        COUNT(DISTINCT notification_type) as notification_types_received
    FROM notification
    WHERE receiver_id = p_user_id
    AND created_date BETWEEN p_start_date AND p_end_date;
END//

CREATE PROCEDURE get_notification_engagement_metrics(
    IN p_notification_type VARCHAR(20)
)
BEGIN
    SELECT 
        DATE_FORMAT(created_date, '%Y-%m-%d') as date,
        COUNT(*) as total_sent,
        SUM(CASE WHEN is_read = 1 THEN 1 ELSE 0 END) as read_count,
        AVG(TIMESTAMPDIFF(HOUR, created_date, 
            CASE WHEN is_read = 1 THEN updated_date ELSE NOW() END
        )) as avg_read_time_hours
    FROM notification
    WHERE notification_type = p_notification_type
    GROUP BY DATE_FORMAT(created_date, '%Y-%m-%d')
    ORDER BY date DESC;
END//

-- Notification Triggers
CREATE TRIGGER before_notification_insert_type_validation
BEFORE INSERT ON notification
FOR EACH ROW
BEGIN
    IF NEW.notification_type NOT IN ('ACTIVITY', 'LEARNING', 'SECURITY') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid notification type';
    END IF;
END//

CREATE TRIGGER before_notification_insert_default_read
BEFORE INSERT ON notification
FOR EACH ROW
BEGIN
    IF NEW.is_read IS NULL THEN
        SET NEW.is_read = 0;
    END IF;
END//

CREATE TRIGGER before_notification_insert_duplicate_check
BEFORE INSERT ON notification
FOR EACH ROW
BEGIN
    DECLARE duplicate_count INT DEFAULT 0;
    SELECT COUNT(*) INTO duplicate_count
    FROM notification
    WHERE receiver_id = NEW.receiver_id
    AND notification_type = NEW.notification_type
    AND content = NEW.content
    AND created_date > DATE_SUB(NOW(), INTERVAL 1 HOUR);
    
    IF duplicate_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duplicate notification detected within the last hour';
    END IF;
END//

-- Report Management Stored Procedures and Triggers
CREATE PROCEDURE get_report_statistics_by_type()
BEGIN
    SELECT 
        report_type,
        COUNT(*) as total_reports,
        COUNT(DISTINCT reporter_id) as unique_reporters,
        COUNT(DISTINCT reported_object_id) as unique_reported_objects,
        AVG(TIMESTAMPDIFF(HOUR, created_date, NOW())) as avg_age_hours
    FROM report
    GROUP BY report_type;
END//

CREATE PROCEDURE get_reporter_statistics(
    IN p_start_date TIMESTAMP,
    IN p_end_date TIMESTAMP
)
BEGIN
    SELECT 
        r.reporter_id,
        COUNT(*) as total_reports,
        COUNT(DISTINCT r.report_type) as report_types_used,
        COUNT(DISTINCT r.reported_object_id) as unique_objects_reported,
        AVG(TIMESTAMPDIFF(HOUR, r.created_date, NOW())) as avg_report_age_hours
    FROM report r
    WHERE r.created_date BETWEEN p_start_date AND p_end_date
    GROUP BY r.reporter_id;
END//

CREATE PROCEDURE get_reported_object_statistics(
    IN p_report_type VARCHAR(20)
)
BEGIN
    SELECT 
        reported_object_id,
        COUNT(*) as report_count,
        COUNT(DISTINCT reporter_id) as unique_reporters,
        MIN(created_date) as first_report_date,
        MAX(created_date) as last_report_date,
        AVG(TIMESTAMPDIFF(HOUR, created_date, NOW())) as avg_report_age_hours
    FROM report
    WHERE report_type = p_report_type
    GROUP BY reported_object_id
    HAVING report_count > 1
    ORDER BY report_count DESC;
END//

-- Report Triggers
CREATE TRIGGER before_report_insert_type_validation
BEFORE INSERT ON report
FOR EACH ROW
BEGIN
    IF NEW.report_type NOT IN ('ACTIVITY', 'USER', 'ORGANIZATION') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid report type';
    END IF;
END//

CREATE TRIGGER before_report_insert_duplicate_check
BEFORE INSERT ON report
FOR EACH ROW
BEGIN
    DECLARE duplicate_count INT DEFAULT 0;
    SELECT COUNT(*) INTO duplicate_count
    FROM report
    WHERE reporter_id = NEW.reporter_id
    AND report_type = NEW.report_type
    AND reported_object_id = NEW.reported_object_id
    AND created_date > DATE_SUB(NOW(), INTERVAL 24 HOUR);
    
    IF duplicate_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duplicate report detected within the last 24 hours';
    END IF;
END//

CREATE TRIGGER before_report_insert_object_validation
BEFORE INSERT ON report
FOR EACH ROW
BEGIN
    DECLARE object_exists INT DEFAULT 0;
    
    CASE NEW.report_type
        WHEN 'ACTIVITY' THEN
            SELECT COUNT(*) INTO object_exists FROM activity WHERE id = NEW.reported_object_id;
        WHEN 'USER' THEN
            SELECT COUNT(*) INTO object_exists FROM account WHERE id = NEW.reported_object_id;
        WHEN 'ORGANIZATION' THEN
            SELECT COUNT(*) INTO object_exists FROM account WHERE id = NEW.reported_object_id AND role = 'ORGANIZATION';
    END CASE;
    
    IF object_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reported object does not exist';
    END IF;
END//

DELIMITER ;
