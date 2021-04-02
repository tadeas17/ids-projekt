create table "Prodejna"
(
    "ID_prodejny" NUMBER generated as identity
        constraint PRODEJNA_PK
            primary key,
    "Nazev"       VARCHAR2(510) not null,
    "Adresa"      VARCHAR2(510) not null
)
/

create table "Surovina"
(
    "ID_suroviny" NUMBER generated as identity
        constraint SUROVINA_PK
            primary key,
    "Nazev"       VARCHAR2(510) not null
)
/

create table "Surovina_prodejna_mnozstvi"
(
    "ID_mnozstvi" NUMBER generated as identity
        constraint SUROVINA_PRODEJNA_MNOZSTVI_PK
            primary key,
    "mnozstvi[g]" NUMBER(12, 2),
    "ID_prodejny" NUMBER
        constraint SUROVINA_PRODEJNA_MNOZSTVI_PRODEJNA_ID_PRODEJNY_FK
            references "Prodejna"
                on delete cascade,
    "ID_suroviny" NUMBER not null
        constraint SUROVINA_PRODEJNA_MNOZSTVI_SUROVINA_ID_SUROVINY_FK
            references "Surovina"
                on delete cascade
)
/

create table HOSPODA
(
    ID     NUMBER not null
        primary key,
    NAZEV  VARCHAR2(50),
    ADRESA VARCHAR2(150)
)
/

create table PIVOVAR
(
    ID     NUMBER not null
        primary key,
    NAZEV  VARCHAR2(50),
    ADRESA VARCHAR2(150)
)
/

create table UZIVATEL
(
    LOGIN         VARCHAR2(50) not null
        primary key,
    JMENO         VARCHAR2(50),
    PRIJMENI      VARCHAR2(50),
    TYP_UZIVATELE VARCHAR2(50) not null
        check (TYP_UZIVATELE in ('admin', 'sladek', 'user')),
    ID_PIVOVARU   NUMBER
        constraint UZIVATEL_PIVOVAR_ID_FK
            references PIVOVAR
                on delete set null
)
/

create table SLADKOVSKY_DIPLOM
(
    ID            NUMBER not null
        primary key,
    DATUM_UDELENI DATE,
    LOGIN         VARCHAR2(50)
        constraint FK_DIPLOM_UZIVATEL
            references UZIVATEL
                on delete cascade
)
/

create table HODNOCENI_HOSPODY
(
    ID_HODNOCENI    NUMBER not null,
    ID_HOSPODY      NUMBER not null
        constraint FK_HODNOCENI_ID_HOSPODY
            references HOSPODA
                on delete cascade,
    DATUM           DATE,
    HODNOTA         NUMBER,
    KOMENTAR        VARCHAR2(500),
    LOGIN_UZIVATELE VARCHAR2(50)
        constraint FK_HODNOCENI_LOGIN_UZIVATELE
            references UZIVATEL
                on delete cascade,
    constraint PK_HODNOCENI_HOSPODA
        primary key (ID_HODNOCENI, ID_HOSPODY)
)
/

create table RAMCOVA_SMLOUVA
(
    ID             NUMBER not null
        primary key,
    DATUM_UZAVRENI DATE,
    DATUM_UKONCENI DATE,
    SLEVA          NUMBER,
    ID_HOSPODY     NUMBER
        constraint FK_ID_HOSPODY
            references HOSPODA
                on delete cascade,
    ID_PIVOVARU    NUMBER
        constraint FK_ID_PIVOVARU
            references PIVOVAR
                on delete cascade
)
/

create table "Pivo"
(
    "ID_pivo"        NUMBER generated as identity
        constraint PIVO_PK
            primary key,
    "Nazev"          VARCHAR2(255) not null,
    "Barva"          NUMBER(2)
        check ("Barva" BETWEEN 1 and 80),
    "Typ"            VARCHAR2(16)
        check ("Typ" in ('ale', 'stout', 'ipa', 'apa', 'red ipa')),
    "Zpusob_kvaseni" VARCHAR2(16)
        check ("Zpusob_kvaseni" in ('svrchně', 'spodně')),
    "Obsah_alkoholu" NUMBER(2)     not null,
    "ID_pivovaru"    NUMBER
        constraint PIVO_PIVOVAR_ID_FK
            references PIVOVAR,
    "ID_uzivatel"    VARCHAR2(50)
        constraint PIVO_UZIVATEL_LOGIN_FK
            references UZIVATEL
)
/

create table VARKA
(
    ID               NUMBER       not null
        constraint VARKA_PK
            primary key,
    DATUM_VARENI     DATE,
    "OBJEM[l]"       NUMBER(12, 2),
    FORMA_DISTRIBUCE VARCHAR2(25),
    CENA             NUMBER(12, 2),
    "ID_pivo"        NUMBER       not null
        constraint VARKA_PIVO_ID_PIVO_FK
            references "Pivo"
                on delete cascade,
    "ID_uzivatel"    VARCHAR2(50) not null
        constraint VARKA_UZIVATEL_LOGIN_FK
            references UZIVATEL
                on delete set null
)
/

create table "Seznam_vypitych_piv"
(
    "ID_seznam_vypitych_piv"  NUMBER generated as identity
        constraint SEZNAM_VYPITYCH_PIV_PK
        primary key,
    "Objem_vypiteho_piva[ml]" NUMBER default 0 not null,
    "ID_pivo"                 NUMBER
        constraint SEZNAM_VYPITYCH_PIV_PIVO_ID_PIVO_FK
            references "Pivo"
                on delete set null,
    "ID_uzivatel"             VARCHAR2(50)
        constraint SEZNAM_VYPITYCH_PIV_UZIVATEL_LOGIN_FK
            references UZIVATEL
                on delete cascade
)
/

create table "Surovina_pivo_mnozstvi"
(
    "ID_mnozstvi" NUMBER generated as identity
        constraint SUROVINA_PIVO_MNOZSTVI_PK
            primary key,
    "mnozstvi[g]" NUMBER(12, 2) not null,
    "ID_suroviny" NUMBER
        constraint SUROVINA_PIVO_MNOZSTVI_SUROVINA_ID_SUROVINY_FK
            references "Surovina"
                on delete cascade,
    "ID_pivo"     NUMBER
        constraint SUROVINA_PIVO_MNOZSTVI_PIVO_ID_PIVO_FK
            references "Pivo"
                on delete cascade
)
/

create table "Objem_pivo_ramcova_smlouva"
(
    "ID_objem"           NUMBER generated as identity
        constraint OBJEM_PIVO_RAMCOVA_SMLOUVA_PK
            primary key,
    "ID_pivo"            NUMBER
        constraint OBJEM_PIVO_RAMCOVA_SMLOUVA_PIVO_ID_PIVO_FK
            references "Pivo"
                on delete cascade,
    "ID_ramcova_smlouva" NUMBER
        constraint OBJEM_PIVO_RAMCOVA_SMLOUVA_RAMCOVA_SMLOUVA_ID_FK
            references RAMCOVA_SMLOUVA
                on delete cascade,
    "objem[l]"           NUMBER
)
/

create table "Slad"
(
    "ID_sladu"    NUMBER generated as identity
        constraint SLAD_PK
            primary key,
    BARVA         VARCHAR2(127),
    "Puvod"       VARCHAR2(127),
    "Extrakt"     VARCHAR2(127),
    "ID_surovina" NUMBER not null
        constraint SLAD_SUROVINA_ID_SUROVINY_FK
            references "Surovina"
                on delete cascade
)
/

create table "Chmel"
(
    "ID_chmelu"        NUMBER generated as identity
        constraint CHMEL_PK
            primary key,
    AROMA              VARCHAR2(255),
    HORKOST            NUMBER,
    PODIL_ALFA_KYSELIN NUMBER,
    MISTO_PUVODU       VARCHAR2(255),
    DOBA_SKLIZNE       DATE,
    "ID_surovina"      NUMBER not null
        constraint CHMEL_SUROVINA_ID_SUROVINY_FK
            references "Surovina"
                on delete cascade
)
/

create table "Kvasnice"
(
    "ID_kvasnic"  NUMBER generated as identity
        constraint KVASNICE_PK
            primary key,
    SKUPENSTVI    VARCHAR2(127),
    MISTO_KVASENI VARCHAR2(255),
    TYP           VARCHAR2(8)
        check (typ in ('svrchni', 'spodni')),
    "ID_surovina" NUMBER not null
        constraint KVASNICE_SUROVINA_ID_SUROVINY_FK
            references "Surovina"
                on delete cascade
)
/

create table "Hodnoceni_piva"
(
    "ID_hodnoceni" NUMBER generated as identity
        constraint HODNOCENI_PIVA_PK
        primary key,
    DATUM          TIMESTAMP(6) default current_date not null,
    HODNOTA        NUMBER(1)                         not null
        check (hodnota BETWEEN 1 and 5),
    KOMENTAR       VARCHAR2(2047),
    "ID_uzivatel"  VARCHAR2(50)                      not null
        constraint HODNOCENI_PIVA_UZIVATEL_LOGIN_FK
            references UZIVATEL
                on delete cascade,
    "ID_pivo"      NUMBER                            not null
        constraint HODNOCENI_PIVA_PIVO_ID_PIVO_FK
            references "Pivo"
                on delete cascade
)
/

create table "Objem_hospoda_varka"
(
    "ID_objem"  NUMBER generated as identity
        constraint OBJEM_HOSPODA_VARKA_PK
            primary key,
    "objem[l]"  NUMBER not null,
    "ID_hopoda" NUMBER not null
        constraint OBJEM_HOSPODA_VARKA_HOSPODA_ID_FK
            references HOSPODA
                on delete cascade,
    "ID_varka"  NUMBER not null
        constraint OBJEM_HOSPODA_VARKA_VARKA_ID_FK
            references VARKA
                on delete cascade
)
/
