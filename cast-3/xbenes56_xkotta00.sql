DROP TABLE "varka_uzivatel";
DROP TABLE "objem_hospoda_varka";
DROP TABLE "hodnoceni_piva";
DROP TABLE "kvasnice";
DROP TABLE "chmel";
DROP TABLE "slad";
DROP TABLE "objem_pivo_ramcova_smlouva";
DROP TABLE "surovina_pivo_mnozstvi";
DROP TABLE "seznam_vypitych_piv";
DROP TABLE "varka";
DROP TABLE "pivo";
DROP TABLE "ramcova_smlouva";
DROP TABLE "hodnoceni_hospody";
DROP TABLE "sladkovsky_diplom";
DROP TABLE "uzivatel";
DROP TABLE "pivovar";
DROP TABLE "hospoda";
DROP TABLE "surovina_prodejna_mnozstvi";
DROP TABLE "surovina";
DROP TABLE "prodejna";

create table "prodejna"
(
    "id" NUMBER generated as identity
        constraint PRODEJNA_PK
            primary key,
    "nazev"       VARCHAR2(150) not null,
    "ulice"       VARCHAR2(80)  not null,
    "mesto"       VARCHAR2(50)  not null,
    "PSC"         NUMBER(5)   not null
)
/

create table "surovina"
(
    "id" NUMBER generated as identity
        constraint SUROVINA_PK
            primary key,
    "nazev"       VARCHAR2(510) not null
)
/

create table "surovina_prodejna_mnozstvi"
(
    "id" NUMBER generated as identity
        constraint SUROVINA_PRODEJNA_MNOZSTVI_PK
            primary key,
    "mnozstvi[g]" NUMBER(12, 2),
    "id_prodejny" NUMBER
        constraint SUROVINA_PRODEJNA_MNOZSTVI_PRODEJNA_ID_PRODEJNY_FK
            references "prodejna"
                on delete cascade,
    "id_suroviny" NUMBER not null
        constraint SUROVINA_PRODEJNA_MNOZSTVI_SUROVINA_ID_SUROVINY_FK
            references "surovina"
                on delete cascade
)
/

create table "hospoda"
(
    "id"     NUMBER generated as identity
        primary key,
    "nazev"  VARCHAR2(50),
    "ulice"       VARCHAR2(80)  not null,
    "mesto"       VARCHAR2(50)  not null,
    "PSC"         NUMBER(5)   not null
)
/

create table "pivovar"
(
    "id"     NUMBER generated as identity
        primary key,
    "nazev"  VARCHAR2(50),
    "ulice"       VARCHAR2(80)  not null,
    "mesto"       VARCHAR2(50)  not null,
    "PSC"         NUMBER(5)   not null
)
/

create table "uzivatel"
(
    "login"         VARCHAR2(50) not null
        primary key,
    "jmeno"         VARCHAR2(50),
    "prijmeni"      VARCHAR2(50),
    "typ_uzivatele" VARCHAR2(50) not null
        check ("typ_uzivatele" in ('admin', 'sladek', 'user')),
    "id_pivovar"   NUMBER
        constraint UZIVATEL_PIVOVAR_ID_FK
            references "pivovar"
                on delete set null
)
/

create table "sladkovsky_diplom"
(
    "id"            NUMBER generated as identity
        primary key,
    "datum_udeleni" DATE,
    "login_uzivatel"         VARCHAR2(50)
        constraint FK_DIPLOM_UZIVATEL
            references "uzivatel"
                on delete cascade
)
/

create table "hodnoceni_hospody"
(
    "id_hodnoceni"    NUMBER generated as identity not null,
    "id_hospody"      NUMBER not null
        constraint FK_HODNOCENI_ID_HOSPODY
            references "hospoda"
                on delete cascade,
    "datum"           DATE,
    "hodnota"         NUMBER check ("hodnota" BETWEEN 1 and 5),
    "komentar"        VARCHAR2(500),
    "login_uzivatel" VARCHAR2(50)
        constraint FK_HODNOCENI_LOGIN_UZIVATELE
            references "uzivatel"
                on delete cascade,
    constraint PK_HODNOCENI_HOSPODA
        primary key ("id_hodnoceni", "id_hospody")
)
/

create table "ramcova_smlouva"
(
    "id"             NUMBER generated as identity
        primary key,
    "datum_uzavreni" DATE,
    "datum_ukonceni" DATE,
    "sleva"          NUMBER,
    "id_hospody"     NUMBER
        constraint FK_ID_HOSPODY
            references "hospoda"
                on delete cascade,
    "id_pivovaru"    NUMBER
        constraint FK_ID_PIVOVARU
            references "pivovar"
                on delete cascade
)
/

create table "pivo"
(
    "id"        NUMBER generated as identity
        constraint PIVO_PK
            primary key,
    "nazev"          VARCHAR2(255) not null,
    "barva"          NUMBER(2)
        check ("barva" BETWEEN 1 and 80),
    "typ"            VARCHAR2(16)
        check ("typ" in ('ale', 'stout', 'ipa', 'apa', 'red ipa', 'lager', 'pilsner')),
    "zpusob_kvaseni" VARCHAR2(16)
        check ("zpusob_kvaseni" in ('svrchni', 'spodni')),
    "obsah_alkoholu" NUMBER(4,2)     not null,
    "id_pivovaru"    NUMBER
        constraint PIVO_PIVOVAR_ID_FK
            references "pivovar",
    "login_uzivatel"    VARCHAR2(50)
        constraint PIVO_UZIVATEL_LOGIN_FK
            references "uzivatel"
)
/

create table "varka"
(
    "id"               NUMBER generated as identity not null,
    "datum_vareni"     DATE,
    "objem[l]"       NUMBER(12, 2),
    "forma_distribuce" VARCHAR2(25),
    "cena"             NUMBER(12, 2),
    "id_pivo"        NUMBER not null
        constraint VARKA_PIVO_ID_PIVO_FK
            references "pivo"
                on delete cascade,
    constraint VARKA_PK
        primary key ("id")
)
/

create table "seznam_vypitych_piv"
(
    "id"  NUMBER generated as identity,
    "objem_vypiteho_piva[ml]" NUMBER default 0 not null,
    "id_pivo"                 NUMBER
        constraint SEZNAM_VYPITYCH_PIV_PIVO_ID_PIVO_FK
            references "pivo"
                on delete set null,
    "login_uzivatel"             VARCHAR2(50)
        constraint SEZNAM_VYPITYCH_PIV_UZIVATEL_LOGIN_FK
            references "uzivatel"
                on delete cascade,
    constraint SEZNAM_VYPITYCH_PIV_PK
        primary key ("id", "id_pivo", "login_uzivatel")
)
/

create table "surovina_pivo_mnozstvi"
(
    "id" NUMBER generated as identity
        constraint SUROVINA_PIVO_MNOZSTVI_PK
            primary key,
    "mnozstvi[g]" NUMBER(12, 2) not null,
    "id_suroviny" NUMBER
        constraint SUROVINA_PIVO_MNOZSTVI_SUROVINA_ID_SUROVINY_FK
            references "surovina"
                on delete cascade,
    "id_pivo"     NUMBER
        constraint SUROVINA_PIVO_MNOZSTVI_PIVO_ID_PIVO_FK
            references "pivo"
                on delete cascade
)
/

create table "objem_pivo_ramcova_smlouva"
(
    "id"           NUMBER generated as identity
        constraint OBJEM_PIVO_RAMCOVA_SMLOUVA_PK
            primary key,
    "id_pivo"            NUMBER
        constraint OBJEM_PIVO_RAMCOVA_SMLOUVA_PIVO_ID_PIVO_FK
            references "pivo"
                on delete cascade,
    "id_ramcova_smlouva" NUMBER
        constraint OBJEM_PIVO_RAMCOVA_SMLOUVA_RAMCOVA_SMLOUVA_ID_FK
            references "ramcova_smlouva"
                on delete cascade,
    "objem[l]"           NUMBER
)
/

create table "slad"
(
    "id"    NUMBER generated as identity
        constraint SLAD_PK
            primary key,
    "barva"         VARCHAR2(127),
    "puvod"       VARCHAR2(127),
    "extrakt"     VARCHAR2(127),
    "id_surovina" NUMBER not null
        constraint SLAD_SUROVINA_ID_SUROVINY_FK
            references "surovina"
                on delete cascade
)
/

create table "chmel"
(
    "id"        NUMBER generated as identity
        constraint CHMEL_PK
            primary key,
    "aroma"              VARCHAR2(255),
    "horkost"            NUMBER,
    "podil_alfa_kyselin" NUMBER,
    "misto_puvodu"       VARCHAR2(255),
    "doba_sklizne"       DATE,
    "id_surovina"      NUMBER not null
        constraint CHMEL_SUROVINA_ID_SUROVINY_FK
            references "surovina"
                on delete cascade
)
/

create table "kvasnice"
(
    "id"  NUMBER generated as identity
        constraint KVASNICE_PK
            primary key,
    "skupenstvi"    VARCHAR2(127),
    "misto_kvaseni" VARCHAR2(255),
    "typ"           VARCHAR2(8)
        check ("typ" in ('svrchni', 'spodni')),
    "id_surovina" NUMBER not null
        constraint KVASNICE_SUROVINA_ID_SUROVINY_FK
            references "surovina"
                on delete cascade
)
/

create table "hodnoceni_piva"
(
    "id" NUMBER generated as identity
        constraint HODNOCENI_PIVA_PK
        primary key,
    "datum"          TIMESTAMP(6) default current_date not null,
    "hodnota"        NUMBER(1)                         not null
        check ("hodnota" BETWEEN 1 and 5),
    "komentar"       VARCHAR2(2047),
    "id_uzivatel"  VARCHAR2(50)                      not null
        constraint HODNOCENI_PIVA_UZIVATEL_LOGIN_FK
            references "uzivatel"
                on delete cascade,
    "id_pivo"      NUMBER                            not null
        constraint HODNOCENI_PIVA_PIVO_ID_PIVO_FK
            references "pivo"
                on delete cascade
)
/

create table "objem_hospoda_varka"
(
    "id"  NUMBER generated as identity
        constraint OBJEM_HOSPODA_VARKA_PK
            primary key,
    "objem[l]"  NUMBER not null,
    "id_hospoda" NUMBER not null
        constraint OBJEM_HOSPODA_VARKA_HOSPODA_ID_FK
            references "hospoda"
                on delete cascade,
    "id_varka"  NUMBER not null
        constraint OBJEM_HOSPODA_VARKA_VARKA_ID_FK
            references "varka"
                on delete cascade
)
/

create table "varka_uzivatel"
(
    "uzivatel_login"       VARCHAR2(50) not null
        constraint TABLE_NAME_UZIVATEL_LOGIN_FK
            references "uzivatel"
                on delete cascade,
    "id_varka"          NUMBER       not null
        constraint TABLE_NAME_VARKA_ID_FK
            references "varka"
                on delete cascade,
    "id_varka_uzivatel" NUMBER generated as identity
        constraint TABLE_NAME_PK
            primary key
);
insert into "pivovar" ("nazev", "ulice", "mesto", PSC) values ('Litovel', 'Palackeho 934', 'Litovel', 78401)/
insert into "pivovar" ("nazev", "ulice", "mesto", PSC) values ('Holba', 'Pivovarská 261', 'Hanušovice', 78833)/
insert into "uzivatel" values ('xbenes56', 'Dalibor', 'Beneš', 'sladek', null)/
insert into "uzivatel" values ('xkotta00', 'Tadeáš', 'Kot', 'sladek', (select "id" from "pivovar" where "nazev" = 'Litovel' and ROWNUM <= 1))/
insert into "uzivatel" values ('ozrala69', 'Miloš', 'Zeman', 'user', null)/
insert into "uzivatel" values ('tak_dam_si', 'Honza', 'Hrouda', 'user', null)/
insert into "uzivatel" values ('rubik', 'Adam', 'Nový', 'user', null)/
insert into "sladkovsky_diplom" ("datum_udeleni", "login_uzivatel") VALUES (TO_DATE('2021-04-13', 'YYYY-MM-DD'), 'xbenes56')/
insert into "hospoda" ("nazev", "ulice", "mesto", "PSC") values ('U Lenina', 'Moravská 34', 'Svitavy', '56802')/
insert into "pivo" ("nazev", "barva", "typ", "zpusob_kvaseni", "obsah_alkoholu", "id_pivovaru", "login_uzivatel") values ('grešlák', 05, 'pilsner', 'spodni', 5.5, null, 'xbenes56')/
insert into "pivo" ("nazev", "barva", "typ", "zpusob_kvaseni", "obsah_alkoholu", "id_pivovaru", "login_uzivatel") values ('Gustav', 23, 'lager', 'spodni', 6.9, (select "id" from "pivovar" where "nazev" = 'Litovel' and ROWNUM <= 1), 'xkotta00')/
insert into "pivo" ("nazev", "barva", "typ", "zpusob_kvaseni", "obsah_alkoholu", "id_pivovaru", "login_uzivatel") values ('Moravan', 18, 'lager', 'spodni', 5.3, (select "id" from "pivovar" where "nazev" = 'Litovel' and ROWNUM <= 1), 'xkotta00')/
insert into "prodejna" ("nazev", "ulice", "mesto", PSC)  values ('U opilého hrocha', 'Božetěchova 2', 'Brno', '61200')/
insert into "surovina" ("nazev") values ('Žatecký chmel') /
insert into "surovina" ("nazev") values ('Čerstvé kvasnice') /
insert into "surovina" ("nazev") values ('Zrající slad') /
insert into "slad" ("barva", "puvod", "extrakt", "id_surovina") values ('Tmavě žlutá', 'Polsko', 'Lesní', (select "id" from "surovina" where "nazev" = 'Čerstvé kvasnice' and ROWNUM <= 1)) /
insert into "chmel" ("aroma", "horkost", "podil_alfa_kyselin", "misto_puvodu", "doba_sklizne", "id_surovina") values ('Citronove', 30, 5, 'Madarsko', '07/07/2019', (select "id" from "surovina" where "nazev" = 'Žatecký chmel' and ROWNUM <= 1)) /
insert into "kvasnice" ("skupenstvi", "misto_kvaseni", "typ", "id_surovina") values ('kapalné', 'sklep', 'svrchni', (select "id" from "surovina" where "nazev" = 'Zrající slad' and ROWNUM <= 1))/
insert into "surovina_prodejna_mnozstvi" ("mnozstvi[g]", "id_prodejny", "id_suroviny") values (50000, (select "id" from "prodejna" where "nazev" = 'U opilého hrocha' and ROWNUM <= 1), (select "id" from "surovina" where "nazev" = 'Žatecký chmel' and ROWNUM <= 1)) /
insert into "surovina_prodejna_mnozstvi" ("mnozstvi[g]", "id_prodejny", "id_suroviny") values (20000, (select "id" from "prodejna" where "nazev" = 'U opilého hrocha' and ROWNUM <= 1), (select "id" from "surovina" where "nazev" = 'Čerstvé kvasnice' and ROWNUM <= 1)) /
insert into "surovina_prodejna_mnozstvi" ("mnozstvi[g]", "id_prodejny", "id_suroviny") values (30000, (select "id" from "prodejna" where "nazev" = 'U opilého hrocha' and ROWNUM <= 1), (select "id" from "surovina" where "nazev" = 'Zrající slad' and ROWNUM <= 1)) /
insert into "surovina_pivo_mnozstvi" ("mnozstvi[g]", "id_suroviny", "id_pivo") values (5000, (select "id" from "surovina" where "nazev" = 'Žatecký chmel' and ROWNUM <= 1), (select "id" from "pivo" where "nazev" = 'grešlák' and ROWNUM <= 1)) /
insert into "surovina_pivo_mnozstvi" ("mnozstvi[g]", "id_suroviny", "id_pivo") values (500, (select "id" from "surovina" where "nazev" = 'Čerstvé kvasnice' and ROWNUM <= 1), (select "id" from "pivo" where "nazev" = 'grešlák' and ROWNUM <= 1)) /
insert into "surovina_pivo_mnozstvi" ("mnozstvi[g]", "id_suroviny", "id_pivo") values (100, (select "id" from "surovina" where "nazev" = 'Zrající slad' and ROWNUM <= 1), (select "id" from "pivo" where "nazev" = 'grešlák' and ROWNUM <= 1))/
insert into "surovina_pivo_mnozstvi" ("mnozstvi[g]", "id_suroviny", "id_pivo") values (10000, (select "id" from "surovina" where "nazev" = 'Žatecký chmel' and ROWNUM <= 1), (select "id" from "pivo" where "nazev" = 'Gustav' and ROWNUM <= 1)) /
insert into "surovina_pivo_mnozstvi" ("mnozstvi[g]", "id_suroviny", "id_pivo") values (300, (select "id" from "surovina" where "nazev" = 'Čerstvé kvasnice' and ROWNUM <= 1), (select "id" from "pivo" where "nazev" = 'Gustav' and ROWNUM <= 1)) /
insert into "surovina_pivo_mnozstvi" ("mnozstvi[g]", "id_suroviny", "id_pivo") values (400, (select "id" from "surovina" where "nazev" = 'Zrající slad' and ROWNUM <= 1), (select "id" from "pivo" where "nazev" = 'Gustav' and ROWNUM <= 1)) /
insert into "surovina_pivo_mnozstvi" ("mnozstvi[g]", "id_suroviny", "id_pivo") values (8000, (select "id" from "surovina" where "nazev" = 'Žatecký chmel' and ROWNUM <= 1), (select "id" from "pivo" where "nazev" = 'Moravan' and ROWNUM <= 1)) /
insert into "surovina_pivo_mnozstvi" ("mnozstvi[g]", "id_suroviny", "id_pivo") values (400, (select "id" from "surovina" where "nazev" = 'Čerstvé kvasnice' and ROWNUM <= 1), (select "id" from "pivo" where "nazev" = 'Moravan' and ROWNUM <= 1)) /
insert into "surovina_pivo_mnozstvi" ("mnozstvi[g]", "id_suroviny", "id_pivo") values (200, (select "id" from "surovina" where "nazev" = 'Zrající slad' and ROWNUM <= 1), (select "id" from "pivo" where "nazev" = 'Moravan' and ROWNUM <= 1)) /
insert into "seznam_vypitych_piv" ("id_pivo", "login_uzivatel", "objem_vypiteho_piva[ml]") values ((select "id" from "pivo" where "nazev" = 'Gustav' and ROWNUM <= 1), 'ozrala69', 15000) /
insert into "seznam_vypitych_piv" ("id_pivo", "login_uzivatel", "objem_vypiteho_piva[ml]") values ((select "id" from "pivo" where "nazev" = 'grešlák' and ROWNUM <= 1), 'ozrala69', 1000)/
insert into "hodnoceni_piva" ("datum", "hodnota", "komentar", "id_uzivatel", "id_pivo") values (TO_DATE('2020-12-24', 'YYYY-MM-DD'), 4, 'Super pivo, stačí pár kousků a hned je vám líp.', 'ozrala69', (select "id" from "pivo" where "nazev" = 'Gustav' and ROWNUM <= 1)) /
insert into "hodnoceni_piva" ("datum", "hodnota", "komentar", "id_uzivatel", "id_pivo") values (TO_DATE('2020-12-31', 'YYYY-MM-DD'), 1, 'Hnus, to se nedá pít.', 'ozrala69', (select "id" from "pivo" where "nazev" = 'grešlák' and ROWNUM <= 1))/
insert into "hodnoceni_hospody" ("id_hospody", "datum", "hodnota", "komentar", "login_uzivatel") values ((select "id" from "hospoda" where "nazev" = 'U Lenina' and ROWNUM <= 1), TO_DATE('2020-11-15', 'YYYY-MM-DD'), 5, 'Výborný podnik, velký výběr piv.', 'ozrala69') /
insert into "hodnoceni_hospody" ("id_hospody", "datum", "hodnota", "komentar", "login_uzivatel") values ((select "id" from "hospoda" where "nazev" = 'U Lenina' and ROWNUM <= 1), TO_DATE('2020-10-19', 'YYYY-MM-DD'), 1, 'Odpad.', 'tak_dam_si') /
insert into "hodnoceni_hospody" ("id_hospody", "datum", "hodnota", "komentar", "login_uzivatel") values ((select "id" from "hospoda" where "nazev" = 'U Lenina' and ROWNUM <= 1), TO_DATE('2020-12-15', 'YYYY-MM-DD'), 5, 'Výborný tatarák.', 'rubik') /
insert into "varka" ("datum_vareni", "objem[l]", "forma_distribuce", "cena", "id_pivo") values (TO_DATE('2020-11-12', 'YYYY-MM-DD'), 500, 'bečka', 15000, (select "id" from "pivo" where "nazev" = 'Gustav' and ROWNUM <= 1))/
insert into "varka" ("datum_vareni", "objem[l]", "forma_distribuce", "cena", "id_pivo") values (TO_DATE('2020-9-10', 'YYYY-MM-DD'), 100, 'skleněná láhev', 2500, (select "id" from "pivo" where "nazev" = 'grešlák' and ROWNUM<= 1))/
insert into "ramcova_smlouva" ("datum_uzavreni", "datum_ukonceni", "sleva", "id_hospody", "id_pivovaru") values (TO_DATE('2020-11-03', 'YYYY-MM-DD'), TO_DATE('2021-11-02', 'YYYY-MM-DD'), 2000, (select "id" from "hospoda" where "nazev" = 'U Lenina' and ROWNUM <= 1), (select "id" from "pivovar" where "nazev" = 'Litovel' and ROWNUM <= 1))/
insert into "objem_pivo_ramcova_smlouva" ("id_pivo", "id_ramcova_smlouva", "objem[l]") values ((select "id" from "pivo" where "nazev" = 'Gustav' and ROWNUM <= 1), (select "id" from "ramcova_smlouva" where "id_hospody" = (select "id" from "hospoda" where "nazev" = 'U Lenina' and ROWNUM <= 1) and "id_pivovaru" = (select "id" from "pivovar" where "nazev" = 'Litovel' and ROWNUM <= 1) and ROWNUM <= 1), 250)/
insert into "objem_hospoda_varka" ("objem[l]", "id_hospoda", "id_varka") values (50, (select "id" from "hospoda" where "nazev" = 'U Lenina' and ROWNUM <= 1), (select "id" from "varka" where "id_pivo" = (select "id" from "pivo" where "nazev" = 'grešlák' and ROWNUM <= 1) and "datum_vareni" = TO_DATE('2020-9-10', 'YYYY-MM-DD') and ROWNUM <= 1));

/*Výpis všech pivovarů a případně jejich piv pokud nějáké mají */
select "pivovar"."nazev" as "Jméno pivovaru", "pivo"."nazev" as "Pivo" from "pivovar" left join "pivo" on "pivovar"."id" = "pivo"."id_pivovaru" order by "pivovar"."nazev";
/*Zobrazi vsechny uvarene varky*/
select p."nazev" as "Pivo", v."objem[l]" as "Objem [l]", TO_CHAR(v."datum_vareni", 'DD.MM.YYYY') as "Datum uvaření", v."forma_distribuce" as "Forma distribuce", v."cena" as "Cena" from "varka" v join "pivo" p on p."id" = v."id_pivo" order by p."nazev";
/*Zobrazi vsechny hodnoceni, pro vsechny hospody*/
select hos."nazev" as "Název hospody", hod."hodnota" as "Počet hvězd", concat(u."jmeno", concat(' ', u."prijmeni")) as "Uživatel", hod."komentar" as "Komentář" from "hospoda" hos left join "hodnoceni_hospody" hod on hos."id" = hod."id_hospody" join "uzivatel" u on hod."login_uzivatel" = u."login" order by hos."nazev";
/*Zobrazi kolik objemu piva celkem vypil každý uživatel, pokud nějáké vypil*/
select concat(u."jmeno", concat(' ', u."prijmeni")) as "Uživatel", sum(svp."objem_vypiteho_piva[ml]") as "Objem vypitého piva [ml]" from "uzivatel" u join "seznam_vypitych_piv" svp on u."login" = svp."login_uzivatel" group by u."login", u."jmeno", u."prijmeni" order by concat(u."jmeno", concat(' ', u."prijmeni"));
/*Zobrazí počet druhů piv od každého pivovaru*/
select pr."nazev" as "Pivovar", count(pv."id") as "Počet druhů piv" from "pivovar" pr left join "pivo" pv on pr."id" = pv."id_pivovaru" group by pr."nazev" order by pr."nazev";
/*Zobrazí všechny hospody co mají hodnocení větší nebo rovna 3.5*/
select hos."nazev" from "hospoda" hos where exists(select 1 from "hodnoceni_hospody" hod where hod."id_hospody" = hos."id" group by hod."id_hospody" having avg(hod."hodnota") >= 3.5 );
/*Zobrazí všechna piva s hodnocením větším nebo rovno 3.5*/
select pv."nazev" as "Pivo" from "pivo" pv where "id" IN (select hod."id_pivo" from "hodnoceni_piva" hod group by hod."id_pivo" having avg(hod."hodnota") >=3.5);