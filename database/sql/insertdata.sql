SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL, ALLOW_INVALID_DATES';

LOAD DATA LOCAL INFILE './database/data_csv/acqtype_FI.csv' 
INTO TABLE tietolahde 
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(thscode, description, lang);

LOAD DATA LOCAL INFILE './database/data_csv/cmpclass_FI.csv' 
INTO TABLE ravintotekijaluokka 
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(thscode, description, lang);

LOAD DATA LOCAL INFILE './database/data_csv/component.csv' 
INTO TABLE ravintotekija 
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(eufdname, compunit, cmpclass, cmpclassp);

LOAD DATA LOCAL INFILE './database/data_csv/component_value.csv' 
INTO TABLE ravintoarvo 
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(foodid, eufdname, bestloc, acqtype, methtype);

LOAD DATA LOCAL INFILE './database/data_csv/compunit_FI.csv' 
INTO TABLE ravintotekijayksikko 
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(thscode, description, lang);

LOAD DATA LOCAL INFILE './database/data_csv/contribfood.csv' 
INTO TABLE resepti 
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(foodid, confdid, amount, foodunit, mass, evremain, recyear);

LOAD DATA LOCAL INFILE './database/data_csv/eufdname_FI.csv' 
INTO TABLE ravintotekijanimi 
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(thscode, description, lang);

LOAD DATA LOCAL INFILE './database/data_csv/food.csv' 
INTO TABLE elintarvike 
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(foodid, foodname, foodtype, process, edport, igclass, igclassp, fuclass, fuclassp);

LOAD DATA LOCAL INFILE './database/data_csv/foodaddunit.csv' 
INTO TABLE elintarvikemitat 
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(foodid, foodunit, mass);

LOAD DATA LOCAL INFILE './database/data_csv/foodtype_FI.csv' 
INTO TABLE elintarviketyyppi
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(thscode, description, lang);

LOAD DATA LOCAL INFILE './database/data_csv/foodunit_FI.csv' 
INTO TABLE elintarvikeyksikko
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(thscode, description, lang);

LOAD DATA LOCAL INFILE './database/data_csv/fuclass_FI.csv' 
INTO TABLE ruoankayttoluokka
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(thscode, description, lang);

LOAD DATA LOCAL INFILE './database/data_csv/igclass_FI.csv' 
INTO TABLE raakaaineluokka
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(thscode, description, lang);

LOAD DATA LOCAL INFILE './database/data_csv/methtype_FI.csv' 
INTO TABLE menetelmatyyppi
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(thscode, description, lang);

LOAD DATA LOCAL INFILE './database/data_csv/process_FI.csv' 
INTO TABLE valmistustapa
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(thscode, description, lang);

LOAD DATA LOCAL INFILE './database/data_csv/specdiet.csv' 
INTO TABLE erityisruokavalio
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(foodid, specdiet);

LOAD DATA LOCAL INFILE './database/data_csv/specdiet_FI.csv' 
INTO TABLE erityisruokavalio_fi
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(thscode, description, lang);

LOAD DATA LOCAL INFILE './database/data_csv/suositukset.csv' 
INTO TABLE suositukset
FIELDS TERMINATED BY ';' ENCLOSED BY '' LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(USER_ID,ALC,ENERC,CHOAVL,PROT,FAT,VITE,VITD,VITK,CAROTENS,VITA,NIA,VITB12,NIAEQ,VITPYRID,RIBF,FOL,THIA,VITC,FIBC,FIBINS,OA,SUGOH,PSACNCS,FRUS,GALS,SUCS,GLUS,SUGAR,LACS,MALS,STARCH,FAPU,F18D3N3,FAPUN3,F20D5N3,FAPUN6,F22D6N3,FASAT,FATRN,FAFRE,FAMCIS,F18D2CN6,STERT,CHOLE,ZN,FE,ID,SE,P,K,CA,MG,NA,NACL,TRP);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

