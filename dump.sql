-- --------------------------------------------------------
-- Хост:                         127.0.0.1
-- Версия сервера:               8.0.30 - MySQL Community Server - GPL
-- Операционная система:         Win64
-- HeidiSQL Версия:              12.8.0.6908
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Дамп структуры для таблица ddr_cms_last_2.catalogs
CREATE TABLE IF NOT EXISTS `catalogs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `item_variable` varchar(100) DEFAULT NULL,
  `page` varchar(100) DEFAULT NULL,
  `fields` json DEFAULT NULL,
  `vars` json DEFAULT NULL,
  `simular_products_category` int DEFAULT NULL,
  `simular_products_options` int DEFAULT NULL,
  `simular_products_tags` int DEFAULT NULL,
  `sort` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Дамп данных таблицы ddr_cms_last_2.catalogs: ~0 rows (приблизительно)

-- Дамп структуры для таблица ddr_cms_last_2.categories
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `catalog_id` int NOT NULL DEFAULT '0',
  `parent_id` int DEFAULT '0',
  `title` varchar(100) DEFAULT NULL,
  `seo_title` varchar(255) DEFAULT NULL,
  `seo_text` text,
  `link_title` varchar(100) DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  `seo_url` varchar(100) DEFAULT NULL,
  `meta_keywords` text,
  `meta_description` text,
  `navigation` int DEFAULT '0',
  `page_id` int DEFAULT NULL,
  `items_variable` varchar(100) DEFAULT NULL,
  `subcategories_variable` varchar(100) DEFAULT NULL,
  `sort` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Дамп данных таблицы ddr_cms_last_2.categories: ~0 rows (приблизительно)

-- Дамп структуры для таблица ddr_cms_last_2.lists
CREATE TABLE IF NOT EXISTS `lists` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT NULL,
  `fields` text,
  `regroup` text,
  `list_in_list` json DEFAULT NULL,
  `sort` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Дамп данных таблицы ddr_cms_last_2.lists: ~0 rows (приблизительно)

-- Дамп структуры для таблица ddr_cms_last_2.lists_items
CREATE TABLE IF NOT EXISTS `lists_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `list_id` int NOT NULL DEFAULT '0',
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `--sort` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Дамп данных таблицы ddr_cms_last_2.lists_items: ~0 rows (приблизительно)

-- Дамп структуры для таблица ddr_cms_last_2.options
CREATE TABLE IF NOT EXISTS `options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `color` varchar(10) DEFAULT NULL,
  `sort` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Дамп данных таблицы ddr_cms_last_2.options: ~0 rows (приблизительно)

-- Дамп структуры для таблица ddr_cms_last_2.pages
CREATE TABLE IF NOT EXISTS `pages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `page_title` varchar(255) DEFAULT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `seo_url` varchar(255) DEFAULT NULL,
  `link_title` varchar(100) DEFAULT NULL,
  `header` int DEFAULT '0',
  `footer` int DEFAULT '0',
  `nav_mobile` int DEFAULT '0',
  `navigation` int DEFAULT '0',
  `meta_keywords` text,
  `meta_description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Дамп данных таблицы ddr_cms_last_2.pages: ~2 rows (приблизительно)

-- Дамп структуры для таблица ddr_cms_last_2.pages_sections
CREATE TABLE IF NOT EXISTS `pages_sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `page_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `navigation` int DEFAULT '0',
  `navigation_title` varchar(100) DEFAULT NULL,
  `showsection` int NOT NULL DEFAULT '1',
  `sort` int DEFAULT '0',
  `settings` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='привязка секций к старницам';

-- Дамп данных таблицы ddr_cms_last_2.pages_sections: ~2 rows (приблизительно)

-- Дамп структуры для таблица ddr_cms_last_2.patterns
CREATE TABLE IF NOT EXISTS `patterns` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

-- Дамп данных таблицы ddr_cms_last_2.patterns: ~0 rows (приблизительно)

-- Дамп структуры для таблица ddr_cms_last_2.products
CREATE TABLE IF NOT EXISTS `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `catalog_id` int DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `seo_url` varchar(100) DEFAULT NULL,
  `link_title` varchar(100) DEFAULT NULL,
  `meta_keywords` text,
  `meta_description` text,
  `article` varchar(50) DEFAULT NULL,
  `model` varchar(100) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `main_image` varchar(255) DEFAULT NULL,
  `threed` varchar(255) DEFAULT NULL,
  `gallery` json DEFAULT NULL,
  `videos` json DEFAULT NULL,
  `short_desc` text,
  `description` text,
  `price` int DEFAULT NULL,
  `price_old` int DEFAULT NULL,
  `price_label` int NOT NULL,
  `attributes` json DEFAULT NULL,
  `label` int DEFAULT NULL,
  `option_title` varchar(100) DEFAULT NULL,
  `option_color` varchar(10) DEFAULT NULL,
  `option_icon` varchar(255) DEFAULT NULL,
  `files` json DEFAULT NULL,
  `hashtags` json DEFAULT NULL,
  `icons` json DEFAULT NULL,
  `sort` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Товары';

-- Дамп данных таблицы ddr_cms_last_2.products: ~0 rows (приблизительно)

-- Дамп структуры для таблица ddr_cms_last_2.products_icons
CREATE TABLE IF NOT EXISTS `products_icons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `sort` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- Дамп данных таблицы ddr_cms_last_2.products_icons: ~0 rows (приблизительно)

-- Дамп структуры для таблица ddr_cms_last_2.products_options
CREATE TABLE IF NOT EXISTS `products_options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `product_option_id` int DEFAULT NULL,
  `title` varchar(500) DEFAULT NULL,
  `icon` varchar(500) DEFAULT NULL,
  `color` varchar(10) DEFAULT NULL,
  `sort` int DEFAULT '0',
  `position` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Дамп данных таблицы ddr_cms_last_2.products_options: ~0 rows (приблизительно)

-- Дамп структуры для таблица ddr_cms_last_2.products_reviews
CREATE TABLE IF NOT EXISTS `products_reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `from` varchar(100) DEFAULT NULL,
  `images` json DEFAULT NULL,
  `text` text,
  `rating` int DEFAULT NULL,
  `date` int DEFAULT NULL,
  `published` int unsigned DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Отзывы о товарах';

-- Дамп данных таблицы ddr_cms_last_2.products_reviews: ~0 rows (приблизительно)

-- Дамп структуры для таблица ddr_cms_last_2.products_to_categories
CREATE TABLE IF NOT EXISTS `products_to_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='категории к товарам';

-- Дамп данных таблицы ddr_cms_last_2.products_to_categories: ~0 rows (приблизительно)

-- Дамп структуры для таблица ddr_cms_last_2.sections
CREATE TABLE IF NOT EXISTS `sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `fields` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='fields - это поле, в которое заносятся поля, которые будут генерироваться в "настройках контенты"';

-- Дамп данных таблицы ddr_cms_last_2.sections: ~0 rows (приблизительно)

-- Дамп структуры для таблица ddr_cms_last_2.settings
CREATE TABLE IF NOT EXISTS `settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `param` varchar(255) DEFAULT NULL,
  `value` longtext,
  `json` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=utf8mb3;

-- Дамп данных таблицы ddr_cms_last_2.settings: ~7 rows (приблизительно)
INSERT INTO `settings` (`id`, `param`, `value`, `json`) VALUES
	(6, 'setting_email', '{"from":null,"to":null,"subject":"\\u0417\\u0430\\u0433\\u043e\\u043b\\u043e\\u0432\\u043e\\u043a \\u043f\\u0438\\u0441\\u044c\\u043c\\u0430","from_name":"\\u041e\\u0442\\u043f\\u0440\\u0430\\u0432\\u0438\\u0442\\u0435\\u043b\\u044c","contact":null}', 1),
	(7, 'setting_smtp', '{"host":null,"user":null,"pass":null,"port":null,"crypto":null}', 1),
	(12, 'setting_setvarstocats', '0', 0),
	(13, 'setting_setvarstocatalogs', '0', 0),
	(59, 'setting_strict_filters', '{"tags":0,"icons":0}', 1),
	(94, 'setting_og', NULL, 1),
	(164, 'setting_tinypng_api_key', NULL, 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
