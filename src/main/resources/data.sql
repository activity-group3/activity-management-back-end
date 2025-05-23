-- Temporarily disable foreign key checks to allow independent inserts
SET FOREIGN_KEY_CHECKS = 0;

-- Delete existing data
DELETE FROM `activity`.`notification`;
DELETE FROM `activity`.`event_schedule`;
DELETE FROM `activity`.`department`;
DELETE FROM `activity`.`feedback`;
DELETE FROM `activity`.`attendance`;
DELETE FROM `activity`.`activity`;
DELETE FROM `activity`.`organization`;
DELETE FROM `activity`.`account`;
DELETE FROM `activity`.`class`;
DELETE FROM `activity`.`report`;
DELETE FROM `activity`.`student_semester_detail`;

-- -- 1. class table (IDs: 1000-1009)
-- INSERT INTO `activity`.`class` (id, academic_year, capacity, end_date, start_date, created_date, updated_date, class_name, created_by, department, updated_by, status) VALUES
-- (1000, 2024, 30, '2024-12-15', '2024-09-01', NOW(), NOW(), 'CS101', 'admin1', 'Computer Science', 'admin1', 'ACTIVE'),
-- (1001, 2024, 25, '2024-12-15', '2024-09-01', NOW(), NOW(), 'MATH201', 'admin1', 'Mathematics', 'admin1', 'ACTIVE'),
-- (1002, 2024, 35, '2024-12-15', '2024-09-01', NOW(), NOW(), 'PHY101', 'admin1', 'Physics', 'admin1', 'ACTIVE'),
-- (1003, 2024, 30, '2024-12-15', '2024-09-01', NOW(), NOW(), 'CHEM101', 'admin1', 'Chemistry', 'admin1', 'ACTIVE'),
-- (1004, 2024, 28, '2024-12-15', '2024-09-01', NOW(), NOW(), 'BIO101', 'admin1', 'Biology', 'admin1', 'ACTIVE'),
-- (1005, 2023, 30, '2023-12-15', '2023-09-01', NOW(), NOW(), 'CS102', 'admin1', 'Computer Science', 'admin1', 'INACTIVE'),
-- (1006, 2024, 25, '2024-12-15', '2024-09-01', NOW(), NOW(), 'MATH202', 'admin1', 'Mathematics', 'admin1', 'ACTIVE'),
-- (1007, 2024, 30, '2024-12-15', '2024-09-01', NOW(), NOW(), 'PHY102', 'admin1', 'Physics', 'admin1', 'ACTIVE'),
-- (1008, 2024, 35, '2024-12-15', '2024-09-01', NOW(), NOW(), 'CHEM102', 'admin1', 'Chemistry', 'admin1', 'ACTIVE'),
-- (1009, 2024, 30, '2024-12-15', '2024-09-01', NOW(), NOW(), 'BIO102', 'admin1', 'Biology', 'admin1', 'ACTIVE');

-- -- 2. account table (IDs: 1000-1009)
-- INSERT INTO `activity`.`account` (id, is_active, class_id, created_date, updated_date, refresh_token, created_by, email, full_name, password, phone, student_code, updated_by, role) VALUES
-- (1000, b'1', 1000, NOW(), NOW(), 'token1', 'admin1', 'john@university.com', 'John Doe', 'hashedpass1', '1234567890', 'STU001', 'admin1', 'STUDENT'),
-- (1001, b'1', 1000, NOW(), NOW(), 'token2', 'admin1', 'jane@university.com', 'Jane Smith', 'hashedpass2', '1234567891', 'STU002', 'admin1', 'STUDENT'),
-- (1002, b'1', 1001, NOW(), NOW(), 'token3', 'admin1', 'bob@university.com', 'Bob Johnson', 'hashedpass3', '1234567892', 'STU003', 'admin1', 'STUDENT'),
-- (1003, b'1', 1002, NOW(), NOW(), 'token4', 'admin1', 'alice@university.com', 'Alice Brown', 'hashedpass4', '1234567893', 'STU004', 'admin1', 'STUDENT'),
-- (1004, b'1', 1003, NOW(), NOW(), 'token5', 'admin1', 'mike@university.com', 'Mike Wilson', 'hashedpass5', '1234567894', 'STU005', 'admin1', 'STUDENT'),
-- (1005, b'1', NULL, NOW(), NOW(), 'token6', 'system', 'admin@university.com', 'Admin User', 'hashedpass6', '1234567895', NULL, 'system', 'ADMIN'),
-- (1006, b'1', 1004, NOW(), NOW(), 'token7', 'admin1', 'sarah@university.com', 'Sarah Davis', 'hashedpass7', '1234567896', 'STU006', 'admin1', 'STUDENT'),
-- (1007, b'1', 1005, NOW(), NOW(), 'token8', 'admin1', 'tom@university.com', 'Tom Clark', 'hashedpass8', '1234567897', 'STU007', 'admin1', 'STUDENT'),
-- (1008, b'1', 1006, NOW(), NOW(), 'token9', 'admin1', 'emma@university.com', 'Emma White', 'hashedpass9', '1234567898', 'STU008', 'admin1', 'STUDENT'),
-- (1009, b'1', 1007, NOW(), NOW(), 'token10', 'admin1', 'peter@university.com', 'Peter Green', 'hashedpass10', '1234567899', 'STU009', 'admin1', 'STUDENT');

-- -- 3. representative_organizer table (IDs: 1000-1009)
-- INSERT INTO `activity`.`representative_organizer` (id, created_by, created_date, updated_by, updated_date, organization_name, representative_email, representative_name, representative_phone, representative_position) VALUES
-- (1000, 1005, NOW(), 1005, NOW(), 'Student Union', 'union@university.com', 'Mary Johnson', '555-0101', 'President'),
-- (1001, 1005, NOW(), 1005, NOW(), 'Tech Club', 'tech@university.com', 'James Brown', '555-0102', 'Chairperson'),
-- (1002, 1005, NOW(), 1005, NOW(), 'Sports Association', 'sports@university.com', 'Lisa White', '555-0103', 'Director'),
-- (1003, 1005, NOW(), 1005, NOW(), 'Cultural Society', 'culture@university.com', 'David Lee', '555-0104', 'Coordinator'),
-- (1004, 1005, NOW(), 1005, NOW(), 'Science Club', 'science@university.com', 'Emma Davis', '555-0105', 'President'),
-- (1005, 1005, NOW(), 1005, NOW(), 'Music Society', 'music@university.com', 'Tom Wilson', '555-0106', 'Director'),
-- (1006, 1005, NOW(), 1005, NOW(), 'Drama Club', 'drama@university.com', 'Sarah Clark', '555-0107', 'Chairperson'),
-- (1007, 1005, NOW(), 1005, NOW(), 'Art Association', 'art@university.com', 'Mike Green', '555-0108', 'President'),
-- (1008, 1005, NOW(), 1005, NOW(), 'Debate Team', 'debate@university.com', 'Jane Miller', '555-0109', 'Coordinator'),
-- (1009, 1005, NOW(), 1005, NOW(), 'Volunteer Group', 'volunteer@university.com', 'Peter Smith', '555-0110', 'Director');

-- -- 4. activity table (IDs: 1000-1009)
-- INSERT INTO `activity`.`activity` (id, activity_capacity_limit, attendance_score_unit, capacity, created_by_id, created_date, end_date, representative_organizer_id, start_date, updated_by_id, updated_date, version, activity_name, activity_venue, description, activity_category, activity_status) VALUES
-- (1000, '100', 5, 50, 1005, NOW(), '2024-04-15 17:00:00', 1000, '2024-04-15 09:00:00', 1005, NOW(), 1, 'Tech Workshop', 'Room 101', 'Tech skills training', 'STUDENT_ORGANIZATION', 'WAITING_TO_START'),
-- (1001, '200', 3, 100, 1005, NOW(), '2024-04-16 15:00:00', 1001, '2024-04-16 10:00:00', 1005, NOW(), 1, 'Coding Bootcamp', 'Lab A', 'Programming intensive', 'STUDENT_ORGANIZATION', 'WAITING_TO_START'),
-- (1002, '150', 4, 75, 1005, NOW(), '2024-04-17 16:00:00', 1002, '2024-04-17 13:00:00', 1005, NOW(), 1, 'Sports Day', 'Field 1', 'Annual sports event', 'UNIVERSITY', 'WAITING_TO_START'),
-- (1003, '80', 2, 40, 1005, NOW(), '2024-04-18 14:00:00', 1003, '2024-04-18 09:00:00', 1005, NOW(), 1, 'Cultural Fest', 'Hall B', 'Cultural celebration', 'STUDENT_ORGANIZATION', 'WAITING_TO_START'),
-- (1004, '120', 5, 60, 1005, NOW(), '2024-04-19 17:00:00', 1004, '2024-04-19 10:00:00', 1005, NOW(), 1, 'Science Fair', 'Lab B', 'Science exhibition', 'UNIVERSITY', 'WAITING_TO_START'),
-- (1005, '90', 3, 45, 1005, NOW(), '2024-04-20 15:00:00', 1005, '2024-04-20 11:00:00', 1005, NOW(), 1, 'Music Concert', 'Auditorium', 'Live music event', 'STUDENT_ORGANIZATION', 'WAITING_TO_START'),
-- (1006, '110', 4, 55, 1005, NOW(), '2024-04-21 16:00:00', 1006, '2024-04-21 13:00:00', 1005, NOW(), 1, 'Drama Play', 'Theater', 'Theatrical performance', 'STUDENT_ORGANIZATION', 'WAITING_TO_START'),
-- (1007, '70', 2, 35, 1005, NOW(), '2024-04-22 14:00:00', 1007, '2024-04-22 10:00:00', 1005, NOW(), 1, 'Art Exhibition', 'Gallery', 'Art showcase', 'STUDENT_ORGANIZATION', 'WAITING_TO_START'),
-- (1008, '130', 5, 65, 1005, NOW(), '2024-04-23 17:00:00', 1008, '2024-04-23 11:00:00', 1005, NOW(), 1, 'Debate Competition', 'Room 201', 'Debate event', 'UNIVERSITY', 'WAITING_TO_START'),
-- (1009, '100', 3, 50, 1005, NOW(), '2024-04-24 15:00:00', 1009, '2024-04-24 09:00:00', 1005, NOW(), 1, 'Volunteer Drive', 'Campus', 'Community service', 'THIRD_PARTY', 'WAITING_TO_START');

-- -- 5. participation_detail table (IDs: 1000-1009)
-- INSERT INTO `activity`.`participation_detail` (id, activity_id, participant_id, registered_at, created_by, qr_code, participation_role, status) VALUES
-- (1000, 1000, 1000, NOW(), 'admin1', 'QR001', 'PARTICIPANT', 'UNVERIFIED'),
-- (1001, 1000, 1001, NOW(), 'admin1', 'QR002', 'PARTICIPANT', 'UNVERIFIED'),
-- (1002, 1001, 1002, NOW(), 'admin1', 'QR003', 'PARTICIPANT', 'UNVERIFIED'),
-- (1003, 1002, 1003, NOW(), 'admin1', 'QR004', 'PARTICIPANT', 'UNVERIFIED'),
-- (1004, 1003, 1004, NOW(), 'admin1', 'QR005', 'PARTICIPANT', 'UNVERIFIED'),
-- (1005, 1004, 1006, NOW(), 'admin1', 'QR006', 'PARTICIPANT', 'UNVERIFIED'),
-- (1006, 1005, 1007, NOW(), 'admin1', 'QR007', 'PARTICIPANT', 'UNVERIFIED'),
-- (1007, 1006, 1008, NOW(), 'admin1', 'QR008', 'PARTICIPANT', 'UNVERIFIED'),
-- (1008, 1007, 1009, NOW(), 'admin1', 'QR009', 'PARTICIPANT', 'UNVERIFIED'),
-- (1009, 1008, 1000, NOW(), 'admin1', 'QR010', 'CONTRIBUTOR', 'UNVERIFIED');

-- -- 6. confirmation table (IDs: 1000-1009)
-- INSERT INTO `activity`.`confirmation` (id, rating, confirmed_at, confirmed_by_account_id, created_date, feedback_created_at, participation_id, created_by, feedback_description) VALUES
-- (1000, 4.5, NULL, 1005, NOW(), NULL, 1000, 'admin1', NULL),
-- (1001, 4.0, NULL, 1005, NOW(), NULL, 1001, 'admin1', NULL),
-- (1002, 3.5, NULL, 1005, NOW(), NULL, 1002, 'admin1', NULL),
-- (1003, 4.8, NULL, 1005, NOW(), NULL, 1003, 'admin1', NULL),
-- (1004, 4.2, NULL, 1005, NOW(), NULL, 1004, 'admin1', NULL),
-- (1005, 3.8, NULL, 1005, NOW(), NULL, 1005, 'admin1', NULL),
-- (1006, 4.6, NULL, 1005, NOW(), NULL, 1006, 'admin1', NULL),
-- (1007, 4.1, NULL, 1005, NOW(), NULL, 1007, 'admin1', NULL),
-- (1008, 3.9, NULL, 1005, NOW(), NULL, 1008, 'admin1', NULL),
-- (1009, 4.7, NULL, 1005, NOW(), NULL, 1009, 'admin1', NULL);

-- -- 7. event_schedule table (IDs: 1000-1009)
-- INSERT INTO `activity`.`event_schedule` (id, activity_id, created_date, end_time, start_time, updated_date, activity_description, created_by, location, updated_by, status) VALUES
-- (1000, 1000, NOW(), '2024-04-15 12:00:00', '2024-04-15 09:00:00', NOW(), 'Morning Session', 'admin1', 'Room 101', 'admin1', 'WAITING_TO_START'),
-- (1001, 1000, NOW(), '2024-04-15 17:00:00', '2024-04-15 14:00:00', NOW(), 'Afternoon Session', 'admin1', 'Room 101', 'admin1', 'WAITING_TO_START'),
-- (1002, 1001, NOW(), '2024-04-16 12:00:00', '2024-04-16 10:00:00', NOW(), 'Coding Basics', 'admin1', 'Lab A', 'admin1', 'WAITING_TO_START'),
-- (1003, 1002, NOW(), '2024-04-17 16:00:00', '2024-04-17 13:00:00', NOW(), 'Main Event', 'admin1', 'Field 1', 'admin1', 'WAITING_TO_START'),
-- (1004, 1003, NOW(), '2024-04-18 14:00:00', '2024-04-18 09:00:00', NOW(), 'Cultural Show', 'admin1', 'Hall B', 'admin1', 'WAITING_TO_START'),
-- (1005, 1004, NOW(), '2024-04-19 17:00:00', '2024-04-19 10:00:00', NOW(), 'Project Display', 'admin1', 'Lab B', 'admin1', 'WAITING_TO_START'),
-- (1006, 1005, NOW(), '2024-04-20 15:00:00', '2024-04-20 11:00:00', NOW(), 'Concert', 'admin1', 'Auditorium', 'admin1', 'WAITING_TO_START'),
-- (1007, 1006, NOW(), '2024-04-21 16:00:00', '2024-04-21 13:00:00', NOW(), 'Play Performance', 'admin1', 'Theater', 'admin1', 'WAITING_TO_START'),
-- (1008, 1007, NOW(), '2024-04-22 14:00:00', '2024-04-22 10:00:00', NOW(), 'Art Display', 'admin1', 'Gallery', 'admin1', 'WAITING_TO_START'),
-- (1009, 1008, NOW(), '2024-04-23 17:00:00', '2024-04-23 11:00:00', NOW(), 'Debate Rounds', 'admin1', 'Room 201', 'admin1', 'WAITING_TO_START');

-- -- 8. notification table (IDs: 1000-1009)
-- INSERT INTO `activity`.`notification` (id, created_date, receiver_id, sender_id, created_by, message, notification_type) VALUES
-- (1000, NOW(), 1000, 1005, 'admin1', 'Tech Workshop registration confirmed', 'ACTIVITY'),
-- (1001, NOW(), 1001, 1005, 'admin1', 'Tech Workshop registration confirmed', 'ACTIVITY'),
-- (1002, NOW(), 1002, 1005, 'admin1', 'Coding Bootcamp registration confirmed', 'ACTIVITY'),
-- (1003, NOW(), 1003, 1005, 'admin1', 'Sports Day registration confirmed', 'ACTIVITY'),
-- (1004, NOW(), 1004, 1005, 'admin1', 'Cultural Fest registration confirmed', 'ACTIVITY'),
-- (1005, NOW(), 1006, 1005, 'admin1', 'Science Fair registration confirmed', 'ACTIVITY'),
-- (1006, NOW(), 1007, 1005, 'admin1', 'Music Concert registration confirmed', 'ACTIVITY'),
-- (1007, NOW(), 1008, 1005, 'admin1', 'Drama Play registration confirmed', 'ACTIVITY'),
-- (1008, NOW(), 1009, 1005, 'admin1', 'Art Exhibition registration confirmed', 'ACTIVITY'),
-- (1009, NOW(), 1000, 1005, 'admin1', 'Debate Competition role assigned', 'ACTIVITY');

-- -- 9. report table (IDs: 1000-1009)
-- INSERT INTO `activity`.`report` (id, activity_id, created_date, reporter_id, created_by, description) VALUES
-- (1000, 1000, NOW(), 1000, 'john@university.com', 'Need more seats'),
-- (1001, 1001, NOW(), 1001, 'jane@university.com', 'Equipment request'),
-- (1002, 1002, NOW(), 1002, 'bob@university.com', 'Timing conflict'),
-- (1003, 1003, NOW(), 1003, 'alice@university.com', 'Venue concern'),
-- (1004, 1004, NOW(), 1004, 'mike@university.com', 'Resource request'),
-- (1005, 1005, NOW(), 1006, 'sarah@university.com', 'Staffing issue'),
-- (1006, 1006, NOW(), 1007, 'tom@university.com', 'Schedule change'),
-- (1007, 1007, NOW(), 1008, 'emma@university.com', 'Budget concern'),
-- (1008, 1008, NOW(), 1009, 'peter@university.com', 'Equipment need'),
-- (1009, 1009, NOW(), 1000, 'john@university.com', 'Volunteer request');

-- -- 10. student_semester_detail table (IDs: 1000-1009)
-- INSERT INTO `activity`.`student_semester_detail` (id, attendance_score, gpa, created_date, student_id, updated_date, created_by, updated_by) VALUES
-- (1000, 85.5, 3.7, NOW(), 1000, NOW(), 'admin1', 'admin1'),
-- (1001, 92.0, 3.9, NOW(), 1001, NOW(), 'admin1', 'admin1'),
-- (1002, 78.5, 3.4, NOW(), 1002, NOW(), 'admin1', 'admin1'),
-- (1003, 88.0, 3.6, NOW(), 1003, NOW(), 'admin1', 'admin1'),
-- (1004, 95.0, 4.0, NOW(), 1004, NOW(), 'admin1', 'admin1'),
-- (1005, 82.5, 3.5, NOW(), 1006, NOW(), 'admin1', 'admin1'),
-- (1006, 90.0, 3.8, NOW(), 1007, NOW(), 'admin1', 'admin1'),
-- (1007, 87.5, 3.7, NOW(), 1008, NOW(), 'admin1', 'admin1'),
-- (1008, 83.0, 3.6, NOW(), 1009, NOW(), 'admin1', 'admin1'),
-- (1009, 91.5, 3.9, NOW(), 1000, NOW(), 'admin1', 'admin1');

-- -- Re-enable foreign key checks
-- SET FOREIGN_KEY_CHECKS = 1;
