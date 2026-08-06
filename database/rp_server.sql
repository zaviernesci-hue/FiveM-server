-- =============================================================================
-- Los Santos Roleplay - Database Schema
-- Import this AFTER creating database: CREATE DATABASE rp_server;
-- Compatible with QBCore + custom rp-* resources
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `rp_server` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `rp_server`;

-- ---------------------------------------------------------------------------
-- QBCore base tables (minimal — full schema comes with qb-core install)
-- Run official qb-core SQL first if tables missing; these extend/customize
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `players` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `license` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `money` TEXT NOT NULL,
    `charinfo` TEXT NOT NULL,
    `job` TEXT NOT NULL,
    `gang` TEXT DEFAULT NULL,
    `position` TEXT NOT NULL,
    `metadata` TEXT NOT NULL,
    `inventory` LONGTEXT DEFAULT NULL,
    `last_updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`),
    KEY `license` (`license`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `player_vehicles` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `license` VARCHAR(50) DEFAULT NULL,
    `citizenid` VARCHAR(50) DEFAULT NULL,
    `vehicle` VARCHAR(50) DEFAULT NULL,
    `hash` VARCHAR(50) DEFAULT NULL,
    `mods` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
    `plate` VARCHAR(15) NOT NULL,
    `fakeplate` VARCHAR(50) DEFAULT NULL,
    `garage` VARCHAR(50) DEFAULT 'pillboxgarage',
    `fuel` INT(11) DEFAULT 100,
    `engine` FLOAT DEFAULT 1000,
    `body` FLOAT DEFAULT 1000,
    `state` INT(11) DEFAULT 1,
    `depotprice` INT(11) NOT NULL DEFAULT 0,
    `drivingdistance` INT(50) DEFAULT NULL,
    `status` TEXT DEFAULT NULL,
    `balance` INT(11) NOT NULL DEFAULT 0,
    `paymentamount` INT(11) NOT NULL DEFAULT 0,
    `paymentsleft` INT(11) NOT NULL DEFAULT 0,
    `financetime` INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `plate` (`plate`),
    KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------------------------------------------------------------------------
-- RP Custom Tables
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `rp_licences` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `licence_type` VARCHAR(50) NOT NULL,
    `issued_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `expires_at` TIMESTAMP NULL,
    `status` ENUM('valid','suspended','revoked') DEFAULT 'valid',
    PRIMARY KEY (`id`),
    UNIQUE KEY `citizen_licence` (`citizenid`, `licence_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_housing` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `property_id` VARCHAR(50) NOT NULL,
    `owner_citizenid` VARCHAR(50) DEFAULT NULL,
    `renter_citizenid` VARCHAR(50) DEFAULT NULL,
    `keys` LONGTEXT DEFAULT '[]',
    `stash` LONGTEXT DEFAULT '[]',
    `garage_slots` INT DEFAULT 2,
    `purchase_price` INT DEFAULT 0,
    `rent_price` INT DEFAULT 0,
    `owned` TINYINT(1) DEFAULT 0,
    `locked` TINYINT(1) DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE KEY `property_id` (`property_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_phone_contacts` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `number` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_phone_messages` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `sender` VARCHAR(20) NOT NULL,
    `receiver` VARCHAR(20) NOT NULL,
    `message` TEXT NOT NULL,
    `read_status` TINYINT(1) DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_phone_calls` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `caller` VARCHAR(20) NOT NULL,
    `receiver` VARCHAR(20) NOT NULL,
    `duration` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_taktik_posts` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `username` VARCHAR(50) NOT NULL,
    `caption` TEXT,
    `video_url` VARCHAR(255) DEFAULT NULL,
    `likes` INT DEFAULT 0,
    `views` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_taktik_comments` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `post_id` INT NOT NULL,
    `citizenid` VARCHAR(50) NOT NULL,
    `comment` TEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `post_id` (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_taktik_follows` (
    `follower` VARCHAR(50) NOT NULL,
    `following` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`follower`, `following`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_marketplace` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `seller_citizenid` VARCHAR(50) NOT NULL,
    `title` VARCHAR(100) NOT NULL,
    `description` TEXT,
    `item_name` VARCHAR(50) DEFAULT NULL,
    `item_amount` INT DEFAULT 1,
    `vehicle_plate` VARCHAR(15) DEFAULT NULL,
    `price` INT NOT NULL,
    `listing_type` ENUM('buy_now','auction') DEFAULT 'buy_now',
    `current_bid` INT DEFAULT 0,
    `bidder_citizenid` VARCHAR(50) DEFAULT NULL,
    `expires_at` TIMESTAMP NULL,
    `status` ENUM('active','sold','cancelled') DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_bank_transactions` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `type` VARCHAR(50) NOT NULL,
    `amount` INT NOT NULL,
    `balance_after` INT NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_dispatch_logs` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `incident_type` VARCHAR(50) NOT NULL,
    `title` VARCHAR(100) NOT NULL,
    `coords` VARCHAR(100) NOT NULL,
    `caller_citizenid` VARCHAR(50) DEFAULT NULL,
    `assigned_job` VARCHAR(50) NOT NULL,
    `status` ENUM('open','assigned','closed') DEFAULT 'open',
    `data` LONGTEXT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_evidence` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `locker_id` VARCHAR(50) NOT NULL,
    `case_number` VARCHAR(50) NOT NULL,
    `officer_citizenid` VARCHAR(50) NOT NULL,
    `items` LONGTEXT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_crops` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `crop_type` VARCHAR(50) NOT NULL,
    `coords` VARCHAR(100) NOT NULL,
    `water_level` INT DEFAULT 0,
    `growth_stage` INT DEFAULT 0,
    `planted_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_darkweb_bounties` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `poster_citizenid` VARCHAR(50) NOT NULL,
    `target_citizenid` VARCHAR(50) NOT NULL,
    `amount` INT NOT NULL,
    `status` ENUM('active','claimed','cancelled') DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_vehicle_fuel` (
    `plate` VARCHAR(15) NOT NULL,
    `fuel` FLOAT DEFAULT 100.0,
    PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rp_paychecks` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `job` VARCHAR(50) NOT NULL,
    `amount` INT NOT NULL,
    `tax_deducted` INT DEFAULT 0,
    `paid_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Default housing properties
INSERT IGNORE INTO `rp_housing` (`property_id`, `purchase_price`, `rent_price`, `garage_slots`) VALUES
('apartment_1', 85000, 1200, 1),
('apartment_2', 95000, 1400, 1),
('house_mirror_park', 425000, 0, 2),
('house_vinewood', 890000, 0, 3),
('house_sandy', 175000, 0, 2),
('house_lossoques', 560000, 0, 2),
('apt_del_perro', 320000, 0, 2);
