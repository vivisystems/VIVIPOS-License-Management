-- phpMyAdmin SQL Dump
-- version 2.11.3deb1ubuntu1
-- http://www.phpmyadmin.net
--
-- 主機: localhost
-- 建立日期: Jan 11, 2011, 03:11 PM
-- 伺服器版本: 5.0.51
-- PHP 版本: 5.2.4-2ubuntu5.7

SET FOREIGN_KEY_CHECKS=0;

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

SET AUTOCOMMIT=0;
START TRANSACTION;

--
-- 資料庫: `Licenses`
--

-- --------------------------------------------------------

--
-- 資料表格式： `Downloads`
--

DROP TABLE IF EXISTS `Downloads`;
CREATE TABLE IF NOT EXISTS `Downloads` (
  `download_id` int(11) unsigned NOT NULL auto_increment,
  `terminal_stub` varchar(128) NOT NULL,
  `partner_id` varchar(128) NOT NULL,
  `ip_address` varchar(128) NOT NULL,
  `sdk_version` varchar(128) NOT NULL,
  `app_version` varchar(128) NOT NULL,
  `os_version` varchar(128) default NULL,
  `license_helper_version` varchar(128) NOT NULL,
  `download_request_id` varchar(128) default NULL,
  `created` datetime NOT NULL,
  `created_by` varchar(128) NOT NULL,
  PRIMARY KEY  (`download_id`),
  KEY `license_downloaded` (`terminal_stub`,`partner_id`),
  KEY `download_request_id` (`download_request_id`),
  KEY `ip_address` (`ip_address`),
  KEY `sdk_version` (`sdk_version`),
  KEY `app_version` (`app_version`),
  KEY `os_version` (`os_version`),
  KEY `license_helper_version` (`license_helper_version`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- 列出以下資料庫的數據： `Downloads`
--


-- --------------------------------------------------------

--
-- 資料表格式： `Licenses`
--

DROP TABLE IF EXISTS `Licenses`;
CREATE TABLE IF NOT EXISTS `Licenses` (
  `terminal_stub` varchar(128) NOT NULL,
  `partner_id` varchar(128) NOT NULL,
  `serial_number` varchar(128) NOT NULL,
  `license_key` varchar(128) default NULL,
  `expire_date` timestamp NULL default NULL,
  `signed_by` varchar(128) NOT NULL,
  `order_number` varchar(36) default NULL,
  `created` datetime NOT NULL,
  `created_by` varchar(128) NOT NULL,
  `import_request_id` varchar(128) default NULL,
  `update_count` int(11) default '0',
  PRIMARY KEY  (`terminal_stub`,`partner_id`),
  KEY `partner_issues_licenses` (`partner_id`),
  KEY `license_key` (`license_key`),
  KEY `order_number` (`order_number`),
  KEY `created_by` (`created_by`),
  KEY `serial_number` (`serial_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 列出以下資料庫的數據： `Licenses`
--


-- --------------------------------------------------------

--
-- 資料表格式： `Partners`
--

DROP TABLE IF EXISTS `Partners`;
CREATE TABLE IF NOT EXISTS `Partners` (
  `partner_id` varchar(128) NOT NULL,
  `name` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `created_on` datetime NOT NULL,
  `created_by` varchar(128) NOT NULL,
  PRIMARY KEY  (`partner_id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 列出以下資料庫的數據： `Partners`
--

INSERT INTO `Partners` (`partner_id`, `name`, `email`, `created_on`, `created_by`) VALUES
('VIVIPOS SDK', 'VIVIPOS App Engine', 'info@vivipos.com.tw', '2010-12-23 10:52:23', 'Irving Hsu'),
('VIVISYSTEMS', 'VIVISYSTEMS Base License', 'info@vivisystems.com.tw', '2010-12-27 10:53:14', 'Irving Hsu');

-- --------------------------------------------------------

--
-- 資料表格式： `Requests`
--

DROP TABLE IF EXISTS `Requests`;
CREATE TABLE IF NOT EXISTS `Requests` (
  `id` int(36) unsigned NOT NULL auto_increment,
  `request_id` varchar(128) default NULL,
  `ticket` varchar(128) default NULL,
  `ip_address` varchar(128) default NULL,
  `customer_name` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `terminal_stub` varchar(128) NOT NULL,
  `dallas_key` varchar(128) NOT NULL,
  `system_name` varchar(128) NOT NULL,
  `vendor_name` varchar(128) NOT NULL,
  `mac_address` varchar(128) NOT NULL,
  `sdk_version` varchar(128) default NULL,
  `app_version` varchar(128) default NULL,
  `os_version` varchar(128) default NULL,
  `lic_helper_version` varchar(128) default NULL,
  `hw_serial_number` varchar(128) default NULL,
  `sw_serial_number` varchar(128) default NULL,
  `status` int(11) NOT NULL,
  `reason` varchar(128) default NULL,
  `sales_rep` varchar(128) default NULL,
  `processed_on` datetime default NULL,
  `processed_by` varchar(128) default NULL,
  `annotations` longtext,
  `created_on` datetime NOT NULL,
  `created_by` varchar(128) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `customer_name` (`customer_name`),
  KEY `email` (`email`),
  KEY `stub` (`terminal_stub`),
  KEY `status` (`status`),
  KEY `processed_by` (`processed_by`),
  KEY `sales_rep` (`sales_rep`),
  KEY `created_on` (`created_on`),
  KEY `created_by` (`created_by`),
  KEY `processed_on` (`processed_on`),
  KEY `request_id` (`request_id`),
  KEY `sdk_version` (`sdk_version`),
  KEY `app_version` (`app_version`),
  KEY `os_version` (`os_version`),
  KEY `lic_helper_version` (`lic_helper_version`),
  KEY `hw_serial_number` (`hw_serial_number`),
  KEY `sw_serial_number` (`sw_serial_number`),
  KEY `ip_address` (`ip_address`),
  KEY `request_id_2` (`request_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- 列出以下資料庫的數據： `Requests`
--


-- --------------------------------------------------------

--
-- 資料表格式： `Revokes`
--

DROP TABLE IF EXISTS `Revokes`;
CREATE TABLE IF NOT EXISTS `Revokes` (
  `terminal_stub` varchar(128) NOT NULL,
  `partner_id` varchar(128) NOT NULL,
  `request_id` int(36) unsigned default NULL,
  `serial_number` varchar(128) NOT NULL,
  `license_key` varchar(128) default NULL,
  `expire_date` timestamp NULL default NULL,
  `signed_by` varchar(128) NOT NULL,
  `order_number` varchar(36) default NULL,
  `created` datetime NOT NULL,
  `created_by` varchar(128) NOT NULL,
  `import_request_id` varchar(128) default NULL,
  `update_count` int(11) default '0',
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
-- 列出以下資料庫的數據： `Revokes`
--


-- --------------------------------------------------------

--
-- 資料表格式： `Terminals`
--

DROP TABLE IF EXISTS `Terminals`;
CREATE TABLE IF NOT EXISTS `Terminals` (
  `terminal_stub` varchar(128) NOT NULL,
  `serial_number` varchar(128) default NULL,
  `dallas_key` varchar(128) default NULL,
  `system_name` varchar(128) default NULL,
  `vendor_name` varchar(128) default NULL,
  `mac_address` varchar(128) default NULL,
  `model` varchar(128) default NULL,
  `created` datetime NOT NULL,
  `created_by` varchar(128) NOT NULL,
  `signed_by` varchar(128) NOT NULL,
  `import_request_id` varchar(128) default NULL,
  `update_count` int(11) NOT NULL default '0',
  PRIMARY KEY  (`terminal_stub`),
  UNIQUE KEY `serial_number` (`serial_number`),
  KEY `system_name` (`system_name`),
  KEY `vendor_name` (`vendor_name`),
  KEY `model` (`model`),
  KEY `created_by` (`created_by`),
  KEY `signed_by` (`signed_by`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 列出以下資料庫的數據： `Terminals`
--


SET FOREIGN_KEY_CHECKS=1;

COMMIT;
