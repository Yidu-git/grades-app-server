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
CREATE TABLE `Study_plans`(
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
    `Study_plans` ADD INDEX `study_plans_private_index`(`Private`);
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
    `Displayname` VARCHAR(20) NOT NULL,
    `username` VARCHAR(20) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `first_name` VARCHAR(255) NOT NULL,
    `last_name` VARCHAR(255) NULL,
    `is_verified` BOOLEAN NOT NULL,
    `verified_at` DATETIME NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `salt` VARCHAR(255) NOT NULL,
    `pfp_id` BIGINT NOT NULL
);
ALTER TABLE
    `Users` ADD UNIQUE `users_username_unique`(`username`);
ALTER TABLE
    `Users` ADD UNIQUE `users_email_unique`(`email`);
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
CREATE TABLE `Profile_pictures`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `imgURL` LINESTRING NOT NULL
);
CREATE TABLE `Login_data`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `UserID` BIGINT NOT NULL,
    `last_updated` DATETIME NOT NULL,
    `history` JSON NOT NULL,
    `prevous_usernames` JSON NOT NULL
);
CREATE TABLE `Likes`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `StudyplanID` BIGINT NOT NULL,
    `likes` BIGINT NOT NULL,
    `liked_by` JSON NOT NULL
);
CREATE TABLE `Roles`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `UserID` BIGINT NOT NULL,
    `Role` VARCHAR(255) NOT NULL,
    `admin` BOOLEAN NOT NULL
);
CREATE TABLE `Comments`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `StudyplanID` BIGINT NOT NULL,
    `comment` MULTILINESTRING NOT NULL,
    `created_at` DATETIME NOT NULL
);
ALTER TABLE
    `Grades` ADD CONSTRAINT `grades_courseid_foreign` FOREIGN KEY(`CourseID`) REFERENCES `Courses`(`id`);
ALTER TABLE
    `Notes` ADD CONSTRAINT `notes_courseid_foreign` FOREIGN KEY(`CourseID`) REFERENCES `Courses`(`id`);
ALTER TABLE
    `Likes` ADD CONSTRAINT `likes_studyplanid_foreign` FOREIGN KEY(`StudyplanID`) REFERENCES `Study_plans`(`id`);
ALTER TABLE
    `Study_plans` ADD CONSTRAINT `study_plans_cards_foreign` FOREIGN KEY(`cards`) REFERENCES `Card groups`(`id`);
ALTER TABLE
    `Grades` ADD CONSTRAINT `grades_answer_cards_foreign` FOREIGN KEY(`answer_cards`) REFERENCES `Cards`(`id`);
ALTER TABLE
    `Study_plans` ADD CONSTRAINT `study_plans_notes_foreign` FOREIGN KEY(`notes`) REFERENCES `Notes`(`id`);
ALTER TABLE
    `Comments` ADD CONSTRAINT `comments_studyplanid_foreign` FOREIGN KEY(`StudyplanID`) REFERENCES `Study_plans`(`id`);
ALTER TABLE
    `Assignments` ADD CONSTRAINT `assignments_courseid_foreign` FOREIGN KEY(`CourseID`) REFERENCES `Courses`(`id`);
ALTER TABLE
    `Courses` ADD CONSTRAINT `courses_assignments_foreign` FOREIGN KEY(`assignments`) REFERENCES `Assignments`(`id`);
ALTER TABLE
    `Study_plans` ADD CONSTRAINT `study_plans_results_foreign` FOREIGN KEY(`results`) REFERENCES `Grades`(`id`);
ALTER TABLE
    `Users` ADD CONSTRAINT `users_pfp_id_foreign` FOREIGN KEY(`pfp_id`) REFERENCES `Profile_pictures`(`id`);
ALTER TABLE
    `Card groups` ADD CONSTRAINT `card groups_cards_foreign` FOREIGN KEY(`cards`) REFERENCES `Cards`(`id`);
ALTER TABLE
    `Users` ADD CONSTRAINT `users_id_foreign` FOREIGN KEY(`id`) REFERENCES `Roles`(`id`);