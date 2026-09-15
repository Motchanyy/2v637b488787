-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Час створення: Вер 15 2026 р., 13:56
-- Версія сервера: 8.0.46-0ubuntu0.22.04.4
-- Версія PHP: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База даних: `demo_growthc`
--

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contact_center_attachments`
--

CREATE TABLE `8ydnb966_contact_center_attachments` (
  `id` bigint UNSIGNED NOT NULL,
  `id_message` bigint UNSIGNED NOT NULL,
  `id_conversation` bigint UNSIGNED NOT NULL,
  `id_channel` int UNSIGNED NOT NULL,
  `type` enum('image','video','audio','file','sticker') COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtype` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `thumb_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mime` varchar(127) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size` bigint UNSIGNED DEFAULT NULL,
  `sha256` char(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `width` smallint UNSIGNED DEFAULT NULL,
  `height` smallint UNSIGNED DEFAULT NULL,
  `duration` int UNSIGNED DEFAULT NULL,
  `waveform` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source_type` enum('none','url','telegram_file_id') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'none',
  `source_ref` text COLLATE utf8mb4_unicode_ci,
  `source_expires` datetime DEFAULT NULL,
  `status` enum('pending','processing','done','failed','skipped') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `attempts` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `error` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_next_try` datetime DEFAULT NULL,
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contact_center_attachments`
--

INSERT INTO `8ydnb966_contact_center_attachments` (`id`, `id_message`, `id_conversation`, `id_channel`, `type`, `subtype`, `sort_order`, `path`, `thumb_path`, `file_name`, `mime`, `size`, `sha256`, `width`, `height`, `duration`, `waveform`, `source_type`, `source_ref`, `source_expires`, `status`, `attempts`, `error`, `date_next_try`, `date_add`, `date_edit`) VALUES
(1, 6, 1, 1, 'image', NULL, 0, '/assets/contact-center/telegram/179ad037ac6dd0cfac7f0ee2e755b9c6/client/36a8b4bd98a2d5eb8aaeabb3abeee368.bin', NULL, NULL, 'application/octet-stream', 48329, '36a8b4bd98a2d5eb8aaeabb3abeee368f98cac710011b122b34c98692dbf308a', 623, 646, NULL, NULL, 'telegram_file_id', 'AgACAgIAAxkBAAMLaqdWpm-_C9W-c3j8-sbHAfIZ8P4AAj8oaxvFrzhJmdm53sZ6VAABAQADAgADeAADPQQ', NULL, 'done', 1, NULL, '2026-09-14 05:06:31', '2026-09-14 05:06:30', '2026-09-14 08:18:27'),
(2, 33, 1, 1, 'image', NULL, 0, '/assets/contact-center/telegram/179ad037ac6dd0cfac7f0ee2e755b9c6/manager/faec9912aa30386a675353125ad0b065.png', NULL, 'novyiÌproekt.png', 'image/png', 242008, NULL, NULL, NULL, NULL, NULL, 'none', NULL, NULL, 'done', 0, NULL, NULL, '2026-09-14 08:17:25', '2026-09-14 08:17:25'),
(3, 34, 1, 1, 'image', NULL, 0, '/assets/contact-center/telegram/179ad037ac6dd0cfac7f0ee2e755b9c6/client/36a8b4bd98a2d5eb8aaeabb3abeee368.bin', NULL, NULL, 'application/octet-stream', 48329, '36a8b4bd98a2d5eb8aaeabb3abeee368f98cac710011b122b34c98692dbf308a', 623, 646, NULL, NULL, 'telegram_file_id', 'AgACAgIAAxkBAAMLaqdWpm-_C9W-c3j8-sbHAfIZ8P4AAj8oaxvFrzhJmdm53sZ6VAABAQADAgADeAADPQQ', NULL, 'done', 1, NULL, '2026-09-14 08:18:27', '2026-09-14 08:18:27', '2026-09-14 08:18:27');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contact_center_channels`
--

CREATE TABLE `8ydnb966_contact_center_channels` (
  `id` int UNSIGNED NOT NULL,
  `type` enum('telegram','instagram','webchat') COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `is_configured` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `connection_status` enum('unknown','ok','error') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unknown',
  `connection_error` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_checked` datetime DEFAULT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `id_user` int UNSIGNED DEFAULT NULL,
  `id_user_edited` int UNSIGNED DEFAULT NULL,
  `id_user_deleted` int UNSIGNED DEFAULT NULL,
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `date_deleted` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contact_center_channels`
--

INSERT INTO `8ydnb966_contact_center_channels` (`id`, `type`, `name`, `status`, `is_configured`, `connection_status`, `connection_error`, `date_checked`, `sort_order`, `id_user`, `id_user_edited`, `id_user_deleted`, `date_add`, `date_edit`, `deleted`, `date_deleted`) VALUES
(1, 'telegram', 'Nota', 1, 1, 'ok', NULL, '2026-09-14 04:54:38', 0, 1, 1, NULL, '2026-09-13 10:34:14', '2026-09-14 04:54:38', 0, NULL),
(2, 'webchat', 'Веб чат', 1, 1, 'ok', NULL, '2026-09-14 09:56:18', 0, 1, 1, NULL, '2026-09-14 08:20:20', '2026-09-14 09:56:18', 0, NULL),
(3, 'instagram', 'Інстаграм', 1, 1, 'ok', NULL, '2026-09-15 13:49:20', 0, 1, 1, NULL, '2026-09-15 13:46:03', '2026-09-15 13:49:20', 0, NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contact_center_channel_instagram`
--

CREATE TABLE `8ydnb966_contact_center_channel_instagram` (
  `id` int UNSIGNED NOT NULL,
  `id_channel` int UNSIGNED NOT NULL,
  `ig_user_id` bigint UNSIGNED DEFAULT NULL,
  `ig_username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ig_account_type` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ig_profile_picture` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token_cipher` varbinary(2048) NOT NULL,
  `token_iv` varbinary(16) NOT NULL,
  `token_tag` varbinary(16) NOT NULL,
  `token_type` enum('short_lived','long_lived') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'long_lived',
  `date_token_expires` datetime DEFAULT NULL,
  `date_token_refresh` datetime DEFAULT NULL,
  `app_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `verify_token` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date_deleted` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contact_center_channel_instagram`
--

INSERT INTO `8ydnb966_contact_center_channel_instagram` (`id`, `id_channel`, `ig_user_id`, `ig_username`, `ig_account_type`, `ig_profile_picture`, `token_cipher`, `token_iv`, `token_tag`, `token_type`, `date_token_expires`, `date_token_refresh`, `app_id`, `verify_token`, `date_add`, `date_edit`, `date_deleted`) VALUES
(1, 3, 28904921762478867, 'skyneuron', 'BUSINESS', 'https://scontent-fra3-2.cdninstagram.com/v/t51.75761-19/503134545_17931070467048201_7531734332733236815_n.jpg?stp=dst-jpg_s206x206_tt6&_nc_cat=104&ccb=7-5&_nc_sid=bf7eb4&efg=eyJ2ZW5jb2RlX3RhZyI6InByb2ZpbGVfcGljLnd3dy41MTIuQzMifQ%3D%3D&_nc_ohc=_ebbnPI8WTAQ7kNvwHAfyHR&_nc_oc=AdoHE-hgstt89q3gQTG3YMuMqAjNCtf3ARa3cAcHR8WdBEu3VSML9MPU0wwPHjYI0y-QE4JeE1uNvuFoJqcn3G-P&_nc_zt=24&_nc_ht=scontent-fra3-2.cdninstagram.com&edm=AP4hL3IEAAAA&_nc_gid=_ZC9VKpeHF5nfqbLMFefLA&_nc_tpa=Q5bMBQJx16XEDRE9F1BdEAixki6Oh1m--xhV7EQ8wzvVWTBQmyHEPeJgJ7g9XSV_GzpL758jRJrU61PcFg&oh=00_AQI4aZDLJ4D7BQVtarhkNIFZS2iuJrsTWqMWVBH5OLSe1A&oe=6AAF03A7', 0xd1eba0249798af1f24dd4c5951cb9831d595ca074a355b607f118aeaa7705f3ad888c62c21ea559e8dc47cab9598c05454b303ee6ef32ce6e3190552e76201e4ce015c7615d64f304c8cd31eba355002535d32b6daf0f0140c9b00d69b1b3058a03d4bd9da3d16be51e7845e3541980345a1cd5cb6ec43b4597ae9190a763a7172ae847e96bf7c4f81b7920bc6fbbdefd25deec82be76e31c9921a08abec870b47ab1bedb64b8c5ab365917c92c90287e059546142e6d3, 0x501f399674326028580d7010, 0x3ad9017f3fc5ac71650caf0562170399, 'long_lived', NULL, '2026-09-15 13:47:13', '936825515455008', '58c344877c5aa8e1e4d579883f1879f147c4de1720748316ffdf52d670c49ea7', '2026-09-15 13:46:03', '2026-09-15 13:49:23', NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contact_center_channel_telegram`
--

CREATE TABLE `8ydnb966_contact_center_channel_telegram` (
  `id` int UNSIGNED NOT NULL,
  `id_channel` int UNSIGNED NOT NULL,
  `bot_id` bigint UNSIGNED DEFAULT NULL,
  `bot_username` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bot_first_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token_cipher` varbinary(512) NOT NULL,
  `token_iv` varbinary(16) NOT NULL,
  `token_tag` varbinary(16) NOT NULL,
  `token_last4` char(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `webhook_secret` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `webhook_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `webhook_set` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `date_webhook_set` datetime DEFAULT NULL,
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date_deleted` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contact_center_channel_telegram`
--

INSERT INTO `8ydnb966_contact_center_channel_telegram` (`id`, `id_channel`, `bot_id`, `bot_username`, `bot_first_name`, `token_cipher`, `token_iv`, `token_tag`, `token_last4`, `webhook_secret`, `webhook_url`, `webhook_set`, `date_webhook_set`, `date_add`, `date_edit`, `date_deleted`) VALUES
(1, 1, 8901023557, 'nota_bene_shopbot', 'nota_benebot', 0x82037d808cb999059d21b96d1a197fef5057cc86433207fdcff017141dd5a0f6d38d47d9b2a37ac6fecf07d50f70, 0xcc636cea1ab8a2a0e4a9a6b1, 0xc9ffd5264a74180366abaee6bd100af9, 'LN1U', '7be8deef77cdc5e63158fc16134c47451373c0e4b8cf428591463f22165f94d8', 'https://demo.growthcontour.com/api/contact-center/webhook/telegram/7be8deef77cdc5e63158fc16134c47451373c0e4b8cf428591463f22165f94d8/', 1, '2026-09-14 04:54:38', '2026-09-13 10:34:14', '2026-09-14 04:54:38', NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contact_center_channel_webchat`
--

CREATE TABLE `8ydnb966_contact_center_channel_webchat` (
  `id` int UNSIGNED NOT NULL,
  `id_channel` int UNSIGNED NOT NULL,
  `site_id` varchar(190) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `allowed_origins` text COLLATE utf8mb4_unicode_ci,
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date_deleted` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contact_center_channel_webchat`
--

INSERT INTO `8ydnb966_contact_center_channel_webchat` (`id`, `id_channel`, `site_id`, `allowed_origins`, `date_add`, `date_edit`, `date_deleted`) VALUES
(1, 2, 'my-shop-123', 'skyneuron.com', '2026-09-14 08:20:20', '2026-09-14 09:12:14', NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contact_center_contacts`
--

CREATE TABLE `8ydnb966_contact_center_contacts` (
  `id` bigint UNSIGNED NOT NULL,
  `id_channel` int UNSIGNED NOT NULL,
  `external_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lang` varchar(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timezone` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `blocked` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `attributes` json DEFAULT NULL,
  `id_crm_contact` int UNSIGNED DEFAULT NULL,
  `date_last_seen` datetime DEFAULT NULL,
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contact_center_contacts`
--

INSERT INTO `8ydnb966_contact_center_contacts` (`id`, `id_channel`, `external_id`, `name`, `first_name`, `last_name`, `username`, `avatar`, `phone`, `email`, `lang`, `timezone`, `blocked`, `attributes`, `id_crm_contact`, `date_last_seen`, `date_add`, `date_edit`) VALUES
(1, 1, '339284801', 'Сергій М. 🇺🇦', 'Сергій', 'М. 🇺🇦', 'motchanyy', NULL, NULL, NULL, 'uk', NULL, 0, '{\"is_bot\": false, \"chat_type\": \"private\"}', NULL, '2026-09-14 08:18:27', '2026-09-14 04:54:51', '2026-09-14 08:18:27'),
(30, 2, 'my-shop-123_v_0bd8e73773b22d339f', 'v_0bd8e73773b22d339f', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '{\"site_id\": \"my-shop-123\", \"visitor_id\": \"v_0bd8e73773b22d339f\"}', NULL, '2026-09-14 08:40:50', '2026-09-14 08:40:50', '2026-09-14 08:40:50'),
(31, 2, 'my-shop-123_v_4ea757c811625b51d7', 'v_4ea757c811625b51d7', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '{\"site_id\": \"my-shop-123\", \"visitor_id\": \"v_4ea757c811625b51d7\"}', NULL, '2026-09-14 10:48:34', '2026-09-14 08:42:08', '2026-09-14 10:48:34');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contact_center_conversations`
--

CREATE TABLE `8ydnb966_contact_center_conversations` (
  `id` bigint UNSIGNED NOT NULL,
  `id_channel` int UNSIGNED NOT NULL,
  `id_contact` bigint UNSIGNED NOT NULL,
  `status` enum('open','pending','resolved','archived') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `id_manager` int UNSIGNED DEFAULT NULL,
  `priority` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `url_token` char(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_thread_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_last_message` bigint UNSIGNED DEFAULT NULL,
  `last_message_text` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_message_type` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_message_dir` enum('in','out') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_last_message` datetime(3) DEFAULT NULL,
  `date_last_inbound` datetime(3) DEFAULT NULL,
  `date_first_reply` datetime(3) DEFAULT NULL,
  `messages_count` int UNSIGNED NOT NULL DEFAULT '0',
  `date_resolved` datetime DEFAULT NULL,
  `date_archived` datetime DEFAULT NULL,
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contact_center_conversations`
--

INSERT INTO `8ydnb966_contact_center_conversations` (`id`, `id_channel`, `id_contact`, `status`, `id_manager`, `priority`, `url_token`, `source_thread_id`, `id_last_message`, `last_message_text`, `last_message_type`, `last_message_dir`, `date_last_message`, `date_last_inbound`, `date_first_reply`, `messages_count`, `date_resolved`, `date_archived`, `date_add`, `date_edit`) VALUES
(1, 1, 1, 'resolved', 1, 0, '179ad037ac6dd0cfac7f0ee2e755b9c6', '339284801', 34, '3333 4444', 'media', 'in', '2026-09-14 08:18:27.000', '2026-09-14 08:18:27.000', '2026-09-14 04:59:14.218', 34, '2026-09-14 08:35:39', NULL, '2026-09-14 04:54:51', '2026-09-14 08:35:39'),
(2, 2, 30, 'open', 1, 0, 'f66a30a817d9d6bfd32d6996c1fbaf88', 'my-shop-123_v_0bd8e73773b22d339f', 38, '🤭🤭', 'text', 'out', '2026-09-14 08:41:36.326', '2026-09-14 08:40:50.031', '2026-09-14 08:41:06.172', 4, NULL, NULL, '2026-09-14 08:40:50', '2026-09-14 08:41:36'),
(3, 2, 31, 'open', 1, 0, '169c1b6da7e890c78021b73c0abadc96', 'my-shop-123_v_4ea757c811625b51d7', 61, '123', 'text', 'in', '2026-09-14 07:48:34.000', '2026-09-14 07:48:34.000', '2026-09-14 08:42:15.939', 17, NULL, NULL, '2026-09-14 08:42:08', '2026-09-14 10:48:34');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contact_center_messages`
--

CREATE TABLE `8ydnb966_contact_center_messages` (
  `id` bigint UNSIGNED NOT NULL,
  `id_conversation` bigint UNSIGNED NOT NULL,
  `id_channel` int UNSIGNED NOT NULL,
  `direction` enum('in','out') COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_manager` int UNSIGNED DEFAULT NULL,
  `source_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` enum('text','media','location','contact','sticker','poll','system','event') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'text',
  `subtype` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `text` mediumtext COLLATE utf8mb4_unicode_ci,
  `id_reply_to` bigint UNSIGNED DEFAULT NULL,
  `lat` decimal(10,7) DEFAULT NULL,
  `lng` decimal(10,7) DEFAULT NULL,
  `attributes` json DEFAULT NULL,
  `status` enum('pending','sent','delivered','read','failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'sent',
  `error` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `has_attachments` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `date_edited` datetime(3) DEFAULT NULL,
  `date_deleted` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contact_center_messages`
--

INSERT INTO `8ydnb966_contact_center_messages` (`id`, `id_conversation`, `id_channel`, `direction`, `id_manager`, `source_id`, `type`, `subtype`, `text`, `id_reply_to`, `lat`, `lng`, `attributes`, `status`, `error`, `has_attachments`, `date_add`, `date_edited`, `date_deleted`) VALUES
(1, 1, 1, 'in', NULL, '6', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 04:54:51.000', NULL, NULL),
(2, 1, 1, 'in', NULL, '7', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 04:55:00.000', NULL, NULL),
(3, 1, 1, 'in', NULL, '8', 'text', NULL, '333', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 04:55:07.000', NULL, NULL),
(4, 1, 1, 'out', 1, '9', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'sent', NULL, 0, '2026-09-14 04:59:14.218', NULL, NULL),
(5, 1, 1, 'out', 1, '10', 'text', NULL, '3333333', NULL, NULL, NULL, NULL, 'sent', NULL, 0, '2026-09-14 04:59:21.101', NULL, NULL),
(6, 1, 1, 'in', NULL, '11', 'media', NULL, NULL, NULL, NULL, NULL, NULL, 'delivered', NULL, 1, '2026-09-14 05:06:30.000', NULL, NULL),
(7, 1, 1, 'in', NULL, '12', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 05:06:34.000', NULL, NULL),
(8, 1, 1, 'in', NULL, '13', 'text', NULL, '3333', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 05:24:59.000', NULL, NULL),
(9, 1, 1, 'in', NULL, '14', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 05:25:06.000', NULL, NULL),
(10, 1, 1, 'in', NULL, '15', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 05:33:20.000', NULL, NULL),
(11, 1, 1, 'in', NULL, '16', 'text', NULL, '44', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 05:33:31.000', NULL, NULL),
(12, 1, 1, 'in', NULL, '17', 'text', NULL, '555', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 05:37:11.000', NULL, NULL),
(13, 1, 1, 'in', NULL, '18', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 05:37:17.000', NULL, NULL),
(14, 1, 1, 'in', NULL, '19', 'text', NULL, '555', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 05:53:22.000', NULL, NULL),
(15, 1, 1, 'in', NULL, '20', 'text', NULL, '55', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 05:53:27.000', NULL, NULL),
(16, 1, 1, 'in', NULL, '21', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:01:46.000', NULL, NULL),
(17, 1, 1, 'in', NULL, '22', 'text', NULL, '3', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:01:50.000', NULL, NULL),
(18, 1, 1, 'in', NULL, '23', 'text', NULL, '2', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:01:53.000', NULL, NULL),
(19, 1, 1, 'in', NULL, '24', 'text', NULL, '5', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:01:55.000', NULL, NULL),
(20, 1, 1, 'in', NULL, '25', 'text', NULL, '6', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:03:47.000', NULL, NULL),
(21, 1, 1, 'in', NULL, '26', 'text', NULL, '3', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:03:55.000', NULL, NULL),
(22, 1, 1, 'in', NULL, '27', 'text', NULL, '4', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:05:07.000', NULL, NULL),
(23, 1, 1, 'in', NULL, '28', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:05:18.000', NULL, NULL),
(24, 1, 1, 'in', NULL, '29', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:05:25.000', NULL, NULL),
(25, 1, 1, 'in', NULL, '30', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:07:52.000', NULL, NULL),
(26, 1, 1, 'in', NULL, '31', 'text', NULL, '444', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:07:55.000', NULL, NULL),
(27, 1, 1, 'in', NULL, '32', 'text', NULL, '5', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:10:24.000', NULL, NULL),
(28, 1, 1, 'in', NULL, '33', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:10:54.000', NULL, NULL),
(29, 1, 1, 'in', NULL, '34', 'text', NULL, '3', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:10:57.000', NULL, NULL),
(30, 1, 1, 'out', 1, '35', 'system', 'request_contact', 'Поділитися номером', NULL, NULL, NULL, NULL, 'sent', NULL, 0, '2026-09-14 07:57:16.853', NULL, NULL),
(31, 1, 1, 'in', NULL, '36', 'contact', NULL, 'Сергій М. 🇺🇦 +380687207605', NULL, NULL, NULL, '{\"reply_to_source_id\": \"35\"}', 'delivered', NULL, 0, '2026-09-14 07:57:23.000', NULL, NULL),
(32, 1, 1, 'out', 1, '37', 'text', NULL, '😃😀😘', NULL, NULL, NULL, NULL, 'sent', NULL, 0, '2026-09-14 08:08:25.637', NULL, NULL),
(33, 1, 1, 'out', 1, '38', 'media', NULL, '123', NULL, NULL, NULL, NULL, 'sent', NULL, 1, '2026-09-14 08:17:25.326', NULL, NULL),
(34, 1, 1, 'in', NULL, '39', 'media', NULL, '3333\n4444', NULL, NULL, NULL, NULL, 'delivered', NULL, 1, '2026-09-14 08:18:27.000', NULL, NULL),
(35, 2, 2, 'in', NULL, 'wc_62', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 08:40:50.031', NULL, NULL),
(36, 2, 2, 'out', 1, NULL, 'text', NULL, '123', NULL, NULL, NULL, NULL, 'sent', NULL, 0, '2026-09-14 08:41:06.172', NULL, NULL),
(37, 2, 2, 'out', 1, NULL, 'text', NULL, '333', NULL, NULL, NULL, NULL, 'sent', NULL, 0, '2026-09-14 08:41:15.516', NULL, NULL),
(38, 2, 2, 'out', 1, NULL, 'text', NULL, '🤭🤭', NULL, NULL, NULL, NULL, 'sent', NULL, 0, '2026-09-14 08:41:36.326', NULL, NULL),
(39, 3, 2, 'in', NULL, 'wc_63', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 08:42:08.827', NULL, NULL),
(40, 3, 2, 'out', 1, NULL, 'text', NULL, '123', NULL, NULL, NULL, NULL, 'read', NULL, 0, '2026-09-14 08:42:15.939', NULL, NULL),
(41, 3, 2, 'out', 1, NULL, 'text', NULL, '4444444', NULL, NULL, NULL, NULL, 'read', NULL, 0, '2026-09-14 08:42:20.650', NULL, NULL),
(42, 3, 2, 'out', 1, 'wc_65', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'read', NULL, 0, '2026-09-14 08:45:17.027', NULL, NULL),
(43, 3, 2, 'in', NULL, 'wc_66', 'text', NULL, '333', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 08:45:27.252', NULL, NULL),
(45, 3, 2, 'out', 1, 'wc_67', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'read', NULL, 0, '2026-09-14 08:45:38.833', NULL, NULL),
(46, 3, 2, 'in', NULL, 'wc_68', 'text', NULL, '333', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 08:45:42.251', NULL, NULL),
(48, 3, 2, 'in', NULL, 'wc_69', 'text', NULL, '4444', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 08:45:51.402', NULL, NULL),
(50, 3, 2, 'in', NULL, 'wc_70', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 05:48:55.000', NULL, NULL),
(52, 3, 2, 'in', NULL, 'wc_71', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:05:14.000', NULL, NULL),
(54, 3, 2, 'in', NULL, 'wc_73', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 06:05:24.000', NULL, NULL),
(56, 3, 2, 'out', 1, 'wc_74', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'read', NULL, 0, '2026-09-14 09:05:34.209', NULL, NULL),
(57, 3, 2, 'out', 1, 'wc_75', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'read', NULL, 0, '2026-09-14 09:05:40.474', NULL, NULL),
(58, 3, 2, 'out', 1, 'wc_76', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'read', NULL, 0, '2026-09-14 09:07:01.297', NULL, NULL),
(59, 3, 2, 'out', 1, 'wc_77', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'read', NULL, 0, '2026-09-14 09:11:31.142', NULL, NULL),
(60, 3, 2, 'out', 1, 'wc_78', 'text', NULL, '33', NULL, NULL, NULL, NULL, 'read', NULL, 0, '2026-09-14 09:11:35.345', NULL, NULL),
(61, 3, 2, 'in', NULL, 'wc_79', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, 0, '2026-09-14 07:48:34.000', NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contact_center_unread`
--

CREATE TABLE `8ydnb966_contact_center_unread` (
  `id_conversation` bigint UNSIGNED NOT NULL,
  `id_manager` int UNSIGNED NOT NULL,
  `count` int UNSIGNED NOT NULL DEFAULT '0',
  `id_last_read_message` bigint UNSIGNED DEFAULT NULL,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contact_center_unread`
--

INSERT INTO `8ydnb966_contact_center_unread` (`id_conversation`, `id_manager`, `count`, `id_last_read_message`, `date_edit`) VALUES
(1, 1, 0, 34, '2026-09-14 08:18:31'),
(2, 1, 0, 38, '2026-09-15 12:17:01'),
(3, 1, 0, 61, '2026-09-14 10:48:47');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contact_label_dict`
--

CREATE TABLE `8ydnb966_contact_label_dict` (
  `id` smallint UNSIGNED NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'work, home, personal, wife...',
  `sort` tinyint UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contact_label_dict`
--

INSERT INTO `8ydnb966_contact_label_dict` (`id`, `code`, `sort`) VALUES
(1, 'work', 1),
(2, 'home', 2),
(3, 'personal', 3),
(4, 'wife', 4),
(5, 'husband', 5),
(6, 'accountant', 6);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contact_label_dict_lang`
--

CREATE TABLE `8ydnb966_contact_label_dict_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_label` smallint UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contact_label_dict_lang`
--

INSERT INTO `8ydnb966_contact_label_dict_lang` (`id`, `id_label`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Робочий'),
(2, 1, 2, 'Work'),
(3, 2, 1, 'Домашній'),
(4, 2, 2, 'Home'),
(5, 3, 1, 'Особистий'),
(6, 3, 2, 'Personal'),
(7, 4, 1, 'Дружина'),
(8, 4, 2, 'Wife'),
(9, 5, 1, 'Чоловік'),
(10, 5, 2, 'Husband'),
(11, 6, 1, 'Бухгалтер'),
(12, 6, 2, 'Accountant');

--
-- Індекси збережених таблиць
--

--
-- Індекси таблиці `8ydnb966_contact_center_attachments`
--
ALTER TABLE `8ydnb966_contact_center_attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_message` (`id_message`,`sort_order`),
  ADD KEY `idx_conv_type` (`id_conversation`,`type`,`id`),
  ADD KEY `idx_queue` (`status`,`date_next_try`,`id`),
  ADD KEY `idx_sha256` (`sha256`),
  ADD KEY `fk_cc_att_channel` (`id_channel`);

--
-- Індекси таблиці `8ydnb966_contact_center_channels`
--
ALTER TABLE `8ydnb966_contact_center_channels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_type_deleted_status` (`type`,`deleted`,`status`),
  ADD KEY `idx_deleted_sort` (`deleted`,`sort_order`,`id`),
  ADD KEY `idx_id_user` (`id_user`);

--
-- Індекси таблиці `8ydnb966_contact_center_channel_instagram`
--
ALTER TABLE `8ydnb966_contact_center_channel_instagram`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_channel` (`id_channel`),
  ADD UNIQUE KEY `uniq_ig_user` (`ig_user_id`,`date_deleted`),
  ADD KEY `idx_token_expires` (`date_token_expires`);

--
-- Індекси таблиці `8ydnb966_contact_center_channel_telegram`
--
ALTER TABLE `8ydnb966_contact_center_channel_telegram`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_channel` (`id_channel`),
  ADD UNIQUE KEY `uniq_webhook_secret` (`webhook_secret`),
  ADD UNIQUE KEY `uniq_bot_id` (`bot_id`,`date_deleted`);

--
-- Індекси таблиці `8ydnb966_contact_center_channel_webchat`
--
ALTER TABLE `8ydnb966_contact_center_channel_webchat`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_channel` (`id_channel`),
  ADD UNIQUE KEY `uniq_site_id` (`site_id`);

--
-- Індекси таблиці `8ydnb966_contact_center_contacts`
--
ALTER TABLE `8ydnb966_contact_center_contacts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_channel_external` (`id_channel`,`external_id`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_phone` (`phone`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_crm_contact` (`id_crm_contact`);

--
-- Індекси таблиці `8ydnb966_contact_center_conversations`
--
ALTER TABLE `8ydnb966_contact_center_conversations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_url_token` (`url_token`),
  ADD UNIQUE KEY `uniq_contact_active` (`id_contact`,`date_resolved`,`date_archived`),
  ADD KEY `idx_status_last` (`status`,`date_last_message`,`id`),
  ADD KEY `idx_manager_status` (`id_manager`,`status`,`date_last_message`),
  ADD KEY `idx_channel_status` (`id_channel`,`status`,`date_last_message`),
  ADD KEY `idx_thread` (`id_channel`,`source_thread_id`);

--
-- Індекси таблиці `8ydnb966_contact_center_messages`
--
ALTER TABLE `8ydnb966_contact_center_messages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_conv_source` (`id_conversation`,`source_id`),
  ADD KEY `idx_conv_id` (`id_conversation`,`id`),
  ADD KEY `idx_conv_date` (`id_conversation`,`date_add`),
  ADD KEY `idx_channel_date` (`id_channel`,`date_add`),
  ADD KEY `idx_reply` (`id_reply_to`),
  ADD KEY `idx_status_pending` (`status`,`date_add`);

--
-- Індекси таблиці `8ydnb966_contact_center_unread`
--
ALTER TABLE `8ydnb966_contact_center_unread`
  ADD PRIMARY KEY (`id_conversation`,`id_manager`),
  ADD KEY `idx_manager_count` (`id_manager`,`count`);

--
-- Індекси таблиці `8ydnb966_contact_label_dict`
--
ALTER TABLE `8ydnb966_contact_label_dict`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_code` (`code`);

--
-- Індекси таблиці `8ydnb966_contact_label_dict_lang`
--
ALTER TABLE `8ydnb966_contact_label_dict_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_label_lang` (`id_label`,`id_lang`);

--
-- AUTO_INCREMENT для збережених таблиць
--

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_attachments`
--
ALTER TABLE `8ydnb966_contact_center_attachments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_channels`
--
ALTER TABLE `8ydnb966_contact_center_channels`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_channel_instagram`
--
ALTER TABLE `8ydnb966_contact_center_channel_instagram`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_channel_telegram`
--
ALTER TABLE `8ydnb966_contact_center_channel_telegram`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_channel_webchat`
--
ALTER TABLE `8ydnb966_contact_center_channel_webchat`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_contacts`
--
ALTER TABLE `8ydnb966_contact_center_contacts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_conversations`
--
ALTER TABLE `8ydnb966_contact_center_conversations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_messages`
--
ALTER TABLE `8ydnb966_contact_center_messages`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_label_dict`
--
ALTER TABLE `8ydnb966_contact_label_dict`
  MODIFY `id` smallint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_label_dict_lang`
--
ALTER TABLE `8ydnb966_contact_label_dict_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Обмеження зовнішнього ключа збережених таблиць
--

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_contact_center_attachments`
--
ALTER TABLE `8ydnb966_contact_center_attachments`
  ADD CONSTRAINT `fk_cc_att_channel` FOREIGN KEY (`id_channel`) REFERENCES `8ydnb966_contact_center_channels` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cc_att_conv` FOREIGN KEY (`id_conversation`) REFERENCES `8ydnb966_contact_center_conversations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cc_att_msg` FOREIGN KEY (`id_message`) REFERENCES `8ydnb966_contact_center_messages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_contact_center_channel_instagram`
--
ALTER TABLE `8ydnb966_contact_center_channel_instagram`
  ADD CONSTRAINT `fk_cc_ig_channel` FOREIGN KEY (`id_channel`) REFERENCES `8ydnb966_contact_center_channels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_contact_center_channel_telegram`
--
ALTER TABLE `8ydnb966_contact_center_channel_telegram`
  ADD CONSTRAINT `fk_cc_tg_channel` FOREIGN KEY (`id_channel`) REFERENCES `8ydnb966_contact_center_channels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_contact_center_channel_webchat`
--
ALTER TABLE `8ydnb966_contact_center_channel_webchat`
  ADD CONSTRAINT `fk_cc_wc_channel` FOREIGN KEY (`id_channel`) REFERENCES `8ydnb966_contact_center_channels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_contact_center_contacts`
--
ALTER TABLE `8ydnb966_contact_center_contacts`
  ADD CONSTRAINT `fk_cc_contact_channel` FOREIGN KEY (`id_channel`) REFERENCES `8ydnb966_contact_center_channels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_contact_center_conversations`
--
ALTER TABLE `8ydnb966_contact_center_conversations`
  ADD CONSTRAINT `fk_cc_conv_channel` FOREIGN KEY (`id_channel`) REFERENCES `8ydnb966_contact_center_channels` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cc_conv_contact` FOREIGN KEY (`id_contact`) REFERENCES `8ydnb966_contact_center_contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_contact_center_messages`
--
ALTER TABLE `8ydnb966_contact_center_messages`
  ADD CONSTRAINT `fk_cc_msg_channel` FOREIGN KEY (`id_channel`) REFERENCES `8ydnb966_contact_center_channels` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cc_msg_conv` FOREIGN KEY (`id_conversation`) REFERENCES `8ydnb966_contact_center_conversations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cc_msg_reply` FOREIGN KEY (`id_reply_to`) REFERENCES `8ydnb966_contact_center_messages` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_contact_center_unread`
--
ALTER TABLE `8ydnb966_contact_center_unread`
  ADD CONSTRAINT `fk_cc_unread_conv` FOREIGN KEY (`id_conversation`) REFERENCES `8ydnb966_contact_center_conversations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_contact_label_dict_lang`
--
ALTER TABLE `8ydnb966_contact_label_dict_lang`
  ADD CONSTRAINT `fk_clabel_lang` FOREIGN KEY (`id_label`) REFERENCES `8ydnb966_contact_label_dict` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
