-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Час створення: Вер 15 2026 р., 14:05
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
-- Структура таблиці `8ydnb966_notif_delivery`
--

CREATE TABLE `8ydnb966_notif_delivery` (
  `id` bigint NOT NULL,
  `event_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `channel` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','sent','delivered','failed','bounced','skipped') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `attempts` int NOT NULL DEFAULT '0',
  `last_error` text COLLATE utf8mb4_unicode_ci,
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_notif_events`
--

CREATE TABLE `8ydnb966_notif_events` (
  `id` bigint NOT NULL,
  `event_key` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_type` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `audience_type` enum('user','group','topic','broadcast') COLLATE utf8mb4_unicode_ci NOT NULL,
  `audience_ref` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `channels` json NOT NULL,
  `priority` tinyint NOT NULL DEFAULT '5',
  `collapse_key` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `payload` json NOT NULL,
  `materialized` tinyint NOT NULL DEFAULT '0',
  `dispatched` tinyint NOT NULL DEFAULT '0',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `expires_at` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_notif_events`
--

INSERT INTO `8ydnb966_notif_events` (`id`, `event_key`, `event_type`, `audience_type`, `audience_ref`, `channels`, `priority`, `collapse_key`, `payload`, `materialized`, `dispatched`, `created_at`, `expires_at`) VALUES
(1, 'cf11a40cbb108d6f94ce37ad94c4423b56623685', 'contact_center.new_message', 'group', '1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 02:37:11\", \"name\": \"Сергій М. 🇺🇦\", \"count\": 10, \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"555\"}', 1, 1, '2026-09-14 05:37:11.850', NULL),
(2, '3fb108100bb8691775a1d809e325b03ba844477a', 'contact_center.new_message', 'group', '1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 02:37:17\", \"name\": \"Сергій М. 🇺🇦\", \"count\": 11, \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"123\"}', 1, 1, '2026-09-14 05:37:17.152', NULL),
(3, '3f67513720d1fd86ce315168f0f3d78149011d6f', 'contact_center.new_message', 'group', '1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 02:53:22\", \"name\": \"Сергій М. 🇺🇦\", \"count\": 12, \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"555\"}', 1, 1, '2026-09-14 05:53:22.078', NULL),
(4, '22214c506a2bfa121c51bf1a46ad82b01dc078b5', 'contact_center.new_message', 'group', '1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 02:53:27\", \"name\": \"Сергій М. 🇺🇦\", \"count\": 13, \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"55\"}', 1, 1, '2026-09-14 05:53:27.358', NULL),
(5, 'c55a7ecf1314dabb3079c50d8ec7b8381cbeee1b', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 03:01:46\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"123\"}', 1, 1, '2026-09-14 06:01:46.193', NULL),
(6, '835097151ffff4555a86da50b2b4a246f90a934a', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 03:01:50\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"3\"}', 1, 1, '2026-09-14 06:01:50.392', NULL),
(7, 'ad1ba9af24e19a110c8065552a15fd083dfd49ea', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 03:01:53\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"2\"}', 1, 1, '2026-09-14 06:01:53.406', NULL),
(8, 'eed2097c7398f588c58f5daae9a98734381a7efc', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 03:01:55\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"5\"}', 1, 1, '2026-09-14 06:01:55.654', NULL),
(9, '50e79994d17476d044641353e10ef2cddd10d699', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 03:03:47\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"6\"}', 1, 1, '2026-09-14 06:03:47.540', NULL),
(10, 'cf460cfe3726ccffc4b4c4116fd93cb4f6b2b260', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 03:03:55\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"3\"}', 1, 1, '2026-09-14 06:03:55.316', NULL),
(11, '4c874560ed2e126b30c6a6be4f2550c661561fa6', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 03:05:07\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"4\"}', 1, 1, '2026-09-14 06:05:07.810', NULL),
(12, '0f5d01900016a36c4c56d73bf2e7612686ac0aac', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 03:05:18\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"123\"}', 1, 1, '2026-09-14 06:05:18.377', NULL),
(13, '7d6b84209862e33ed73984c0a3bb1d539fa603c1', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 03:05:25\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"123\"}', 1, 1, '2026-09-14 06:05:25.953', NULL),
(14, '44012fd65684af3b2445e647dfd542080109d71d', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 03:07:52\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"123\"}', 1, 1, '2026-09-14 06:07:52.770', NULL),
(15, 'a6b4416d791e05486440bd7a2867225c19483a41', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 03:07:55\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"444\"}', 1, 1, '2026-09-14 06:07:55.874', NULL),
(16, 'ef27035e0cc67b33c69aaeb1395840d586b7a645', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 03:10:24\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"5\"}', 1, 1, '2026-09-14 06:10:24.331', NULL),
(17, '98a8c2eea02753adb2ed6983864e962f4e4c5db2', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 03:10:54\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"123\"}', 1, 1, '2026-09-14 06:10:54.337', NULL),
(18, '715d0ec6b4e8d5f2735927244563483402a91296', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 03:10:57\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"3\"}', 1, 1, '2026-09-14 06:10:57.349', NULL),
(19, '3c30d7b6c405fb1888b393e8e100466383a4e22f', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 04:57:23\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"Сергій М. 🇺🇦 +380687207605\"}', 1, 1, '2026-09-14 07:57:23.601', NULL),
(20, '4de6eb107a9861379001324e444d4e5b9e5c798d', 'contact_center.new_message', 'topic', 'contact_center.channel.1', '[\"inapp\"]', 5, 'cc_conv_1', '{\"url\": \"/contact-center/chat/179ad037ac6dd0cfac7f0ee2e755b9c6/\", \"date\": \"2026-09-14 05:18:27\", \"name\": \"Сергій М. 🇺🇦\", \"title\": \"Nota\", \"channel\": \"telegram\", \"message\": \"3333\\n4444\"}', 1, 1, '2026-09-14 08:18:27.436', NULL),
(21, '56e2d85adf34cd123f16eb832010f417224222dc', 'webchat.msg', 'group', '1', '[\"inapp\"]', 5, 'webchat:my-shop-123_v_0bd8e73773b22d339f', '{\"url\": \"/contact-center/webchat//\", \"date\": \"2026-09-14 05:34:38\", \"count\": 1, \"title\": \"skyneuron.com · 0bd8e7\", \"channel\": \"webchat\", \"chat_id\": \"my-shop-123_v_0bd8e73773b22d339f\", \"message\": \"123\"}', 1, 1, '2026-09-14 08:34:38.546', NULL),
(22, '7c7c24dd8ad937029601f91a69939e7093124d2e', 'webchat.msg', 'group', '1', '[\"inapp\"]', 5, 'webchat:my-shop-123_v_0bd8e73773b22d339f', '{\"url\": \"/contact-center/webchat/661f92f71f354f4546bfbd75737ad2a9/\", \"date\": \"2026-09-14 05:35:02\", \"count\": 2, \"title\": \"skyneuron.com · 0bd8e7\", \"channel\": \"webchat\", \"chat_id\": \"my-shop-123_v_0bd8e73773b22d339f\", \"message\": \"123\"}', 1, 1, '2026-09-14 08:35:02.250', NULL),
(23, '5f3e57b0f36756943da26459f7208107df3166fc', 'webchat.msg', 'group', '1', '[\"inapp\"]', 5, 'webchat:my-shop-123_v_0bd8e73773b22d339f', '{\"url\": \"/contact-center/webchat/661f92f71f354f4546bfbd75737ad2a9/\", \"date\": \"2026-09-14 05:38:49\", \"count\": 3, \"title\": \"skyneuron.com · 0bd8e7\", \"channel\": \"webchat\", \"chat_id\": \"my-shop-123_v_0bd8e73773b22d339f\", \"message\": \"123\"}', 1, 1, '2026-09-14 08:38:49.035', NULL),
(24, '5c2d9bcfc92bf2fa39aa65f23c0fd626608f2580', 'webchat.msg', 'group', '1', '[\"inapp\"]', 5, 'webchat:my-shop-123_v_0bd8e73773b22d339f', '{\"url\": \"/contact-center/webchat/661f92f71f354f4546bfbd75737ad2a9/\", \"date\": \"2026-09-14 05:38:58\", \"count\": 4, \"title\": \"skyneuron.com · 0bd8e7\", \"channel\": \"webchat\", \"chat_id\": \"my-shop-123_v_0bd8e73773b22d339f\", \"message\": \"123\"}', 1, 1, '2026-09-14 08:38:58.626', NULL),
(25, '0a8140112502e6589f59d113fe485f2bba4ec219', 'webchat.msg', 'group', '1', '[\"inapp\"]', 5, 'webchat:my-shop-123_v_0bd8e73773b22d339f', '{\"url\": \"/contact-center/webchat/661f92f71f354f4546bfbd75737ad2a9/\", \"date\": \"2026-09-14 05:40:50\", \"count\": 5, \"title\": \"skyneuron.com · 0bd8e7\", \"channel\": \"webchat\", \"chat_id\": \"my-shop-123_v_0bd8e73773b22d339f\", \"message\": \"123\"}', 1, 1, '2026-09-14 08:40:50.044', NULL),
(26, 'b755f77e4938c81329b93e6055f18fd86de2382a', 'webchat.msg', 'group', '1', '[\"inapp\"]', 5, 'webchat:my-shop-123_v_4ea757c811625b51d7', '{\"url\": \"/contact-center/webchat//\", \"date\": \"2026-09-14 05:42:08\", \"count\": 1, \"title\": \"skyneuron.com · 4ea757\", \"channel\": \"webchat\", \"chat_id\": \"my-shop-123_v_4ea757c811625b51d7\", \"message\": \"123\"}', 1, 1, '2026-09-14 08:42:08.834', NULL),
(27, '34d6b58a344e2997ecf90d159fafe34b7644a537', 'webchat.msg', 'group', '1', '[\"inapp\"]', 5, 'webchat:my-shop-123_v_4ea757c811625b51d7', '{\"url\": \"/contact-center/webchat/0f7c083c9922eeb761de9fbe437204bf/\", \"date\": \"2026-09-14 05:45:27\", \"count\": 2, \"title\": \"skyneuron.com · 4ea757\", \"channel\": \"webchat\", \"chat_id\": \"my-shop-123_v_4ea757c811625b51d7\", \"message\": \"333\"}', 1, 1, '2026-09-14 08:45:27.266', NULL),
(28, '339b05ce2a11302111914d5c78306feb36c25ed9', 'webchat.msg', 'group', '1', '[\"inapp\"]', 5, 'webchat:my-shop-123_v_4ea757c811625b51d7', '{\"url\": \"/contact-center/webchat/0f7c083c9922eeb761de9fbe437204bf/\", \"date\": \"2026-09-14 05:45:42\", \"count\": 3, \"title\": \"skyneuron.com · 4ea757\", \"channel\": \"webchat\", \"chat_id\": \"my-shop-123_v_4ea757c811625b51d7\", \"message\": \"333\"}', 1, 1, '2026-09-14 08:45:42.258', NULL),
(29, '29be48084f47aa8c412b63010be1966bf6cfe113', 'webchat.msg', 'group', '1', '[\"inapp\"]', 5, 'webchat:my-shop-123_v_4ea757c811625b51d7', '{\"url\": \"/contact-center/webchat/0f7c083c9922eeb761de9fbe437204bf/\", \"date\": \"2026-09-14 05:45:51\", \"count\": 4, \"title\": \"skyneuron.com · 4ea757\", \"channel\": \"webchat\", \"chat_id\": \"my-shop-123_v_4ea757c811625b51d7\", \"message\": \"4444\"}', 1, 1, '2026-09-14 08:45:51.408', NULL),
(30, '837f4aec4e81bc9d2bdf6d243da68afb6e2eee74', 'webchat.msg', 'group', '1', '[\"inapp\"]', 5, 'webchat:my-shop-123_v_4ea757c811625b51d7', '{\"url\": \"/contact-center/webchat/0f7c083c9922eeb761de9fbe437204bf/\", \"date\": \"2026-09-14 05:48:55\", \"count\": 5, \"title\": \"skyneuron.com · 4ea757\", \"channel\": \"webchat\", \"chat_id\": \"my-shop-123_v_4ea757c811625b51d7\", \"message\": \"123\"}', 1, 1, '2026-09-14 08:48:55.435', NULL),
(31, 'a7dc21ea38de5441f0b924907815d48dbadc8954', 'webchat.msg', 'group', '1', '[\"inapp\"]', 5, 'webchat:my-shop-123_v_4ea757c811625b51d7', '{\"url\": \"/contact-center/webchat/0f7c083c9922eeb761de9fbe437204bf/\", \"date\": \"2026-09-14 06:05:14\", \"count\": 1, \"title\": \"skyneuron.com · 4ea757\", \"channel\": \"webchat\", \"chat_id\": \"my-shop-123_v_4ea757c811625b51d7\", \"message\": \"123\"}', 1, 1, '2026-09-14 09:05:14.372', NULL),
(32, '36dfe420b0c3b2388685890cf7dd1d1ea66a2865', 'webchat.msg', 'group', '1', '[\"inapp\"]', 5, 'webchat:my-shop-123_v_4ea757c811625b51d7', '{\"url\": \"/contact-center/webchat/0f7c083c9922eeb761de9fbe437204bf/\", \"date\": \"2026-09-14 06:05:24\", \"count\": 1, \"title\": \"skyneuron.com · 4ea757\", \"channel\": \"webchat\", \"chat_id\": \"my-shop-123_v_4ea757c811625b51d7\", \"message\": \"123\"}', 1, 1, '2026-09-14 09:05:24.664', NULL),
(33, '9898027e8c6fd7e8b087b7644ab2e9d7432635b0', 'webchat.msg', 'topic', 'contact_center.channel.2', '[\"inapp\"]', 5, 'webchat:my-shop-123_v_4ea757c811625b51d7', '{\"url\": \"/contact-center/webchat/0f7c083c9922eeb761de9fbe437204bf/\", \"date\": \"2026-09-14 07:48:34\", \"count\": 1, \"title\": \"skyneuron.com · 4ea757\", \"channel\": \"webchat\", \"chat_id\": \"my-shop-123_v_4ea757c811625b51d7\", \"message\": \"123\"}', 1, 1, '2026-09-14 10:48:34.067', NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_notif_inbox`
--

CREATE TABLE `8ydnb966_notif_inbox` (
  `id` bigint NOT NULL,
  `event_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `collapse_key` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `seen_at` datetime(3) DEFAULT NULL,
  `read_at` datetime(3) DEFAULT NULL,
  `archived_at` datetime(3) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_notif_inbox`
--

INSERT INTO `8ydnb966_notif_inbox` (`id`, `event_id`, `user_id`, `collapse_key`, `seen_at`, `read_at`, `archived_at`, `created_at`) VALUES
(1, 1, 1, 'cc_conv_1', '2026-09-14 05:37:14.100', NULL, '2026-09-14 06:10:35.212', '2026-09-14 05:37:11.857'),
(2, 2, 1, 'cc_conv_1', '2026-09-14 05:37:45.172', NULL, '2026-09-14 06:10:35.212', '2026-09-14 05:37:17.156'),
(3, 3, 1, 'cc_conv_1', '2026-09-14 05:53:24.399', NULL, '2026-09-14 06:10:35.212', '2026-09-14 05:53:22.085'),
(4, 4, 1, 'cc_conv_1', '2026-09-14 05:53:32.756', NULL, '2026-09-14 06:10:35.212', '2026-09-14 05:53:27.362'),
(5, 9, 1, 'cc_conv_1', '2026-09-14 06:03:50.332', '2026-09-14 06:05:02.401', '2026-09-14 06:10:35.212', '2026-09-14 06:03:47.543'),
(6, 10, 1, 'cc_conv_1', '2026-09-14 06:04:05.092', '2026-09-14 06:05:02.401', '2026-09-14 06:10:35.212', '2026-09-14 06:03:55.319'),
(7, 11, 1, 'cc_conv_1', '2026-09-14 06:05:11.332', '2026-09-14 06:05:22.197', '2026-09-14 06:10:35.212', '2026-09-14 06:05:07.812'),
(8, 12, 1, 'cc_conv_1', '2026-09-14 06:05:29.663', '2026-09-14 06:05:22.197', '2026-09-14 06:10:35.212', '2026-09-14 06:05:18.380'),
(9, 13, 1, 'cc_conv_1', '2026-09-14 06:05:29.663', NULL, '2026-09-14 06:10:35.212', '2026-09-14 06:05:25.956'),
(10, 14, 1, 'cc_conv_1', '2026-09-14 06:07:54.677', NULL, '2026-09-14 06:10:35.212', '2026-09-14 06:07:52.779'),
(11, 15, 1, 'cc_conv_1', '2026-09-14 06:08:00.987', NULL, '2026-09-14 06:10:35.212', '2026-09-14 06:07:55.877'),
(12, 16, 1, 'cc_conv_1', '2026-09-14 06:10:26.050', NULL, '2026-09-14 06:10:35.212', '2026-09-14 06:10:24.335'),
(13, 17, 1, 'cc_conv_1', '2026-09-14 06:10:59.207', '2026-09-14 07:32:40.209', '2026-09-14 07:32:40.209', '2026-09-14 06:10:54.341'),
(14, 18, 1, 'cc_conv_1', '2026-09-14 06:10:59.207', '2026-09-14 07:32:40.209', '2026-09-14 07:32:40.209', '2026-09-14 06:10:57.353'),
(15, 19, 1, 'cc_conv_1', '2026-09-14 08:34:48.511', '2026-09-14 08:03:29.823', '2026-09-14 08:03:29.823', '2026-09-14 07:57:23.788'),
(16, 20, 1, 'cc_conv_1', '2026-09-14 08:34:48.511', '2026-09-14 08:18:31.605', '2026-09-14 08:18:31.605', '2026-09-14 08:18:27.542'),
(17, 21, 1, 'webchat:my-shop-123_v_0bd8e73773b22d339f', '2026-09-14 08:34:48.511', NULL, '2026-09-14 10:48:45.003', '2026-09-14 08:34:38.553'),
(18, 22, 1, 'webchat:my-shop-123_v_0bd8e73773b22d339f', '2026-09-14 08:38:41.164', NULL, '2026-09-14 10:48:45.003', '2026-09-14 08:35:02.264'),
(19, 23, 1, 'webchat:my-shop-123_v_0bd8e73773b22d339f', '2026-09-14 10:48:36.203', NULL, '2026-09-14 10:48:45.003', '2026-09-14 08:38:49.049'),
(20, 24, 1, 'webchat:my-shop-123_v_0bd8e73773b22d339f', '2026-09-14 10:48:36.203', NULL, '2026-09-14 10:48:45.003', '2026-09-14 08:38:58.673'),
(21, 25, 1, 'webchat:my-shop-123_v_0bd8e73773b22d339f', '2026-09-14 10:48:36.203', NULL, '2026-09-14 10:48:45.003', '2026-09-14 08:40:50.051'),
(22, 26, 1, 'webchat:my-shop-123_v_4ea757c811625b51d7', '2026-09-14 10:48:36.203', NULL, '2026-09-14 10:48:44.467', '2026-09-14 08:42:08.865'),
(23, 27, 1, 'webchat:my-shop-123_v_4ea757c811625b51d7', '2026-09-14 10:48:36.203', NULL, '2026-09-14 10:48:44.467', '2026-09-14 08:45:27.277'),
(24, 28, 1, 'webchat:my-shop-123_v_4ea757c811625b51d7', '2026-09-14 10:48:36.203', NULL, '2026-09-14 10:48:44.467', '2026-09-14 08:45:42.264'),
(25, 29, 1, 'webchat:my-shop-123_v_4ea757c811625b51d7', '2026-09-14 10:48:36.203', NULL, '2026-09-14 10:48:44.467', '2026-09-14 08:45:51.439'),
(26, 30, 1, 'webchat:my-shop-123_v_4ea757c811625b51d7', '2026-09-14 10:48:36.203', NULL, '2026-09-14 10:48:44.467', '2026-09-14 08:48:55.444'),
(27, 31, 1, 'webchat:my-shop-123_v_4ea757c811625b51d7', '2026-09-14 10:48:36.203', NULL, '2026-09-14 10:48:44.467', '2026-09-14 09:05:14.379'),
(28, 32, 1, 'webchat:my-shop-123_v_4ea757c811625b51d7', '2026-09-14 10:48:36.203', NULL, '2026-09-14 10:48:44.467', '2026-09-14 09:05:24.668'),
(29, 33, 1, 'webchat:my-shop-123_v_4ea757c811625b51d7', '2026-09-14 10:48:36.203', NULL, '2026-09-14 10:48:44.467', '2026-09-14 10:48:34.188');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_notif_preferences`
--

CREATE TABLE `8ydnb966_notif_preferences` (
  `user_id` bigint NOT NULL,
  `channel` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_type` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `enabled` tinyint NOT NULL DEFAULT '1',
  `quiet_start` time DEFAULT NULL,
  `quiet_end` time DEFAULT NULL,
  `tz` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_notif_read_state`
--

CREATE TABLE `8ydnb966_notif_read_state` (
  `user_id` bigint NOT NULL,
  `topic` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_read_event_id` bigint NOT NULL DEFAULT '0',
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_notif_recipients`
--

CREATE TABLE `8ydnb966_notif_recipients` (
  `id` int UNSIGNED NOT NULL,
  `scope` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `scope_ref` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kind` enum('user','group','topic') COLLATE utf8mb4_unicode_ci NOT NULL,
  `ref` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` json DEFAULT NULL,
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_notif_recipients`
--

INSERT INTO `8ydnb966_notif_recipients` (`id`, `scope`, `scope_ref`, `kind`, `ref`, `options`, `date_add`) VALUES
(2, 'contact_center.channel', '2', 'group', '1', '{\"on_new_message\": 1, \"on_new_conversation\": 1}', '2026-09-14 10:48:21'),
(6, 'contact_center.channel', '3', 'group', '1', '{\"on_new_message\": 1, \"on_new_conversation\": 1}', '2026-09-15 13:49:23');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_notif_subscriptions`
--

CREATE TABLE `8ydnb966_notif_subscriptions` (
  `user_id` bigint NOT NULL,
  `topic` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_notif_subscriptions`
--

INSERT INTO `8ydnb966_notif_subscriptions` (`user_id`, `topic`, `created_at`) VALUES
(1, 'contact_center.channel.1', '2026-09-14 06:03:23.797'),
(1, 'contact_center.channel.2', '2026-09-14 10:08:40.454');

--
-- Індекси збережених таблиць
--

--
-- Індекси таблиці `8ydnb966_notif_delivery`
--
ALTER TABLE `8ydnb966_notif_delivery`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_event_user_channel` (`event_id`,`user_id`,`channel`),
  ADD KEY `idx_status` (`channel`,`status`);

--
-- Індекси таблиці `8ydnb966_notif_events`
--
ALTER TABLE `8ydnb966_notif_events`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_event_key` (`event_key`),
  ADD KEY `idx_dispatch` (`dispatched`,`id`),
  ADD KEY `idx_audience` (`audience_type`,`audience_ref`,`id`),
  ADD KEY `idx_type_time` (`event_type`,`created_at`);

--
-- Індекси таблиці `8ydnb966_notif_inbox`
--
ALTER TABLE `8ydnb966_notif_inbox`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_event_user` (`event_id`,`user_id`),
  ADD KEY `idx_user_unread` (`user_id`,`read_at`,`id`),
  ADD KEY `idx_user_collapse` (`user_id`,`collapse_key`,`id`);

--
-- Індекси таблиці `8ydnb966_notif_preferences`
--
ALTER TABLE `8ydnb966_notif_preferences`
  ADD PRIMARY KEY (`user_id`,`channel`,`event_type`);

--
-- Індекси таблиці `8ydnb966_notif_read_state`
--
ALTER TABLE `8ydnb966_notif_read_state`
  ADD PRIMARY KEY (`user_id`,`topic`);

--
-- Індекси таблиці `8ydnb966_notif_recipients`
--
ALTER TABLE `8ydnb966_notif_recipients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_scope_audience` (`scope`,`scope_ref`,`kind`,`ref`),
  ADD KEY `idx_scope` (`scope`,`scope_ref`);

--
-- Індекси таблиці `8ydnb966_notif_subscriptions`
--
ALTER TABLE `8ydnb966_notif_subscriptions`
  ADD PRIMARY KEY (`user_id`,`topic`),
  ADD KEY `idx_topic` (`topic`);

--
-- AUTO_INCREMENT для збережених таблиць
--

--
-- AUTO_INCREMENT для таблиці `8ydnb966_notif_delivery`
--
ALTER TABLE `8ydnb966_notif_delivery`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_notif_events`
--
ALTER TABLE `8ydnb966_notif_events`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_notif_inbox`
--
ALTER TABLE `8ydnb966_notif_inbox`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_notif_recipients`
--
ALTER TABLE `8ydnb966_notif_recipients`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
