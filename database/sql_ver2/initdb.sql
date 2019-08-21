-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema fineli_ver_2
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema fineli_ver_2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `fineli_ver_2` DEFAULT CHARACTER SET utf8 ;
USE `fineli_ver_2` ;

-- -----------------------------------------------------
-- Table `fineli_ver_2`.`tietolahde`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`tietolahde` (
  `thscode` CHAR(1) NOT NULL,
  `description` VARCHAR(85) NULL,
  `lang` VARCHAR(2) NULL,
  PRIMARY KEY (`thscode`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`ravintotekijaluokka`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`ravintotekijaluokka` (
  `thscode` VARCHAR(15) NOT NULL,
  `description` VARCHAR(45) NULL,
  `lang` VARCHAR(2) NULL,
  PRIMARY KEY (`thscode`))
ENGINE = InnoDB
COMMENT = 'cmpclass_FI.csv';


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`ravintotekijayksikko`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`ravintotekijayksikko` (
  `thscode` VARCHAR(15) NOT NULL,
  `description` VARCHAR(45) NULL,
  `lang` VARCHAR(2) NULL,
  PRIMARY KEY (`thscode`))
ENGINE = InnoDB
COMMENT = 'compunit_FI.csv';


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`ravintotekijanimi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`ravintotekijanimi` (
  `thscode` VARCHAR(15) NOT NULL,
  `description` VARCHAR(145) NULL,
  `lang` VARCHAR(2) NULL,
  PRIMARY KEY (`thscode`))
ENGINE = InnoDB
COMMENT = 'eufdname_FI.csv';


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`ravintotekija`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`ravintotekija` (
  `eufdname` VARCHAR(15) NOT NULL,
  `compunit` VARCHAR(15) NULL,
  `cmpclass` VARCHAR(15) NULL,
  `cmpclassp` VARCHAR(15) NULL,
  PRIMARY KEY (`eufdname`),
  INDEX `fk_ravintotekija_1_idx` (`compunit` ASC),
  INDEX `fk_ravintotekija_3_idx` (`cmpclass` ASC),
  INDEX `fk_ravintotekija_4_idx` (`cmpclassp` ASC),
  CONSTRAINT `fk_ravintotekija_1`
    FOREIGN KEY (`compunit`)
    REFERENCES `fineli_ver_2`.`ravintotekijayksikko` (`thscode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ravintotekija_2`
    FOREIGN KEY (`eufdname`)
    REFERENCES `fineli_ver_2`.`ravintotekijanimi` (`thscode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ravintotekija_3`
    FOREIGN KEY (`cmpclass`)
    REFERENCES `fineli_ver_2`.`ravintotekijaluokka` (`thscode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ravintotekija_4`
    FOREIGN KEY (`cmpclassp`)
    REFERENCES `fineli_ver_2`.`ravintotekijaluokka` (`thscode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'component.csv\n\r\nEUFDNAME (Ravintotekijän koodi, teksti)\n\r\nCOMPUNIT (Yksikön koodi, teksti)\n\r\nCMPCLASS (Ravintotekijäluokan koodi, teksti)\n\r\nCMPCLASSP (Ravintotekijäluokan koodi, luokan ylempi taso, teksti)';


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`raakaaineluokka`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`raakaaineluokka` (
  `thscode` VARCHAR(15) NOT NULL,
  `description` VARCHAR(45) NULL,
  `lang` VARCHAR(2) NULL,
  PRIMARY KEY (`thscode`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`ruoankayttoluokka`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`ruoankayttoluokka` (
  `thscode` VARCHAR(15) NOT NULL,
  `description` VARCHAR(75) NULL,
  `lang` VARCHAR(2) NULL,
  PRIMARY KEY (`thscode`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`valmistustapa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`valmistustapa` (
  `thscode` VARCHAR(15) NOT NULL,
  `description` VARCHAR(45) NULL,
  `lang` VARCHAR(2) NULL,
  PRIMARY KEY (`thscode`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`elintarviketyyppi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`elintarviketyyppi` (
  `thscode` VARCHAR(15) NOT NULL,
  `description` VARCHAR(45) NULL,
  `lang` VARCHAR(2) NULL,
  PRIMARY KEY (`thscode`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`elintarvike`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`elintarvike` (
  `foodid` INT NOT NULL,
  `foodname` VARCHAR(115) NULL,
  `foodtype` VARCHAR(15) NULL,
  `process` VARCHAR(15) NULL,
  `edport` INT NULL,
  `igclass` VARCHAR(15) NULL,
  `igclassp` VARCHAR(15) NULL,
  `fuclass` VARCHAR(15) NULL,
  `fuclassp` VARCHAR(15) NULL,
  PRIMARY KEY (`foodid`),
  INDEX `fk_elintarvike_1_idx` (`igclass` ASC),
  INDEX `fk_elintarvike_2_idx` (`igclassp` ASC),
  INDEX `fk_elintarvike_3_idx` (`fuclass` ASC),
  INDEX `fk_elintarvike_4_idx` (`fuclassp` ASC),
  INDEX `fk_elintarvike_5_idx` (`process` ASC),
  INDEX `fk_elintarvike_6_idx` (`foodtype` ASC),
  CONSTRAINT `fk_elintarvike_1`
    FOREIGN KEY (`igclass`)
    REFERENCES `fineli_ver_2`.`raakaaineluokka` (`thscode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_elintarvike_2`
    FOREIGN KEY (`igclassp`)
    REFERENCES `fineli_ver_2`.`raakaaineluokka` (`thscode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_elintarvike_3`
    FOREIGN KEY (`fuclass`)
    REFERENCES `fineli_ver_2`.`ruoankayttoluokka` (`thscode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_elintarvike_4`
    FOREIGN KEY (`fuclassp`)
    REFERENCES `fineli_ver_2`.`ruoankayttoluokka` (`thscode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_elintarvike_5`
    FOREIGN KEY (`process`)
    REFERENCES `fineli_ver_2`.`valmistustapa` (`thscode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_elintarvike_6`
    FOREIGN KEY (`foodtype`)
    REFERENCES `fineli_ver_2`.`elintarviketyyppi` (`thscode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'food.csv\n\nfoodname: nimi (Kananmuna, luomu..)\n\nfoodtype: tyyppikoodi\n\nprocess: valmistustavan koodi\n\nedport: syötävä osuus, prosenttia\n\nigclass: raaka-aineluokan koodi\n\nigclassp: raaka-aineluokan koodi, ylempi taso\n\nfuclass: ruoankayttoluokan koodi\n\nfuclassp: ruoankayttoluokan koodi, ylempi taso';


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`menetelmatyyppi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`menetelmatyyppi` (
  `thscode` VARCHAR(2) NOT NULL,
  `description` VARCHAR(55) NULL,
  `lang` VARCHAR(2) NULL,
  PRIMARY KEY (`thscode`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`ravintoarvo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`ravintoarvo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `foodid` INT NOT NULL,
  `eufdname` VARCHAR(15) NULL,
  `bestloc` DECIMAL(8,2) NULL,
  `acqtype` CHAR(1) NULL,
  `methtype` VARCHAR(2) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_ravintoarvo_1_idx` (`foodid` ASC),
  INDEX `fk_ravintoarvo_2_idx` (`eufdname` ASC),
  INDEX `fk_ravintoarvo_3_idx` (`acqtype` ASC),
  INDEX `fk_ravintoarvo_4_idx` (`methtype` ASC),
  CONSTRAINT `fk_ravintoarvo_1`
    FOREIGN KEY (`foodid`)
    REFERENCES `fineli_ver_2`.`elintarvike` (`foodid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ravintoarvo_2`
    FOREIGN KEY (`eufdname`)
    REFERENCES `fineli_ver_2`.`ravintotekija` (`eufdname`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ravintoarvo_3`
    FOREIGN KEY (`acqtype`)
    REFERENCES `fineli_ver_2`.`tietolahde` (`thscode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ravintoarvo_4`
    FOREIGN KEY (`methtype`)
    REFERENCES `fineli_ver_2`.`menetelmatyyppi` (`thscode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'component_value.csv\n\r\nFOODID (Elintarvikkeen tunnus, numero)\n\r\nEUFDNAME (Ravintotekijän koodi, teksti)\r\n\nBESTLOC (Ravintoarvo, numero)\r\n\nACQTYPE (Tietolähteen koodi, teksti)\r\n\nMETHTYPE (Menetelmätyypin koodi, teksti)\n';


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`resepti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`resepti` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `foodid` INT NULL,
  `confdid` INT NULL,
  `amount` DECIMAL(10,5) NULL,
  `foodunit` CHAR(1) NULL,
  `mass` DECIMAL(10,5) NULL,
  `evremain` INT NULL,
  `recyear` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_resepti_1_idx` (`foodid` ASC),
  INDEX `fk_resepti_2_idx` (`confdid` ASC),
  CONSTRAINT `fk_resepti_1`
    FOREIGN KEY (`foodid`)
    REFERENCES `fineli_ver_2`.`elintarvike` (`foodid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_resepti_2`
    FOREIGN KEY (`confdid`)
    REFERENCES `fineli_ver_2`.`elintarvike` (`foodid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`elintarvikeyksikko`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`elintarvikeyksikko` (
  `thscode` VARCHAR(15) NOT NULL,
  `description` VARCHAR(45) NULL,
  `lang` VARCHAR(2) NULL,
  PRIMARY KEY (`thscode`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`elintarvikemitat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`elintarvikemitat` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `foodid` INT NULL,
  `foodunit` VARCHAR(15) NULL,
  `mass` DECIMAL(7,2) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_elintarvikemitat_1_idx` (`foodid` ASC),
  INDEX `fk_elintarvikemitat_2_idx` (`foodunit` ASC),
  CONSTRAINT `fk_elintarvikemitat_1`
    FOREIGN KEY (`foodid`)
    REFERENCES `fineli_ver_2`.`elintarvike` (`foodid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_elintarvikemitat_2`
    FOREIGN KEY (`foodunit`)
    REFERENCES `fineli_ver_2`.`elintarvikeyksikko` (`thscode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`elintarvikenimi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`elintarvikenimi` (
  `foodid` INT NOT NULL,
  `foodname` VARCHAR(115) NULL,
  `lang` VARCHAR(2) NULL,
  PRIMARY KEY (`foodid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`erityisruokavalio_fi`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`erityisruokavalio_fi` (
  `thscode` VARCHAR(15) NOT NULL,
  `description` VARCHAR(500) NULL,
  `lang` VARCHAR(25) NULL,
  `shortname` VARCHAR(90) NULL,
  PRIMARY KEY (`thscode`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`erityisruokavalio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`erityisruokavalio` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `foodid` INT NULL,
  `specdiet` VARCHAR(15) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_erityisruokavalio_1_idx` (`foodid` ASC),
  INDEX `fk_erityisruokavalio_2_idx` (`specdiet` ASC),
  CONSTRAINT `fk_erityisruokavalio_1`
    FOREIGN KEY (`foodid`)
    REFERENCES `fineli_ver_2`.`elintarvike` (`foodid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_erityisruokavalio_2`
    FOREIGN KEY (`specdiet`)
    REFERENCES `fineli_ver_2`.`erityisruokavalio_fi` (`thscode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`suositukset`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`suositukset` (
  `user_id` VARCHAR(90) NOT NULL,
  `alc` DECIMAL(8,2) NULL,
  `enerc` DECIMAL(8,2) NULL,
  `choavl` DECIMAL(8,2) NULL,
  `prot` DECIMAL(8,2) NULL,
  `fat` DECIMAL(8,2) NULL,
  `vite` DECIMAL(8,2) NULL,
  `vitd` DECIMAL(8,2) NULL,
  `vitk` DECIMAL(8,2) NULL,
  `carotens` DECIMAL(8,2) NULL,
  `vita` DECIMAL(8,2) NULL,
  `nia` DECIMAL(8,2) NULL,
  `vitb12` DECIMAL(8,2) NULL,
  `niaeq` DECIMAL(8,2) NULL,
  `vitpyrid` DECIMAL(8,2) NULL,
  `ribf` DECIMAL(8,2) NULL,
  `fol` DECIMAL(8,2) NULL,
  `thia` DECIMAL(8,2) NULL,
  `vitc` DECIMAL(8,2) NULL,
  `fibc` DECIMAL(8,2) NULL,
  `fibins` DECIMAL(8,2) NULL,
  `oa` DECIMAL(8,2) NULL,
  `sugoh` DECIMAL(8,2) NULL,
  `psacncs` DECIMAL(8,2) NULL,
  `frus` DECIMAL(8,2) NULL,
  `gals` DECIMAL(8,2) NULL,
  `sucs` DECIMAL(8,2) NULL,
  `glus` DECIMAL(8,2) NULL,
  `sugar` DECIMAL(8,2) NULL,
  `lacs` DECIMAL(8,2) NULL,
  `mals` DECIMAL(8,2) NULL,
  `starch` DECIMAL(8,2) NULL,
  `fapu` DECIMAL(8,2) NULL,
  `f18d3n3` DECIMAL(8,2) NULL,
  `fapun3` DECIMAL(8,2) NULL,
  `f20d5n3` DECIMAL(8,2) NULL,
  `fapun6` DECIMAL(8,2) NULL,
  `f22d6n3` DECIMAL(8,2) NULL,
  `fasat` DECIMAL(8,2) NULL,
  `fatrn` DECIMAL(8,2) NULL,
  `fafre` DECIMAL(8,2) NULL,
  `famcis` DECIMAL(8,2) NULL,
  `f18d2cn6` DECIMAL(8,2) NULL,
  `stert` DECIMAL(8,2) NULL,
  `chole` DECIMAL(8,2) NULL,
  `zn` DECIMAL(8,2) NULL,
  `fe` DECIMAL(8,2) NULL,
  `id` DECIMAL(8,2) NULL,
  `se` DECIMAL(8,2) NULL,
  `p` DECIMAL(8,2) NULL,
  `k` DECIMAL(8,2) NULL,
  `ca` DECIMAL(8,2) NULL,
  `mg` DECIMAL(8,2) NULL,
  `na` DECIMAL(8,2) NULL,
  `nacl` DECIMAL(8,2) NULL,
  `trp` DECIMAL(8,2) NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_suositukset_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `fineli_ver_2`.`user` (`email`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(90) NOT NULL,
  `passhash` CHAR(60) NOT NULL,
  `gender` VARCHAR(6) NOT NULL,
  `recommendation` VARCHAR(90) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `passhash_UNIQUE` (`passhash` ASC),
  INDEX `fk_user_1_idx` (`recommendation` ASC),
  CONSTRAINT `fk_user_1`
    FOREIGN KEY (`recommendation`)
    REFERENCES `fineli_ver_2`.`suositukset` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`ateria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`ateria` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `pvm` TIMESTAMP NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_ateria_1_idx` (`user_id` ASC),
  CONSTRAINT `fk_ateria_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `fineli_ver_2`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fineli_ver_2`.`ateria_elintarvike`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `fineli_ver_2`.`ateria_elintarvike` (
  `meal_id` INT NOT NULL,
  `foodid` INT NOT NULL,
  `amount` INT NOT NULL,
  PRIMARY KEY (`meal_id`, `foodid`),
  INDEX `fk_ateria_elintarvike_2_idx` (`foodid` ASC),
  CONSTRAINT `fk_ateria_elintarvike_1`
    FOREIGN KEY (`meal_id`)
    REFERENCES `fineli_ver_2`.`ateria` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ateria_elintarvike_2`
    FOREIGN KEY (`foodid`)
    REFERENCES `fineli_ver_2`.`elintarvike` (`foodid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
