-- phpMyAdmin SQL Dump
-- version 2.11.3deb1ubuntu1
-- http://www.phpmyadmin.net
--
-- 主機: localhost
-- 建立日期: Jan 11, 2011, 04:09 PM
-- 伺服器版本: 5.0.51
-- PHP 版本: 5.2.4-2ubuntu5.7

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

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

INSERT INTO `Licenses` (`terminal_stub`, `partner_id`, `serial_number`, `license_key`, `expire_date`, `signed_by`, `order_number`, `created`, `created_by`, `import_request_id`, `update_count`) VALUES
('114a1b03d1b6cd8a174a826f76e009f4d41d8cd98f00b204e9800998ecf8427ed41d8cd98f00b204e9800998ecf8427eca06eb3927fa621516df32dc4861fd42', 'VIVIPOS SDK', 'SW11111111', 'efb570b939d4b6d3ad6b581ed5b7efd1846017736226993915aa96ad2a138ab137c68df94e6a7539986e304354e377c15cbaf003ebcd6645ea775df482f8708f', '2011-01-11 16:08:23', 'irving.hsu@vivipos.com.tw', 'S220-12341234', '2011-01-11 16:02:01', 'license-import@vivipos.com.tw', '20110111-6-1602', 0),
('334a1b03d1b6cd8a174a826f76e009f4d41d8cd98f00b204e9800998ecf8427ed41d8cd98f00b204e9800998ecf8427eca06eb3927fa621516df32dc4861fd42', 'VIVIPOS SDK', 'SW33333333', 'efb570b939d4b6d3ad6b581ed5b7efd1846017736226993915aa96ad2a138ab185fc8b68167eb4823516412c5b3705349579659d286e22669a5c5dc7e58407fd', '2011-01-11 16:08:34', 'irving.hsu@vivipos.com.tw', 'S220-12341234', '2011-01-11 16:02:02', 'license-import@vivipos.com.tw', '20110111-6-1602', 0),
('1e4a1b03d1b6cd8a174a826f76e009f4d41d8cd98f00b204e9800998ecf8427ed41d8cd98f00b204e9800998ecf8427eca06eb3927fa621516df32dc4861fd42', 'VIVIPOS SDK', 'SW00000000', 'efb570b939d4b6d3ad6b581ed5b7efd1846017736226993915aa96ad2a138ab12fc1a13ac68aedd405f095fd153a1c6951e9ba5b311153be5e340cfd09b53f50', '2011-01-11 16:08:46', 'irving.hsu@vivipos.com.tw', 'S220-12341234', '2011-01-11 16:02:02', 'license-import@vivipos.com.tw', '20110111-6-1602', 0);

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
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- 列出以下資料庫的數據： `Requests`
--

INSERT INTO `Requests` (`id`, `request_id`, `ticket`, `ip_address`, `customer_name`, `email`, `terminal_stub`, `dallas_key`, `system_name`, `vendor_name`, `mac_address`, `sdk_version`, `app_version`, `os_version`, `lic_helper_version`, `hw_serial_number`, `sw_serial_number`, `status`, `reason`, `sales_rep`, `processed_on`, `processed_by`, `annotations`, `created_on`, `created_by`) VALUES
(1, '20110111-1-1529', 'tender+dc8c2075125777ba14d337bad112629145efa7d66@tenderapp.com', '114.45.171.250', 'Irving Hsu', 'irving.hsu@vivisystems.com.tw', '1e4a1b03d1b6cd8a174a826f76e009f4d41d8cd98f00b204e9800998ecf8427ed41d8cd98f00b204e9800998ecf8427eca06eb3927fa621516df32dc4861fd42', '0000000000000000', '', '', '000c29d2a12e', '1.2.1.9-RR-RC4', '1.2.1.6-RR', 'Ubuntu 10.04.1 LTS', '1.3', 'HW00000000', 'HW00000000', 1, NULL, 'irving.hsu@vivipos.com.tw', '2011-01-11 16:02:02', '20110111-6-1602', '', '2011-01-11 15:28:56', '/addons/app/webroot/services/submitRequest.php'),
(2, '20110111-3-1536', 'tender+d3e399e1deb8343127fe0fa506ddf0a68011f5cd4@tenderapp.com', NULL, 'administrator@vivisystems.com.tw', 'administrator@vivisystems.com.tw', '114a1b03d1b6cd8a174a826f76e009f4d41d8cd98f00b204e9800998ecf8427ed41d8cd98f00b204e9800998ecf8427eca06eb3927fa621516df32dc4861fd42', '1111111111111111', 'All Ones System', 'All Ones Vendor', '111c29d2a12e', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'irving.hsu@vivipos.com.tw', '2011-01-11 16:02:01', '20110111-6-1602', NULL, '2011-01-11 15:36:04', 'license-request@vivipos.com.tw'),
(3, '20110111-3-1536', 'tender+d3e399e1deb8343127fe0fa506ddf0a68011f5cd4@tenderapp.com', NULL, 'administrator@vivisystems.com.tw', 'administrator@vivisystems.com.tw', '334a1b03d1b6cd8a174a826f76e009f4d41d8cd98f00b204e9800998ecf8427ed41d8cd98f00b204e9800998ecf8427eca06eb3927fa621516df32dc4861fd42', '3333333333333333', 'All Threes System', 'All Threes Vendor', '333c29d2a12e', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'irving.hsu@vivipos.com.tw', '2011-01-11 16:02:02', '20110111-6-1602', NULL, '2011-01-11 15:36:04', 'license-request@vivipos.com.tw'),
(4, '20110111-3-1536', 'tender+d3e399e1deb8343127fe0fa506ddf0a68011f5cd4@tenderapp.com', NULL, 'administrator@vivisystems.com.tw', 'administrator@vivisystems.com.tw', '224a1b03d1b6cd8a174a826f76e009f4d41d8cd98f00b204e9800998ecf8427ed41d8cd98f00b204e9800998ecf8427eca06eb3927fa621516df32dc4861fd42', '2222222222222222', 'All Twos System', 'All Twos Vendor', '222c29d2a12e', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, '2011-01-11 15:36:04', 'license-request@vivipos.com.tw');

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

INSERT INTO `Terminals` (`terminal_stub`, `serial_number`, `dallas_key`, `system_name`, `vendor_name`, `mac_address`, `model`, `created`, `created_by`, `signed_by`, `import_request_id`, `update_count`) VALUES
('114a1b03d1b6cd8a174a826f76e009f4d41d8cd98f00b204e9800998ecf8427ed41d8cd98f00b204e9800998ecf8427eca06eb3927fa621516df32dc4861fd42', 'HW11111111', '1111111111111111', 'All Ones System', 'All Ones Vendor', '111c29d2a12e', 'MP-3522', '2011-01-11 16:02:01', 'license-import@vivipos.com.tw', 'irving.hsu@vivipos.com.tw', '20110111-6-1602', 0),
('334a1b03d1b6cd8a174a826f76e009f4d41d8cd98f00b204e9800998ecf8427ed41d8cd98f00b204e9800998ecf8427eca06eb3927fa621516df32dc4861fd42', 'HW33333333', '3333333333333333', 'All Threes System', 'All Threes Vendor', '333c29d2a12e', 'MP-3522', '2011-01-11 16:02:02', 'license-import@vivipos.com.tw', 'irving.hsu@vivipos.com.tw', '20110111-6-1602', 0),
('1e4a1b03d1b6cd8a174a826f76e009f4d41d8cd98f00b204e9800998ecf8427ed41d8cd98f00b204e9800998ecf8427eca06eb3927fa621516df32dc4861fd42', 'HW00000000', '0000000000000000', '', '', '000c29d2a12e', 'MP-3522', '2011-01-11 16:02:02', 'license-import@vivipos.com.tw', 'irving.hsu@vivipos.com.tw', '20110111-6-1602', 0);
