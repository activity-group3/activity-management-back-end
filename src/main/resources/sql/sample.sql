-- ACCOUNT
use activity;
INSERT INTO `activity`.`account` (
  `id`,
  `status`,
  `created_date`,
  `updated_date`,
  `refresh_token`,
  `created_by`,
  `email`,
  `full_name`,
  `identify_code`,
  `password`,
  `phone`,
  `updated_by`,
  `major_type`,
  `role`
) VALUES (
  FLOOR(RAND() * 20000) + 10,                              -- id (BIGINT, PRIMARY KEY)
  b'1',                           -- status (BIT(1))
  '2025-06-05 10:00:00.000000',   -- created_date (DATETIME(6))
  '2025-06-05 10:00:00.000000',   -- updated_date (DATETIME(6))
  NULL,                           -- refresh_token
  'system',                       -- created_by
  'xx',         -- email
  'John Doe',                     -- full_name
  'ID123456',                     -- identify_code
  'hashed_password_here',         -- password
  '0123456789',                   -- phone
  'system',                       -- updated_by
  'IT',                           -- major_type (ENUM)
  'STUDENT'                       -- role (ENUM)
);



-- ACTIVITY
use activity;

INSERT INTO `activity`.`activity` (
  `id`,
  `attendance_score`,
  `current_participants`,
  `fee`,
  `is_approved`,
  `is_featured`,
  `latitude`,
  `likes`,
  `longitude`,
  -- `contributor_limit`,
  `max_attendees`,
  `created_by_id`,
  `created_date`,
  `end_date`,
  `organization_id`,
  `registration_deadline`,
  `start_date`,
  `updated_by_id`,
  `updated_date`,
  `version`,
  `address`,
  `description`,
  `image_url`,
  `name`,
  `online_link`,
  `short_description`,
  `venue`,
  `category`,
  `status`
) VALUES (
  95775,                                -- id (PRIMARY KEY)
  10,                               -- attendance_score
  5,                                -- current_participants
  100.00,                           -- fee
  b'1',                             -- is_approved (BIT)
  b'0',                             -- is_featured (BIT)
  10.762622,                        -- latitude
  25,                               -- likes
  106.660172,                       -- longitude
  -- 3,                                -- contributor_limit
  50,                               -- max_attendees
  101,                              -- created_by_id  
  '2025-06-05 10:00:00.000000',     -- created_date
  '2025-07-01 17:00:00.000000',     -- end_date
  3,                             -- organization_id
  '2025-06-02 23:59:59.000000',     -- registration_deadline
  '2025-06-15 09:00:00.000000',     -- start_date
  101,                              -- updated_by_id
  '2025-06-05 11:00:00.000000',     -- updated_date
  0,                                -- version
  '123 Main St, HCMC',              -- address
  'This is a full description of the activity. It includes goals and schedule.', -- description
  'https://example.com/image.jpg',  -- image_url
  'Summer Coding Bootcamp',         -- name
  'https://example.com/online',     -- online_link
  'Learn to code in 2 weeks!',      -- short_description
  'Main Campus Hall A',             -- venue
  'UNIVERSITY',                     -- category (ENUM)
  'PUBLISHED'                       -- status (ENUM)
);
