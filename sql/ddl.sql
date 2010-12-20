-- phpMyAdmin SQL Dump
-- version 3.3.2deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 20, 2010 at 06:37 PM
-- Server version: 5.1.41
-- PHP Version: 5.3.2-1ubuntu4.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `vivipos`
--

-- --------------------------------------------------------

--
-- Table structure for table `Downloads`
--

DROP TABLE IF EXISTS `Downloads`;
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
  KEY `license_downloaded` (`terminal_stub`, `partner_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Licenses`
--

DROP TABLE IF EXISTS `Licenses`;
CREATE TABLE IF NOT EXISTS `Licenses` (
  `terminal_stub` varchar(128) NOT NULL,
  `partner_id` varchar(128) NOT NULL,
  `request_id` int(36) unsigned DEFAULT NULL,
  `license_key` varchar(128) NOT NULL,
  `expire_date` datetime DEFAULT NULL,
  `signed_by` varchar(128) NOT NULL,
  `order_number` varchar(36) DEFAULT NULL,
  `created` datetime NOT NULL,
  `created_by` varchar(128) NOT NULL,
  `create_request_id` varchar(128) DEFAULT NULL,
  `update_count` int(11) DEFAULT '0',
  PRIMARY KEY (`terminal_stub`,`partner_id`),
  KEY `partner_issues_licenses` (`partner_id`),
  KEY `request_generates_licenses` (`request_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Partners`
--

DROP TABLE IF EXISTS `Partners`;
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

-- --------------------------------------------------------

--
-- Table structure for table `Requests`
--

DROP TABLE IF EXISTS `Requests`;
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
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `Terminals`
--

DROP TABLE IF EXISTS `Terminals`;
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
  `create_request_id` varchar(128) DEFAULT NULL,
  `update_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`terminal_stub`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

