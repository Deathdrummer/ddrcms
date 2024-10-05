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

CREATE TABLE IF NOT EXISTS `lists` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT NULL,
  `fields` text,
  `regroup` text,
  `list_in_list` json DEFAULT NULL,
  `sort` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `lists_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `list_id` int NOT NULL DEFAULT '0',
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `--sort` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `color` varchar(10) DEFAULT NULL,
  `sort` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3;

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `pages_sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `page_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `navigation` int DEFAULT '0',
  `navigation_title` varchar(100) DEFAULT NULL,
  `showsection` int NOT NULL DEFAULT '1',
  `sort` int DEFAULT '0',
  `settings` text,
  `uid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COMMENT='привязка секций к старницам';

CREATE TABLE IF NOT EXISTS `patterns` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

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

CREATE TABLE IF NOT EXISTS `products_icons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `sort` int DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

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

CREATE TABLE IF NOT EXISTS `products_to_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='категории к товарам';

CREATE TABLE IF NOT EXISTS `sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `fields` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COMMENT='fields - это поле, в которое заносятся поля, которые будут генерироваться в "настройках контенты"';

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `param` varchar(255) DEFAULT NULL,
  `value` longtext,
  `json` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=utf8mb3;