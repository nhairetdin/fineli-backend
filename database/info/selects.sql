SELECT elintarvike.foodid, elintarvike.foodname, ravintoarvo.eufdname, ravintoarvo.bestloc, ravintotekija.compunit, ravintotekijanimi.description 
FROM elintarvike JOIN ravintoarvo 
ON elintarvike.foodid = ravintoarvo.foodid 
JOIN ravintotekija 
ON ravintoarvo.eufdname = ravintotekija.eufdname 
JOIN ravintotekijanimi 
ON ravintotekija.eufdname = ravintotekijanimi.thscode 
WHERE elintarvike.foodid = 34661;

CREATE VIEW v_ravintoarvot AS
    SELECT elintarvike.foodid, elintarvike.foodname, ravintoarvo.eufdname, ravintoarvo.bestloc, ravintotekija.compunit, ravintotekijanimi.description 
    FROM elintarvike JOIN ravintoarvo 
    ON elintarvike.foodid = ravintoarvo.foodid 
    JOIN ravintotekija 
    ON ravintoarvo.eufdname = ravintotekija.eufdname 
    JOIN ravintotekijanimi 
    ON ravintotekija.eufdname = ravintotekijanimi.thscode;

-- create new table based on select result:
CREATE TABLE elintarvike_ravintoarvot
    SELECT elintarvike.foodid, elintarvike.foodname, ravintoarvo.eufdname, ravintoarvo.bestloc, ravintotekija.compunit, ravintotekijanimi.description 
    FROM elintarvike JOIN ravintoarvo 
    ON elintarvike.foodid = ravintoarvo.foodid 
    JOIN ravintotekija 
    ON ravintoarvo.eufdname = ravintotekija.eufdname 
    JOIN ravintotekijanimi 
    ON ravintotekija.eufdname = ravintotekijanimi.thscode;

-- and index for it:
CREATE INDEX idx_elintarvike_ravintoarvot_1 ON elintarvike_ravintoarvot(foodid);

-- ravintotekijät ja tiedot yhdeksi tauluksi:
SELECT 
 ravintotekija.eufdname AS koodi, 
 ravintotekijanimi.description AS nimi, 
 ravintotekijayksikko.thscode AS yksikko,
 r1.description AS luokka,
 r2.description AS ylempiluokka
FROM ravintotekija 
 JOIN ravintotekijanimi ON ravintotekija.eufdname = ravintotekijanimi.thscode
 JOIN ravintotekijayksikko ON ravintotekija.compunit = ravintotekijayksikko.thscode
 JOIN ravintotekijaluokka r1 ON ravintotekija.cmpclass = r1.thscode
 JOIN ravintotekijaluokka r2 ON ravintotekija.cmpclassp = r2.thscode
ORDER BY ylempiluokka ASC, luokka ASC;

-- ravintotekijä nimien/koodin maksimiarvo
SELECT eufdname, MAX(bestloc) max, (MAX(bestloc) / 1000) AS step FROM ravintoarvo GROUP BY eufdname
    



-- testing
SELECT foodid, foodname 
FROM elintarvike_large 
WHERE (eufdname = 'PROT' AND bestloc = 25) 
OR (eufdname = 'FAT' AND bestloc = 10);

-- pivot try2: SELECT * FROM elintarvike_extended LIMIT 0,270;

CREATE VIEW elintarvike_extended AS (
 SELECT foodid, foodname,
  CASE WHEN eufdname = 'ENERC' THEN bestloc END AS ENERC,
  CASE WHEN eufdname = 'CHOAVL' THEN bestloc END AS CHOAVL,
  CASE WHEN eufdname = 'FAT' THEN bestloc END AS FAT,
  CASE WHEN eufdname = 'PROT' THEN bestloc END AS PROT,
  CASE WHEN eufdname = 'ALC' THEN bestloc END AS ALC,
  CASE WHEN eufdname = 'FIBC' THEN bestloc END AS FIBC,
  CASE WHEN eufdname = 'OA' THEN bestloc END AS OA,
  CASE WHEN eufdname = 'SUGOH' THEN bestloc END AS SUGOH,
  CASE WHEN eufdname = 'STARCH' THEN bestloc END AS STARCH,
  CASE WHEN eufdname = 'SUGAR' THEN bestloc END AS SUGAR,
  CASE WHEN eufdname = 'FRUS' THEN bestloc END AS FRUS,
  CASE WHEN eufdname = 'GALS' THEN bestloc END AS GALS,
  CASE WHEN eufdname = 'GLUS' THEN bestloc END AS GLUS,
  CASE WHEN eufdname = 'LACS' THEN bestloc END AS LACS,
  CASE WHEN eufdname = 'MALS' THEN bestloc END AS MALS,
  CASE WHEN eufdname = 'SUCS' THEN bestloc END AS SUCS,
  CASE WHEN eufdname = 'PSACNCS' THEN bestloc END AS PSACNCS,
  CASE WHEN eufdname = 'FIBINS' THEN bestloc END AS FIBINS,
  CASE WHEN eufdname = 'FOL' THEN bestloc END AS FOL,
  CASE WHEN eufdname = 'NIAEQ' THEN bestloc END AS NIAEQ,
  CASE WHEN eufdname = 'NIA' THEN bestloc END AS NIA,
  CASE WHEN eufdname = 'VITPYRID' THEN bestloc END AS VITPYRID,
  CASE WHEN eufdname = 'RIBF' THEN bestloc END AS RIBF,
  CASE WHEN eufdname = 'THIA' THEN bestloc END AS THIA,
  CASE WHEN eufdname = 'VITB12' THEN bestloc END AS VITB12,
  CASE WHEN eufdname = 'VITC' THEN bestloc END AS VITC,
  CASE WHEN eufdname = 'VITA' THEN bestloc END AS VITA,
  CASE WHEN eufdname = 'CAROTENS' THEN bestloc END AS CAROTENS,
  CASE WHEN eufdname = 'VITD' THEN bestloc END AS VITD,
  CASE WHEN eufdname = 'VITE' THEN bestloc END AS VITE,
  CASE WHEN eufdname = 'VITK' THEN bestloc END AS VITK,
  CASE WHEN eufdname = 'CA' THEN bestloc END AS CA,
  CASE WHEN eufdname = 'FE' THEN bestloc END AS FE,
  CASE WHEN eufdname = 'ID' THEN bestloc END AS ID,
  CASE WHEN eufdname = 'K' THEN bestloc END AS K,
  CASE WHEN eufdname = 'MG' THEN bestloc END AS MG,
  CASE WHEN eufdname = 'NA' THEN bestloc END AS NA,
  CASE WHEN eufdname = 'NACL' THEN bestloc END AS NACL,
  CASE WHEN eufdname = 'P' THEN bestloc END AS P,
  CASE WHEN eufdname = 'SE' THEN bestloc END AS SE,
  CASE WHEN eufdname = 'ZN' THEN bestloc END AS ZN,
  CASE WHEN eufdname = 'FAFRE' THEN bestloc END AS FAFRE,
  CASE WHEN eufdname = 'FAPU' THEN bestloc END AS FAPU,
  CASE WHEN eufdname = 'FAMCIS' THEN bestloc END AS FAMCIS,
  CASE WHEN eufdname = 'FASAT' THEN bestloc END AS FASAT,
  CASE WHEN eufdname = 'FATRN' THEN bestloc END AS FATRN,
  CASE WHEN eufdname = 'FAPUN3' THEN bestloc END AS FAPUN3,
  CASE WHEN eufdname = 'FAPUN6' THEN bestloc END AS FAPUN6,
  CASE WHEN eufdname = 'F18D2CN6' THEN bestloc END AS F18D2CN6,
  CASE WHEN eufdname = 'F18D3N3' THEN bestloc END AS F18D3N3,
  CASE WHEN eufdname = 'F20D5N3' THEN bestloc END AS F20D5N3,
  CASE WHEN eufdname = 'F22D6N3' THEN bestloc END AS F22D6N3,
  CASE WHEN eufdname = 'TRP' THEN bestloc END AS TRP,
  CASE WHEN eufdname = 'CHOLE' THEN bestloc END AS CHOLE,
  CASE WHEN eufdname = 'STERT' THEN bestloc END AS STERT
 FROM elintarvike_large
);

CREATE VIEW eep AS (
 SELECT
  FOODID,
  FOODNAME,
  MAX(ENERC) AS ENERC,
  MAX(CHOAVL) AS CHOAVL,
  MAX(FAT) FAT,
  MAX(PROT) PROT,
  MAX(ALC) ALC,
  MAX(FIBC) FIBC,
  MAX(OA) OA,
  MAX(SUGOH) SUGOH,
  MAX(STARCH) STARCH,
  MAX(SUGAR) SUGAR,
  MAX(FRUS) FRUS,
  MAX(GALS) GALS,
  MAX(GLUS) GLUS,
  MAX(LACS) LACS,
  MAX(MALS) MALS,
  MAX(SUCS) SUCS,
  MAX(PSACNCS) PSACNCS,
  MAX(FIBINS) FIBINS,
  MAX(FOL) FOL,
  MAX(NIAEQ) NIAEQ,
  MAX(NIA) NIA,
  MAX(VITPYRID) VITPYRID,
  MAX(RIBF) RIBF,
  MAX(THIA) THIA,
  MAX(VITB12) VITB12,
  MAX(VITC) VITC,
  MAX(VITA) VITA,
  MAX(CAROTENS) CAROTENS,
  MAX(VITD) VITD,
  MAX(VITE) VITE,
  MAX(VITK) VITK,
  MAX(CA) CA,
  MAX(FE) FE,
  MAX(ID) ID,
  MAX(K) K,
  MAX(MG) MG,
  MAX(NA) NA,
  MAX(NACL) NACL,
  MAX(P) P,
  MAX(SE) SE,
  MAX(ZN) ZN,
  MAX(FAFRE) FAFRE,
  MAX(FAPU) FAPU,
  MAX(FAMCIS) FAMCIS,
  MAX(FASAT) FASAT,
  MAX(FATRN) FATRN,
  MAX(FAPUN3) FAPUN3,
  MAX(FAPUN6) FAPUN6,
  MAX(F18D2CN6) F18D2CN6,
  MAX(F18D3N3) F18D3N3,
  MAX(F20D5N3) F20D5N3,
  MAX(F22D6N3) F22D6N3,
  MAX(TRP) TRP,
  MAX(CHOLE) CHOLE,
  MAX(STERT) STERT
 FROM elintarvike_extended GROUP BY FOODID
);




