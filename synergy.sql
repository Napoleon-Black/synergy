SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Users
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Users` ;

-- -----------------------------------------------------
-- Schema Users
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Users` DEFAULT CHARACTER SET utf8 ;
USE `Users` ;

-- -----------------------------------------------------
-- Table `Users`.`courses_courses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Users`.`courses_courses` ;

CREATE TABLE IF NOT EXISTS `Users`.`courses_courses` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `code` VARCHAR(7) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC),
  UNIQUE INDEX `code` (`code` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Users`.`courses_users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Users`.`courses_users` ;

CREATE TABLE IF NOT EXISTS `Users`.`courses_users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  `status` TINYINT(1) NOT NULL,
  `phone` VARCHAR(13) NULL DEFAULT NULL,
  `mobile_phone` VARCHAR(13) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email` (`email` ASC),
  INDEX `name` (`name` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 26
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `Users`.`courses_users_courses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Users`.`courses_users_courses` ;

CREATE TABLE IF NOT EXISTS `Users`.`courses_users_courses` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `users_id` INT(11) NOT NULL,
  `courses_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `courses_users_courses_users_id_courses_id_30f31c11_uniq` (`users_id` ASC, `courses_id` ASC),
  INDEX `courses_users_courses_courses_id_dd7d33e5_fk_courses_courses_id` (`courses_id` ASC),
  CONSTRAINT `courses_users_courses_courses_id_dd7d33e5_fk_courses_courses_id`
    FOREIGN KEY (`courses_id`)
    REFERENCES `Users`.`courses_courses` (`id`),
  CONSTRAINT `courses_users_courses_users_id_89a6ec61_fk_courses_users_id`
    FOREIGN KEY (`users_id`)
    REFERENCES `Users`.`courses_users` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8;

USE `Users` ;

-- -----------------------------------------------------
-- procedure add_user
-- -----------------------------------------------------

USE `Users`;
DROP procedure IF EXISTS `Users`.`add_user`;

DELIMITER $$
USE `Users`$$
CREATE DEFINER=`Users_user`@`localhost` PROCEDURE `add_user`(
	IN `p_name` VARCHAR(50),
    IN `p_email` VARCHAR(50),
    IN `p_status` BOOLEAN,
    IN `p_phone` VARCHAR(13),
    IN `p_mobile_phone` VARCHAR(13)
)
BEGIN
	INSERT INTO `courses_users` (`name`, `email`, `status`, `phone`, `mobile_phone`)
    VALUES (p_name, p_email, p_status, p_phone, p_mobile_phone);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure add_users_course
-- -----------------------------------------------------

USE `Users`;
DROP procedure IF EXISTS `Users`.`add_users_course`;

DELIMITER $$
USE `Users`$$
CREATE DEFINER=`Users_user`@`localhost` PROCEDURE `add_users_course`(
	IN `p_user_id` INT,
    IN `p_course_id` INT
)
BEGIN
	INSERT INTO `courses_users_courses` (`users_id`, `courses_id`)
    VALUES (p_user_id, p_course_id);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure change_user
-- -----------------------------------------------------

USE `Users`;
DROP procedure IF EXISTS `Users`.`change_user`;

DELIMITER $$
USE `Users`$$
CREATE DEFINER=`Users_user`@`localhost` PROCEDURE `change_user`(
	IN `user_id` INT,
	IN `p_name` VARCHAR(50),
    IN `p_email` VARCHAR(50),
    IN `p_status` BOOLEAN,
    IN `p_phone` VARCHAR(13),
    IN `p_mobile_phone` VARCHAR(13)
)
BEGIN
	UPDATE `courses_users`
    SET `name` = p_name, `email` = p_email, `status` = p_status, `phone` = p_phone, `mobile_phone` = p_mobile_phone
    WHERE `id` = user_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure get_courses_list
-- -----------------------------------------------------

USE `Users`;
DROP procedure IF EXISTS `Users`.`get_courses_list`;

DELIMITER $$
USE `Users`$$
CREATE DEFINER=`Users_user`@`localhost` PROCEDURE `get_courses_list`()
BEGIN
	SELECT `id`, `name`, `code` FROM `courses_courses`;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure get_user
-- -----------------------------------------------------

USE `Users`;
DROP procedure IF EXISTS `Users`.`get_user`;

DELIMITER $$
USE `Users`$$
CREATE DEFINER=`Users_user`@`localhost` PROCEDURE `get_user`(
	IN `user_id` INT
)
BEGIN
	SELECT `name`, `email`, `phone`, `mobile_phone`, `status`
    FROM `courses_users`
    WHERE `courses_users`.`id` = user_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure get_users_courses
-- -----------------------------------------------------

USE `Users`;
DROP procedure IF EXISTS `Users`.`get_users_courses`;

DELIMITER $$
USE `Users`$$
CREATE DEFINER=`Users_user`@`localhost` PROCEDURE `get_users_courses`(
	IN `user_id` INT
)
BEGIN
	SELECT `courses_courses`.`id`, `courses_courses`.`name`, `courses_courses`.`code`
    FROM `courses_courses` INNER JOIN `courses_users_courses`
    ON (`courses_courses`.`id` = `courses_users_courses`.`courses_id`)
    WHERE `courses_users_courses`.`users_id` = user_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure get_users_list
-- -----------------------------------------------------

USE `Users`;
DROP procedure IF EXISTS `Users`.`get_users_list`;

DELIMITER $$
USE `Users`$$
CREATE DEFINER=`Users_user`@`localhost` PROCEDURE `get_users_list`(
	IN `order_by` VARCHAR(12)
)
BEGIN
	SELECT `id`, `name`, `email`, `status`
    FROM `courses_users`
    ORDER BY order_by;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure remove_user
-- -----------------------------------------------------

USE `Users`;
DROP procedure IF EXISTS `Users`.`remove_user`;

DELIMITER $$
USE `Users`$$
CREATE DEFINER=`Users_user`@`localhost` PROCEDURE `remove_user`(
	IN `user_id` INT
)
BEGIN
	DELETE FROM `courses_users`
    WHERE `courses_users`.`id` = user_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure remove_users_course
-- -----------------------------------------------------

USE `Users`;
DROP procedure IF EXISTS `Users`.`remove_users_course`;

DELIMITER $$
USE `Users`$$
CREATE DEFINER=`Users_user`@`localhost` PROCEDURE `remove_users_course`(
	IN `p_user_id` INT
)
BEGIN
	DELETE FROM `courses_users_courses`
    WHERE `users_id` = p_user_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure search_users
-- -----------------------------------------------------

USE `Users`;
DROP procedure IF EXISTS `Users`.`search_users`;

DELIMITER $$
USE `Users`$$
CREATE DEFINER=`Users_user`@`localhost` PROCEDURE `search_users`(
	IN `user_filter` VARCHAR(50),
    IN `order_by` VARCHAR(12)
)
BEGIN
	SELECT `id`, `name`, `email`, `status`
    FROM `courses_users`
    WHERE `name` LIKE CONCAT(user_filter, '%')
    ORDER BY order_by;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
