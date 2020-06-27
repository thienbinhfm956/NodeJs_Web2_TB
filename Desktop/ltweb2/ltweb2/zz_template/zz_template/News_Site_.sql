-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema News_Site
-- -----------------------------------------------------
-- 
-- WEBSITE TIN TỨC

-- -----------------------------------------------------
-- Schema News_Site
--
-- 
-- WEBSITE TIN TỨC
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `News_Site` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `News_Site` ;

-- -----------------------------------------------------
-- Table `News_Site`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `News_Site`.`category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name_utf8` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_general_ci' NOT NULL COMMENT 'tên Tiếng Việt có dấu',
  `name_asni` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_general_ci' NULL COMMENT 'tên không dấu',
  `sequence` INT NULL COMMENT 'thứ tự bài viết',
  `is_delete` TINYINT(1) NULL DEFAULT 0 COMMENT '1: true - đã xoá, 0: false - chưa xoá',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `sequence_UNIQUE` (`sequence` ASC) ,
  FULLTEXT INDEX `fts_category` (`name_utf8`, `name_asni`) )
ENGINE = InnoDB 
DEFAULT CHARACTER SET = utf8 COLLATE = utf8_general_ci;

-- -----------------------------------------------------
-- Table `News_Site`.`subcategory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `News_Site`.`subcategory` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name_utf8` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_general_ci' NOT NULL COMMENT 'tên Tiếng Việt có dấu',
  `name_asni` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_general_ci' NULL COMMENT 'tên không dấu',
  `sequence` INT NULL COMMENT 'thứ tự bài viết',
  `id_category` INT NOT NULL,
  `is_delete` TINYINT(1) NULL DEFAULT 0 COMMENT '1: true - đã xoá, 0: false - chưa xoá',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name_utf8` ASC) ,
  UNIQUE INDEX `name_asni_UNIQUE` (`name_asni` ASC) ,
  UNIQUE INDEX `sequence_UNIQUE` (`sequence` ASC) ,
  FULLTEXT INDEX `fts_subcategory` (`name_utf8`, `name_asni`) ,
  INDEX `fk_subcategory_id_category_idx` (`id_category` ASC) ,
  CONSTRAINT `fk_subcategory_id_category`
    FOREIGN KEY (`id_category`)
    REFERENCES `News_Site`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB 
DEFAULT CHARACTER SET = utf8 COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `News_Site`.`user_permission`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `News_Site`.`user_permission` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '1: admin\n2: editor\n3: writer\n4: subcriber',
  `key` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_general_ci' NOT NULL COMMENT '1: admin\n2: editor\n3: writer\n4: subcriber',
  `id_delete` TINYINT(1) NULL DEFAULT 0 COMMENT '1: true - đã xoá, 0: false - chưa xoá',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `typename_UNIQUE` (`key` ASC) )
ENGINE = InnoDB 
DEFAULT CHARACTER SET = utf8 COLLATE = utf8_general_ci;

-- -----------------------------------------------------
-- Table `News_Site`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `News_Site`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(128) NOT NULL,
  `displayname` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_general_ci' NOT NULL,
  `id_permission` INT DEFAULT 4 COMMENT '1: admin\n2: editor\n3: writer\n4: subcriber',
  `created_date` DATETIME NOT NULL,
  `email` VARCHAR(45) NULL,
  `date_of_birth` DATE NULL,
  `is_delete` TINYINT(1) NULL DEFAULT 0 COMMENT '1: true - đã xoá, 0: false - chưa xoá',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) ,
  -- UNIQUE INDEX `password_UNIQUE` (`password` ASC) ,
  -- UNIQUE INDEX `displayname_UNIQUE` (`displayname` ASC) ,
  INDEX `fk_id_persmission_idx` (`id_permission` ASC) ,
  CONSTRAINT `fk_user_id_persmission`
    FOREIGN KEY (`id_permission`)
    REFERENCES `News_Site`.`user_permission` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB 
DEFAULT CHARACTER SET = utf8 COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `News_Site`.`post`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `News_Site`.`post` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title_utf8` VARCHAR(100) CHARACTER SET 'utf8' COLLATE 'utf8_general_ci' NOT NULL COMMENT 'là tiêu đề Tiếng Việt có dấu',
  `title_ansi` VARCHAR(100) CHARACTER SET 'utf8' COLLATE 'utf8_general_ci' NULL COMMENT 'là tiêu đề không dấu',
  `post_date` DATETIME NOT NULL,
  `last_update` DATETIME NULL,
  `id_user` INT NOT NULL,
  `views` INT NULL,
  `id_category` INT NOT NULL,
  `id_subcategory` INT NULL,
  `content` LONGTEXT NOT NULL,
  `summary` TEXT NULL,
  `description` VARCHAR(100) CHARACTER SET 'utf8' COLLATE 'utf8_general_ci' NULL,
  `tag` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_general_ci' NULL,
  `status` TINYINT(2) NOT NULL DEFAULT 4 COMMENT '1:   Đã được duyệt & chờ xuất bản\n2:   Đã xuất bản\n3:   Bị từ chối\n4:   Chưa được duyệt\n',
  `is_premium` TINYINT(1) NULL DEFAULT 0 COMMENT '1: true, 0: false',
  `is_delete` TINYINT(1) NULL DEFAULT 0 COMMENT '1: true - đã xoá, 0: false - chưa xoá',
  PRIMARY KEY (`id`),
  INDEX `fk_id_category_idx` (`id_category` ASC) ,
  INDEX `fk_id_subcategory_idx` (`id_subcategory` ASC) ,
  INDEX `fk_id_user_idx` (`id_user` ASC) ,
  FULLTEXT INDEX `fts_post` (`title_utf8`, `summary`, `content`, `title_ansi`, `tag`) ,
  CONSTRAINT `fk_post_id_category`
    FOREIGN KEY (`id_category`)
    REFERENCES `News_Site`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_id_subcategory`
    FOREIGN KEY (`id_subcategory`)
    REFERENCES `News_Site`.`subcategory` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_id_user`
    FOREIGN KEY (`id_user`)
    REFERENCES `News_Site`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB 
DEFAULT CHARACTER SET = utf8 COLLATE = utf8_general_ci;

-- -----------------------------------------------------
-- Table `News_Site`.`comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `News_Site`.`comment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `displayname` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_general_ci' NOT NULL,
  `content` TEXT NOT NULL,
  `comment_date` DATETIME NOT NULL,
  `last_update` DATETIME NULL,
  `id_post` INT NOT NULL,
  `is_delete` TINYINT(1) NULL DEFAULT 0 COMMENT '1: true - đã xoá, 0: false - chưa xoá',
  PRIMARY KEY (`id`),
  INDEX `fk_id_post_idx` (`id_post` ASC) ,
  CONSTRAINT `fk_comment_id_post`
    FOREIGN KEY (`id_post`)
    REFERENCES `News_Site`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB 
DEFAULT CHARACTER SET = utf8 COLLATE = utf8_general_ci;

-- -----------------------------------------------------
-- Table `News_Site`.`post_image`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `News_Site`.`post_image` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_post` INT NOT NULL,
  `description` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_general_ci' NULL,
  `is_delete` TINYINT(1) NULL DEFAULT 0 COMMENT '1: true - đã xoá, 0: false - chưa xoá',
  PRIMARY KEY (`id`),
  INDEX `fk_id_post_idx` (`id_post` ASC) ,
  CONSTRAINT `fk_image_id_post`
    FOREIGN KEY (`id_post`)
    REFERENCES `News_Site`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB 
DEFAULT CHARACTER SET = utf8 COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `News_Site`.`subscriber`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `News_Site`.`subscriber` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `expiration_date` DATETIME NULL,
  `id_user` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_id_user_idx` (`id_user` ASC) ,
  CONSTRAINT `fk_subcriber_id_user`
    FOREIGN KEY (`id_user`)
    REFERENCES `News_Site`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB 
DEFAULT CHARACTER SET = utf8 COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `News_Site`.`writer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `News_Site`.`writer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `posted` INT NULL DEFAULT 0 COMMENT 'số bài báo đã viết',
  `id_user` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_id_user_idx` (`id_user` ASC) ,
  CONSTRAINT `fk_writer_id_user`
    FOREIGN KEY (`id_user`)
    REFERENCES `News_Site`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB 
DEFAULT CHARACTER SET = utf8 COLLATE = utf8_general_ci;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
