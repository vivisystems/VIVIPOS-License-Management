-- phpMyAdmin SQL Dump
-- version 3.3.2deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 27, 2010 at 06:25 PM
-- Server version: 5.1.41
-- PHP Version: 5.3.2-1ubuntu4.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `Licenses`
--
DROP DATABASE `Licenses`;
CREATE DATABASE `Licenses` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `Licenses`;

-- --------------------------------------------------------

--
-- Table structure for table `Downloads`
--

CREATE TABLE IF NOT EXISTS `Downloads` (
  `download_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `terminal_stub` varchar(128) NOT NULL,
  `partner_id` varchar(128) NOT NULL,
  `ip_address` varchar(128) NOT NULL,
  `sdk_version` varchar(128) NOT NULL,
  `app_version` varchar(128) NOT NULL,
  `license_helper_version` varchar(128) NOT NULL,
  `created` datetime NOT NULL,
  `created_by` varchar(128) NOT NULL,
  PRIMARY KEY (`download_id`),
  KEY `license_downloaded` (`terminal_stub`,`partner_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `Downloads`
--


-- --------------------------------------------------------

--
-- Table structure for table `Licenses`
--

CREATE TABLE IF NOT EXISTS `Licenses` (
  `terminal_stub` varchar(128) NOT NULL,
  `partner_id` varchar(128) NOT NULL,
  `request_id` int(36) unsigned DEFAULT NULL,
  `serial_number` varchar(128) NOT NULL,
  `license_key` varchar(128) DEFAULT NULL,
  `expire_date` timestamp NULL DEFAULT NULL,
  `signed_by` varchar(128) NOT NULL,
  `order_number` varchar(36) DEFAULT NULL,
  `created` datetime NOT NULL,
  `created_by` varchar(128) NOT NULL,
  `import_request_id` varchar(128) DEFAULT NULL,
  `update_count` int(11) DEFAULT '0',
  PRIMARY KEY (`terminal_stub`,`partner_id`),
  KEY `partner_issues_licenses` (`partner_id`),
  KEY `request_generates_licenses` (`request_id`),
  KEY `license_key` (`license_key`),
  KEY `order_number` (`order_number`),
  KEY `created_by` (`created_by`),
  KEY `serial_number` (`serial_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Licenses`
--


-- --------------------------------------------------------

--
-- Table structure for table `Partners`
--

CREATE TABLE IF NOT EXISTS `Partners` (
  `partner_id` varchar(128) NOT NULL,
  `name` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `created_on` datetime NOT NULL,
  `created_by` varchar(128) NOT NULL,
  PRIMARY KEY (`partner_id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Partners`
--

INSERT INTO `Partners` (`partner_id`, `name`, `email`, `created_on`, `created_by`) VALUES
('VIVIPOS SDK', 'VIVIPOS App Engine', 'info@vivipos.com.tw', '2010-12-23 10:52:23', 'Irving Hsu');

-- --------------------------------------------------------

--
-- Table structure for table `Requests`
--

CREATE TABLE IF NOT EXISTS `Requests` (
  `request_id` int(36) unsigned NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `serial_number` varchar(128) NOT NULL,
  `dallas_key` varchar(128) DEFAULT NULL,
  `system_name` varchar(128) DEFAULT NULL,
  `mac_address` varchar(128) DEFAULT NULL,
  `vendor_name` varchar(128) DEFAULT NULL,
  `stub` varchar(128) NOT NULL,
  `status` int(11) NOT NULL,
  `reason` varchar(128) DEFAULT NULL,
  `sales_rep` varchar(128) DEFAULT NULL,
  `processed_by` varchar(128) DEFAULT NULL,
  `annotations` longtext,
  `submitted_via` varchar(128) NOT NULL,
  `created_on` datetime NOT NULL,
  `created_by` varchar(128) NOT NULL,
  PRIMARY KEY (`request_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `Requests`
--


-- --------------------------------------------------------

--
-- Table structure for table `Revokes`
--

CREATE TABLE IF NOT EXISTS `Revokes` (
  `terminal_stub` varchar(128) NOT NULL,
  `partner_id` varchar(128) NOT NULL,
  `request_id` int(36) unsigned DEFAULT NULL,
  `serial_number` varchar(128) NOT NULL,
  `license_key` varchar(128) DEFAULT NULL,
  `expire_date` timestamp NULL DEFAULT NULL,
  `signed_by` varchar(128) NOT NULL,
  `order_number` varchar(36) DEFAULT NULL,
  `created` datetime NOT NULL,
  `created_by` varchar(128) NOT NULL,
  `import_request_id` varchar(128) DEFAULT NULL,
  `update_count` int(11) DEFAULT '0',
  `revoked` datetime NOT NULL,
  `revoked_by` varchar(128) NOT NULL,
  `revoke_type` varchar(128) NOT NULL,
  `revoke_request_id` varchar(128) NOT NULL,
  KEY `partner_issues_licenses` (`partner_id`),
  KEY `request_generates_licenses` (`request_id`),
  KEY `license_key` (`license_key`),
  KEY `order_number` (`order_number`),
  KEY `created_by` (`created_by`),
  KEY `serial_number` (`serial_number`),
  KEY `terminal_stub_and_partner_id` (`terminal_stub`,`partner_id`),
  KEY `revoked_by` (`revoked_by`),
  KEY `revoke_type` (`revoke_type`),
  KEY `revoke_request_id` (`revoke_request_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Revokes`
--


-- --------------------------------------------------------

--
-- Table structure for table `Terminals`
--

CREATE TABLE IF NOT EXISTS `Terminals` (
  `terminal_stub` varchar(128) NOT NULL,
  `serial_number` varchar(128) DEFAULT NULL,
  `dallas_key` varchar(128) DEFAULT NULL,
  `system_name` varchar(128) DEFAULT NULL,
  `vendor_name` varchar(128) DEFAULT NULL,
  `mac_address` varchar(128) DEFAULT NULL,
  `model` varchar(128) DEFAULT NULL,
  `created` datetime NOT NULL,
  `created_by` varchar(128) NOT NULL,
  `signed_by` varchar(128) NOT NULL,
  `import_request_id` varchar(128) DEFAULT NULL,
  `update_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`terminal_stub`),
  UNIQUE KEY `serial_number` (`serial_number`),
  KEY `system_name` (`system_name`),
  KEY `vendor_name` (`vendor_name`),
  KEY `model` (`model`),
  KEY `created_by` (`created_by`),
  KEY `signed_by` (`signed_by`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Terminals`
--

