CREATE TABLE users (
    -- Primary Key
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    
    -- Identity & Authentication
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    username VARCHAR(50) UNIQUE,
    phone VARCHAR(20),
    two_factor_secret VARCHAR(255),
    security_question_1 VARCHAR(255),
    security_answer_1_hash VARCHAR(255),
    security_question_2 VARCHAR(255),
    security_answer_2_hash VARCHAR(255),
    sso_provider VARCHAR(50),
    sso_provider_id VARCHAR(255),
    
    -- Personal Information
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    date_of_birth DATE,
    gender VARCHAR(50),
    profile_photo_url VARCHAR(500),
    bio TEXT,
    pronouns VARCHAR(50),
    
    -- Contact Information
    email_secondary VARCHAR(255),
    phone_secondary VARCHAR(20),
    country VARCHAR(100),
    state_province VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    address_line_1 VARCHAR(255),
    address_line_2 VARCHAR(255),
    time_zone VARCHAR(50),
    
    -- Account Status & Permissions
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    email_verified_at TIMESTAMP NULL,
    phone_verified_at TIMESTAMP NULL,
    account_status ENUM('pending', 'active', 'suspended', 'banned') DEFAULT 'pending',
    user_role ENUM('guest', 'user', 'moderator', 'admin') DEFAULT 'user',
    permissions JSON,
    
    -- Preferences & Settings
    language_preference VARCHAR(10) DEFAULT 'en',
    theme_preference ENUM('light', 'dark', 'auto') DEFAULT 'auto',
    notification_settings JSON,
    privacy_settings JSON,
    email_subscriptions JSON,
    
    -- Tracking & Analytics
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP NULL,
    last_activity_at TIMESTAMP NULL,
    login_count INT UNSIGNED DEFAULT 0,
    last_ip_address VARCHAR(45),
    last_user_agent TEXT,
    referral_source VARCHAR(255),
    
    -- Social & Professional
    company_name VARCHAR(255),
    job_title VARCHAR(255),
    website_url VARCHAR(500),
    social_links JSON,
    linkedin_profile VARCHAR(500),
    twitter_handle VARCHAR(100),
    
    -- Financial & Subscription
    subscription_tier VARCHAR(50),
    subscription_status ENUM('trial', 'active', 'past_due', 'cancelled', 'expired'),
    subscription_start_date TIMESTAMP NULL,
    subscription_end_date TIMESTAMP NULL,
    payment_method_id VARCHAR(255),
    currency_preference VARCHAR(3) DEFAULT 'USD',
    
    -- Compliance & Legal
    terms_accepted_at TIMESTAMP NULL,
    privacy_policy_accepted_at TIMESTAMP NULL,
    age_verification_status BOOLEAN DEFAULT FALSE,
    gdpr_consent BOOLEAN DEFAULT FALSE,
    marketing_consent BOOLEAN DEFAULT FALSE,
    
    -- Advanced Features
    api_key VARCHAR(255) UNIQUE,
    refresh_token VARCHAR(255),
    password_reset_token VARCHAR(255),
    password_reset_expiry TIMESTAMP NULL,
    failed_login_attempts INT UNSIGNED DEFAULT 0,
    account_locked_until TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    admin_notes TEXT,
    
    -- Indexes for common queries
    INDEX idx_email (email),
    INDEX idx_username (username),
    INDEX idx_phone (phone),
    INDEX idx_account_status (account_status),
    INDEX idx_user_role (user_role),
    INDEX idx_created_at (created_at),
    INDEX idx_last_login (last_login_at),
    INDEX idx_subscription_status (subscription_status),
    INDEX idx_deleted_at (deleted_at),
    INDEX idx_sso_provider (sso_provider, sso_provider_id)
    
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;