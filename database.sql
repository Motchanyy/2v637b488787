-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Час створення: Вер 17 2026 р., 18:31
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
-- Структура таблиці `8ydnb966_calendar_events`
--

CREATE TABLE `8ydnb966_calendar_events` (
  `id` bigint UNSIGNED NOT NULL,
  `id_user_creator` int UNSIGNED NOT NULL,
  `id_event_type` tinyint UNSIGNED DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_start` datetime NOT NULL,
  `date_end` datetime NOT NULL,
  `all_day` tinyint(1) NOT NULL DEFAULT '0',
  `tz_offset` smallint NOT NULL DEFAULT '0' COMMENT 'зсув таймзони автора у хвилинах на момент створення',
  `priority` tinyint UNSIGNED NOT NULL DEFAULT '2' COMMENT '1-низький 2-середній 3-високий 4-критичний',
  `status` tinyint UNSIGNED NOT NULL DEFAULT '1' COMMENT '1-planned 2-done 3-canceled',
  `is_shared` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0-лише автор, 1-є інші учасники',
  `visibility` tinyint UNSIGNED NOT NULL DEFAULT '1' COMMENT '1-private 2-busy 3-team(резерв) 4-company',
  `notify_scope` tinyint UNSIGNED NOT NULL DEFAULT '2' COMMENT '0-none 1-me 2-participants 3-team(резерв) 4-company',
  `is_busy` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1-час зайнятий (впливає на Free/Busy), 0-вільний',
  `participants_cnt` smallint UNSIGNED NOT NULL DEFAULT '1' COMMENT 'денормалізований лічильник, разом з автором',
  `reminder_minutes` smallint UNSIGNED DEFAULT NULL COMMENT 'NULL = без нагадування',
  `id_ref_type` tinyint UNSIGNED DEFAULT NULL COMMENT 'зв''язок із сутністю CRM: 1-deal 2-company 3-contact 4-lead',
  `id_ref` int UNSIGNED DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Події особистого календаря'
PARTITION BY KEY (id)
PARTITIONS 16;

--
-- Дамп даних таблиці `8ydnb966_calendar_events`
--

INSERT INTO `8ydnb966_calendar_events` (`id`, `id_user_creator`, `id_event_type`, `title`, `description`, `location`, `location_url`, `date_start`, `date_end`, `all_day`, `tz_offset`, `priority`, `status`, `is_shared`, `visibility`, `notify_scope`, `is_busy`, `participants_cnt`, `reminder_minutes`, `id_ref_type`, `id_ref`, `active`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '123', '333333 3333', 'Офіс, кабінет 3...', NULL, '2026-08-23 00:00:00', '2026-08-23 23:59:00', 1, 180, 4, 1, 0, 4, 1, 1, 1, NULL, NULL, NULL, 0, '2026-08-23 15:34:20', '2026-08-23 21:04:11'),
(2, 1, 7, 'Гулянка', NULL, NULL, NULL, '2026-09-01 00:00:00', '2026-09-06 00:00:00', 0, 180, 3, 1, 0, 4, 0, 1, 1, NULL, NULL, NULL, 0, '2026-08-23 17:38:15', '2026-08-23 21:04:17');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_calendar_event_type`
--

CREATE TABLE `8ydnb966_calendar_event_type` (
  `id` tinyint UNSIGNED NOT NULL,
  `code` varchar(50) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `icon` varchar(100) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `color` char(7) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT '#007bff',
  `is_system` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'системний тип — не можна видалити',
  `is_absence` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1-відсутність (відпустка/лікарняний): рендериться фоновою смугою',
  `default_visibility` tinyint UNSIGNED NOT NULL DEFAULT '1' COMMENT 'видимість за замовчуванням для цього типу',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Типи подій особистого календаря';

--
-- Дамп даних таблиці `8ydnb966_calendar_event_type`
--

INSERT INTO `8ydnb966_calendar_event_type` (`id`, `code`, `icon`, `color`, `is_system`, `is_absence`, `default_visibility`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 'meeting', 'fas fa-handshake', '#007bff', 1, 0, 2, 1, 1, '2026-08-23 01:31:30', '2026-08-23 01:31:30'),
(2, 'call', 'fas fa-phone', '#28a745', 1, 0, 1, 1, 2, '2026-08-23 01:31:30', '2026-08-23 01:31:30'),
(3, 'reminder', 'fas fa-bell', '#ffc107', 1, 0, 1, 1, 3, '2026-08-23 01:31:30', '2026-08-23 01:31:30'),
(4, 'deadline', 'fas fa-flag', '#dc3545', 1, 0, 2, 1, 4, '2026-08-23 01:31:30', '2026-08-23 01:31:30'),
(5, 'task', 'fas fa-check-square', '#6610f2', 1, 0, 1, 1, 5, '2026-08-23 01:31:30', '2026-08-23 01:31:30'),
(6, 'personal', 'fas fa-user', '#20c997', 1, 0, 1, 1, 6, '2026-08-23 01:31:30', '2026-08-23 01:31:30'),
(7, 'vacation', 'fas fa-umbrella-beach', '#fd7e14', 1, 1, 4, 1, 7, '2026-08-23 01:31:30', '2026-08-23 01:31:30'),
(8, 'sick', 'fas fa-notes-medical', '#e83e8c', 1, 1, 4, 1, 8, '2026-08-23 01:31:30', '2026-08-23 01:31:30'),
(9, 'other', 'fas fa-circle', '#6c757d', 1, 0, 1, 1, 9, '2026-08-23 01:31:30', '2026-08-23 01:31:30'),
(10, 'business_trip', 'fas fa-plane', '#0dcaf0', 1, 1, 4, 1, 10, '2026-08-23 17:49:09', '2026-08-23 17:49:09');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_calendar_event_type_lang`
--

CREATE TABLE `8ydnb966_calendar_event_type_lang` (
  `id_event_type` tinyint UNSIGNED NOT NULL,
  `id_lang` tinyint UNSIGNED NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Переклади типів подій';

--
-- Дамп даних таблиці `8ydnb966_calendar_event_type_lang`
--

INSERT INTO `8ydnb966_calendar_event_type_lang` (`id_event_type`, `id_lang`, `name`) VALUES
(1, 1, 'Зустріч'),
(1, 2, 'Meeting'),
(2, 1, 'Дзвінок'),
(2, 2, 'Call'),
(3, 1, 'Нагадування'),
(3, 2, 'Reminder'),
(4, 1, 'Дедлайн'),
(4, 2, 'Deadline'),
(5, 1, 'Завдання'),
(5, 2, 'Task'),
(6, 1, 'Особисте'),
(6, 2, 'Personal'),
(7, 1, 'Відпустка'),
(7, 2, 'Vacation'),
(8, 1, 'Лікарняний'),
(8, 2, 'Sick leave'),
(9, 1, 'Інше'),
(9, 2, 'Other'),
(10, 1, 'Відрядження'),
(10, 2, 'Business trip');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_calendar_event_users`
--

CREATE TABLE `8ydnb966_calendar_event_users` (
  `id_user` int UNSIGNED NOT NULL,
  `date_start` datetime NOT NULL COMMENT 'денормалізація з events',
  `id_event` bigint UNSIGNED NOT NULL,
  `date_end` datetime NOT NULL COMMENT 'денормалізація з events',
  `is_owner` tinyint(1) NOT NULL DEFAULT '0',
  `response` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT '0-очікує 1-прийнято 2-відхилено 3-можливо',
  `is_hidden` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'учасник прибрав подію зі свого календаря',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Учасники подій календаря (fan-out)'
PARTITION BY KEY (id_user)
PARTITIONS 64;

--
-- Дамп даних таблиці `8ydnb966_calendar_event_users`
--

INSERT INTO `8ydnb966_calendar_event_users` (`id_user`, `date_start`, `id_event`, `date_end`, `is_owner`, `response`, `is_hidden`, `active`, `date_add`) VALUES
(1, '2026-08-23 00:00:00', 1, '2026-08-23 23:59:00', 1, 1, 0, 0, '2026-08-23 17:28:51'),
(1, '2026-09-01 00:00:00', 2, '2026-09-06 00:00:00', 1, 1, 0, 0, '2026-08-23 19:17:04');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_calendar_hidden_events`
--

CREATE TABLE `8ydnb966_calendar_hidden_events` (
  `id_user` int UNSIGNED NOT NULL,
  `id_event` bigint UNSIGNED NOT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Чужі видимі події, які користувач сховав у себе';

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_calendar_reminder_queue`
--

CREATE TABLE `8ydnb966_calendar_reminder_queue` (
  `id_event` bigint UNSIGNED NOT NULL,
  `id_user` int UNSIGNED NOT NULL,
  `kind` tinyint UNSIGNED NOT NULL DEFAULT '1' COMMENT '1-попереднє (за N хв) 2-у момент початку',
  `date_fire` datetime NOT NULL COMMENT 'date_start - reminder_minutes',
  `sent` tinyint(1) NOT NULL DEFAULT '0',
  `attempts` tinyint UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Черга нагадувань — тільки майбутні, старі чистяться';

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_calendar_user_settings`
--

CREATE TABLE `8ydnb966_calendar_user_settings` (
  `id_user` int UNSIGNED NOT NULL,
  `default_view` varchar(20) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT 'dayGridMonth',
  `first_day` tinyint UNSIGNED NOT NULL DEFAULT '1' COMMENT '0-нд 1-пн',
  `work_time_start` time NOT NULL DEFAULT '09:00:00',
  `work_time_end` time NOT NULL DEFAULT '18:00:00',
  `default_reminder` smallint UNSIGNED DEFAULT '30',
  `notify_email` tinyint(1) NOT NULL DEFAULT '1',
  `notify_push` tinyint(1) NOT NULL DEFAULT '1',
  `auto_accept` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'автоприйняття запрошень',
  `show_company` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'показувати події рівня "вся компанія"',
  `show_busy` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'показувати шар зайнятості колег',
  `default_visibility` tinyint UNSIGNED NOT NULL DEFAULT '1' COMMENT 'видимість нових подій за замовчуванням',
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Персональні налаштування календаря';

--
-- Дамп даних таблиці `8ydnb966_calendar_user_settings`
--

INSERT INTO `8ydnb966_calendar_user_settings` (`id_user`, `default_view`, `first_day`, `work_time_start`, `work_time_end`, `default_reminder`, `notify_email`, `notify_push`, `auto_accept`, `show_company`, `show_busy`, `default_visibility`, `date_edit`) VALUES
(1, 'dayGridMonth', 1, '09:00:00', '18:00:00', 30, 1, 1, 0, 1, 1, 1, '2026-08-23 21:04:23');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_catalog_brands`
--

CREATE TABLE `8ydnb966_catalog_brands` (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `banner_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_catalog_brands_lang`
--

CREATE TABLE `8ydnb966_catalog_brands_lang` (
  `id` int NOT NULL,
  `id_brand` int NOT NULL,
  `id_lang` int NOT NULL,
  `short_description` varchar(999) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `meta_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_catalog_currency`
--

CREATE TABLE `8ydnb966_catalog_currency` (
  `id` int NOT NULL,
  `iso_code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `iso_code_num` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_plural` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `symbol` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `symbol_native` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `symbol_position` tinyint(1) NOT NULL DEFAULT '0',
  `symbol_spacer` tinyint(1) NOT NULL DEFAULT '0',
  `decimal_digits` tinyint UNSIGNED NOT NULL DEFAULT '2',
  `decimal_separator` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '.',
  `thousand_separator` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ',',
  `rounding` decimal(5,2) NOT NULL DEFAULT '0.00',
  `conversion_rate` decimal(13,6) NOT NULL DEFAULT '1.000000',
  `rate_updated_at` datetime DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_catalog_currency`
--

INSERT INTO `8ydnb966_catalog_currency` (`id`, `iso_code`, `iso_code_num`, `name`, `name_plural`, `symbol`, `symbol_native`, `symbol_position`, `symbol_spacer`, `decimal_digits`, `decimal_separator`, `thousand_separator`, `rounding`, `conversion_rate`, `rate_updated_at`, `is_default`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 'UAH', '980', 'Ukrainian Hryvnia', 'Ukrainian Hryvnias', '₴', '₴', 1, 1, 2, ',', '', 0.00, 1.000000, '2026-02-23 13:58:17', 1, 1, 1, '2026-02-23 13:58:17', '2026-02-23 13:58:17'),
(2, 'USD', '840', 'US Dollar', 'US Dollars', '$', '$', 0, 0, 2, '.', ',', 0.00, 0.024100, '2026-02-23 13:58:17', 0, 1, 2, '2026-02-23 13:58:17', '2026-02-23 13:58:17'),
(3, 'PLN', '985', 'Polish Zloty', 'Polish Zlotys', 'zł', 'zł', 1, 1, 2, ',', '', 0.00, 0.098000, '2026-02-23 13:58:17', 0, 1, 3, '2026-02-23 13:58:17', '2026-02-23 13:58:17');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_catalog_lang`
--

CREATE TABLE `8ydnb966_catalog_lang` (
  `id` int NOT NULL,
  `code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_native` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `locale` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `encoding` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `flag_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url_prefix` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_format` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Y-m-d',
  `date_format_full` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Y-m-d H:i:s',
  `decimal_separator` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '.',
  `thousand_separator` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ',',
  `is_rtl` tinyint(1) NOT NULL DEFAULT '0',
  `default` tinyint(1) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_catalog_lang`
--

INSERT INTO `8ydnb966_catalog_lang` (`id`, `code`, `name`, `name_native`, `locale`, `encoding`, `flag_url`, `url_prefix`, `date_format`, `date_format_full`, `decimal_separator`, `thousand_separator`, `is_rtl`, `default`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 'uk', 'Українська', 'Українська', 'uk_UA', 'uk_UA.UTF-8,uk_UA,uk,ukrainian', '/images/flags/uk.png', 'uk', 'd.m.Y', 'd.m.Y H:i:s', ',', '', 0, 1, 1, 1, '2026-02-23 12:47:44', '2026-02-23 12:47:44'),
(2, 'en', 'Англійська', 'English', 'en_US', 'en_US.UTF-8,en_US,en,english', '/images/flags/en.png', 'en', 'm/d/Y', 'm/d/Y H:i:s', '.', ',', 0, 0, 1, 2, '2026-02-23 12:47:44', '2026-02-23 12:47:44'),
(3, 'pl', 'Польська', 'Polski', 'pl_PL', 'pl_PL.UTF-8,pl_PL,pl,polish', '/images/flags/pl.png', 'pl', 'd.m.Y', 'd.m.Y H:i:s', ',', '', 0, 0, 1, 3, '2026-02-23 12:47:44', '2026-02-23 12:47:44');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_catalog_stock_status`
--

CREATE TABLE `8ydnb966_catalog_stock_status` (
  `id` int NOT NULL,
  `color_background` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#000000',
  `color_text` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_catalog_stock_status`
--

INSERT INTO `8ydnb966_catalog_stock_status` (`id`, `color_background`, `color_text`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, '#28a745', '#ffffff', 1, 1, '2026-02-23 14:03:08', '2026-02-23 14:03:08'),
(2, '#dc3545', '#ffffff', 1, 2, '2026-02-23 14:03:08', '2026-02-23 14:03:08'),
(3, '#ffc107', '#000000', 1, 3, '2026-02-23 14:03:08', '2026-02-23 14:03:08'),
(4, '#007bff', '#ffffff', 1, 4, '2026-02-23 14:03:08', '2026-02-23 14:03:08');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_catalog_stock_status_lang`
--

CREATE TABLE `8ydnb966_catalog_stock_status_lang` (
  `id` int NOT NULL,
  `id_stock_status` int NOT NULL,
  `id_lang` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_catalog_stock_status_lang`
--

INSERT INTO `8ydnb966_catalog_stock_status_lang` (`id`, `id_stock_status`, `id_lang`, `name`) VALUES
(1, 1, 1, 'В наявності'),
(2, 1, 2, 'In Stock'),
(3, 1, 3, 'Na stanie'),
(4, 2, 1, 'Немає у наявності'),
(5, 2, 2, 'Out of Stock'),
(6, 2, 3, 'Brak w magazynie'),
(7, 3, 1, 'Очікування 2-3 дні'),
(8, 3, 2, 'Expected in 2-3 days'),
(9, 3, 3, 'Oczekiwanie 2-3 dni'),
(10, 4, 1, 'Передзамовлення'),
(11, 4, 2, 'Pre-order'),
(12, 4, 3, 'Przedsprzedaż');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies`
--

CREATE TABLE `8ydnb966_companies` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_company_type` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_type',
  `id_company_status` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_status',
  `id_industry` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_industry',
  `id_legal_form` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_legal_form',
  `id_segment` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_segment',
  `id_source` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_source',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users (відповідальний менеджер)',
  `id_team` int UNSIGNED DEFAULT NULL COMMENT 'FK → teams',
  `name` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Назва компанії (робоча)',
  `name_full` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Повна юридична назва',
  `name_short` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Коротка назва / бренд',
  `edrpou` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ЄДРПОУ (8 цифр)',
  `ipn` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ІПН / ПДВ номер',
  `vat_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Номер платника ПДВ',
  `registration_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Реєстраційний номер (для нерезидентів)',
  `registration_date` date DEFAULT NULL COMMENT 'Дата державної реєстрації',
  `country_registration` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Країна реєстрації',
  `address_legal` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Юридична адреса',
  `address_actual` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Фактична адреса',
  `address_post` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Поштова адреса',
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Місто',
  `region` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Область / регіон',
  `country` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Країна',
  `zip` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Поштовий індекс',
  `website` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Сайт',
  `email_main` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Головний email компанії',
  `phone_main` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Головний телефон',
  `employees_count` tinyint UNSIGNED DEFAULT NULL COMMENT '1=до 10, 2=10-50, 3=50-250, 4=250+',
  `annual_revenue` decimal(18,2) DEFAULT NULL COMMENT 'Річний оборот',
  `annual_revenue_currency` char(3) COLLATE utf8mb4_unicode_ci DEFAULT 'UAH' COMMENT 'Валюта обороту',
  `founded_year` year DEFAULT NULL COMMENT 'Рік заснування',
  `logo` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Шлях до логотипу',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'Загальний опис / нотатки',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Внутрішні нотатки менеджера',
  `date_first_contact` date DEFAULT NULL COMMENT 'Дата першого контакту',
  `date_last_activity` datetime DEFAULT NULL COMMENT 'Дата останньої активності (авто)',
  `active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=активна, 0=видалена',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL COMMENT 'Дата створення запису',
  `date_edit` datetime NOT NULL COMMENT 'Дата останнього редагування'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Головна таблиця компаній CRM';

--
-- Дамп даних таблиці `8ydnb966_companies`
--

INSERT INTO `8ydnb966_companies` (`id`, `id_company_type`, `id_company_status`, `id_industry`, `id_legal_form`, `id_segment`, `id_source`, `id_user`, `id_team`, `name`, `name_full`, `name_short`, `edrpou`, `ipn`, `vat_number`, `registration_number`, `registration_date`, `country_registration`, `address_legal`, `address_actual`, `address_post`, `city`, `region`, `country`, `zip`, `website`, `email_main`, `phone_main`, `employees_count`, `annual_revenue`, `annual_revenue_currency`, `founded_year`, `logo`, `description`, `notes`, `date_first_contact`, `date_last_activity`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, 1, 1, 1, 1, 1, 1, 'Альфа-Трейд', 'Товариство з обмеженою відповідальністю \"Альфа-Трейд\"', 'Альфа', '38291047', '382910426541', '38291047', NULL, '2010-03-15', 'Україна', 'м. Київ, вул. Хрещатик 22, оф. 304', 'м. Київ, вул. Хрещатик 22, оф. 304', 'м. Київ, 01001, вул. Хрещатик 22', 'Київ', 'Київська область', 'Україна', '01001', 'https://alpha-trade.ua', 'info@alpha-trade.ua', '+380442001234', 2, 12500000.00, 'UAH', '2010', 'uploads/companies/logos/alpha-trade.png', 'Компанія займається оптовою торгівлею промисловим обладнанням. Працює на ринку з 2010 року. Основні клієнти — виробничі підприємства.', 'Ключовий клієнт. Щоквартальні закупівлі. Цікавляться новими моделями компресорів.', '2024-01-15', '2026-05-28 23:11:57', 1, 0, '2026-05-28 23:11:57', '2026-05-28 23:11:57');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_bank`
--

CREATE TABLE `8ydnb966_companies_bank` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `name` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Назва банку',
  `name_short` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Коротка назва: ПриватБанк, Mono...',
  `mfo` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'МФО банку (6 цифр, UA)',
  `swift` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'SWIFT / BIC код',
  `country` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Країна банку',
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Місто головного офісу',
  `address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Адреса банку',
  `phone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Телефон банку',
  `website` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Сайт банку',
  `logo` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Логотип банку',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Довідник банків';

--
-- Дамп даних таблиці `8ydnb966_companies_bank`
--

INSERT INTO `8ydnb966_companies_bank` (`id`, `name`, `name_short`, `mfo`, `swift`, `country`, `city`, `address`, `phone`, `website`, `logo`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 'АТ КБ «ПриватБанк»', 'ПриватБанк', '305299', 'PBANK2X', 'UA', NULL, NULL, NULL, NULL, NULL, 1, 1, '2026-05-28 22:56:57', '2026-05-28 22:56:57'),
(2, 'АТ «Ощадбанк»', 'Ощадбанк', '300465', 'OSCBUAUX', 'UA', NULL, NULL, NULL, NULL, NULL, 1, 2, '2026-05-28 22:56:57', '2026-05-28 22:56:57'),
(3, 'АТ «Райффайзен Банк»', 'Райффайзен', '380805', 'RAIFUA2X', 'UA', NULL, NULL, NULL, NULL, NULL, 1, 3, '2026-05-28 22:56:57', '2026-05-28 22:56:57'),
(4, 'АТ «ПУМБ»', 'ПУМБ', '334851', 'FUIBUA2X', 'UA', NULL, NULL, NULL, NULL, NULL, 1, 4, '2026-05-28 22:56:57', '2026-05-28 22:56:57'),
(5, 'АТ «Укрсиббанк»', 'Укрсиббанк', '351005', 'UNCRUA2X', 'UA', NULL, NULL, NULL, NULL, NULL, 1, 5, '2026-05-28 22:56:57', '2026-05-28 22:56:57'),
(6, 'АТ «monobank» / Універсал Банк', 'monobank', '322001', 'UNJSUAUX', 'UA', NULL, NULL, NULL, NULL, NULL, 1, 6, '2026-05-28 22:56:57', '2026-05-28 22:56:57'),
(7, 'АТ «Укргазбанк»', 'Укргазбанк', '320478', 'UGASUAUK', 'UA', NULL, NULL, NULL, NULL, NULL, 1, 7, '2026-05-28 22:56:57', '2026-05-28 22:56:57'),
(8, 'АТ «Кредобанк»', 'Кредобанк', '325365', 'WUCBUA2X', 'UA', NULL, NULL, NULL, NULL, NULL, 1, 8, '2026-05-28 22:56:57', '2026-05-28 22:56:57');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_bank_accounts`
--

CREATE TABLE `8ydnb966_companies_bank_accounts` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_company` int UNSIGNED NOT NULL COMMENT 'FK → companies',
  `id_bank` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_bank (довідник)',
  `id_bank_account_type` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_bank_account_type',
  `iban` varchar(34) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'IBAN (UA + 27 цифр)',
  `account_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Номер рахунку (старий формат або для не-UA)',
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH' COMMENT 'Валюта рахунку: UAH, USD, EUR...',
  `bank_name` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Назва банку вручну (якщо немає в довіднику)',
  `bank_mfo` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'МФО вручну',
  `bank_swift` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'SWIFT вручну',
  `bank_address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Адреса банку вручну',
  `bank_correspondent` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Банк-кореспондент (для міжнародних платежів)',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = основний рахунок',
  `note` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Примітка (напр. "тільки для USD платежів")',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Банківські рахунки компаній';

--
-- Дамп даних таблиці `8ydnb966_companies_bank_accounts`
--

INSERT INTO `8ydnb966_companies_bank_accounts` (`id`, `id_company`, `id_bank`, `id_bank_account_type`, `iban`, `account_number`, `currency`, `bank_name`, `bank_mfo`, `bank_swift`, `bank_address`, `bank_correspondent`, `is_primary`, `note`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 0, 1, 1, 'UA213052990000026007233566001', NULL, 'UAH', NULL, NULL, NULL, NULL, NULL, 1, 'Основний гривневий рахунок', 1, 1, '2026-05-28 23:11:57', '2026-05-28 23:11:57'),
(2, 0, 3, 2, 'UA893805800000000026001234567', NULL, 'USD', NULL, NULL, NULL, NULL, 'Raiffeisen Bank International AG, Vienna, Austria', 0, 'Валютний рахунок USD', 1, 2, '2026-05-28 23:11:57', '2026-05-28 23:11:57');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_bank_account_type`
--

CREATE TABLE `8ydnb966_companies_bank_account_type` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Типи банківських рахунків';

--
-- Дамп даних таблиці `8ydnb966_companies_bank_account_type`
--

INSERT INTO `8ydnb966_companies_bank_account_type` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 22:56:56', '2026-05-28 22:56:56'),
(2, 1, 2, '2026-05-28 22:56:56', '2026-05-28 22:56:56'),
(3, 1, 3, '2026-05-28 22:56:56', '2026-05-28 22:56:56'),
(4, 1, 4, '2026-05-28 22:56:56', '2026-05-28 22:56:56'),
(5, 1, 5, '2026-05-28 22:56:56', '2026-05-28 22:56:56');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_bank_account_type_lang`
--

CREATE TABLE `8ydnb966_companies_bank_account_type_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_bank_account_type` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_bank_account_type_lang`
--

INSERT INTO `8ydnb966_companies_bank_account_type_lang` (`id`, `id_bank_account_type`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Розрахунковий'),
(2, 1, 2, 'Current Account'),
(3, 2, 1, 'Валютний'),
(4, 2, 2, 'Foreign Currency'),
(5, 3, 1, 'Картковий'),
(6, 3, 2, 'Card Account'),
(7, 4, 1, 'Депозитний'),
(8, 4, 2, 'Deposit Account'),
(9, 5, 1, 'Кредитний'),
(10, 5, 2, 'Credit Account');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_custom_field`
--

CREATE TABLE `8ydnb966_companies_custom_field` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_custom_field_group` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_custom_field_group',
  `field_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'text|textarea|number|decimal|date|datetime|checkbox|select|multiselect|url|email|phone|file',
  `field_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Системний ключ поля (латиниця, унікальний): license_number, next_audit_date',
  `is_required` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = обов''язкове поле',
  `is_unique` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = значення унікальне серед всіх компаній',
  `min_length` int UNSIGNED DEFAULT NULL COMMENT 'Мінімальна довжина (для text/textarea)',
  `max_length` int UNSIGNED DEFAULT NULL COMMENT 'Максимальна довжина (для text/textarea)',
  `min_value` decimal(18,4) DEFAULT NULL COMMENT 'Мінімальне значення (для number/decimal)',
  `max_value` decimal(18,4) DEFAULT NULL COMMENT 'Максимальне значення (для number/decimal)',
  `regex` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Regexp для валідації (опційно)',
  `default_value` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Значення за замовчуванням',
  `show_in_list` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = показувати колонку в списку компаній',
  `show_in_card` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = показувати в картці компанії',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Опис кастомних полів компаній';

--
-- Дамп даних таблиці `8ydnb966_companies_custom_field`
--

INSERT INTO `8ydnb966_companies_custom_field` (`id`, `id_custom_field_group`, `field_type`, `field_key`, `is_required`, `is_unique`, `min_length`, `max_length`, `min_value`, `max_value`, `regex`, `default_value`, `show_in_list`, `show_in_card`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 'text', 'license_number', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 1, '2026-05-28 22:57:11', '2026-05-28 22:57:11'),
(2, 1, 'date', 'license_expire', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 2, '2026-05-28 22:57:11', '2026-05-28 22:57:11'),
(3, 2, 'select', 'payment_terms', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 3, '2026-05-28 22:57:11', '2026-05-28 22:57:11'),
(4, 2, 'number', 'credit_limit', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 4, '2026-05-28 22:57:11', '2026-05-28 22:57:11'),
(5, 3, 'text', 'delivery_region', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 5, '2026-05-28 22:57:11', '2026-05-28 22:57:11'),
(6, 1, 'checkbox', 'has_nda', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 6, '2026-05-28 22:57:11', '2026-05-28 22:57:11');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_custom_field_group`
--

CREATE TABLE `8ydnb966_companies_custom_field_group` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Групи кастомних полів (для відображення в картці)';

--
-- Дамп даних таблиці `8ydnb966_companies_custom_field_group`
--

INSERT INTO `8ydnb966_companies_custom_field_group` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 22:57:08', '2026-05-28 22:57:08'),
(2, 1, 2, '2026-05-28 22:57:08', '2026-05-28 22:57:08'),
(3, 1, 3, '2026-05-28 22:57:08', '2026-05-28 22:57:08');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_custom_field_group_lang`
--

CREATE TABLE `8ydnb966_companies_custom_field_group_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_custom_field_group` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Назва групи',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Опис групи'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_custom_field_group_lang`
--

INSERT INTO `8ydnb966_companies_custom_field_group_lang` (`id`, `id_custom_field_group`, `id_lang`, `name`, `description`) VALUES
(1, 1, 1, 'Додаткова інформація', NULL),
(2, 1, 2, 'Additional Info', NULL),
(3, 2, 1, 'Договірні умови', NULL),
(4, 2, 2, 'Contract Terms', NULL),
(5, 3, 1, 'Логістика', NULL),
(6, 3, 2, 'Logistics', NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_custom_field_lang`
--

CREATE TABLE `8ydnb966_companies_custom_field_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_custom_field` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Підпис поля в інтерфейсі',
  `placeholder` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Placeholder в інпуті',
  `hint` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Підказка під полем'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_custom_field_lang`
--

INSERT INTO `8ydnb966_companies_custom_field_lang` (`id`, `id_custom_field`, `id_lang`, `label`, `placeholder`, `hint`) VALUES
(1, 1, 1, 'Номер ліцензії', 'Введіть номер', 'Ліцензія або дозвіл'),
(2, 1, 2, 'License Number', 'Enter number', 'License or permit number'),
(3, 2, 1, 'Термін дії ліцензії', NULL, 'Дата закінчення ліцензії'),
(4, 2, 2, 'License Expiry', NULL, 'License expiration date'),
(5, 3, 1, 'Умови оплати', NULL, 'Стандартні умови для цього клієнта'),
(6, 3, 2, 'Payment Terms', NULL, 'Default payment terms'),
(7, 4, 1, 'Кредитний ліміт (грн)', '0', 'Максимальна сума відстрочки'),
(8, 4, 2, 'Credit Limit (UAH)', '0', 'Maximum deferred payment amount'),
(9, 5, 1, 'Регіон доставки', 'Наприклад: Захід', NULL),
(10, 5, 2, 'Delivery Region', 'e.g. West', NULL),
(11, 6, 1, 'NDA підписано', NULL, 'Угода про нерозголошення'),
(12, 6, 2, 'NDA Signed', NULL, 'Non-disclosure agreement signed');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_custom_field_option`
--

CREATE TABLE `8ydnb966_companies_custom_field_option` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_custom_field` int UNSIGNED NOT NULL COMMENT 'FK → companies_custom_field',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Варіанти вибору для кастомних полів типу select/multiselect';

--
-- Дамп даних таблиці `8ydnb966_companies_custom_field_option`
--

INSERT INTO `8ydnb966_companies_custom_field_option` (`id`, `id_custom_field`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 3, 1, 1, '2026-05-28 22:57:13', '2026-05-28 22:57:13'),
(2, 3, 1, 2, '2026-05-28 22:57:13', '2026-05-28 22:57:13'),
(3, 3, 1, 3, '2026-05-28 22:57:13', '2026-05-28 22:57:13'),
(4, 3, 1, 4, '2026-05-28 22:57:13', '2026-05-28 22:57:13');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_custom_field_option_lang`
--

CREATE TABLE `8ydnb966_companies_custom_field_option_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_custom_field_option` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Назва варіанту'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_custom_field_option_lang`
--

INSERT INTO `8ydnb966_companies_custom_field_option_lang` (`id`, `id_custom_field_option`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Передоплата 100%'),
(2, 1, 2, 'Prepayment 100%'),
(3, 2, 1, 'Оплата по факту'),
(4, 2, 2, 'Payment on delivery'),
(5, 3, 1, 'Відстрочка 14 днів'),
(6, 3, 2, 'Net 14 days'),
(7, 4, 1, 'Відстрочка 30 днів'),
(8, 4, 2, 'Net 30 days');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_custom_field_value`
--

CREATE TABLE `8ydnb966_companies_custom_field_value` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_company` int UNSIGNED NOT NULL COMMENT 'FK → companies',
  `id_custom_field` int UNSIGNED NOT NULL COMMENT 'FK → companies_custom_field',
  `value_text` text COLLATE utf8mb4_unicode_ci COMMENT 'Значення для text/textarea/url/email/phone/file/multiselect',
  `value_int` int DEFAULT NULL COMMENT 'Значення для number/checkbox/select',
  `value_decimal` decimal(18,4) DEFAULT NULL COMMENT 'Значення для decimal',
  `value_date` date DEFAULT NULL COMMENT 'Значення для date',
  `value_datetime` datetime DEFAULT NULL COMMENT 'Значення для datetime',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Значення кастомних полів для компаній (EAV)';

--
-- Дамп даних таблиці `8ydnb966_companies_custom_field_value`
--

INSERT INTO `8ydnb966_companies_custom_field_value` (`id`, `id_company`, `id_custom_field`, `value_text`, `value_int`, `value_decimal`, `value_date`, `value_datetime`, `date_add`, `date_edit`) VALUES
(1, 0, 1, 'ЛІЦ-2024-00891', NULL, NULL, NULL, NULL, '2026-05-28 23:11:57', '2026-05-28 23:11:57'),
(2, 0, 2, NULL, NULL, NULL, '2025-12-31', NULL, '2026-05-28 23:11:57', '2026-05-28 23:11:57'),
(3, 0, 3, NULL, 2, NULL, NULL, NULL, '2026-05-28 23:11:57', '2026-05-28 23:11:57'),
(4, 0, 4, NULL, NULL, 500000.0000, NULL, NULL, '2026-05-28 23:11:57', '2026-05-28 23:11:57');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_emails`
--

CREATE TABLE `8ydnb966_companies_emails` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_company` int UNSIGNED NOT NULL COMMENT 'FK → companies',
  `id_email_type` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_email_type',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Email адреса',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = головний (показується в списку)',
  `subscribed` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = підписаний на розсилку',
  `bounced` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = email не доставляється (bounce)',
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Примітка',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Email-и компаній (один до багатьох)';

--
-- Дамп даних таблиці `8ydnb966_companies_emails`
--

INSERT INTO `8ydnb966_companies_emails` (`id`, `id_company`, `id_email_type`, `email`, `is_primary`, `subscribed`, `bounced`, `note`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 0, 1, 'info@alpha-trade.ua', 1, 1, 0, 'Загальний', 1, 1, '2026-05-28 23:11:57', '2026-05-28 23:11:57'),
(2, 0, 2, 'sales@alpha-trade.ua', 0, 1, 0, 'Продажі', 1, 2, '2026-05-28 23:11:57', '2026-05-28 23:11:57'),
(3, 0, 3, 'buh@alpha-trade.ua', 0, 0, 0, 'Бухгалтерія', 1, 3, '2026-05-28 23:11:57', '2026-05-28 23:11:57');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_email_type`
--

CREATE TABLE `8ydnb966_companies_email_type` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Типи email-ів компанії';

--
-- Дамп даних таблиці `8ydnb966_companies_email_type`
--

INSERT INTO `8ydnb966_companies_email_type` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 22:56:47', '2026-05-28 22:56:47'),
(2, 1, 2, '2026-05-28 22:56:47', '2026-05-28 22:56:47'),
(3, 1, 3, '2026-05-28 22:56:47', '2026-05-28 22:56:47'),
(4, 1, 4, '2026-05-28 22:56:47', '2026-05-28 22:56:47'),
(5, 1, 5, '2026-05-28 22:56:47', '2026-05-28 22:56:47');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_email_type_lang`
--

CREATE TABLE `8ydnb966_companies_email_type_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_email_type` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_email_type_lang`
--

INSERT INTO `8ydnb966_companies_email_type_lang` (`id`, `id_email_type`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Загальний'),
(2, 1, 2, 'General'),
(3, 2, 1, 'Продажі'),
(4, 2, 2, 'Sales'),
(5, 3, 1, 'Бухгалтерія'),
(6, 3, 2, 'Accounting'),
(7, 4, 1, 'Директор'),
(8, 4, 2, 'Director'),
(9, 5, 1, 'Технічний'),
(10, 5, 2, 'Technical');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_industry`
--

CREATE TABLE `8ydnb966_companies_industry` (
  `id` int UNSIGNED NOT NULL,
  `code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'КВЕД або власний код',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Галузі: торгівля, виробництво, IT, логістика...';

--
-- Дамп даних таблиці `8ydnb966_companies_industry`
--

INSERT INTO `8ydnb966_companies_industry` (`id`, `code`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, '46', 1, 1, '2026-05-28 22:56:29', '2026-05-28 22:56:29'),
(2, '10', 1, 2, '2026-05-28 22:56:29', '2026-05-28 22:56:29'),
(3, '62', 1, 3, '2026-05-28 22:56:29', '2026-05-28 22:56:29'),
(4, '49', 1, 4, '2026-05-28 22:56:29', '2026-05-28 22:56:29'),
(5, '41', 1, 5, '2026-05-28 22:56:29', '2026-05-28 22:56:29'),
(6, '64', 1, 6, '2026-05-28 22:56:29', '2026-05-28 22:56:29'),
(7, '86', 1, 7, '2026-05-28 22:56:29', '2026-05-28 22:56:29');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_industry_lang`
--

CREATE TABLE `8ydnb966_companies_industry_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_industry` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_industry_lang`
--

INSERT INTO `8ydnb966_companies_industry_lang` (`id`, `id_industry`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Оптова торгівля'),
(2, 1, 2, 'Wholesale Trade'),
(3, 2, 1, 'Виробництво'),
(4, 2, 2, 'Manufacturing'),
(5, 3, 1, 'IT та технології'),
(6, 3, 2, 'IT & Technology'),
(7, 4, 1, 'Логістика'),
(8, 4, 2, 'Logistics'),
(9, 5, 1, 'Будівництво'),
(10, 5, 2, 'Construction'),
(11, 6, 1, 'Фінанси та банки'),
(12, 6, 2, 'Finance & Banking'),
(13, 7, 1, 'Медицина'),
(14, 7, 2, 'Healthcare');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_legal_form`
--

CREATE TABLE `8ydnb966_companies_legal_form` (
  `id` int UNSIGNED NOT NULL,
  `code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ТОВ, ФОП, ПАТ...',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Орг.-правові форми: ТОВ, ФОП, ПАТ, ДП...';

--
-- Дамп даних таблиці `8ydnb966_companies_legal_form`
--

INSERT INTO `8ydnb966_companies_legal_form` (`id`, `code`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 'ТОВ', 1, 1, '2026-05-28 22:56:31', '2026-05-28 22:56:31'),
(2, 'ФОП', 1, 2, '2026-05-28 22:56:31', '2026-05-28 22:56:31'),
(3, 'ПАТ', 1, 3, '2026-05-28 22:56:31', '2026-05-28 22:56:31'),
(4, 'ПП', 1, 4, '2026-05-28 22:56:31', '2026-05-28 22:56:31'),
(5, 'ДП', 1, 5, '2026-05-28 22:56:31', '2026-05-28 22:56:31'),
(6, 'КП', 1, 6, '2026-05-28 22:56:31', '2026-05-28 22:56:31');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_legal_form_lang`
--

CREATE TABLE `8ydnb966_companies_legal_form_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_legal_form` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_legal_form_lang`
--

INSERT INTO `8ydnb966_companies_legal_form_lang` (`id`, `id_legal_form`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Товариство з обмеженою відповідальністю'),
(2, 1, 2, 'Limited Liability Company'),
(3, 2, 1, 'Фізична особа-підприємець'),
(4, 2, 2, 'Sole Proprietor'),
(5, 3, 1, 'Публічне акціонерне товариство'),
(6, 3, 2, 'Public Joint-Stock Company'),
(7, 4, 1, 'Приватне підприємство'),
(8, 4, 2, 'Private Enterprise'),
(9, 5, 1, 'Державне підприємство'),
(10, 5, 2, 'State Enterprise'),
(11, 6, 1, 'Комунальне підприємство'),
(12, 6, 2, 'Municipal Enterprise');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_phones`
--

CREATE TABLE `8ydnb966_companies_phones` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_company` int UNSIGNED NOT NULL COMMENT 'FK → companies',
  `id_phone_type` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_phone_type',
  `phone` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Номер телефону',
  `phone_clean` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Номер без символів для пошуку (тільки цифри)',
  `country_code` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Код країни: +380, +1...',
  `extension` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Внутрішній номер (доб.)',
  `viber` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Є Viber на цьому номері',
  `whatsapp` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Є WhatsApp на цьому номері',
  `telegram` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Є Telegram на цьому номері',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = головний (показується в списку)',
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Примітка до номера',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Телефони компаній (один до багатьох)';

--
-- Дамп даних таблиці `8ydnb966_companies_phones`
--

INSERT INTO `8ydnb966_companies_phones` (`id`, `id_company`, `id_phone_type`, `phone`, `phone_clean`, `country_code`, `extension`, `viber`, `whatsapp`, `telegram`, `is_primary`, `note`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 0, 1, '+38 (044) 200-12-34', '380442001234', '+380', NULL, 0, 0, 0, 1, 'Головний', 1, 1, '2026-05-28 23:11:57', '2026-05-28 23:11:57'),
(2, 0, 2, '+38 (067) 300-45-67', '380673004567', '+380', NULL, 1, 1, 1, 0, 'Відділ продажів', 1, 2, '2026-05-28 23:11:57', '2026-05-28 23:11:57'),
(3, 0, 3, '+38 (050) 400-78-90', '380504007890', '+380', NULL, 0, 0, 0, 0, 'Бухгалтерія', 1, 3, '2026-05-28 23:11:57', '2026-05-28 23:11:57');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_phone_type`
--

CREATE TABLE `8ydnb966_companies_phone_type` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Типи телефонів компанії';

--
-- Дамп даних таблиці `8ydnb966_companies_phone_type`
--

INSERT INTO `8ydnb966_companies_phone_type` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 22:56:44', '2026-05-28 22:56:44'),
(2, 1, 2, '2026-05-28 22:56:44', '2026-05-28 22:56:44'),
(3, 1, 3, '2026-05-28 22:56:44', '2026-05-28 22:56:44'),
(4, 1, 4, '2026-05-28 22:56:44', '2026-05-28 22:56:44'),
(5, 1, 5, '2026-05-28 22:56:44', '2026-05-28 22:56:44');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_phone_type_lang`
--

CREATE TABLE `8ydnb966_companies_phone_type_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_phone_type` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_phone_type_lang`
--

INSERT INTO `8ydnb966_companies_phone_type_lang` (`id`, `id_phone_type`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Головний'),
(2, 1, 2, 'Main'),
(3, 2, 1, 'Відділ продажів'),
(4, 2, 2, 'Sales'),
(5, 3, 1, 'Бухгалтерія'),
(6, 3, 2, 'Accounting'),
(7, 4, 1, 'Директор'),
(8, 4, 2, 'Director'),
(9, 5, 1, 'Служба підтримки'),
(10, 5, 2, 'Support');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_segment`
--

CREATE TABLE `8ydnb966_companies_segment` (
  `id` int UNSIGNED NOT NULL,
  `color_background` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#000000',
  `color_text` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Сегменти клієнтів: A, B, C або VIP, Standard...';

--
-- Дамп даних таблиці `8ydnb966_companies_segment`
--

INSERT INTO `8ydnb966_companies_segment` (`id`, `color_background`, `color_text`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, '#28a745', '#ffffff', 1, 1, '2026-05-28 22:56:35', '2026-05-28 22:56:35'),
(2, '#ffc107', '#000000', 1, 2, '2026-05-28 22:56:35', '2026-05-28 22:56:35'),
(3, '#6c757d', '#ffffff', 1, 3, '2026-05-28 22:56:35', '2026-05-28 22:56:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_segment_lang`
--

CREATE TABLE `8ydnb966_companies_segment_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_segment` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_segment_lang`
--

INSERT INTO `8ydnb966_companies_segment_lang` (`id`, `id_segment`, `id_lang`, `name`, `description`) VALUES
(1, 1, 1, 'A — Ключові', 'Найцінніші клієнти, пріоритет'),
(2, 1, 2, 'A — Key', 'Top-priority clients'),
(3, 2, 1, 'B — Активні', 'Регулярні клієнти середнього рівня'),
(4, 2, 2, 'B — Active', 'Regular mid-tier clients'),
(5, 3, 1, 'C — Потенційні', 'Рідко купують або в процесі'),
(6, 3, 2, 'C — Potential', 'Rarely buy or in process');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_socials`
--

CREATE TABLE `8ydnb966_companies_socials` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_company` int UNSIGNED NOT NULL COMMENT 'FK → companies',
  `id_social_type` int UNSIGNED NOT NULL COMMENT 'FK → companies_social_type',
  `handle` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username / нікнейм (@company)',
  `url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Повний URL сторінки',
  `phone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Номер для Viber/WhatsApp (якщо застосовно)',
  `followers` int UNSIGNED DEFAULT NULL COMMENT 'Кількість підписників (опційно)',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = основний акаунт цього типу',
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Примітка',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Соціальні мережі та месенджери компаній';

--
-- Дамп даних таблиці `8ydnb966_companies_socials`
--

INSERT INTO `8ydnb966_companies_socials` (`id`, `id_company`, `id_social_type`, `handle`, `url`, `phone`, `followers`, `is_primary`, `note`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 0, 1, 'alpha-trade-ua', 'https://linkedin.com/company/alpha-trade-ua', NULL, NULL, 1, 'LinkedIn сторінка', 1, 1, '2026-05-28 23:11:57', '2026-05-28 23:11:57'),
(2, 0, 2, 'alphatrade.ua', 'https://facebook.com/alphatrade.ua', NULL, NULL, 0, 'Facebook сторінка', 1, 2, '2026-05-28 23:11:57', '2026-05-28 23:11:57'),
(3, 0, 4, 'alphatrade_ua', 'https://t.me/alphatrade_ua', NULL, NULL, 0, 'Telegram канал', 1, 3, '2026-05-28 23:11:57', '2026-05-28 23:11:57'),
(4, 0, 6, NULL, NULL, '+380673004567', NULL, 0, 'WhatsApp продажі', 1, 4, '2026-05-28 23:11:57', '2026-05-28 23:11:57');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_social_type`
--

CREATE TABLE `8ydnb966_companies_social_type` (
  `id` int UNSIGNED NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Системна назва: linkedin, facebook, telegram...',
  `icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'CSS клас іконки або шлях до SVG',
  `color` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#000000' COMMENT 'Фірмовий колір мережі',
  `url_pattern` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Шаблон URL: https://t.me/{handle}',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Типи соцмереж і месенджерів з іконками та кольорами';

--
-- Дамп даних таблиці `8ydnb966_companies_social_type`
--

INSERT INTO `8ydnb966_companies_social_type` (`id`, `code`, `icon`, `color`, `url_pattern`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 'linkedin', 'fab fa-linkedin', '#0077b5', 'https://linkedin.com/company/{handle}', 1, 1, '2026-05-28 22:56:51', '2026-05-28 22:56:51'),
(2, 'facebook', 'fab fa-facebook', '#1877f2', 'https://facebook.com/{handle}', 1, 2, '2026-05-28 22:56:51', '2026-05-28 22:56:51'),
(3, 'instagram', 'fab fa-instagram', '#e4405f', 'https://instagram.com/{handle}', 1, 3, '2026-05-28 22:56:51', '2026-05-28 22:56:51'),
(4, 'telegram', 'fab fa-telegram', '#2ca5e0', 'https://t.me/{handle}', 1, 4, '2026-05-28 22:56:51', '2026-05-28 22:56:51'),
(5, 'viber', 'fab fa-viber', '#7360f2', NULL, 1, 5, '2026-05-28 22:56:51', '2026-05-28 22:56:51'),
(6, 'whatsapp', 'fab fa-whatsapp', '#25d366', 'https://wa.me/{handle}', 1, 6, '2026-05-28 22:56:51', '2026-05-28 22:56:51'),
(7, 'youtube', 'fab fa-youtube', '#ff0000', 'https://youtube.com/@{handle}', 1, 7, '2026-05-28 22:56:51', '2026-05-28 22:56:51'),
(8, 'twitter', 'fab fa-x-twitter', '#000000', 'https://x.com/{handle}', 1, 8, '2026-05-28 22:56:51', '2026-05-28 22:56:51'),
(9, 'tiktok', 'fab fa-tiktok', '#010101', 'https://tiktok.com/@{handle}', 1, 9, '2026-05-28 22:56:51', '2026-05-28 22:56:51'),
(10, 'skype', 'fab fa-skype', '#00aff0', 'skype:{handle}?call', 1, 10, '2026-05-28 22:56:51', '2026-05-28 22:56:51');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_social_type_lang`
--

CREATE TABLE `8ydnb966_companies_social_type_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_social_type` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_social_type_lang`
--

INSERT INTO `8ydnb966_companies_social_type_lang` (`id`, `id_social_type`, `id_lang`, `name`) VALUES
(1, 1, 1, 'LinkedIn'),
(2, 1, 2, 'LinkedIn'),
(3, 2, 1, 'Facebook'),
(4, 2, 2, 'Facebook'),
(5, 3, 1, 'Instagram'),
(6, 3, 2, 'Instagram'),
(7, 4, 1, 'Telegram'),
(8, 4, 2, 'Telegram'),
(9, 5, 1, 'Viber'),
(10, 5, 2, 'Viber'),
(11, 6, 1, 'WhatsApp'),
(12, 6, 2, 'WhatsApp'),
(13, 7, 1, 'YouTube'),
(14, 7, 2, 'YouTube'),
(15, 8, 1, 'X (Twitter)'),
(16, 8, 2, 'X (Twitter)'),
(17, 9, 1, 'TikTok'),
(18, 9, 2, 'TikTok'),
(19, 10, 1, 'Skype'),
(20, 10, 2, 'Skype');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_source`
--

CREATE TABLE `8ydnb966_companies_source` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Джерела: сайт, виставка, холодний дзвінок, реферал...';

--
-- Дамп даних таблиці `8ydnb966_companies_source`
--

INSERT INTO `8ydnb966_companies_source` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 22:56:38', '2026-05-28 22:56:38'),
(2, 1, 2, '2026-05-28 22:56:38', '2026-05-28 22:56:38'),
(3, 1, 3, '2026-05-28 22:56:38', '2026-05-28 22:56:38'),
(4, 1, 4, '2026-05-28 22:56:38', '2026-05-28 22:56:38'),
(5, 1, 5, '2026-05-28 22:56:38', '2026-05-28 22:56:38'),
(6, 1, 6, '2026-05-28 22:56:38', '2026-05-28 22:56:38');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_source_lang`
--

CREATE TABLE `8ydnb966_companies_source_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_source` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_source_lang`
--

INSERT INTO `8ydnb966_companies_source_lang` (`id`, `id_source`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Сайт / Форма'),
(2, 1, 2, 'Website / Form'),
(3, 2, 1, 'Холодний дзвінок'),
(4, 2, 2, 'Cold Call'),
(5, 3, 1, 'Виставка / Захід'),
(6, 3, 2, 'Exhibition / Event'),
(7, 4, 1, 'Реферал'),
(8, 4, 2, 'Referral'),
(9, 5, 1, 'Соціальні мережі'),
(10, 5, 2, 'Social Media'),
(11, 6, 1, 'Особистий контакт'),
(12, 6, 2, 'Personal Contact');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_status`
--

CREATE TABLE `8ydnb966_companies_status` (
  `id` int UNSIGNED NOT NULL,
  `color_background` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#000000',
  `color_text` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Статуси: активна, потенційна, неактивна, заблокована';

--
-- Дамп даних таблиці `8ydnb966_companies_status`
--

INSERT INTO `8ydnb966_companies_status` (`id`, `color_background`, `color_text`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, '#28a745', '#ffffff', 1, 1, '2026-05-28 22:56:27', '2026-05-28 22:56:27'),
(2, '#007bff', '#ffffff', 1, 2, '2026-05-28 22:56:27', '2026-05-28 22:56:27'),
(3, '#6c757d', '#ffffff', 1, 3, '2026-05-28 22:56:27', '2026-05-28 22:56:27'),
(4, '#dc3545', '#ffffff', 1, 4, '2026-05-28 22:56:27', '2026-05-28 22:56:27');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_status_lang`
--

CREATE TABLE `8ydnb966_companies_status_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_company_status` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_status_lang`
--

INSERT INTO `8ydnb966_companies_status_lang` (`id`, `id_company_status`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Активна'),
(2, 1, 2, 'Active'),
(3, 2, 1, 'Потенційна'),
(4, 2, 2, 'Potential'),
(5, 3, 1, 'Неактивна'),
(6, 3, 2, 'Inactive'),
(7, 4, 1, 'Заблокована'),
(8, 4, 2, 'Blocked');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_tag`
--

CREATE TABLE `8ydnb966_companies_tag` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_tag_category` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_tag_category (опційно)',
  `color_background` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#e9ecef' COMMENT 'Колір фону бейджа',
  `color_text` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#212529' COMMENT 'Колір тексту бейджа',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Довідник тегів для компаній';

--
-- Дамп даних таблиці `8ydnb966_companies_tag`
--

INSERT INTO `8ydnb966_companies_tag` (`id`, `id_tag_category`, `color_background`, `color_text`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, '#cfe2ff', '#084298', 1, 1, '2026-05-28 22:57:05', '2026-05-28 22:57:05'),
(2, 1, '#d1e7dd', '#0a3622', 1, 2, '2026-05-28 22:57:05', '2026-05-28 22:57:05'),
(3, 1, '#fff3cd', '#664d03', 1, 3, '2026-05-28 22:57:05', '2026-05-28 22:57:05'),
(4, 2, '#e2d9f3', '#432874', 1, 4, '2026-05-28 22:57:05', '2026-05-28 22:57:05'),
(5, 2, '#fde8e8', '#842029', 1, 5, '2026-05-28 22:57:05', '2026-05-28 22:57:05'),
(6, 3, '#d1e7dd', '#0a3622', 1, 6, '2026-05-28 22:57:05', '2026-05-28 22:57:05'),
(7, 3, '#fde8e8', '#842029', 1, 7, '2026-05-28 22:57:05', '2026-05-28 22:57:05'),
(8, 3, '#fff3cd', '#664d03', 1, 8, '2026-05-28 22:57:05', '2026-05-28 22:57:05'),
(9, 4, '#f8d7da', '#58151c', 1, 9, '2026-05-28 22:57:05', '2026-05-28 22:57:05'),
(10, 4, '#d1e7dd', '#0a3622', 1, 10, '2026-05-28 22:57:05', '2026-05-28 22:57:05');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_tags_map`
--

CREATE TABLE `8ydnb966_companies_tags_map` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_company` int UNSIGNED NOT NULL COMMENT 'FK → companies',
  `id_tag` int UNSIGNED NOT NULL COMMENT 'FK → companies_tag',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users (хто поставив тег)',
  `date_add` datetime NOT NULL COMMENT 'Коли поставлено тег'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Прив''язка тегів до компаній (many-to-many)';

--
-- Дамп даних таблиці `8ydnb966_companies_tags_map`
--

INSERT INTO `8ydnb966_companies_tags_map` (`id`, `id_company`, `id_tag`, `id_user`, `date_add`) VALUES
(1, 0, 9, 1, '2026-05-28 23:11:57'),
(2, 0, 6, 1, '2026-05-28 23:11:57'),
(3, 0, 1, 1, '2026-05-28 23:11:57');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_tag_category`
--

CREATE TABLE `8ydnb966_companies_tag_category` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `color` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#6c757d' COMMENT 'Колір категорії',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Категорії тегів для групування';

--
-- Дамп даних таблиці `8ydnb966_companies_tag_category`
--

INSERT INTO `8ydnb966_companies_tag_category` (`id`, `color`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, '#007bff', 1, 1, '2026-05-28 22:57:03', '2026-05-28 22:57:03'),
(2, '#28a745', 1, 2, '2026-05-28 22:57:03', '2026-05-28 22:57:03'),
(3, '#ffc107', 1, 3, '2026-05-28 22:57:03', '2026-05-28 22:57:03'),
(4, '#dc3545', 1, 4, '2026-05-28 22:57:03', '2026-05-28 22:57:03');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_tag_category_lang`
--

CREATE TABLE `8ydnb966_companies_tag_category_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_tag_category` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_tag_category_lang`
--

INSERT INTO `8ydnb966_companies_tag_category_lang` (`id`, `id_tag_category`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Тип співпраці'),
(2, 1, 2, 'Cooperation Type'),
(3, 2, 1, 'Маркетинг'),
(4, 2, 2, 'Marketing'),
(5, 3, 1, 'Фінанси'),
(6, 3, 2, 'Finance'),
(7, 4, 1, 'Пріоритет'),
(8, 4, 2, 'Priority');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_tag_lang`
--

CREATE TABLE `8ydnb966_companies_tag_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_tag` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Назва тегу',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Опис тегу (підказка при наведенні)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_tag_lang`
--

INSERT INTO `8ydnb966_companies_tag_lang` (`id`, `id_tag`, `id_lang`, `name`, `description`) VALUES
(1, 1, 1, 'Тендер', 'Бере участь у тендерах'),
(2, 1, 2, 'Tender', 'Participates in tenders'),
(3, 2, 1, 'Дилер', 'Офіційний дилер'),
(4, 2, 2, 'Dealer', 'Official dealer'),
(5, 3, 1, 'Агент', 'Агентська схема роботи'),
(6, 3, 2, 'Agent', 'Works on agency basis'),
(7, 4, 1, 'Виставка 2025', 'Зустрілись на виставці 2025'),
(8, 4, 2, 'Expo 2025', 'Met at exhibition 2025'),
(9, 5, 1, 'Розсилка', 'Підписаний на email-розсилку'),
(10, 5, 2, 'Newsletter', 'Subscribed to newsletter'),
(11, 6, 1, 'Передоплата', 'Працює тільки за передоплатою'),
(12, 6, 2, 'Prepayment', 'Prepayment only'),
(13, 7, 1, 'Борг', 'Має прострочену заборгованість'),
(14, 7, 2, 'Debt', 'Has overdue debt'),
(15, 8, 1, 'Відстрочка', 'Надано відстрочку платежу'),
(16, 8, 2, 'Deferred', 'Payment deferral granted'),
(17, 9, 1, 'VIP', 'Ключовий клієнт, особлива увага'),
(18, 9, 2, 'VIP', 'Key client, special attention'),
(19, 10, 1, 'Новий', 'Нова компанія, перший контакт'),
(20, 10, 2, 'New', 'New company, first contact');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_type`
--

CREATE TABLE `8ydnb966_companies_type` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Типи компаній: клієнт, постачальник, партнер...';

--
-- Дамп даних таблиці `8ydnb966_companies_type`
--

INSERT INTO `8ydnb966_companies_type` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 22:56:25', '2026-05-28 22:56:25'),
(2, 1, 2, '2026-05-28 22:56:25', '2026-05-28 22:56:25'),
(3, 1, 3, '2026-05-28 22:56:25', '2026-05-28 22:56:25'),
(4, 1, 4, '2026-05-28 22:56:25', '2026-05-28 22:56:25'),
(5, 1, 5, '2026-05-28 22:56:25', '2026-05-28 22:56:25'),
(6, 1, 6, '2026-05-28 22:56:25', '2026-05-28 22:56:25');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_type_lang`
--

CREATE TABLE `8ydnb966_companies_type_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_company_type` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_companies_type_lang`
--

INSERT INTO `8ydnb966_companies_type_lang` (`id`, `id_company_type`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Клієнт'),
(2, 1, 2, 'Client'),
(3, 2, 1, 'Постачальник'),
(4, 2, 2, 'Supplier'),
(5, 3, 1, 'Партнер'),
(6, 3, 2, 'Partner'),
(7, 4, 1, 'Конкурент'),
(8, 4, 2, 'Competitor'),
(9, 5, 1, 'Дистриб\'ютор'),
(10, 5, 2, 'Distributor'),
(11, 6, 1, 'Посередник'),
(12, 6, 2, 'Intermediary');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_companies_websites`
--

CREATE TABLE `8ydnb966_companies_websites` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_company` int UNSIGNED NOT NULL COMMENT 'FK → companies',
  `url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'URL сайту',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Назва / підпис (Основний сайт, Лендінг...)',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = головний сайт',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Сайти та URL компаній';

--
-- Дамп даних таблиці `8ydnb966_companies_websites`
--

INSERT INTO `8ydnb966_companies_websites` (`id`, `id_company`, `url`, `title`, `is_primary`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 0, 'https://alpha-trade.ua', 'Основний сайт', 1, 1, 1, '2026-05-28 23:11:57', '2026-05-28 23:11:57'),
(2, 0, 'https://catalog.alpha-trade.ua', 'Каталог товарів', 0, 1, 2, '2026-05-28 23:11:57', '2026-05-28 23:11:57');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts`
--

CREATE TABLE `8ydnb966_contacts` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_contact_status` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts_status',
  `id_source` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts_source',
  `id_salutation` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts_salutation',
  `id_segment` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts_segment',
  `id_company` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies (основна компанія)',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users (відповідальний менеджер)',
  `id_team` int UNSIGNED DEFAULT NULL COMMENT 'FK → teams',
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Прізвище',
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ім''я (обов''язкове)',
  `middle_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'По батькові',
  `full_name` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Повне ім''я (авто або вручну)',
  `position` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Посада',
  `department` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Відділ',
  `gender` tinyint(1) DEFAULT NULL COMMENT '0=чоловік, 1=жінка, NULL=не вказано',
  `birthday` date DEFAULT NULL COMMENT 'Дата народження',
  `language` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Мова спілкування: uk, en, pl...',
  `nationality` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Громадянство',
  `photo` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Шлях до фото',
  `phone_main` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Головний телефон (з contacts_phones)',
  `email_main` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Головний email (з contacts_emails)',
  `address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Адреса',
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Місто',
  `region` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Область / регіон',
  `country` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Країна',
  `zip` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Поштовий індекс',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'Загальний опис',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Внутрішні нотатки менеджера',
  `gdpr_consent` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = надав згоду на обробку даних',
  `gdpr_consent_date` datetime DEFAULT NULL COMMENT 'Дата надання згоди',
  `subscribed` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = підписаний на розсилку',
  `unsubscribed_date` datetime DEFAULT NULL COMMENT 'Дата відписки',
  `date_first_contact` date DEFAULT NULL COMMENT 'Дата першого контакту',
  `date_last_activity` datetime DEFAULT NULL COMMENT 'Дата останньої активності (авто)',
  `date_birthday_next` date DEFAULT NULL COMMENT 'Наступний день народження (для нагадувань)',
  `active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=активний, 0=видалений',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL COMMENT 'Дата створення',
  `date_edit` datetime NOT NULL COMMENT 'Дата редагування'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Головна таблиця контактів CRM';

--
-- Дамп даних таблиці `8ydnb966_contacts`
--

INSERT INTO `8ydnb966_contacts` (`id`, `id_contact_status`, `id_source`, `id_salutation`, `id_segment`, `id_company`, `id_user`, `id_team`, `last_name`, `first_name`, `middle_name`, `full_name`, `position`, `department`, `gender`, `birthday`, `language`, `nationality`, `photo`, `phone_main`, `email_main`, `address`, `city`, `region`, `country`, `zip`, `description`, `notes`, `gdpr_consent`, `gdpr_consent_date`, `subscribed`, `unsubscribed_date`, `date_first_contact`, `date_last_activity`, `date_birthday_next`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 6, 1, 1, 1, 1, 1, 'Іванов', 'Василь', 'Петрович', 'Іванов Василь Петрович', 'Директор з розвитку бізнесу', 'Відділ закупівель', 0, '1980-06-15', 'uk', 'Україна', 'uploads/contacts/photos/ivanov_vp.jpg', '+380673004567', 'ivanov@alpha-trade.ua', 'вул. Лесі Українки 12, кв. 45', 'Київ', 'Київська область', 'Україна', '02000', 'Ключовий контакт в компанії Альфа-Трейд. Відповідає за закупівлі промислового обладнання. Має технічну освіту, добре розуміється на специфікаціях.', 'Любить конкретику і цифри. Не любить затягування. Кращий час для дзвінка — вранці до 11:00. Приймає рішення самостійно в межах бюджету до 500 тис. грн.', 1, '2024-01-15 10:30:00', 1, NULL, '2024-01-15', '2026-05-28 23:12:38', '2026-06-15', 1, 0, '2026-05-28 23:12:38', '2026-05-28 23:12:38');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_addresses`
--

CREATE TABLE `8ydnb966_contacts_addresses` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_contact` int UNSIGNED NOT NULL COMMENT 'FK → contacts',
  `id_address_type` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts_address_type',
  `address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Вулиця, будинок, квартира',
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Місто',
  `region` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Область / регіон',
  `country` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Країна',
  `zip` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Поштовий індекс',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = основна адреса',
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Адреси контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_addresses`
--

INSERT INTO `8ydnb966_contacts_addresses` (`id`, `id_contact`, `id_address_type`, `address`, `city`, `region`, `country`, `zip`, `is_primary`, `note`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 0, 2, 'вул. Хрещатик 22, оф. 304', 'Київ', 'Київська область', 'Україна', '01001', 1, 'Робоча адреса', 1, 1, '2026-05-28 23:12:38', '2026-05-28 23:12:38'),
(2, 0, 1, 'вул. Лесі Українки 12, кв. 45', 'Київ', 'Київська область', 'Україна', '02000', 0, 'Домашня адреса', 1, 2, '2026-05-28 23:12:38', '2026-05-28 23:12:38');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_address_type`
--

CREATE TABLE `8ydnb966_contacts_address_type` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Типи адрес контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_address_type`
--

INSERT INTO `8ydnb966_contacts_address_type` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 23:06:30', '2026-05-28 23:06:30'),
(2, 1, 2, '2026-05-28 23:06:30', '2026-05-28 23:06:30'),
(3, 1, 3, '2026-05-28 23:06:30', '2026-05-28 23:06:30'),
(4, 1, 4, '2026-05-28 23:06:30', '2026-05-28 23:06:30');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_address_type_lang`
--

CREATE TABLE `8ydnb966_contacts_address_type_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_address_type` int UNSIGNED NOT NULL COMMENT 'FK → contacts_address_type',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contacts_address_type_lang`
--

INSERT INTO `8ydnb966_contacts_address_type_lang` (`id`, `id_address_type`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Домашня'),
(2, 1, 2, 'Home'),
(3, 2, 1, 'Робоча'),
(4, 2, 2, 'Work'),
(5, 3, 1, 'Для доставки'),
(6, 3, 2, 'Shipping'),
(7, 4, 1, 'Інша'),
(8, 4, 2, 'Other');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_audit_log`
--

CREATE TABLE `8ydnb966_contacts_audit_log` (
  `id` bigint UNSIGNED NOT NULL COMMENT 'PK',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users',
  `user_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ім''я (знімок на момент дії)',
  `user_ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP адреса',
  `entity_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'contact/phone/email/social/tag/file/note/company_map',
  `id_entity` int UNSIGNED NOT NULL COMMENT 'ID запису',
  `id_contact` int UNSIGNED NOT NULL COMMENT 'FK → contacts (для швидкої вибірки)',
  `action` enum('create','update','delete','restore','view','export','merge','tag_add','tag_remove','company_link','company_unlink') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Тип дії',
  `field_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Яке поле змінилось',
  `value_old` text COLLATE utf8mb4_unicode_ci COMMENT 'Старе значення',
  `value_new` text COLLATE utf8mb4_unicode_ci COMMENT 'Нове значення',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'Опис дії (для складних змін)',
  `date_add` datetime NOT NULL COMMENT 'Дата і час дії'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Журнал всіх змін контактів (audit log)';

--
-- Дамп даних таблиці `8ydnb966_contacts_audit_log`
--

INSERT INTO `8ydnb966_contacts_audit_log` (`id`, `id_user`, `user_name`, `user_ip`, `entity_type`, `id_entity`, `id_contact`, `action`, `field_name`, `value_old`, `value_new`, `description`, `date_add`) VALUES
(1, 1, 'Мотчаний Сергій', '192.168.1.105', 'contact', 0, 0, 'create', NULL, NULL, NULL, 'Контакт створено', '2026-05-28 23:12:38'),
(2, 1, 'Мотчаний Сергій', '192.168.1.105', 'contact', 0, 0, 'tag_add', NULL, NULL, '1', 'Додано тег VIP', '2026-05-28 23:12:38'),
(3, 1, 'Мотчаний Сергій', '192.168.1.105', 'contact', 0, 0, 'company_link', NULL, NULL, '1', 'Прив\'язано до Альфа-Трейд', '2026-05-28 23:12:38');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_companies_map`
--

CREATE TABLE `8ydnb966_contacts_companies_map` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_contact` int UNSIGNED NOT NULL COMMENT 'FK → contacts',
  `id_company` int UNSIGNED NOT NULL COMMENT 'FK → companies',
  `id_role` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts_role (роль саме в цій компанії)',
  `position` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Посада в цій компанії',
  `department` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Відділ в цій компанії',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = основна компанія контакта',
  `date_from` date DEFAULT NULL COMMENT 'Дата початку роботи в компанії',
  `date_to` date DEFAULT NULL COMMENT 'Дата закінчення (NULL = працює зараз)',
  `note` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Примітка щодо зв''язку',
  `active` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = актуальний зв''язок',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Зв''язок контактів з компаніями (many-to-many)';

--
-- Дамп даних таблиці `8ydnb966_contacts_companies_map`
--

INSERT INTO `8ydnb966_contacts_companies_map` (`id`, `id_contact`, `id_company`, `id_role`, `position`, `department`, `is_primary`, `date_from`, `date_to`, `note`, `active`, `date_add`, `date_edit`) VALUES
(1, 0, 1, 1, 'Директор з розвитку бізнесу', 'Відділ закупівель', 1, '2018-03-01', NULL, 'Основне місце роботи', 1, '2026-05-28 23:12:38', '2026-05-28 23:12:38');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_custom_field`
--

CREATE TABLE `8ydnb966_contacts_custom_field` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_custom_field_group` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts_custom_field_group',
  `field_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'text|textarea|number|decimal|date|datetime|checkbox|select|multiselect|url|email|phone|file',
  `field_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Системний ключ (унікальний, латиниця)',
  `is_required` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = обов''язкове поле',
  `is_unique` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = унікальне серед контактів',
  `min_length` int UNSIGNED DEFAULT NULL COMMENT 'Мін. довжина (text/textarea)',
  `max_length` int UNSIGNED DEFAULT NULL COMMENT 'Макс. довжина (text/textarea)',
  `min_value` decimal(18,4) DEFAULT NULL COMMENT 'Мін. значення (number/decimal)',
  `max_value` decimal(18,4) DEFAULT NULL COMMENT 'Макс. значення (number/decimal)',
  `regex` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Regexp для валідації',
  `default_value` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Значення за замовчуванням',
  `show_in_list` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = показувати колонку в списку',
  `show_in_card` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = показувати в картці',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Кастомні поля контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_custom_field`
--

INSERT INTO `8ydnb966_contacts_custom_field` (`id`, `id_custom_field_group`, `field_type`, `field_key`, `is_required`, `is_unique`, `min_length`, `max_length`, `min_value`, `max_value`, `regex`, `default_value`, `show_in_list`, `show_in_card`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 2, 'select', 'english_level', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 1, '2026-05-28 23:06:49', '2026-05-28 23:06:49'),
(2, 1, 'date', 'next_contact_date', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 2, '2026-05-28 23:06:49', '2026-05-28 23:06:49'),
(3, 1, 'checkbox', 'nda_signed', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 3, '2026-05-28 23:06:49', '2026-05-28 23:06:49'),
(4, 1, 'decimal', 'annual_budget', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 4, '2026-05-28 23:06:49', '2026-05-28 23:06:49'),
(5, 3, 'text', 'preferred_contact', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 5, '2026-05-28 23:06:49', '2026-05-28 23:06:49'),
(6, 3, 'textarea', 'personal_notes', 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 1, 6, '2026-05-28 23:06:49', '2026-05-28 23:06:49');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_custom_field_group`
--

CREATE TABLE `8ydnb966_contacts_custom_field_group` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Групи кастомних полів контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_custom_field_group`
--

INSERT INTO `8ydnb966_contacts_custom_field_group` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 23:06:46', '2026-05-28 23:06:46'),
(2, 1, 2, '2026-05-28 23:06:46', '2026-05-28 23:06:46'),
(3, 1, 3, '2026-05-28 23:06:46', '2026-05-28 23:06:46');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_custom_field_group_lang`
--

CREATE TABLE `8ydnb966_contacts_custom_field_group_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_custom_field_group` int UNSIGNED NOT NULL COMMENT 'FK → contacts_custom_field_group',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Назва групи',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contacts_custom_field_group_lang`
--

INSERT INTO `8ydnb966_contacts_custom_field_group_lang` (`id`, `id_custom_field_group`, `id_lang`, `name`, `description`) VALUES
(1, 1, 1, 'Додаткова інформація', NULL),
(2, 1, 2, 'Additional Info', NULL),
(3, 2, 1, 'Кваліфікація', NULL),
(4, 2, 2, 'Qualification', NULL),
(5, 3, 1, 'Особисті уподобання', NULL),
(6, 3, 2, 'Personal Preferences', NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_custom_field_lang`
--

CREATE TABLE `8ydnb966_contacts_custom_field_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_custom_field` int UNSIGNED NOT NULL COMMENT 'FK → contacts_custom_field',
  `id_lang` smallint UNSIGNED NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Підпис поля в інтерфейсі',
  `placeholder` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Placeholder в інпуті',
  `hint` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Підказка під полем'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contacts_custom_field_lang`
--

INSERT INTO `8ydnb966_contacts_custom_field_lang` (`id`, `id_custom_field`, `id_lang`, `label`, `placeholder`, `hint`) VALUES
(1, 1, 1, 'Рівень англійської', NULL, 'Для міжнародних проектів'),
(2, 1, 2, 'English Level', NULL, 'For international projects'),
(3, 2, 1, 'Дата наступного контакту', NULL, 'Коли зв\'язатись наступного разу'),
(4, 2, 2, 'Next Contact Date', NULL, 'When to reach out next time'),
(5, 3, 1, 'NDA підписано', NULL, 'Угода про нерозголошення'),
(6, 3, 2, 'NDA Signed', NULL, 'Non-disclosure agreement signed'),
(7, 4, 1, 'Річний бюджет (грн)', '0', 'Орієнтовний бюджет клієнта'),
(8, 4, 2, 'Annual Budget (UAH)', '0', 'Estimated client budget'),
(9, 5, 1, 'Зручний спосіб зв\'язку', 'Email / Telegram', NULL),
(10, 5, 2, 'Preferred Contact Method', 'Email / Telegram', NULL),
(11, 6, 1, 'Особисті нотатки', NULL, 'Хобі, вподобання, важливі деталі'),
(12, 6, 2, 'Personal Notes', NULL, 'Hobbies, preferences, important details');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_custom_field_option`
--

CREATE TABLE `8ydnb966_contacts_custom_field_option` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_custom_field` int UNSIGNED NOT NULL COMMENT 'FK → contacts_custom_field',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Варіанти вибору для кастомних полів контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_custom_field_option`
--

INSERT INTO `8ydnb966_contacts_custom_field_option` (`id`, `id_custom_field`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, 1, '2026-05-28 23:06:51', '2026-05-28 23:06:51'),
(2, 1, 1, 2, '2026-05-28 23:06:51', '2026-05-28 23:06:51'),
(3, 1, 1, 3, '2026-05-28 23:06:51', '2026-05-28 23:06:51'),
(4, 1, 1, 4, '2026-05-28 23:06:51', '2026-05-28 23:06:51'),
(5, 1, 1, 5, '2026-05-28 23:06:51', '2026-05-28 23:06:51');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_custom_field_option_lang`
--

CREATE TABLE `8ydnb966_contacts_custom_field_option_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_custom_field_option` int UNSIGNED NOT NULL COMMENT 'FK → contacts_custom_field_option',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contacts_custom_field_option_lang`
--

INSERT INTO `8ydnb966_contacts_custom_field_option_lang` (`id`, `id_custom_field_option`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Початківець (A1-A2)'),
(2, 1, 2, 'Beginner (A1-A2)'),
(3, 2, 1, 'Середній (B1-B2)'),
(4, 2, 2, 'Intermediate (B1-B2)'),
(5, 3, 1, 'Просунутий (C1-C2)'),
(6, 3, 2, 'Advanced (C1-C2)'),
(7, 4, 1, 'Вільно (Native)'),
(8, 4, 2, 'Fluent (Native)'),
(9, 5, 1, 'Не вказано'),
(10, 5, 2, 'Not specified');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_custom_field_value`
--

CREATE TABLE `8ydnb966_contacts_custom_field_value` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_contact` int UNSIGNED NOT NULL COMMENT 'FK → contacts',
  `id_custom_field` int UNSIGNED NOT NULL COMMENT 'FK → contacts_custom_field',
  `value_text` text COLLATE utf8mb4_unicode_ci COMMENT 'text/textarea/url/email/phone/file/multiselect',
  `value_int` int DEFAULT NULL COMMENT 'number/checkbox/select',
  `value_decimal` decimal(18,4) DEFAULT NULL COMMENT 'decimal',
  `value_date` date DEFAULT NULL COMMENT 'date',
  `value_datetime` datetime DEFAULT NULL COMMENT 'datetime',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Значення кастомних полів контактів (EAV)';

--
-- Дамп даних таблиці `8ydnb966_contacts_custom_field_value`
--

INSERT INTO `8ydnb966_contacts_custom_field_value` (`id`, `id_contact`, `id_custom_field`, `value_text`, `value_int`, `value_decimal`, `value_date`, `value_datetime`, `date_add`, `date_edit`) VALUES
(1, 0, 1, NULL, 2, NULL, NULL, NULL, '2026-05-28 23:12:38', '2026-05-28 23:12:38'),
(2, 0, 2, NULL, NULL, NULL, '2026-06-10', NULL, '2026-05-28 23:12:38', '2026-05-28 23:12:38'),
(3, 0, 3, NULL, 1, NULL, NULL, NULL, '2026-05-28 23:12:38', '2026-05-28 23:12:38'),
(4, 0, 4, NULL, NULL, 500000.0000, NULL, NULL, '2026-05-28 23:12:38', '2026-05-28 23:12:38'),
(5, 0, 5, 'Telegram', NULL, NULL, NULL, NULL, '2026-05-28 23:12:38', '2026-05-28 23:12:38'),
(6, 0, 6, 'Технічна освіта (КПІ). Добре розуміється на специфікаціях. Цінує точність і конкретику в комунікації.', NULL, NULL, NULL, NULL, '2026-05-28 23:12:38', '2026-05-28 23:12:38');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_emails`
--

CREATE TABLE `8ydnb966_contacts_emails` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_contact` int UNSIGNED NOT NULL COMMENT 'FK → contacts',
  `id_email_type` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_email_type (спільний довідник)',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Email адреса',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = головний (показується в списку)',
  `subscribed` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = підписаний на розсилку',
  `bounced` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = email не доставляється (bounce)',
  `bounce_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Причина bounce (hard/soft/spam)',
  `verified` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = email підтверджений',
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Примітка: робочий, особистий...',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Email-и контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_emails`
--

INSERT INTO `8ydnb966_contacts_emails` (`id`, `id_contact`, `id_email_type`, `email`, `is_primary`, `subscribed`, `bounced`, `bounce_reason`, `verified`, `note`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 0, 2, 'ivanov@alpha-trade.ua', 1, 1, 0, NULL, 1, 'Робочий', 1, 1, '2026-05-28 23:12:38', '2026-05-28 23:12:38'),
(2, 0, 1, 'v.ivanov@gmail.com', 0, 1, 0, NULL, 1, 'Особистий', 1, 2, '2026-05-28 23:12:38', '2026-05-28 23:12:38');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_files`
--

CREATE TABLE `8ydnb966_contacts_files` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_contact` int UNSIGNED NOT NULL COMMENT 'FK → contacts',
  `id_category` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts_file_category',
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Шлях до файлу',
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Оригінальна назва',
  `file_ext` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Розширення: pdf, docx...',
  `file_size` int UNSIGNED DEFAULT NULL COMMENT 'Розмір в байтах',
  `file_mime` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'MIME тип',
  `file_hash` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'SHA256 для дедуплікації',
  `version` tinyint UNSIGNED NOT NULL DEFAULT '1' COMMENT 'Версія файлу',
  `id_file_parent` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts_files (попередня версія)',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Назва / підпис',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'Опис',
  `is_public` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = видно контакту (кабінет)',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users (хто завантажив)',
  `download_count` int UNSIGNED NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Файли та документи контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_files`
--

INSERT INTO `8ydnb966_contacts_files` (`id`, `id_contact`, `id_category`, `file_path`, `file_name`, `file_ext`, `file_size`, `file_mime`, `file_hash`, `version`, `id_file_parent`, `title`, `description`, `is_public`, `id_user`, `download_count`, `active`, `date_add`, `date_edit`) VALUES
(1, 0, 1, 'uploads/contacts/files/ivanov_nda_2024.pdf', 'NDA_Іванов_2024.pdf', 'pdf', 245760, 'application/pdf', 'c3d5e7f9a1b3c5e7f9a1b3c5e7f9a1b3', 1, NULL, 'NDA підписано 15.01.2024', 'Угода про нерозголошення, підписана обома сторонами', 0, 1, 0, 1, '2026-05-28 23:12:38', '2026-05-28 23:12:38');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_file_category`
--

CREATE TABLE `8ydnb966_contacts_file_category` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Категорії файлів контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_file_category`
--

INSERT INTO `8ydnb966_contacts_file_category` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 23:06:41', '2026-05-28 23:06:41'),
(2, 1, 2, '2026-05-28 23:06:41', '2026-05-28 23:06:41'),
(3, 1, 3, '2026-05-28 23:06:41', '2026-05-28 23:06:41'),
(4, 1, 4, '2026-05-28 23:06:41', '2026-05-28 23:06:41'),
(5, 1, 5, '2026-05-28 23:06:41', '2026-05-28 23:06:41'),
(6, 1, 6, '2026-05-28 23:06:41', '2026-05-28 23:06:41');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_file_category_lang`
--

CREATE TABLE `8ydnb966_contacts_file_category_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_category` int UNSIGNED NOT NULL COMMENT 'FK → contacts_file_category',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contacts_file_category_lang`
--

INSERT INTO `8ydnb966_contacts_file_category_lang` (`id`, `id_category`, `id_lang`, `name`) VALUES
(1, 1, 1, 'NDA / Угода'),
(2, 1, 2, 'NDA / Agreement'),
(3, 2, 1, 'Резюме'),
(4, 2, 2, 'Resume / CV'),
(5, 3, 1, 'Документ'),
(6, 3, 2, 'Document'),
(7, 4, 1, 'Презентація'),
(8, 4, 2, 'Presentation'),
(9, 5, 1, 'Фото'),
(10, 5, 2, 'Photo'),
(11, 6, 1, 'Інше'),
(12, 6, 2, 'Other');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_merge_log`
--

CREATE TABLE `8ydnb966_contacts_merge_log` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_contact_master` int UNSIGNED NOT NULL COMMENT 'FK → contacts (залишений)',
  `id_contact_merged` int UNSIGNED NOT NULL COMMENT 'FK → contacts (злитий / видалений)',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users (хто злив)',
  `merged_data` json DEFAULT NULL COMMENT 'JSON знімок злитого контакта до видалення',
  `note` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Примітка до злиття',
  `date_add` datetime NOT NULL COMMENT 'Дата злиття'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Журнал злиття дублікатів контактів';

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_notes`
--

CREATE TABLE `8ydnb966_contacts_notes` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_contact` int UNSIGNED NOT NULL COMMENT 'FK → contacts',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users (хто додав)',
  `note` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Текст нотатки',
  `is_pinned` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = закріплена нотатка',
  `is_private` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = видно тільки автору',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Нотатки контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_notes`
--

INSERT INTO `8ydnb966_contacts_notes` (`id`, `id_contact`, `id_user`, `note`, `is_pinned`, `is_private`, `active`, `date_add`, `date_edit`) VALUES
(1, 0, 1, 'Василь Петрович — ключова людина в компанії. Має технічну освіту (КПІ, машинобудування). Приймає рішення самостійно до 500 тис. грн. Вище — потрібне погодження з генеральним директором Марківим С.О.', 1, 0, 1, '2026-05-28 23:12:38', '2026-05-28 23:12:38'),
(2, 0, 1, 'День народження 15 червня — привітати і надіслати невеликий подарунок.', 0, 1, 1, '2026-05-28 23:12:38', '2026-05-28 23:12:38');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_phones`
--

CREATE TABLE `8ydnb966_contacts_phones` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_contact` int UNSIGNED NOT NULL COMMENT 'FK → contacts',
  `id_phone_type` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_phone_type (спільний довідник)',
  `phone` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Номер телефону',
  `phone_clean` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Тільки цифри для пошуку',
  `country_code` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Код країни: +380, +1...',
  `extension` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Внутрішній номер (доб.)',
  `viber` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = є Viber на цьому номері',
  `whatsapp` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = є WhatsApp',
  `telegram` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = є Telegram',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = головний (показується в списку)',
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Примітка: робочий, особистий...',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Телефони контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_phones`
--

INSERT INTO `8ydnb966_contacts_phones` (`id`, `id_contact`, `id_phone_type`, `phone`, `phone_clean`, `country_code`, `extension`, `viber`, `whatsapp`, `telegram`, `is_primary`, `note`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 0, 1, '+38 (067) 300-45-67', '380673004567', '+380', NULL, 1, 1, 1, 1, 'Робочий мобільний', 1, 1, '2026-05-28 23:12:38', '2026-05-28 23:12:38'),
(2, 0, 1, '+38 (050) 111-22-33', '380501112233', '+380', NULL, 0, 0, 0, 0, 'Особистий', 1, 2, '2026-05-28 23:12:38', '2026-05-28 23:12:38'),
(3, 0, 3, '+38 (044) 200-12-34', '380442001234', '+380', '304', 0, 0, 0, 0, 'Офіс, доб. 304', 1, 3, '2026-05-28 23:12:38', '2026-05-28 23:12:38');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_role`
--

CREATE TABLE `8ydnb966_contacts_role` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Ролі контакта в компанії';

--
-- Дамп даних таблиці `8ydnb966_contacts_role`
--

INSERT INTO `8ydnb966_contacts_role` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 23:06:17', '2026-05-28 23:06:17'),
(2, 1, 2, '2026-05-28 23:06:17', '2026-05-28 23:06:17'),
(3, 1, 3, '2026-05-28 23:06:17', '2026-05-28 23:06:17'),
(4, 1, 4, '2026-05-28 23:06:17', '2026-05-28 23:06:17'),
(5, 1, 5, '2026-05-28 23:06:17', '2026-05-28 23:06:17'),
(6, 1, 6, '2026-05-28 23:06:17', '2026-05-28 23:06:17'),
(7, 1, 7, '2026-05-28 23:06:17', '2026-05-28 23:06:17');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_role_lang`
--

CREATE TABLE `8ydnb966_contacts_role_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_role` int UNSIGNED NOT NULL COMMENT 'FK → contacts_role',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contacts_role_lang`
--

INSERT INTO `8ydnb966_contacts_role_lang` (`id`, `id_role`, `id_lang`, `name`, `description`) VALUES
(1, 1, 1, 'ЛПР', 'Особа що приймає рішення'),
(2, 1, 2, 'Decision Maker', 'Person who makes decisions'),
(3, 2, 1, 'Агент впливу', 'Впливає на рішення але не вирішує'),
(4, 2, 2, 'Influencer', 'Influences decisions'),
(5, 3, 1, 'Бухгалтер', 'Фінансові питання та оплати'),
(6, 3, 2, 'Accountant', 'Financial and payment matters'),
(7, 4, 1, 'Технічний спец.', 'Технічна оцінка продукту'),
(8, 4, 2, 'Technical', 'Technical product evaluation'),
(9, 5, 1, 'Керівник проекту', 'Веде проект з боку клієнта'),
(10, 5, 2, 'Project Manager', 'Manages project on client side'),
(11, 6, 1, 'Кінцевий користувач', 'Використовує продукт'),
(12, 6, 2, 'End User', 'Uses the product'),
(13, 7, 1, 'Секретар / Асистент', 'Фільтрує доступ до ЛПР'),
(14, 7, 2, 'Assistant', 'Filters access to decision maker');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_salutation`
--

CREATE TABLE `8ydnb966_contacts_salutation` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Звернення: Пан, Пані, Др., Проф.';

--
-- Дамп даних таблиці `8ydnb966_contacts_salutation`
--

INSERT INTO `8ydnb966_contacts_salutation` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 23:06:19', '2026-05-28 23:06:19'),
(2, 1, 2, '2026-05-28 23:06:19', '2026-05-28 23:06:19'),
(3, 1, 3, '2026-05-28 23:06:19', '2026-05-28 23:06:19'),
(4, 1, 4, '2026-05-28 23:06:19', '2026-05-28 23:06:19');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_salutation_lang`
--

CREATE TABLE `8ydnb966_contacts_salutation_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_salutation` int UNSIGNED NOT NULL COMMENT 'FK → contacts_salutation',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contacts_salutation_lang`
--

INSERT INTO `8ydnb966_contacts_salutation_lang` (`id`, `id_salutation`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Пан'),
(2, 1, 2, 'Mr.'),
(3, 2, 1, 'Пані'),
(4, 2, 2, 'Ms.'),
(5, 3, 1, 'Др.'),
(6, 3, 2, 'Dr.'),
(7, 4, 1, 'Проф.'),
(8, 4, 2, 'Prof.');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_segment`
--

CREATE TABLE `8ydnb966_contacts_segment` (
  `id` int UNSIGNED NOT NULL,
  `color_background` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#000000',
  `color_text` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Сегменти контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_segment`
--

INSERT INTO `8ydnb966_contacts_segment` (`id`, `color_background`, `color_text`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, '#28a745', '#ffffff', 1, 1, '2026-05-28 23:06:20', '2026-05-28 23:06:20'),
(2, '#ffc107', '#000000', 1, 2, '2026-05-28 23:06:20', '2026-05-28 23:06:20'),
(3, '#6c757d', '#ffffff', 1, 3, '2026-05-28 23:06:20', '2026-05-28 23:06:20');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_segment_lang`
--

CREATE TABLE `8ydnb966_contacts_segment_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_segment` int UNSIGNED NOT NULL COMMENT 'FK → contacts_segment',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contacts_segment_lang`
--

INSERT INTO `8ydnb966_contacts_segment_lang` (`id`, `id_segment`, `id_lang`, `name`, `description`) VALUES
(1, 1, 1, 'A — Ключові', 'Найцінніші контакти'),
(2, 1, 2, 'A — Key', 'Top priority contacts'),
(3, 2, 1, 'B — Активні', 'Регулярні контакти'),
(4, 2, 2, 'B — Active', 'Regular contacts'),
(5, 3, 1, 'C — Потенційні', 'В процесі розвитку'),
(6, 3, 2, 'C — Potential', 'In development');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_socials`
--

CREATE TABLE `8ydnb966_contacts_socials` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_contact` int UNSIGNED NOT NULL COMMENT 'FK → contacts',
  `id_social_type` int UNSIGNED NOT NULL COMMENT 'FK → companies_social_type (спільний довідник)',
  `handle` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Username / нікнейм (@name)',
  `url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Повний URL профілю',
  `phone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Номер для Viber/WhatsApp',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = основний акаунт цього типу',
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Примітка',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Соцмережі та месенджери контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_socials`
--

INSERT INTO `8ydnb966_contacts_socials` (`id`, `id_contact`, `id_social_type`, `handle`, `url`, `phone`, `is_primary`, `note`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 0, 1, 'vasyl-ivanov-ua', 'https://linkedin.com/in/vasyl-ivanov-ua', NULL, 1, 'LinkedIn профіль', 1, 1, '2026-05-28 23:12:38', '2026-05-28 23:12:38'),
(2, 0, 4, 'vasyl_ivanov_kv', 'https://t.me/vasyl_ivanov_kv', NULL, 0, 'Telegram', 1, 2, '2026-05-28 23:12:38', '2026-05-28 23:12:38'),
(3, 0, 6, NULL, NULL, '+380673004567', 0, 'WhatsApp', 1, 3, '2026-05-28 23:12:38', '2026-05-28 23:12:38'),
(4, 0, 5, NULL, NULL, '+380501112233', 0, 'Viber особистий', 1, 4, '2026-05-28 23:12:38', '2026-05-28 23:12:38');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_source`
--

CREATE TABLE `8ydnb966_contacts_source` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Джерела контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_source`
--

INSERT INTO `8ydnb966_contacts_source` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 23:06:15', '2026-05-28 23:06:15'),
(2, 1, 2, '2026-05-28 23:06:15', '2026-05-28 23:06:15'),
(3, 1, 3, '2026-05-28 23:06:15', '2026-05-28 23:06:15'),
(4, 1, 4, '2026-05-28 23:06:15', '2026-05-28 23:06:15'),
(5, 1, 5, '2026-05-28 23:06:15', '2026-05-28 23:06:15'),
(6, 1, 6, '2026-05-28 23:06:15', '2026-05-28 23:06:15'),
(7, 1, 7, '2026-05-28 23:06:15', '2026-05-28 23:06:15');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_source_lang`
--

CREATE TABLE `8ydnb966_contacts_source_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_source` int UNSIGNED NOT NULL COMMENT 'FK → contacts_source',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contacts_source_lang`
--

INSERT INTO `8ydnb966_contacts_source_lang` (`id`, `id_source`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Сайт / Форма'),
(2, 1, 2, 'Website / Form'),
(3, 2, 1, 'Холодний дзвінок'),
(4, 2, 2, 'Cold Call'),
(5, 3, 1, 'Виставка / Захід'),
(6, 3, 2, 'Exhibition / Event'),
(7, 4, 1, 'Реферал'),
(8, 4, 2, 'Referral'),
(9, 5, 1, 'Соціальні мережі'),
(10, 5, 2, 'Social Media'),
(11, 6, 1, 'Особистий контакт'),
(12, 6, 2, 'Personal Contact'),
(13, 7, 1, 'Імпорт'),
(14, 7, 2, 'Import');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_status`
--

CREATE TABLE `8ydnb966_contacts_status` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `color_background` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#000000',
  `color_text` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Статуси контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_status`
--

INSERT INTO `8ydnb966_contacts_status` (`id`, `color_background`, `color_text`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, '#28a745', '#ffffff', 1, 1, '2026-05-28 23:06:14', '2026-05-28 23:06:14'),
(2, '#007bff', '#ffffff', 1, 2, '2026-05-28 23:06:14', '2026-05-28 23:06:14'),
(3, '#6c757d', '#ffffff', 1, 3, '2026-05-28 23:06:14', '2026-05-28 23:06:14'),
(4, '#dc3545', '#ffffff', 1, 4, '2026-05-28 23:06:14', '2026-05-28 23:06:14');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_status_lang`
--

CREATE TABLE `8ydnb966_contacts_status_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_contact_status` int UNSIGNED NOT NULL COMMENT 'FK → contacts_status',
  `id_lang` smallint UNSIGNED NOT NULL COMMENT 'FK → languages',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contacts_status_lang`
--

INSERT INTO `8ydnb966_contacts_status_lang` (`id`, `id_contact_status`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Активний'),
(2, 1, 2, 'Active'),
(3, 2, 1, 'Потенційний'),
(4, 2, 2, 'Potential'),
(5, 3, 1, 'Неактивний'),
(6, 3, 2, 'Inactive'),
(7, 4, 1, 'Заблокований'),
(8, 4, 2, 'Blocked');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_tag`
--

CREATE TABLE `8ydnb966_contacts_tag` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_tag_category` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts_tag_category',
  `color_background` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#e9ecef',
  `color_text` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#212529',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Довідник тегів контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_tag`
--

INSERT INTO `8ydnb966_contacts_tag` (`id`, `id_tag_category`, `color_background`, `color_text`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, '#f8d7da', '#58151c', 1, 1, '2026-05-28 23:06:37', '2026-05-28 23:06:37'),
(2, 1, '#d1e7dd', '#0a3622', 1, 2, '2026-05-28 23:06:37', '2026-05-28 23:06:37'),
(3, 2, '#cfe2ff', '#084298', 1, 3, '2026-05-28 23:06:37', '2026-05-28 23:06:37'),
(4, 2, '#d1e7dd', '#0a3622', 1, 4, '2026-05-28 23:06:37', '2026-05-28 23:06:37'),
(5, 2, '#fff3cd', '#664d03', 1, 5, '2026-05-28 23:06:37', '2026-05-28 23:06:37'),
(6, 3, '#e2d9f3', '#432874', 1, 6, '2026-05-28 23:06:37', '2026-05-28 23:06:37'),
(7, 3, '#fde8d8', '#7a3c00', 1, 7, '2026-05-28 23:06:37', '2026-05-28 23:06:37'),
(8, 4, '#f8d7da', '#58151c', 1, 8, '2026-05-28 23:06:37', '2026-05-28 23:06:37'),
(9, 4, '#d1e7dd', '#0a3622', 1, 9, '2026-05-28 23:06:37', '2026-05-28 23:06:37'),
(10, 5, '#cfe2ff', '#084298', 1, 10, '2026-05-28 23:06:37', '2026-05-28 23:06:37'),
(11, 5, '#d1ecf1', '#0c5460', 1, 11, '2026-05-28 23:06:37', '2026-05-28 23:06:37');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_tags_map`
--

CREATE TABLE `8ydnb966_contacts_tags_map` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_contact` int UNSIGNED NOT NULL COMMENT 'FK → contacts',
  `id_tag` int UNSIGNED NOT NULL COMMENT 'FK → contacts_tag',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users (хто поставив тег)',
  `date_add` datetime NOT NULL COMMENT 'Коли поставлено тег'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Прив''язка тегів до контактів (many-to-many)';

--
-- Дамп даних таблиці `8ydnb966_contacts_tags_map`
--

INSERT INTO `8ydnb966_contacts_tags_map` (`id`, `id_contact`, `id_tag`, `id_user`, `date_add`) VALUES
(1, 0, 1, 1, '2026-05-28 23:12:38'),
(2, 0, 3, 1, '2026-05-28 23:12:38'),
(3, 0, 11, 1, '2026-05-28 23:12:38');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_tag_category`
--

CREATE TABLE `8ydnb966_contacts_tag_category` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `color` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#6c757d' COMMENT 'Колір категорії',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Категорії тегів контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_tag_category`
--

INSERT INTO `8ydnb966_contacts_tag_category` (`id`, `color`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, '#007bff', 1, 1, '2026-05-28 23:06:35', '2026-05-28 23:06:35'),
(2, '#28a745', 1, 2, '2026-05-28 23:06:35', '2026-05-28 23:06:35'),
(3, '#ffc107', 1, 3, '2026-05-28 23:06:35', '2026-05-28 23:06:35'),
(4, '#dc3545', 1, 4, '2026-05-28 23:06:35', '2026-05-28 23:06:35'),
(5, '#6f42c1', 1, 5, '2026-05-28 23:06:35', '2026-05-28 23:06:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_tag_category_lang`
--

CREATE TABLE `8ydnb966_contacts_tag_category_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_tag_category` int UNSIGNED NOT NULL COMMENT 'FK → contacts_tag_category',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contacts_tag_category_lang`
--

INSERT INTO `8ydnb966_contacts_tag_category_lang` (`id`, `id_tag_category`, `id_lang`, `name`, `description`) VALUES
(1, 1, 1, 'Пріоритет', NULL),
(2, 1, 2, 'Priority', NULL),
(3, 2, 1, 'Тип співпраці', NULL),
(4, 2, 2, 'Cooperation Type', NULL),
(5, 3, 1, 'Маркетинг', NULL),
(6, 3, 2, 'Marketing', NULL),
(7, 4, 1, 'Фінанси', NULL),
(8, 4, 2, 'Finance', NULL),
(9, 5, 1, 'Кваліфікація', NULL),
(10, 5, 2, 'Qualification', NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_tag_lang`
--

CREATE TABLE `8ydnb966_contacts_tag_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_tag` int UNSIGNED NOT NULL COMMENT 'FK → contacts_tag',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contacts_tag_lang`
--

INSERT INTO `8ydnb966_contacts_tag_lang` (`id`, `id_tag`, `id_lang`, `name`, `description`) VALUES
(1, 1, 1, 'VIP', 'Ключовий контакт, особлива увага'),
(2, 1, 2, 'VIP', 'Key contact, special attention'),
(3, 2, 1, 'Новий', 'Перший контакт, ще не кваліфікований'),
(4, 2, 2, 'New', 'First contact, not yet qualified'),
(5, 3, 1, 'ЛПР', 'Особа що приймає рішення'),
(6, 3, 2, 'Decision Maker', 'Key decision maker'),
(7, 4, 1, 'Партнер', 'Партнерська співпраця'),
(8, 4, 2, 'Partner', 'Partnership cooperation'),
(9, 5, 1, 'Агент', 'Агентська схема роботи'),
(10, 5, 2, 'Agent', 'Works on agency basis'),
(11, 6, 1, 'Розсилка', 'Підписаний на email-розсилку'),
(12, 6, 2, 'Newsletter', 'Subscribed to newsletter'),
(13, 7, 1, 'Виставка 2026', 'Зустрілись на виставці 2026'),
(14, 7, 2, 'Expo 2026', 'Met at exhibition 2026'),
(15, 8, 1, 'Борг', 'Має прострочену заборгованість'),
(16, 8, 2, 'Debt', 'Has overdue debt'),
(17, 9, 1, 'Передоплата', 'Працює тільки за передоплатою'),
(18, 9, 2, 'Prepayment', 'Prepayment only'),
(19, 10, 1, 'Холодний', 'Ще не виявив інтерес'),
(20, 10, 2, 'Cold', 'Has not shown interest yet'),
(21, 11, 1, 'Теплий', 'Виявив інтерес, в процесі'),
(22, 11, 2, 'Warm', 'Interested, in process');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_contacts_websites`
--

CREATE TABLE `8ydnb966_contacts_websites` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_contact` int UNSIGNED NOT NULL COMMENT 'FK → contacts',
  `url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'URL',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Назва / підпис (Портфоліо, Блог...)',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = головний сайт',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Сайти та URL контактів';

--
-- Дамп даних таблиці `8ydnb966_contacts_websites`
--

INSERT INTO `8ydnb966_contacts_websites` (`id`, `id_contact`, `url`, `title`, `is_primary`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 0, 'https://ivanov-blog.ua', 'Особистий блог', 1, 1, 1, '2026-05-28 23:12:38', '2026-05-28 23:12:38');

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
(3, 34, 1, 1, 'image', NULL, 0, '/assets/contact-center/telegram/179ad037ac6dd0cfac7f0ee2e755b9c6/client/36a8b4bd98a2d5eb8aaeabb3abeee368.bin', NULL, NULL, 'application/octet-stream', 48329, '36a8b4bd98a2d5eb8aaeabb3abeee368f98cac710011b122b34c98692dbf308a', 623, 646, NULL, NULL, 'telegram_file_id', 'AgACAgIAAxkBAAMLaqdWpm-_C9W-c3j8-sbHAfIZ8P4AAj8oaxvFrzhJmdm53sZ6VAABAQADAgADeAADPQQ', NULL, 'done', 1, NULL, '2026-09-14 08:18:27', '2026-09-14 08:18:27', '2026-09-14 08:18:27'),
(4, 81, 4, 3, 'image', NULL, 0, '/assets/contact-center/instagram/c9f1d3cef9cb1ad1988631c058d2a8af/client/9e5792ec55024de1f26d42ffc72e564d.jpg', NULL, NULL, 'image/jpeg', 11595, '9e5792ec55024de1f26d42ffc72e564df9a35a88e7c45580d80a24ce6e98e4e9', NULL, NULL, NULL, NULL, 'url', 'https://lookaside.fbsbx.com/ig_messaging_cdn/?asset_id=26858187340545872&signature=Ab0mJCjg-l5ar7cQtJ4xDfeBCtWDJ9INNcYMPNW1bnf8Ml3O6R2nGCmNxE4K2_s2iJ1Rcm3jMC996RjzALLwauKk6Cvg8MoT0u1_IjEM6VHV7J4m6H9e6W5qKWYJWB7RQIHbfn8TWwwbc0GcOyE73Z2o2qCVMK-uBSuiIcXfl4bgapYG4I14cJdzYAedn7AKjHzyh8fo1Mr0ZNUXing25f9um24I8xTL', NULL, 'done', 1, NULL, '2026-09-15 17:42:29', '2026-09-15 17:42:29', '2026-09-15 17:42:29'),
(5, 84, 4, 3, 'image', NULL, 0, '/assets/contact-center/instagram/c9f1d3cef9cb1ad1988631c058d2a8af/client/9e5792ec55024de1f26d42ffc72e564d.jpg', NULL, NULL, 'image/jpeg', 11595, '9e5792ec55024de1f26d42ffc72e564df9a35a88e7c45580d80a24ce6e98e4e9', NULL, NULL, NULL, NULL, 'url', 'https://lookaside.fbsbx.com/ig_messaging_cdn/?asset_id=1068685955809515&signature=Ab1C-x1e0fN4Zyw0m_K7vJ0jENSZZPzv5c2M4e_bDuTMSjhfr8UWAkEPQs8gjg_d727DSWIju2yQdFg7ZvAr5yo2dBBLU9i2f3Ax7nHQVSgmXSQFg0DN6G3jEpQqfc43cA0d1knLjBpDmvhqgw-PsZJkjIcgECyQsQ9WELHL6pJ6ZgPlc3kr2Dmpvs_XJ8GHpHgc59RaZ5vSOm5-d7jrbrWLOJt_I7c', NULL, 'done', 1, NULL, '2026-09-15 17:59:29', '2026-09-15 17:59:29', '2026-09-15 17:59:30'),
(6, 87, 4, 3, 'image', NULL, 0, '/assets/contact-center/instagram/c9f1d3cef9cb1ad1988631c058d2a8af/client/9e5792ec55024de1f26d42ffc72e564d.jpg', NULL, NULL, 'image/jpeg', 11595, '9e5792ec55024de1f26d42ffc72e564df9a35a88e7c45580d80a24ce6e98e4e9', NULL, NULL, NULL, NULL, 'url', 'https://lookaside.fbsbx.com/ig_messaging_cdn/?asset_id=1113654228010349&signature=Ab2X4DvknEKPwRA31-SWj0T3VmVn3_80-1ECH44-L06QMjk6a_VGCR5lR34tcThY4L9_609hIcunVeIjTBAnjXxvkEMJLhXMDDMfc7_SUzxuU9Li7Ho8h-ephOlQgbGpBLS8DJ3NMsv0JYZTMp0vdrv3BVgaoFLGSV_SP1CrdaWV-7ReyH_Eq6gMq96FIHvUnvI9plHhAEDxp6Kh_hAsjS6ZlQO6OSg', NULL, 'done', 1, NULL, '2026-09-15 18:12:54', '2026-09-15 18:12:54', '2026-09-15 18:12:54'),
(7, 88, 4, 3, 'image', NULL, 0, '/assets/contact-center/instagram/c9f1d3cef9cb1ad1988631c058d2a8af/manager/c0354304912bc176898a80bb853d4422.png', NULL, 'novyiÌproekt.png', 'image/png', 242008, NULL, NULL, NULL, NULL, NULL, 'none', NULL, NULL, 'done', 0, NULL, NULL, '2026-09-15 18:18:55', '2026-09-15 18:18:55'),
(8, 98, 4, 3, 'audio', 'voice', 0, '/assets/contact-center/instagram/c9f1d3cef9cb1ad1988631c058d2a8af/client/740c8b3ecfa691c76768fc514815860f.mp4', NULL, NULL, 'video/mp4', 3289, '740c8b3ecfa691c76768fc514815860ffb4f3902d3c2996234577219b07561cd', NULL, NULL, NULL, NULL, 'url', 'https://lookaside.fbsbx.com/ig_messaging_cdn/?asset_id=28196487156672288&signature=Ab1r_64qBYuBM3XHoQfDwts0Ou14xYiV5upObgHC9tvDibLbzTiKAyqgL1wYr0bv1qA58kx05ALdZ-SYOcjRSOCHgUtGtwUgzBFLvnaYGoXR4BGLocuZo4pD2vyzYFMqqAT4mxvX1hGDv34wKc1gvZNqZbDEhiTCa6ZJogByZOt39_JyQOOWq0k3Jc2kSaHCvb7TypxC3Bhlby3EP6b0UuUZY32R52q6', NULL, 'done', 1, NULL, '2026-09-16 06:06:07', '2026-09-16 06:06:07', '2026-09-16 06:06:08'),
(9, 99, 4, 3, 'video', NULL, 0, '/assets/contact-center/instagram/c9f1d3cef9cb1ad1988631c058d2a8af/client/9ac1b3bcab8e67181989a91993506e6e.mp4', NULL, NULL, 'video/mp4', 7094430, '9ac1b3bcab8e67181989a91993506e6e8559531987d02314b1ccee5f5047c984', NULL, NULL, NULL, NULL, 'url', 'https://lookaside.fbsbx.com/ig_messaging_cdn/?asset_id=1071878605551710&signature=Ab2WP5uFN4Bawe30TU05886WR_8MRwTk9ekOR0MeGQlnN7WDbyOpcfrECrJ9gT2NLDAo889T4fBy9tibRFGCIDGcwqUYKY-CdJUd-E5mEYn0tFsCvQMvcj5pb6ku-vJGbW6PNFB3a2CYQAvVtUU-oSAhsVDnJZQHEj_7ZASTS9iVvyRwi6zHofwGWRoRy5uHH2s3UPixc6Yfau194wVs_NdZF6WSVYE', NULL, 'done', 1, NULL, '2026-09-16 06:06:47', '2026-09-16 06:06:47', '2026-09-16 06:06:50'),
(10, 100, 4, 3, 'video', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'url', 'https://lookaside.fbsbx.com/ig_messaging_cdn/?asset_id=3511739452339728&signature=Ab0dT4NLPytUIPQDH7bn3hj7x1bky0-TMMpr9Km8rHyc-XuaFtiofqIP5-zfeBp8UEMNQCSiH1ALzDKZSpCbnPaZ9QBF1VRqD19kOqVsWqC_s2ebN3uK3SQPWSauIXE-1vY9RhR2h6eVO3d5MwZZjhh3kTaN0ATr47iQcFvf1ZHarL8yYnyWH1aq_7cKYG8NxBZb1NqWEWifX2suLdlXLXZEU2HONww', NULL, 'pending', 0, NULL, '2026-09-16 06:06:54', '2026-09-16 06:06:53', '2026-09-16 06:06:53'),
(11, 102, 4, 3, 'video', NULL, 0, '/assets/contact-center/instagram/c9f1d3cef9cb1ad1988631c058d2a8af/client/94385a90bdcb67a9a857f5f0900520f8.mp4', NULL, NULL, 'video/mp4', 1645059, '94385a90bdcb67a9a857f5f0900520f82b80e83e3913031c9902a9508a75ae91', NULL, NULL, NULL, NULL, 'url', 'https://lookaside.fbsbx.com/ig_messaging_cdn/?asset_id=1503726331791719&signature=Ab2YlI_-Zzi3yst3GcARUslyt5rmUpLhrlLMEZRPF1IozOlQNRtZ93oWJjFxbc3CpyGk8XFiiZ0vOsZcYwjUYinB9BoIQFSsHtOwbJLQ8bKu9EJya1INHcVNXqogka7kyjrRkA_nKtwVBf3WyOfbgPAe6H0zIFUNtORCU3zHYlSdUm9STK71RgqZ0i4q6atvurs92KlUAdXql0F5lG9RPmvhcrZKixo', NULL, 'done', 1, NULL, '2026-09-16 06:24:00', '2026-09-16 06:24:00', '2026-09-16 06:24:02'),
(12, 104, 4, 3, 'video', NULL, 0, '/assets/contact-center/instagram/c9f1d3cef9cb1ad1988631c058d2a8af/client/26e6857229ece05a2d8925da0c8c4587.mp4', NULL, NULL, 'video/mp4', 2828476, '26e6857229ece05a2d8925da0c8c45870573bbcbf08128019c9fe01e35fd20bd', NULL, NULL, NULL, NULL, 'url', 'https://lookaside.fbsbx.com/ig_messaging_cdn/?asset_id=3230344840484655&signature=Ab0Wnr8j6-ipccp_pFa4cLu3fWhdqpdsUCn260yoa352Qj7P2JkUiQvpDz_UeXdMjdztX8B-NrQJg0tyRKjrsuUrmlfv-_aQkS53gzxQdeT4yM1m4L2g8RdJq0rJEi7FJ9z_OksPzHAGTCP56ndFFOuupJ6M2vBxTRsTvLPHvyIPWv9_29aEiZa-wZMQ5ECDGR4IGXvCzm0zQGpDEGkcync0SWUQ_KI', NULL, 'done', 1, NULL, '2026-09-16 06:24:55', '2026-09-16 06:24:55', '2026-09-16 06:24:57'),
(13, 118, 5, 1, 'image', NULL, 0, '/assets/contact-center/telegram/3678720a05a4a4753132aaad08e9db61/manager/a065717d24f34f50f48183d97813ffa7.jpg', NULL, '798216890_4553464541642114_4363126141368115513_n.jpg', 'image/jpeg', 41074, NULL, NULL, NULL, NULL, NULL, 'none', NULL, NULL, 'done', 0, NULL, NULL, '2026-09-17 00:36:45', '2026-09-17 00:36:45');

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
(2, 'webchat', 'Веб чат', 1, 1, 'ok', NULL, '2026-09-14 09:56:18', 0, 1, 1, NULL, '2026-09-14 08:20:20', '2026-09-17 15:12:40', 0, NULL),
(3, 'instagram', 'Інстаграм', 1, 1, 'ok', NULL, '2026-09-15 17:29:36', 0, 1, 1, NULL, '2026-09-15 13:46:03', '2026-09-15 17:29:36', 0, NULL);

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
  `app_secret_cipher` varbinary(512) DEFAULT NULL,
  `app_secret_iv` varbinary(16) DEFAULT NULL,
  `app_secret_tag` varbinary(16) DEFAULT NULL,
  `verify_token` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date_deleted` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contact_center_channel_instagram`
--

INSERT INTO `8ydnb966_contact_center_channel_instagram` (`id`, `id_channel`, `ig_user_id`, `ig_username`, `ig_account_type`, `ig_profile_picture`, `token_cipher`, `token_iv`, `token_tag`, `token_type`, `date_token_expires`, `date_token_refresh`, `app_id`, `app_secret_cipher`, `app_secret_iv`, `app_secret_tag`, `verify_token`, `date_add`, `date_edit`, `date_deleted`) VALUES
(1, 3, 17841461446010333, 'skyneuron', 'BUSINESS', 'https://scontent-fra3-2.cdninstagram.com/v/t51.75761-19/503134545_17931070467048201_7531734332733236815_n.jpg?stp=dst-jpg_s206x206_tt6&_nc_cat=104&ccb=7-5&_nc_sid=bf7eb4&efg=eyJ2ZW5jb2RlX3RhZyI6InByb2ZpbGVfcGljLnd3dy41MTIuQzMifQ%3D%3D&_nc_ohc=_ebbnPI8WTAQ7kNvwHAfyHR&_nc_oc=AdoHE-hgstt89q3gQTG3YMuMqAjNCtf3ARa3cAcHR8WdBEu3VSML9MPU0wwPHjYI0y-QE4JeE1uNvuFoJqcn3G-P&_nc_zt=24&_nc_ht=scontent-fra3-2.cdninstagram.com&edm=AP4hL3IEAAAA&_nc_gid=aFK2m69j3dzdGTVGXxDPeg&_nc_tpa=Q5bMBQKz-_8ocvRvoyumPE4n-GHT6G6rRyt6MVTUDUgzAzTloXo6haxF1X2hZ2gd0zlQ9kIaPd_QXssUSg&oh=00_AQJwg1NzdViIIxuXQkoSdZGZ7StpJajcFrBwBCBwVjXE7g&oe=6AAF3BE7', 0xf1cf4c76540655f82016068ac8c55aec44b11242d4c8e8481bec0f4c337638796db303d8d9a3694e8c64370005abdf654b8a2bbdf81186100b020446068a51da0abd4d1ad3c57fd3e373a9eb90f475748523c9fb77e4aa11fff307357d3752e648899f899b5dd55935043f81ab3f5b7e2c13296fadd7a5cfd512fffdc115e9ed7c748b81a511d5ea483f6ff0163fc0148ca3fda0dba3c4d446295a5a5ec1c5b8ac4a5e, 0xc77536a712dc2c56bef7308f, 0x2b420c587ab7bd2af95a012c85a0b1d1, 'long_lived', '2026-11-14 15:44:42', '2026-09-15 19:18:44', '936825515455008', 0xc21eb59b73a09ee65a4b1061cc6e4509492099b361dd53f3bd8ef0a3082fee0a, 0xe86ca0695a3d46e66e79501f, 0x0bfb9f2a9f33691cde706ddd98c170fc, '58c344877c5aa8e1e4d579883f1879f147c4de1720748316ffdf52d670c49ea7', '2026-09-15 13:46:03', '2026-09-15 19:18:44', NULL);

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
(1, 1, '339284801', 'Сергій М. 🇺🇦', 'Сергій', 'М. 🇺🇦', 'motchanyy', '/assets/contact-center/avatars/tg_339284801_1789594286803.jpg', NULL, NULL, 'uk', NULL, 0, '{\"is_bot\": false, \"chat_type\": \"private\", \"avatar_synced_at\": \"2026-09-16T21:31:26.803Z\"}', NULL, '2026-09-17 11:38:53', '2026-09-14 04:54:51', '2026-09-17 11:38:53'),
(30, 2, 'my-shop-123_v_0bd8e73773b22d339f', 'v_0bd8e73773b22d339f', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '{\"site_id\": \"my-shop-123\", \"visitor_id\": \"v_0bd8e73773b22d339f\"}', NULL, '2026-09-14 08:40:50', '2026-09-14 08:40:50', '2026-09-14 08:40:50'),
(31, 2, 'my-shop-123_v_4ea757c811625b51d7', 'v_4ea757c811625b51d7', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, '{\"site_id\": \"my-shop-123\", \"visitor_id\": \"v_4ea757c811625b51d7\"}', NULL, '2026-09-17 16:18:26', '2026-09-14 08:42:08', '2026-09-17 16:18:26'),
(46, 3, '4342583812721401', 'Сергій Мотчаний', NULL, NULL, NULL, 'https://scontent-fra3-2.cdninstagram.com/v/t51.2885-19/438990828_792350232802822_6937790446175074459_n.jpg?stp=dst-jpg_s206x206_tt6&_nc_cat=104&ccb=7-5&_nc_sid=bf7eb4&efg=eyJ2ZW5jb2RlX3RhZyI6InByb2ZpbGVfcGljLnd3dy42NDAuQzMifQ%3D%3D&_nc_ohc=0BolB8fUgNwQ7kNvwHu-JUB&_nc_oc=AdoKPEoNv6dKPPZI-ZlfKJWqEkZ8bgKSAV1eleOGTzbRNl1UJZM0-p9lrPxyWMpIwIm9KB4wDY0HVZ1Z42Sc5Uwq&_nc_zt=24&_nc_ht=scontent-fra3-2.cdninstagram.com&edm=ALmAK4EEAAAA&oh=00_AQLnTigjcQ_NrRQfdrUTPhDkeWeqosCXSAjhMz5jRWq36g&oe=6AB0C9EF', NULL, NULL, NULL, NULL, 0, '{\"profile_synced_at\": \"2026-09-16T21:08:34.501Z\"}', NULL, '2026-09-17 00:14:07', '2026-09-15 15:46:33', '2026-09-17 00:14:07');

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
(4, 3, 46, 'open', 1, 0, 'c9f1d3cef9cb1ad1988631c058d2a8af', '4342583812721401', 112, '555', 'text', 'in', '2026-09-17 00:14:05.791', '2026-09-17 00:14:05.791', '2026-09-15 15:46:46.632', 46, NULL, NULL, '2026-09-15 15:46:33', '2026-09-17 00:14:07'),
(5, 1, 1, 'open', 1, 0, '3678720a05a4a4753132aaad08e9db61', '339284801', 120, 'Сергій М. 🇺🇦 +380687207605', 'contact', 'in', '2026-09-17 11:38:53.000', '2026-09-17 11:38:53.000', '2026-09-15 17:19:44.714', 12, NULL, NULL, '2026-09-15 15:53:10', '2026-09-17 11:38:53');

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
  `reaction` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `error` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `has_attachments` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `date_edited` datetime(3) DEFAULT NULL,
  `date_deleted` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_contact_center_messages`
--

INSERT INTO `8ydnb966_contact_center_messages` (`id`, `id_conversation`, `id_channel`, `direction`, `id_manager`, `source_id`, `type`, `subtype`, `text`, `id_reply_to`, `lat`, `lng`, `attributes`, `status`, `reaction`, `error`, `has_attachments`, `date_add`, `date_edited`, `date_deleted`) VALUES
(1, 1, 1, 'in', NULL, '6', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 04:54:51.000', NULL, NULL),
(2, 1, 1, 'in', NULL, '7', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 04:55:00.000', NULL, NULL),
(3, 1, 1, 'in', NULL, '8', 'text', NULL, '333', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 04:55:07.000', NULL, NULL),
(4, 1, 1, 'out', 1, '9', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'sent', NULL, NULL, 0, '2026-09-14 04:59:14.218', NULL, NULL),
(5, 1, 1, 'out', 1, '10', 'text', NULL, '3333333', NULL, NULL, NULL, NULL, 'sent', NULL, NULL, 0, '2026-09-14 04:59:21.101', NULL, NULL),
(6, 1, 1, 'in', NULL, '11', 'media', NULL, NULL, NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 1, '2026-09-14 05:06:30.000', NULL, NULL),
(7, 1, 1, 'in', NULL, '12', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 05:06:34.000', NULL, NULL),
(8, 1, 1, 'in', NULL, '13', 'text', NULL, '3333', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 05:24:59.000', NULL, NULL),
(9, 1, 1, 'in', NULL, '14', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 05:25:06.000', NULL, NULL),
(10, 1, 1, 'in', NULL, '15', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 05:33:20.000', NULL, NULL),
(11, 1, 1, 'in', NULL, '16', 'text', NULL, '44', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 05:33:31.000', NULL, NULL),
(12, 1, 1, 'in', NULL, '17', 'text', NULL, '555', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 05:37:11.000', NULL, NULL),
(13, 1, 1, 'in', NULL, '18', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 05:37:17.000', NULL, NULL),
(14, 1, 1, 'in', NULL, '19', 'text', NULL, '555', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 05:53:22.000', NULL, NULL),
(15, 1, 1, 'in', NULL, '20', 'text', NULL, '55', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 05:53:27.000', NULL, NULL),
(16, 1, 1, 'in', NULL, '21', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 06:01:46.000', NULL, NULL),
(17, 1, 1, 'in', NULL, '22', 'text', NULL, '3', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 06:01:50.000', NULL, NULL),
(18, 1, 1, 'in', NULL, '23', 'text', NULL, '2', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 06:01:53.000', NULL, NULL),
(19, 1, 1, 'in', NULL, '24', 'text', NULL, '5', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 06:01:55.000', NULL, NULL),
(20, 1, 1, 'in', NULL, '25', 'text', NULL, '6', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 06:03:47.000', NULL, NULL),
(21, 1, 1, 'in', NULL, '26', 'text', NULL, '3', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 06:03:55.000', NULL, NULL),
(22, 1, 1, 'in', NULL, '27', 'text', NULL, '4', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 06:05:07.000', NULL, NULL),
(23, 1, 1, 'in', NULL, '28', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 06:05:18.000', NULL, NULL),
(24, 1, 1, 'in', NULL, '29', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 06:05:25.000', NULL, NULL),
(25, 1, 1, 'in', NULL, '30', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 06:07:52.000', NULL, NULL),
(26, 1, 1, 'in', NULL, '31', 'text', NULL, '444', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 06:07:55.000', NULL, NULL),
(27, 1, 1, 'in', NULL, '32', 'text', NULL, '5', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 06:10:24.000', NULL, NULL),
(28, 1, 1, 'in', NULL, '33', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 06:10:54.000', NULL, NULL),
(29, 1, 1, 'in', NULL, '34', 'text', NULL, '3', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 06:10:57.000', NULL, NULL),
(30, 1, 1, 'out', 1, '35', 'system', 'request_contact', 'Поділитися номером', NULL, NULL, NULL, NULL, 'sent', NULL, NULL, 0, '2026-09-14 07:57:16.853', NULL, NULL),
(31, 1, 1, 'in', NULL, '36', 'contact', NULL, 'Сергій М. 🇺🇦 +380687207605', NULL, NULL, NULL, '{\"reply_to_source_id\": \"35\"}', 'delivered', NULL, NULL, 0, '2026-09-14 07:57:23.000', NULL, NULL),
(32, 1, 1, 'out', 1, '37', 'text', NULL, '😃😀😘', NULL, NULL, NULL, NULL, 'sent', NULL, NULL, 0, '2026-09-14 08:08:25.637', NULL, NULL),
(33, 1, 1, 'out', 1, '38', 'media', NULL, '123', NULL, NULL, NULL, NULL, 'sent', NULL, NULL, 1, '2026-09-14 08:17:25.326', NULL, NULL),
(34, 1, 1, 'in', NULL, '39', 'media', NULL, '3333\n4444', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 1, '2026-09-14 08:18:27.000', NULL, NULL),
(35, 2, 2, 'in', NULL, 'wc_62', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-14 08:40:50.031', NULL, NULL),
(36, 2, 2, 'out', 1, NULL, 'text', NULL, '123', NULL, NULL, NULL, NULL, 'sent', NULL, NULL, 0, '2026-09-14 08:41:06.172', NULL, NULL),
(37, 2, 2, 'out', 1, NULL, 'text', NULL, '333', NULL, NULL, NULL, NULL, 'sent', NULL, NULL, 0, '2026-09-14 08:41:15.516', NULL, NULL),
(38, 2, 2, 'out', 1, NULL, 'text', NULL, '🤭🤭', NULL, NULL, NULL, NULL, 'sent', NULL, NULL, 0, '2026-09-14 08:41:36.326', NULL, NULL),
(63, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDAxMzAyMTI2NjU0Njg3MzgxNjIwMzg1MDE1Mzk4NAZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 15:46:31.571', NULL, NULL),
(64, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDAxMzMyMzk3NTcxNzEwODc1MDM1Mzc4NDg5NzUzNgZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'read', NULL, NULL, 0, '2026-09-15 15:46:46.632', NULL, NULL),
(65, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDAxNDk2NDczMjc2ODgzMjY4Mzk3NDc3MjkxNjIyNAZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'read', NULL, NULL, 0, '2026-09-15 15:48:15.847', NULL, NULL),
(66, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDAxNTE0MDA5MTMxODAyNjY0NjE1NjYwMjI0NTEyMAZDZD', 'text', NULL, '5555555', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 15:48:26.433', NULL, NULL),
(67, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDAxNTMyNDE1MDc1MzY3ODMxOTM2NDg5OTYwMjQzMgZDZD', 'text', NULL, '🤗🤭🤢', NULL, NULL, NULL, NULL, 'read', NULL, NULL, 0, '2026-09-15 15:48:35.515', NULL, NULL),
(68, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDAxNDU2MTQxNTcyMDUwMjUyNDU4Mzg2ODM2Njg0OAZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 15:47:55.063', NULL, NULL),
(69, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDAxNTQ2ODM0NjU5MDkxOTI2NTQ5NTA1OTI2NzU4NAZDZD', 'text', NULL, '😆😄😃', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 15:48:44.228', NULL, NULL),
(70, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDAxNTgxNzE0MTEzMjc0NjMzOTcwMTgyOTQwMjYyNAZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 15:49:03.136', NULL, NULL),
(71, 5, 1, 'in', NULL, '40', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 15:53:10.000', NULL, NULL),
(72, 5, 1, 'in', NULL, '41', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 15:53:24.000', NULL, NULL),
(73, 5, 1, 'in', NULL, '42', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 15:53:49.000', NULL, NULL),
(74, 5, 1, 'out', 1, '43', 'text', NULL, '333', NULL, NULL, NULL, NULL, 'sent', NULL, NULL, 0, '2026-09-15 17:19:44.714', NULL, NULL),
(75, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDExNjM1MDI3MjYzMzYwMzI4NDAyMDU4NjYxMDY4OAZDZD', 'text', NULL, '333', NULL, NULL, NULL, NULL, 'read', NULL, NULL, 0, '2026-09-15 17:19:52.103', NULL, NULL),
(76, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDEyNTEwNzk4MjEyODE2NDMxNjEzODM1MDU3NTYxNgZDZD', 'text', NULL, '55555', NULL, NULL, NULL, NULL, 'read', NULL, NULL, 0, '2026-09-15 17:27:47.095', NULL, NULL),
(77, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDEzMzc5MTU4Njk3NTA1MDgxNjY5NzQ2MjE2MTQwOAZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 17:35:38.543', NULL, NULL),
(78, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDE0MDQyMDYyNTg3NzkzNjg4NDkwNTI2NTg1NjUxMgZDZD', 'text', NULL, '555', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 17:41:37.904', NULL, NULL),
(79, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDE0MDYwNDIwNDQ2MjMxMDc4ODcyNjY4MTIzOTU1MgZDZD', 'text', NULL, '33333333', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 17:41:47.856', NULL, NULL),
(80, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDE0MTMyNDU4OTI1NzUyNzk3NjMwODMwNzM5NDU2MAZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 17:42:26.908', NULL, NULL),
(81, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDE0MTMyNjc3NDIzNzQ3MDAxOTA1NzI3NzIwNjUyOAZDZD', 'media', NULL, NULL, NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 1, '2026-09-15 17:42:27.027', NULL, NULL),
(82, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDE1OTgyMjE1MTA0OTAwMTA4MTUwMzIyMzkwNjMwNAZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 17:59:09.663', NULL, NULL),
(83, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDE2MDE0NzU0MDAyOTkwNjAzOTcwNDEzMTczMTQ1NgZDZD', 'text', NULL, '555555555', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 17:59:27.302', NULL, NULL),
(84, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDE2MDE1NDY5Njk0MjMzMTUyNTMxNDgzOTA1MjI4OAZDZD', 'media', NULL, NULL, NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 1, '2026-09-15 17:59:27.690', NULL, NULL),
(85, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDE2MDI2Njg3NTg1NDI0MTYzNDEyNTEyMjM3MTU4NAZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'read', NULL, NULL, 0, '2026-09-15 17:59:33.027', NULL, NULL),
(86, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDE2MDQyNjI1MTQwNjUwMDM3MTQwMzA0OTUzMzQ0MAZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'read', NULL, NULL, 0, '2026-09-15 17:59:41.759', NULL, NULL),
(87, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDE3NDk5OTcwNzAyMjk3MjM1NDE1NzM4MDM3MDQzMgZDZD', 'media', NULL, NULL, NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 1, '2026-09-15 18:12:52.440', NULL, NULL),
(88, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDE4MTgzMTE4NzU0MTk3OTU0NzE0MTY2Njc2Njg0OAZDZD', 'media', NULL, '333', NULL, NULL, NULL, NULL, 'read', NULL, NULL, 1, '2026-09-15 18:18:55.978', NULL, NULL),
(89, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDIxMjU2NTY1MzI0MDAyMzA2NzIyNjcyODgyNDgzMgZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 18:46:48.894', NULL, NULL),
(90, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDIxODI5NzAwNDI1MzQxODE5OTY1MjQwMjk4NzAwOAZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'read', NULL, NULL, 0, '2026-09-15 18:51:58.794', NULL, NULL),
(91, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDIxODQ0NDA1ODMwMjk3MjkwMjYzNTMyODI0MTY2NAZDZD', 'text', NULL, '4444', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 18:52:07.563', NULL, NULL),
(92, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDIyMDA4MTUxODQwNTAyMjAzMDI5NTU3NTAzNTkwNAZDZD', 'text', NULL, '444', NULL, NULL, NULL, NULL, 'read', NULL, NULL, 0, '2026-09-15 18:53:35.261', NULL, NULL),
(93, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDIyMDE1MzExNjIxMzk2MzkyMTAyMTAwMTAwNzEwNAZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 18:53:40.211', NULL, NULL),
(94, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDIyMTA5MzYzMTg3MjI3NzMwMDEyMTY5ODMwNDAwMAZDZD', 'text', NULL, '5555', NULL, NULL, NULL, NULL, 'read', NULL, NULL, 0, '2026-09-15 18:54:30.457', NULL, NULL),
(95, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDIyMTM4ODkzMzQyMDM4ODA0Mjg3NDQwOTcxMzY2NAZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 18:54:47.205', NULL, NULL),
(96, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDIyNjQzNTYzNjcwMDMyNzQyNTk2OTg5ODkxMzc5MgZDZD', 'text', NULL, '3', NULL, NULL, NULL, NULL, 'read', NULL, NULL, 0, '2026-09-15 18:59:19.953', NULL, NULL),
(97, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDIyNjUyNDAxNzYzMzcyODczODc1MTAyODM5NjAzMgZDZD', 'text', NULL, '2', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-15 18:59:25.578', NULL, NULL),
(98, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDk2NDM3OTg2MjY5ODE3NDYzMDI3MTQyOTY0MDE5MgZDZD', 'media', NULL, NULL, NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 1, '2026-09-16 06:06:04.824', NULL, NULL),
(99, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDk2NTEzNDM0Njc0MjUzMzkyNzcyODI0NzIwOTk4NAZDZD', 'media', NULL, NULL, NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 1, '2026-09-16 06:06:45.725', NULL, NULL),
(100, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDk2NTI1NDM4ODM3NjE5MTI3MDQyNDEwMTc4MTUwNAZDZD', 'media', NULL, NULL, NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 1, '2026-09-16 06:06:52.232', NULL, NULL),
(101, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDk4NDA3NTA5MDg1OTQwMTYzMDA5OTc3NTE2MDMyMAZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-16 06:23:52.504', NULL, NULL),
(102, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDk4NDE5Mjc0Mzc2ODgyODYzNTkyNDY2MjMyMTE1MgZDZD', 'media', NULL, NULL, NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 1, '2026-09-16 06:23:58.882', NULL, NULL),
(103, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDk4NTE4Nzc0NjQ0MjEwOTUwMjM5MjMxNjcyMzIwMAZDZD', 'text', NULL, '555', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-16 06:24:52.822', NULL, NULL),
(104, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDk4NTIwMTYwNTY4Mzg0NjI2NTE4OTI1MDg5MTc3NgZDZD', 'media', NULL, NULL, NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 1, '2026-09-16 06:24:53.573', NULL, NULL),
(105, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMDk4Njg0MzkxMjI5ODk2NTg3ODU1OTk5Mzc1NzY5NgZDZD', 'text', NULL, '➗', NULL, NULL, NULL, NULL, 'read', NULL, NULL, 0, '2026-09-16 06:26:21.796', NULL, NULL),
(106, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMTAxNjE4MzI5OTA5MTYzMDk2MjQ0OTA3MjUyMTIxNgZDZD', 'text', NULL, '55', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-16 06:52:53.094', NULL, NULL),
(107, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMTExMjI3MjU2NjgzNTA5MDM3NTUyNDMxMzIwMjY4OAZDZD', 'text', NULL, '123123123444', NULL, NULL, NULL, NULL, 'read', NULL, NULL, 0, '2026-09-16 08:19:41.262', NULL, NULL),
(108, 4, 3, 'out', 1, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMTExMjQ0OTg4NjQ5NDU0MDMwMTkxNTk5MzkzMTc3NgZDZD', 'text', NULL, '123', NULL, NULL, NULL, NULL, 'read', '❤', NULL, 0, '2026-09-16 08:19:51.002', NULL, NULL),
(109, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMTExMjY0Njk1MjAyODQ2MjA3MjkyODE3Mjc2OTI4MAZDZD', 'text', NULL, '123123', NULL, NULL, NULL, NULL, 'delivered', '❤', NULL, 0, '2026-09-16 08:20:02.399', NULL, NULL),
(110, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMjE2MjQ1NDI2NDk2NzgwMDAwOTE2OTE4Mzk2NTE4NAZDZD', 'text', NULL, '555', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-17 00:08:32.567', NULL, NULL),
(111, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMjE2ODA4NDU3ODc1NTEzMTYwMDc2NDA3NDQ1OTEzNgZDZD', 'text', NULL, '555', 105, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-17 00:13:37.787', NULL, NULL),
(112, 4, 3, 'in', NULL, 'aWdfZAG1faXRlbToxOklHTWVzc2FnZAUlEOjE3ODQxNDYxNDQ2MDEwMzMzOjM0MDI4MjM2Njg0MTcxMDMwMTI0NDI1OTIxMDYyMDkxNjMwOTQ3MTozMzAxMjE2ODYwMTE0ODUwMDM0NDM5OTU5ODI2MTg5NTE2OAZDZD', 'text', NULL, '555', 107, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-17 00:14:05.791', NULL, NULL),
(113, 5, 1, 'out', 1, '44', 'text', NULL, '2', NULL, NULL, NULL, NULL, 'sent', NULL, NULL, 0, '2026-09-17 00:21:24.455', NULL, NULL),
(114, 5, 1, 'in', NULL, '45', 'text', NULL, '333', 74, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-17 00:31:26.000', NULL, NULL),
(115, 5, 1, 'in', NULL, '46', 'text', NULL, '333', 74, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-17 00:31:48.000', NULL, NULL),
(116, 5, 1, 'in', NULL, '47', 'text', NULL, '555', 33, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-17 00:35:27.000', NULL, NULL),
(117, 5, 1, 'in', NULL, '48', 'text', NULL, '1', 74, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-17 00:35:37.000', NULL, NULL),
(118, 5, 1, 'out', 1, '49', 'media', NULL, '555', NULL, NULL, NULL, NULL, 'sent', NULL, NULL, 1, '2026-09-17 00:36:45.778', NULL, NULL),
(119, 5, 1, 'in', NULL, '50', 'text', NULL, '33', NULL, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-17 00:54:44.000', NULL, NULL),
(120, 5, 1, 'in', NULL, '51', 'contact', NULL, 'Сергій М. 🇺🇦 +380687207605', 30, NULL, NULL, NULL, 'delivered', NULL, NULL, 0, '2026-09-17 11:38:53.000', NULL, NULL);

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
(4, 1, 0, 112, '2026-09-17 00:14:07'),
(5, 1, 0, 120, '2026-09-17 14:28:38');

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

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_currencies`
--

CREATE TABLE `8ydnb966_currencies` (
  `id` smallint UNSIGNED NOT NULL COMMENT 'PK',
  `iso` char(3) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ISO 4217: UAH, USD, EUR, PLN...',
  `symbol` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Символ: ₴, $, €',
  `symbol_pos` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = перед сумою, 1 = після',
  `rate` decimal(18,6) NOT NULL DEFAULT '1.000000' COMMENT 'Курс відносно базової валюти',
  `rate_updated` datetime DEFAULT NULL COMMENT 'Коли оновлено курс',
  `is_base` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = базова валюта системи',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Довідник валют';

--
-- Дамп даних таблиці `8ydnb966_currencies`
--

INSERT INTO `8ydnb966_currencies` (`id`, `iso`, `symbol`, `symbol_pos`, `rate`, `rate_updated`, `is_base`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 'UAH', '₴', 0, 1.000000, NULL, 1, 1, 1, '2026-05-28 22:57:02', '2026-05-28 22:57:02'),
(2, 'USD', '$', 0, 0.024000, NULL, 0, 1, 2, '2026-05-28 22:57:02', '2026-05-28 22:57:02'),
(3, 'EUR', '€', 0, 0.022000, NULL, 0, 1, 3, '2026-05-28 22:57:02', '2026-05-28 22:57:02'),
(4, 'PLN', 'zł', 1, 0.098000, NULL, 0, 1, 4, '2026-05-28 22:57:02', '2026-05-28 22:57:02'),
(5, 'GBP', '£', 0, 0.019000, NULL, 0, 1, 5, '2026-05-28 22:57:02', '2026-05-28 22:57:02');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_currencies_lang`
--

CREATE TABLE `8ydnb966_currencies_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_currency` smallint UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Українська гривня / US Dollar...'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_currencies_lang`
--

INSERT INTO `8ydnb966_currencies_lang` (`id`, `id_currency`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Українська гривня'),
(2, 1, 2, 'Ukrainian Hryvnia'),
(3, 2, 1, 'Долар США'),
(4, 2, 2, 'US Dollar'),
(5, 3, 1, 'Євро'),
(6, 3, 2, 'Euro'),
(7, 4, 1, 'Польський злотий'),
(8, 4, 2, 'Polish Zloty'),
(9, 5, 1, 'Британський фунт'),
(10, 5, 2, 'British Pound');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customers`
--

CREATE TABLE `8ydnb966_customers` (
  `id` int UNSIGNED NOT NULL,
  `uid` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'CUST-4521',
  `external_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `external_source` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'prestashop, website, import',
  `type` enum('individual','company') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'individual',
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `middle_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` enum('male','female','other') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `age` tinyint UNSIGNED DEFAULT NULL COMMENT 'денормалізовано, оновлює крон/тригер',
  `language` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'uk',
  `timezone` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Europe/Kyiv',
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH',
  `preferred_contact` enum('phone','email','telegram','viber','whatsapp') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `preferred_contact_time` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `do_not_call` tinyint(1) NOT NULL DEFAULT '0',
  `do_not_email` tinyint(1) NOT NULL DEFAULT '0',
  `do_not_sms` tinyint(1) NOT NULL DEFAULT '0',
  `source` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'instagram, google, referral',
  `referral_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'власний реф. код клієнта',
  `referred_by_id` int UNSIGNED DEFAULT NULL,
  `segment` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_discipline` enum('good','average','bad') COLLATE utf8mb4_unicode_ci DEFAULT 'good',
  `credit_limit` decimal(12,2) NOT NULL DEFAULT '0.00',
  `blacklisted` tinyint(1) NOT NULL DEFAULT '0',
  `blacklist_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `blacklisted_at` datetime DEFAULT NULL,
  `is_new` tinyint(1) NOT NULL DEFAULT '1',
  `lead_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deal_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quote_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `assigned_to` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `social_telegram` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `social_instagram` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `social_viber` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `social_whatsapp` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `social_facebook` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `social_tiktok` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pref_delivery_method` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pref_delivery_warehouse` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pref_delivery_city` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `tags` json DEFAULT NULL COMMENT '["vip","wholesale"]',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL COMMENT 'soft delete'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customers`
--

INSERT INTO `8ydnb966_customers` (`id`, `uid`, `external_id`, `external_source`, `type`, `first_name`, `last_name`, `middle_name`, `gender`, `birthday`, `age`, `language`, `timezone`, `currency`, `preferred_contact`, `preferred_contact_time`, `do_not_call`, `do_not_email`, `do_not_sms`, `source`, `referral_code`, `referred_by_id`, `segment`, `payment_discipline`, `credit_limit`, `blacklisted`, `blacklist_reason`, `blacklisted_at`, `is_new`, `lead_id`, `deal_id`, `quote_id`, `assigned_to`, `social_telegram`, `social_instagram`, `social_viber`, `social_whatsapp`, `social_facebook`, `social_tiktok`, `pref_delivery_method`, `pref_delivery_warehouse`, `pref_delivery_city`, `notes`, `tags`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'CUST-0001', '54321', 'prestashop', 'individual', 'Сергій', 'Мотчаний', 'Сергійович', 'male', NULL, 35, 'en', 'Europe/Kyiv', 'UAH', 'phone', 'afternoon', 0, 0, 0, 'website', 'REF-MOT01', NULL, 'vip', 'good', 10000.00, 0, NULL, NULL, 0, NULL, NULL, NULL, 'manager_007', '@motchanyy', 'motchanyy', '+380687207605', '+380687207605', 'motchanyy.fb', NULL, 'nova_poshta', '5', 'Кривий Ріг', 'Адмін системи. Дзвонити після 14:00.', '[\"admin\", \"vip\"]', '2025-06-10 09:00:00', '2026-05-19 04:08:30', NULL),
(2, 'CUST-0002', NULL, NULL, 'individual', 'Марія', 'Шевченко', 'Олексіївна', 'female', NULL, 30, 'uk', 'Europe/Kyiv', 'UAH', 'email', 'morning', 0, 0, 0, 'google', 'REF-SHE02', NULL, 'retail', 'good', 0.00, 0, NULL, NULL, 1, NULL, NULL, NULL, 'manager_003', NULL, 'masha_shevchenko', NULL, '+380931234567', NULL, NULL, 'nova_poshta', NULL, 'Харків', 'Перше замовлення. Цікавиться акціями.', '[\"new_customer\"]', '2026-04-15 10:30:00', '2026-05-19 02:52:27', NULL),
(3, 'CUST-0003', '99001', 'prestashop', 'company', 'Іван', 'Бондаренко', 'Петрович', 'male', '1978-11-05', 47, 'uk', 'Europe/Kyiv', 'UAH', 'phone', 'morning', 0, 1, 0, 'referral', 'REF-BON03', 1, 'bulk_buyer', 'good', 50000.00, 0, NULL, NULL, 0, NULL, NULL, NULL, 'manager_007', '@bondarenko_iv', NULL, '+380501111222', '+380501111222', NULL, NULL, 'nova_poshta', NULL, 'Дніпро', 'Оптові закупки щоквартально. Потрібен рахунок-фактура.', '[\"wholesale\", \"b2b\"]', '2024-03-20 08:00:00', '2026-03-01 12:00:00', NULL),
(4, 'CUST-0004', NULL, NULL, 'individual', 'Олена', 'Ткаченко', 'Василівна', 'female', '1988-02-14', 38, 'uk', 'Europe/Kyiv', 'UAH', '', 'evening', 0, 1, 0, 'facebook', NULL, NULL, 'retail', 'average', 0.00, 0, NULL, NULL, 0, NULL, NULL, NULL, 'manager_003', NULL, NULL, '+380661234567', NULL, NULL, NULL, 'ukrposhta', NULL, 'Одеса', 'Давно не купувала. Спробувати реактивацію.', '[\"at_risk\"]', '2023-09-01 14:00:00', '2025-11-20 09:00:00', NULL),
(5, 'CUST-0005', NULL, NULL, 'individual', 'Дмитро', 'Мельник', 'Андрійович', 'male', '1982-06-30', 43, 'uk', 'Europe/Kyiv', 'UAH', 'phone', NULL, 1, 1, 1, 'website', NULL, NULL, 'retail', 'bad', 0.00, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Повернення без причини двічі. Не обслуговувати.', '[]', '2023-01-15 10:00:00', '2024-06-01 10:00:00', NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customers_groups`
--

CREATE TABLE `8ydnb966_customers_groups` (
  `id` int UNSIGNED NOT NULL,
  `color_text` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#000000',
  `color_background` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `icon` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customers_groups`
--

INSERT INTO `8ydnb966_customers_groups` (`id`, `color_text`, `color_background`, `icon`, `sort`, `active`, `date_add`, `date_edit`) VALUES
(1, '#ffffff', '#999999', '', 1, 1, '2026-05-19 01:13:41', '2026-05-19 01:13:41'),
(2, '#ffffff', '#FFD700', '', 2, 1, '2026-05-19 01:13:41', '2026-05-19 01:13:41'),
(3, '#ffffff', '#FF8C00', '', 3, 1, '2026-05-19 01:13:41', '2026-05-19 01:13:41'),
(4, '#ffffff', '#dc3545', '🔥', 4, 1, '2026-05-19 01:14:28', '2026-05-19 01:14:28');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customers_groups_lang`
--

CREATE TABLE `8ydnb966_customers_groups_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_group` int UNSIGNED NOT NULL,
  `id_lang` int UNSIGNED NOT NULL,
  `text` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'назва групи цією мовою'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customers_groups_lang`
--

INSERT INTO `8ydnb966_customers_groups_lang` (`id`, `id_group`, `id_lang`, `text`) VALUES
(1, 1, 1, 'За замовчуванням'),
(2, 1, 2, 'Default'),
(3, 2, 1, 'VIP'),
(4, 2, 2, 'VIP'),
(5, 3, 1, 'Оптовий покупець'),
(6, 3, 2, 'Bulk Buyer'),
(7, 4, 1, 'Під загрозою'),
(8, 4, 2, 'At Risk');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customers_to_groups`
--

CREATE TABLE `8ydnb966_customers_to_groups` (
  `id` int UNSIGNED NOT NULL,
  `client_id` int UNSIGNED NOT NULL,
  `group_id` int UNSIGNED NOT NULL,
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customers_to_groups`
--

INSERT INTO `8ydnb966_customers_to_groups` (`id`, `client_id`, `group_id`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(2, 1, 2, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(3, 2, 1, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(4, 3, 1, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(5, 3, 3, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(6, 4, 1, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(7, 4, 4, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(8, 5, 1, '2026-05-19 01:14:28', '2026-05-19 01:14:28');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_addresses`
--

CREATE TABLE `8ydnb966_customer_addresses` (
  `id` int UNSIGNED NOT NULL,
  `customer_id` int UNSIGNED NOT NULL,
  `type` enum('billing','shipping','home','work','other') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'shipping',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `country` char(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UA',
  `region` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `district` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `street` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `building` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apartment` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recipient_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recipient_phone` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entrance` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `floor` tinyint DEFAULT NULL,
  `intercom_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `carrier` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'nova_poshta, ukrposhta, meest',
  `np_warehouse_ref` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'UUID відділення з API НП',
  `np_warehouse_num` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `np_warehouse_address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lat` decimal(10,7) DEFAULT NULL,
  `lon` decimal(10,7) DEFAULT NULL,
  `use_count` smallint UNSIGNED NOT NULL DEFAULT '0',
  `last_used_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customer_addresses`
--

INSERT INTO `8ydnb966_customer_addresses` (`id`, `customer_id`, `type`, `is_default`, `country`, `region`, `city`, `district`, `street`, `building`, `apartment`, `zip`, `recipient_name`, `recipient_phone`, `entrance`, `floor`, `intercom_code`, `carrier`, `np_warehouse_ref`, `np_warehouse_num`, `np_warehouse_address`, `lat`, `lon`, `use_count`, `last_used_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'home', 1, 'UA', 'Дніпропетровська обл.', 'Кривий Ріг', NULL, 'вул. Поштова', '12', '34', '50000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, '2026-05-18 10:30:00', '2026-05-19 01:14:28', '2026-05-19 01:14:28', NULL),
(2, 1, 'shipping', 0, 'UA', 'Київська обл.', 'Київ', NULL, 'вул. Хрещатик', '1', '5', '01001', 'Марія Коваленко', '+380671112233', NULL, NULL, NULL, 'nova_poshta', NULL, '12', NULL, NULL, NULL, 5, '2026-05-18 10:30:00', '2026-05-19 01:14:28', '2026-05-19 01:14:28', NULL),
(3, 2, 'shipping', 1, 'UA', 'Харківська обл.', 'Харків', NULL, NULL, NULL, NULL, '61000', NULL, NULL, NULL, NULL, NULL, 'nova_poshta', NULL, '7', NULL, NULL, NULL, 1, '2026-04-15 10:00:00', '2026-05-19 01:14:28', '2026-05-19 01:14:28', NULL),
(4, 3, 'work', 1, 'UA', 'Дніпропетровська обл.', 'Дніпро', NULL, 'пр. Яворницького', '100', '501', '49000', 'ТОВ Бондар-Трейд', '+380501111222', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10, '2026-03-01 12:00:00', '2026-05-19 01:14:28', '2026-05-19 01:14:28', NULL),
(5, 3, 'shipping', 0, 'UA', 'Дніпропетровська обл.', 'Дніпро', NULL, NULL, NULL, NULL, '49000', NULL, NULL, NULL, NULL, NULL, 'nova_poshta', NULL, '3', NULL, NULL, NULL, 8, '2026-03-01 12:00:00', '2026-05-19 01:14:28', '2026-05-19 01:14:28', NULL),
(6, 4, 'home', 1, 'UA', 'Одеська обл.', 'Одеса', NULL, 'вул. Дерибасівська', '5', '12', '65000', NULL, NULL, NULL, NULL, NULL, 'ukrposhta', NULL, NULL, NULL, NULL, NULL, 2, '2025-11-20 09:00:00', '2026-05-19 01:14:28', '2026-05-19 01:14:28', NULL),
(7, 5, 'home', 1, 'UA', 'Запорізька обл.', 'Запоріжжя', NULL, 'вул. Соборна', '3', '7', '69000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, '2026-05-19 01:14:28', '2026-05-19 01:14:28', NULL),
(8, 1, 'shipping', 1, 'UA', 'Дніпропетровська обл.', 'Кривий Ріг', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'nova_poshta', NULL, '5', NULL, NULL, NULL, 0, NULL, '2026-05-19 03:32:07', '2026-05-19 03:32:07', NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_addresses_lang`
--

CREATE TABLE `8ydnb966_customer_addresses_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_address` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Дача / Country house',
  `delivery_instructions` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customer_addresses_lang`
--

INSERT INTO `8ydnb966_customer_addresses_lang` (`id`, `id_address`, `id_lang`, `label`, `delivery_instructions`) VALUES
(1, 1, 1, 'Будинок', NULL),
(2, 1, 2, 'Home', NULL),
(3, 2, 1, 'НП Київ — дружина', 'Дзвонити за 1 год до доставки'),
(4, 2, 2, 'NP Kyiv — wife', 'Call 1 hour before delivery'),
(5, 4, 1, 'Офіс', 'Здавати на охорону, 1 поверх'),
(6, 4, 2, 'Office', 'Leave at security, 1st floor');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_analytics`
--

CREATE TABLE `8ydnb966_customer_analytics` (
  `id` int UNSIGNED NOT NULL,
  `customer_id` int UNSIGNED NOT NULL,
  `total_orders` smallint UNSIGNED NOT NULL DEFAULT '0',
  `total_spent` decimal(14,2) NOT NULL DEFAULT '0.00',
  `average_order_value` decimal(12,2) NOT NULL DEFAULT '0.00',
  `max_order_value` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_returned` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_cancelled` smallint UNSIGNED NOT NULL DEFAULT '0',
  `first_order_at` datetime DEFAULT NULL,
  `last_order_at` datetime DEFAULT NULL,
  `days_since_last_order` smallint DEFAULT NULL,
  `avg_days_between_orders` smallint DEFAULT NULL,
  `predicted_ltv` decimal(14,2) DEFAULT NULL,
  `repeat_probability` decimal(5,4) DEFAULT NULL COMMENT '0.0000 – 1.0000',
  `churn_risk` decimal(5,4) DEFAULT NULL,
  `churn_risk_level` enum('low','medium','high') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rfm_recency` tinyint DEFAULT NULL COMMENT '1–5',
  `rfm_frequency` tinyint DEFAULT NULL,
  `rfm_monetary` tinyint DEFAULT NULL,
  `rfm_score` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '555, 312',
  `rfm_segment` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Champions, At Risk, Lost',
  `top_categories` json DEFAULT NULL,
  `top_brands` json DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customer_analytics`
--

INSERT INTO `8ydnb966_customer_analytics` (`id`, `customer_id`, `total_orders`, `total_spent`, `average_order_value`, `max_order_value`, `total_returned`, `total_cancelled`, `first_order_at`, `last_order_at`, `days_since_last_order`, `avg_days_between_orders`, `predicted_ltv`, `repeat_probability`, `churn_risk`, `churn_risk_level`, `rfm_recency`, `rfm_frequency`, `rfm_monetary`, `rfm_score`, `rfm_segment`, `top_categories`, `top_brands`, `updated_at`) VALUES
(1, 1, 15, 120000.00, 8000.00, 15000.00, 2500.00, 1, '2025-06-10 09:00:00', '2026-05-01 14:00:00', 18, 30, 20000.00, 0.8500, 0.1000, 'low', 5, 5, 4, '555', 'Champions', '[\"Ноутбуки\", \"Аксесуари\"]', '[\"Dell\", \"Apple\"]', '2026-05-19 03:32:07'),
(2, 2, 1, 1200.00, 1200.00, 1200.00, 0.00, 0, '2026-04-15 10:30:00', '2026-04-15 10:30:00', 34, NULL, 3000.00, 0.3500, 0.2500, 'low', 3, 1, 1, '311', 'New Customers', '[\"Аксесуари\"]', '[\"Samsung\"]', '2026-05-19 01:14:28'),
(3, 3, 28, 450000.00, 16071.00, 80000.00, 5000.00, 0, '2024-03-20 08:00:00', '2026-03-01 12:00:00', 79, 25, 80000.00, 0.9100, 0.0800, 'low', 4, 5, 5, '455', 'Champions', '[\"Ноутбуки\", \"Сервери\", \"Мережеве обладнання\"]', '[\"Dell\", \"HP\", \"Cisco\"]', '2026-05-19 01:14:28'),
(4, 4, 4, 8500.00, 2125.00, 3200.00, 0.00, 2, '2023-09-01 14:00:00', '2025-11-20 09:00:00', 180, 90, 4000.00, 0.1800, 0.7800, 'high', 1, 2, 2, '122', 'At Risk', '[\"Планшети\", \"Телефони\"]', '[\"Xiaomi\"]', '2026-05-19 01:14:28'),
(5, 5, 2, 2200.00, 1100.00, 1500.00, 2200.00, 1, '2023-01-15 10:00:00', '2024-06-01 10:00:00', 352, 170, 0.00, 0.0500, 0.9500, 'high', 1, 1, 1, '111', 'Lost', '[\"Телефони\"]', '[\"Samsung\"]', '2026-05-19 01:14:28');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_companies`
--

CREATE TABLE `8ydnb966_customer_companies` (
  `id` int UNSIGNED NOT NULL,
  `customer_id` int UNSIGNED NOT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT '1',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `edrpou` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vat_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ІПН / номер ПДВ',
  `website` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_person` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `legal_address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bank_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bank_account` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IBAN UA...',
  `bank_mfo` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customer_companies`
--

INSERT INTO `8ydnb966_customer_companies` (`id`, `customer_id`, `is_primary`, `name`, `edrpou`, `vat_id`, `website`, `contact_person`, `position`, `legal_address`, `bank_name`, `bank_account`, `bank_mfo`, `notes`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'ТОВ Ромашка', '12345678', 'UA123456789', 'https://romashka.ua', 'Петренко Іван Сидорович', 'Генеральний директор', 'м. Кривий Ріг, вул. Поштова 12', 'АТ КБ ПриватБанк', 'UA213223260000026007123456789', NULL, NULL, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(2, 3, 1, 'ТОВ Бондар-Трейд', '87654321', 'UA987654321', 'https://bondar-trade.ua', 'Бондаренко Іван Петрович', 'Директор', 'м. Дніпро, пр. Яворницького 100, оф. 501', 'АТ Ощадбанк', 'UA903226690000026009876543210', NULL, NULL, '2026-05-19 01:14:28', '2026-05-19 01:14:28');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_consent`
--

CREATE TABLE `8ydnb966_customer_consent` (
  `id` int UNSIGNED NOT NULL,
  `customer_id` int UNSIGNED NOT NULL,
  `terms_accepted` tinyint(1) NOT NULL DEFAULT '0',
  `personal_data_processing` tinyint(1) NOT NULL DEFAULT '0',
  `marketing_emails` tinyint(1) NOT NULL DEFAULT '0',
  `marketing_sms` tinyint(1) NOT NULL DEFAULT '0',
  `marketing_push` tinyint(1) NOT NULL DEFAULT '0',
  `marketing_phone` tinyint(1) NOT NULL DEFAULT '0',
  `marketing_viber` tinyint(1) NOT NULL DEFAULT '0',
  `accepted_at` datetime DEFAULT NULL,
  `ip_address_at_consent` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `consent_source` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'website_checkout, call_center',
  `consent_version` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'версія документу політики',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customer_consent`
--

INSERT INTO `8ydnb966_customer_consent` (`id`, `customer_id`, `terms_accepted`, `personal_data_processing`, `marketing_emails`, `marketing_sms`, `marketing_push`, `marketing_phone`, `marketing_viber`, `accepted_at`, `ip_address_at_consent`, `consent_source`, `consent_version`, `updated_at`) VALUES
(1, 1, 1, 1, 1, 1, 0, 1, 1, '2025-06-10 09:00:00', '192.168.1.1', 'website_checkout', 'v1.2', '2026-05-19 03:32:07'),
(2, 2, 1, 1, 1, 1, 1, 0, 0, '2026-04-15 10:30:00', '10.0.0.55', 'website_checkout', 'v1.3', '2026-05-19 01:14:28'),
(3, 3, 1, 1, 0, 0, 0, 1, 0, '2024-03-20 08:00:00', '172.16.0.10', 'call_center', 'v1.1', '2026-05-19 01:14:28'),
(4, 4, 1, 1, 0, 0, 0, 0, 0, '2023-09-01 14:00:00', '192.168.5.22', 'website_checkout', 'v1.0', '2026-05-19 01:14:28'),
(5, 5, 1, 1, 0, 0, 0, 0, 0, '2023-01-15 10:00:00', '192.168.9.99', 'website_checkout', 'v1.0', '2026-05-19 01:14:28');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_consent_log`
--

CREATE TABLE `8ydnb966_customer_consent_log` (
  `id` int UNSIGNED NOT NULL,
  `customer_id` int UNSIGNED NOT NULL,
  `field` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'marketing_emails, marketing_sms...',
  `old_value` tinyint(1) DEFAULT NULL,
  `new_value` tinyint(1) NOT NULL,
  `changed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `changed_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'customer, manager_007, system',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_contacts`
--

CREATE TABLE `8ydnb966_customer_contacts` (
  `id` int UNSIGNED NOT NULL,
  `customer_id` int UNSIGNED NOT NULL,
  `type` enum('phone','email','fax','other') COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '+380671234567 або user@mail.com',
  `id_label` smallint UNSIGNED DEFAULT NULL COMMENT 'FK → 8ydnb966_contact_label_dict',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  `is_verified` tinyint(1) NOT NULL DEFAULT '0',
  `verified_at` datetime DEFAULT NULL,
  `do_not_use` tinyint(1) NOT NULL DEFAULT '0',
  `note` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customer_contacts`
--

INSERT INTO `8ydnb966_customer_contacts` (`id`, `customer_id`, `type`, `value`, `id_label`, `is_primary`, `is_verified`, `verified_at`, `do_not_use`, `note`, `created_at`, `updated_at`) VALUES
(1, 1, 'phone', '+380671234567', 3, 0, 1, '2025-06-10 09:05:00', 0, NULL, '2026-05-19 01:14:28', '2026-05-19 15:37:57'),
(2, 1, 'phone', '+380501234567', 4, 0, 0, NULL, 0, NULL, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(3, 1, 'email', 'kovalenko@example.com', NULL, 0, 1, '2025-06-10 09:05:00', 0, NULL, '2026-05-19 01:14:28', '2026-05-19 15:37:57'),
(4, 2, 'phone', '+380931234567', 3, 1, 1, '2026-04-15 10:35:00', 0, NULL, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(5, 2, 'email', 'masha@example.com', NULL, 1, 1, '2026-04-15 10:35:00', 0, NULL, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(6, 3, 'phone', '+380501111222', 1, 1, 1, '2024-03-20 08:05:00', 0, NULL, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(7, 3, 'phone', '+380671111333', 5, 0, 0, NULL, 0, NULL, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(8, 3, 'email', 'bondarenko@firma.ua', 1, 1, 1, '2024-03-20 08:05:00', 0, NULL, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(9, 3, 'email', 'buh@firma.ua', 5, 0, 0, NULL, 0, NULL, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(10, 4, 'phone', '+380661234567', 3, 1, 1, '2023-09-01 14:05:00', 0, NULL, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(11, 4, 'email', 'tkachenko@mail.ua', NULL, 1, 0, NULL, 0, NULL, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(12, 5, 'phone', '+380991234567', 3, 1, 0, NULL, 0, NULL, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(13, 5, 'email', 'melnyk@mail.ua', NULL, 1, 0, NULL, 0, NULL, '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(14, 1, 'phone', '+380687207605', 3, 1, 1, '2026-05-19 03:32:07', 0, NULL, '2026-05-19 03:32:07', '2026-05-19 03:32:07'),
(15, 1, 'email', 'motchanyy@gmail.com', NULL, 1, 1, '2026-05-19 03:32:07', 0, NULL, '2026-05-19 03:32:07', '2026-05-19 03:32:07');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_custom_fields`
--

CREATE TABLE `8ydnb966_customer_custom_fields` (
  `id` int UNSIGNED NOT NULL,
  `customer_id` int UNSIGNED NOT NULL,
  `id_field_def` smallint UNSIGNED NOT NULL,
  `field_value` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customer_custom_fields`
--

INSERT INTO `8ydnb966_customer_custom_fields` (`id`, `customer_id`, `id_field_def`, `field_value`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'afternoon', '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(2, 1, 3, '1', '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(3, 2, 1, 'morning', '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(4, 3, 1, 'morning', '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(5, 3, 2, 'Tesla Model 3', '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(6, 3, 3, '0', '2026-05-19 01:14:28', '2026-05-19 01:14:28'),
(7, 4, 1, 'evening', '2026-05-19 01:14:28', '2026-05-19 01:14:28');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_custom_field_defs`
--

CREATE TABLE `8ydnb966_customer_custom_field_defs` (
  `id` smallint UNSIGNED NOT NULL,
  `field_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'системний ключ: preferred_contact_time',
  `field_type` enum('text','number','date','boolean','select','multiselect','url') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'text',
  `is_required` tinyint(1) NOT NULL DEFAULT '0',
  `is_visible` tinyint(1) NOT NULL DEFAULT '1',
  `sort` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customer_custom_field_defs`
--

INSERT INTO `8ydnb966_customer_custom_field_defs` (`id`, `field_key`, `field_type`, `is_required`, `is_visible`, `sort`, `active`, `created_at`) VALUES
(1, 'preferred_contact_time', 'select', 0, 1, 1, 1, '2026-05-19 01:13:45'),
(2, 'car_brand', 'text', 0, 1, 2, 1, '2026-05-19 01:13:45'),
(3, 'installation_required', 'boolean', 0, 1, 3, 1, '2026-05-19 01:13:45');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_custom_field_defs_lang`
--

CREATE TABLE `8ydnb966_customer_custom_field_defs_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_field_def` smallint UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Зручний час дзвінка',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `placeholder` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customer_custom_field_defs_lang`
--

INSERT INTO `8ydnb966_customer_custom_field_defs_lang` (`id`, `id_field_def`, `id_lang`, `name`, `description`, `placeholder`) VALUES
(1, 1, 1, 'Зручний час дзвінка', '', 'напр. вранці'),
(2, 1, 2, 'Preferred Call Time', '', 'e.g. morning'),
(3, 2, 1, 'Марка автомобіля', '', 'напр. Toyota'),
(4, 2, 2, 'Car Brand', '', 'e.g. Toyota'),
(5, 3, 1, 'Потрібна установка', '', ''),
(6, 3, 2, 'Installation Required', '', '');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_loyalty`
--

CREATE TABLE `8ydnb966_customer_loyalty` (
  `id` int UNSIGNED NOT NULL,
  `customer_id` int UNSIGNED NOT NULL,
  `id_level` smallint UNSIGNED DEFAULT NULL COMMENT 'FK → loyalty_levels_dict',
  `id_next_level` smallint UNSIGNED DEFAULT NULL,
  `points_balance` int NOT NULL DEFAULT '0',
  `points_earned_total` int NOT NULL DEFAULT '0',
  `points_spent_total` int NOT NULL DEFAULT '0',
  `points_expired_total` int NOT NULL DEFAULT '0',
  `points_to_next_level` int DEFAULT NULL,
  `level_achieved_at` datetime DEFAULT NULL,
  `level_expires_at` datetime DEFAULT NULL,
  `cashback_balance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cashback_earned_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `cashback_spent_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customer_loyalty`
--

INSERT INTO `8ydnb966_customer_loyalty` (`id`, `customer_id`, `id_level`, `id_next_level`, `points_balance`, `points_earned_total`, `points_spent_total`, `points_expired_total`, `points_to_next_level`, `level_achieved_at`, `level_expires_at`, `cashback_balance`, `cashback_earned_total`, `cashback_spent_total`, `updated_at`) VALUES
(1, 1, 3, 4, 750, 2000, 1250, 0, 250, '2026-01-15 00:00:00', NULL, 150.00, 350.00, 420.00, '2026-05-19 03:32:07'),
(2, 2, 1, 2, 50, 50, 0, 0, 450, '2026-04-15 10:30:00', NULL, 0.00, 5.00, 0.00, '2026-05-19 01:14:28'),
(3, 3, 4, NULL, 800, 8000, 7000, 200, NULL, '2025-06-01 00:00:00', NULL, 320.00, 2000.00, 1680.00, '2026-05-19 01:14:28'),
(4, 4, 1, 2, 10, 200, 190, 0, 490, '2023-09-01 14:00:00', NULL, 0.00, 20.00, 20.00, '2026-05-19 01:14:28'),
(5, 5, 1, 2, 0, 30, 0, 30, 500, '2023-01-15 10:00:00', NULL, 0.00, 3.00, 0.00, '2026-05-19 01:14:28');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_loyalty_levels_dict`
--

CREATE TABLE `8ydnb966_customer_loyalty_levels_dict` (
  `id` smallint UNSIGNED NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'bronze, silver, gold, platinum',
  `color` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `points_required` int UNSIGNED NOT NULL DEFAULT '0' COMMENT 'мін. балів для рівня',
  `sort` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customer_loyalty_levels_dict`
--

INSERT INTO `8ydnb966_customer_loyalty_levels_dict` (`id`, `code`, `color`, `points_required`, `sort`, `active`) VALUES
(1, 'bronze', '#CD7F32', 0, 1, 1),
(2, 'silver', '#C0C0C0', 500, 2, 1),
(3, 'gold', '#FFD700', 1500, 3, 1),
(4, 'platinum', '#E5E4E2', 5000, 4, 1);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_loyalty_levels_dict_lang`
--

CREATE TABLE `8ydnb966_customer_loyalty_levels_dict_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_level` smallint UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customer_loyalty_levels_dict_lang`
--

INSERT INTO `8ydnb966_customer_loyalty_levels_dict_lang` (`id`, `id_level`, `id_lang`, `name`, `description`) VALUES
(1, 1, 1, 'Бронза', 'Початковий рівень'),
(2, 1, 2, 'Bronze', 'Entry level'),
(3, 2, 1, 'Срібло', 'Постійний клієнт'),
(4, 2, 2, 'Silver', 'Regular customer'),
(5, 3, 1, 'Золото', 'Преміум клієнт'),
(6, 3, 2, 'Gold', 'Premium customer'),
(7, 4, 1, 'Платина', 'Найвищий рівень'),
(8, 4, 2, 'Platinum', 'Top tier customer');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_loyalty_log`
--

CREATE TABLE `8ydnb966_customer_loyalty_log` (
  `id` int UNSIGNED NOT NULL,
  `customer_id` int UNSIGNED NOT NULL,
  `type` enum('earn','spend','expire','adjust','refund','cashback_earn','cashback_spend') COLLATE utf8mb4_unicode_ci NOT NULL,
  `points` int NOT NULL DEFAULT '0',
  `cashback` decimal(10,2) NOT NULL DEFAULT '0.00',
  `balance_after` int NOT NULL DEFAULT '0',
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ref_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'order, return, promo, manual',
  `ref_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ORD-2026-000123',
  `created_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customer_loyalty_log`
--

INSERT INTO `8ydnb966_customer_loyalty_log` (`id`, `customer_id`, `type`, `points`, `cashback`, `balance_after`, `reason`, `ref_type`, `ref_id`, `created_by`, `created_at`) VALUES
(1, 1, 'earn', 500, 0.00, 500, 'Замовлення ORD-2025-000010', 'order', 'ORD-2025-000010', 'system', '2026-05-19 01:14:28'),
(2, 1, 'earn', 700, 0.00, 1200, 'Замовлення ORD-2025-000045', 'order', 'ORD-2025-000045', 'system', '2026-05-19 01:14:28'),
(3, 1, 'spend', 800, 0.00, 400, 'Оплата балами ORD-2025-000080', 'order', 'ORD-2025-000080', 'system', '2026-05-19 01:14:28'),
(4, 1, 'earn', 300, 0.00, 700, 'Замовлення ORD-2026-000100', 'order', 'ORD-2026-000100', 'system', '2026-05-19 01:14:28'),
(5, 1, 'spend', 350, 0.00, 350, 'Оплата балами ORD-2026-000123', 'order', 'ORD-2026-000123', 'system', '2026-05-19 01:14:28'),
(6, 2, 'earn', 50, 0.00, 50, 'Замовлення ORD-2026-000200', 'order', 'ORD-2026-000200', 'system', '2026-05-19 01:14:28'),
(7, 3, 'earn', 5000, 0.00, 5000, 'Замовлення ORD-2025-000001', 'order', 'ORD-2025-000001', 'system', '2026-05-19 01:14:28'),
(8, 3, 'earn', 3000, 0.00, 8000, 'Замовлення ORD-2025-000030', 'order', 'ORD-2025-000030', 'system', '2026-05-19 01:14:28'),
(9, 3, 'spend', 7000, 0.00, 1000, 'Оплата балами ORD-2026-000050', 'order', 'ORD-2026-000050', 'system', '2026-05-19 01:14:28'),
(10, 3, 'expire', 200, 0.00, 800, 'Згорання балів (термін вийшов)', 'promo', NULL, 'system', '2026-05-19 01:14:28'),
(11, 4, 'earn', 200, 0.00, 200, 'Замовлення ORD-2023-000300', 'order', 'ORD-2023-000300', 'system', '2026-05-19 01:14:28'),
(12, 4, 'spend', 190, 0.00, 10, 'Оплата балами ORD-2024-000010', 'order', 'ORD-2024-000010', 'system', '2026-05-19 01:14:28');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_merge_log`
--

CREATE TABLE `8ydnb966_customer_merge_log` (
  `id` int UNSIGNED NOT NULL,
  `master_id` int UNSIGNED NOT NULL COMMENT 'клієнт що залишився',
  `merged_id` int UNSIGNED NOT NULL COMMENT 'клієнт що поглинутий',
  `merged_uid` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'зберігаємо uid для аудиту',
  `merged_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `merged_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_customer_notes`
--

CREATE TABLE `8ydnb966_customer_notes` (
  `id` int UNSIGNED NOT NULL,
  `customer_id` int UNSIGNED NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_pinned` tinyint(1) NOT NULL DEFAULT '0',
  `visibility` enum('internal','team','public') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'internal',
  `author_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `author_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_customer_notes`
--

INSERT INTO `8ydnb966_customer_notes` (`id`, `customer_id`, `body`, `is_pinned`, `visibility`, `author_id`, `author_name`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Клієнт VIP. Завжди уточнює наявність матового екрану. Дзвонити після 14:00.', 1, 'internal', 'manager_007', 'Іван Петров', '2026-05-19 01:14:28', '2026-05-19 01:14:28', NULL),
(2, 1, 'Зробив повторне замовлення після акції \"Весна 2026\". Лояльний.', 0, 'internal', 'manager_007', 'Іван Петров', '2026-05-19 01:14:28', '2026-05-19 01:14:28', NULL),
(3, 2, 'Перший клієнт. Прийшла з Google. Цікавилась гарантією.', 1, 'internal', 'manager_003', 'Оксана Лисенко', '2026-05-19 01:14:28', '2026-05-19 01:14:28', NULL),
(4, 3, 'Оптовий клієнт. Закупки Q1/Q2/Q3/Q4. Потрібен оригінальний рахунок-фактура.', 1, 'internal', 'manager_007', 'Іван Петров', '2026-05-19 01:14:28', '2026-05-19 01:14:28', NULL),
(5, 3, 'Просив знижку 5% на наступне замовлення від 100к. Погоджено з директором.', 0, 'team', 'manager_007', 'Іван Петров', '2026-05-19 01:14:28', '2026-05-19 01:14:28', NULL),
(6, 4, 'Клієнт не купував 6+ місяців. Спробувати реактивацію через SMS.', 1, 'internal', 'manager_003', 'Оксана Лисенко', '2026-05-19 01:14:28', '2026-05-19 01:14:28', NULL),
(7, 5, 'ЗАБЛОКОВАНИЙ. Два повернення без обґрунтованої причини. Не обслуговувати.', 1, 'team', 'manager_001', 'Адміністратор', '2026-05-19 01:14:28', '2026-05-19 01:14:28', NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals`
--

CREATE TABLE `8ydnb966_deals` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_pipeline` int UNSIGNED NOT NULL COMMENT 'FK → deals_pipeline',
  `id_stage` int UNSIGNED NOT NULL COMMENT 'FK → deals_stage',
  `id_stage_prev` int UNSIGNED DEFAULT NULL COMMENT 'Попередня стадія',
  `id_deal_type` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_type',
  `id_source` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_source',
  `id_lost_reason` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_lost_reason',
  `id_company` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies',
  `id_contact` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts',
  `id_lead` int UNSIGNED DEFAULT NULL COMMENT 'FK → leads',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users (менеджер)',
  `id_user_creator` int UNSIGNED DEFAULT NULL COMMENT 'FK → users (хто створив)',
  `id_team` int UNSIGNED DEFAULT NULL COMMENT 'FK → teams',
  `title` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Назва угоди',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'Опис',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Внутрішні нотатки',
  `amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Сума угоди',
  `amount_gross` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Сума до знижки (price * qty з позицій)',
  `amount_currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH' COMMENT 'Валюта',
  `amount_base` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Сума в базовій валюті',
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'Знижка',
  `discount_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=%, 1=фікс.сума',
  `discount_amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Загальна сума знижки (авто з позицій)',
  `tax_amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Сума ПДВ',
  `amount_final` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Фінальна сума',
  `probability` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Ймовірність %',
  `probability_override` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = менеджер змінив вручну, 0 = автоматично від стадії',
  `amount_weighted` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Зважена сума (amount * probability/100)',
  `margin_amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Маржа (amount - cost_price * qty)',
  `margin_percent` decimal(6,2) NOT NULL DEFAULT '0.00' COMMENT 'Маржа %',
  `forecast_category` enum('pipeline','best_case','commit','closed','omitted') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pipeline' COMMENT 'Категорія прогнозу',
  `date_close_plan` date DEFAULT NULL COMMENT 'Планова дата закриття',
  `date_close_fact` date DEFAULT NULL COMMENT 'Фактична дата закриття',
  `date_next_action` datetime DEFAULT NULL COMMENT 'Дата наступної дії',
  `date_stage_changed` datetime DEFAULT NULL COMMENT 'Коли змінилась стадія',
  `id_competitor` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies (конкурент)',
  `competitor_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Конкурент вручну',
  `deal_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Номер угоди (авто)',
  `external_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ID в ERP/1С',
  `is_rotting` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = угода протухає',
  `rotting_days` smallint NOT NULL DEFAULT '0' COMMENT 'Днів без активності',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Головна таблиця угод CRM';

--
-- Дамп даних таблиці `8ydnb966_deals`
--

INSERT INTO `8ydnb966_deals` (`id`, `id_pipeline`, `id_stage`, `id_stage_prev`, `id_deal_type`, `id_source`, `id_lost_reason`, `id_company`, `id_contact`, `id_lead`, `id_user`, `id_user_creator`, `id_team`, `title`, `description`, `notes`, `amount`, `amount_gross`, `amount_currency`, `amount_base`, `discount`, `discount_type`, `discount_amount`, `tax_amount`, `amount_final`, `probability`, `probability_override`, `amount_weighted`, `margin_amount`, `margin_percent`, `forecast_category`, `date_close_plan`, `date_close_fact`, `date_next_action`, `date_stage_changed`, `id_competitor`, `competitor_name`, `deal_number`, `external_id`, `is_rotting`, `rotting_days`, `active`, `date_add`, `date_edit`) VALUES
(1, 1, 2, 1, 1, 1, NULL, 1, 1, NULL, 1, 1, 1, 'Постачання обладнання Q3 2026', 'Клієнт зацікавлений у закупівлі промислового обладнання для нового цеху. Бюджет підтверджено. Технічне завдання узгоджено.', 'Ключовий контакт — Іванов В.П. Рішення приймається колегіально. Конкурент — ТОВ \"Бета\" подав нижчу ціну.', 900.00, 1000.00, 'UAH', 485000.00, 5.00, 0, 100.00, 0.00, 900.00, 25, 0, 225.00, 830.00, 92.22, 'best_case', '2026-07-31', NULL, '2026-05-31 20:05:35', '2026-05-30 15:58:36', 5, 'ТОВ \"Бета Індастріал\"', 'УГ-2026-0001', 'ERP-20260528-001', 0, 3, 1, '2026-05-28 20:05:35', '2026-05-30 15:58:36'),
(2, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9, 9, NULL, 'Нова угода', NULL, NULL, 0.00, 0.00, 'UAH', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 10, 0, 0.00, 0.00, 0.00, 'pipeline', NULL, NULL, NULL, NULL, NULL, NULL, 'УГ-2026-0002', NULL, 0, 0, 1, '2026-06-21 20:06:20', '2026-06-21 20:06:20'),
(3, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, 'Нова угода', NULL, NULL, 0.00, 0.00, 'UAH', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 10, 0, 0.00, 0.00, 0.00, 'pipeline', NULL, NULL, NULL, NULL, NULL, NULL, 'УГ-2026-0003', NULL, 0, 0, 1, '2026-08-14 14:36:22', '2026-08-14 14:36:22'),
(4, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, NULL, 'Нова угода', NULL, NULL, 0.00, 0.00, 'UAH', 0.00, 0.00, 0, 0.00, 0.00, 0.00, 10, 0, 0.00, 0.00, 0.00, 'pipeline', NULL, NULL, NULL, NULL, NULL, NULL, 'УГ-2026-0004', NULL, 0, 0, 1, '2026-09-03 12:40:14', '2026-09-03 12:40:14');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_act`
--

CREATE TABLE `8ydnb966_deals_act` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_deal` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals',
  `id_contract` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_contract',
  `id_invoice` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_invoice',
  `id_company` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies',
  `id_contact` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts',
  `id_act_status` int UNSIGNED NOT NULL COMMENT 'FK → deals_act_status',
  `id_user` int UNSIGNED DEFAULT NULL,
  `act_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Номер: АКТ-2026-0001',
  `date_act` date NOT NULL,
  `date_signed` date DEFAULT NULL,
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH',
  `amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `tax_amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `amount_total` decimal(18,2) NOT NULL DEFAULT '0.00',
  `subject` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `file_pdf` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Акти виконаних робіт';

--
-- Дамп даних таблиці `8ydnb966_deals_act`
--

INSERT INTO `8ydnb966_deals_act` (`id`, `id_deal`, `id_contract`, `id_invoice`, `id_company`, `id_contact`, `id_act_status`, `id_user`, `act_number`, `date_act`, `date_signed`, `currency`, `amount`, `tax_amount`, `amount_total`, `subject`, `notes`, `file_pdf`, `active`, `date_add`, `date_edit`) VALUES
(1, 1, 1, NULL, 1, 1, 1, 1, 'АКТ-2026-0001', '2026-06-11', NULL, 'UAH', 43200.00, 8640.00, 51840.00, 'Акт виконаних робіт з монтажу та підключення промислового компресора KMB-500 (3 шт.)', 'Акт буде підписано після завершення монтажу 07.08.2026', NULL, 1, '2026-05-28 20:05:35', '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_activity`
--

CREATE TABLE `8ydnb966_deals_activity` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_activity_type` int UNSIGNED NOT NULL COMMENT 'FK → deals_activity_type',
  `id_outcome` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_activity_outcome',
  `id_deal` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals',
  `id_company` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies',
  `id_contact` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users (відповідальний)',
  `id_user_creator` int UNSIGNED DEFAULT NULL COMMENT 'FK → users (хто створив)',
  `subject` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `result` text COLLATE utf8mb4_unicode_ci,
  `next_step` text COLLATE utf8mb4_unicode_ci,
  `date_plan` datetime NOT NULL,
  `date_start` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `duration_minutes` smallint UNSIGNED DEFAULT NULL,
  `timezone` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `location_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Zoom/Meet посилання',
  `reminder` tinyint(1) NOT NULL DEFAULT '0',
  `reminder_minutes` smallint UNSIGNED DEFAULT NULL,
  `reminder_sent` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('planned','in_progress','done','canceled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'planned',
  `is_overdue` tinyint(1) NOT NULL DEFAULT '0',
  `priority` tinyint UNSIGNED NOT NULL DEFAULT '2' COMMENT '1=низький..4=критичний',
  `is_private` tinyint(1) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Активності угод (дзвінки, зустрічі, листи, нотатки...)';

--
-- Дамп даних таблиці `8ydnb966_deals_activity`
--

INSERT INTO `8ydnb966_deals_activity` (`id`, `id_activity_type`, `id_outcome`, `id_deal`, `id_company`, `id_contact`, `id_user`, `id_user_creator`, `subject`, `description`, `result`, `next_step`, `date_plan`, `date_start`, `date_end`, `duration_minutes`, `timezone`, `location`, `location_url`, `reminder`, `reminder_minutes`, `reminder_sent`, `status`, `is_overdue`, `priority`, `is_private`, `active`, `date_add`, `date_edit`) VALUES
(1, 2, 5, 1, 1, NULL, 1, 1, '123', 'Уточнити чи погодив технічний відділ специфікацію KMB-500. Якщо є зауваження — запропонувати зустріч.', NULL, NULL, '2026-06-06 20:00:00', '2026-05-27 20:05:35', '2026-05-27 21:05:35', NULL, 'Europe/Kyiv', NULL, NULL, 1, 30, 1, 'planned', 0, 3, 0, 1, '2026-05-28 20:05:35', '2026-05-30 03:31:26'),
(2, 1, 1, 1, NULL, NULL, 9, 9, '123', NULL, NULL, NULL, '2026-05-30 20:00:00', NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, 0, 'planned', 0, 2, 0, 1, '2026-05-29 01:39:39', '2026-05-29 01:39:39'),
(3, 3, 8, 1, NULL, NULL, 9, 9, 'asd', NULL, NULL, NULL, '2026-05-31 05:22:00', NULL, NULL, NULL, NULL, NULL, NULL, 1, 30, 0, 'planned', 0, 2, 0, 1, '2026-05-29 01:40:10', '2026-05-29 01:40:10');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_activity_outcome`
--

CREATE TABLE `8ydnb966_deals_activity_outcome` (
  `id` int UNSIGNED NOT NULL,
  `id_activity_type` int UNSIGNED DEFAULT NULL COMMENT 'NULL = для всіх типів',
  `color_background` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#e9ecef',
  `color_text` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#212529',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_activity_outcome`
--

INSERT INTO `8ydnb966_deals_activity_outcome` (`id`, `id_activity_type`, `color_background`, `color_text`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, '#d1e7dd', '#0a3622', 1, 1, '2026-05-28 19:50:22', '2026-05-28 19:50:22'),
(2, 1, '#f8d7da', '#58151c', 1, 2, '2026-05-28 19:50:22', '2026-05-28 19:50:22'),
(3, 1, '#fff3cd', '#664d03', 1, 3, '2026-05-28 19:50:22', '2026-05-28 19:50:22'),
(4, 1, '#e2d9f3', '#432874', 1, 4, '2026-05-28 19:50:22', '2026-05-28 19:50:22'),
(5, 2, '#d1e7dd', '#0a3622', 1, 1, '2026-05-28 19:50:22', '2026-05-28 19:50:22'),
(6, 2, '#f8d7da', '#58151c', 1, 2, '2026-05-28 19:50:22', '2026-05-28 19:50:22'),
(7, 2, '#fff3cd', '#664d03', 1, 3, '2026-05-28 19:50:22', '2026-05-28 19:50:22'),
(8, NULL, '#d1e7dd', '#0a3622', 1, 1, '2026-05-28 19:50:22', '2026-05-28 19:50:22'),
(9, NULL, '#f8d7da', '#58151c', 1, 2, '2026-05-28 19:50:22', '2026-05-28 19:50:22');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_activity_outcome_lang`
--

CREATE TABLE `8ydnb966_deals_activity_outcome_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_outcome` int UNSIGNED NOT NULL COMMENT 'FK → deals_activity_outcome',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_activity_outcome_lang`
--

INSERT INTO `8ydnb966_deals_activity_outcome_lang` (`id`, `id_outcome`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Додзвонився'),
(2, 1, 2, 'Reached'),
(3, 2, 1, 'Не додзвонився'),
(4, 2, 2, 'No Answer'),
(5, 3, 1, 'Зайнятий'),
(6, 3, 2, 'Busy'),
(7, 4, 1, 'Передзвонить сам'),
(8, 4, 2, 'Will Call Back'),
(9, 5, 1, 'Зустріч відбулась'),
(10, 5, 2, 'Meeting Held'),
(11, 6, 1, 'Перенесено'),
(12, 6, 2, 'Rescheduled'),
(13, 7, 1, 'Скасовано'),
(14, 7, 2, 'Canceled'),
(15, 8, 1, 'Виконано'),
(16, 8, 2, 'Completed'),
(17, 9, 1, 'Не виконано'),
(18, 9, 2, 'Not Completed');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_activity_participant`
--

CREATE TABLE `8ydnb966_deals_activity_participant` (
  `id` int UNSIGNED NOT NULL,
  `id_activity` int UNSIGNED NOT NULL COMMENT 'FK → deals_activity',
  `participant_type` enum('user','contact') COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_participant` int UNSIGNED NOT NULL,
  `status` enum('invited','accepted','declined','attended') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'invited',
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Учасники активностей';

--
-- Дамп даних таблиці `8ydnb966_deals_activity_participant`
--

INSERT INTO `8ydnb966_deals_activity_participant` (`id`, `id_activity`, `participant_type`, `id_participant`, `status`, `date_add`) VALUES
(1, 1, 'user', 1, 'attended', '2026-05-28 20:05:35'),
(2, 1, 'contact', 1, 'attended', '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_activity_type`
--

CREATE TABLE `8ydnb966_deals_activity_type` (
  `id` int UNSIGNED NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'call/meeting/email/note...',
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#007bff',
  `has_duration` tinyint(1) NOT NULL DEFAULT '0',
  `has_location` tinyint(1) NOT NULL DEFAULT '0',
  `has_outcome` tinyint(1) NOT NULL DEFAULT '1',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Типи активностей';

--
-- Дамп даних таблиці `8ydnb966_deals_activity_type`
--

INSERT INTO `8ydnb966_deals_activity_type` (`id`, `code`, `icon`, `color`, `has_duration`, `has_location`, `has_outcome`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 'call', 'fas fa-phone', '#28a745', 1, 0, 1, 1, 1, '2026-05-28 19:50:19', '2026-05-28 19:50:19'),
(2, 'meeting', 'fas fa-users', '#007bff', 1, 1, 1, 1, 2, '2026-05-28 19:50:19', '2026-05-28 19:50:19'),
(3, 'email', 'fas fa-envelope', '#6f42c1', 0, 0, 1, 1, 3, '2026-05-28 19:50:19', '2026-05-28 19:50:19'),
(4, 'note', 'fas fa-sticky-note', '#ffc107', 0, 0, 0, 1, 4, '2026-05-28 19:50:19', '2026-05-28 19:50:19'),
(5, 'task', 'fas fa-check-square', '#17a2b8', 0, 0, 1, 1, 5, '2026-05-28 19:50:19', '2026-05-28 19:50:19'),
(6, 'demo', 'fas fa-desktop', '#fd7e14', 1, 1, 1, 1, 6, '2026-05-28 19:50:19', '2026-05-28 19:50:19'),
(7, 'presentation', 'fas fa-file-powerpoint', '#e83e8c', 1, 1, 1, 1, 7, '2026-05-28 19:50:19', '2026-05-28 19:50:19'),
(8, 'whatsapp', 'fab fa-whatsapp', '#25d366', 0, 0, 1, 1, 8, '2026-05-28 19:50:19', '2026-05-28 19:50:19'),
(9, 'telegram', 'fab fa-telegram', '#2ca5e0', 0, 0, 1, 1, 9, '2026-05-28 19:50:19', '2026-05-28 19:50:19'),
(10, 'viber', 'fab fa-viber', '#7360f2', 0, 0, 1, 1, 10, '2026-05-28 19:50:19', '2026-05-28 19:50:19'),
(11, 'deadline', 'fas fa-flag', '#dc3545', 0, 0, 0, 1, 11, '2026-05-28 19:50:19', '2026-05-28 19:50:19'),
(12, 'document', 'fas fa-file-alt', '#6c757d', 0, 0, 0, 1, 12, '2026-05-28 19:50:19', '2026-05-28 19:50:19');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_activity_type_lang`
--

CREATE TABLE `8ydnb966_deals_activity_type_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_activity_type` int UNSIGNED NOT NULL COMMENT 'FK → deals_activity_type',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_activity_type_lang`
--

INSERT INTO `8ydnb966_deals_activity_type_lang` (`id`, `id_activity_type`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Дзвінок'),
(2, 1, 2, 'Call'),
(3, 2, 1, 'Зустріч'),
(4, 2, 2, 'Meeting'),
(5, 3, 1, 'Email'),
(6, 3, 2, 'Email'),
(7, 4, 1, 'Нотатка'),
(8, 4, 2, 'Note'),
(9, 5, 1, 'Завдання'),
(10, 5, 2, 'Task'),
(11, 6, 1, 'Демо'),
(12, 6, 2, 'Demo'),
(13, 7, 1, 'Презентація'),
(14, 7, 2, 'Presentation'),
(15, 8, 1, 'WhatsApp'),
(16, 8, 2, 'WhatsApp'),
(17, 9, 1, 'Telegram'),
(18, 9, 2, 'Telegram'),
(19, 10, 1, 'Viber'),
(20, 10, 2, 'Viber'),
(21, 11, 1, 'Дедлайн'),
(22, 11, 2, 'Deadline'),
(23, 12, 1, 'Документ'),
(24, 12, 2, 'Document');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_act_item`
--

CREATE TABLE `8ydnb966_deals_act_item` (
  `id` int UNSIGNED NOT NULL,
  `id_act` int UNSIGNED NOT NULL COMMENT 'FK → deals_act',
  `id_product` int UNSIGNED DEFAULT NULL COMMENT 'FK → зовнішня таблиця товарів',
  `id_unit` int UNSIGNED DEFAULT NULL,
  `name` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qty` decimal(10,3) NOT NULL DEFAULT '1.000',
  `price` decimal(18,2) NOT NULL DEFAULT '0.00',
  `tax_rate` decimal(6,2) NOT NULL DEFAULT '0.00',
  `tax_amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `amount_total` decimal(18,2) NOT NULL DEFAULT '0.00',
  `sort_order` int NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Позиції актів';

--
-- Дамп даних таблиці `8ydnb966_deals_act_item`
--

INSERT INTO `8ydnb966_deals_act_item` (`id`, `id_act`, `id_product`, `id_unit`, `name`, `qty`, `price`, `tax_rate`, `tax_amount`, `amount`, `amount_total`, `sort_order`, `active`, `date_add`, `date_edit`) VALUES
(1, 1, NULL, 4, 'Монтаж та підключення промислового компресора KMB-500', 24.000, 1800.00, 20.00, 8640.00, 43200.00, 51840.00, 1, 1, '2026-05-28 20:05:35', '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_act_status`
--

CREATE TABLE `8ydnb966_deals_act_status` (
  `id` int UNSIGNED NOT NULL,
  `color_background` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#000000',
  `color_text` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_act_status`
--

INSERT INTO `8ydnb966_deals_act_status` (`id`, `color_background`, `color_text`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, '#6c757d', '#ffffff', 1, 1, '2026-05-28 19:50:15', '2026-05-28 19:50:15'),
(2, '#007bff', '#ffffff', 1, 2, '2026-05-28 19:50:15', '2026-05-28 19:50:15'),
(3, '#28a745', '#ffffff', 1, 3, '2026-05-28 19:50:15', '2026-05-28 19:50:15'),
(4, '#dc3545', '#ffffff', 1, 4, '2026-05-28 19:50:15', '2026-05-28 19:50:15');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_act_status_lang`
--

CREATE TABLE `8ydnb966_deals_act_status_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_act_status` int UNSIGNED NOT NULL COMMENT 'FK → deals_act_status',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_act_status_lang`
--

INSERT INTO `8ydnb966_deals_act_status_lang` (`id`, `id_act_status`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Чернетка'),
(2, 1, 2, 'Draft'),
(3, 2, 1, 'Надіслано'),
(4, 2, 2, 'Sent'),
(5, 3, 1, 'Підписано'),
(6, 3, 2, 'Signed'),
(7, 4, 1, 'Оскаржено'),
(8, 4, 2, 'Disputed');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_audit_log`
--

CREATE TABLE `8ydnb966_deals_audit_log` (
  `id` bigint UNSIGNED NOT NULL,
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users',
  `user_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ім''я (знімок)',
  `user_ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entity_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'deal/quote/contract/invoice/act/activity/task',
  `id_entity` int UNSIGNED NOT NULL,
  `action` enum('create','update','delete','restore','view','export','stage_change','status_change') COLLATE utf8mb4_unicode_ci NOT NULL,
  `field_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value_old` text COLLATE utf8mb4_unicode_ci,
  `value_new` text COLLATE utf8mb4_unicode_ci,
  `description` text COLLATE utf8mb4_unicode_ci,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Журнал всіх змін угод (audit log)';

--
-- Дамп даних таблиці `8ydnb966_deals_audit_log`
--

INSERT INTO `8ydnb966_deals_audit_log` (`id`, `id_user`, `user_name`, `user_ip`, `entity_type`, `id_entity`, `action`, `field_name`, `value_old`, `value_new`, `description`, `date_add`) VALUES
(1, 1, 'Петренко Олег', '192.168.1.105', 'deal', 1, 'create', NULL, NULL, NULL, 'Угода створена', '2026-05-14 20:05:35'),
(2, 1, 'Петренко Олег', '192.168.1.105', 'deal', 1, 'stage_change', 'id_stage', '1', '2', 'Переведено: Новий → Кваліфікація', '2026-05-21 20:05:35'),
(3, 1, 'Петренко Олег', '192.168.1.105', 'deal', 1, 'stage_change', 'id_stage', '2', '3', 'Переведено: Кваліфікація → КП надіслано', '2026-05-28 20:05:35'),
(4, 1, 'Петренко Олег', '192.168.1.105', 'deal', 1, 'update', 'probability', '25', '50', 'Підвищено ймовірність після підтвердження бюджету', '2026-05-21 20:05:35'),
(5, 1, 'Петренко Олег', '192.168.1.105', 'quote', 1, 'create', NULL, NULL, NULL, 'КП-2026-0001 створено', '2026-05-28 20:05:35'),
(6, 1, 'Петренко Олег', '192.168.1.105', 'quote', 1, 'status_change', 'id_quote_status', '1', '2', 'КП надіслано клієнту', '2026-05-28 20:05:35'),
(7, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'create', NULL, NULL, NULL, 'Додано активність', '2026-05-29 01:39:39'),
(8, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'create', NULL, NULL, NULL, 'Додано активність', '2026-05-29 01:40:10'),
(9, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'stage_change', 'id_stage', '3', '1', NULL, '2026-05-29 02:15:05'),
(10, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'stage_change', 'id_stage', '1', '2', NULL, '2026-05-29 02:15:13'),
(11, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'stage_change', 'id_stage', '2', '3', NULL, '2026-05-29 02:15:17'),
(12, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'stage_change', 'id_stage', '3', '4', NULL, '2026-05-29 02:15:21'),
(13, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'stage_change', 'id_stage', '4', '5', NULL, '2026-05-29 02:15:25'),
(14, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'stage_change', 'id_stage', '5', '1', NULL, '2026-05-29 02:36:36'),
(15, 9, 'Demo Demo', NULL, 'deal', 1, 'stage_change', 'id_stage', '1', '1', NULL, '2026-05-29 02:36:37'),
(16, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'stage_change', 'id_stage', '1', '2', NULL, '2026-05-29 02:36:41'),
(17, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'stage_change', 'id_stage', '2', '1', NULL, '2026-05-29 02:36:44'),
(18, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'update', 'probability', '50', '80', 'Змінено вручну', '2026-05-30 15:53:41'),
(19, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'update', 'probability', '80', '76', 'Змінено вручну', '2026-05-30 15:54:02'),
(20, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'stage_change', 'id_stage', '1', '2', NULL, '2026-05-30 15:58:37'),
(21, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'update', 'probability', '76', '25', 'Автоматично від стадії', '2026-05-30 15:58:37'),
(22, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 1, 'update', 'custom_field_1', NULL, 'Тендер №ТН-2026-0089 111', 'Оновлено кастомне поле', '2026-06-02 03:20:19'),
(23, 9, 'Demo Demo', '::ffff:127.0.0.1', 'deal', 2, 'create', NULL, NULL, NULL, 'Угода створена', '2026-06-21 20:06:20'),
(24, 1, 'Мотчаний Сергій', '::ffff:127.0.0.1', 'deal', 3, 'create', NULL, NULL, NULL, 'Угода створена', '2026-08-14 14:36:23'),
(25, 1, 'Мотчаний Сергій', '::ffff:127.0.0.1', 'deal', 4, 'create', NULL, NULL, NULL, 'Угода створена', '2026-09-03 12:40:14');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_calendar_events`
--

CREATE TABLE `8ydnb966_deals_calendar_events` (
  `id` int UNSIGNED NOT NULL,
  `id_deal` int UNSIGNED NOT NULL,
  `id_event_type` int UNSIGNED DEFAULT NULL COMMENT 'FK -> deals_calendar_event_type',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `date_start` datetime NOT NULL,
  `date_end` datetime NOT NULL,
  `all_day` tinyint(1) NOT NULL DEFAULT '0',
  `priority` tinyint UNSIGNED NOT NULL DEFAULT '2' COMMENT '1-низький 2-середній 3-високий 4-критичний',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'planned' COMMENT 'planned/done/canceled',
  `visibility_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'all' COMMENT 'private/all/custom',
  `reminder` tinyint(1) NOT NULL DEFAULT '0',
  `reminder_minutes` int DEFAULT '30',
  `id_user_creator` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Події календаря по угодах';

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_calendar_event_type`
--

CREATE TABLE `8ydnb966_deals_calendar_event_type` (
  `id` int UNSIGNED NOT NULL,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'meeting/call/reminder/deadline/vacation...',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#007bff',
  `has_location` tinyint(1) NOT NULL DEFAULT '1',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Типи подій календаря угод';

--
-- Дамп даних таблиці `8ydnb966_deals_calendar_event_type`
--

INSERT INTO `8ydnb966_deals_calendar_event_type` (`id`, `code`, `icon`, `color`, `has_location`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 'meeting', 'fas fa-handshake', '#007bff', 1, 1, 1, '2026-06-22 11:01:20', '2026-06-22 11:01:20'),
(2, 'call', 'fas fa-phone', '#28a745', 0, 1, 2, '2026-06-22 11:01:20', '2026-06-22 11:01:20'),
(3, 'reminder', 'fas fa-bell', '#ffc107', 0, 1, 3, '2026-06-22 11:01:20', '2026-06-22 11:01:20'),
(4, 'deadline', 'fas fa-flag', '#dc3545', 0, 1, 4, '2026-06-22 11:01:20', '2026-06-22 11:01:20'),
(5, 'demo', 'fas fa-desktop', '#fd7e14', 1, 1, 5, '2026-06-22 11:01:20', '2026-06-22 11:01:20'),
(6, 'internal', 'fas fa-users', '#6f42c1', 1, 1, 6, '2026-06-22 11:01:20', '2026-06-22 11:01:20'),
(7, 'other', 'fas fa-circle', '#6c757d', 1, 1, 7, '2026-06-22 11:01:20', '2026-06-22 11:01:20');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_calendar_event_type_lang`
--

CREATE TABLE `8ydnb966_deals_calendar_event_type_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_event_type` int UNSIGNED NOT NULL COMMENT 'FK -> deals_calendar_event_type',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_calendar_event_type_lang`
--

INSERT INTO `8ydnb966_deals_calendar_event_type_lang` (`id`, `id_event_type`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Зустріч'),
(2, 1, 2, 'Meeting'),
(3, 2, 1, 'Дзвінок'),
(4, 2, 2, 'Call'),
(5, 3, 1, 'Нагадування'),
(6, 3, 2, 'Reminder'),
(7, 4, 1, 'Дедлайн'),
(8, 4, 2, 'Deadline'),
(9, 5, 1, 'Демо'),
(10, 5, 2, 'Demo'),
(11, 6, 1, 'Внутрішня нарада'),
(12, 6, 2, 'Internal meeting'),
(13, 7, 1, 'Інше'),
(14, 7, 2, 'Other');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_calendar_event_users`
--

CREATE TABLE `8ydnb966_deals_calendar_event_users` (
  `id` int UNSIGNED NOT NULL,
  `id_event` int UNSIGNED NOT NULL,
  `id_user` int UNSIGNED NOT NULL,
  `reminder_sent` tinyint(1) NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Учасники подій календаря (custom-видимість)';

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_companies_map`
--

CREATE TABLE `8ydnb966_deals_companies_map` (
  `id` int UNSIGNED NOT NULL,
  `id_deal` int UNSIGNED NOT NULL COMMENT 'FK → deals',
  `id_company` int UNSIGNED NOT NULL COMMENT 'FK → companies',
  `role` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Роль компанії в угоді',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Компанії прив''язані до угоди (many-to-many)';

--
-- Дамп даних таблиці `8ydnb966_deals_companies_map`
--

INSERT INTO `8ydnb966_deals_companies_map` (`id`, `id_deal`, `id_company`, `role`, `is_primary`, `date_add`) VALUES
(1, 1, 1, 'Покупець', 1, '2026-05-28 20:05:35'),
(2, 1, 3, 'Субпідрядник', 0, '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_contacts_map`
--

CREATE TABLE `8ydnb966_deals_contacts_map` (
  `id` int UNSIGNED NOT NULL,
  `id_deal` int UNSIGNED NOT NULL COMMENT 'FK → deals',
  `id_contact` int UNSIGNED NOT NULL COMMENT 'FK → contacts',
  `id_role` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts_role',
  `is_primary` tinyint(1) NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Контакти прив''язані до угоди (many-to-many)';

--
-- Дамп даних таблиці `8ydnb966_deals_contacts_map`
--

INSERT INTO `8ydnb966_deals_contacts_map` (`id`, `id_deal`, `id_contact`, `id_role`, `is_primary`, `date_add`) VALUES
(1, 1, 1, 1, 1, '2026-05-28 20:05:35'),
(2, 1, 2, 3, 0, '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_contract`
--

CREATE TABLE `8ydnb966_deals_contract` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_deal` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals',
  `id_quote` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_quote',
  `id_company` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies',
  `id_contact` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts',
  `id_contract_status` int UNSIGNED NOT NULL COMMENT 'FK → deals_contract_status',
  `id_contract_type` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_contract_type',
  `id_template` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_doc_template',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users',
  `id_contract_parent` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_contract (для доп.угод)',
  `contract_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Номер: ДОГ-2026-0001',
  `external_number` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Номер договору клієнта',
  `date_contract` date NOT NULL,
  `date_start` date DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  `date_signed_us` date DEFAULT NULL,
  `date_signed_client` date DEFAULT NULL,
  `date_terminated` date DEFAULT NULL,
  `auto_renew` tinyint(1) NOT NULL DEFAULT '0',
  `renew_days_before` tinyint UNSIGNED DEFAULT NULL COMMENT 'Нагадати за N днів',
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH',
  `amount_total` decimal(18,2) NOT NULL DEFAULT '0.00',
  `payment_terms` text COLLATE utf8mb4_unicode_ci,
  `delivery_terms` text COLLATE utf8mb4_unicode_ci,
  `signed_by_us` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `signed_by_client` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `signatory_basis` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'На підставі чого підписує',
  `subject` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Предмет договору',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `internal_notes` text COLLATE utf8mb4_unicode_ci,
  `file_pdf` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Договори';

--
-- Дамп даних таблиці `8ydnb966_deals_contract`
--

INSERT INTO `8ydnb966_deals_contract` (`id`, `id_deal`, `id_quote`, `id_company`, `id_contact`, `id_contract_status`, `id_contract_type`, `id_template`, `id_user`, `id_contract_parent`, `contract_number`, `external_number`, `date_contract`, `date_start`, `date_end`, `date_signed_us`, `date_signed_client`, `date_terminated`, `auto_renew`, `renew_days_before`, `currency`, `amount_total`, `payment_terms`, `delivery_terms`, `signed_by_us`, `signed_by_client`, `signatory_basis`, `subject`, `notes`, `internal_notes`, `file_pdf`, `active`, `date_add`, `date_edit`) VALUES
(1, 1, 1, 1, 1, 2, 1, 1, 1, NULL, 'ДОГ-2026-0001', 'АТ-2026/П-047', '2026-05-28', '2026-06-04', '2027-05-28', NULL, NULL, NULL, 0, 30, 'UAH', 457860.00, '50% передоплата протягом 3 банківських днів, 50% після підписання акту', 'DDP склад покупця, м. Харків, вул. Промислова 15', 'Директор Коваленко О.М.', 'Директор Іванов В.П.', 'Статуту', 'Постачання промислового компресора KMB-500 (3 шт.), монтаж, навчання та технічне обслуговування', 'Клієнт просить додати пункт про штрафні санкції за прострочення поставки', 'Юрист перевірив 27.05.2026. Є зауваження до п.5.3 — уточнити форс-мажор', 'uploads/contracts/ДОГ-2026-0001.pdf', 1, '2026-05-28 20:05:35', '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_contract_file`
--

CREATE TABLE `8ydnb966_deals_contract_file` (
  `id` int UNSIGNED NOT NULL,
  `id_contract` int UNSIGNED NOT NULL COMMENT 'FK → deals_contract',
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size` int UNSIGNED DEFAULT NULL,
  `file_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_user` int UNSIGNED DEFAULT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Файли договорів';

--
-- Дамп даних таблиці `8ydnb966_deals_contract_file`
--

INSERT INTO `8ydnb966_deals_contract_file` (`id`, `id_contract`, `file_path`, `file_name`, `file_size`, `file_type`, `description`, `id_user`, `date_add`) VALUES
(1, 1, 'uploads/contracts/spec_KMB500.pdf', 'Специфікація KMB-500.pdf', 524288, 'application/pdf', 'Технічна специфікація обладнання', 1, '2026-05-28 20:05:35'),
(2, 1, 'uploads/contracts/ДОГ-2026-0001_скан.pdf', 'Договір підписаний скан.pdf', 1048576, 'application/pdf', 'Скан підписаного договору з боку клієнта', 1, '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_contract_status`
--

CREATE TABLE `8ydnb966_deals_contract_status` (
  `id` int UNSIGNED NOT NULL,
  `color_background` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#000000',
  `color_text` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_contract_status`
--

INSERT INTO `8ydnb966_deals_contract_status` (`id`, `color_background`, `color_text`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, '#6c757d', '#ffffff', 1, 1, '2026-05-28 19:50:03', '2026-05-28 19:50:03'),
(2, '#ffc107', '#000000', 1, 2, '2026-05-28 19:50:03', '2026-05-28 19:50:03'),
(3, '#28a745', '#ffffff', 1, 3, '2026-05-28 19:50:03', '2026-05-28 19:50:03'),
(4, '#17a2b8', '#ffffff', 1, 4, '2026-05-28 19:50:03', '2026-05-28 19:50:03'),
(5, '#dc3545', '#ffffff', 1, 5, '2026-05-28 19:50:03', '2026-05-28 19:50:03'),
(6, '#6c757d', '#ffffff', 1, 6, '2026-05-28 19:50:03', '2026-05-28 19:50:03');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_contract_status_lang`
--

CREATE TABLE `8ydnb966_deals_contract_status_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_contract_status` int UNSIGNED NOT NULL COMMENT 'FK → deals_contract_status',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_contract_status_lang`
--

INSERT INTO `8ydnb966_deals_contract_status_lang` (`id`, `id_contract_status`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Чернетка'),
(2, 1, 2, 'Draft'),
(3, 2, 1, 'На підписанні'),
(4, 2, 2, 'Pending Signature'),
(5, 3, 1, 'Активний'),
(6, 3, 2, 'Active'),
(7, 4, 1, 'Завершений'),
(8, 4, 2, 'Completed'),
(9, 5, 1, 'Розірваний'),
(10, 5, 2, 'Terminated'),
(11, 6, 1, 'Призупинений'),
(12, 6, 2, 'Suspended');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_contract_type`
--

CREATE TABLE `8ydnb966_deals_contract_type` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_contract_type`
--

INSERT INTO `8ydnb966_deals_contract_type` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 19:50:04', '2026-05-28 19:50:04'),
(2, 1, 2, '2026-05-28 19:50:04', '2026-05-28 19:50:04'),
(3, 1, 3, '2026-05-28 19:50:04', '2026-05-28 19:50:04'),
(4, 1, 4, '2026-05-28 19:50:04', '2026-05-28 19:50:04'),
(5, 1, 5, '2026-05-28 19:50:04', '2026-05-28 19:50:04'),
(6, 1, 6, '2026-05-28 19:50:04', '2026-05-28 19:50:04'),
(7, 1, 7, '2026-05-28 19:50:04', '2026-05-28 19:50:04');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_contract_type_lang`
--

CREATE TABLE `8ydnb966_deals_contract_type_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_contract_type` int UNSIGNED NOT NULL COMMENT 'FK → deals_contract_type',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_contract_type_lang`
--

INSERT INTO `8ydnb966_deals_contract_type_lang` (`id`, `id_contract_type`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Договір постачання'),
(2, 1, 2, 'Supply Agreement'),
(3, 2, 1, 'Договір послуг'),
(4, 2, 2, 'Service Agreement'),
(5, 3, 1, 'Рамковий договір'),
(6, 3, 2, 'Framework Agreement'),
(7, 4, 1, 'Агентський договір'),
(8, 4, 2, 'Agency Agreement'),
(9, 5, 1, 'NDA'),
(10, 5, 2, 'NDA'),
(11, 6, 1, 'Ліцензійна угода'),
(12, 6, 2, 'License Agreement'),
(13, 7, 1, 'Договір підряду'),
(14, 7, 2, 'Contract Work Agreement');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_custom_field`
--

CREATE TABLE `8ydnb966_deals_custom_field` (
  `id` int UNSIGNED NOT NULL,
  `id_group` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_custom_field_group',
  `field_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'text|textarea|number|decimal|date|datetime|checkbox|select|multiselect|url|email|phone|file',
  `field_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Назва поля',
  `placeholder` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hint` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_pipeline` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_pipeline (NULL = для всіх)',
  `is_required` tinyint(1) NOT NULL DEFAULT '0',
  `is_unique` tinyint(1) NOT NULL DEFAULT '0',
  `default_value` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'FA іконка',
  `show_in_list` tinyint(1) NOT NULL DEFAULT '0',
  `show_in_card` tinyint(1) NOT NULL DEFAULT '1',
  `show_in_kanban` tinyint(1) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Кастомні поля угод';

--
-- Дамп даних таблиці `8ydnb966_deals_custom_field`
--

INSERT INTO `8ydnb966_deals_custom_field` (`id`, `id_group`, `field_type`, `field_key`, `label`, `placeholder`, `hint`, `id_pipeline`, `is_required`, `is_unique`, `default_value`, `icon`, `show_in_list`, `show_in_card`, `show_in_kanban`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, NULL, 'text', '', 'Номер тендеру', NULL, NULL, NULL, 0, 0, NULL, NULL, 0, 1, 0, 1, 1, '2026-06-02 01:00:06', '2026-06-02 01:00:06');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_custom_field_group`
--

CREATE TABLE `8ydnb966_deals_custom_field_group` (
  `id` int UNSIGNED NOT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_custom_field_group_lang`
--

CREATE TABLE `8ydnb966_deals_custom_field_group_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_group` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_custom_field_lang`
--

CREATE TABLE `8ydnb966_deals_custom_field_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_custom_field` int UNSIGNED NOT NULL COMMENT 'FK → deals_custom_field',
  `id_lang` smallint UNSIGNED NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `placeholder` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hint` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_custom_field_lang`
--

INSERT INTO `8ydnb966_deals_custom_field_lang` (`id`, `id_custom_field`, `id_lang`, `label`, `placeholder`, `hint`) VALUES
(1, 1, 1, 'Номер тендеру', NULL, NULL),
(2, 1, 2, 'Tender number', NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_custom_field_option`
--

CREATE TABLE `8ydnb966_deals_custom_field_option` (
  `id` int UNSIGNED NOT NULL,
  `id_custom_field` int UNSIGNED NOT NULL COMMENT 'FK → deals_custom_field',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Назва варіанту',
  `value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Значення (якщо відрізняється від назви)',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_custom_field_value`
--

CREATE TABLE `8ydnb966_deals_custom_field_value` (
  `id` int UNSIGNED NOT NULL,
  `id_deal` int UNSIGNED NOT NULL COMMENT 'FK → deals',
  `id_custom_field` int UNSIGNED NOT NULL COMMENT 'FK → deals_custom_field',
  `value_text` text COLLATE utf8mb4_unicode_ci,
  `value_int` int DEFAULT NULL,
  `value_decimal` decimal(18,4) DEFAULT NULL,
  `value_date` date DEFAULT NULL,
  `value_datetime` datetime DEFAULT NULL,
  `value_json` json DEFAULT NULL COMMENT 'Для multiselect, tags',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Значення кастомних полів угод (EAV)';

--
-- Дамп даних таблиці `8ydnb966_deals_custom_field_value`
--

INSERT INTO `8ydnb966_deals_custom_field_value` (`id`, `id_deal`, `id_custom_field`, `value_text`, `value_int`, `value_decimal`, `value_date`, `value_datetime`, `value_json`, `date_add`, `date_edit`) VALUES
(1, 1, 1, 'Тендер №ТН-2026-0089 111', NULL, NULL, NULL, NULL, NULL, '2026-05-28 20:05:35', '2026-06-02 03:20:19'),
(2, 1, 2, NULL, 1, NULL, NULL, NULL, NULL, '2026-05-28 20:05:35', '2026-05-28 20:05:35'),
(3, 1, 3, NULL, NULL, 485000.0000, NULL, NULL, NULL, '2026-05-28 20:05:35', '2026-05-28 20:05:35'),
(4, 1, 4, NULL, NULL, NULL, '2026-06-15', NULL, NULL, '2026-05-28 20:05:35', '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_doc_counter`
--

CREATE TABLE `8ydnb966_deals_doc_counter` (
  `id` int UNSIGNED NOT NULL,
  `doc_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'quote / contract / invoice / act',
  `year` year NOT NULL,
  `counter` int UNSIGNED NOT NULL DEFAULT '0',
  `prefix` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `padding` tinyint NOT NULL DEFAULT '4' COMMENT 'Довжина: 0001'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Лічильники авто-нумерації документів';

--
-- Дамп даних таблиці `8ydnb966_deals_doc_counter`
--

INSERT INTO `8ydnb966_deals_doc_counter` (`id`, `doc_type`, `year`, `counter`, `prefix`, `padding`) VALUES
(1, 'quote', '2026', 0, 'КП', 4),
(2, 'contract', '2026', 0, 'ДОГ', 4),
(3, 'invoice', '2026', 0, 'РАХ', 4),
(4, 'act', '2026', 0, 'АКТ', 4);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_doc_template`
--

CREATE TABLE `8ydnb966_deals_doc_template` (
  `id` int UNSIGNED NOT NULL,
  `doc_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'quote / contract / invoice / act',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Шаблони документів (HTML → PDF)';

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_doc_template_lang`
--

CREATE TABLE `8ydnb966_deals_doc_template_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_template` int UNSIGNED NOT NULL COMMENT 'FK → deals_doc_template',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci COMMENT 'HTML з {змінними}',
  `css` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_file`
--

CREATE TABLE `8ydnb966_deals_file` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `entity_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'deal/quote/contract/invoice/act/activity/task',
  `id_entity` int UNSIGNED NOT NULL COMMENT 'ID запису',
  `id_deal` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals (для швидкої вибірки)',
  `id_company` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies',
  `id_category` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_file_category',
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_ext` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_size` int UNSIGNED DEFAULT NULL,
  `file_mime` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_hash` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'SHA256 для дедуплікації',
  `version` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `id_file_parent` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_file (попередня версія)',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_public` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = видно клієнту',
  `id_user` int UNSIGNED DEFAULT NULL,
  `download_count` int UNSIGNED NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Файли та документи угод';

--
-- Дамп даних таблиці `8ydnb966_deals_file`
--

INSERT INTO `8ydnb966_deals_file` (`id`, `entity_type`, `id_entity`, `id_deal`, `id_company`, `id_category`, `file_path`, `file_name`, `file_ext`, `file_size`, `file_mime`, `file_hash`, `version`, `id_file_parent`, `title`, `description`, `is_public`, `id_user`, `download_count`, `active`, `date_add`, `date_edit`) VALUES
(1, 'deal', 1, 1, 1, 6, 'uploads/deals/presentation_KMB500.pdf', 'Презентація_KMB-500_2026.pdf', 'pdf', 2097152, 'application/pdf', 'a3f5c8e1d2b4f6a7c9e0b1d3f5a7c9e1', 1, NULL, 'Презентація обладнання KMB-500', 'Технічна презентація для технічного відділу клієнта', 1, 1, 2, 1, '2026-05-28 20:05:35', '2026-05-28 20:05:35'),
(2, 'quote', 1, 1, 1, 1, 'uploads/quotes/КП-2026-0001.pdf', 'КП-2026-0001.pdf', 'pdf', 786432, 'application/pdf', 'b4e6d8f0a2c4e6f8a0b2d4f6a8c0e2f4', 1, NULL, 'Комерційна пропозиція КП-2026-0001', 'Фінальна версія КП надіслана клієнту', 1, 1, 1, 1, '2026-05-28 20:05:35', '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_file_category`
--

CREATE TABLE `8ydnb966_deals_file_category` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_file_category`
--

INSERT INTO `8ydnb966_deals_file_category` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 19:50:32', '2026-05-28 19:50:32'),
(2, 1, 2, '2026-05-28 19:50:32', '2026-05-28 19:50:32'),
(3, 1, 3, '2026-05-28 19:50:32', '2026-05-28 19:50:32'),
(4, 1, 4, '2026-05-28 19:50:32', '2026-05-28 19:50:32'),
(5, 1, 5, '2026-05-28 19:50:32', '2026-05-28 19:50:32'),
(6, 1, 6, '2026-05-28 19:50:32', '2026-05-28 19:50:32'),
(7, 1, 7, '2026-05-28 19:50:32', '2026-05-28 19:50:32'),
(8, 1, 8, '2026-05-28 19:50:32', '2026-05-28 19:50:32');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_file_category_lang`
--

CREATE TABLE `8ydnb966_deals_file_category_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_category` int UNSIGNED NOT NULL COMMENT 'FK → deals_file_category',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_file_category_lang`
--

INSERT INTO `8ydnb966_deals_file_category_lang` (`id`, `id_category`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Комерційна пропозиція'),
(2, 1, 2, 'Quote'),
(3, 2, 1, 'Договір'),
(4, 2, 2, 'Contract'),
(5, 3, 1, 'Рахунок'),
(6, 3, 2, 'Invoice'),
(7, 4, 1, 'Акт'),
(8, 4, 2, 'Act'),
(9, 5, 1, 'Специфікація'),
(10, 5, 2, 'Specification'),
(11, 6, 1, 'Презентація'),
(12, 6, 2, 'Presentation'),
(13, 7, 1, 'Технічне завдання'),
(14, 7, 2, 'Technical Spec'),
(15, 8, 1, 'Інше'),
(16, 8, 2, 'Other');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_invoice`
--

CREATE TABLE `8ydnb966_deals_invoice` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_deal` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals',
  `id_quote` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_quote',
  `id_contract` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_contract',
  `id_company` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies',
  `id_contact` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts',
  `id_invoice_status` int UNSIGNED NOT NULL COMMENT 'FK → deals_invoice_status',
  `id_template` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_doc_template',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users',
  `id_bank_account` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies_bank_accounts (наш рахунок)',
  `invoice_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Номер: РАХ-2026-0001',
  `invoice_type` enum('invoice','prepayment','correction','credit_note') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'invoice',
  `date_invoice` date NOT NULL,
  `date_due` date DEFAULT NULL COMMENT 'Дата оплати (план)',
  `date_paid` date DEFAULT NULL COMMENT 'Дата оплати (факт)',
  `date_sent` datetime DEFAULT NULL,
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH',
  `amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `discount_amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `tax_amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `amount_total` decimal(18,2) NOT NULL DEFAULT '0.00',
  `amount_paid` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Сплачено',
  `amount_due` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Залишок',
  `payer_name` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Назва платника (знімок)',
  `payer_edrpou` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payer_ipn` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payer_address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payer_iban` varchar(34) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payer_bank` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payer_mfo` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_terms` text COLLATE utf8mb4_unicode_ci,
  `purpose` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Призначення платежу',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `internal_notes` text COLLATE utf8mb4_unicode_ci,
  `reminder_sent` tinyint(1) NOT NULL DEFAULT '0',
  `reminder_date` datetime DEFAULT NULL,
  `file_pdf` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Рахунки на оплату';

--
-- Дамп даних таблиці `8ydnb966_deals_invoice`
--

INSERT INTO `8ydnb966_deals_invoice` (`id`, `id_deal`, `id_quote`, `id_contract`, `id_company`, `id_contact`, `id_invoice_status`, `id_template`, `id_user`, `id_bank_account`, `invoice_number`, `invoice_type`, `date_invoice`, `date_due`, `date_paid`, `date_sent`, `currency`, `amount`, `discount_amount`, `tax_amount`, `amount_total`, `amount_paid`, `amount_due`, `payer_name`, `payer_edrpou`, `payer_ipn`, `payer_address`, `payer_iban`, `payer_bank`, `payer_mfo`, `payment_terms`, `purpose`, `notes`, `internal_notes`, `reminder_sent`, `reminder_date`, `file_pdf`, `active`, `date_add`, `date_edit`) VALUES
(1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 'РАХ-2026-0001', 'prepayment', '2026-05-28', '2026-05-31', NULL, '2026-05-28 20:05:35', 'UAH', 190775.00, 0.00, 38155.00, 228930.00, 0.00, 228930.00, 'Товариство з обмеженою відповідальністю \"Альфа-Трейд\"', '38291047', '382910426541', 'м. Київ, вул. Хрещатик 22, оф. 304', 'UA213052990000026007233566001', 'АТ КБ «ПриватБанк»', '305299', 'Передоплата 50% протягом 3 банківських днів з дати виставлення рахунку', 'Передоплата 50% за договором ДОГ-2026-0001 від 28.05.2026, постачання компресорного обладнання', 'Рахунок на передоплату. Другий рахунок після підписання акту.', 'Нагадати клієнту 30.05.2026 якщо не оплатить', 0, '2026-05-30 20:05:35', 'uploads/invoices/РАХ-2026-0001.pdf', 1, '2026-05-28 20:05:35', '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_invoice_item`
--

CREATE TABLE `8ydnb966_deals_invoice_item` (
  `id` int UNSIGNED NOT NULL,
  `id_invoice` int UNSIGNED NOT NULL COMMENT 'FK → deals_invoice',
  `id_product` int UNSIGNED DEFAULT NULL COMMENT 'FK → зовнішня таблиця товарів',
  `id_unit` int UNSIGNED DEFAULT NULL,
  `id_tax` int UNSIGNED DEFAULT NULL,
  `name` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `sku` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qty` decimal(10,3) NOT NULL DEFAULT '1.000',
  `price` decimal(18,2) NOT NULL DEFAULT '0.00',
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `discount_type` tinyint(1) NOT NULL DEFAULT '0',
  `discount_amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `tax_rate` decimal(6,2) NOT NULL DEFAULT '0.00',
  `tax_included` tinyint(1) NOT NULL DEFAULT '0',
  `tax_amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `amount_total` decimal(18,2) NOT NULL DEFAULT '0.00',
  `sort_order` int NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Позиції рахунків';

--
-- Дамп даних таблиці `8ydnb966_deals_invoice_item`
--

INSERT INTO `8ydnb966_deals_invoice_item` (`id`, `id_invoice`, `id_product`, `id_unit`, `id_tax`, `name`, `description`, `sku`, `qty`, `price`, `discount`, `discount_type`, `discount_amount`, `tax_rate`, `tax_included`, `tax_amount`, `amount`, `amount_total`, `sort_order`, `active`, `date_add`, `date_edit`) VALUES
(1, 1, 42, 1, 2, 'Передоплата 50%: Промисловий компресор KMB-500 (3 шт)', NULL, 'KMB-500', 1.000, 162450.00, 0.00, 0, 0.00, 20.00, 0, 32490.00, 162450.00, 194940.00, 1, 1, '2026-05-28 20:05:35', '2026-05-28 20:05:35'),
(2, 1, NULL, 8, 2, 'Передоплата 50%: Монтаж та підключення', NULL, NULL, 1.000, 21600.00, 0.00, 0, 0.00, 20.00, 0, 4320.00, 21600.00, 25920.00, 2, 1, '2026-05-28 20:05:35', '2026-05-28 20:05:35'),
(3, 1, NULL, 8, 2, 'Передоплата 50%: Технічне обслуговування (12 міс)', NULL, NULL, 1.000, 28800.00, 0.00, 0, 0.00, 20.00, 0, 5760.00, 28800.00, 34560.00, 3, 1, '2026-05-28 20:05:35', '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_invoice_status`
--

CREATE TABLE `8ydnb966_deals_invoice_status` (
  `id` int UNSIGNED NOT NULL,
  `color_background` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#000000',
  `color_text` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_invoice_status`
--

INSERT INTO `8ydnb966_deals_invoice_status` (`id`, `color_background`, `color_text`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, '#6c757d', '#ffffff', 1, 1, '2026-05-28 19:50:09', '2026-05-28 19:50:09'),
(2, '#007bff', '#ffffff', 1, 2, '2026-05-28 19:50:09', '2026-05-28 19:50:09'),
(3, '#ffc107', '#000000', 1, 3, '2026-05-28 19:50:09', '2026-05-28 19:50:09'),
(4, '#28a745', '#ffffff', 1, 4, '2026-05-28 19:50:09', '2026-05-28 19:50:09'),
(5, '#dc3545', '#ffffff', 1, 5, '2026-05-28 19:50:09', '2026-05-28 19:50:09'),
(6, '#17a2b8', '#ffffff', 1, 6, '2026-05-28 19:50:09', '2026-05-28 19:50:09'),
(7, '#6c757d', '#ffffff', 1, 7, '2026-05-28 19:50:09', '2026-05-28 19:50:09');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_invoice_status_lang`
--

CREATE TABLE `8ydnb966_deals_invoice_status_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_invoice_status` int UNSIGNED NOT NULL COMMENT 'FK → deals_invoice_status',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_invoice_status_lang`
--

INSERT INTO `8ydnb966_deals_invoice_status_lang` (`id`, `id_invoice_status`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Чернетка'),
(2, 1, 2, 'Draft'),
(3, 2, 1, 'Виставлено'),
(4, 2, 2, 'Issued'),
(5, 3, 1, 'Часткова оплата'),
(6, 3, 2, 'Partially Paid'),
(7, 4, 1, 'Оплачено'),
(8, 4, 2, 'Paid'),
(9, 5, 1, 'Прострочено'),
(10, 5, 2, 'Overdue'),
(11, 6, 1, 'Скасовано'),
(12, 6, 2, 'Canceled'),
(13, 7, 1, 'Повернення'),
(14, 7, 2, 'Refunded');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_item`
--

CREATE TABLE `8ydnb966_deals_item` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_deal` int UNSIGNED NOT NULL COMMENT 'FK → deals',
  `id_item_type` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_item_type',
  `id_product` int UNSIGNED DEFAULT NULL COMMENT 'FK → зовнішня таблиця товарів (заповнюється якщо item_type=product)',
  `ref_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Таблиця-джерело: products, services, works... (NULL = вручну)',
  `id_ref` int UNSIGNED DEFAULT NULL COMMENT 'ID запису в таблиці ref_type (NULL = вручну)',
  `id_unit` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_unit',
  `id_tax` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_tax',
  `name` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Назва позиції',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'Опис',
  `sku` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Артикул (якщо є)',
  `qty` decimal(10,3) NOT NULL DEFAULT '1.000' COMMENT 'Кількість',
  `price` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Ціна за одиницю (до знижки)',
  `price_currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH' COMMENT 'Валюта',
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT 'Знижка',
  `discount_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=%, 1=фіксована сума',
  `discount_amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Сума знижки (авто)',
  `tax_rate` decimal(6,2) NOT NULL DEFAULT '0.00' COMMENT 'Ставка ПДВ %',
  `tax_included` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=ПДВ зверху, 1=включено в ціну',
  `tax_amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Сума ПДВ (авто)',
  `amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Сума без ПДВ: (price-discount)*qty',
  `amount_total` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Сума з ПДВ',
  `cost_price` decimal(18,2) DEFAULT NULL COMMENT 'Собівартість за одиницю',
  `margin_amount` decimal(18,2) DEFAULT NULL COMMENT 'Маржа',
  `margin_percent` decimal(6,2) DEFAULT NULL COMMENT 'Маржа %',
  `billing_period` enum('once','daily','weekly','monthly','quarterly','yearly') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Період тарифікації (для підписок, оренди)',
  `billing_cycles` smallint UNSIGNED DEFAULT NULL COMMENT 'Кількість циклів (0=безкінечно)',
  `date_from` date DEFAULT NULL COMMENT 'Дата початку (послуга/оренда/навчання)',
  `date_to` date DEFAULT NULL COMMENT 'Дата закінчення',
  `sort_order` int NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Позиції угоди (товари, послуги, роботи, підписки, оренда, навчання, довільні)';

--
-- Дамп даних таблиці `8ydnb966_deals_item`
--

INSERT INTO `8ydnb966_deals_item` (`id`, `id_deal`, `id_item_type`, `id_product`, `ref_type`, `id_ref`, `id_unit`, `id_tax`, `name`, `description`, `sku`, `qty`, `price`, `price_currency`, `discount`, `discount_type`, `discount_amount`, `tax_rate`, `tax_included`, `tax_amount`, `amount`, `amount_total`, `cost_price`, `margin_amount`, `margin_percent`, `billing_period`, `billing_cycles`, `date_from`, `date_to`, `sort_order`, `active`, `date_add`, `date_edit`) VALUES
(1, 1, 1, NULL, NULL, NULL, 1, NULL, 'Промисловий компресор KMB-500', 'Компресор гвинтовий, 500 л/хв, 10 бар', 'KMB-500', 1.000, 1000.00, 'UAH', 10.00, 0, 100.00, 0.00, 0, 0.00, 900.00, 900.00, 70.00, 830.00, 92.22, NULL, NULL, NULL, NULL, 0, 1, '2026-05-28 20:05:35', '2026-05-30 10:26:02'),
(2, 1, 2, NULL, NULL, NULL, 4, 2, 'Монтаж та підключення обладнання', 'Виїзд бригади 2 особи, 3 дні', NULL, 24.000, 1800.00, 'UAH', 0.00, 0, 0.00, 20.00, 0, 8640.00, 43200.00, 51840.00, NULL, NULL, NULL, 'once', NULL, '2026-08-05', '2026-08-07', 2, 0, '2026-05-28 20:05:35', '2026-05-30 07:24:51'),
(3, 1, 4, NULL, NULL, NULL, 4, 2, 'Технічне обслуговування (ТО)', 'Щомісячне планове ТО, включає виїзд і запчастини', NULL, 12.000, 4800.00, 'UAH', 0.00, 0, 0.00, 20.00, 0, 11520.00, 57600.00, 69120.00, NULL, NULL, NULL, 'monthly', 12, '2026-09-01', '2027-08-31', 3, 0, '2026-05-28 20:05:35', '2026-05-30 07:24:56'),
(4, 1, 7, NULL, NULL, NULL, 8, 1, 'Навчання операторів', '2 дні навчання на підприємстві клієнта, 5 осіб', NULL, 1.000, 12000.00, 'UAH', 0.00, 0, 0.00, 0.00, 0, 0.00, 12000.00, 12000.00, NULL, NULL, NULL, 'once', NULL, '2026-08-10', '2026-08-11', 4, 0, '2026-05-28 20:05:35', '2026-05-30 07:25:01');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_item_type`
--

CREATE TABLE `8ydnb966_deals_item_type` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Системний код: product, service...',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Типи позицій угоди';

--
-- Дамп даних таблиці `8ydnb966_deals_item_type`
--

INSERT INTO `8ydnb966_deals_item_type` (`id`, `code`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 'product', 1, 1, '2026-05-29 03:20:27', '2026-05-29 03:20:27'),
(2, 'service', 1, 2, '2026-05-29 03:20:27', '2026-05-29 03:20:27'),
(3, 'work', 1, 3, '2026-05-29 03:20:27', '2026-05-29 03:20:27'),
(4, 'subscription', 1, 4, '2026-05-29 03:20:27', '2026-05-29 03:20:27'),
(5, 'license', 1, 5, '2026-05-29 03:20:27', '2026-05-29 03:20:27'),
(6, 'rental', 1, 6, '2026-05-29 03:20:27', '2026-05-29 03:20:27'),
(7, 'training', 1, 7, '2026-05-29 03:20:27', '2026-05-29 03:20:27'),
(8, 'custom', 1, 8, '2026-05-29 03:20:27', '2026-05-29 03:20:27');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_item_type_lang`
--

CREATE TABLE `8ydnb966_deals_item_type_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_item_type` int UNSIGNED NOT NULL COMMENT 'FK → deals_item_type',
  `id_lang` smallint UNSIGNED NOT NULL COMMENT 'FK → languages',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_item_type_lang`
--

INSERT INTO `8ydnb966_deals_item_type_lang` (`id`, `id_item_type`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Товар'),
(2, 1, 2, 'Product'),
(3, 2, 1, 'Послуга'),
(4, 2, 2, 'Service'),
(5, 3, 1, 'Робота'),
(6, 3, 2, 'Work'),
(7, 4, 1, 'Підписка'),
(8, 4, 2, 'Subscription'),
(9, 5, 1, 'Ліцензія'),
(10, 5, 2, 'License'),
(11, 6, 1, 'Оренда'),
(12, 6, 2, 'Rental'),
(13, 7, 1, 'Навчання'),
(14, 7, 2, 'Training'),
(15, 8, 1, 'Довільна'),
(16, 8, 2, 'Custom');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_lost_reason`
--

CREATE TABLE `8ydnb966_deals_lost_reason` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Причини програшу угод';

--
-- Дамп даних таблиці `8ydnb966_deals_lost_reason`
--

INSERT INTO `8ydnb966_deals_lost_reason` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 19:49:39', '2026-05-28 19:49:39'),
(2, 1, 2, '2026-05-28 19:49:39', '2026-05-28 19:49:39'),
(3, 1, 3, '2026-05-28 19:49:39', '2026-05-28 19:49:39'),
(4, 1, 4, '2026-05-28 19:49:39', '2026-05-28 19:49:39'),
(5, 1, 5, '2026-05-28 19:49:39', '2026-05-28 19:49:39'),
(6, 1, 6, '2026-05-28 19:49:39', '2026-05-28 19:49:39'),
(7, 1, 7, '2026-05-28 19:49:39', '2026-05-28 19:49:39');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_lost_reason_lang`
--

CREATE TABLE `8ydnb966_deals_lost_reason_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_lost_reason` int UNSIGNED NOT NULL COMMENT 'FK → deals_lost_reason',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_lost_reason_lang`
--

INSERT INTO `8ydnb966_deals_lost_reason_lang` (`id`, `id_lost_reason`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Ціна'),
(2, 1, 2, 'Price'),
(3, 2, 1, 'Обрали конкурента'),
(4, 2, 2, 'Chose competitor'),
(5, 3, 1, 'Немає бюджету'),
(6, 3, 2, 'No budget'),
(7, 4, 1, 'Відклали рішення'),
(8, 4, 2, 'Decision postponed'),
(9, 5, 1, 'Не влаштував продукт'),
(10, 5, 2, 'Product did not fit'),
(11, 6, 1, 'Немає потреби'),
(12, 6, 2, 'No need'),
(13, 7, 1, 'Немає відповіді'),
(14, 7, 2, 'No response');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_payment`
--

CREATE TABLE `8ydnb966_deals_payment` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_invoice` int UNSIGNED NOT NULL COMMENT 'FK → deals_invoice',
  `id_deal` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals',
  `id_company` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users',
  `amount` decimal(18,2) NOT NULL,
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH',
  `amount_base` decimal(18,2) NOT NULL DEFAULT '0.00',
  `exchange_rate` decimal(18,6) NOT NULL DEFAULT '1.000000',
  `payment_method` enum('bank_transfer','cash','card','crypto','barter','other') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'bank_transfer',
  `transaction_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Призначення платежу',
  `bank_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_payment` date NOT NULL,
  `date_confirmed` datetime DEFAULT NULL,
  `status` enum('pending','confirmed','failed','refunded') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `is_refund` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = повернення',
  `id_payment_parent` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_payment (для повернень)',
  `notes` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Платежі по рахунках';

--
-- Дамп даних таблиці `8ydnb966_deals_payment`
--

INSERT INTO `8ydnb966_deals_payment` (`id`, `id_invoice`, `id_deal`, `id_company`, `id_user`, `amount`, `currency`, `amount_base`, `exchange_rate`, `payment_method`, `transaction_id`, `payment_reference`, `bank_name`, `date_payment`, `date_confirmed`, `status`, `is_refund`, `id_payment_parent`, `notes`, `date_add`, `date_edit`) VALUES
(1, 1, 1, 1, 1, 228930.00, 'UAH', 228930.00, 1.000000, 'bank_transfer', NULL, 'Передоплата 50% за договором ДОГ-2026-0001 від 28.05.2026', 'АТ КБ «ПриватБанк»', '2026-05-31', NULL, 'pending', 0, NULL, 'Очікуємо оплату до 31.05.2026', '2026-05-28 20:05:35', '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_pipeline`
--

CREATE TABLE `8ydnb966_deals_pipeline` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `color` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#007bff' COMMENT 'Колір воронки в інтерфейсі',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = воронка за замовчуванням',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Воронки продажів';

--
-- Дамп даних таблиці `8ydnb966_deals_pipeline`
--

INSERT INTO `8ydnb966_deals_pipeline` (`id`, `color`, `is_default`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, '#007bff', 1, 1, 1, '2026-05-28 19:49:32', '2026-05-28 19:49:32'),
(2, '#28a745', 0, 1, 2, '2026-05-28 19:49:32', '2026-05-28 19:49:32'),
(3, '#ffc107', 0, 1, 3, '2026-05-28 19:49:32', '2026-05-28 19:49:32');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_pipeline_lang`
--

CREATE TABLE `8ydnb966_deals_pipeline_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_pipeline` int UNSIGNED NOT NULL COMMENT 'FK → deals_pipeline',
  `id_lang` smallint UNSIGNED NOT NULL COMMENT 'FK → languages',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_pipeline_lang`
--

INSERT INTO `8ydnb966_deals_pipeline_lang` (`id`, `id_pipeline`, `id_lang`, `name`, `description`) VALUES
(1, 1, 1, 'Основні продажі', 'Стандартна воронка продажів'),
(2, 1, 2, 'Main Sales', 'Standard sales pipeline'),
(3, 2, 1, 'Партнери', 'Воронка для партнерів'),
(4, 2, 2, 'Partners', 'Partner pipeline'),
(5, 3, 1, 'Тендери', 'Тендерні процедури'),
(6, 3, 2, 'Tenders', 'Tender procedures');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_quote`
--

CREATE TABLE `8ydnb966_deals_quote` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_deal` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals',
  `id_company` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies',
  `id_contact` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts',
  `id_quote_status` int UNSIGNED NOT NULL COMMENT 'FK → deals_quote_status',
  `id_template` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_doc_template',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users',
  `id_user_creator` int UNSIGNED DEFAULT NULL COMMENT 'FK → users',
  `id_quote_parent` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_quote (попередня версія)',
  `quote_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Номер КП: КП-2026-0001',
  `version` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `date_quote` date NOT NULL,
  `date_valid` date DEFAULT NULL COMMENT 'Дійсне до',
  `date_sent` datetime DEFAULT NULL,
  `date_viewed` datetime DEFAULT NULL,
  `date_accepted` datetime DEFAULT NULL,
  `date_declined` datetime DEFAULT NULL,
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH',
  `amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `discount_type` tinyint(1) NOT NULL DEFAULT '0',
  `discount_amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `tax_amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `amount_total` decimal(18,2) NOT NULL DEFAULT '0.00',
  `payment_terms` text COLLATE utf8mb4_unicode_ci,
  `delivery_terms` text COLLATE utf8mb4_unicode_ci,
  `warranty_terms` text COLLATE utf8mb4_unicode_ci,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `internal_notes` text COLLATE utf8mb4_unicode_ci,
  `footer_text` text COLLATE utf8mb4_unicode_ci,
  `sign_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Токен для онлайн-підписання',
  `sign_token_expires` datetime DEFAULT NULL,
  `signed_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `signed_ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_signed` datetime DEFAULT NULL,
  `file_pdf` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Комерційні пропозиції (КП)';

--
-- Дамп даних таблиці `8ydnb966_deals_quote`
--

INSERT INTO `8ydnb966_deals_quote` (`id`, `id_deal`, `id_company`, `id_contact`, `id_quote_status`, `id_template`, `id_user`, `id_user_creator`, `id_quote_parent`, `quote_number`, `version`, `date_quote`, `date_valid`, `date_sent`, `date_viewed`, `date_accepted`, `date_declined`, `currency`, `amount`, `discount`, `discount_type`, `discount_amount`, `tax_amount`, `amount_total`, `payment_terms`, `delivery_terms`, `warranty_terms`, `notes`, `internal_notes`, `footer_text`, `sign_token`, `sign_token_expires`, `signed_by`, `signed_ip`, `date_signed`, `file_pdf`, `active`, `date_add`, `date_edit`) VALUES
(1, 1, 1, 1, 3, 1, 1, 1, NULL, 'КП-2026-0001', 1, '2026-05-28', '2026-06-27', '2026-05-26 20:05:35', '2026-05-27 20:05:35', NULL, NULL, 'UAH', 383550.00, 5.00, 0, 14250.00, 74310.00, 457860.00, 'Оплата: 50% передоплата, 50% після монтажу', 'Доставка за рахунок постачальника, DDP склад клієнта', 'Гарантія 24 місяці на обладнання, 12 місяців на монтажні роботи', 'Варіант з розширеним ТО включено за запитом клієнта', 'Клієнт порівнює з пропозицією ТОВ \"Бета\", наш плюс — гарантія і навчання', 'Ціни дійсні 30 днів. ПДВ включено в позиції.', 'tok_kp2026_abc123xyz', '2026-06-27 20:05:35', NULL, NULL, NULL, 'uploads/quotes/КП-2026-0001.pdf', 1, '2026-05-28 20:05:35', '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_quote_item`
--

CREATE TABLE `8ydnb966_deals_quote_item` (
  `id` int UNSIGNED NOT NULL,
  `id_quote` int UNSIGNED NOT NULL COMMENT 'FK → deals_quote',
  `id_product` int UNSIGNED DEFAULT NULL COMMENT 'FK → зовнішня таблиця товарів',
  `id_unit` int UNSIGNED DEFAULT NULL,
  `id_tax` int UNSIGNED DEFAULT NULL,
  `name` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `sku` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `qty` decimal(10,3) NOT NULL DEFAULT '1.000',
  `price` decimal(18,2) NOT NULL DEFAULT '0.00',
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `discount_type` tinyint(1) NOT NULL DEFAULT '0',
  `discount_amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `tax_rate` decimal(6,2) NOT NULL DEFAULT '0.00',
  `tax_included` tinyint(1) NOT NULL DEFAULT '0',
  `tax_amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `amount` decimal(18,2) NOT NULL DEFAULT '0.00',
  `amount_total` decimal(18,2) NOT NULL DEFAULT '0.00',
  `sort_order` int NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Позиції КП';

--
-- Дамп даних таблиці `8ydnb966_deals_quote_item`
--

INSERT INTO `8ydnb966_deals_quote_item` (`id`, `id_quote`, `id_product`, `id_unit`, `id_tax`, `name`, `description`, `sku`, `qty`, `price`, `discount`, `discount_type`, `discount_amount`, `tax_rate`, `tax_included`, `tax_amount`, `amount`, `amount_total`, `sort_order`, `active`, `date_add`, `date_edit`) VALUES
(1, 1, 42, 1, 2, 'Промисловий компресор KMB-500', 'Компресор гвинтовий, 500 л/хв', 'KMB-500', 3.000, 95000.00, 5.00, 0, 14250.00, 20.00, 0, 54150.00, 270750.00, 324900.00, 1, 1, '2026-05-28 20:05:35', '2026-05-28 20:05:35'),
(2, 1, NULL, 4, 2, 'Монтаж та підключення', NULL, NULL, 24.000, 1800.00, 0.00, 0, 0.00, 20.00, 0, 8640.00, 43200.00, 51840.00, 2, 1, '2026-05-28 20:05:35', '2026-05-28 20:05:35'),
(3, 1, NULL, 4, 2, 'Технічне обслуговування (12 міс)', NULL, NULL, 12.000, 4800.00, 0.00, 0, 0.00, 20.00, 0, 11520.00, 57600.00, 69120.00, 3, 1, '2026-05-28 20:05:35', '2026-05-28 20:05:35'),
(4, 1, NULL, 8, 1, 'Навчання операторів', '2 дні, 5 осіб', NULL, 1.000, 12000.00, 0.00, 0, 0.00, 0.00, 0, 0.00, 12000.00, 12000.00, 4, 1, '2026-05-28 20:05:35', '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_quote_status`
--

CREATE TABLE `8ydnb966_deals_quote_status` (
  `id` int UNSIGNED NOT NULL,
  `color_background` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#000000',
  `color_text` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_quote_status`
--

INSERT INTO `8ydnb966_deals_quote_status` (`id`, `color_background`, `color_text`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, '#6c757d', '#ffffff', 1, 1, '2026-05-28 19:49:57', '2026-05-28 19:49:57'),
(2, '#007bff', '#ffffff', 1, 2, '2026-05-28 19:49:57', '2026-05-28 19:49:57'),
(3, '#17a2b8', '#ffffff', 1, 3, '2026-05-28 19:49:57', '2026-05-28 19:49:57'),
(4, '#28a745', '#ffffff', 1, 4, '2026-05-28 19:49:57', '2026-05-28 19:49:57'),
(5, '#dc3545', '#ffffff', 1, 5, '2026-05-28 19:49:57', '2026-05-28 19:49:57'),
(6, '#ffc107', '#000000', 1, 6, '2026-05-28 19:49:57', '2026-05-28 19:49:57'),
(7, '#6c757d', '#ffffff', 1, 7, '2026-05-28 19:49:57', '2026-05-28 19:49:57');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_quote_status_lang`
--

CREATE TABLE `8ydnb966_deals_quote_status_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_quote_status` int UNSIGNED NOT NULL COMMENT 'FK → deals_quote_status',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_quote_status_lang`
--

INSERT INTO `8ydnb966_deals_quote_status_lang` (`id`, `id_quote_status`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Чернетка'),
(2, 1, 2, 'Draft'),
(3, 2, 1, 'Надіслано'),
(4, 2, 2, 'Sent'),
(5, 3, 1, 'Переглянуто'),
(6, 3, 2, 'Viewed'),
(7, 4, 1, 'Прийнято'),
(8, 4, 2, 'Accepted'),
(9, 5, 1, 'Відхилено'),
(10, 5, 2, 'Declined'),
(11, 6, 1, 'Прострочено'),
(12, 6, 2, 'Expired'),
(13, 7, 1, 'Скасовано'),
(14, 7, 2, 'Canceled');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_source`
--

CREATE TABLE `8ydnb966_deals_source` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Джерела угод';

--
-- Дамп даних таблиці `8ydnb966_deals_source`
--

INSERT INTO `8ydnb966_deals_source` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 19:49:38', '2026-05-28 19:49:38'),
(2, 1, 2, '2026-05-28 19:49:38', '2026-05-28 19:49:38'),
(3, 1, 3, '2026-05-28 19:49:38', '2026-05-28 19:49:38'),
(4, 1, 4, '2026-05-28 19:49:38', '2026-05-28 19:49:38'),
(5, 1, 5, '2026-05-28 19:49:38', '2026-05-28 19:49:38'),
(6, 1, 6, '2026-05-28 19:49:38', '2026-05-28 19:49:38'),
(7, 1, 7, '2026-05-28 19:49:38', '2026-05-28 19:49:38');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_source_lang`
--

CREATE TABLE `8ydnb966_deals_source_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_source` int UNSIGNED NOT NULL COMMENT 'FK → deals_source',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_source_lang`
--

INSERT INTO `8ydnb966_deals_source_lang` (`id`, `id_source`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Вхідний запит'),
(2, 1, 2, 'Inbound'),
(3, 2, 1, 'Холодний дзвінок'),
(4, 2, 2, 'Cold Call'),
(5, 3, 1, 'Реферал'),
(6, 3, 2, 'Referral'),
(7, 4, 1, 'Виставка / Захід'),
(8, 4, 2, 'Event / Exhibition'),
(9, 5, 1, 'Сайт / Форма'),
(10, 5, 2, 'Website / Form'),
(11, 6, 1, 'Соціальні мережі'),
(12, 6, 2, 'Social Media'),
(13, 7, 1, 'Повторний клієнт'),
(14, 7, 2, 'Returning Client');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_stage`
--

CREATE TABLE `8ydnb966_deals_stage` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_pipeline` int UNSIGNED NOT NULL COMMENT 'FK → deals_pipeline',
  `stage_type` enum('open','won','lost','canceled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open' COMMENT 'Тип: open/won/lost/canceled',
  `probability` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Ймовірність закриття %',
  `color_background` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#e9ecef',
  `color_text` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#212529',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = початкова стадія воронки',
  `rotting_days` tinyint UNSIGNED DEFAULT NULL COMMENT 'Днів без активності → угода протухає',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Стадії воронок продажів';

--
-- Дамп даних таблиці `8ydnb966_deals_stage`
--

INSERT INTO `8ydnb966_deals_stage` (`id`, `id_pipeline`, `stage_type`, `probability`, `color_background`, `color_text`, `is_default`, `rotting_days`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 'open', 10, '#e7f3ff', '#084298', 1, 14, 1, 1, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(2, 1, 'open', 25, '#fff3cd', '#664d03', 0, 14, 1, 2, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(3, 1, 'open', 50, '#fde8d8', '#7a3c00', 0, 10, 1, 3, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(4, 1, 'open', 75, '#e2d9f3', '#432874', 0, 7, 1, 4, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(5, 1, 'open', 90, '#d1ecf1', '#0c5460', 0, 5, 1, 5, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(6, 1, 'won', 100, '#d1e7dd', '#0a3622', 0, NULL, 1, 6, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(7, 1, 'lost', 0, '#f8d7da', '#58151c', 0, NULL, 1, 7, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(8, 1, 'canceled', 0, '#e9ecef', '#495057', 0, NULL, 1, 8, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(9, 2, 'open', 20, '#e7f3ff', '#084298', 1, 21, 1, 1, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(10, 2, 'open', 60, '#fff3cd', '#664d03', 0, 14, 1, 2, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(11, 2, 'won', 100, '#d1e7dd', '#0a3622', 0, NULL, 1, 3, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(12, 2, 'lost', 0, '#f8d7da', '#58151c', 0, NULL, 1, 4, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(13, 3, 'open', 10, '#e7f3ff', '#084298', 1, 30, 1, 1, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(14, 3, 'open', 30, '#fff3cd', '#664d03', 0, 21, 1, 2, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(15, 3, 'open', 50, '#fde8d8', '#7a3c00', 0, 14, 1, 3, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(16, 3, 'open', 80, '#d1ecf1', '#0c5460', 0, 7, 1, 4, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(17, 3, 'won', 100, '#d1e7dd', '#0a3622', 0, NULL, 1, 5, '2026-05-28 19:49:34', '2026-05-28 19:49:34'),
(18, 3, 'lost', 0, '#f8d7da', '#58151c', 0, NULL, 1, 6, '2026-05-28 19:49:34', '2026-05-28 19:49:34');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_stage_history`
--

CREATE TABLE `8ydnb966_deals_stage_history` (
  `id` int UNSIGNED NOT NULL,
  `id_deal` int UNSIGNED NOT NULL COMMENT 'FK → deals',
  `id_stage_from` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_stage (звідки)',
  `id_stage_to` int UNSIGNED NOT NULL COMMENT 'FK → deals_stage (куди)',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users',
  `duration_days` int DEFAULT NULL COMMENT 'Днів у попередній стадії',
  `note` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Історія переходів між стадіями угоди';

--
-- Дамп даних таблиці `8ydnb966_deals_stage_history`
--

INSERT INTO `8ydnb966_deals_stage_history` (`id`, `id_deal`, `id_stage_from`, `id_stage_to`, `id_user`, `duration_days`, `note`, `date_add`) VALUES
(1, 1, NULL, 1, 1, NULL, 'Угода створена', '2026-05-14 20:05:35'),
(2, 1, 1, 2, 1, 7, 'Клієнт кваліфікований, бюджет підтверджено', '2026-05-21 20:05:35'),
(3, 1, 2, 3, 1, 7, 'КП підготовлено і надіслано клієнту', '2026-05-28 20:05:35'),
(4, 1, 3, 1, 9, 0, NULL, '2026-05-29 02:15:05'),
(5, 1, 1, 2, 9, 0, NULL, '2026-05-29 02:15:13'),
(6, 1, 2, 3, 9, 0, NULL, '2026-05-29 02:15:17'),
(7, 1, 3, 4, 9, 0, NULL, '2026-05-29 02:15:21'),
(8, 1, 4, 5, 9, 0, NULL, '2026-05-29 02:15:25'),
(9, 1, 5, 1, 9, 0, NULL, '2026-05-29 02:36:36'),
(10, 1, 1, 1, 9, 0, NULL, '2026-05-29 02:36:37'),
(11, 1, 1, 2, 9, 0, NULL, '2026-05-29 02:36:41'),
(12, 1, 2, 1, 9, 0, NULL, '2026-05-29 02:36:43'),
(13, 1, 1, 2, 9, 1, NULL, '2026-05-30 15:58:36');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_stage_lang`
--

CREATE TABLE `8ydnb966_deals_stage_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_stage` int UNSIGNED NOT NULL COMMENT 'FK → deals_stage',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_stage_lang`
--

INSERT INTO `8ydnb966_deals_stage_lang` (`id`, `id_stage`, `id_lang`, `name`, `description`) VALUES
(1, 1, 1, 'Новий', NULL),
(2, 1, 2, 'New', NULL),
(3, 2, 1, 'Кваліфікація', NULL),
(4, 2, 2, 'Qualification', NULL),
(5, 3, 1, 'КП надіслано', NULL),
(6, 3, 2, 'Proposal Sent', NULL),
(7, 4, 1, 'Переговори', NULL),
(8, 4, 2, 'Negotiation', NULL),
(9, 5, 1, 'Договір', NULL),
(10, 5, 2, 'Contract', NULL),
(11, 6, 1, 'Виграно', NULL),
(12, 6, 2, 'Won', NULL),
(13, 7, 1, 'Програно', NULL),
(14, 7, 2, 'Lost', NULL),
(15, 8, 1, 'Скасовано', NULL),
(16, 8, 2, 'Canceled', NULL),
(17, 9, 1, 'Знайомство', NULL),
(18, 9, 2, 'Introduction', NULL),
(19, 10, 1, 'Погодження умов', NULL),
(20, 10, 2, 'Terms Agreement', NULL),
(21, 11, 1, 'Партнер підписаний', NULL),
(22, 11, 2, 'Partner Signed', NULL),
(23, 12, 1, 'Відмова', NULL),
(24, 12, 2, 'Declined', NULL),
(25, 13, 1, 'Моніторинг', NULL),
(26, 13, 2, 'Monitoring', NULL),
(27, 14, 1, 'Підготовка заявки', NULL),
(28, 14, 2, 'Bid Preparation', NULL),
(29, 15, 1, 'Заявку подано', NULL),
(30, 15, 2, 'Bid Submitted', NULL),
(31, 16, 1, 'Розгляд', NULL),
(32, 16, 2, 'Under Review', NULL),
(33, 17, 1, 'Тендер виграно', NULL),
(34, 17, 2, 'Tender Won', NULL),
(35, 18, 1, 'Тендер програно', NULL),
(36, 18, 2, 'Tender Lost', NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_task`
--

CREATE TABLE `8ydnb966_deals_task` (
  `id` int UNSIGNED NOT NULL COMMENT 'PK',
  `id_deal` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals',
  `id_company` int UNSIGNED DEFAULT NULL COMMENT 'FK → companies',
  `id_contact` int UNSIGNED DEFAULT NULL COMMENT 'FK → contacts',
  `id_activity` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_activity',
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'FK → users (виконавець)',
  `id_user_creator` int UNSIGNED DEFAULT NULL COMMENT 'FK → users (постановник)',
  `id_user_observer` int UNSIGNED DEFAULT NULL COMMENT 'FK → users (спостерігач)',
  `title` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `result` text COLLATE utf8mb4_unicode_ci,
  `date_start` datetime DEFAULT NULL,
  `date_due` datetime DEFAULT NULL,
  `date_done` datetime DEFAULT NULL,
  `estimated_minutes` smallint UNSIGNED DEFAULT NULL,
  `actual_minutes` smallint UNSIGNED DEFAULT NULL,
  `status` enum('new','in_progress','on_hold','done','canceled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'new',
  `priority` tinyint UNSIGNED NOT NULL DEFAULT '2',
  `progress` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT '% виконання',
  `is_recurring` tinyint(1) NOT NULL DEFAULT '0',
  `recur_type` enum('daily','weekly','monthly','yearly') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recur_interval` tinyint UNSIGNED DEFAULT NULL,
  `recur_end_date` date DEFAULT NULL,
  `id_task_parent` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_task (батьківське)',
  `id_task_blocked_by` int UNSIGNED DEFAULT NULL COMMENT 'FK → deals_task (блокується)',
  `is_private` tinyint(1) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Завдання';

--
-- Дамп даних таблиці `8ydnb966_deals_task`
--

INSERT INTO `8ydnb966_deals_task` (`id`, `id_deal`, `id_company`, `id_contact`, `id_activity`, `id_user`, `id_user_creator`, `id_user_observer`, `title`, `description`, `result`, `date_start`, `date_due`, `date_done`, `estimated_minutes`, `actual_minutes`, `status`, `priority`, `progress`, `is_recurring`, `recur_type`, `recur_interval`, `recur_end_date`, `id_task_parent`, `id_task_blocked_by`, `is_private`, `active`, `date_add`, `date_edit`) VALUES
(1, 1, 1, 1, 1, 1, 1, NULL, 'Зателефонувати — рішення технічного відділу', 'Уточнити чи погодив технічний відділ специфікацію KMB-500. Якщо є зауваження — запропонувати зустріч.', NULL, '2026-05-28 14:05:00', '2026-05-31 14:05:00', NULL, 30, NULL, 'new', 3, 15, 0, NULL, NULL, NULL, NULL, NULL, 1, 1, '2026-05-28 20:05:35', '2026-05-29 02:45:04');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_task_checklist`
--

CREATE TABLE `8ydnb966_deals_task_checklist` (
  `id` int UNSIGNED NOT NULL,
  `id_task` int UNSIGNED NOT NULL COMMENT 'FK → deals_task',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_done` tinyint(1) NOT NULL DEFAULT '0',
  `id_user` int UNSIGNED DEFAULT NULL,
  `date_done` datetime DEFAULT NULL,
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Чеклісти завдань';

--
-- Дамп даних таблиці `8ydnb966_deals_task_checklist`
--

INSERT INTO `8ydnb966_deals_task_checklist` (`id`, `id_task`, `title`, `is_done`, `id_user`, `date_done`, `sort_order`, `date_add`) VALUES
(1, 1, 'Перевірити чи переглянув КП технічний відділ', 0, NULL, NULL, 1, '2026-05-28 20:05:35'),
(2, 1, 'Уточнити терміни прийняття рішення', 0, NULL, NULL, 2, '2026-05-28 20:05:35'),
(3, 1, 'Запропонувати демо на виробництві якщо є сумніви', 0, NULL, NULL, 3, '2026-05-28 20:05:35');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_tax`
--

CREATE TABLE `8ydnb966_deals_tax` (
  `id` int UNSIGNED NOT NULL,
  `rate` decimal(6,2) NOT NULL DEFAULT '0.00' COMMENT 'Ставка %',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Ставки ПДВ для позицій угод';

--
-- Дамп даних таблиці `8ydnb966_deals_tax`
--

INSERT INTO `8ydnb966_deals_tax` (`id`, `rate`, `is_default`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 0.00, 0, 1, 1, '2026-05-28 19:49:49', '2026-05-28 19:49:49'),
(2, 20.00, 1, 1, 2, '2026-05-28 19:49:49', '2026-05-28 19:49:49'),
(3, 7.00, 0, 1, 3, '2026-05-28 19:49:49', '2026-05-28 19:49:49'),
(4, 14.00, 0, 1, 4, '2026-05-28 19:49:49', '2026-05-28 19:49:49');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_tax_lang`
--

CREATE TABLE `8ydnb966_deals_tax_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_tax` int UNSIGNED NOT NULL COMMENT 'FK → deals_tax',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_tax_lang`
--

INSERT INTO `8ydnb966_deals_tax_lang` (`id`, `id_tax`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Без ПДВ'),
(2, 1, 2, 'No VAT'),
(3, 2, 1, 'ПДВ 20%'),
(4, 2, 2, 'VAT 20%'),
(5, 3, 1, 'ПДВ 7%'),
(6, 3, 2, 'VAT 7%'),
(7, 4, 1, 'ПДВ 14%'),
(8, 4, 2, 'VAT 14%');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_total`
--

CREATE TABLE `8ydnb966_deals_total` (
  `id` int UNSIGNED NOT NULL,
  `id_deal` int UNSIGNED NOT NULL COMMENT 'FK → deals',
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Сума без ПДВ',
  `discount_amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Загальна знижка',
  `tax_amount` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'ПДВ',
  `amount_total` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Сума з ПДВ',
  `amount_base` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Еквівалент в базовій валюті',
  `margin_amount` decimal(18,2) DEFAULT NULL,
  `margin_percent` decimal(6,2) DEFAULT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Підсумки угоди по валютах (авто-розраховуються)';

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_type`
--

CREATE TABLE `8ydnb966_deals_type` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Типи угод';

--
-- Дамп даних таблиці `8ydnb966_deals_type`
--

INSERT INTO `8ydnb966_deals_type` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 19:49:36', '2026-05-28 19:49:36'),
(2, 1, 2, '2026-05-28 19:49:36', '2026-05-28 19:49:36'),
(3, 1, 3, '2026-05-28 19:49:36', '2026-05-28 19:49:36'),
(4, 1, 4, '2026-05-28 19:49:36', '2026-05-28 19:49:36'),
(5, 1, 5, '2026-05-28 19:49:36', '2026-05-28 19:49:36'),
(6, 1, 6, '2026-05-28 19:49:36', '2026-05-28 19:49:36');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_type_lang`
--

CREATE TABLE `8ydnb966_deals_type_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_deal_type` int UNSIGNED NOT NULL COMMENT 'FK → deals_type',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_type_lang`
--

INSERT INTO `8ydnb966_deals_type_lang` (`id`, `id_deal_type`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Новий бізнес'),
(2, 1, 2, 'New Business'),
(3, 2, 1, 'Повторний продаж'),
(4, 2, 2, 'Repeat Sale'),
(5, 3, 1, 'Upsell'),
(6, 3, 2, 'Upsell'),
(7, 4, 1, 'Cross-sell'),
(8, 4, 2, 'Cross-sell'),
(9, 5, 1, 'Продовження'),
(10, 5, 2, 'Renewal'),
(11, 6, 1, 'Тендер'),
(12, 6, 2, 'Tender');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_unit`
--

CREATE TABLE `8ydnb966_deals_unit` (
  `id` int UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Одиниці виміру позицій угод';

--
-- Дамп даних таблиці `8ydnb966_deals_unit`
--

INSERT INTO `8ydnb966_deals_unit` (`id`, `active`, `sort_order`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-28 19:49:48', '2026-05-28 19:49:48'),
(2, 1, 2, '2026-05-28 19:49:48', '2026-05-28 19:49:48'),
(3, 1, 3, '2026-05-28 19:49:48', '2026-05-28 19:49:48'),
(4, 1, 4, '2026-05-28 19:49:48', '2026-05-28 19:49:48'),
(5, 1, 5, '2026-05-28 19:49:48', '2026-05-28 19:49:48'),
(6, 1, 6, '2026-05-28 19:49:48', '2026-05-28 19:49:48'),
(7, 1, 7, '2026-05-28 19:49:48', '2026-05-28 19:49:48'),
(8, 1, 8, '2026-05-28 19:49:48', '2026-05-28 19:49:48'),
(9, 1, 9, '2026-05-28 19:49:48', '2026-05-28 19:49:48'),
(10, 1, 10, '2026-05-28 19:49:48', '2026-05-28 19:49:48');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_deals_unit_lang`
--

CREATE TABLE `8ydnb966_deals_unit_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_unit` int UNSIGNED NOT NULL COMMENT 'FK → deals_unit',
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Штука, Година, Місяць...',
  `name_short` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'шт, год, міс...'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_deals_unit_lang`
--

INSERT INTO `8ydnb966_deals_unit_lang` (`id`, `id_unit`, `id_lang`, `name`, `name_short`) VALUES
(1, 1, 1, 'Штука', 'шт'),
(2, 1, 2, 'Piece', 'pcs'),
(3, 2, 1, 'Година', 'год'),
(4, 2, 2, 'Hour', 'hr'),
(5, 3, 1, 'День', 'день'),
(6, 3, 2, 'Day', 'day'),
(7, 4, 1, 'Місяць', 'міс'),
(8, 4, 2, 'Month', 'mo'),
(9, 5, 1, 'Рік', 'рік'),
(10, 5, 2, 'Year', 'yr'),
(11, 6, 1, 'Кілограм', 'кг'),
(12, 6, 2, 'Kilogram', 'kg'),
(13, 7, 1, 'Метр', 'м'),
(14, 7, 2, 'Meter', 'm'),
(15, 8, 1, 'Комплект', 'компл'),
(16, 8, 2, 'Set', 'set'),
(17, 9, 1, 'Ліцензія', 'ліц'),
(18, 9, 2, 'License', 'lic'),
(19, 10, 1, 'Послуга', 'посл'),
(20, 10, 2, 'Service', 'svc');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_integrations`
--

CREATE TABLE `8ydnb966_integrations` (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `color_text` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color_background` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` json NOT NULL,
  `system` int NOT NULL,
  `ssl` int NOT NULL,
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` int NOT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_languages`
--

CREATE TABLE `8ydnb966_languages` (
  `id` smallint UNSIGNED NOT NULL,
  `iso` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'uk, en, pl...',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `sort` tinyint UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_languages`
--

INSERT INTO `8ydnb966_languages` (`id`, `iso`, `name`, `active`, `sort`) VALUES
(1, 'en', 'English', 1, 1),
(2, 'uk', 'Українська', 1, 2);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads`
--

CREATE TABLE `8ydnb966_leads` (
  `id` int UNSIGNED NOT NULL,
  `title` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `note` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `id_pipeline` int UNSIGNED DEFAULT NULL,
  `id_stage` int UNSIGNED DEFAULT NULL,
  `id_status` int UNSIGNED NOT NULL DEFAULT '0',
  `temperature` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'cold',
  `id_temperature` int UNSIGNED DEFAULT NULL,
  `qualification` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unqualified',
  `id_qualification` int UNSIGNED DEFAULT NULL,
  `priority` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `id_priority` int UNSIGNED DEFAULT NULL,
  `id_manager` int UNSIGNED DEFAULT NULL,
  `id_team` int UNSIGNED DEFAULT NULL,
  `id_source` int UNSIGNED DEFAULT NULL,
  `lead_source` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `website` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `capture_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'manual',
  `capture_ref` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `contact_info` json DEFAULT NULL,
  `utm` json DEFAULT NULL,
  `fingerprint` json DEFAULT NULL,
  `custom_fields` json DEFAULT NULL,
  `products` json DEFAULT NULL,
  `score_fit` smallint NOT NULL DEFAULT '0',
  `score_activity` smallint NOT NULL DEFAULT '0',
  `score` smallint NOT NULL DEFAULT '0',
  `grade` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'D',
  `score_decay_at` datetime DEFAULT NULL,
  `expected_close_date` date DEFAULT NULL,
  `response_deadline` datetime DEFAULT NULL,
  `first_response_at` datetime DEFAULT NULL,
  `id_loss_reason` int UNSIGNED DEFAULT NULL,
  `loss_note` text COLLATE utf8mb4_unicode_ci,
  `is_converted` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `converted_at` datetime DEFAULT NULL,
  `is_duplicate` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `id_duplicate_of` int UNSIGNED DEFAULT NULL,
  `duplicate_method` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `id_deleted_by` int UNSIGNED DEFAULT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_activities`
--

CREATE TABLE `8ydnb966_leads_activities` (
  `id` int UNSIGNED NOT NULL,
  `id_lead` int UNSIGNED NOT NULL,
  `id_manager` int UNSIGNED DEFAULT NULL,
  `type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `direction` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'outbound',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'planned',
  `subject` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `body` text COLLATE utf8mb4_unicode_ci,
  `duration_sec` int UNSIGNED NOT NULL DEFAULT '0',
  `record_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_outcome` int UNSIGNED DEFAULT NULL,
  `scheduled_at` datetime DEFAULT NULL,
  `done_at` datetime DEFAULT NULL,
  `repeat` json DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `id_deleted_by` int UNSIGNED DEFAULT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_activity_outcomes`
--

CREATE TABLE `8ydnb966_leads_activity_outcomes` (
  `id` int UNSIGNED NOT NULL,
  `activity_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#cccccc',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_activity_outcomes_lang`
--

CREATE TABLE `8ydnb966_leads_activity_outcomes_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_outcome` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_api_tokens`
--

CREATE TABLE `8ydnb966_leads_api_tokens` (
  `id` int UNSIGNED NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_whitelist` json DEFAULT NULL,
  `id_pipeline` int UNSIGNED DEFAULT NULL,
  `id_manager` int UNSIGNED DEFAULT NULL,
  `field_map` json DEFAULT NULL,
  `note` varchar(999) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `last_used_at` datetime DEFAULT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_automations`
--

CREATE TABLE `8ydnb966_leads_automations` (
  `id` int UNSIGNED NOT NULL,
  `trigger` json NOT NULL,
  `conditions` json DEFAULT NULL,
  `actions` json NOT NULL,
  `delay_min` int UNSIGNED NOT NULL DEFAULT '0',
  `priority` int UNSIGNED NOT NULL DEFAULT '0',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_automations_lang`
--

CREATE TABLE `8ydnb966_leads_automations_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_automation` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_automations_log`
--

CREATE TABLE `8ydnb966_leads_automations_log` (
  `id` int UNSIGNED NOT NULL,
  `id_automation` int UNSIGNED NOT NULL,
  `id_lead` int UNSIGNED NOT NULL,
  `result` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'success',
  `error` text COLLATE utf8mb4_unicode_ci,
  `trigger_data` json DEFAULT NULL,
  `actions_data` json DEFAULT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_conversions`
--

CREATE TABLE `8ydnb966_leads_conversions` (
  `id` int UNSIGNED NOT NULL,
  `id_lead` int UNSIGNED NOT NULL,
  `id_manager` int UNSIGNED DEFAULT NULL,
  `converted_to` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `converted_id` int UNSIGNED DEFAULT NULL,
  `snapshot` json NOT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_custom_fields`
--

CREATE TABLE `8ydnb966_leads_custom_fields` (
  `id` int UNSIGNED NOT NULL,
  `type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_pipeline` int UNSIGNED DEFAULT NULL,
  `options` json DEFAULT NULL,
  `min_value` decimal(15,4) DEFAULT NULL,
  `max_value` decimal(15,4) DEFAULT NULL,
  `visibility` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'all',
  `is_required` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_custom_fields_lang`
--

CREATE TABLE `8ydnb966_leads_custom_fields_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_field` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hint` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_custom_fields_stage`
--

CREATE TABLE `8ydnb966_leads_custom_fields_stage` (
  `id` int UNSIGNED NOT NULL,
  `id_field` int UNSIGNED NOT NULL,
  `id_stage` int UNSIGNED NOT NULL,
  `is_required` tinyint UNSIGNED NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_duplicates`
--

CREATE TABLE `8ydnb966_leads_duplicates` (
  `id` int UNSIGNED NOT NULL,
  `id_lead` int UNSIGNED NOT NULL,
  `id_lead_orig` int UNSIGNED NOT NULL,
  `method` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `id_manager` int UNSIGNED DEFAULT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_email_templates`
--

CREATE TABLE `8ydnb966_leads_email_templates` (
  `id` int UNSIGNED NOT NULL,
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_email_templates_lang`
--

CREATE TABLE `8ydnb966_leads_email_templates_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_template` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `subject` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_files`
--

CREATE TABLE `8ydnb966_leads_files` (
  `id` int UNSIGNED NOT NULL,
  `id_lead` int UNSIGNED NOT NULL,
  `id_manager` int UNSIGNED DEFAULT NULL,
  `category` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'other',
  `name` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `path` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mime` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `size` int UNSIGNED NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  `id_deleted_by` int UNSIGNED DEFAULT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_history`
--

CREATE TABLE `8ydnb966_leads_history` (
  `id` int UNSIGNED NOT NULL,
  `id_lead` int UNSIGNED NOT NULL,
  `id_manager` int UNSIGNED DEFAULT NULL,
  `action_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `field_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value_old` text COLLATE utf8mb4_unicode_ci,
  `value_new` text COLLATE utf8mb4_unicode_ci,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `is_pinned` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `source` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'web',
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_loss_reasons`
--

CREATE TABLE `8ydnb966_leads_loss_reasons` (
  `id` int UNSIGNED NOT NULL,
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_loss_reasons_lang`
--

CREATE TABLE `8ydnb966_leads_loss_reasons_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_reason` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_pipelines`
--

CREATE TABLE `8ydnb966_leads_pipelines` (
  `id` int UNSIGNED NOT NULL,
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `is_default` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_pipelines`
--

INSERT INTO `8ydnb966_leads_pipelines` (`id`, `is_active`, `is_default`, `sort`, `date_add`, `date_edit`) VALUES
(1, 1, 1, 1, '2026-05-17 09:17:17', '2026-05-17 09:17:17');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_pipelines_lang`
--

CREATE TABLE `8ydnb966_leads_pipelines_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_pipeline` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_pipelines_lang`
--

INSERT INTO `8ydnb966_leads_pipelines_lang` (`id`, `id_pipeline`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Sales'),
(2, 1, 2, 'Продажі');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_pipeline_stages`
--

CREATE TABLE `8ydnb966_leads_pipeline_stages` (
  `id` int UNSIGNED NOT NULL,
  `id_pipeline` int UNSIGNED NOT NULL,
  `color` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#cccccc',
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `system_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'regular',
  `probability` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `sla_hours` smallint UNSIGNED NOT NULL DEFAULT '0',
  `required_fields` json DEFAULT NULL,
  `auto_actions` json DEFAULT NULL,
  `lock_back` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_pipeline_stages`
--

INSERT INTO `8ydnb966_leads_pipeline_stages` (`id`, `id_pipeline`, `color`, `icon`, `system_type`, `probability`, `sla_hours`, `required_fields`, `auto_actions`, `lock_back`, `is_active`, `sort`, `date_add`, `date_edit`) VALUES
(1, 1, '#0d6efd', '', 'regular', 10, 24, NULL, NULL, 0, 1, 1, '2026-05-17 09:17:18', '2026-05-17 09:17:18'),
(2, 1, '#6f42c1', '', 'regular', 30, 48, NULL, NULL, 0, 1, 2, '2026-05-17 09:17:18', '2026-05-17 09:17:18'),
(3, 1, '#fd7e14', '', 'regular', 60, 72, NULL, NULL, 0, 1, 3, '2026-05-17 09:17:18', '2026-05-17 09:17:18'),
(4, 1, '#20c997', '', 'won', 100, 0, NULL, NULL, 0, 1, 4, '2026-05-17 09:17:18', '2026-05-17 09:17:18'),
(5, 1, '#dc3545', '', 'lost', 0, 0, NULL, NULL, 0, 1, 5, '2026-05-17 09:17:18', '2026-05-17 09:17:18');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_pipeline_stages_lang`
--

CREATE TABLE `8ydnb966_leads_pipeline_stages_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_stage` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_pipeline_stages_lang`
--

INSERT INTO `8ydnb966_leads_pipeline_stages_lang` (`id`, `id_stage`, `id_lang`, `name`) VALUES
(1, 1, 1, 'New'),
(2, 1, 2, 'Новий'),
(3, 2, 1, 'Contacted'),
(4, 2, 2, 'Contacted'),
(5, 3, 1, 'Negotiation'),
(6, 3, 2, 'Переговори'),
(7, 4, 1, 'Won'),
(8, 4, 2, 'Виграно'),
(9, 5, 1, 'Lost'),
(10, 5, 2, 'Програно');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_priorities`
--

CREATE TABLE `8ydnb966_leads_priorities` (
  `id` int UNSIGNED NOT NULL,
  `color_text` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `color_background` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#6c757d',
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_priorities`
--

INSERT INTO `8ydnb966_leads_priorities` (`id`, `color_text`, `color_background`, `icon`, `sort`, `is_active`, `date_add`, `date_edit`) VALUES
(1, '#ffffff', '#6c757d', '', 1, 1, '2026-05-17 19:16:27', '2026-05-17 19:16:27'),
(2, '#ffffff', '#0d6efd', '', 2, 1, '2026-05-17 19:16:27', '2026-05-17 19:16:27'),
(3, '#000000', '#ffc107', '', 3, 1, '2026-05-17 19:16:27', '2026-05-17 19:16:27'),
(4, '#ffffff', '#dc3545', '', 4, 1, '2026-05-17 19:16:27', '2026-05-17 19:16:27');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_priorities_lang`
--

CREATE TABLE `8ydnb966_leads_priorities_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_priority` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_priorities_lang`
--

INSERT INTO `8ydnb966_leads_priorities_lang` (`id`, `id_priority`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Low'),
(2, 1, 2, 'Низький'),
(3, 2, 1, 'Normal'),
(4, 2, 2, 'Нормальний'),
(5, 3, 1, 'High'),
(6, 3, 2, 'Високий'),
(7, 4, 1, 'Urgent'),
(8, 4, 2, 'Терміновий');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_qualifications`
--

CREATE TABLE `8ydnb966_leads_qualifications` (
  `id` int UNSIGNED NOT NULL,
  `slug` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color_text` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `color_background` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#6c757d',
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_qualifications`
--

INSERT INTO `8ydnb966_leads_qualifications` (`id`, `slug`, `color_text`, `color_background`, `icon`, `sort`, `is_active`, `date_add`, `date_edit`) VALUES
(1, 'unqualified', '#ffffff', '#6c757d', '', 1, 1, '2026-05-17 19:16:30', '2026-05-17 19:16:30'),
(2, 'mql', '#ffffff', '#0d6efd', 'fa-user', 2, 1, '2026-05-17 19:16:30', '2026-05-17 19:16:30'),
(3, 'sql', '#ffffff', '#198754', 'fa-star', 3, 1, '2026-05-17 19:16:30', '2026-05-17 19:16:30'),
(4, 'pql', '#ffffff', '#20c997', 'fa-trophy', 4, 1, '2026-05-17 19:16:30', '2026-05-17 19:16:30');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_qualifications_lang`
--

CREATE TABLE `8ydnb966_leads_qualifications_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_qualification` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_qualifications_lang`
--

INSERT INTO `8ydnb966_leads_qualifications_lang` (`id`, `id_qualification`, `id_lang`, `name`, `description`) VALUES
(1, 1, 1, 'Unqualified', 'Lead has not been qualified yet'),
(2, 1, 2, 'Некваліфікований', 'Лід ще не кваліфіковано'),
(3, 2, 1, 'MQL', 'Marketing Qualified Lead'),
(4, 2, 2, 'MQL', 'Кваліфікований маркетингом'),
(5, 3, 1, 'SQL', 'Sales Qualified Lead'),
(6, 3, 2, 'SQL', 'Кваліфікований продажами'),
(7, 4, 1, 'PQL', 'Product Qualified Lead'),
(8, 4, 2, 'PQL', 'Кваліфікований продуктом');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_reminders`
--

CREATE TABLE `8ydnb966_leads_reminders` (
  `id` int UNSIGNED NOT NULL,
  `id_lead` int UNSIGNED NOT NULL,
  `id_manager` int UNSIGNED DEFAULT NULL,
  `id_team` int UNSIGNED DEFAULT NULL,
  `text` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `remind_at` datetime NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_routing_rules`
--

CREATE TABLE `8ydnb966_leads_routing_rules` (
  `id` int UNSIGNED NOT NULL,
  `conditions` json NOT NULL,
  `id_pipeline` int UNSIGNED DEFAULT NULL,
  `id_stage` int UNSIGNED DEFAULT NULL,
  `id_manager` int UNSIGNED DEFAULT NULL,
  `id_team` int UNSIGNED DEFAULT NULL,
  `assign_mode` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'fixed',
  `priority` int UNSIGNED NOT NULL DEFAULT '0',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_routing_rules_lang`
--

CREATE TABLE `8ydnb966_leads_routing_rules_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_rule` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_score_log`
--

CREATE TABLE `8ydnb966_leads_score_log` (
  `id` int UNSIGNED NOT NULL,
  `id_lead` int UNSIGNED NOT NULL,
  `id_rule` int UNSIGNED DEFAULT NULL,
  `id_manager` int UNSIGNED DEFAULT NULL,
  `score_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'fit',
  `delta` smallint NOT NULL DEFAULT '0',
  `score_after` smallint NOT NULL DEFAULT '0',
  `reason` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_score_rules`
--

CREATE TABLE `8ydnb966_leads_score_rules` (
  `id` int UNSIGNED NOT NULL,
  `score_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'fit',
  `condition` json NOT NULL,
  `score_delta` smallint NOT NULL DEFAULT '0',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_score_rules_lang`
--

CREATE TABLE `8ydnb966_leads_score_rules_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_rule` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_segments`
--

CREATE TABLE `8ydnb966_leads_segments` (
  `id` int UNSIGNED NOT NULL,
  `rules` json NOT NULL,
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_segments_lang`
--

CREATE TABLE `8ydnb966_leads_segments_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_segment` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_segments_rel`
--

CREATE TABLE `8ydnb966_leads_segments_rel` (
  `id_segment` int UNSIGNED NOT NULL,
  `id_lead` int UNSIGNED NOT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_settings_status`
--

CREATE TABLE `8ydnb966_leads_settings_status` (
  `id` int UNSIGNED NOT NULL,
  `color_text` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `color_background` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#999999',
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `note` varchar(999) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `system_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `is_default` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_settings_status`
--

INSERT INTO `8ydnb966_leads_settings_status` (`id`, `color_text`, `color_background`, `icon`, `note`, `system_type`, `is_active`, `is_default`, `sort`, `date_add`, `date_edit`) VALUES
(1, '#ffffff', '#198754', 'fa-star', '', 'new', 1, 1, 1, '2026-05-17 09:17:17', '2026-05-17 09:17:17'),
(2, '#ffffff', '#0d6efd', '', '', 'in_progress', 1, 0, 2, '2026-05-17 09:17:17', '2026-05-17 09:17:17'),
(3, '#ffffff', '#ffc107', '', '', 'postponed', 1, 0, 3, '2026-05-17 09:17:17', '2026-05-17 09:17:17'),
(4, '#ffffff', '#20c997', '', '', 'won', 1, 0, 4, '2026-05-17 09:17:17', '2026-05-17 09:17:17'),
(5, '#ffffff', '#dc3545', '', '', 'lost', 1, 0, 5, '2026-05-17 09:17:17', '2026-05-17 09:17:17');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_settings_status_lang`
--

CREATE TABLE `8ydnb966_leads_settings_status_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_status` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_settings_status_lang`
--

INSERT INTO `8ydnb966_leads_settings_status_lang` (`id`, `id_status`, `id_lang`, `name`) VALUES
(1, 1, 1, 'New'),
(2, 1, 2, 'Новий'),
(3, 2, 1, 'In progress'),
(4, 2, 2, 'В обробці'),
(5, 3, 1, 'Postponed'),
(6, 3, 2, 'Відкладено'),
(7, 4, 1, 'Won'),
(8, 4, 2, 'Виграно'),
(9, 5, 1, 'Lost'),
(10, 5, 2, 'Програно');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_sla_log`
--

CREATE TABLE `8ydnb966_leads_sla_log` (
  `id` int UNSIGNED NOT NULL,
  `id_lead` int UNSIGNED NOT NULL,
  `id_sla_rule` int UNSIGNED DEFAULT NULL,
  `breach_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deadline_at` datetime NOT NULL,
  `breached_at` datetime NOT NULL,
  `overdue_min` int UNSIGNED NOT NULL DEFAULT '0',
  `id_manager` int UNSIGNED DEFAULT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_sla_rules`
--

CREATE TABLE `8ydnb966_leads_sla_rules` (
  `id` int UNSIGNED NOT NULL,
  `id_pipeline` int UNSIGNED DEFAULT NULL,
  `id_stage` int UNSIGNED DEFAULT NULL,
  `response_hours` smallint UNSIGNED NOT NULL DEFAULT '0',
  `stage_hours` smallint UNSIGNED NOT NULL DEFAULT '0',
  `breach_actions` json DEFAULT NULL,
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_sla_rules_lang`
--

CREATE TABLE `8ydnb966_leads_sla_rules_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_sla_rule` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_sources`
--

CREATE TABLE `8ydnb966_leads_sources` (
  `id` int UNSIGNED NOT NULL,
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_sources`
--

INSERT INTO `8ydnb966_leads_sources` (`id`, `is_active`, `sort`, `date_add`, `date_edit`) VALUES
(1, 1, 1, '2026-05-17 09:17:17', '2026-05-17 09:17:17'),
(2, 1, 2, '2026-05-17 09:17:17', '2026-05-17 09:17:17'),
(3, 1, 3, '2026-05-17 09:17:17', '2026-05-17 09:17:17'),
(4, 1, 4, '2026-05-17 09:17:17', '2026-05-17 09:17:17'),
(5, 1, 5, '2026-05-17 09:17:17', '2026-05-17 09:17:17');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_sources_lang`
--

CREATE TABLE `8ydnb966_leads_sources_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_source` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_sources_lang`
--

INSERT INTO `8ydnb966_leads_sources_lang` (`id`, `id_source`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Website'),
(2, 1, 2, 'Сайт'),
(3, 2, 1, 'Google Ads'),
(4, 2, 2, 'Google Ads'),
(5, 3, 1, 'Facebook'),
(6, 3, 2, 'Facebook'),
(7, 4, 1, 'Referral'),
(8, 4, 2, 'Реферал'),
(9, 5, 1, 'Manual'),
(10, 5, 2, 'Вручну');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_tags`
--

CREATE TABLE `8ydnb966_leads_tags` (
  `id` int UNSIGNED NOT NULL,
  `color` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#cccccc',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_tags`
--

INSERT INTO `8ydnb966_leads_tags` (`id`, `color`, `is_active`, `sort`, `date_add`, `date_edit`) VALUES
(1, '#0d6efd', 1, 1, '2026-05-17 09:17:18', '2026-05-17 09:17:18'),
(2, '#dc3545', 1, 2, '2026-05-17 09:17:18', '2026-05-17 09:17:18'),
(3, '#198754', 1, 3, '2026-05-17 09:17:18', '2026-05-17 09:17:18');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_tags_lang`
--

CREATE TABLE `8ydnb966_leads_tags_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_tag` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_tags_lang`
--

INSERT INTO `8ydnb966_leads_tags_lang` (`id`, `id_tag`, `id_lang`, `name`) VALUES
(1, 1, 1, 'VIP'),
(2, 1, 2, 'VIP'),
(3, 2, 1, 'Urgent'),
(4, 2, 2, 'Терміново'),
(5, 3, 1, 'Wholesale'),
(6, 3, 2, 'Опт');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_tags_rel`
--

CREATE TABLE `8ydnb966_leads_tags_rel` (
  `id_lead` int UNSIGNED NOT NULL,
  `id_tag` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_tags_rel`
--

INSERT INTO `8ydnb966_leads_tags_rel` (`id_lead`, `id_tag`) VALUES
(1, 1),
(1, 2),
(3, 1),
(3, 3),
(6, 1);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_temperatures`
--

CREATE TABLE `8ydnb966_leads_temperatures` (
  `id` int UNSIGNED NOT NULL,
  `slug` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color_text` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `color_background` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#6c757d',
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `sort` int UNSIGNED NOT NULL DEFAULT '0',
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_temperatures`
--

INSERT INTO `8ydnb966_leads_temperatures` (`id`, `slug`, `color_text`, `color_background`, `icon`, `sort`, `is_active`, `date_add`, `date_edit`) VALUES
(1, 'cold', '#0dcaf0', '#e7f8fd', 'fa-snowflake', 1, 1, '2026-05-17 19:16:28', '2026-05-17 19:16:28'),
(2, 'warm', '#000000', '#fff3cd', 'fa-sun', 2, 1, '2026-05-17 19:16:28', '2026-05-17 19:16:28'),
(3, 'hot', '#ffffff', '#dc3545', 'fa-fire', 3, 1, '2026-05-17 19:16:28', '2026-05-17 19:16:28');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_temperatures_lang`
--

CREATE TABLE `8ydnb966_leads_temperatures_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_temperature` int UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_leads_temperatures_lang`
--

INSERT INTO `8ydnb966_leads_temperatures_lang` (`id`, `id_temperature`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Cold'),
(2, 1, 2, 'Холодний'),
(3, 2, 1, 'Warm'),
(4, 2, 2, 'Теплий'),
(5, 3, 1, 'Hot'),
(6, 3, 2, 'Гарячий');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_webhooks`
--

CREATE TABLE `8ydnb966_leads_webhooks` (
  `id` int UNSIGNED NOT NULL,
  `url` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `events` json NOT NULL,
  `method` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'POST',
  `headers` json DEFAULT NULL,
  `secret` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `note` varchar(999) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_leads_webhooks_log`
--

CREATE TABLE `8ydnb966_leads_webhooks_log` (
  `id` int UNSIGNED NOT NULL,
  `id_webhook` int UNSIGNED NOT NULL,
  `id_lead` int UNSIGNED DEFAULT NULL,
  `event` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` json DEFAULT NULL,
  `response_code` smallint UNSIGNED DEFAULT NULL,
  `response_body` text COLLATE utf8mb4_unicode_ci,
  `result` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'success',
  `attempt` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_mail_accounts`
--

CREATE TABLE `8ydnb966_mail_accounts` (
  `id` int UNSIGNED NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Назва акаунту',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Опис призначення',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Акаунт за замовчуванням',
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Відправлення увімкнено',
  `driver` enum('smtp','sendmail','mailgun','ses') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'smtp',
  `host` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `port` smallint UNSIGNED NOT NULL DEFAULT '587',
  `encryption` enum('tls','ssl','none') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'tls',
  `verify_ssl` tinyint(1) NOT NULL DEFAULT '1',
  `timeout` smallint UNSIGNED NOT NULL DEFAULT '30' COMMENT 'Секунди',
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `password` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Зберігати зашифрованим',
  `from_email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `from_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reply_to` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `bounce_address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Return-Path',
  `log_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `log_level` enum('all','errors') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'all',
  `log_retention` smallint UNSIGNED NOT NULL DEFAULT '30' COMMENT 'Днів',
  `queue_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `retry_count` tinyint UNSIGNED NOT NULL DEFAULT '3',
  `retry_delay` smallint UNSIGNED NOT NULL DEFAULT '60' COMMENT 'Секунди',
  `rate_per_hour` smallint UNSIGNED NOT NULL DEFAULT '500',
  `send_delay_ms` smallint UNSIGNED NOT NULL DEFAULT '100' COMMENT 'Мс між листами',
  `charset` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'utf-8',
  `content_type` enum('text/html','text/plain','both') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'text/html',
  `connection_status` tinyint(1) DEFAULT NULL COMMENT '1=OK, 0=Помилка, NULL=не перевірялось',
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Поштові акаунти CRM';

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_notifications`
--

CREATE TABLE `8ydnb966_notifications` (
  `id` int NOT NULL,
  `type` int NOT NULL,
  `data` json NOT NULL,
  `is_read` int NOT NULL,
  `groups` int NOT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_notification_reads`
--

CREATE TABLE `8ydnb966_notification_reads` (
  `notification_id` int NOT NULL,
  `manager_id` int NOT NULL,
  `read_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_notif_subscriptions`
--

CREATE TABLE `8ydnb966_notif_subscriptions` (
  `user_id` bigint NOT NULL,
  `topic` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders`
--

CREATE TABLE `8ydnb966_orders` (
  `id` bigint UNSIGNED NOT NULL,
  `id_integration` int DEFAULT NULL,
  `external_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ID замовлення в CMS/маркетплейсі',
  `external_number` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Людський номер у джерелі',
  `external_cart_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `secure_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Внутрішній номер CRM',
  `source_channel` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'web/phone/marketplace/instagram',
  `id_client` int NOT NULL DEFAULT '0',
  `client` json NOT NULL,
  `status` int NOT NULL COMMENT 'FK orders_status (поточний)',
  `financial_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT 'pending/authorized/paid/partially_paid/partially_refunded/refunded/voided',
  `fulfillment_status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unfulfilled' COMMENT 'unfulfilled/partial/fulfilled/returned',
  `is_paid` tinyint(1) NOT NULL DEFAULT '0',
  `is_shipped` tinyint(1) NOT NULL DEFAULT '0',
  `is_canceled` tinyint(1) NOT NULL DEFAULT '0',
  `currency` int NOT NULL COMMENT 'FK orders_currency',
  `currency_iso` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH',
  `currency_rate` decimal(20,10) NOT NULL DEFAULT '1.0000000000' COMMENT 'Курс до базової на момент',
  `id_lang` int NOT NULL DEFAULT '2',
  `total_products` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_discount` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_discount_base` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_shipping` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_wrapping` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_tax` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_tips` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total` decimal(15,4) NOT NULL DEFAULT '0.0000' COMMENT 'Підсумок до сплати',
  `total_base` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_paid` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_paid_base` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_refunded` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_refunded_base` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_fees` decimal(15,4) NOT NULL DEFAULT '0.0000' COMMENT 'Комісії маркетплейсу',
  `total_fees_base` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `delivery` int DEFAULT NULL COMMENT 'FK orders_delivery',
  `payment` int DEFAULT NULL COMMENT 'FK orders_payment',
  `is_gift` tinyint(1) NOT NULL DEFAULT '0',
  `gift_message` varchar(999) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custom_fields` json DEFAULT NULL,
  `note` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ip` varbinary(16) DEFAULT NULL COMMENT 'INET6_ATON',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_user` int DEFAULT NULL COMMENT 'Відповідальний менеджер',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL,
  `date_order` datetime DEFAULT NULL COMMENT 'Дата в джерелі (може ≠ date_add)',
  `deleted_at` datetime DEFAULT NULL COMMENT 'Soft delete',
  `revision` int NOT NULL DEFAULT '0' COMMENT 'Лічильник змін (монотонний)',
  `sync_hash` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Хеш останнього синхронізованого стану джерела (echo-захист)',
  `external_updated_at` datetime DEFAULT NULL COMMENT 'Мітка часу зміни на боці джерела (для конфліктів статусу)',
  `date_order_day` date GENERATED ALWAYS AS (cast(coalesce(`date_order`,`date_add`) as date)) STORED,
  `base_currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_abandoned_cart`
--

CREATE TABLE `8ydnb966_orders_abandoned_cart` (
  `id` int UNSIGNED NOT NULL,
  `store_id` int UNSIGNED NOT NULL,
  `id_integration` int UNSIGNED DEFAULT NULL,
  `id_customer` int UNSIGNED DEFAULT NULL,
  `id_client` int UNSIGNED DEFAULT NULL,
  `id_order` int UNSIGNED DEFAULT NULL COMMENT 'Відновлене замовлення (без FK — гаряча таблиця)',
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `external_cart_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH',
  `total_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `items_count` int UNSIGNED NOT NULL DEFAULT '0',
  `sync_hash` char(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'sha256 знімка — echo-suppression',
  `status` enum('active','abandoned','notified','recovered','expired') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `cart` json NOT NULL,
  `utm_source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `utm_medium` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `utm_campaign` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_seen_at` datetime NOT NULL,
  `last_activity_at` datetime NOT NULL,
  `recovered_at` datetime DEFAULT NULL,
  `reconciled_at` datetime DEFAULT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_abandoned_cart_events`
--

CREATE TABLE `8ydnb966_orders_abandoned_cart_events` (
  `id` int UNSIGNED NOT NULL,
  `service_id` int UNSIGNED NOT NULL,
  `id_integration` int UNSIGNED DEFAULT NULL COMMENT 'NULL = усі сайти; інакше — конкретне джерело',
  `store_id` int UNSIGNED DEFAULT NULL COMMENT 'NULL = будь-який стор джерела',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `delay_hours` int UNSIGNED NOT NULL DEFAULT '24',
  `send_time_from` time DEFAULT '09:00:00' COMMENT 'Початок вікна відправлення',
  `send_time_to` time DEFAULT '20:00:00' COMMENT 'Кінець вікна відправлення',
  `send_slot_1` time DEFAULT '10:00:00' COMMENT 'Перший час відправлення',
  `send_slot_2` time DEFAULT NULL COMMENT 'Другий час (необовʼязково)',
  `send_days` tinyint UNSIGNED NOT NULL DEFAULT '127' COMMENT 'Бітмаска днів Пн..Нд (127=всі)',
  `delay_minutes` int UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Додаткова затримка у хвилинах',
  `resend_mode` enum('once','once_repeat') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'once' COMMENT 'once=1 меседж, once_repeat=1+повтор',
  `repeat_after_hours` int UNSIGNED NOT NULL DEFAULT '24' COMMENT 'Через скільки годин повтор',
  `min_cart_amount` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT 'Мін. сума кошика для відправлення',
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_abandoned_cart_inbox`
--

CREATE TABLE `8ydnb966_orders_abandoned_cart_inbox` (
  `id` bigint UNSIGNED NOT NULL,
  `id_token` int UNSIGNED NOT NULL,
  `id_integration` int UNSIGNED DEFAULT NULL,
  `external_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'session_id кошика на джерелі',
  `payload` json NOT NULL,
  `status` enum('pending','processing','done','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `attempts` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `id_cart` int UNSIGNED DEFAULT NULL COMMENT 'Заповнюється воркером після upsert',
  `ip` varbinary(16) DEFAULT NULL,
  `last_error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `locked_at` datetime DEFAULT NULL,
  `received_at` datetime NOT NULL,
  `processed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_abandoned_cart_log`
--

CREATE TABLE `8ydnb966_orders_abandoned_cart_log` (
  `id` int UNSIGNED NOT NULL,
  `cart_id` int UNSIGNED NOT NULL,
  `event_id` int UNSIGNED NOT NULL,
  `attempt_no` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `source` enum('auto','manual') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'auto',
  `service_id` int UNSIGNED DEFAULT NULL,
  `channel` tinyint UNSIGNED DEFAULT NULL,
  `recipient` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `recovery_token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '0',
  `http_status` smallint UNSIGNED DEFAULT NULL,
  `request` json DEFAULT NULL,
  `error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `response` json DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_abandoned_cart_queue`
--

CREATE TABLE `8ydnb966_orders_abandoned_cart_queue` (
  `id` bigint UNSIGNED NOT NULL,
  `cart_id` int UNSIGNED NOT NULL,
  `event_id` int UNSIGNED NOT NULL,
  `service_id` int UNSIGNED NOT NULL,
  `attempt_no` tinyint UNSIGNED NOT NULL DEFAULT '1' COMMENT '1=перше, 2=повтор (once_repeat)',
  `status` enum('pending','processing','sent','failed','skipped','canceled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `run_after` datetime NOT NULL COMMENT 'Не відправляти раніше цього моменту',
  `attempts` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Лічильник спроб відправки (ретраї воркера)',
  `max_attempts` tinyint UNSIGNED NOT NULL DEFAULT '3',
  `locked_at` datetime DEFAULT NULL,
  `locked_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `recipient` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Снапшот номера на момент відправки',
  `provider_message_ids` json DEFAULT NULL COMMENT 'id повідомлень від SMSclub',
  `correlation_id` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'UUID однієї відправки — зшивання log/JSONL/status',
  `last_error` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `sent_at` datetime DEFAULT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL,
  `delivery_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Головний статус доставки (Delivered/Sent/...)',
  `delivery_extra` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'additionalStatus (Read/Blocked/...)',
  `delivery_final` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = термінальний статус, більше не опитувати',
  `delivery_checked_at` datetime DEFAULT NULL,
  `status_attempts` smallint UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_abandoned_cart_recovery`
--

CREATE TABLE `8ydnb966_orders_abandoned_cart_recovery` (
  `id` bigint UNSIGNED NOT NULL,
  `cart_id` int UNSIGNED NOT NULL,
  `token` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_integration` int UNSIGNED DEFAULT NULL,
  `store_id` int UNSIGNED DEFAULT NULL,
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `clicks` int UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Скільки разів перейшли',
  `first_click_at` datetime DEFAULT NULL,
  `last_click_at` datetime DEFAULT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_abandoned_cart_services`
--

CREATE TABLE `8ydnb966_orders_abandoned_cart_services` (
  `id` int UNSIGNED NOT NULL,
  `channel` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `provider` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `config_fields` json DEFAULT NULL,
  `config` json DEFAULT NULL,
  `is_connected` tinyint(1) NOT NULL DEFAULT '0',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_addresses`
--

CREATE TABLE `8ydnb966_orders_addresses` (
  `id` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED NOT NULL,
  `type` enum('billing','shipping') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'shipping',
  `firstname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `middlename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city_ref` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_1` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_2` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warehouse` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warehouse_ref` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postcode` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta` json DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_orders_addresses`
--

INSERT INTO `8ydnb966_orders_addresses` (`id`, `id_order`, `type`, `firstname`, `lastname`, `middlename`, `company`, `phone`, `email`, `country`, `region`, `city`, `city_ref`, `address_1`, `address_2`, `warehouse`, `warehouse_ref`, `postcode`, `meta`) VALUES
(1, 1, 'billing', 'Сергій', 'Мотчаний', NULL, NULL, '0687207605', 'test@skyneuron.com', 'UA', 'Dnipropetrovs\'ka Oblast\'', 'Місто', NULL, 'Адреса 1', NULL, NULL, NULL, '50047', NULL),
(2, 1, 'shipping', 'Сергій', 'Мотчаний', NULL, NULL, '0687207605', 'test@skyneuron.com', 'UA', 'Dnipropetrovs\'ka Oblast\'', 'Місто', NULL, 'Адреса 1', NULL, NULL, NULL, '50047', NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_clients`
--

CREATE TABLE `8ydnb966_orders_clients` (
  `id` bigint UNSIGNED NOT NULL,
  `id_integration` int DEFAULT NULL COMMENT 'Звідки прийшов (CMS/маркетплейс)',
  `external_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ID клієнта в джерелі',
  `source_channel` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'web/phone/marketplace/instagram/manual',
  `social_title` enum('mr','mrs','ms','other') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Звертання (PrestaShop social_title)',
  `firstname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `middlename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'По батькові',
  `display_name` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Готове відображуване імʼя (кеш)',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Основний email (для дедуплікації)',
  `phone` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Основний телефон, нормалізований E.164',
  `phones` json DEFAULT NULL COMMENT 'Додаткові телефони [{"phone":"","note":""}]',
  `emails` json DEFAULT NULL COMMENT 'Додаткові email',
  `messengers` json DEFAULT NULL COMMENT '{"telegram":"","viber":"","whatsapp":"","instagram":""}',
  `website` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` enum('male','female','other') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `id_lang` int NOT NULL DEFAULT '2' COMMENT 'Мова спілкування',
  `country` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ISO 3166 основної країни',
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Основне місто (кеш з адрес)',
  `timezone` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_company` tinyint(1) NOT NULL DEFAULT '0',
  `company` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_code` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ЄДРПОУ / ІПН',
  `vat_number` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ПДВ / VAT',
  `position` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Посада контактної особи',
  `company_details` json DEFAULT NULL COMMENT 'Банк, IBAN, юр.адреса тощо',
  `id_default_group` int NOT NULL DEFAULT '1',
  `type` enum('lead','customer','wholesale','vip','partner') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'customer',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=активний, 0=вимкнений',
  `is_vip` tinyint(1) NOT NULL DEFAULT '0',
  `is_blacklisted` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Чорний список',
  `blacklist_reason` varchar(999) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_manager` int DEFAULT NULL COMMENT 'Відповідальний менеджер',
  `newsletter` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Згода на email-розсилку',
  `newsletter_date` datetime DEFAULT NULL,
  `opt_in_sms` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Згода на SMS',
  `opt_in_calls` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Згода на дзвінки',
  `opt_in_partners` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Реклама партнерів (PrestaShop optin)',
  `gdpr_consent` tinyint(1) NOT NULL DEFAULT '0',
  `gdpr_consent_date` datetime DEFAULT NULL,
  `acquisition_source` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Як залучили (google/instagram/friend)',
  `utm_first` json DEFAULT NULL COMMENT 'UTM першого контакту',
  `referrer_id` bigint UNSIGNED DEFAULT NULL COMMENT 'Хто привів (реферал/спонсор)',
  `reward_points` int NOT NULL DEFAULT '0' COMMENT 'Бонусні бали (кеш SUM rewards)',
  `balance` decimal(15,4) NOT NULL DEFAULT '0.0000' COMMENT 'Грошовий стор-кредит (кеш SUM transactions)',
  `balance_currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH',
  `credit_limit` decimal(15,4) NOT NULL DEFAULT '0.0000' COMMENT 'Кредитний ліміт для B2B-постоплати',
  `orders_count` int NOT NULL DEFAULT '0',
  `orders_valid_count` int NOT NULL DEFAULT '0' COMMENT 'Підтверджені замовлення',
  `total_spent` decimal(15,4) NOT NULL DEFAULT '0.0000' COMMENT 'LTV',
  `avg_order_value` decimal(15,4) NOT NULL DEFAULT '0.0000' COMMENT 'Середній чек',
  `first_order_at` datetime DEFAULT NULL,
  `last_order_at` datetime DEFAULT NULL,
  `last_activity_at` datetime DEFAULT NULL COMMENT 'Остання активність будь-де',
  `custom_fields` json DEFAULT NULL COMMENT 'Довільні поля клієнта',
  `tags` json DEFAULT NULL COMMENT 'Теги ["опт","борг"]',
  `note` longtext COLLATE utf8mb4_unicode_ci COMMENT 'Внутрішня нотатка менеджера',
  `avatar` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ip` varbinary(16) DEFAULT NULL COMMENT 'IP реєстрації (INET6_ATON)',
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Якщо є вхід у кабінет',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL,
  `deleted_at` datetime DEFAULT NULL COMMENT 'Soft delete'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_clients_addresses`
--

CREATE TABLE `8ydnb966_orders_clients_addresses` (
  `id` bigint UNSIGNED NOT NULL,
  `id_client` bigint UNSIGNED NOT NULL,
  `alias` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Назва адреси (Дім/Офіс)',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `type` enum('billing','shipping','both') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'both',
  `firstname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `middlename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city_ref` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ID міста у службі доставки',
  `address_1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_2` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warehouse` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '№ відділення/поштомат',
  `warehouse_ref` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `postcode` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta` json DEFAULT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_clients_groups`
--

CREATE TABLE `8ydnb966_orders_clients_groups` (
  `id` int NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_percent` decimal(5,2) NOT NULL DEFAULT '0.00' COMMENT 'Знижка на весь магазин для групи',
  `tax_exempt` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Звільнення від податку (B2B)',
  `color_text` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `color_background` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#6c757d',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Група за замовчуванням для нових',
  `is_system` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Вбудована, не можна видалити',
  `note` varchar(999) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_clients_group_map`
--

CREATE TABLE `8ydnb966_orders_clients_group_map` (
  `id_client` bigint UNSIGNED NOT NULL,
  `id_group` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_clients_rewards`
--

CREATE TABLE `8ydnb966_orders_clients_rewards` (
  `id` bigint UNSIGNED NOT NULL,
  `id_client` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED DEFAULT NULL COMMENT 'Замовлення-джерело (якщо є)',
  `points` int NOT NULL COMMENT '+нарахування / −списання',
  `description` varchar(999) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Причина',
  `id_user` int DEFAULT NULL COMMENT 'Хто нарахував (NULL=система)',
  `expires_at` datetime DEFAULT NULL COMMENT 'Термін дії балів',
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_clients_transactions`
--

CREATE TABLE `8ydnb966_orders_clients_transactions` (
  `id` bigint UNSIGNED NOT NULL,
  `id_client` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED DEFAULT NULL,
  `amount` decimal(15,4) NOT NULL COMMENT '+поповнення / −списання',
  `currency` char(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH',
  `description` varchar(999) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_user` int DEFAULT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_currency`
--

CREATE TABLE `8ydnb966_orders_currency` (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `symbol` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency_iso_code` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rate` decimal(20,10) NOT NULL DEFAULT '1.0000000000' COMMENT 'Курс до базової',
  `is_base` tinyint(1) NOT NULL DEFAULT '0',
  `date_edit` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_delivery`
--

CREATE TABLE `8ydnb966_orders_delivery` (
  `id` int NOT NULL,
  `color_text` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `color_background` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL,
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_delivery_lang`
--

CREATE TABLE `8ydnb966_orders_delivery_lang` (
  `id` int NOT NULL,
  `id_delivery` int NOT NULL,
  `id_lang` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_discounts`
--

CREATE TABLE `8ydnb966_orders_discounts` (
  `id` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED NOT NULL,
  `code` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_documents`
--

CREATE TABLE `8ydnb966_orders_documents` (
  `id` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED NOT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'invoice/delivery_slip/credit_slip/label',
  `id_ref` bigint UNSIGNED DEFAULT NULL,
  `number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_path` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_events`
--

CREATE TABLE `8ydnb966_orders_events` (
  `id` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED NOT NULL,
  `id_user` int DEFAULT NULL,
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` json DEFAULT NULL,
  `source` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'manual',
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_fees`
--

CREATE TABLE `8ydnb966_orders_fees` (
  `id` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED NOT NULL,
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_inbox`
--

CREATE TABLE `8ydnb966_orders_inbox` (
  `id` bigint UNSIGNED NOT NULL,
  `id_token` bigint UNSIGNED DEFAULT NULL COMMENT 'Яким токеном прийнято',
  `id_integration` int DEFAULT NULL,
  `external_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ID у джерелі (для дедуплікації)',
  `payload` json NOT NULL COMMENT 'Сирий конверт як прийшов',
  `status` enum('pending','processing','done','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `attempts` int NOT NULL DEFAULT '0',
  `last_error` varchar(999) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_order` bigint UNSIGNED DEFAULT NULL COMMENT 'Створене замовлення (коли done)',
  `ip` varbinary(16) DEFAULT NULL,
  `received_at` datetime NOT NULL,
  `locked_at` datetime DEFAULT NULL COMMENT 'Коли воркер узяв у роботу (для реклейму зависань)',
  `processed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_integrations`
--

CREATE TABLE `8ydnb966_orders_integrations` (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Людська назва (напр. "OpenCart — основний сайт")',
  `color_text` varchar(9) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color_background` varchar(9) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `platform` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'opencart/woocommerce/prestashop/amazon...',
  `base_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Базовий URL магазину https://shop.com',
  `callback_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Куди CRM шле зміни назад (endpoint на боці сайту)',
  `outbound_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Токен, яким CRM автентифікується на сайті (сайт його видав)',
  `sync_orders_out` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Слати зміни замовлень CRM→сайт',
  `sync_status_out` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Слати зміни статусу CRM→сайт',
  `status` enum('active','disabled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `note` varchar(999) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_invoices`
--

CREATE TABLE `8ydnb966_orders_invoices` (
  `id` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED NOT NULL,
  `number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `number_prefix` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `shop_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `total_products_tax_excl` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_products_tax_incl` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_discount_tax_excl` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_discount_tax_incl` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_shipping_tax_excl` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_shipping_tax_incl` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_wrapping_tax_excl` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_wrapping_tax_incl` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_paid_tax_excl` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_paid_tax_incl` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_invoices_tax`
--

CREATE TABLE `8ydnb966_orders_invoices_tax` (
  `id` bigint UNSIGNED NOT NULL,
  `id_invoice` bigint UNSIGNED NOT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'products',
  `rate` decimal(6,4) NOT NULL DEFAULT '0.0000',
  `amount` decimal(15,4) NOT NULL DEFAULT '0.0000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_items`
--

CREATE TABLE `8ydnb966_orders_items` (
  `id` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED NOT NULL,
  `id_product` bigint UNSIGNED DEFAULT NULL,
  `external_product_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sku` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'product',
  `quantity` decimal(12,3) NOT NULL DEFAULT '1.000',
  `unit_price` decimal(15,4) NOT NULL DEFAULT '0.0000' COMMENT 'За од. без податку',
  `unit_price_wt` decimal(15,4) NOT NULL DEFAULT '0.0000' COMMENT 'За од. з податком',
  `discount` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `tax_rate` decimal(6,4) NOT NULL DEFAULT '0.0000' COMMENT '0.2000 = 20%',
  `total` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `total_base` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `attributes` json DEFAULT NULL,
  `meta` json DEFAULT NULL,
  `cost_price` decimal(15,4) DEFAULT NULL COMMENT 'Собівартість за од. на момент продажу'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_meta`
--

CREATE TABLE `8ydnb966_orders_meta` (
  `id` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED NOT NULL,
  `meta_key` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_notes`
--

CREATE TABLE `8ydnb966_orders_notes` (
  `id` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED NOT NULL,
  `id_user` int DEFAULT NULL,
  `is_private` tinyint(1) NOT NULL DEFAULT '1',
  `text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_outbox`
--

CREATE TABLE `8ydnb966_orders_outbox` (
  `id` bigint UNSIGNED NOT NULL,
  `id_integration` int NOT NULL COMMENT 'Куди слати (FK orders_integrations)',
  `id_order` bigint UNSIGNED NOT NULL,
  `external_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ID замовлення в джерелі (щоб сайт знайшов своє)',
  `event_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'status_change / order_updated',
  `payload` json NOT NULL COMMENT 'Що саме змінилось (готове до відправлення)',
  `status` enum('pending','processing','done','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `attempts` int NOT NULL DEFAULT '0',
  `last_error` varchar(999) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `http_status` int DEFAULT NULL COMMENT 'Код відповіді сайту',
  `date_add` datetime NOT NULL,
  `locked_at` datetime DEFAULT NULL,
  `processed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_payment`
--

CREATE TABLE `8ydnb966_orders_payment` (
  `id` int NOT NULL,
  `code` varchar(64) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT 'cash/cod/liqpay/wayforpay/bank_invoice',
  `color_text` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#ffffff',
  `color_background` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#6c757d',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_online` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Проходить через платіжний шлюз',
  `is_prepaid` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Передоплата до відвантаження',
  `is_cod` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Накладений платіж',
  `is_system` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Вбудований, не видаляється',
  `id_status_default` int DEFAULT NULL COMMENT 'FK orders_status — стартовий статус для методу',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_payments`
--

CREATE TABLE `8ydnb966_orders_payments` (
  `id` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED NOT NULL,
  `id_integration` int DEFAULT NULL,
  `id_payment` int DEFAULT NULL,
  `id_payment_method` int DEFAULT NULL COMMENT 'FK orders_payment (метод)',
  `id_gateway` int DEFAULT NULL COMMENT 'FK orders_payment_gateway',
  `driver` varchar(64) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL COMMENT 'Драйвер (для дедуплікації)',
  `transaction_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Рекурентний токен картки',
  `signature_valid` tinyint(1) DEFAULT NULL COMMENT 'Чи пройшла криптоперевірка підпису',
  `amount` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `amount_base` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `currency_iso` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UAH',
  `id_currency` int DEFAULT NULL COMMENT 'FK orders_currency',
  `status` enum('pending','authorized','paid','failed','refunded','partially_refunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `gateway_status` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Сирий статус шлюзу',
  `paid_at` datetime DEFAULT NULL,
  `raw` json DEFAULT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_payment_gateway`
--

CREATE TABLE `8ydnb966_orders_payment_gateway` (
  `id` int NOT NULL,
  `id_payment` int NOT NULL COMMENT 'FK orders_payment',
  `id_integration` int DEFAULT NULL COMMENT 'null = для всіх сайтів',
  `driver` varchar(64) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT 'liqpay/wayforpay — адаптер у коді',
  `is_test` tinyint(1) NOT NULL DEFAULT '0',
  `public_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `secret_key` varbinary(512) DEFAULT NULL COMMENT 'Зашифровано (AES) — НЕ plaintext',
  `webhook_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `extra_config` json DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_payment_inbox`
--

CREATE TABLE `8ydnb966_orders_payment_inbox` (
  `id` bigint UNSIGNED NOT NULL,
  `driver` varchar(64) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL COMMENT 'liqpay/wayforpay',
  `id_integration` int DEFAULT NULL,
  `id_gateway` int DEFAULT NULL COMMENT 'Яким конфігом прийнято (після резолву)',
  `external_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'transaction_id/orderReference — дедуплікація',
  `id_order` bigint UNSIGNED DEFAULT NULL COMMENT 'Резолв замовлення',
  `signature_valid` tinyint(1) DEFAULT NULL COMMENT 'Результат перевірки підпису',
  `payload` json NOT NULL COMMENT 'Сирий callback',
  `headers` json DEFAULT NULL COMMENT 'HTTP-заголовки',
  `status` enum('pending','processing','done','failed','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `attempts` int NOT NULL DEFAULT '0',
  `last_error` varchar(999) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_payment_txn` bigint UNSIGNED DEFAULT NULL COMMENT 'Створена/оновлена транзакція',
  `ip` varbinary(16) DEFAULT NULL,
  `received_at` datetime NOT NULL,
  `locked_at` datetime DEFAULT NULL,
  `processed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_payment_lang`
--

CREATE TABLE `8ydnb966_orders_payment_lang` (
  `id` int NOT NULL,
  `id_payment` int NOT NULL,
  `id_lang` int NOT NULL,
  `text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_payment_map`
--

CREATE TABLE `8ydnb966_orders_payment_map` (
  `id` int NOT NULL,
  `id_integration` int DEFAULT NULL COMMENT 'null = загальний',
  `external_code` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'method_code з джерела',
  `external_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'method_title як прийшов (дебаг)',
  `id_payment` int DEFAULT NULL COMMENT 'FK orders_payment; NULL = потребує ручного мапінгу',
  `direction` enum('in','out','both') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'both',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_payment_status_map`
--

CREATE TABLE `8ydnb966_orders_payment_status_map` (
  `id` int NOT NULL,
  `driver` varchar(64) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `gateway_status` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'success/Approved/wait_accept...',
  `crm_status` enum('pending','authorized','paid','failed','refunded','partially_refunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_raw`
--

CREATE TABLE `8ydnb966_orders_raw` (
  `id_order` bigint UNSIGNED NOT NULL,
  `payload` json NOT NULL,
  `received_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_refunds`
--

CREATE TABLE `8ydnb966_orders_refunds` (
  `id` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED NOT NULL,
  `number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `amount_base` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `shipping_refunded` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `restock` tinyint(1) NOT NULL DEFAULT '0',
  `id_user` int DEFAULT NULL,
  `transaction_id` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `raw` json DEFAULT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_refunds_items`
--

CREATE TABLE `8ydnb966_orders_refunds_items` (
  `id` bigint UNSIGNED NOT NULL,
  `id_refund` bigint UNSIGNED NOT NULL,
  `id_order_item` bigint UNSIGNED DEFAULT NULL,
  `quantity` decimal(12,3) NOT NULL DEFAULT '0.000',
  `amount` decimal(15,4) NOT NULL DEFAULT '0.0000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_shipments`
--

CREATE TABLE `8ydnb966_orders_shipments` (
  `id` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED NOT NULL,
  `carrier` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tracking_number` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cost` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `weight` decimal(12,3) DEFAULT NULL,
  `shipped_at` datetime DEFAULT NULL,
  `delivered_at` datetime DEFAULT NULL,
  `items` json DEFAULT NULL,
  `raw` json DEFAULT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_stats_cash_daily`
--

CREATE TABLE `8ydnb966_orders_stats_cash_daily` (
  `day` date NOT NULL,
  `id_integration` int NOT NULL DEFAULT '0',
  `paid_base` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `refunded_base` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `payments_count` int NOT NULL DEFAULT '0',
  `refunds_count` int NOT NULL DEFAULT '0',
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_stats_daily`
--

CREATE TABLE `8ydnb966_orders_stats_daily` (
  `day` date NOT NULL,
  `id_integration` int NOT NULL DEFAULT '0',
  `orders_count` int NOT NULL DEFAULT '0',
  `orders_valid` int NOT NULL DEFAULT '0',
  `orders_confirmed` int NOT NULL DEFAULT '0',
  `orders_canceled` int NOT NULL DEFAULT '0',
  `revenue_gross_base` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `revenue_confirmed_base` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `refunded_base` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `fees_base` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `discount_base` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `shipping_base` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `items_qty` decimal(18,3) NOT NULL DEFAULT '0.000',
  `new_clients` int NOT NULL DEFAULT '0',
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_stats_daily_channel`
--

CREATE TABLE `8ydnb966_orders_stats_daily_channel` (
  `day` date NOT NULL,
  `id_integration` int NOT NULL DEFAULT '0',
  `source_channel` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `orders_count` int NOT NULL DEFAULT '0',
  `revenue_base` decimal(18,4) NOT NULL DEFAULT '0.0000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_stats_daily_product`
--

CREATE TABLE `8ydnb966_orders_stats_daily_product` (
  `day` date NOT NULL,
  `id_integration` int NOT NULL DEFAULT '0',
  `sku` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `name` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `qty` decimal(18,3) NOT NULL DEFAULT '0.000',
  `revenue_base` decimal(18,4) NOT NULL DEFAULT '0.0000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_stats_daily_status`
--

CREATE TABLE `8ydnb966_orders_stats_daily_status` (
  `day` date NOT NULL,
  `id_integration` int NOT NULL DEFAULT '0',
  `id_status` int NOT NULL,
  `orders_count` int NOT NULL DEFAULT '0',
  `revenue_base` decimal(18,4) NOT NULL DEFAULT '0.0000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_status`
--

CREATE TABLE `8ydnb966_orders_status` (
  `id` int NOT NULL,
  `color_text` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `color_background` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL,
  `logable` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Вважати замовлення підтвердженим',
  `count_in_revenue` tinyint(1) NOT NULL DEFAULT '0',
  `is_final` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Термінальний статус — далі не рухається',
  `is_negative` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Скасування/повернення/фрод — виключати з виручки',
  `invoice` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Дозволити перегляд/завантаження PDF рахунку',
  `hidden` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Приховати статус у замовленнях клієнта',
  `send_email` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Надсилати email при зміні статусу',
  `pdf_invoice` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Додати PDF-рахунок до email',
  `pdf_delivery` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Додати транспортну PDF-накладну до email',
  `shipped` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Позначити замовлення як доставлене',
  `paid` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Позначити замовлення як оплачене',
  `delivery` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Показати PDF про доставку',
  `id_template` int DEFAULT NULL COMMENT 'FK на шаблон листа'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_orders_status`
--

INSERT INTO `8ydnb966_orders_status` (`id`, `color_text`, `color_background`, `icon`, `date_add`, `date_edit`, `logable`, `count_in_revenue`, `is_final`, `is_negative`, `invoice`, `hidden`, `send_email`, `pdf_invoice`, `pdf_delivery`, `shipped`, `paid`, `delivery`, `id_template`) VALUES
(1, '#ffffff', '#f39c12', 'fa-solid fa-hourglass-half', '2026-08-14 14:19:09', '2026-08-22 02:40:19', 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, NULL),
(2, '#ffffff', '#2fb25c', 'fa-solid fa-circle-check', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 0, NULL),
(3, '#ffffff', '#e74c3c', 'fa-solid fa-triangle-exclamation', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, NULL),
(4, '#ffffff', '#3498db', 'fa-solid fa-clipboard-check', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, NULL),
(5, '#ffffff', '#5dade2', 'fa-solid fa-list-check', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, NULL),
(6, '#ffffff', '#8e44ad', 'fa-solid fa-truck-fast', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, NULL),
(7, '#ffffff', '#27ae60', 'fa-solid fa-box', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 0, NULL),
(8, '#ffffff', '#16a085', 'fa-solid fa-check', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, NULL),
(9, '#ffffff', '#c0392b', 'fa-solid fa-circle-xmark', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, NULL),
(10, '#ffffff', '#ec7063', 'fa-solid fa-hand-holding-dollar', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, NULL),
(11, '#ffffff', '#d35400', 'fa-solid fa-arrow-rotate-left', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, NULL),
(12, '#333333', '#f1c40f', 'fa-solid fa-boxes-stacked', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, NULL),
(13, '#ffffff', '#e67e22', 'fa-solid fa-money-bill', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL),
(14, '#ffffff', '#af7ac5', 'fa-solid fa-wallet', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL),
(15, '#ffffff', '#7f8c8d', 'fa-solid fa-rotate-left', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
(16, '#ffffff', '#95a5a6', 'fa-solid fa-ban', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, NULL),
(17, '#ffffff', '#34495e', 'fa-solid fa-clock', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL),
(18, '#ffffff', '#922b21', 'fa-solid fa-shield-halved', '2026-08-14 14:19:09', '2026-08-14 14:19:09', 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_status_history`
--

CREATE TABLE `8ydnb966_orders_status_history` (
  `id` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED NOT NULL,
  `id_status` int NOT NULL,
  `id_status_old` int DEFAULT NULL,
  `duration_sec` int UNSIGNED DEFAULT NULL COMMENT 'Скільки секунд замовлення пробуло у ПОПЕРЕДНЬОМУ статусі',
  `id_user` int DEFAULT NULL,
  `source` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'manual',
  `comment` varchar(999) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notified` tinyint(1) NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_status_lang`
--

CREATE TABLE `8ydnb966_orders_status_lang` (
  `id` int NOT NULL,
  `id_status` int NOT NULL,
  `id_lang` int NOT NULL,
  `text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_orders_status_lang`
--

INSERT INTO `8ydnb966_orders_status_lang` (`id`, `id_status`, `id_lang`, `text`) VALUES
(21, 2, 1, 'Payment accepted'),
(22, 2, 2, 'Оплата прийнята'),
(23, 3, 1, 'Payment error'),
(24, 3, 2, 'Помилка оплати'),
(25, 4, 1, 'Processing'),
(26, 4, 2, 'Обробляється'),
(27, 5, 1, 'Preparing'),
(28, 5, 2, 'Комплектується'),
(29, 6, 1, 'Shipped'),
(30, 6, 2, 'Відправлено'),
(31, 7, 1, 'Delivered'),
(32, 7, 2, 'Доставлено'),
(33, 8, 1, 'Completed'),
(34, 8, 2, 'Виконано'),
(35, 9, 1, 'Canceled'),
(36, 9, 2, 'Скасовано'),
(37, 10, 1, 'Refunded'),
(38, 10, 2, 'Кошти повернено'),
(39, 11, 1, 'Returned'),
(40, 11, 2, 'Повернення товару'),
(41, 12, 1, 'On backorder'),
(42, 12, 2, 'Очікування товару'),
(43, 13, 1, 'Awaiting bank wire payment'),
(44, 13, 2, 'Очікування банківського переказу'),
(45, 14, 1, 'Awaiting cash on delivery'),
(46, 14, 2, 'Очікування накладеного платежу'),
(47, 15, 1, 'Chargeback'),
(48, 15, 2, 'Зворотний платіж'),
(49, 16, 1, 'Failed'),
(50, 16, 2, 'Невдале'),
(51, 17, 1, 'On hold'),
(52, 17, 2, 'Призупинено'),
(53, 18, 1, 'Suspected fraud'),
(54, 18, 2, 'Підозра шахрайства'),
(55, 1, 1, 'Awaiting payment'),
(56, 1, 2, 'Очікування оплати');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_status_map`
--

CREATE TABLE `8ydnb966_orders_status_map` (
  `id` int NOT NULL,
  `id_integration` int DEFAULT NULL COMMENT 'Для якої інтеграції (null = загальна)',
  `external_status` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Сирий статус джерела (код або id)',
  `id_status` int NOT NULL COMMENT 'FK orders_status — внутрішній статус CRM',
  `direction` enum('in','out','both') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'both' COMMENT 'in=сайт→CRM, out=CRM→сайт',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_orders_status_map`
--

INSERT INTO `8ydnb966_orders_status_map` (`id`, `id_integration`, `external_status`, `id_status`, `direction`, `date_add`, `date_edit`) VALUES
(1, NULL, '1', 17, 'both', '2026-08-19 01:51:15', '2026-08-19 01:51:15'),
(2, NULL, '2', 4, 'both', '2026-08-19 01:51:15', '2026-08-19 01:51:15'),
(3, NULL, '3', 6, 'both', '2026-08-19 01:51:15', '2026-08-19 01:51:15'),
(4, NULL, '5', 8, 'both', '2026-08-19 01:51:15', '2026-08-19 01:51:15'),
(5, NULL, '7', 3, 'both', '2026-08-19 01:51:15', '2026-08-19 01:51:15'),
(6, NULL, '8', 16, 'both', '2026-08-19 01:51:15', '2026-08-19 01:51:15'),
(7, NULL, '9', 16, 'both', '2026-08-19 01:51:15', '2026-08-19 01:51:15'),
(8, NULL, '10', 11, 'both', '2026-08-19 01:51:15', '2026-08-19 01:51:15'),
(9, NULL, '11', 9, 'both', '2026-08-19 01:51:15', '2026-08-19 01:51:15'),
(10, NULL, '12', 4, 'both', '2026-08-19 01:51:15', '2026-08-19 01:51:15'),
(11, NULL, '13', 6, 'both', '2026-08-19 01:51:15', '2026-08-19 01:51:15'),
(12, NULL, '14', 1, 'both', '2026-08-19 01:51:15', '2026-08-19 01:51:15'),
(13, NULL, '15', 18, 'both', '2026-08-19 01:51:15', '2026-08-19 01:51:15'),
(14, NULL, '16', 9, 'both', '2026-08-19 01:51:15', '2026-08-19 01:51:15');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_tokens`
--

CREATE TABLE `8ydnb966_orders_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Людська назва (напр. "OpenCart — основний сайт")',
  `prefix` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Перші символи для впізнавання в списку (напр. ok_live_a3f9)',
  `token_hash` char(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'SHA-256 повного токена (сам токен НЕ зберігаємо)',
  `last4` varchar(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Останні символи для впізнавання (…a3f9)',
  `environment` enum('live','test') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'live' COMMENT 'Робочий / тестовий ключ',
  `id_integration` int DEFAULT NULL COMMENT 'Який магазин/CMS цим токеном користується',
  `id_user` int DEFAULT NULL COMMENT 'Хто створив токен',
  `allowed_domains` json DEFAULT NULL COMMENT 'Дозволені домени ["shop.com","www.shop.com"]; null/[] = будь-який',
  `allowed_ips` json DEFAULT NULL COMMENT 'Дозволені IP/CIDR ["1.2.3.4","10.0.0.0/24"]; null/[] = будь-який',
  `source_check_mode` enum('any','all','off') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'any' COMMENT 'any=досить одного збігу (домен АБО ip); all=обидва обовʼязкові; off=не перевіряти джерело',
  `can_create_orders` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Приймати нові замовлення',
  `can_update_orders` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Оновлювати наявні замовлення',
  `can_update_status` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Змінювати статус замовлення',
  `can_create_clients` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Створювати/оновлювати клієнтів',
  `can_read` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Читати дані (віддавати назад у CMS)',
  `can_sync_carts` tinyint(1) NOT NULL DEFAULT '0',
  `rate_limit_per_min` int DEFAULT NULL COMMENT 'Макс. запитів за хвилину; null = без ліміту',
  `max_daily` int DEFAULT NULL COMMENT 'Макс. замовлень на добу; null = без ліміту',
  `status` enum('active','disabled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active' COMMENT 'Активний / тимчасово вимкнений',
  `expires_at` datetime DEFAULT NULL COMMENT 'Термін дії; null = безстроковий',
  `revoked_at` datetime DEFAULT NULL COMMENT 'Коли відкликано (незворотно)',
  `revoked_by` int DEFAULT NULL COMMENT 'Хто відкликав',
  `revoked_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rotated_from` bigint UNSIGNED DEFAULT NULL COMMENT 'ID попереднього токена при ротації',
  `last_used_at` datetime DEFAULT NULL,
  `last_used_ip` varbinary(16) DEFAULT NULL COMMENT 'INET6_ATON',
  `last_used_domain` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usage_count` bigint UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Всього успішних використань',
  `error_count` bigint UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Всього відхилених спроб',
  `note` varchar(999) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Опис / технічний контакт',
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_tokens_log`
--

CREATE TABLE `8ydnb966_orders_tokens_log` (
  `id` bigint UNSIGNED NOT NULL,
  `id_token` bigint UNSIGNED DEFAULT NULL COMMENT 'null, якщо токен не розпізнано',
  `prefix` varchar(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Префікс зі спроби (для нерозпізнаних)',
  `ip` varbinary(16) DEFAULT NULL COMMENT 'INET6_ATON',
  `domain` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Origin/Referer host',
  `method` varchar(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `endpoint` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `result` enum('success','rejected') COLLATE utf8mb4_unicode_ci NOT NULL,
  `reject_reason` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'bad_token/expired/revoked/disabled/ip_denied/domain_denied/no_scope/rate_limited/bad_payload',
  `http_status` int DEFAULT NULL,
  `id_order` bigint UNSIGNED DEFAULT NULL COMMENT 'Створене замовлення (якщо success)',
  `external_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ID замовлення в джерелі зі спроби',
  `message` varchar(999) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Деталі / текст помилки',
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_orders_totals`
--

CREATE TABLE `8ydnb966_orders_totals` (
  `id` bigint UNSIGNED NOT NULL,
  `id_order` bigint UNSIGNED NOT NULL,
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` decimal(15,4) NOT NULL DEFAULT '0.0000',
  `sort_order` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_orders_totals`
--

INSERT INTO `8ydnb966_orders_totals` (`id`, `id_order`, `code`, `title`, `value`, `sort_order`) VALUES
(1, 4, 'sub_total', 'Subtotal', 300.0000, 1),
(2, 4, 'discount', 'Discount', -30.0000, 2),
(3, 4, 'shipping', 'Shipping', 25.0000, 3),
(4, 4, 'wrapping', 'Gift wrap', 5.0000, 4),
(5, 4, 'tax', 'VAT 20%', 54.0000, 5),
(6, 4, 'tip', 'Tip', 10.0000, 6),
(7, 4, 'total', 'Total', 364.0000, 7),
(8, 5, 'sub_total', 'Разом за товари', 800.0000, 1),
(9, 5, 'shipping', 'Доставка', 50.0000, 2),
(10, 5, 'total', 'До сплати', 850.0000, 3),
(11, 7, 'sub_total', 'Subtotal', 500.0000, 1),
(12, 7, 'discount', 'Discount', -50.0000, 2),
(13, 7, 'shipping', 'Shipping', 40.0000, 3),
(14, 7, 'wrapping', 'Wrapping', 10.0000, 4),
(15, 7, 'tax', 'VAT 18%', 90.0000, 5),
(16, 7, 'tip', 'Tip', 15.0000, 6),
(17, 7, 'total', 'Total', 605.0000, 7),
(18, 8, 'sub_total', 'Разом', 1234.5600, 1),
(19, 8, 'total', 'До сплати', 1234.5600, 2),
(20, 9, 'sub_total', 'Сума', 160.0000, 1),
(21, 9, 'shipping', 'Доставка з фіксованою вартістю', 5.0000, 3),
(22, 9, 'total', 'Разом', 165.0000, 9),
(23, 10, 'sub_total', 'Сума', 500.0000, 1),
(24, 10, 'tax', 'Eco Tax (-2.00)', 2.0000, 5),
(25, 10, 'tax', 'VAT (20%)', 100.0000, 5),
(26, 10, 'total', 'Разом', 602.0000, 9),
(59, 11, 'sub_total', 'Сума', 160.0000, 1),
(60, 11, 'shipping', 'Доставка з фіксованою вартістю', 5.0000, 3),
(61, 11, 'total', 'Разом', 165.0000, 9),
(149, 12, 'sub_total', 'Сума', 201.0000, 1),
(150, 12, 'shipping', 'Доставка з фіксованою вартістю', 5.0000, 3),
(151, 12, 'total', 'Разом', 206.0000, 9),
(154, 13, 'sub_total', 'Сума', 500.0000, 1),
(155, 13, 'total', 'Разом', 500.0000, 9),
(156, 14, 'sub_total', 'Сума', 500.0000, 1),
(157, 14, 'tax', 'Eco Tax (-2.00)', 2.0000, 5),
(158, 14, 'tax', 'VAT (20%)', 100.0000, 5),
(159, 14, 'total', 'Разом', 602.0000, 9),
(160, 15, 'sub_total', 'Сума', 500.0000, 1),
(161, 15, 'tax', 'Eco Tax (-2.00)', 2.0000, 5),
(162, 15, 'tax', 'VAT (20%)', 100.0000, 5),
(163, 15, 'total', 'Разом', 602.0000, 9),
(164, 16, 'sub_total', 'Сума', 500.0000, 1),
(165, 16, 'tax', 'Eco Tax (-2.00)', 2.0000, 5),
(166, 16, 'tax', 'VAT (20%)', 100.0000, 5),
(167, 16, 'total', 'Разом', 602.0000, 9),
(168, 17, 'sub_total', 'Сума', 500.0000, 1),
(169, 17, 'tax', 'Eco Tax (-2.00)', 2.0000, 5),
(170, 17, 'tax', 'VAT (20%)', 100.0000, 5),
(171, 17, 'total', 'Разом', 602.0000, 9),
(172, 18, 'sub_total', 'Сума', 1000.0000, 1),
(173, 18, 'tax', 'Eco Tax (-2.00)', 4.0000, 5),
(174, 18, 'tax', 'VAT (20%)', 200.0000, 5),
(175, 18, 'total', 'Разом', 1204.0000, 9),
(178, 19, 'sub_total', 'Сума', 1000.0000, 1),
(179, 19, 'total', 'Разом', 1000.0000, 9),
(180, 20, 'sub_total', 'Сума', 500.0000, 1),
(181, 20, 'total', 'Разом', 500.0000, 9),
(182, 1, 'sub_total', 'Сума', 201.0000, 1),
(183, 1, 'shipping', 'Доставка з фіксованою вартістю', 5.0000, 3),
(184, 1, 'total', 'Разом', 206.0000, 9);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_to_do`
--

CREATE TABLE `8ydnb966_to_do` (
  `id` int NOT NULL,
  `id_user` int NOT NULL,
  `text` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` int NOT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL,
  `date_end` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_url`
--

CREATE TABLE `8ydnb966_url` (
  `id` int NOT NULL,
  `ssl` int NOT NULL,
  `url` varchar(999) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_users`
--

CREATE TABLE `8ydnb966_users` (
  `id` int UNSIGNED NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Ім''я',
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Прізвище',
  `patronymic` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'По-батькові',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `birthday` date DEFAULT NULL,
  `gender` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT '0=не вказано 1=чоловік 2=жінка',
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Назва файлу. Шлях: /uploads/users/{id}/{avatar}',
  `id_lang` smallint UNSIGNED NOT NULL DEFAULT '1',
  `active` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT '0=неактивний 1=активний 2=заблокований 3=запрошений',
  `tfa_enabled` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `tfa_secret` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `tfa_secret_pending` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `tfa_last_step` bigint UNSIGNED NOT NULL DEFAULT '0',
  `tfa_failed_attempts` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `tfa_locked_until` datetime DEFAULT NULL,
  `reset_token` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reset_token_expires` datetime DEFAULT NULL,
  `failed_login_attempts` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `locked_until` datetime DEFAULT NULL,
  `token_version` int UNSIGNED NOT NULL DEFAULT '0',
  `last_login_ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP адреса останнього успішного входу',
  `last_device_type` tinyint UNSIGNED DEFAULT '0' COMMENT '0=desktop 1=mobile 2=tablet',
  `id_created_by` int UNSIGNED DEFAULT NULL COMMENT 'NULL = зареєструвався сам',
  `date_last_login` datetime DEFAULT NULL,
  `date_online_since` datetime DEFAULT NULL COMMENT 'Коли юзер став онлайн (перша вкладка)',
  `date_last_seen` datetime DEFAULT NULL COMMENT 'Коли юзер востаннє був онлайн',
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_users`
--

INSERT INTO `8ydnb966_users` (`id`, `email`, `password`, `first_name`, `last_name`, `patronymic`, `phone`, `birthday`, `gender`, `avatar`, `id_lang`, `active`, `tfa_enabled`, `tfa_secret`, `tfa_secret_pending`, `tfa_last_step`, `tfa_failed_attempts`, `tfa_locked_until`, `reset_token`, `reset_token_expires`, `failed_login_attempts`, `locked_until`, `token_version`, `last_login_ip`, `last_device_type`, `id_created_by`, `date_last_login`, `date_online_since`, `date_last_seen`, `date_add`, `date_edit`) VALUES
(1, 'motchanyy@gmail.com', '$2a$12$h6C/KZLMoByyPYu5Y6bane/hwl9mi2XnoNjTyWi6/g4weyv/Gt746', 'Сергій', 'Мотчаний', 'Сергійович', '', NULL, 1, NULL, 2, 1, 0, '', '', 0, 0, NULL, NULL, NULL, 0, NULL, 55, '188.163.14.150', 0, NULL, '2026-09-17 18:26:13', '2026-09-17 14:13:50', '2026-09-17 18:26:13', '2026-03-26 18:20:52', '2026-09-17 18:26:13');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_users_groups`
--

CREATE TABLE `8ydnb966_users_groups` (
  `id` smallint UNSIGNED NOT NULL,
  `active` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `id_created_by` int UNSIGNED DEFAULT NULL COMMENT 'NULL = система',
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_users_groups`
--

INSERT INTO `8ydnb966_users_groups` (`id`, `active`, `id_created_by`, `date_add`, `date_edit`) VALUES
(1, 1, NULL, '2026-03-26 17:16:57', '2026-03-26 17:16:57'),
(2, 1, NULL, '2026-03-26 17:16:57', '2026-03-26 17:16:57');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_users_groups_lang`
--

CREATE TABLE `8ydnb966_users_groups_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_group` smallint UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `note` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_users_groups_lang`
--

INSERT INTO `8ydnb966_users_groups_lang` (`id`, `id_group`, `id_lang`, `name`, `note`) VALUES
(1, 1, 1, 'Адміністратор', NULL),
(2, 1, 2, 'Administrator', NULL),
(3, 2, 1, 'Менеджер', NULL),
(4, 2, 2, 'Manager', NULL);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_users_groups_permissions`
--

CREATE TABLE `8ydnb966_users_groups_permissions` (
  `id_group` smallint UNSIGNED NOT NULL,
  `id_page` smallint UNSIGNED NOT NULL,
  `can_view` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `can_add` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `can_edit` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `can_delete` tinyint UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_users_groups_permissions`
--

INSERT INTO `8ydnb966_users_groups_permissions` (`id_group`, `id_page`, `can_view`, `can_add`, `can_edit`, `can_delete`) VALUES
(1, 10, 1, 1, 1, 1),
(1, 11, 1, 1, 1, 1),
(1, 12, 1, 1, 1, 1),
(1, 90, 1, 1, 1, 1),
(1, 91, 1, 1, 1, 1),
(1, 92, 1, 1, 1, 1),
(1, 93, 1, 1, 1, 1),
(1, 94, 1, 1, 1, 1),
(2, 10, 1, 1, 1, 1),
(2, 11, 1, 1, 1, 1),
(2, 12, 1, 1, 1, 1),
(2, 90, 1, 1, 1, 1),
(2, 91, 1, 1, 1, 1),
(2, 92, 1, 1, 1, 1),
(2, 93, 1, 1, 1, 1),
(2, 94, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_users_invites`
--

CREATE TABLE `8ydnb966_users_invites` (
  `id` int UNSIGNED NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_group` smallint UNSIGNED DEFAULT NULL COMMENT 'Група після реєстрації',
  `id_created_by` int UNSIGNED NOT NULL COMMENT 'Хто запросив',
  `status` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT '0=очікує 1=завершено',
  `expires_at` datetime NOT NULL,
  `date_accepted` datetime DEFAULT NULL COMMENT 'Дата завершення реєстрації',
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_edit` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_users_login_log`
--

CREATE TABLE `8ydnb966_users_login_log` (
  `id` bigint UNSIGNED NOT NULL,
  `id_user` int UNSIGNED NOT NULL,
  `ip` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'IPv4 або IPv6',
  `country` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Код країни: UA, PL...',
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `user_agent` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `device` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT '0=desktop 1=mobile 2=tablet',
  `status` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT '0=невдала 1=успішна',
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
PARTITION BY RANGE (((year(`date_add`) * 100) + month(`date_add`)))
(
PARTITION p202601 VALUES LESS THAN (202602) ENGINE=InnoDB,
PARTITION p202602 VALUES LESS THAN (202603) ENGINE=InnoDB,
PARTITION p202603 VALUES LESS THAN (202604) ENGINE=InnoDB,
PARTITION p202604 VALUES LESS THAN (202605) ENGINE=InnoDB,
PARTITION p202605 VALUES LESS THAN (202606) ENGINE=InnoDB,
PARTITION p202606 VALUES LESS THAN (202607) ENGINE=InnoDB,
PARTITION p202607 VALUES LESS THAN (202608) ENGINE=InnoDB,
PARTITION p202608 VALUES LESS THAN (202609) ENGINE=InnoDB,
PARTITION p202609 VALUES LESS THAN (202610) ENGINE=InnoDB,
PARTITION p202610 VALUES LESS THAN (202611) ENGINE=InnoDB,
PARTITION p202611 VALUES LESS THAN (202612) ENGINE=InnoDB,
PARTITION p202612 VALUES LESS THAN (202613) ENGINE=InnoDB,
PARTITION pmax VALUES LESS THAN MAXVALUE ENGINE=InnoDB
);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_users_permissions_pages`
--

CREATE TABLE `8ydnb966_users_permissions_pages` (
  `id` smallint UNSIGNED NOT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Унікальний ключ: users.list, products.catalog',
  `parent_id` smallint UNSIGNED DEFAULT NULL COMMENT 'NULL = корінь дерева',
  `sort_order` smallint UNSIGNED NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_users_permissions_pages`
--

INSERT INTO `8ydnb966_users_permissions_pages` (`id`, `slug`, `parent_id`, `sort_order`) VALUES
(1, 'users', NULL, 10),
(2, 'settings', NULL, 90),
(10, 'users.list', 1, 10),
(11, 'users.groups', 1, 20),
(12, 'users.invites', 1, 30),
(90, 'settings.general', 2, 10),
(91, 'settings.languages', 2, 20),
(92, 'contact-center', NULL, 50),
(93, 'contact-center.channels', 92, 10),
(94, 'contact_center.channels', NULL, 0);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_users_permissions_pages_lang`
--

CREATE TABLE `8ydnb966_users_permissions_pages_lang` (
  `id` int UNSIGNED NOT NULL,
  `id_page` smallint UNSIGNED NOT NULL,
  `id_lang` smallint UNSIGNED NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_users_permissions_pages_lang`
--

INSERT INTO `8ydnb966_users_permissions_pages_lang` (`id`, `id_page`, `id_lang`, `name`) VALUES
(1, 1, 1, 'Користувачі'),
(2, 1, 2, 'Users'),
(3, 2, 1, 'Налаштування'),
(4, 2, 2, 'Settings'),
(5, 10, 1, 'Список користувачів'),
(6, 10, 2, 'User list'),
(7, 11, 1, 'Групи'),
(8, 11, 2, 'Groups'),
(9, 12, 1, 'Запрошення'),
(10, 12, 2, 'Invites'),
(11, 90, 1, 'Загальні'),
(12, 90, 2, 'General'),
(13, 91, 1, 'Мови'),
(14, 91, 2, 'Languages'),
(15, 92, 1, 'Contact Center'),
(16, 92, 2, 'Contact Center'),
(17, 93, 1, 'Канали комунікації'),
(18, 93, 2, 'Communication Channels');

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_users_security_events`
--

CREATE TABLE `8ydnb966_users_security_events` (
  `id` bigint UNSIGNED NOT NULL,
  `id_user` int UNSIGNED DEFAULT NULL COMMENT 'NULL якщо користувач не знайдений',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `event_type` enum('login_success','login_failed_invalid_password','login_failed_unknown_user','login_blocked','login_inactive','login_failed_invalid_2fa','invalid_request','login_system_error','password_changed','2fa_enabled','2fa_disabled','password_reset_requested') COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_agent` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `details` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Логування подій безпеки';

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_users_sessions`
--

CREATE TABLE `8ydnb966_users_sessions` (
  `id` bigint UNSIGNED NOT NULL,
  `id_user` int UNSIGNED NOT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_agent` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_fingerprint` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Хеш пристрою (IP + User-Agent)',
  `refresh_token_hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_valid` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime NOT NULL,
  `last_activity` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Активні сесії користувачів';

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_users_tfa_backup_codes`
--

CREATE TABLE `8ydnb966_users_tfa_backup_codes` (
  `id` bigint UNSIGNED NOT NULL,
  `id_user` int UNSIGNED NOT NULL,
  `code_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_users_to_groups`
--

CREATE TABLE `8ydnb966_users_to_groups` (
  `id_user` int UNSIGNED NOT NULL,
  `id_group` smallint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп даних таблиці `8ydnb966_users_to_groups`
--

INSERT INTO `8ydnb966_users_to_groups` (`id_user`, `id_group`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_users_ui_settings`
--

CREATE TABLE `8ydnb966_users_ui_settings` (
  `id` int UNSIGNED NOT NULL,
  `id_user` int UNSIGNED NOT NULL,
  `key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` json NOT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_web_chat`
--

CREATE TABLE `8ydnb966_web_chat` (
  `id` int NOT NULL,
  `id_chat` varchar(999) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` json NOT NULL,
  `type` varchar(999) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_add` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_web_chat_client_reads`
--

CREATE TABLE `8ydnb966_web_chat_client_reads` (
  `room_id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `site_id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_read_id` bigint UNSIGNED NOT NULL DEFAULT '0',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_web_chat_conversations`
--

CREATE TABLE `8ydnb966_web_chat_conversations` (
  `id` bigint UNSIGNED NOT NULL,
  `site_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `room_id` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url_token` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('open','closed','archived') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'open',
  `client_wrote` tinyint(1) NOT NULL DEFAULT '0',
  `operator_id` int DEFAULT NULL,
  `joined_at` datetime(3) DEFAULT NULL,
  `closed_at` datetime(3) DEFAULT NULL,
  `offline_ack_at` datetime(3) DEFAULT NULL,
  `rating` tinyint DEFAULT NULL,
  `rating_comment` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rated_at` datetime(3) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_web_chat_leads`
--

CREATE TABLE `8ydnb966_web_chat_leads` (
  `id` bigint UNSIGNED NOT NULL,
  `site_id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `room_id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `visitor_id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trigger` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `form_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `answers` json DEFAULT NULL,
  `page_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_add` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_web_chat_manager`
--

CREATE TABLE `8ydnb966_web_chat_manager` (
  `id` int NOT NULL,
  `id_manager` int NOT NULL,
  `id_chat` varchar(999) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` json NOT NULL,
  `type_message` varchar(999) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_add` datetime NOT NULL,
  `date_edit` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_web_chat_messages`
--

CREATE TABLE `8ydnb966_web_chat_messages` (
  `id` bigint UNSIGNED NOT NULL,
  `site_id` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_chat` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sender` enum('client','operator') COLLATE utf8mb4_unicode_ci NOT NULL,
  `manager_id` int DEFAULT NULL,
  `message` json NOT NULL,
  `type` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'text',
  `client_ts` bigint DEFAULT NULL,
  `client_msg_id` char(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_add` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `edited_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_web_chat_operator_reads`
--

CREATE TABLE `8ydnb966_web_chat_operator_reads` (
  `operator_id` int NOT NULL,
  `room_id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `site_id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_read_id` bigint UNSIGNED NOT NULL DEFAULT '0',
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_web_chat_push_subs`
--

CREATE TABLE `8ydnb966_web_chat_push_subs` (
  `id` bigint UNSIGNED NOT NULL,
  `operator_id` int NOT NULL,
  `endpoint` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `p256dh` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `auth` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_agent` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_add` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_web_chat_sessions`
--

CREATE TABLE `8ydnb966_web_chat_sessions` (
  `uid` char(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `site_id` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `visitor_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `last_seen` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_web_chat_sites`
--

CREATE TABLE `8ydnb966_web_chat_sites` (
  `site_id` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `domains` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `product_card_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `lead_timeout_sec` int NOT NULL DEFAULT '120',
  `offline_lead_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `offline_lead_delay_sec` int NOT NULL DEFAULT '30',
  `brand_color` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#007fff',
  `config` json DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_web_chat_visitor_meta`
--

CREATE TABLE `8ydnb966_web_chat_visitor_meta` (
  `site_id` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `visitor_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` json NOT NULL,
  `first_data` json DEFAULT NULL,
  `first_seen` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблиці `8ydnb966_web_chat_visitor_products`
--

CREATE TABLE `8ydnb966_web_chat_visitor_products` (
  `id` bigint UNSIGNED NOT NULL,
  `site_id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `visitor_id` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `product` json NOT NULL,
  `views` int UNSIGNED NOT NULL DEFAULT '1',
  `first_viewed` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `last_viewed` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Індекси збережених таблиць
--

--
-- Індекси таблиці `8ydnb966_calendar_events`
--
ALTER TABLE `8ydnb966_calendar_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_creator` (`id_user_creator`,`active`,`date_start`),
  ADD KEY `idx_ref` (`id_ref_type`,`id_ref`),
  ADD KEY `idx_visibility_range` (`visibility`,`active`,`date_start`,`date_end`);

--
-- Індекси таблиці `8ydnb966_calendar_event_type`
--
ALTER TABLE `8ydnb966_calendar_event_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_code` (`code`);

--
-- Індекси таблиці `8ydnb966_calendar_event_type_lang`
--
ALTER TABLE `8ydnb966_calendar_event_type_lang`
  ADD PRIMARY KEY (`id_event_type`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_calendar_event_users`
--
ALTER TABLE `8ydnb966_calendar_event_users`
  ADD PRIMARY KEY (`id_user`,`date_start`,`id_event`),
  ADD KEY `idx_event` (`id_event`),
  ADD KEY `idx_pending` (`id_user`,`response`,`date_start`);

--
-- Індекси таблиці `8ydnb966_calendar_hidden_events`
--
ALTER TABLE `8ydnb966_calendar_hidden_events`
  ADD PRIMARY KEY (`id_user`,`id_event`);

--
-- Індекси таблиці `8ydnb966_calendar_reminder_queue`
--
ALTER TABLE `8ydnb966_calendar_reminder_queue`
  ADD PRIMARY KEY (`id_event`,`id_user`,`kind`),
  ADD KEY `idx_fire` (`sent`,`date_fire`);

--
-- Індекси таблиці `8ydnb966_calendar_user_settings`
--
ALTER TABLE `8ydnb966_calendar_user_settings`
  ADD PRIMARY KEY (`id_user`);

--
-- Індекси таблиці `8ydnb966_catalog_brands`
--
ALTER TABLE `8ydnb966_catalog_brands`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_name` (`name`),
  ADD KEY `idx_active` (`active`),
  ADD KEY `idx_sort` (`sort_order`);

--
-- Індекси таблиці `8ydnb966_catalog_brands_lang`
--
ALTER TABLE `8ydnb966_catalog_brands_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_brand_lang` (`id_brand`,`id_lang`),
  ADD KEY `idx_brand` (`id_brand`),
  ADD KEY `idx_lang` (`id_lang`);

--
-- Індекси таблиці `8ydnb966_catalog_currency`
--
ALTER TABLE `8ydnb966_catalog_currency`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_iso_code` (`iso_code`),
  ADD UNIQUE KEY `uq_iso_code_num` (`iso_code_num`),
  ADD KEY `idx_active` (`active`),
  ADD KEY `idx_default` (`is_default`);

--
-- Індекси таблиці `8ydnb966_catalog_lang`
--
ALTER TABLE `8ydnb966_catalog_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_code` (`code`),
  ADD UNIQUE KEY `uq_locale` (`locale`),
  ADD UNIQUE KEY `uq_url_prefix` (`url_prefix`),
  ADD KEY `idx_active` (`active`),
  ADD KEY `idx_default` (`default`);

--
-- Індекси таблиці `8ydnb966_catalog_stock_status`
--
ALTER TABLE `8ydnb966_catalog_stock_status`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_active` (`active`);

--
-- Індекси таблиці `8ydnb966_catalog_stock_status_lang`
--
ALTER TABLE `8ydnb966_catalog_stock_status_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_status_lang` (`id_stock_status`,`id_lang`),
  ADD KEY `idx_status` (`id_stock_status`),
  ADD KEY `idx_lang` (`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies`
--
ALTER TABLE `8ydnb966_companies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_type` (`id_company_type`),
  ADD KEY `idx_status` (`id_company_status`),
  ADD KEY `idx_industry` (`id_industry`),
  ADD KEY `idx_segment` (`id_segment`),
  ADD KEY `idx_user` (`id_user`),
  ADD KEY `idx_country` (`country`),
  ADD KEY `idx_edrpou` (`edrpou`),
  ADD KEY `idx_active` (`active`);

--
-- Індекси таблиці `8ydnb966_companies_bank`
--
ALTER TABLE `8ydnb966_companies_bank`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_mfo` (`mfo`),
  ADD KEY `idx_swift` (`swift`);

--
-- Індекси таблиці `8ydnb966_companies_bank_accounts`
--
ALTER TABLE `8ydnb966_companies_bank_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_bank` (`id_bank`),
  ADD KEY `idx_iban` (`iban`),
  ADD KEY `idx_currency` (`currency`),
  ADD KEY `idx_primary` (`id_company`,`is_primary`);

--
-- Індекси таблиці `8ydnb966_companies_bank_account_type`
--
ALTER TABLE `8ydnb966_companies_bank_account_type`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_companies_bank_account_type_lang`
--
ALTER TABLE `8ydnb966_companies_bank_account_type_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_bank_account_type_lang` (`id_bank_account_type`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_custom_field`
--
ALTER TABLE `8ydnb966_companies_custom_field`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_field_key` (`field_key`),
  ADD KEY `idx_group` (`id_custom_field_group`),
  ADD KEY `idx_field_type` (`field_type`);

--
-- Індекси таблиці `8ydnb966_companies_custom_field_group`
--
ALTER TABLE `8ydnb966_companies_custom_field_group`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_companies_custom_field_group_lang`
--
ALTER TABLE `8ydnb966_companies_custom_field_group_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cfg_lang` (`id_custom_field_group`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_custom_field_lang`
--
ALTER TABLE `8ydnb966_companies_custom_field_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cf_lang` (`id_custom_field`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_custom_field_option`
--
ALTER TABLE `8ydnb966_companies_custom_field_option`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_field` (`id_custom_field`);

--
-- Індекси таблиці `8ydnb966_companies_custom_field_option_lang`
--
ALTER TABLE `8ydnb966_companies_custom_field_option_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cfo_lang` (`id_custom_field_option`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_custom_field_value`
--
ALTER TABLE `8ydnb966_companies_custom_field_value`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_company_field` (`id_company`,`id_custom_field`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_custom_field` (`id_custom_field`),
  ADD KEY `idx_value_int` (`value_int`),
  ADD KEY `idx_value_date` (`value_date`);

--
-- Індекси таблиці `8ydnb966_companies_emails`
--
ALTER TABLE `8ydnb966_companies_emails`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_primary` (`id_company`,`is_primary`);

--
-- Індекси таблиці `8ydnb966_companies_email_type`
--
ALTER TABLE `8ydnb966_companies_email_type`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_companies_email_type_lang`
--
ALTER TABLE `8ydnb966_companies_email_type_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_email_type_lang` (`id_email_type`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_industry`
--
ALTER TABLE `8ydnb966_companies_industry`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_companies_industry_lang`
--
ALTER TABLE `8ydnb966_companies_industry_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_industry_lang` (`id_industry`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_legal_form`
--
ALTER TABLE `8ydnb966_companies_legal_form`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_companies_legal_form_lang`
--
ALTER TABLE `8ydnb966_companies_legal_form_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_legal_form_lang` (`id_legal_form`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_phones`
--
ALTER TABLE `8ydnb966_companies_phones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_phone` (`phone_clean`),
  ADD KEY `idx_primary` (`id_company`,`is_primary`);

--
-- Індекси таблиці `8ydnb966_companies_phone_type`
--
ALTER TABLE `8ydnb966_companies_phone_type`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_companies_phone_type_lang`
--
ALTER TABLE `8ydnb966_companies_phone_type_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_phone_type_lang` (`id_phone_type`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_segment`
--
ALTER TABLE `8ydnb966_companies_segment`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_companies_segment_lang`
--
ALTER TABLE `8ydnb966_companies_segment_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_segment_lang` (`id_segment`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_socials`
--
ALTER TABLE `8ydnb966_companies_socials`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_social_type` (`id_social_type`),
  ADD KEY `idx_handle` (`handle`);

--
-- Індекси таблиці `8ydnb966_companies_social_type`
--
ALTER TABLE `8ydnb966_companies_social_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_code` (`code`);

--
-- Індекси таблиці `8ydnb966_companies_social_type_lang`
--
ALTER TABLE `8ydnb966_companies_social_type_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_social_type_lang` (`id_social_type`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_source`
--
ALTER TABLE `8ydnb966_companies_source`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_companies_source_lang`
--
ALTER TABLE `8ydnb966_companies_source_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_source_lang` (`id_source`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_status`
--
ALTER TABLE `8ydnb966_companies_status`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_companies_status_lang`
--
ALTER TABLE `8ydnb966_companies_status_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_status_lang` (`id_company_status`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_tag`
--
ALTER TABLE `8ydnb966_companies_tag`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category` (`id_tag_category`);

--
-- Індекси таблиці `8ydnb966_companies_tags_map`
--
ALTER TABLE `8ydnb966_companies_tags_map`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_company_tag` (`id_company`,`id_tag`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_tag` (`id_tag`);

--
-- Індекси таблиці `8ydnb966_companies_tag_category`
--
ALTER TABLE `8ydnb966_companies_tag_category`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_companies_tag_category_lang`
--
ALTER TABLE `8ydnb966_companies_tag_category_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_tag_category_lang` (`id_tag_category`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_tag_lang`
--
ALTER TABLE `8ydnb966_companies_tag_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_tag_lang` (`id_tag`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_type`
--
ALTER TABLE `8ydnb966_companies_type`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_companies_type_lang`
--
ALTER TABLE `8ydnb966_companies_type_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_type_lang` (`id_company_type`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_companies_websites`
--
ALTER TABLE `8ydnb966_companies_websites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_company` (`id_company`);

--
-- Індекси таблиці `8ydnb966_contacts`
--
ALTER TABLE `8ydnb966_contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`id_contact_status`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_segment` (`id_segment`),
  ADD KEY `idx_user` (`id_user`),
  ADD KEY `idx_last_name` (`last_name`),
  ADD KEY `idx_email` (`email_main`),
  ADD KEY `idx_phone` (`phone_main`),
  ADD KEY `idx_birthday` (`date_birthday_next`),
  ADD KEY `idx_active` (`active`),
  ADD KEY `idx_last_activity` (`date_last_activity`);

--
-- Індекси таблиці `8ydnb966_contacts_addresses`
--
ALTER TABLE `8ydnb966_contacts_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_contact` (`id_contact`),
  ADD KEY `idx_city` (`city`),
  ADD KEY `idx_country` (`country`);

--
-- Індекси таблиці `8ydnb966_contacts_address_type`
--
ALTER TABLE `8ydnb966_contacts_address_type`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_contacts_address_type_lang`
--
ALTER TABLE `8ydnb966_contacts_address_type_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_addr_type_lang` (`id_address_type`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_contacts_audit_log`
--
ALTER TABLE `8ydnb966_contacts_audit_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_contact` (`id_contact`),
  ADD KEY `idx_entity` (`entity_type`,`id_entity`),
  ADD KEY `idx_user` (`id_user`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_date` (`date_add`);

--
-- Індекси таблиці `8ydnb966_contacts_companies_map`
--
ALTER TABLE `8ydnb966_contacts_companies_map`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_contact_company` (`id_contact`,`id_company`),
  ADD KEY `idx_contact` (`id_contact`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_role` (`id_role`),
  ADD KEY `idx_primary` (`id_contact`,`is_primary`);

--
-- Індекси таблиці `8ydnb966_contacts_custom_field`
--
ALTER TABLE `8ydnb966_contacts_custom_field`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_field_key` (`field_key`),
  ADD KEY `idx_group` (`id_custom_field_group`),
  ADD KEY `idx_field_type` (`field_type`);

--
-- Індекси таблиці `8ydnb966_contacts_custom_field_group`
--
ALTER TABLE `8ydnb966_contacts_custom_field_group`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_contacts_custom_field_group_lang`
--
ALTER TABLE `8ydnb966_contacts_custom_field_group_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_ccfg_lang` (`id_custom_field_group`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_contacts_custom_field_lang`
--
ALTER TABLE `8ydnb966_contacts_custom_field_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_ccf_lang` (`id_custom_field`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_contacts_custom_field_option`
--
ALTER TABLE `8ydnb966_contacts_custom_field_option`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_field` (`id_custom_field`);

--
-- Індекси таблиці `8ydnb966_contacts_custom_field_option_lang`
--
ALTER TABLE `8ydnb966_contacts_custom_field_option_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_ccfo_lang` (`id_custom_field_option`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_contacts_custom_field_value`
--
ALTER TABLE `8ydnb966_contacts_custom_field_value`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_contact_field` (`id_contact`,`id_custom_field`),
  ADD KEY `idx_contact` (`id_contact`),
  ADD KEY `idx_custom_field` (`id_custom_field`),
  ADD KEY `idx_value_int` (`value_int`),
  ADD KEY `idx_value_date` (`value_date`);

--
-- Індекси таблиці `8ydnb966_contacts_emails`
--
ALTER TABLE `8ydnb966_contacts_emails`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_contact` (`id_contact`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_primary` (`id_contact`,`is_primary`),
  ADD KEY `idx_subscribed` (`subscribed`);

--
-- Індекси таблиці `8ydnb966_contacts_files`
--
ALTER TABLE `8ydnb966_contacts_files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_contact` (`id_contact`),
  ADD KEY `idx_category` (`id_category`),
  ADD KEY `idx_hash` (`file_hash`);

--
-- Індекси таблиці `8ydnb966_contacts_file_category`
--
ALTER TABLE `8ydnb966_contacts_file_category`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_contacts_file_category_lang`
--
ALTER TABLE `8ydnb966_contacts_file_category_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cfc_lang` (`id_category`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_contacts_merge_log`
--
ALTER TABLE `8ydnb966_contacts_merge_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_master` (`id_contact_master`),
  ADD KEY `idx_merged` (`id_contact_merged`);

--
-- Індекси таблиці `8ydnb966_contacts_notes`
--
ALTER TABLE `8ydnb966_contacts_notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_contact` (`id_contact`),
  ADD KEY `idx_user` (`id_user`),
  ADD KEY `idx_pinned` (`id_contact`,`is_pinned`);

--
-- Індекси таблиці `8ydnb966_contacts_phones`
--
ALTER TABLE `8ydnb966_contacts_phones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_contact` (`id_contact`),
  ADD KEY `idx_phone` (`phone_clean`),
  ADD KEY `idx_primary` (`id_contact`,`is_primary`);

--
-- Індекси таблиці `8ydnb966_contacts_role`
--
ALTER TABLE `8ydnb966_contacts_role`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_contacts_role_lang`
--
ALTER TABLE `8ydnb966_contacts_role_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_contact_role_lang` (`id_role`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_contacts_salutation`
--
ALTER TABLE `8ydnb966_contacts_salutation`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_contacts_salutation_lang`
--
ALTER TABLE `8ydnb966_contacts_salutation_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_salutation_lang` (`id_salutation`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_contacts_segment`
--
ALTER TABLE `8ydnb966_contacts_segment`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_contacts_segment_lang`
--
ALTER TABLE `8ydnb966_contacts_segment_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_contact_segment_lang` (`id_segment`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_contacts_socials`
--
ALTER TABLE `8ydnb966_contacts_socials`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_contact` (`id_contact`),
  ADD KEY `idx_social_type` (`id_social_type`),
  ADD KEY `idx_handle` (`handle`);

--
-- Індекси таблиці `8ydnb966_contacts_source`
--
ALTER TABLE `8ydnb966_contacts_source`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_contacts_source_lang`
--
ALTER TABLE `8ydnb966_contacts_source_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_contact_source_lang` (`id_source`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_contacts_status`
--
ALTER TABLE `8ydnb966_contacts_status`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_contacts_status_lang`
--
ALTER TABLE `8ydnb966_contacts_status_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_contact_status_lang` (`id_contact_status`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_contacts_tag`
--
ALTER TABLE `8ydnb966_contacts_tag`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category` (`id_tag_category`);

--
-- Індекси таблиці `8ydnb966_contacts_tags_map`
--
ALTER TABLE `8ydnb966_contacts_tags_map`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_contact_tag` (`id_contact`,`id_tag`),
  ADD KEY `idx_contact` (`id_contact`),
  ADD KEY `idx_tag` (`id_tag`);

--
-- Індекси таблиці `8ydnb966_contacts_tag_category`
--
ALTER TABLE `8ydnb966_contacts_tag_category`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_contacts_tag_category_lang`
--
ALTER TABLE `8ydnb966_contacts_tag_category_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_ctc_lang` (`id_tag_category`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_contacts_tag_lang`
--
ALTER TABLE `8ydnb966_contacts_tag_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_ct_lang` (`id_tag`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_contacts_websites`
--
ALTER TABLE `8ydnb966_contacts_websites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_contact` (`id_contact`);

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
  ADD KEY `idx_status_pending` (`status`,`date_add`),
  ADD KEY `idx_channel_source` (`id_channel`,`source_id`);

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
-- Індекси таблиці `8ydnb966_currencies`
--
ALTER TABLE `8ydnb966_currencies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_iso` (`iso`);

--
-- Індекси таблиці `8ydnb966_currencies_lang`
--
ALTER TABLE `8ydnb966_currencies_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_currency_lang` (`id_currency`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_customers`
--
ALTER TABLE `8ydnb966_customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_uid` (`uid`),
  ADD UNIQUE KEY `uq_external` (`external_source`,`external_id`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_segment` (`segment`),
  ADD KEY `idx_blacklisted` (`blacklisted`),
  ADD KEY `idx_assigned_to` (`assigned_to`),
  ADD KEY `idx_referred_by` (`referred_by_id`),
  ADD KEY `idx_source` (`source`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_deleted_at` (`deleted_at`);

--
-- Індекси таблиці `8ydnb966_customers_groups`
--
ALTER TABLE `8ydnb966_customers_groups`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_customers_groups_lang`
--
ALTER TABLE `8ydnb966_customers_groups_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_group_lang` (`id_group`,`id_lang`),
  ADD KEY `idx_lang` (`id_lang`);

--
-- Індекси таблиці `8ydnb966_customers_to_groups`
--
ALTER TABLE `8ydnb966_customers_to_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_client_group` (`client_id`,`group_id`),
  ADD KEY `idx_group` (`group_id`);

--
-- Індекси таблиці `8ydnb966_customer_addresses`
--
ALTER TABLE `8ydnb966_customer_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_customer` (`customer_id`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_default` (`customer_id`,`is_default`);

--
-- Індекси таблиці `8ydnb966_customer_addresses_lang`
--
ALTER TABLE `8ydnb966_customer_addresses_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_addr_lang` (`id_address`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_customer_analytics`
--
ALTER TABLE `8ydnb966_customer_analytics`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_customer` (`customer_id`),
  ADD KEY `idx_churn_risk` (`churn_risk_level`),
  ADD KEY `idx_total_spent` (`total_spent`),
  ADD KEY `idx_rfm_segment` (`rfm_segment`);

--
-- Індекси таблиці `8ydnb966_customer_companies`
--
ALTER TABLE `8ydnb966_customer_companies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_customer` (`customer_id`),
  ADD KEY `idx_edrpou` (`edrpou`),
  ADD KEY `idx_vat_id` (`vat_id`);

--
-- Індекси таблиці `8ydnb966_customer_consent`
--
ALTER TABLE `8ydnb966_customer_consent`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_customer` (`customer_id`);

--
-- Індекси таблиці `8ydnb966_customer_consent_log`
--
ALTER TABLE `8ydnb966_customer_consent_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_customer` (`customer_id`),
  ADD KEY `idx_changed` (`changed_at`);

--
-- Індекси таблиці `8ydnb966_customer_contacts`
--
ALTER TABLE `8ydnb966_customer_contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_customer` (`customer_id`),
  ADD KEY `idx_value` (`value`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_primary` (`customer_id`,`type`,`is_primary`),
  ADD KEY `fk_contact_label` (`id_label`);

--
-- Індекси таблиці `8ydnb966_customer_custom_fields`
--
ALTER TABLE `8ydnb966_customer_custom_fields`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cust_field` (`customer_id`,`id_field_def`),
  ADD KEY `idx_field_def` (`id_field_def`);

--
-- Індекси таблиці `8ydnb966_customer_custom_field_defs`
--
ALTER TABLE `8ydnb966_customer_custom_field_defs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_field_key` (`field_key`);

--
-- Індекси таблиці `8ydnb966_customer_custom_field_defs_lang`
--
ALTER TABLE `8ydnb966_customer_custom_field_defs_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_field_lang` (`id_field_def`,`id_lang`),
  ADD KEY `idx_lang` (`id_lang`);

--
-- Індекси таблиці `8ydnb966_customer_loyalty`
--
ALTER TABLE `8ydnb966_customer_loyalty`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_customer` (`customer_id`),
  ADD KEY `idx_level` (`id_level`);

--
-- Індекси таблиці `8ydnb966_customer_loyalty_levels_dict`
--
ALTER TABLE `8ydnb966_customer_loyalty_levels_dict`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_code` (`code`);

--
-- Індекси таблиці `8ydnb966_customer_loyalty_levels_dict_lang`
--
ALTER TABLE `8ydnb966_customer_loyalty_levels_dict_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_level_lang` (`id_level`,`id_lang`),
  ADD KEY `idx_lang` (`id_lang`);

--
-- Індекси таблиці `8ydnb966_customer_loyalty_log`
--
ALTER TABLE `8ydnb966_customer_loyalty_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_customer` (`customer_id`),
  ADD KEY `idx_ref` (`ref_type`,`ref_id`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_created` (`created_at`);

--
-- Індекси таблиці `8ydnb966_customer_merge_log`
--
ALTER TABLE `8ydnb966_customer_merge_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_master` (`master_id`),
  ADD KEY `idx_merged` (`merged_id`);

--
-- Індекси таблиці `8ydnb966_customer_notes`
--
ALTER TABLE `8ydnb966_customer_notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_customer` (`customer_id`),
  ADD KEY `idx_pinned` (`customer_id`,`is_pinned`);

--
-- Індекси таблиці `8ydnb966_deals`
--
ALTER TABLE `8ydnb966_deals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_deal_number` (`deal_number`),
  ADD KEY `idx_pipeline` (`id_pipeline`),
  ADD KEY `idx_stage` (`id_stage`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_contact` (`id_contact`),
  ADD KEY `idx_user` (`id_user`),
  ADD KEY `idx_date_close` (`date_close_plan`),
  ADD KEY `idx_amount` (`amount_final`),
  ADD KEY `idx_forecast` (`forecast_category`),
  ADD KEY `idx_active` (`active`),
  ADD KEY `idx_external_id` (`external_id`),
  ADD KEY `idx_active_date_add` (`active`,`date_add`),
  ADD KEY `idx_id_stage` (`id_stage`),
  ADD KEY `idx_id_pipeline` (`id_pipeline`),
  ADD KEY `idx_id_deal_type` (`id_deal_type`),
  ADD KEY `idx_id_source` (`id_source`),
  ADD KEY `idx_id_company` (`id_company`),
  ADD KEY `idx_id_contact` (`id_contact`),
  ADD KEY `idx_id_user` (`id_user`),
  ADD KEY `idx_id_competitor` (`id_competitor`);

--
-- Індекси таблиці `8ydnb966_deals_act`
--
ALTER TABLE `8ydnb966_deals_act`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_act_number` (`act_number`),
  ADD KEY `idx_deal` (`id_deal`),
  ADD KEY `idx_contract` (`id_contract`),
  ADD KEY `idx_company` (`id_company`);

--
-- Індекси таблиці `8ydnb966_deals_activity`
--
ALTER TABLE `8ydnb966_deals_activity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_type` (`id_activity_type`),
  ADD KEY `idx_deal` (`id_deal`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_contact` (`id_contact`),
  ADD KEY `idx_user` (`id_user`),
  ADD KEY `idx_date_plan` (`date_plan`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_active_deal` (`id_deal`,`active`,`date_plan`);

--
-- Індекси таблиці `8ydnb966_deals_activity_outcome`
--
ALTER TABLE `8ydnb966_deals_activity_outcome`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_type` (`id_activity_type`);

--
-- Індекси таблиці `8ydnb966_deals_activity_outcome_lang`
--
ALTER TABLE `8ydnb966_deals_activity_outcome_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_ao_lang` (`id_outcome`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_activity_participant`
--
ALTER TABLE `8ydnb966_deals_activity_participant`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_activity_participant` (`id_activity`,`participant_type`,`id_participant`),
  ADD KEY `idx_activity` (`id_activity`);

--
-- Індекси таблиці `8ydnb966_deals_activity_type`
--
ALTER TABLE `8ydnb966_deals_activity_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_code` (`code`);

--
-- Індекси таблиці `8ydnb966_deals_activity_type_lang`
--
ALTER TABLE `8ydnb966_deals_activity_type_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_at_lang` (`id_activity_type`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_act_item`
--
ALTER TABLE `8ydnb966_deals_act_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_act` (`id_act`);

--
-- Індекси таблиці `8ydnb966_deals_act_status`
--
ALTER TABLE `8ydnb966_deals_act_status`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_act_status_lang`
--
ALTER TABLE `8ydnb966_deals_act_status_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_as_lang` (`id_act_status`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_audit_log`
--
ALTER TABLE `8ydnb966_deals_audit_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_entity` (`entity_type`,`id_entity`),
  ADD KEY `idx_user` (`id_user`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_date` (`date_add`);

--
-- Індекси таблиці `8ydnb966_deals_calendar_events`
--
ALTER TABLE `8ydnb966_deals_calendar_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_deal` (`id_deal`),
  ADD KEY `idx_date_start` (`date_start`),
  ADD KEY `idx_event_type` (`id_event_type`),
  ADD KEY `idx_creator` (`id_user_creator`);

--
-- Індекси таблиці `8ydnb966_deals_calendar_event_type`
--
ALTER TABLE `8ydnb966_deals_calendar_event_type`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_calendar_event_type_lang`
--
ALTER TABLE `8ydnb966_deals_calendar_event_type_lang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_type_lang` (`id_event_type`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_calendar_event_users`
--
ALTER TABLE `8ydnb966_deals_calendar_event_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_event_user` (`id_event`,`id_user`),
  ADD KEY `idx_event` (`id_event`),
  ADD KEY `idx_user` (`id_user`);

--
-- Індекси таблиці `8ydnb966_deals_companies_map`
--
ALTER TABLE `8ydnb966_deals_companies_map`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_deal_company` (`id_deal`,`id_company`),
  ADD KEY `idx_deal` (`id_deal`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_id_deal` (`id_deal`);

--
-- Індекси таблиці `8ydnb966_deals_contacts_map`
--
ALTER TABLE `8ydnb966_deals_contacts_map`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_deal_contact` (`id_deal`,`id_contact`),
  ADD KEY `idx_deal` (`id_deal`),
  ADD KEY `idx_contact` (`id_contact`),
  ADD KEY `idx_id_deal` (`id_deal`);

--
-- Індекси таблиці `8ydnb966_deals_contract`
--
ALTER TABLE `8ydnb966_deals_contract`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_contract_number` (`contract_number`),
  ADD KEY `idx_deal` (`id_deal`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_status` (`id_contract_status`),
  ADD KEY `idx_date_end` (`date_end`),
  ADD KEY `idx_auto_renew` (`auto_renew`,`date_end`);

--
-- Індекси таблиці `8ydnb966_deals_contract_file`
--
ALTER TABLE `8ydnb966_deals_contract_file`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_contract` (`id_contract`);

--
-- Індекси таблиці `8ydnb966_deals_contract_status`
--
ALTER TABLE `8ydnb966_deals_contract_status`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_contract_status_lang`
--
ALTER TABLE `8ydnb966_deals_contract_status_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cs_lang` (`id_contract_status`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_contract_type`
--
ALTER TABLE `8ydnb966_deals_contract_type`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_contract_type_lang`
--
ALTER TABLE `8ydnb966_deals_contract_type_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_ct_lang` (`id_contract_type`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_custom_field`
--
ALTER TABLE `8ydnb966_deals_custom_field`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_field_key` (`field_key`),
  ADD KEY `idx_pipeline` (`id_pipeline`);

--
-- Індекси таблиці `8ydnb966_deals_custom_field_group`
--
ALTER TABLE `8ydnb966_deals_custom_field_group`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_custom_field_group_lang`
--
ALTER TABLE `8ydnb966_deals_custom_field_group_lang`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_custom_field_lang`
--
ALTER TABLE `8ydnb966_deals_custom_field_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_dcf_lang` (`id_custom_field`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_custom_field_option`
--
ALTER TABLE `8ydnb966_deals_custom_field_option`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_field` (`id_custom_field`);

--
-- Індекси таблиці `8ydnb966_deals_custom_field_value`
--
ALTER TABLE `8ydnb966_deals_custom_field_value`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_deal_field` (`id_deal`,`id_custom_field`),
  ADD KEY `idx_deal` (`id_deal`),
  ADD KEY `idx_custom_field` (`id_custom_field`);

--
-- Індекси таблиці `8ydnb966_deals_doc_counter`
--
ALTER TABLE `8ydnb966_deals_doc_counter`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_doc_type_year` (`doc_type`,`year`);

--
-- Індекси таблиці `8ydnb966_deals_doc_template`
--
ALTER TABLE `8ydnb966_deals_doc_template`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_doc_type` (`doc_type`);

--
-- Індекси таблиці `8ydnb966_deals_doc_template_lang`
--
ALTER TABLE `8ydnb966_deals_doc_template_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_tmpl_lang` (`id_template`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_file`
--
ALTER TABLE `8ydnb966_deals_file`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_entity` (`entity_type`,`id_entity`),
  ADD KEY `idx_deal` (`id_deal`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_category` (`id_category`),
  ADD KEY `idx_hash` (`file_hash`);

--
-- Індекси таблиці `8ydnb966_deals_file_category`
--
ALTER TABLE `8ydnb966_deals_file_category`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_file_category_lang`
--
ALTER TABLE `8ydnb966_deals_file_category_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_dfc_lang` (`id_category`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_invoice`
--
ALTER TABLE `8ydnb966_deals_invoice`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_invoice_number` (`invoice_number`),
  ADD KEY `idx_deal` (`id_deal`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_status` (`id_invoice_status`),
  ADD KEY `idx_date_due` (`date_due`),
  ADD KEY `idx_overdue` (`id_invoice_status`,`date_due`);

--
-- Індекси таблиці `8ydnb966_deals_invoice_item`
--
ALTER TABLE `8ydnb966_deals_invoice_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_invoice` (`id_invoice`);

--
-- Індекси таблиці `8ydnb966_deals_invoice_status`
--
ALTER TABLE `8ydnb966_deals_invoice_status`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_invoice_status_lang`
--
ALTER TABLE `8ydnb966_deals_invoice_status_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_is_lang` (`id_invoice_status`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_item`
--
ALTER TABLE `8ydnb966_deals_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_deal` (`id_deal`),
  ADD KEY `idx_product` (`id_product`),
  ADD KEY `idx_ref` (`ref_type`,`id_ref`),
  ADD KEY `idx_item_type` (`id_item_type`),
  ADD KEY `idx_active_deal` (`id_deal`,`active`);

--
-- Індекси таблиці `8ydnb966_deals_item_type`
--
ALTER TABLE `8ydnb966_deals_item_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_code` (`code`);

--
-- Індекси таблиці `8ydnb966_deals_item_type_lang`
--
ALTER TABLE `8ydnb966_deals_item_type_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_item_type_lang` (`id_item_type`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_lost_reason`
--
ALTER TABLE `8ydnb966_deals_lost_reason`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_lost_reason_lang`
--
ALTER TABLE `8ydnb966_deals_lost_reason_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_lost_reason_lang` (`id_lost_reason`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_payment`
--
ALTER TABLE `8ydnb966_deals_payment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_invoice` (`id_invoice`),
  ADD KEY `idx_deal` (`id_deal`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_date` (`date_payment`),
  ADD KEY `idx_status` (`status`);

--
-- Індекси таблиці `8ydnb966_deals_pipeline`
--
ALTER TABLE `8ydnb966_deals_pipeline`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_pipeline_lang`
--
ALTER TABLE `8ydnb966_deals_pipeline_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_pipeline_lang` (`id_pipeline`,`id_lang`),
  ADD KEY `idx_pipeline_lang` (`id_pipeline`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_quote`
--
ALTER TABLE `8ydnb966_deals_quote`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_quote_number` (`quote_number`),
  ADD KEY `idx_deal` (`id_deal`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_status` (`id_quote_status`),
  ADD KEY `idx_valid` (`date_valid`);

--
-- Індекси таблиці `8ydnb966_deals_quote_item`
--
ALTER TABLE `8ydnb966_deals_quote_item`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_quote` (`id_quote`),
  ADD KEY `idx_product` (`id_product`);

--
-- Індекси таблиці `8ydnb966_deals_quote_status`
--
ALTER TABLE `8ydnb966_deals_quote_status`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_quote_status_lang`
--
ALTER TABLE `8ydnb966_deals_quote_status_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_qs_lang` (`id_quote_status`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_source`
--
ALTER TABLE `8ydnb966_deals_source`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_source_lang`
--
ALTER TABLE `8ydnb966_deals_source_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_deal_source_lang` (`id_source`,`id_lang`),
  ADD KEY `idx_source_lang` (`id_source`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_stage`
--
ALTER TABLE `8ydnb966_deals_stage`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pipeline` (`id_pipeline`),
  ADD KEY `idx_pipeline_active` (`id_pipeline`,`active`);

--
-- Індекси таблиці `8ydnb966_deals_stage_history`
--
ALTER TABLE `8ydnb966_deals_stage_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_deal` (`id_deal`),
  ADD KEY `idx_stage` (`id_stage_to`);

--
-- Індекси таблиці `8ydnb966_deals_stage_lang`
--
ALTER TABLE `8ydnb966_deals_stage_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_stage_lang` (`id_stage`,`id_lang`),
  ADD KEY `idx_stage_lang` (`id_stage`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_task`
--
ALTER TABLE `8ydnb966_deals_task`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_deal` (`id_deal`),
  ADD KEY `idx_company` (`id_company`),
  ADD KEY `idx_user` (`id_user`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_due` (`date_due`),
  ADD KEY `idx_parent` (`id_task_parent`);

--
-- Індекси таблиці `8ydnb966_deals_task_checklist`
--
ALTER TABLE `8ydnb966_deals_task_checklist`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_task` (`id_task`);

--
-- Індекси таблиці `8ydnb966_deals_tax`
--
ALTER TABLE `8ydnb966_deals_tax`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_tax_lang`
--
ALTER TABLE `8ydnb966_deals_tax_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_tax_lang` (`id_tax`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_total`
--
ALTER TABLE `8ydnb966_deals_total`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_deal_currency` (`id_deal`,`currency`),
  ADD KEY `idx_deal` (`id_deal`);

--
-- Індекси таблиці `8ydnb966_deals_type`
--
ALTER TABLE `8ydnb966_deals_type`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_type_lang`
--
ALTER TABLE `8ydnb966_deals_type_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_deal_type_lang` (`id_deal_type`,`id_lang`),
  ADD KEY `idx_type_lang` (`id_deal_type`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_deals_unit`
--
ALTER TABLE `8ydnb966_deals_unit`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_deals_unit_lang`
--
ALTER TABLE `8ydnb966_deals_unit_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_unit_lang` (`id_unit`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_integrations`
--
ALTER TABLE `8ydnb966_integrations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`);

--
-- Індекси таблиці `8ydnb966_languages`
--
ALTER TABLE `8ydnb966_languages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_iso` (`iso`);

--
-- Індекси таблиці `8ydnb966_leads`
--
ALTER TABLE `8ydnb966_leads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pipeline_stage` (`id_pipeline`,`id_stage`),
  ADD KEY `idx_status` (`id_status`),
  ADD KEY `idx_manager` (`id_manager`),
  ADD KEY `idx_score` (`score`),
  ADD KEY `idx_deleted` (`deleted_at`),
  ADD KEY `idx_converted` (`is_converted`),
  ADD KEY `idx_date_add` (`date_add`);

--
-- Індекси таблиці `8ydnb966_leads_activities`
--
ALTER TABLE `8ydnb966_leads_activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_lead` (`id_lead`),
  ADD KEY `idx_manager` (`id_manager`),
  ADD KEY `idx_scheduled` (`scheduled_at`),
  ADD KEY `idx_status` (`status`);

--
-- Індекси таблиці `8ydnb966_leads_activity_outcomes`
--
ALTER TABLE `8ydnb966_leads_activity_outcomes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_type` (`activity_type`);

--
-- Індекси таблиці `8ydnb966_leads_activity_outcomes_lang`
--
ALTER TABLE `8ydnb966_leads_activity_outcomes_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_outcome_lang` (`id_outcome`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_api_tokens`
--
ALTER TABLE `8ydnb966_leads_api_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_token` (`token`);

--
-- Індекси таблиці `8ydnb966_leads_automations`
--
ALTER TABLE `8ydnb966_leads_automations`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_leads_automations_lang`
--
ALTER TABLE `8ydnb966_leads_automations_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_automation_lang` (`id_automation`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_automations_log`
--
ALTER TABLE `8ydnb966_leads_automations_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_lead` (`id_lead`),
  ADD KEY `idx_automation` (`id_automation`);

--
-- Індекси таблиці `8ydnb966_leads_conversions`
--
ALTER TABLE `8ydnb966_leads_conversions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_lead` (`id_lead`);

--
-- Індекси таблиці `8ydnb966_leads_custom_fields`
--
ALTER TABLE `8ydnb966_leads_custom_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pipeline` (`id_pipeline`);

--
-- Індекси таблиці `8ydnb966_leads_custom_fields_lang`
--
ALTER TABLE `8ydnb966_leads_custom_fields_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_field_lang` (`id_field`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_custom_fields_stage`
--
ALTER TABLE `8ydnb966_leads_custom_fields_stage`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_field_stage` (`id_field`,`id_stage`);

--
-- Індекси таблиці `8ydnb966_leads_duplicates`
--
ALTER TABLE `8ydnb966_leads_duplicates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_lead` (`id_lead`),
  ADD KEY `idx_orig` (`id_lead_orig`);

--
-- Індекси таблиці `8ydnb966_leads_email_templates`
--
ALTER TABLE `8ydnb966_leads_email_templates`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_leads_email_templates_lang`
--
ALTER TABLE `8ydnb966_leads_email_templates_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_template_lang` (`id_template`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_files`
--
ALTER TABLE `8ydnb966_leads_files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_lead` (`id_lead`);

--
-- Індекси таблиці `8ydnb966_leads_history`
--
ALTER TABLE `8ydnb966_leads_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_lead` (`id_lead`),
  ADD KEY `idx_action` (`action_type`),
  ADD KEY `idx_manager` (`id_manager`);

--
-- Індекси таблиці `8ydnb966_leads_loss_reasons`
--
ALTER TABLE `8ydnb966_leads_loss_reasons`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_leads_loss_reasons_lang`
--
ALTER TABLE `8ydnb966_leads_loss_reasons_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_reason_lang` (`id_reason`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_pipelines`
--
ALTER TABLE `8ydnb966_leads_pipelines`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_leads_pipelines_lang`
--
ALTER TABLE `8ydnb966_leads_pipelines_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_pipeline_lang` (`id_pipeline`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_pipeline_stages`
--
ALTER TABLE `8ydnb966_leads_pipeline_stages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pipeline` (`id_pipeline`);

--
-- Індекси таблиці `8ydnb966_leads_pipeline_stages_lang`
--
ALTER TABLE `8ydnb966_leads_pipeline_stages_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_stage_lang` (`id_stage`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_priorities`
--
ALTER TABLE `8ydnb966_leads_priorities`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_leads_priorities_lang`
--
ALTER TABLE `8ydnb966_leads_priorities_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_priority_lang` (`id_priority`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_qualifications`
--
ALTER TABLE `8ydnb966_leads_qualifications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_slug` (`slug`);

--
-- Індекси таблиці `8ydnb966_leads_qualifications_lang`
--
ALTER TABLE `8ydnb966_leads_qualifications_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_qual_lang` (`id_qualification`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_reminders`
--
ALTER TABLE `8ydnb966_leads_reminders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_lead` (`id_lead`),
  ADD KEY `idx_remind_at` (`remind_at`),
  ADD KEY `idx_status` (`status`);

--
-- Індекси таблиці `8ydnb966_leads_routing_rules`
--
ALTER TABLE `8ydnb966_leads_routing_rules`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_leads_routing_rules_lang`
--
ALTER TABLE `8ydnb966_leads_routing_rules_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_routing_lang` (`id_rule`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_score_log`
--
ALTER TABLE `8ydnb966_leads_score_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_lead` (`id_lead`);

--
-- Індекси таблиці `8ydnb966_leads_score_rules`
--
ALTER TABLE `8ydnb966_leads_score_rules`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_leads_score_rules_lang`
--
ALTER TABLE `8ydnb966_leads_score_rules_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_rule_lang` (`id_rule`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_segments`
--
ALTER TABLE `8ydnb966_leads_segments`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_leads_segments_lang`
--
ALTER TABLE `8ydnb966_leads_segments_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_segment_lang` (`id_segment`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_segments_rel`
--
ALTER TABLE `8ydnb966_leads_segments_rel`
  ADD PRIMARY KEY (`id_segment`,`id_lead`);

--
-- Індекси таблиці `8ydnb966_leads_settings_status`
--
ALTER TABLE `8ydnb966_leads_settings_status`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_leads_settings_status_lang`
--
ALTER TABLE `8ydnb966_leads_settings_status_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_status_lang` (`id_status`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_sla_log`
--
ALTER TABLE `8ydnb966_leads_sla_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_lead` (`id_lead`);

--
-- Індекси таблиці `8ydnb966_leads_sla_rules`
--
ALTER TABLE `8ydnb966_leads_sla_rules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pipeline` (`id_pipeline`),
  ADD KEY `idx_stage` (`id_stage`);

--
-- Індекси таблиці `8ydnb966_leads_sla_rules_lang`
--
ALTER TABLE `8ydnb966_leads_sla_rules_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_sla_rule_lang` (`id_sla_rule`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_sources`
--
ALTER TABLE `8ydnb966_leads_sources`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_leads_sources_lang`
--
ALTER TABLE `8ydnb966_leads_sources_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_source_lang` (`id_source`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_tags`
--
ALTER TABLE `8ydnb966_leads_tags`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_leads_tags_lang`
--
ALTER TABLE `8ydnb966_leads_tags_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_tag_lang` (`id_tag`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_tags_rel`
--
ALTER TABLE `8ydnb966_leads_tags_rel`
  ADD PRIMARY KEY (`id_lead`,`id_tag`);

--
-- Індекси таблиці `8ydnb966_leads_temperatures`
--
ALTER TABLE `8ydnb966_leads_temperatures`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_slug` (`slug`);

--
-- Індекси таблиці `8ydnb966_leads_temperatures_lang`
--
ALTER TABLE `8ydnb966_leads_temperatures_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_temp_lang` (`id_temperature`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_leads_webhooks`
--
ALTER TABLE `8ydnb966_leads_webhooks`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_leads_webhooks_log`
--
ALTER TABLE `8ydnb966_leads_webhooks_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_webhook` (`id_webhook`),
  ADD KEY `idx_lead` (`id_lead`),
  ADD KEY `idx_result` (`result`);

--
-- Індекси таблиці `8ydnb966_mail_accounts`
--
ALTER TABLE `8ydnb966_mail_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_enabled` (`is_enabled`);

--
-- Індекси таблиці `8ydnb966_notifications`
--
ALTER TABLE `8ydnb966_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_date` (`date_add`);

--
-- Індекси таблиці `8ydnb966_notification_reads`
--
ALTER TABLE `8ydnb966_notification_reads`
  ADD PRIMARY KEY (`notification_id`,`manager_id`),
  ADD KEY `idx_manager` (`manager_id`);

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
-- Індекси таблиці `8ydnb966_orders`
--
ALTER TABLE `8ydnb966_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_source_order` (`id_integration`,`external_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_financial` (`financial_status`),
  ADD KEY `idx_fulfillment` (`fulfillment_status`),
  ADD KEY `idx_client` (`id_client`),
  ADD KEY `idx_reference` (`reference`),
  ADD KEY `idx_date_add` (`date_add`),
  ADD KEY `idx_deleted` (`deleted_at`),
  ADD KEY `idx_date_status` (`date_add`,`status`),
  ADD KEY `idx_status_date` (`status`,`date_add`),
  ADD KEY `idx_client_date` (`id_client`,`date_add`),
  ADD KEY `idx_is_paid_date` (`is_paid`,`date_add`),
  ADD KEY `idx_financial_status` (`financial_status`,`date_add`),
  ADD KEY `idx_stat_day` (`date_order_day`,`id_integration`),
  ADD KEY `idx_stat_int_day` (`id_integration`,`date_order_day`,`status`),
  ADD KEY `fk_order_payment_method` (`payment`);

--
-- Індекси таблиці `8ydnb966_orders_abandoned_cart`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_store_session` (`store_id`,`session_id`),
  ADD KEY `idx_customer` (`id_customer`),
  ADD KEY `idx_last_activity` (`last_activity_at`),
  ADD KEY `idx_total` (`total_amount`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_integration` (`id_integration`),
  ADD KEY `idx_client` (`id_client`),
  ADD KEY `idx_order` (`id_order`),
  ADD KEY `idx_status_activity` (`status`,`last_activity_at`);

--
-- Індекси таблиці `8ydnb966_orders_abandoned_cart_events`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_service` (`service_id`),
  ADD KEY `idx_active` (`active`),
  ADD KEY `idx_event_source` (`id_integration`,`store_id`);

--
-- Індекси таблиці `8ydnb966_orders_abandoned_cart_inbox`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_inbox`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pick` (`status`,`attempts`,`id`),
  ADD KEY `idx_locked` (`locked_at`),
  ADD KEY `idx_integration` (`id_integration`);

--
-- Індекси таблиці `8ydnb966_orders_abandoned_cart_log`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_cart` (`cart_id`),
  ADD KEY `idx_event` (`event_id`),
  ADD KEY `idx_sent_at` (`sent_at`);

--
-- Індекси таблиці `8ydnb966_orders_abandoned_cart_queue`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_queue`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_task` (`cart_id`,`event_id`,`attempt_no`),
  ADD KEY `idx_pick` (`status`,`run_after`,`id`),
  ADD KEY `idx_cart` (`cart_id`),
  ADD KEY `idx_event` (`event_id`),
  ADD KEY `idx_locked` (`locked_at`),
  ADD KEY `idx_delivery_poll` (`status`,`delivery_final`,`delivery_checked_at`);

--
-- Індекси таблиці `8ydnb966_orders_abandoned_cart_recovery`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_recovery`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_token` (`token`),
  ADD UNIQUE KEY `uq_cart` (`cart_id`),
  ADD KEY `idx_cart` (`cart_id`);

--
-- Індекси таблиці `8ydnb966_orders_abandoned_cart_services`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_services`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_provider` (`provider`),
  ADD KEY `idx_channel` (`channel`),
  ADD KEY `idx_connected` (`is_connected`),
  ADD KEY `idx_active` (`active`);

--
-- Індекси таблиці `8ydnb966_orders_addresses`
--
ALTER TABLE `8ydnb966_orders_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order` (`id_order`),
  ADD KEY `idx_type` (`id_order`,`type`),
  ADD KEY `idx_country_city` (`country`,`city`);

--
-- Індекси таблиці `8ydnb966_orders_clients`
--
ALTER TABLE `8ydnb966_orders_clients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_source` (`id_integration`,`external_id`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_phone` (`phone`),
  ADD KEY `idx_group` (`id_default_group`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_manager` (`id_manager`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_deleted` (`deleted_at`),
  ADD KEY `idx_last_order` (`last_order_at`);

--
-- Індекси таблиці `8ydnb966_orders_clients_addresses`
--
ALTER TABLE `8ydnb966_orders_clients_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_client` (`id_client`);

--
-- Індекси таблиці `8ydnb966_orders_clients_groups`
--
ALTER TABLE `8ydnb966_orders_clients_groups`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_orders_clients_group_map`
--
ALTER TABLE `8ydnb966_orders_clients_group_map`
  ADD PRIMARY KEY (`id_client`,`id_group`),
  ADD KEY `idx_group` (`id_group`);

--
-- Індекси таблиці `8ydnb966_orders_clients_rewards`
--
ALTER TABLE `8ydnb966_orders_clients_rewards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_client` (`id_client`),
  ADD KEY `idx_order` (`id_order`);

--
-- Індекси таблиці `8ydnb966_orders_clients_transactions`
--
ALTER TABLE `8ydnb966_orders_clients_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_client` (`id_client`),
  ADD KEY `idx_order` (`id_order`);

--
-- Індекси таблиці `8ydnb966_orders_currency`
--
ALTER TABLE `8ydnb966_orders_currency`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_orders_delivery`
--
ALTER TABLE `8ydnb966_orders_delivery`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_orders_delivery_lang`
--
ALTER TABLE `8ydnb966_orders_delivery_lang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_delivery` (`id_delivery`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_orders_discounts`
--
ALTER TABLE `8ydnb966_orders_discounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order` (`id_order`),
  ADD KEY `idx_code` (`code`);

--
-- Індекси таблиці `8ydnb966_orders_documents`
--
ALTER TABLE `8ydnb966_orders_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order` (`id_order`),
  ADD KEY `idx_type` (`id_order`,`type`);

--
-- Індекси таблиці `8ydnb966_orders_events`
--
ALTER TABLE `8ydnb966_orders_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order` (`id_order`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_dedup` (`id_order`,`type`,`date_add`);

--
-- Індекси таблиці `8ydnb966_orders_fees`
--
ALTER TABLE `8ydnb966_orders_fees`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order` (`id_order`);

--
-- Індекси таблиці `8ydnb966_orders_inbox`
--
ALTER TABLE `8ydnb966_orders_inbox`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_inbox_source` (`id_integration`,`external_id`),
  ADD KEY `idx_status` (`status`,`id`);

--
-- Індекси таблиці `8ydnb966_orders_integrations`
--
ALTER TABLE `8ydnb966_orders_integrations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`status`);

--
-- Індекси таблиці `8ydnb966_orders_invoices`
--
ALTER TABLE `8ydnb966_orders_invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order` (`id_order`),
  ADD KEY `idx_number` (`number`);

--
-- Індекси таблиці `8ydnb966_orders_invoices_tax`
--
ALTER TABLE `8ydnb966_orders_invoices_tax`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_invoice` (`id_invoice`);

--
-- Індекси таблиці `8ydnb966_orders_items`
--
ALTER TABLE `8ydnb966_orders_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order` (`id_order`),
  ADD KEY `idx_product` (`id_product`),
  ADD KEY `idx_sku` (`sku`),
  ADD KEY `idx_product_order` (`id_product`,`id_order`),
  ADD KEY `idx_sku_order` (`sku`,`id_order`);

--
-- Індекси таблиці `8ydnb966_orders_meta`
--
ALTER TABLE `8ydnb966_orders_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_key` (`id_order`,`meta_key`);

--
-- Індекси таблиці `8ydnb966_orders_notes`
--
ALTER TABLE `8ydnb966_orders_notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order` (`id_order`);

--
-- Індекси таблиці `8ydnb966_orders_outbox`
--
ALTER TABLE `8ydnb966_orders_outbox`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`status`,`id`),
  ADD KEY `idx_order` (`id_order`);

--
-- Індекси таблиці `8ydnb966_orders_payment`
--
ALTER TABLE `8ydnb966_orders_payment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_code` (`code`),
  ADD KEY `idx_status_default` (`id_status_default`),
  ADD KEY `idx_active_sort` (`active`,`sort_order`);

--
-- Індекси таблиці `8ydnb966_orders_payments`
--
ALTER TABLE `8ydnb966_orders_payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_txn_dedup` (`driver`,`transaction_id`),
  ADD KEY `idx_order` (`id_order`),
  ADD KEY `idx_transaction` (`transaction_id`),
  ADD KEY `idx_paid_at` (`paid_at`),
  ADD KEY `idx_method` (`id_payment_method`),
  ADD KEY `idx_gateway` (`id_gateway`),
  ADD KEY `idx_order_status` (`id_order`,`status`),
  ADD KEY `fk_pay_currency` (`id_currency`);

--
-- Індекси таблиці `8ydnb966_orders_payment_gateway`
--
ALTER TABLE `8ydnb966_orders_payment_gateway`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_gateway` (`id_integration`,`driver`,`is_test`),
  ADD KEY `idx_payment` (`id_payment`);

--
-- Індекси таблиці `8ydnb966_orders_payment_inbox`
--
ALTER TABLE `8ydnb966_orders_payment_inbox`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_pay_inbox` (`driver`,`external_id`),
  ADD KEY `idx_pick` (`status`,`attempts`,`id`),
  ADD KEY `idx_locked` (`locked_at`),
  ADD KEY `idx_order` (`id_order`),
  ADD KEY `idx_gateway` (`id_gateway`),
  ADD KEY `fk_payinbox_txn` (`id_payment_txn`);

--
-- Індекси таблиці `8ydnb966_orders_payment_lang`
--
ALTER TABLE `8ydnb966_orders_payment_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_payment_lang` (`id_payment`,`id_lang`),
  ADD KEY `idx_payment` (`id_payment`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_orders_payment_map`
--
ALTER TABLE `8ydnb966_orders_payment_map`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_pay_map` (`id_integration`,`external_code`,`direction`),
  ADD KEY `idx_payment` (`id_payment`);

--
-- Індекси таблиці `8ydnb966_orders_payment_status_map`
--
ALTER TABLE `8ydnb966_orders_payment_status_map`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_gw_status` (`driver`,`gateway_status`);

--
-- Індекси таблиці `8ydnb966_orders_raw`
--
ALTER TABLE `8ydnb966_orders_raw`
  ADD PRIMARY KEY (`id_order`);

--
-- Індекси таблиці `8ydnb966_orders_refunds`
--
ALTER TABLE `8ydnb966_orders_refunds`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order` (`id_order`),
  ADD KEY `idx_date_add` (`date_add`);

--
-- Індекси таблиці `8ydnb966_orders_refunds_items`
--
ALTER TABLE `8ydnb966_orders_refunds_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_refund` (`id_refund`),
  ADD KEY `idx_order_item` (`id_order_item`);

--
-- Індекси таблиці `8ydnb966_orders_shipments`
--
ALTER TABLE `8ydnb966_orders_shipments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order` (`id_order`),
  ADD KEY `idx_tracking` (`tracking_number`);

--
-- Індекси таблиці `8ydnb966_orders_stats_cash_daily`
--
ALTER TABLE `8ydnb966_orders_stats_cash_daily`
  ADD PRIMARY KEY (`day`,`id_integration`),
  ADD KEY `idx_int_day` (`id_integration`,`day`);

--
-- Індекси таблиці `8ydnb966_orders_stats_daily`
--
ALTER TABLE `8ydnb966_orders_stats_daily`
  ADD PRIMARY KEY (`day`,`id_integration`),
  ADD KEY `idx_int_day` (`id_integration`,`day`),
  ADD KEY `idx_day` (`day`);

--
-- Індекси таблиці `8ydnb966_orders_stats_daily_channel`
--
ALTER TABLE `8ydnb966_orders_stats_daily_channel`
  ADD PRIMARY KEY (`day`,`id_integration`,`source_channel`),
  ADD KEY `idx_int_day` (`id_integration`,`day`);

--
-- Індекси таблиці `8ydnb966_orders_stats_daily_product`
--
ALTER TABLE `8ydnb966_orders_stats_daily_product`
  ADD PRIMARY KEY (`day`,`id_integration`,`sku`),
  ADD KEY `idx_int_day_rev` (`id_integration`,`day`,`revenue_base`);

--
-- Індекси таблиці `8ydnb966_orders_stats_daily_status`
--
ALTER TABLE `8ydnb966_orders_stats_daily_status`
  ADD PRIMARY KEY (`day`,`id_integration`,`id_status`),
  ADD KEY `idx_int_day` (`id_integration`,`day`);

--
-- Індекси таблиці `8ydnb966_orders_status`
--
ALTER TABLE `8ydnb966_orders_status`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_orders_status_history`
--
ALTER TABLE `8ydnb966_orders_status_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order` (`id_order`),
  ADD KEY `idx_order_date` (`id_order`,`date_add`);

--
-- Індекси таблиці `8ydnb966_orders_status_lang`
--
ALTER TABLE `8ydnb966_orders_status_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_status_lang` (`id_status`,`id_lang`);

--
-- Індекси таблиці `8ydnb966_orders_status_map`
--
ALTER TABLE `8ydnb966_orders_status_map`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_map` (`id_integration`,`external_status`,`direction`),
  ADD KEY `idx_status` (`id_status`);

--
-- Індекси таблиці `8ydnb966_orders_tokens`
--
ALTER TABLE `8ydnb966_orders_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_token_hash` (`token_hash`),
  ADD KEY `idx_prefix` (`prefix`),
  ADD KEY `idx_integration` (`id_integration`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_expires` (`expires_at`);

--
-- Індекси таблиці `8ydnb966_orders_tokens_log`
--
ALTER TABLE `8ydnb966_orders_tokens_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_token` (`id_token`),
  ADD KEY `idx_result` (`result`),
  ADD KEY `idx_date` (`date_add`),
  ADD KEY `idx_external` (`external_id`);

--
-- Індекси таблиці `8ydnb966_orders_totals`
--
ALTER TABLE `8ydnb966_orders_totals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order` (`id_order`);

--
-- Індекси таблиці `8ydnb966_to_do`
--
ALTER TABLE `8ydnb966_to_do`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_url`
--
ALTER TABLE `8ydnb966_url`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_users`
--
ALTER TABLE `8ydnb966_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_email` (`email`),
  ADD KEY `idx_active` (`active`),
  ADD KEY `idx_id_lang` (`id_lang`),
  ADD KEY `idx_id_created_by` (`id_created_by`),
  ADD KEY `idx_last_name` (`last_name`),
  ADD KEY `idx_first_name` (`first_name`);

--
-- Індекси таблиці `8ydnb966_users_groups`
--
ALTER TABLE `8ydnb966_users_groups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_active` (`active`),
  ADD KEY `idx_id_created_by` (`id_created_by`);

--
-- Індекси таблиці `8ydnb966_users_groups_lang`
--
ALTER TABLE `8ydnb966_users_groups_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_group_lang` (`id_group`,`id_lang`),
  ADD KEY `idx_id_group` (`id_group`),
  ADD KEY `fk_groups_lang_lang` (`id_lang`);

--
-- Індекси таблиці `8ydnb966_users_groups_permissions`
--
ALTER TABLE `8ydnb966_users_groups_permissions`
  ADD PRIMARY KEY (`id_group`,`id_page`),
  ADD KEY `idx_id_page` (`id_page`);

--
-- Індекси таблиці `8ydnb966_users_invites`
--
ALTER TABLE `8ydnb966_users_invites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_token` (`token`),
  ADD UNIQUE KEY `uq_email` (`email`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_expires_at` (`expires_at`),
  ADD KEY `idx_id_created_by` (`id_created_by`);

--
-- Індекси таблиці `8ydnb966_users_login_log`
--
ALTER TABLE `8ydnb966_users_login_log`
  ADD PRIMARY KEY (`id`,`date_add`),
  ADD KEY `idx_id_user` (`id_user`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_id_user_date_add` (`id_user`,`date_add`),
  ADD KEY `idx_ip_attack_detect` (`ip`,`date_add`);

--
-- Індекси таблиці `8ydnb966_users_permissions_pages`
--
ALTER TABLE `8ydnb966_users_permissions_pages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_slug` (`slug`),
  ADD KEY `idx_parent` (`parent_id`);

--
-- Індекси таблиці `8ydnb966_users_permissions_pages_lang`
--
ALTER TABLE `8ydnb966_users_permissions_pages_lang`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_page_lang` (`id_page`,`id_lang`),
  ADD KEY `idx_id_lang` (`id_lang`);

--
-- Індекси таблиці `8ydnb966_users_security_events`
--
ALTER TABLE `8ydnb966_users_security_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`id_user`),
  ADD KEY `idx_event_type` (`event_type`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_ip_address` (`ip_address`);

--
-- Індекси таблиці `8ydnb966_users_sessions`
--
ALTER TABLE `8ydnb966_users_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_device_session` (`id_user`,`device_fingerprint`),
  ADD KEY `idx_refresh_token` (`refresh_token_hash`),
  ADD KEY `idx_expires` (`expires_at`),
  ADD KEY `idx_valid` (`is_valid`,`expires_at`);

--
-- Індекси таблиці `8ydnb966_users_tfa_backup_codes`
--
ALTER TABLE `8ydnb966_users_tfa_backup_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_unused` (`id_user`,`used_at`);

--
-- Індекси таблиці `8ydnb966_users_to_groups`
--
ALTER TABLE `8ydnb966_users_to_groups`
  ADD PRIMARY KEY (`id_user`,`id_group`),
  ADD KEY `idx_id_group` (`id_group`);

--
-- Індекси таблиці `8ydnb966_users_ui_settings`
--
ALTER TABLE `8ydnb966_users_ui_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_key` (`id_user`,`key`);

--
-- Індекси таблиці `8ydnb966_web_chat`
--
ALTER TABLE `8ydnb966_web_chat`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_web_chat_client_reads`
--
ALTER TABLE `8ydnb966_web_chat_client_reads`
  ADD PRIMARY KEY (`room_id`);

--
-- Індекси таблиці `8ydnb966_web_chat_conversations`
--
ALTER TABLE `8ydnb966_web_chat_conversations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_room` (`site_id`,`room_id`),
  ADD UNIQUE KEY `uk_url_token` (`url_token`);

--
-- Індекси таблиці `8ydnb966_web_chat_leads`
--
ALTER TABLE `8ydnb966_web_chat_leads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_room` (`site_id`,`room_id`),
  ADD KEY `idx_visitor` (`site_id`,`visitor_id`);

--
-- Індекси таблиці `8ydnb966_web_chat_manager`
--
ALTER TABLE `8ydnb966_web_chat_manager`
  ADD PRIMARY KEY (`id`);

--
-- Індекси таблиці `8ydnb966_web_chat_messages`
--
ALTER TABLE `8ydnb966_web_chat_messages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_client_msg` (`id_chat`,`client_msg_id`),
  ADD KEY `idx_chat` (`site_id`,`id_chat`,`id`),
  ADD KEY `idx_date` (`date_add`);

--
-- Індекси таблиці `8ydnb966_web_chat_operator_reads`
--
ALTER TABLE `8ydnb966_web_chat_operator_reads`
  ADD PRIMARY KEY (`operator_id`,`room_id`);

--
-- Індекси таблиці `8ydnb966_web_chat_push_subs`
--
ALTER TABLE `8ydnb966_web_chat_push_subs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_endpoint` (`endpoint`);

--
-- Індекси таблиці `8ydnb966_web_chat_sessions`
--
ALTER TABLE `8ydnb966_web_chat_sessions`
  ADD PRIMARY KEY (`uid`,`site_id`),
  ADD KEY `idx_visitor` (`site_id`,`visitor_id`);

--
-- Індекси таблиці `8ydnb966_web_chat_sites`
--
ALTER TABLE `8ydnb966_web_chat_sites`
  ADD PRIMARY KEY (`site_id`);

--
-- Індекси таблиці `8ydnb966_web_chat_visitor_meta`
--
ALTER TABLE `8ydnb966_web_chat_visitor_meta`
  ADD PRIMARY KEY (`site_id`,`visitor_id`);

--
-- Індекси таблиці `8ydnb966_web_chat_visitor_products`
--
ALTER TABLE `8ydnb966_web_chat_visitor_products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_visitor_product` (`site_id`,`visitor_id`,`product_key`),
  ADD KEY `idx_history` (`site_id`,`visitor_id`,`last_viewed`,`id`);

--
-- AUTO_INCREMENT для збережених таблиць
--

--
-- AUTO_INCREMENT для таблиці `8ydnb966_calendar_events`
--
ALTER TABLE `8ydnb966_calendar_events`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_calendar_event_type`
--
ALTER TABLE `8ydnb966_calendar_event_type`
  MODIFY `id` tinyint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_catalog_brands`
--
ALTER TABLE `8ydnb966_catalog_brands`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_catalog_brands_lang`
--
ALTER TABLE `8ydnb966_catalog_brands_lang`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_catalog_currency`
--
ALTER TABLE `8ydnb966_catalog_currency`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_catalog_lang`
--
ALTER TABLE `8ydnb966_catalog_lang`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_catalog_stock_status`
--
ALTER TABLE `8ydnb966_catalog_stock_status`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_catalog_stock_status_lang`
--
ALTER TABLE `8ydnb966_catalog_stock_status_lang`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies`
--
ALTER TABLE `8ydnb966_companies`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_bank`
--
ALTER TABLE `8ydnb966_companies_bank`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_bank_accounts`
--
ALTER TABLE `8ydnb966_companies_bank_accounts`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_bank_account_type`
--
ALTER TABLE `8ydnb966_companies_bank_account_type`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_bank_account_type_lang`
--
ALTER TABLE `8ydnb966_companies_bank_account_type_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_custom_field`
--
ALTER TABLE `8ydnb966_companies_custom_field`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_custom_field_group`
--
ALTER TABLE `8ydnb966_companies_custom_field_group`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_custom_field_group_lang`
--
ALTER TABLE `8ydnb966_companies_custom_field_group_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_custom_field_lang`
--
ALTER TABLE `8ydnb966_companies_custom_field_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_custom_field_option`
--
ALTER TABLE `8ydnb966_companies_custom_field_option`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_custom_field_option_lang`
--
ALTER TABLE `8ydnb966_companies_custom_field_option_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_custom_field_value`
--
ALTER TABLE `8ydnb966_companies_custom_field_value`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_emails`
--
ALTER TABLE `8ydnb966_companies_emails`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_email_type`
--
ALTER TABLE `8ydnb966_companies_email_type`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_email_type_lang`
--
ALTER TABLE `8ydnb966_companies_email_type_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_industry`
--
ALTER TABLE `8ydnb966_companies_industry`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_industry_lang`
--
ALTER TABLE `8ydnb966_companies_industry_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_legal_form`
--
ALTER TABLE `8ydnb966_companies_legal_form`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_legal_form_lang`
--
ALTER TABLE `8ydnb966_companies_legal_form_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_phones`
--
ALTER TABLE `8ydnb966_companies_phones`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_phone_type`
--
ALTER TABLE `8ydnb966_companies_phone_type`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_phone_type_lang`
--
ALTER TABLE `8ydnb966_companies_phone_type_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_segment`
--
ALTER TABLE `8ydnb966_companies_segment`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_segment_lang`
--
ALTER TABLE `8ydnb966_companies_segment_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_socials`
--
ALTER TABLE `8ydnb966_companies_socials`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_social_type`
--
ALTER TABLE `8ydnb966_companies_social_type`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_social_type_lang`
--
ALTER TABLE `8ydnb966_companies_social_type_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_source`
--
ALTER TABLE `8ydnb966_companies_source`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_source_lang`
--
ALTER TABLE `8ydnb966_companies_source_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_status`
--
ALTER TABLE `8ydnb966_companies_status`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_status_lang`
--
ALTER TABLE `8ydnb966_companies_status_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_tag`
--
ALTER TABLE `8ydnb966_companies_tag`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_tags_map`
--
ALTER TABLE `8ydnb966_companies_tags_map`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_tag_category`
--
ALTER TABLE `8ydnb966_companies_tag_category`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_tag_category_lang`
--
ALTER TABLE `8ydnb966_companies_tag_category_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_tag_lang`
--
ALTER TABLE `8ydnb966_companies_tag_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_type`
--
ALTER TABLE `8ydnb966_companies_type`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_type_lang`
--
ALTER TABLE `8ydnb966_companies_type_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_companies_websites`
--
ALTER TABLE `8ydnb966_companies_websites`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts`
--
ALTER TABLE `8ydnb966_contacts`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_addresses`
--
ALTER TABLE `8ydnb966_contacts_addresses`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_address_type`
--
ALTER TABLE `8ydnb966_contacts_address_type`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_address_type_lang`
--
ALTER TABLE `8ydnb966_contacts_address_type_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_audit_log`
--
ALTER TABLE `8ydnb966_contacts_audit_log`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_companies_map`
--
ALTER TABLE `8ydnb966_contacts_companies_map`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_custom_field`
--
ALTER TABLE `8ydnb966_contacts_custom_field`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_custom_field_group`
--
ALTER TABLE `8ydnb966_contacts_custom_field_group`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_custom_field_group_lang`
--
ALTER TABLE `8ydnb966_contacts_custom_field_group_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_custom_field_lang`
--
ALTER TABLE `8ydnb966_contacts_custom_field_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_custom_field_option`
--
ALTER TABLE `8ydnb966_contacts_custom_field_option`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_custom_field_option_lang`
--
ALTER TABLE `8ydnb966_contacts_custom_field_option_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_custom_field_value`
--
ALTER TABLE `8ydnb966_contacts_custom_field_value`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_emails`
--
ALTER TABLE `8ydnb966_contacts_emails`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_files`
--
ALTER TABLE `8ydnb966_contacts_files`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_file_category`
--
ALTER TABLE `8ydnb966_contacts_file_category`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_file_category_lang`
--
ALTER TABLE `8ydnb966_contacts_file_category_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_merge_log`
--
ALTER TABLE `8ydnb966_contacts_merge_log`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_notes`
--
ALTER TABLE `8ydnb966_contacts_notes`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_phones`
--
ALTER TABLE `8ydnb966_contacts_phones`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_role`
--
ALTER TABLE `8ydnb966_contacts_role`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_role_lang`
--
ALTER TABLE `8ydnb966_contacts_role_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_salutation`
--
ALTER TABLE `8ydnb966_contacts_salutation`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_salutation_lang`
--
ALTER TABLE `8ydnb966_contacts_salutation_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_segment`
--
ALTER TABLE `8ydnb966_contacts_segment`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_segment_lang`
--
ALTER TABLE `8ydnb966_contacts_segment_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_socials`
--
ALTER TABLE `8ydnb966_contacts_socials`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_source`
--
ALTER TABLE `8ydnb966_contacts_source`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_source_lang`
--
ALTER TABLE `8ydnb966_contacts_source_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_status`
--
ALTER TABLE `8ydnb966_contacts_status`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_status_lang`
--
ALTER TABLE `8ydnb966_contacts_status_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_tag`
--
ALTER TABLE `8ydnb966_contacts_tag`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_tags_map`
--
ALTER TABLE `8ydnb966_contacts_tags_map`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_tag_category`
--
ALTER TABLE `8ydnb966_contacts_tag_category`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_tag_category_lang`
--
ALTER TABLE `8ydnb966_contacts_tag_category_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_tag_lang`
--
ALTER TABLE `8ydnb966_contacts_tag_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contacts_websites`
--
ALTER TABLE `8ydnb966_contacts_websites`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_attachments`
--
ALTER TABLE `8ydnb966_contact_center_attachments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_channels`
--
ALTER TABLE `8ydnb966_contact_center_channels`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_channel_instagram`
--
ALTER TABLE `8ydnb966_contact_center_channel_instagram`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_channel_telegram`
--
ALTER TABLE `8ydnb966_contact_center_channel_telegram`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_channel_webchat`
--
ALTER TABLE `8ydnb966_contact_center_channel_webchat`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_contacts`
--
ALTER TABLE `8ydnb966_contact_center_contacts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_conversations`
--
ALTER TABLE `8ydnb966_contact_center_conversations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_center_messages`
--
ALTER TABLE `8ydnb966_contact_center_messages`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_label_dict`
--
ALTER TABLE `8ydnb966_contact_label_dict`
  MODIFY `id` smallint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_contact_label_dict_lang`
--
ALTER TABLE `8ydnb966_contact_label_dict_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_currencies`
--
ALTER TABLE `8ydnb966_currencies`
  MODIFY `id` smallint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_currencies_lang`
--
ALTER TABLE `8ydnb966_currencies_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customers`
--
ALTER TABLE `8ydnb966_customers`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customers_groups`
--
ALTER TABLE `8ydnb966_customers_groups`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customers_groups_lang`
--
ALTER TABLE `8ydnb966_customers_groups_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customers_to_groups`
--
ALTER TABLE `8ydnb966_customers_to_groups`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_addresses`
--
ALTER TABLE `8ydnb966_customer_addresses`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_addresses_lang`
--
ALTER TABLE `8ydnb966_customer_addresses_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_analytics`
--
ALTER TABLE `8ydnb966_customer_analytics`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_companies`
--
ALTER TABLE `8ydnb966_customer_companies`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_consent`
--
ALTER TABLE `8ydnb966_customer_consent`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_consent_log`
--
ALTER TABLE `8ydnb966_customer_consent_log`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_contacts`
--
ALTER TABLE `8ydnb966_customer_contacts`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_custom_fields`
--
ALTER TABLE `8ydnb966_customer_custom_fields`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_custom_field_defs`
--
ALTER TABLE `8ydnb966_customer_custom_field_defs`
  MODIFY `id` smallint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_custom_field_defs_lang`
--
ALTER TABLE `8ydnb966_customer_custom_field_defs_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_loyalty`
--
ALTER TABLE `8ydnb966_customer_loyalty`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_loyalty_levels_dict`
--
ALTER TABLE `8ydnb966_customer_loyalty_levels_dict`
  MODIFY `id` smallint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_loyalty_levels_dict_lang`
--
ALTER TABLE `8ydnb966_customer_loyalty_levels_dict_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_loyalty_log`
--
ALTER TABLE `8ydnb966_customer_loyalty_log`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_merge_log`
--
ALTER TABLE `8ydnb966_customer_merge_log`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_customer_notes`
--
ALTER TABLE `8ydnb966_customer_notes`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals`
--
ALTER TABLE `8ydnb966_deals`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_act`
--
ALTER TABLE `8ydnb966_deals_act`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_activity`
--
ALTER TABLE `8ydnb966_deals_activity`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_activity_outcome`
--
ALTER TABLE `8ydnb966_deals_activity_outcome`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_activity_outcome_lang`
--
ALTER TABLE `8ydnb966_deals_activity_outcome_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_activity_participant`
--
ALTER TABLE `8ydnb966_deals_activity_participant`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_activity_type`
--
ALTER TABLE `8ydnb966_deals_activity_type`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_activity_type_lang`
--
ALTER TABLE `8ydnb966_deals_activity_type_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_act_item`
--
ALTER TABLE `8ydnb966_deals_act_item`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_act_status`
--
ALTER TABLE `8ydnb966_deals_act_status`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_act_status_lang`
--
ALTER TABLE `8ydnb966_deals_act_status_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_audit_log`
--
ALTER TABLE `8ydnb966_deals_audit_log`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_calendar_events`
--
ALTER TABLE `8ydnb966_deals_calendar_events`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_calendar_event_type`
--
ALTER TABLE `8ydnb966_deals_calendar_event_type`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_calendar_event_type_lang`
--
ALTER TABLE `8ydnb966_deals_calendar_event_type_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_calendar_event_users`
--
ALTER TABLE `8ydnb966_deals_calendar_event_users`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_companies_map`
--
ALTER TABLE `8ydnb966_deals_companies_map`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_contacts_map`
--
ALTER TABLE `8ydnb966_deals_contacts_map`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_contract`
--
ALTER TABLE `8ydnb966_deals_contract`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_contract_file`
--
ALTER TABLE `8ydnb966_deals_contract_file`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_contract_status`
--
ALTER TABLE `8ydnb966_deals_contract_status`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_contract_status_lang`
--
ALTER TABLE `8ydnb966_deals_contract_status_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_contract_type`
--
ALTER TABLE `8ydnb966_deals_contract_type`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_contract_type_lang`
--
ALTER TABLE `8ydnb966_deals_contract_type_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_custom_field`
--
ALTER TABLE `8ydnb966_deals_custom_field`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_custom_field_group`
--
ALTER TABLE `8ydnb966_deals_custom_field_group`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_custom_field_group_lang`
--
ALTER TABLE `8ydnb966_deals_custom_field_group_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_custom_field_lang`
--
ALTER TABLE `8ydnb966_deals_custom_field_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_custom_field_option`
--
ALTER TABLE `8ydnb966_deals_custom_field_option`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_custom_field_value`
--
ALTER TABLE `8ydnb966_deals_custom_field_value`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_doc_counter`
--
ALTER TABLE `8ydnb966_deals_doc_counter`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_doc_template`
--
ALTER TABLE `8ydnb966_deals_doc_template`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_doc_template_lang`
--
ALTER TABLE `8ydnb966_deals_doc_template_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_file`
--
ALTER TABLE `8ydnb966_deals_file`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_file_category`
--
ALTER TABLE `8ydnb966_deals_file_category`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_file_category_lang`
--
ALTER TABLE `8ydnb966_deals_file_category_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_invoice`
--
ALTER TABLE `8ydnb966_deals_invoice`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_invoice_item`
--
ALTER TABLE `8ydnb966_deals_invoice_item`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_invoice_status`
--
ALTER TABLE `8ydnb966_deals_invoice_status`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_invoice_status_lang`
--
ALTER TABLE `8ydnb966_deals_invoice_status_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_item`
--
ALTER TABLE `8ydnb966_deals_item`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_item_type`
--
ALTER TABLE `8ydnb966_deals_item_type`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_item_type_lang`
--
ALTER TABLE `8ydnb966_deals_item_type_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_lost_reason`
--
ALTER TABLE `8ydnb966_deals_lost_reason`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_lost_reason_lang`
--
ALTER TABLE `8ydnb966_deals_lost_reason_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_payment`
--
ALTER TABLE `8ydnb966_deals_payment`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_pipeline`
--
ALTER TABLE `8ydnb966_deals_pipeline`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_pipeline_lang`
--
ALTER TABLE `8ydnb966_deals_pipeline_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_quote`
--
ALTER TABLE `8ydnb966_deals_quote`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_quote_item`
--
ALTER TABLE `8ydnb966_deals_quote_item`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_quote_status`
--
ALTER TABLE `8ydnb966_deals_quote_status`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_quote_status_lang`
--
ALTER TABLE `8ydnb966_deals_quote_status_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_source`
--
ALTER TABLE `8ydnb966_deals_source`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_source_lang`
--
ALTER TABLE `8ydnb966_deals_source_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_stage`
--
ALTER TABLE `8ydnb966_deals_stage`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_stage_history`
--
ALTER TABLE `8ydnb966_deals_stage_history`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_stage_lang`
--
ALTER TABLE `8ydnb966_deals_stage_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_task`
--
ALTER TABLE `8ydnb966_deals_task`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'PK';

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_task_checklist`
--
ALTER TABLE `8ydnb966_deals_task_checklist`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_tax`
--
ALTER TABLE `8ydnb966_deals_tax`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_tax_lang`
--
ALTER TABLE `8ydnb966_deals_tax_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_total`
--
ALTER TABLE `8ydnb966_deals_total`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_type`
--
ALTER TABLE `8ydnb966_deals_type`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_type_lang`
--
ALTER TABLE `8ydnb966_deals_type_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_unit`
--
ALTER TABLE `8ydnb966_deals_unit`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_deals_unit_lang`
--
ALTER TABLE `8ydnb966_deals_unit_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_integrations`
--
ALTER TABLE `8ydnb966_integrations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_languages`
--
ALTER TABLE `8ydnb966_languages`
  MODIFY `id` smallint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads`
--
ALTER TABLE `8ydnb966_leads`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_activities`
--
ALTER TABLE `8ydnb966_leads_activities`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_activity_outcomes`
--
ALTER TABLE `8ydnb966_leads_activity_outcomes`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_activity_outcomes_lang`
--
ALTER TABLE `8ydnb966_leads_activity_outcomes_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_api_tokens`
--
ALTER TABLE `8ydnb966_leads_api_tokens`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_automations`
--
ALTER TABLE `8ydnb966_leads_automations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_automations_lang`
--
ALTER TABLE `8ydnb966_leads_automations_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_automations_log`
--
ALTER TABLE `8ydnb966_leads_automations_log`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_conversions`
--
ALTER TABLE `8ydnb966_leads_conversions`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_custom_fields`
--
ALTER TABLE `8ydnb966_leads_custom_fields`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_custom_fields_lang`
--
ALTER TABLE `8ydnb966_leads_custom_fields_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_custom_fields_stage`
--
ALTER TABLE `8ydnb966_leads_custom_fields_stage`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_duplicates`
--
ALTER TABLE `8ydnb966_leads_duplicates`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_email_templates`
--
ALTER TABLE `8ydnb966_leads_email_templates`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_email_templates_lang`
--
ALTER TABLE `8ydnb966_leads_email_templates_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_files`
--
ALTER TABLE `8ydnb966_leads_files`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_history`
--
ALTER TABLE `8ydnb966_leads_history`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_loss_reasons`
--
ALTER TABLE `8ydnb966_leads_loss_reasons`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_loss_reasons_lang`
--
ALTER TABLE `8ydnb966_leads_loss_reasons_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_pipelines`
--
ALTER TABLE `8ydnb966_leads_pipelines`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_pipelines_lang`
--
ALTER TABLE `8ydnb966_leads_pipelines_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_pipeline_stages`
--
ALTER TABLE `8ydnb966_leads_pipeline_stages`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_pipeline_stages_lang`
--
ALTER TABLE `8ydnb966_leads_pipeline_stages_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_priorities`
--
ALTER TABLE `8ydnb966_leads_priorities`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_priorities_lang`
--
ALTER TABLE `8ydnb966_leads_priorities_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_qualifications`
--
ALTER TABLE `8ydnb966_leads_qualifications`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_qualifications_lang`
--
ALTER TABLE `8ydnb966_leads_qualifications_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_reminders`
--
ALTER TABLE `8ydnb966_leads_reminders`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_routing_rules`
--
ALTER TABLE `8ydnb966_leads_routing_rules`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_routing_rules_lang`
--
ALTER TABLE `8ydnb966_leads_routing_rules_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_score_log`
--
ALTER TABLE `8ydnb966_leads_score_log`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_score_rules`
--
ALTER TABLE `8ydnb966_leads_score_rules`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_score_rules_lang`
--
ALTER TABLE `8ydnb966_leads_score_rules_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_segments`
--
ALTER TABLE `8ydnb966_leads_segments`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_segments_lang`
--
ALTER TABLE `8ydnb966_leads_segments_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_settings_status`
--
ALTER TABLE `8ydnb966_leads_settings_status`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_settings_status_lang`
--
ALTER TABLE `8ydnb966_leads_settings_status_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_sla_log`
--
ALTER TABLE `8ydnb966_leads_sla_log`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_sla_rules`
--
ALTER TABLE `8ydnb966_leads_sla_rules`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_sla_rules_lang`
--
ALTER TABLE `8ydnb966_leads_sla_rules_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_sources`
--
ALTER TABLE `8ydnb966_leads_sources`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_sources_lang`
--
ALTER TABLE `8ydnb966_leads_sources_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_tags`
--
ALTER TABLE `8ydnb966_leads_tags`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_tags_lang`
--
ALTER TABLE `8ydnb966_leads_tags_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_temperatures`
--
ALTER TABLE `8ydnb966_leads_temperatures`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_temperatures_lang`
--
ALTER TABLE `8ydnb966_leads_temperatures_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_webhooks`
--
ALTER TABLE `8ydnb966_leads_webhooks`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_leads_webhooks_log`
--
ALTER TABLE `8ydnb966_leads_webhooks_log`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_mail_accounts`
--
ALTER TABLE `8ydnb966_mail_accounts`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_notifications`
--
ALTER TABLE `8ydnb966_notifications`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_notif_delivery`
--
ALTER TABLE `8ydnb966_notif_delivery`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_notif_events`
--
ALTER TABLE `8ydnb966_notif_events`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_notif_inbox`
--
ALTER TABLE `8ydnb966_notif_inbox`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_notif_recipients`
--
ALTER TABLE `8ydnb966_notif_recipients`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders`
--
ALTER TABLE `8ydnb966_orders`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_abandoned_cart`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_abandoned_cart_events`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_events`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_abandoned_cart_inbox`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_inbox`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_abandoned_cart_log`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_log`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_abandoned_cart_queue`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_queue`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_abandoned_cart_recovery`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_recovery`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_abandoned_cart_services`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_services`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_addresses`
--
ALTER TABLE `8ydnb966_orders_addresses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_clients`
--
ALTER TABLE `8ydnb966_orders_clients`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_clients_addresses`
--
ALTER TABLE `8ydnb966_orders_clients_addresses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_clients_groups`
--
ALTER TABLE `8ydnb966_orders_clients_groups`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_clients_rewards`
--
ALTER TABLE `8ydnb966_orders_clients_rewards`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_clients_transactions`
--
ALTER TABLE `8ydnb966_orders_clients_transactions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_currency`
--
ALTER TABLE `8ydnb966_orders_currency`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_delivery`
--
ALTER TABLE `8ydnb966_orders_delivery`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_delivery_lang`
--
ALTER TABLE `8ydnb966_orders_delivery_lang`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_discounts`
--
ALTER TABLE `8ydnb966_orders_discounts`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_documents`
--
ALTER TABLE `8ydnb966_orders_documents`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_events`
--
ALTER TABLE `8ydnb966_orders_events`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_fees`
--
ALTER TABLE `8ydnb966_orders_fees`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_inbox`
--
ALTER TABLE `8ydnb966_orders_inbox`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_integrations`
--
ALTER TABLE `8ydnb966_orders_integrations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_invoices`
--
ALTER TABLE `8ydnb966_orders_invoices`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_invoices_tax`
--
ALTER TABLE `8ydnb966_orders_invoices_tax`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_items`
--
ALTER TABLE `8ydnb966_orders_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_meta`
--
ALTER TABLE `8ydnb966_orders_meta`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_notes`
--
ALTER TABLE `8ydnb966_orders_notes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_outbox`
--
ALTER TABLE `8ydnb966_orders_outbox`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_payment`
--
ALTER TABLE `8ydnb966_orders_payment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_payments`
--
ALTER TABLE `8ydnb966_orders_payments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_payment_gateway`
--
ALTER TABLE `8ydnb966_orders_payment_gateway`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_payment_inbox`
--
ALTER TABLE `8ydnb966_orders_payment_inbox`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_payment_lang`
--
ALTER TABLE `8ydnb966_orders_payment_lang`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_payment_map`
--
ALTER TABLE `8ydnb966_orders_payment_map`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_payment_status_map`
--
ALTER TABLE `8ydnb966_orders_payment_status_map`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_refunds`
--
ALTER TABLE `8ydnb966_orders_refunds`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_refunds_items`
--
ALTER TABLE `8ydnb966_orders_refunds_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_shipments`
--
ALTER TABLE `8ydnb966_orders_shipments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_status`
--
ALTER TABLE `8ydnb966_orders_status`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_status_history`
--
ALTER TABLE `8ydnb966_orders_status_history`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_status_lang`
--
ALTER TABLE `8ydnb966_orders_status_lang`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_status_map`
--
ALTER TABLE `8ydnb966_orders_status_map`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_tokens`
--
ALTER TABLE `8ydnb966_orders_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_tokens_log`
--
ALTER TABLE `8ydnb966_orders_tokens_log`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_orders_totals`
--
ALTER TABLE `8ydnb966_orders_totals`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_to_do`
--
ALTER TABLE `8ydnb966_to_do`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_url`
--
ALTER TABLE `8ydnb966_url`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_users`
--
ALTER TABLE `8ydnb966_users`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_users_groups`
--
ALTER TABLE `8ydnb966_users_groups`
  MODIFY `id` smallint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_users_groups_lang`
--
ALTER TABLE `8ydnb966_users_groups_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_users_invites`
--
ALTER TABLE `8ydnb966_users_invites`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_users_login_log`
--
ALTER TABLE `8ydnb966_users_login_log`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_users_permissions_pages`
--
ALTER TABLE `8ydnb966_users_permissions_pages`
  MODIFY `id` smallint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_users_permissions_pages_lang`
--
ALTER TABLE `8ydnb966_users_permissions_pages_lang`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_users_security_events`
--
ALTER TABLE `8ydnb966_users_security_events`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_users_sessions`
--
ALTER TABLE `8ydnb966_users_sessions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_users_tfa_backup_codes`
--
ALTER TABLE `8ydnb966_users_tfa_backup_codes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_users_ui_settings`
--
ALTER TABLE `8ydnb966_users_ui_settings`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_web_chat`
--
ALTER TABLE `8ydnb966_web_chat`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_web_chat_conversations`
--
ALTER TABLE `8ydnb966_web_chat_conversations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_web_chat_leads`
--
ALTER TABLE `8ydnb966_web_chat_leads`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_web_chat_manager`
--
ALTER TABLE `8ydnb966_web_chat_manager`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_web_chat_messages`
--
ALTER TABLE `8ydnb966_web_chat_messages`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_web_chat_push_subs`
--
ALTER TABLE `8ydnb966_web_chat_push_subs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблиці `8ydnb966_web_chat_visitor_products`
--
ALTER TABLE `8ydnb966_web_chat_visitor_products`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Обмеження зовнішнього ключа збережених таблиць
--

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_catalog_stock_status_lang`
--
ALTER TABLE `8ydnb966_catalog_stock_status_lang`
  ADD CONSTRAINT `fk_stock_status_lang_lang` FOREIGN KEY (`id_lang`) REFERENCES `8ydnb966_catalog_lang` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_stock_status_lang_status` FOREIGN KEY (`id_stock_status`) REFERENCES `8ydnb966_catalog_stock_status` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

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

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customers`
--
ALTER TABLE `8ydnb966_customers`
  ADD CONSTRAINT `fk_cust_referred` FOREIGN KEY (`referred_by_id`) REFERENCES `8ydnb966_customers` (`id`) ON DELETE SET NULL;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customers_groups_lang`
--
ALTER TABLE `8ydnb966_customers_groups_lang`
  ADD CONSTRAINT `fk_cgroup_lang` FOREIGN KEY (`id_group`) REFERENCES `8ydnb966_customers_groups` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customers_to_groups`
--
ALTER TABLE `8ydnb966_customers_to_groups`
  ADD CONSTRAINT `fk_c2g_client` FOREIGN KEY (`client_id`) REFERENCES `8ydnb966_customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_c2g_group` FOREIGN KEY (`group_id`) REFERENCES `8ydnb966_customers_groups` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customer_addresses`
--
ALTER TABLE `8ydnb966_customer_addresses`
  ADD CONSTRAINT `fk_addr_customer` FOREIGN KEY (`customer_id`) REFERENCES `8ydnb966_customers` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customer_addresses_lang`
--
ALTER TABLE `8ydnb966_customer_addresses_lang`
  ADD CONSTRAINT `fk_addrlang` FOREIGN KEY (`id_address`) REFERENCES `8ydnb966_customer_addresses` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customer_analytics`
--
ALTER TABLE `8ydnb966_customer_analytics`
  ADD CONSTRAINT `fk_analytics_customer` FOREIGN KEY (`customer_id`) REFERENCES `8ydnb966_customers` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customer_companies`
--
ALTER TABLE `8ydnb966_customer_companies`
  ADD CONSTRAINT `fk_company_customer` FOREIGN KEY (`customer_id`) REFERENCES `8ydnb966_customers` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customer_consent`
--
ALTER TABLE `8ydnb966_customer_consent`
  ADD CONSTRAINT `fk_consent_customer` FOREIGN KEY (`customer_id`) REFERENCES `8ydnb966_customers` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customer_consent_log`
--
ALTER TABLE `8ydnb966_customer_consent_log`
  ADD CONSTRAINT `fk_clog_customer` FOREIGN KEY (`customer_id`) REFERENCES `8ydnb966_customers` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customer_contacts`
--
ALTER TABLE `8ydnb966_customer_contacts`
  ADD CONSTRAINT `fk_contact_customer` FOREIGN KEY (`customer_id`) REFERENCES `8ydnb966_customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_contact_label` FOREIGN KEY (`id_label`) REFERENCES `8ydnb966_contact_label_dict` (`id`) ON DELETE SET NULL;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customer_custom_fields`
--
ALTER TABLE `8ydnb966_customer_custom_fields`
  ADD CONSTRAINT `fk_cf_customer` FOREIGN KEY (`customer_id`) REFERENCES `8ydnb966_customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cf_def` FOREIGN KEY (`id_field_def`) REFERENCES `8ydnb966_customer_custom_field_defs` (`id`);

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customer_custom_field_defs_lang`
--
ALTER TABLE `8ydnb966_customer_custom_field_defs_lang`
  ADD CONSTRAINT `fk_cfd_lang` FOREIGN KEY (`id_field_def`) REFERENCES `8ydnb966_customer_custom_field_defs` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customer_loyalty`
--
ALTER TABLE `8ydnb966_customer_loyalty`
  ADD CONSTRAINT `fk_loyalty_customer` FOREIGN KEY (`customer_id`) REFERENCES `8ydnb966_customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_loyalty_level` FOREIGN KEY (`id_level`) REFERENCES `8ydnb966_customer_loyalty_levels_dict` (`id`) ON DELETE SET NULL;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customer_loyalty_levels_dict_lang`
--
ALTER TABLE `8ydnb966_customer_loyalty_levels_dict_lang`
  ADD CONSTRAINT `fk_loydict_lang` FOREIGN KEY (`id_level`) REFERENCES `8ydnb966_customer_loyalty_levels_dict` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customer_loyalty_log`
--
ALTER TABLE `8ydnb966_customer_loyalty_log`
  ADD CONSTRAINT `fk_llog_customer` FOREIGN KEY (`customer_id`) REFERENCES `8ydnb966_customers` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_customer_notes`
--
ALTER TABLE `8ydnb966_customer_notes`
  ADD CONSTRAINT `fk_note_customer` FOREIGN KEY (`customer_id`) REFERENCES `8ydnb966_customers` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders`
--
ALTER TABLE `8ydnb966_orders`
  ADD CONSTRAINT `fk_order_payment_method` FOREIGN KEY (`payment`) REFERENCES `8ydnb966_orders_payment` (`id`) ON DELETE SET NULL;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_abandoned_cart_events`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_events`
  ADD CONSTRAINT `fk_event_service` FOREIGN KEY (`service_id`) REFERENCES `8ydnb966_orders_abandoned_cart_services` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_abandoned_cart_log`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_log`
  ADD CONSTRAINT `fk_log_cart` FOREIGN KEY (`cart_id`) REFERENCES `8ydnb966_orders_abandoned_cart` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_log_event` FOREIGN KEY (`event_id`) REFERENCES `8ydnb966_orders_abandoned_cart_events` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_abandoned_cart_queue`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_queue`
  ADD CONSTRAINT `fk_queue_cart` FOREIGN KEY (`cart_id`) REFERENCES `8ydnb966_orders_abandoned_cart` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_queue_event` FOREIGN KEY (`event_id`) REFERENCES `8ydnb966_orders_abandoned_cart_events` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_abandoned_cart_recovery`
--
ALTER TABLE `8ydnb966_orders_abandoned_cart_recovery`
  ADD CONSTRAINT `fk_recovery_cart` FOREIGN KEY (`cart_id`) REFERENCES `8ydnb966_orders_abandoned_cart` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_addresses`
--
ALTER TABLE `8ydnb966_orders_addresses`
  ADD CONSTRAINT `fk_addr_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_clients_addresses`
--
ALTER TABLE `8ydnb966_orders_clients_addresses`
  ADD CONSTRAINT `fk_caddr_client` FOREIGN KEY (`id_client`) REFERENCES `8ydnb966_orders_clients` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_clients_group_map`
--
ALTER TABLE `8ydnb966_orders_clients_group_map`
  ADD CONSTRAINT `fk_cgmap_client` FOREIGN KEY (`id_client`) REFERENCES `8ydnb966_orders_clients` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cgmap_group` FOREIGN KEY (`id_group`) REFERENCES `8ydnb966_orders_clients_groups` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_clients_rewards`
--
ALTER TABLE `8ydnb966_orders_clients_rewards`
  ADD CONSTRAINT `fk_reward_client` FOREIGN KEY (`id_client`) REFERENCES `8ydnb966_orders_clients` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_clients_transactions`
--
ALTER TABLE `8ydnb966_orders_clients_transactions`
  ADD CONSTRAINT `fk_trans_client` FOREIGN KEY (`id_client`) REFERENCES `8ydnb966_orders_clients` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_discounts`
--
ALTER TABLE `8ydnb966_orders_discounts`
  ADD CONSTRAINT `fk_disc_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_documents`
--
ALTER TABLE `8ydnb966_orders_documents`
  ADD CONSTRAINT `fk_doc_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_events`
--
ALTER TABLE `8ydnb966_orders_events`
  ADD CONSTRAINT `fk_events_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_fees`
--
ALTER TABLE `8ydnb966_orders_fees`
  ADD CONSTRAINT `fk_fees_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_invoices`
--
ALTER TABLE `8ydnb966_orders_invoices`
  ADD CONSTRAINT `fk_inv_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_invoices_tax`
--
ALTER TABLE `8ydnb966_orders_invoices_tax`
  ADD CONSTRAINT `fk_invtax_invoice` FOREIGN KEY (`id_invoice`) REFERENCES `8ydnb966_orders_invoices` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_items`
--
ALTER TABLE `8ydnb966_orders_items`
  ADD CONSTRAINT `fk_items_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_meta`
--
ALTER TABLE `8ydnb966_orders_meta`
  ADD CONSTRAINT `fk_meta_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_notes`
--
ALTER TABLE `8ydnb966_orders_notes`
  ADD CONSTRAINT `fk_notes_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_payment`
--
ALTER TABLE `8ydnb966_orders_payment`
  ADD CONSTRAINT `fk_paymethod_status` FOREIGN KEY (`id_status_default`) REFERENCES `8ydnb966_orders_status` (`id`) ON DELETE SET NULL;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_payments`
--
ALTER TABLE `8ydnb966_orders_payments`
  ADD CONSTRAINT `fk_pay_currency` FOREIGN KEY (`id_currency`) REFERENCES `8ydnb966_orders_currency` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pay_gateway` FOREIGN KEY (`id_gateway`) REFERENCES `8ydnb966_orders_payment_gateway` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pay_method` FOREIGN KEY (`id_payment_method`) REFERENCES `8ydnb966_orders_payment` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pay_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_payment_gateway`
--
ALTER TABLE `8ydnb966_orders_payment_gateway`
  ADD CONSTRAINT `fk_gateway_method` FOREIGN KEY (`id_payment`) REFERENCES `8ydnb966_orders_payment` (`id`) ON DELETE RESTRICT;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_payment_inbox`
--
ALTER TABLE `8ydnb966_orders_payment_inbox`
  ADD CONSTRAINT `fk_payinbox_gateway` FOREIGN KEY (`id_gateway`) REFERENCES `8ydnb966_orders_payment_gateway` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_payinbox_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_payinbox_txn` FOREIGN KEY (`id_payment_txn`) REFERENCES `8ydnb966_orders_payments` (`id`) ON DELETE SET NULL;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_payment_lang`
--
ALTER TABLE `8ydnb966_orders_payment_lang`
  ADD CONSTRAINT `fk_paylang_method` FOREIGN KEY (`id_payment`) REFERENCES `8ydnb966_orders_payment` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_payment_map`
--
ALTER TABLE `8ydnb966_orders_payment_map`
  ADD CONSTRAINT `fk_paymap_method` FOREIGN KEY (`id_payment`) REFERENCES `8ydnb966_orders_payment` (`id`) ON DELETE SET NULL;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_raw`
--
ALTER TABLE `8ydnb966_orders_raw`
  ADD CONSTRAINT `fk_raw_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_refunds`
--
ALTER TABLE `8ydnb966_orders_refunds`
  ADD CONSTRAINT `fk_refund_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_refunds_items`
--
ALTER TABLE `8ydnb966_orders_refunds_items`
  ADD CONSTRAINT `fk_refitem_refund` FOREIGN KEY (`id_refund`) REFERENCES `8ydnb966_orders_refunds` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_shipments`
--
ALTER TABLE `8ydnb966_orders_shipments`
  ADD CONSTRAINT `fk_ship_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_status_history`
--
ALTER TABLE `8ydnb966_orders_status_history`
  ADD CONSTRAINT `fk_hist_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_tokens_log`
--
ALTER TABLE `8ydnb966_orders_tokens_log`
  ADD CONSTRAINT `fk_tokenlog_token` FOREIGN KEY (`id_token`) REFERENCES `8ydnb966_orders_tokens` (`id`) ON DELETE SET NULL;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_orders_totals`
--
ALTER TABLE `8ydnb966_orders_totals`
  ADD CONSTRAINT `fk_totals_order` FOREIGN KEY (`id_order`) REFERENCES `8ydnb966_orders` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_users`
--
ALTER TABLE `8ydnb966_users`
  ADD CONSTRAINT `fk_users_created_by` FOREIGN KEY (`id_created_by`) REFERENCES `8ydnb966_users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_users_lang` FOREIGN KEY (`id_lang`) REFERENCES `8ydnb966_languages` (`id`);

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_users_groups`
--
ALTER TABLE `8ydnb966_users_groups`
  ADD CONSTRAINT `fk_groups_created_by` FOREIGN KEY (`id_created_by`) REFERENCES `8ydnb966_users` (`id`) ON DELETE SET NULL;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_users_groups_lang`
--
ALTER TABLE `8ydnb966_users_groups_lang`
  ADD CONSTRAINT `fk_groups_lang_group` FOREIGN KEY (`id_group`) REFERENCES `8ydnb966_users_groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_groups_lang_lang` FOREIGN KEY (`id_lang`) REFERENCES `8ydnb966_languages` (`id`);

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_users_groups_permissions`
--
ALTER TABLE `8ydnb966_users_groups_permissions`
  ADD CONSTRAINT `fk_ugp_group` FOREIGN KEY (`id_group`) REFERENCES `8ydnb966_users_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ugp_page` FOREIGN KEY (`id_page`) REFERENCES `8ydnb966_users_permissions_pages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_users_invites`
--
ALTER TABLE `8ydnb966_users_invites`
  ADD CONSTRAINT `fk_invites_created_by` FOREIGN KEY (`id_created_by`) REFERENCES `8ydnb966_users` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_users_permissions_pages_lang`
--
ALTER TABLE `8ydnb966_users_permissions_pages_lang`
  ADD CONSTRAINT `fk_uppl_page` FOREIGN KEY (`id_page`) REFERENCES `8ydnb966_users_permissions_pages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_users_sessions`
--
ALTER TABLE `8ydnb966_users_sessions`
  ADD CONSTRAINT `fk_sessions_user` FOREIGN KEY (`id_user`) REFERENCES `8ydnb966_users` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_users_tfa_backup_codes`
--
ALTER TABLE `8ydnb966_users_tfa_backup_codes`
  ADD CONSTRAINT `fk_tfa_bc_user` FOREIGN KEY (`id_user`) REFERENCES `8ydnb966_users` (`id`) ON DELETE CASCADE;

--
-- Обмеження зовнішнього ключа таблиці `8ydnb966_users_to_groups`
--
ALTER TABLE `8ydnb966_users_to_groups`
  ADD CONSTRAINT `fk_utg_group` FOREIGN KEY (`id_group`) REFERENCES `8ydnb966_users_groups` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_utg_user` FOREIGN KEY (`id_user`) REFERENCES `8ydnb966_users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
