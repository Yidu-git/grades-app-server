create database if not exists grade_manager;

USE grade_manager;

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
    `UserID` BIGINT NOT NULL,
    `Private` BOOL NOT NULL DEFAULT TRUE
);
CREATE TABLE `Cards`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Question` VARCHAR(30) NOT NULL,
    `Answer` JSON NOT NULL,
    `Choice` BOOLEAN NULL,
    `Choices` JSON NULL,
    `CourseID` BIGINT NULL,
    `UserID` BIGINT NOT NULL,
    `Private` BOOL NOT NULL DEFAULT TRUE
);
CREATE TABLE `Study_plans`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `card_groups` JSON NOT NULL,
    `course` VARCHAR(20) NOT NULL,
    `results` JSON NOT NULL,
    `catagory` VARCHAR(20) NOT NULL,
    `notes` JSON NOT NULL,
    `UserID` BIGINT NOT NULL,
    `Private` BOOLEAN NOT NULL DEFAULT TRUE,
);
ALTER TABLE
    `Study_plans` ADD INDEX `study_plans_private_index`(`Private`);
CREATE TABLE `Card_groups`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20) NOT NULL,
    `cards` JSON NOT NULL,
    `courses` JSON NOT NULL,
    `tags` JSON NOT NULL,
    `UserID` BIGINT NOT NULL,
    `Private` BOOL NOT NULL DEFAULT TRUE,
);
CREATE TABLE `Assignments`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `UserID` BIGINT NOT NULL,
    `Private` BOOL NOT NULL DEFAULT TRUE,
    `Title` VARCHAR(255) NULL,
    `CourseID` BIGINT NOT NULL,
    `Assignment` TEXT NOT NULL,
    `DateSubmitted` DATETIME NULL,
    `Deadline` DATETIME NULL,
    `Status` VARCHAR(20) NOT NULL DEFAULT 'incomplete',
    `Points` BIGINT NULL,
    `PointsPossible` BIGINT NOT NULL,
    `Course` BIGINT NULL,
    `Weight` BIGINT NULL,
    `Catagory` BIGINT NULL
);
CREATE TABLE `Courses`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `UserID` BIGINT NOT NULL,
    `Private` BOOL NOT NULL DEFAULT TRUE,
    `name` VARCHAR(20) NOT NULL,
    `description` TEXT NULL,
    `catagory` VARCHAR(20) NULL,
    `assesment_check_list` JSON NULL
);
CREATE TABLE `Notes`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `UserID` BIGINT NOT NULL,
    `Private` BOOL NOT NULL DEFAULT TRUE,
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
    `created_at` DATETIME NOT NULL,
    `displayname` VARCHAR(20) NOT NULL,
    `username` VARCHAR(20) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `first_name` VARCHAR(255) NOT NULL,
    `last_name` VARCHAR(255) NOT NULL,
    `is_verified` BOOLEAN NOT NULL DEFAULT FALSE,
    `verified_at` DATETIME NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `salt` VARCHAR(255) NOT NULL,
    `pfp_URL` LINESTRING NULL
);
ALTER TABLE
    `Users` ADD UNIQUE `users_username_unique`(`username`);
ALTER TABLE
    `Users` ADD UNIQUE `users_email_unique`(`email`);
CREATE TABLE `Lessons`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255) NOT NULL,
    `courseID` BIGINT NULL,
    `description` MULTILINESTRING NULL,
    `lesson` JSON NOT NULL,
    `topic` LINESTRING NULL,
    `UserID` BIGINT NOT NULL
);
CREATE TABLE `Login_data`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `UserID` BIGINT NOT NULL,
    `last_updated` DATETIME NOT NULL,
    `history` JSON NULL,
    `prevous_usernames` JSON NULL
);
CREATE TABLE `Likes`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `StudyplanID` BIGINT NOT NULL,
    `likes` BIGINT NOT NULL DEFAULT FALSE,
    `liked_by` JSON NULL
);
CREATE TABLE `Roles`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `UserID` BIGINT NOT NULL,
    `role` VARCHAR(255) NOT NULL,
    `admin` BOOLEAN NOT NULL
);
CREATE TABLE `Comments`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `StudyplanID` BIGINT NOT NULL,
    `comment` MULTILINESTRING NOT NULL,
    `created_at` DATETIME NOT NULL,
	`UserID` BIGINT NOT NULL
);
CREATE TABLE `Projects`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `UserID` BIGINT NOT NULL,
    `Private` BOOL NOT NULL DEFAULT TRUE,
    `created_at` DATETIME NOT NULL,
    `deadline` DATETIME NULL,
    `title` LINESTRING NOT NULL,
    `description` MULTILINESTRING NOT NULL,
    `CourseID` BIGINT NULL,
    `progress` LINESTRING NOT NULL
);
CREATE TABLE `Schedules`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `UserID` BIGINT NOT NULL,
    `Private` BOOLEAN NOT NULL DEFAULT FALSE,
    `schedule` JSON NOT NULL
);

ALTER TABLE
    `Grades` ADD CONSTRAINT `grades_courseid_foreign` FOREIGN KEY(`CourseID`) REFERENCES `Courses`(`id`);
ALTER TABLE
    `lessons` ADD CONSTRAINT `lessons_courseid_foreign` FOREIGN KEY(`courseID`) REFERENCES `Courses`(`id`);
ALTER TABLE
    `Cards` ADD CONSTRAINT `cards_courseid_foreign` FOREIGN KEY(`CourseID`) REFERENCES `Courses`(`id`);
ALTER TABLE
    `Notes` ADD CONSTRAINT `notes_courseid_foreign` FOREIGN KEY(`CourseID`) REFERENCES `Courses`(`id`);
ALTER TABLE
    `Likes` ADD CONSTRAINT `likes_studyplanid_foreign` FOREIGN KEY(`StudyplanID`) REFERENCES `Study_plans`(`id`);
ALTER TABLE
    `Schedules` ADD CONSTRAINT `schedules_userid_foreign` FOREIGN KEY(`UserID`) REFERENCES `Users`(`id`);
ALTER TABLE
    `Comments` ADD CONSTRAINT `comments_studyplanid_foreign` FOREIGN KEY(`StudyplanID`) REFERENCES `Study_plans`(`id`);
ALTER TABLE
    `Assignments` ADD CONSTRAINT `assignments_courseid_foreign` FOREIGN KEY(`CourseID`) REFERENCES `Courses`(`id`);
ALTER TABLE
    `Login_data` ADD CONSTRAINT `login_data_userid_foreign` FOREIGN KEY(`UserID`) REFERENCES `Users`(`id`);
ALTER TABLE
    `Roles` ADD CONSTRAINT `roles_userid_foreign` FOREIGN KEY(`UserID`) REFERENCES `Users`(`id`);