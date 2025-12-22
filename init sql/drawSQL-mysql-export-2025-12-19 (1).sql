CREATE TABLE `Grades`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `CourseID` BIGINT NOT NULL,
    `score` FLOAT(53) NOT NULL,
    `max_score` INT NOT NULL,
    `weight` FLOAT(53) NULL,
    `catagory` VARCHAR(20) NOT NULL,
    `term` VARCHAR(10) NOT NULL,
    `year` VARCHAR(20) NOT NULL,
    `comment` VARCHAR(30) NULL,
    `tags` JSON NULL,
    `assesment_date` DATE NULL,
    `assesment_duration` TIMESTAMP NULL,
    `answer_cards` BIGINT NULL,
    `UserID` BIGINT NOT NULL
);
CREATE TABLE `Cards`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Question` VARCHAR(30) NOT NULL,
    `Answer` JSON NOT NULL,
    `Choice` BOOLEAN NOT NULL,
    `Choices` JSON NOT NULL
);
CREATE TABLE `Study plans`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `cards` JSON NOT NULL,
    `course` VARCHAR(20) NOT NULL,
    `results` JSON NOT NULL,
    `catagory` VARCHAR(20) NOT NULL,
    `notes` JSON NOT NULL,
    `UserID` BIGINT NOT NULL,
    `Private` BOOLEAN NOT NULL
);
ALTER TABLE
    `Study plans` ADD INDEX `study plans_private_index`(`Private`);
CREATE TABLE `Card groups`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20) NOT NULL,
    `cards` JSON NOT NULL,
    `courses` VARCHAR(20) NOT NULL,
    `tags` JSON NOT NULL,
    `UserID` BIGINT NOT NULL
);
CREATE TABLE `Assignments`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Title` VARCHAR(255) NULL,
    `CourseID` BIGINT NOT NULL,
    `Assignment` TEXT NOT NULL,
    `DateSubmitted` DATETIME NULL,
    `Deadline` DATETIME NULL,
    `Status` VARCHAR(20) NULL,
    `Points` BIGINT NOT NULL,
    `PointsPossible` BIGINT NOT NULL,
    `Course` BIGINT NULL,
    `Weight` BIGINT NOT NULL,
    `Catagory` BIGINT NULL
);
CREATE TABLE `Courses`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20) NOT NULL,
    `description` TEXT NULL,
    `catagory` VARCHAR(20) NULL,
    `assesment_check_list` JSON NOT NULL DEFAULT '"[]"',
    `assignments` JSON NULL DEFAULT '"[]"',
    `projects` JSON NULL
);
CREATE TABLE `Notes`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(50) NOT NULL,
    `note` MULTILINESTRING NULL,
    `CourseID` BIGINT NULL,
    `description` TEXT NULL,
    `tags` JSON NULL,
    `unit` VARCHAR(20) NULL,
    `catagory` VARCHAR(255) NULL
);
CREATE TABLE `Users`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(20) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `created_at` DATETIME NOT NULL,
    `updated_at` DATETIME NOT NULL,
    `history` JSON NOT NULL,
    `last_login` DATETIME NOT NULL,
    `is_verified` BOOLEAN NOT NULL,
    `verified_at` DATETIME NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `first_name` VARCHAR(255) NOT NULL,
    `last_name` VARCHAR(255) NULL,
    `Data` JSON NOT NULL
);
ALTER TABLE
    `Users` ADD UNIQUE `users_username_unique`(`username`);
ALTER TABLE
    `Users` ADD UNIQUE `users_email_unique`(`email`);
CREATE TABLE `users-alt`(
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(255) NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `username` VARCHAR(50) NULL,
    `phone` VARCHAR(20) NULL,
    `two_factor_secret` VARCHAR(255) NULL,
    `security_question_1` VARCHAR(255) NULL,
    `security_answer_1_hash` VARCHAR(255) NULL,
    `security_question_2` VARCHAR(255) NULL,
    `security_answer_2_hash` VARCHAR(255) NULL,
    `sso_provider` VARCHAR(50) NULL,
    `sso_provider_id` VARCHAR(255) NULL,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `middle_name` VARCHAR(100) NULL,
    `date_of_birth` DATE NULL,
    `gender` VARCHAR(50) NULL,
    `profile_photo_url` VARCHAR(500) NULL,
    `bio` TEXT NULL,
    `pronouns` VARCHAR(50) NULL,
    `email_secondary` VARCHAR(255) NULL,
    `phone_secondary` VARCHAR(20) NULL,
    `country` VARCHAR(100) NULL,
    `state_province` VARCHAR(100) NULL,
    `city` VARCHAR(100) NULL,
    `postal_code` VARCHAR(20) NULL,
    `address_line_1` VARCHAR(255) NULL,
    `address_line_2` VARCHAR(255) NULL,
    `time_zone` VARCHAR(50) NULL,
    `is_active` BOOLEAN NULL DEFAULT 'DEFAULT TRUE',
    `is_verified` BOOLEAN NULL DEFAULT 'DEFAULT FALSE',
    `email_verified_at` TIMESTAMP NULL,
    `phone_verified_at` TIMESTAMP NULL,
    `account_status` ENUM(
        'pending',
        'active',
        'suspended',
        'banned'
    ) NULL DEFAULT 'pending',
    `user_role` ENUM('guest', 'user', 'moderator', 'admin') NULL DEFAULT 'user',
    `permissions` JSON NULL,
    `language_preference` VARCHAR(10) NULL DEFAULT 'en',
    `theme_preference` ENUM('light', 'dark', 'auto') NULL DEFAULT 'auto',
    `notification_settings` JSON NULL,
    `privacy_settings` JSON NULL,
    `email_subscriptions` JSON NULL,
    `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP(), `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP(), `last_login_at` TIMESTAMP NULL, `last_activity_at` TIMESTAMP NULL, `login_count` INT UNSIGNED NULL, `last_ip_address` VARCHAR(45) NULL, `last_user_agent` TEXT NULL, `referral_source` VARCHAR(255) NULL, `company_name` VARCHAR(255) NULL, `job_title` VARCHAR(255) NULL, `website_url` VARCHAR(500) NULL, `social_links` JSON NULL, `linkedin_profile` VARCHAR(500) NULL, `twitter_handle` VARCHAR(100) NULL, `subscription_tier` VARCHAR(50) NULL, `subscription_status` ENUM(
        'trial',
        'active',
        'past_due',
        'cancelled',
        'expired'
    ) NULL, `subscription_start_date` TIMESTAMP NULL, `subscription_end_date` TIMESTAMP NULL, `payment_method_id` VARCHAR(255) NULL, `currency_preference` VARCHAR(3) NULL DEFAULT 'USD', `terms_accepted_at` TIMESTAMP NULL, `privacy_policy_accepted_at` TIMESTAMP NULL, `age_verification_status` BOOLEAN NULL DEFAULT 'DEFAULT FALSE', `gdpr_consent` BOOLEAN NULL DEFAULT 'DEFAULT FALSE', `marketing_consent` BOOLEAN NULL DEFAULT 'DEFAULT FALSE', `api_key` VARCHAR(255) NULL, `refresh_token` VARCHAR(255) NULL, `password_reset_token` VARCHAR(255) NULL, `password_reset_expiry` TIMESTAMP NULL, `failed_login_attempts` INT UNSIGNED NULL, `account_locked_until` TIMESTAMP NULL, `deleted_at` TIMESTAMP NULL, `admin_notes` TEXT NULL);
ALTER TABLE
    `users-alt` ADD INDEX `users_alt_sso_provider_sso_provider_id_index`(`sso_provider`, `sso_provider_id`);
ALTER TABLE
    `users-alt` ADD UNIQUE `users_alt_email_unique`(`email`);
ALTER TABLE
    `users-alt` ADD UNIQUE `users_alt_username_unique`(`username`);
ALTER TABLE
    `users-alt` ADD INDEX `users_alt_phone_index`(`phone`);
ALTER TABLE
    `users-alt` ADD INDEX `users_alt_account_status_index`(`account_status`);
ALTER TABLE
    `users-alt` ADD INDEX `users_alt_user_role_index`(`user_role`);
ALTER TABLE
    `users-alt` ADD INDEX `users_alt_created_at_index`(`created_at`);
ALTER TABLE
    `users-alt` ADD INDEX `users_alt_last_login_at_index`(`last_login_at`);
ALTER TABLE
    `users-alt` ADD INDEX `users_alt_subscription_status_index`(`subscription_status`);
ALTER TABLE
    `users-alt` ADD UNIQUE `users_alt_api_key_unique`(`api_key`);
ALTER TABLE
    `users-alt` ADD INDEX `users_alt_deleted_at_index`(`deleted_at`);
CREATE TABLE `lessons`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255) NOT NULL,
    `courseID` BIGINT NOT NULL,
    `description` MULTILINESTRING NOT NULL,
    `lesson` JSON NOT NULL
);
CREATE TABLE `Images`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `img` BLOB NOT NULL
);
ALTER TABLE
    `Grades` ADD CONSTRAINT `grades_courseid_foreign` FOREIGN KEY(`CourseID`) REFERENCES `Courses`(`id`);
ALTER TABLE
    `Notes` ADD CONSTRAINT `notes_courseid_foreign` FOREIGN KEY(`CourseID`) REFERENCES `Courses`(`id`);
ALTER TABLE
    `Study plans` ADD CONSTRAINT `study plans_userid_foreign` FOREIGN KEY(`UserID`) REFERENCES `Users`(`id`);
ALTER TABLE
    `Study plans` ADD CONSTRAINT `study plans_cards_foreign` FOREIGN KEY(`cards`) REFERENCES `Card groups`(`id`);
ALTER TABLE
    `Study plans` ADD CONSTRAINT `study plans_notes_foreign` FOREIGN KEY(`notes`) REFERENCES `Notes`(`id`);
ALTER TABLE
    `Assignments` ADD CONSTRAINT `assignments_courseid_foreign` FOREIGN KEY(`CourseID`) REFERENCES `Courses`(`id`);
ALTER TABLE
    `Courses` ADD CONSTRAINT `courses_assignments_foreign` FOREIGN KEY(`assignments`) REFERENCES `Assignments`(`id`);
ALTER TABLE
    `Study plans` ADD CONSTRAINT `study plans_results_foreign` FOREIGN KEY(`results`) REFERENCES `Grades`(`id`);
ALTER TABLE
    `Card groups` ADD CONSTRAINT `card groups_cards_foreign` FOREIGN KEY(`cards`) REFERENCES `Cards`(`id`);