
CREATE TABLE hospoda (
    id INTEGER PRIMARY KEY,
    nazev VARCHAR(50),
    adresa VARCHAR(150)
);

CREATE TABLE pivovar (
    id INTEGER PRIMARY KEY,
    nazev VARCHAR(50),
    adresa VARCHAR(150)
);

CREATE TABLE uzivatel (
    login VARCHAR(50) PRIMARY KEY,
    jmeno VARCHAR(50),
    prijmeni VARCHAR(50),
    typ_uzivatele VARCHAR(50),
    id_pivovaru INTEGER
);

CREATE TABLE varka (
    id INTEGER,
    datum_vareni DATE,
    objem DECIMAL(12,2),
    forma_distribuce VARCHAR(25),
    cena DECIMAL(12,2)
);

CREATE TABLE sladkovsky_diplom (
    id INTEGER PRIMARY KEY,
    datum_udeleni DATE,
    login VARCHAR(50),
    CONSTRAINT FK_diplom_uzivatel FOREIGN KEY (login)
        REFERENCES uzivatel(login) ON DELETE CASCADE
);

CREATE TABLE hodnoceni_hospody (
    id_hodnoceni INTEGER,
    id_hospody INTEGER, 
    datum DATE,
    hodnota INTEGER,
    komentar VARCHAR(500),
    login_uzivatele VARCHAR(50),
    CONSTRAINT PK_hodnoceni_hospoda PRIMARY KEY (id_hodnoceni, id_hospody),
    CONSTRAINT FK_hodnoceni_login_uzivatele FOREIGN KEY (login_uzivatele)
        REFERENCES uzivatel(login) ON DELETE CASCADE,
    CONSTRAINT FK_hodnoceni_id_hospody FOREIGN KEY (id_hospody)
        REFERENCES hospoda(id) ON DELETE CASCADE
);


CREATE TABLE ramcova_smlouva (
    id INTEGER PRIMARY KEY,
    datum_uzavreni DATE,
    datum_ukonceni DATE,
    sleva INTEGER,
    id_hospody INTEGER,
    id_pivovaru INTEGER,
    CONSTRAINT FK_id_hospody FOREIGN KEY (id_hospody)
        REFERENCES hospoda(id) ON DELETE CASCADE,
    CONSTRAINT FK_id_pivovaru FOREIGN KEY (id_pivovaru)
        REFERENCES pivovar(id) ON DELETE CASCADE
);
