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
    "id_hodnoceni"    NUMBER not null,
    "id_hospody"      NUMBER not null
        constraint FK_HODNOCENI_ID_HOSPODY
            references "hospoda"
                on delete cascade,
    "datum"           DATE,
    "hodnota"         NUMBER,
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
    "obsah_alkoholu" NUMBER(2)     not null,
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
    "id"               NUMBER not null
    "datum_vareni"     DATE,
    "objem[l]"       NUMBER(12, 2),
    "forma_distribuce" VARCHAR2(25),
    "cena"             NUMBER(12, 2),
    "id_pivo"        NUMBER not null
        constraint VARKA_PIVO_ID_PIVO_FK
            references "pivo"
                on delete cascade,
    constraint VARKA_PK
        primary key ("id", "id_pivo")
)
/

create table "seznam_vypitych_piv"
(
    "id"  NUMBER generated as identity
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
)
/

insert into "uzivatel" values (
    'xbenes56',
    'Dalibor',
    'Beneš',
    'sladek',
    null
)
/

insert into "uzivatel" values (
    'xkotta00',
    'Tadeáš',
    'Kot',
    'sladek',
    null
)

insert into "hospoda" ("nazev", "ulice", "mesto", "PSC") values (
    'U Lenina',
    'Moravská',
    'Svitavy',
    '56802'
)
/

insert into "pivo" ("nazev", "barva", "typ", "zpusob_kvaseni", "obsah_alkoholu", "id_pivovaru", "login_uzivatel") values (
    'grešlák',
    '05',
    'pilsner',
    'spodni',
    '5',
    
)
