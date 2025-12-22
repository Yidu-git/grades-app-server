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
    `answer_cards` BIGINT NULL
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
    `Course` VARCHAR(20) NOT NULL,
    `Results` JSON NOT NULL,
    `Catagory` VARCHAR(20) NOT NULL,
    `notes` JSON NOT NULL
);
CREATE TABLE `Card groups`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Name` VARCHAR(20) NOT NULL,
    `Cards` JSON NOT NULL,
    `Courses` VARCHAR(20) NOT NULL
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
    `Name` VARCHAR(20) NOT NULL,
    `Description` TEXT NULL,
    `Catagory` VARCHAR(20) NULL,
    `Lessons` JSON NOT NULL DEFAULT '"[]"',
    `CheckList` JSON NOT NULL DEFAULT '"[]"',
    `Assignments` JSON NOT NULL DEFAULT '"[]"'
);
CREATE TABLE `Notes`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Title` VARCHAR(50) NOT NULL,
    `Note` MULTILINESTRING NULL,
    `CourseID` BIGINT NULL,
    `Description` TEXT NULL,
    `Tags` JSON NULL
);
CREATE TABLE `Users`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(20) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP NOT NULL,
    `updated_at` TIMESTAMP NOT NULL,
    `history` JSON NOT NULL,
    `last_login` TIMESTAMP NOT NULL,
    `is_verified` BOOLEAN NOT NULL,
    `verified_at` TIMESTAMP NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `first_name` VARCHAR(255) NOT NULL,
    `last_name` VARCHAR(255) NULL,
    `Data` JSON NOT NULL
);
ALTER TABLE
    `Users` ADD UNIQUE `users_username_unique`(`username`);
ALTER TABLE
    `Users` ADD UNIQUE `users_email_unique`(`email`);
ALTER TABLE
    `Grades` ADD CONSTRAINT `grades_courseid_foreign` FOREIGN KEY(`CourseID`) REFERENCES `Courses`(`id`);
ALTER TABLE
    `Notes` ADD CONSTRAINT `notes_courseid_foreign` FOREIGN KEY(`CourseID`) REFERENCES `Courses`(`id`);
ALTER TABLE
    `Study plans` ADD CONSTRAINT `study plans_cards_foreign` FOREIGN KEY(`cards`) REFERENCES `Card groups`(`id`);
ALTER TABLE
    `Study plans` ADD CONSTRAINT `study plans_notes_foreign` FOREIGN KEY(`notes`) REFERENCES `Notes`(`id`);
ALTER TABLE
    `Assignments` ADD CONSTRAINT `assignments_courseid_foreign` FOREIGN KEY(`CourseID`) REFERENCES `Courses`(`id`);
ALTER TABLE
    `Courses` ADD CONSTRAINT `courses_assignments_foreign` FOREIGN KEY(`Assignments`) REFERENCES `Assignments`(`id`);
ALTER TABLE
    `Study plans` ADD CONSTRAINT `study plans_results_foreign` FOREIGN KEY(`Results`) REFERENCES `Grades`(`id`);
ALTER TABLE
    `Card groups` ADD CONSTRAINT `card groups_cards_foreign` FOREIGN KEY(`Cards`) REFERENCES `Cards`(`id`);