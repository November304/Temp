------------------------------------------------------------------
-- CREATEBASE.SQL
------------------------------------------------------------------

DROP TABLE Survenir;
DROP TABLE Marquer;
DROP TABLE Composer;
DROP TABLE Match;
DROP TABLE Arbitre;
DROP TABLE Joueur;
DROP TABLE Equipe;

CREATE TABLE Equipe
(
   ne   CHAR(3),
   nome VARCHAR(50),
   pres VARCHAR(30), 
   noms VARCHAR(30), 
   dtns DATE, 
   nats VARCHAR(30),
   CONSTRAINT pk_equipe      PRIMARY KEY (ne),
   CONSTRAINT uk_equipe_nome UNIQUE (nome)
);

CREATE TABLE Joueur
(
   nj   DECIMAL(5), 
   prej VARCHAR(30), 
   nomj VARCHAR(30), 
   pst  VARCHAR(30), 
   cap  CHAR(9),
   ne   CHAR(3),
   CONSTRAINT pk_joueur        PRIMARY KEY (nj),
   CONSTRAINT fk_joueur_equipe FOREIGN KEY (ne) REFERENCES Equipe(ne),
   CONSTRAINT nn_joueur_ne     CHECK (ne IS NOT NULL),
   CONSTRAINT ck_joueur_pst    CHECK (pst IN ('Pilier', 'Talonneur', 'Deuxième ligne', 'Troisième ligne aile', 'Troisième ligne centre', 'Demi de mêlée', 'Demi d''ouverture', 'Centre', 'Ailier', 'Arrière')),
   CONSTRAINT ck_joueur_cap    CHECK (cap = 'Capitaine')
);

CREATE TABLE Arbitre
(
   prea VARCHAR(30), 
   noma VARCHAR(30), 
   dtna DATE,
   nata VARCHAR(30),
   CONSTRAINT pk_arbitre PRIMARY KEY (prea, noma)
);

CREATE TABLE Match
(
   nm    DECIMAL(5),
   jrn   DECIMAL(1),
   dtm   DATE,
   stade VARCHAR(30),
   ville VARCHAR(30),
   prea  VARCHAR(30), 
   noma  VARCHAR(30), 
   ne1   CHAR(3),
   ne2   CHAR(3),
   scr1  DECIMAL(3),
   scr2  DECIMAL(3),
   nj    DECIMAL(5),
   CONSTRAINT pk_match         PRIMARY KEY (nm),
   CONSTRAINT uk_match_ne1_ne2 UNIQUE (ne1, ne2),
   CONSTRAINT fk_match_equipe1 FOREIGN KEY (ne1) REFERENCES Equipe(ne),
   CONSTRAINT fk_match_equipe2 FOREIGN KEY (ne2) REFERENCES Equipe(ne),
   CONSTRAINT fk_match_arbitre FOREIGN KEY (prea, noma) REFERENCES Arbitre(prea, noma),
   CONSTRAINT fk_match_joueur  FOREIGN KEY (nj) REFERENCES Joueur(nj),
   CONSTRAINT nn_match_ne1     CHECK (ne1 IS NOT NULL),
   CONSTRAINT nn_match_ne2     CHECK (ne2 IS NOT NULL),
   CONSTRAINT nn_match_prea    CHECK (prea IS NOT NULL),
   CONSTRAINT nn_match_noma    CHECK (noma IS NOT NULL),
   CONSTRAINT ck_match_scr1    CHECK (scr1 >= 0),
   CONSTRAINT ck_match_scr2    CHECK (scr2 >= 0),
   CONSTRAINT ck_match_jrn     CHECK (jrn BETWEEN 1 AND 5),
   CONSTRAINT ck_match_ne1_ne2 CHECK (ne1 <> ne2)
);

CREATE TABLE Composer 
(
   nm      DECIMAL(5),
   nj      DECIMAL(5),
   maillot DECIMAL(2),
   CONSTRAINT pk_composer         PRIMARY KEY (nm, nj),
   CONSTRAINT fk_composer_match   FOREIGN KEY (nm) REFERENCES Match(nm),
   CONSTRAINT fk_composer_joueur  FOREIGN KEY (nj) REFERENCES Joueur(nj),
   CONSTRAINT ck_composer_maillot CHECK (maillot BETWEEN 1 AND 23)
);

CREATE TABLE Marquer
(
   nm     DECIMAL(5),
   tps    VARCHAR(5),
   nj     DECIMAL(5),
   action VARCHAR(30),
   point  DECIMAL(1),
   CONSTRAINT pk_marquer              PRIMARY KEY (nm, tps),
   CONSTRAINT fk_marquer_match        FOREIGN KEY (nm) REFERENCES Match(nm),
   CONSTRAINT fk_marquer_joueur       FOREIGN KEY (nj) REFERENCES Joueur(nj),
   CONSTRAINT ck_marquer_point_action CHECK (point = 7 AND  action = 'Essais de Pénalité'
                                          OR point = 5 AND  action = 'Essais'
                                          OR point = 2 AND  action = 'Transformation'
                                          OR point = 3 AND (action = 'Pénalité' OR action = 'Coup de pied tombé'))
);

CREATE TABLE Survenir
(
   nm  DECIMAL(5),
   tps VARCHAR(5),
   nj  DECIMAL(5),
   evt VARCHAR(30),
   CONSTRAINT pk_survenir        PRIMARY KEY (nm, tps, nj),
   CONSTRAINT fk_survenir_match  FOREIGN KEY (nm) REFERENCES Match(nm),
   CONSTRAINT fk_survenir_joueur FOREIGN KEY (nj) REFERENCES Joueur(nj),
   CONSTRAINT ck_survenir_evt    CHECK (evt IN ('Carton Jaune','Carton Rouge','Entrée','Sortie'))
);


------------------------------------------------------------------
-- INSERTBASE.SQL
------------------------------------------------------------------

-- Equipe

INSERT INTO Equipe (ne, nome, pres, noms, dtns, nats) VALUES ('ENG', 'Angleterre', 'Eddie', 'Jones', '30/01/1960', 'Australie');
INSERT INTO Equipe (ne, nome, pres, noms, dtns, nats) VALUES ('SCO', 'Ecosse', 'Gregor', 'Townsend', '26/04/1973', 'Ecosse');
INSERT INTO Equipe (ne, nome, pres, noms, dtns, nats) VALUES ('FRA', 'France', 'Fabien', 'Galthié', '20/03/1969', 'France');
INSERT INTO Equipe (ne, nome, pres, noms, dtns, nats) VALUES ('WAL', 'Galles', 'Wayne', 'Pivac', '10/09/1962', 'Nouvelle Zélande');
INSERT INTO Equipe (ne, nome, pres, noms, dtns, nats) VALUES ('IRL', 'Irlande', 'Andy', 'Farrell', '30/05/1975', 'Angleterre');
INSERT INTO Equipe (ne, nome, pres, noms, dtns, nats) VALUES ('ITA', 'Italie', 'Kieran', 'Crowley', '31/08/1961', 'Nouvelle Zélande');
COMMIT;

-- Joueur

DROP SEQUENCE seq_joueur;

CREATE SEQUENCE seq_joueur
START WITH 1
INCREMENT BY 1;

INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Ellis', 'Genge', 'ENG'); 
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Joe', 'Heyes', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Joe', 'Marler', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Bevan', 'Rodd', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Kyle', 'Sinckler', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Will', 'Stuart', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Jamie', 'Blamire', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Luke', 'Cowan-Dickie', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Jamie', 'George', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Nic', 'Dolly', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Ollie', 'Chessum', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Charlie', 'Ewels', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Jonny', 'Hill', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Nick', 'Isiekwe', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Maro', 'Itoje', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Joe', 'Launchbury', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, cap, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Tom', 'Curry', 'Capitaine', 'ENG'); 
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Courtney', 'Lawes', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Lewis', 'Ludlam', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Sam', 'Underhill', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Alfie', 'Barbeary', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Alex', 'Dombrandt', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Sam', 'Simmonds', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Raffi', 'Quirke', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Harry', 'Randall', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Ben', 'Youngs', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Orlando', 'Bailey', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'George', 'Ford', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Marcus', 'Smith', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Mark', 'Atkinson', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Elliot', 'Daly', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Joe', 'Marchant', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Luke', 'Northmore', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Henry', 'Slade', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Ollie', 'Hassell-Collins', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Jack', 'Nowell', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Max', 'Malins', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Tommy', 'Freeman', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'George', 'Furbank', 'ENG');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Freddie', 'Steward', 'ENG');

INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Allan', 'Dell', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Zander', 'Fagerson', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Willem Petrus', 'Nel', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Pierre', 'Schoeman', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Javan', 'Sebastian', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Rory', 'Sutherland', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Oli', 'Kebble', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Ewan', 'Ashman', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Dave', 'Cherry', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Stuart', 'McInally', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'George', 'Turner', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Scott', 'Cummings', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Grant', 'Gilchrist', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Jonny', 'Gray', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Jamie', 'Hodgson', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Sam', 'Skinner', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Magnus', 'Bradbury', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Andy', 'Christie', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Rory', 'Darge', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Jamie', 'Ritchie', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Hamish', 'Watson', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Josh', 'Bayliss', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Matt', 'Fagerson', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Nick', 'Haining', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Ali', 'Price', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Ben', 'Vellacott', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Ben', 'White', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Finn', 'Russell', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Mark', 'Bennett', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Chris', 'Harris', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Rory', 'Hutchinson', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Sam', 'Johnson', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Cameron', 'Redpath', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Sione', 'Tuipulotu', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Darcy', 'Graham', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Sean', 'Maitland', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Rufus', 'McLean', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Kyle', 'Steyn', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Duhan', 'van der Merwe', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, cap, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Stuart', 'Hogg', 'Capitaine',  'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Blair', 'Kinghorn', 'SCO');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Adam', 'Hastings', 'SCO');

INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Dorian', 'Aldegheri', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Uini', 'Atonio', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Cyril', 'Baille', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Demba', 'Bamba', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Jean-Baptiste', 'Gros', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Mohamed', 'Haouas', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Dany', 'Priso', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Gaëtan', 'Barlot', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Julien', 'Marchand', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Peato', 'Mauvaka', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Thibaud', 'Flament', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Thomas', 'Lavault', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Bernard', 'Le Roux', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Romain', 'Taofifénua', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Paul', 'Willemse', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Cameron', 'Woki', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Paul', 'Boudehent', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Dylan', 'Cretin', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'François', 'Cros', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Ibrahim', 'Diallo', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Anthony', 'Jelonch', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Sekou', 'Macalou', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Grégory', 'Alldritt', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Yoan Tanga', 'Mangene', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Baptiste', 'Couilloud', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, cap, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Antoine', 'Dupont', 'Capitaine', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Maxime', 'Lucu', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Léo', 'Berdeu', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Antoine', 'Hastoy', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Matthieu', 'Jalibert', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Romain', 'Ntamack', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Jonathan', 'Danty', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Jules', 'Favre', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Gaël', 'Fickou', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Yoram', 'Moefana', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Virimi', 'Vakatawa', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Tani', 'Vili', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Matthis', 'Lebel', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Damian', 'Penaud', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Yoram', 'Taofifénua', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Gabin', 'Villière', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Brice', 'Dulin', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Melvyn', 'Jaminet', 'FRA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Thomas', 'Ramos', 'FRA');

INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Leon', 'Brown', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Rhys', 'Carré', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Tomas', 'Francis', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Wyn', 'Jones', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Dillon', 'Lewis', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Gareth', 'Thomas', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Ryan', 'Elias', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Dewi', 'Lake', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Bradley', 'Roberts', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Adam', 'Beard', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Ben', 'Carter', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Seb', 'Davies', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Will', 'Rowlands', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Christ', 'Tshiunza', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Alun', 'Wyn Jones', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Taine', 'Basham', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Ellis', 'Jenkins', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Jac', 'Morgan', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'James', 'Ratti', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Josh', 'Navidi', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Ross', 'Moriarty', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Aaron', 'Wainwright', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Taulupe', 'Faletau', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Gareth', 'Davies', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Kieran', 'Hardy', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Tomos', 'Williams', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Gareth', 'Anscombe', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, cap, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Dan', 'Biggar', 'Capitaine', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Rhys', 'Priestland', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Callum', 'Sheedy', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Jonathan', 'Davies', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Willis', 'Halaholo', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Nick', 'Tompkins', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Owen', 'Watkin', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Josh', 'Adams', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Alex', 'Cuthbert', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Louis', 'Rees-Zammit', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Johnny', 'McNicholl', 'WAL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Liam', 'Williams', 'WAL');

INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Finlay', 'Bealham', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Tadhg', 'Furlong', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Cian', 'Healy', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'David', 'Kilcoyne', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Tom', 'O''Toole', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Andrew', 'Porter', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Rob', 'Herring', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Rónan', 'Kelleher', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Dan', 'Sheehan', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Tadhg', 'Beirne', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Iain', 'Henderson', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'James', 'Ryan', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Kieran', 'Treadwell', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Gavin', 'Coombes', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Peter', 'O''Mahony', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Nick', 'Timoney', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Josh', 'van der Flier', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Ryan', 'Baird', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Jack', 'Conan', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Caelan', 'Doris', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Craig', 'Casey', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Jamison', 'Gibson-Park', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Conor', 'Murray', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Jack', 'Carty', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Joey', 'Carbery', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, cap, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Jonathan', 'Sexton', 'Capitaine', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Bundee', 'Aki', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Robbie', 'Henshaw', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'James', 'Hume', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Garry', 'Ringrose', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Robert', 'Baloucoune', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Andrew', 'Conway', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Keith', 'Earls', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Mack', 'Hansen', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'James', 'Lowe', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Hugo', 'Keenan', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Jordan', 'Larmour', 'IRL');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Michael', 'Lowry', 'IRL');

INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Pietro', 'Ceccarelli', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Danilo', 'Fischetti', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Ivan', 'Nemer', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Tiziano', 'Pasquali', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Cherif', 'Traorè', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Giosuè', 'Zilocchi', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Pilier', 'Filippo', 'Alongi', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Hame', 'Faiva', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Gianmarco', 'Lucchesi', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Giacomo', 'Nicotera', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Talonneur', 'Luca', 'Bigi', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Niccolò', 'Cannone', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Marco', 'Fuser', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'Federico', 'Ruzza', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Deuxième ligne', 'David', 'Sisi', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, cap, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Michele', 'Lamaro', 'Capitaine', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Sebastian', 'Negri', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Giovanni', 'Pettinelli', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Manuel', 'Zuliani', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne aile', 'Andrea', 'Zambonin', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Toa', 'Halafihi', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Troisième ligne centre', 'Braam', 'Steyn', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Callum', 'Braley', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Alessandro', 'Fusco', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi de mêlée', 'Stephen', 'Varney', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Giacomo', 'Da Re', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Paolo', 'Garbisi', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Demi d''ouverture', 'Leonardo', 'Marin', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Juan Ignacio', 'Brex', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Luca', 'Morisi', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Centre', 'Marco', 'Zanon', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Pierre', 'Bruno', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Monty', 'Ioane', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Tommaso', 'Menoncello', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Ailier', 'Federico', 'Mori', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Edoardo', 'Padovani', 'ITA');
INSERT INTO Joueur (nj, pst, prej, nomj, ne) VALUES (seq_joueur.NEXTVAL, 'Arrière', 'Ange', 'Capuozzo', 'ITA');
COMMIT;

-- Arbitre

INSERT INTO Arbitre (prea, noma, dtna, nata) VALUES ('Jaco', 'Peyper', '13/05/1980', 'Afrique du Sud');
INSERT INTO Arbitre (prea, noma, dtna, nata) VALUES ('Ben', 'O''Keeffe', '03/01/1989', 'Nouvelle Zélande');
INSERT INTO Arbitre (prea, noma, dtna, nata) VALUES ('Mike', 'Adamson', '17/05/1984', 'Ecosse');
INSERT INTO Arbitre (prea, noma, dtna, nata) VALUES ('Nic', 'Berry', '13/03/1984', 'Australie');
INSERT INTO Arbitre (prea, noma, dtna, nata) VALUES ('Angus', 'Gardner', '24/08/1984', 'Australie');
INSERT INTO Arbitre (prea, noma, dtna, nata) VALUES ('Damon', 'Murphy', '15/12/1984', 'Australie');
INSERT INTO Arbitre (prea, noma, dtna, nata) VALUES ('Karl', 'Dickson', '02/08/1982', 'Angleterre');
INSERT INTO Arbitre (prea, noma, dtna, nata) VALUES ('Nika', 'Amashukeli', '18/05/1994', 'Géorgie');
INSERT INTO Arbitre (prea, noma, dtna, nata) VALUES ('Matthew', 'Carley', '21/12/1994', 'Angleterre');
INSERT INTO Arbitre (prea, noma, dtna, nata) VALUES ('Luke', 'Pearce', '13/11/1987', 'Pays de Galles');
INSERT INTO Arbitre (prea, noma, dtna, nata) VALUES ('Mathieu', 'Raynal', '09/08/1981', 'France');
INSERT INTO Arbitre (prea, noma, dtna, nata) VALUES ('Andrew', 'Brace', '15/06/1988', 'Pays de Galles');
INSERT INTO Arbitre (prea, noma, dtna, nata) VALUES ('Wayne', 'Barnes', '20/04/1979', 'Angleterre');
COMMIT;

-- Match

DROP SEQUENCE seq_match;

CREATE SEQUENCE seq_match
START WITH 1
INCREMENT BY 1;

INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 1, '05/02/2022', 'Aviva Stadium', 'Dublin', 'IRL', 'WAL', 29, 7, 'Jaco', 'Peyper');
INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 1, '05/02/2022', 'Murrayfield Stadium', 'Edimbourg', 'SCO', 'ENG', 20, 17, 'Ben', 'O''Keeffe');
INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 1, '06/02/2022', 'Stade de France', 'Saint-Denis', 'FRA', 'ITA', 37, 10, 'Mike', 'Adamson');

INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 2, '12/02/2022', 'Millennium Stadium', 'Cardiff', 'WAL', 'SCO', 20, 17, 'Nic', 'Berry');
INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 2, '12/02/2022', 'Stade de France', 'Saint-Denis', 'FRA', 'IRL', 30, 24, 'Angus', 'Gardner');
INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 2, '13/02/2022', 'Stade olympique', 'Rome', 'ITA', 'ENG', 0, 33,'Damon', 'Murphy');

INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 3, '26/02/2022', 'Murrayfield Stadium', 'Edimbourg', 'SCO', 'FRA', 17, 36, 'Karl', 'Dickson');
INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 3, '26/02/2022', 'Stade de Twickenham', 'Londres', 'ENG', 'WAL', 23, 19, 'Mike', 'Adamson');
INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 3, '27/02/2022', 'Aviva Stadium', 'Dublin', 'IRL', 'ITA', 57, 6, 'Nika', 'Amashukeli');

INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 4, '11/03/2022', 'Millennium Stadium', 'Cardiff', 'WAL', 'FRA', 9, 13,'Matthew', 'Carley');
INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 4, '12/03/2022', 'Stade olympique', 'Rome', 'ITA', 'SCO', 22, 33, 'Luke', 'Pearce');
INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 4, '12/03/2022', 'Stade de Twickenham', 'Londres', 'ENG', 'IRL', 15, 32, 'Mathieu', 'Raynal');

INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 5, '19/03/2022', 'Millennium Stadium', 'Cardiff', 'WAL', 'ITA', 21, 22, 'Andrew', 'Brace');
INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 5, '19/03/2022', 'Aviva Stadium', 'Dublin', 'IRL', 'SCO', 26, 5, 'Wayne', 'Barnes');
INSERT INTO Match (nm, jrn, dtm, stade, ville, ne1, ne2, scr1, scr2, prea, noma) 
VALUES (seq_match.NEXTVAL, 5, '19/03/2022', 'Stade de France', 'Saint-Denis', 'FRA', 'ENG', 25, 13, 'Jaco', 'Peyper');

UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Mack' AND nomj = 'Hansen')
WHERE ne1 = 'IRL' AND ne2 = 'WAL';

UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Matt' AND nomj = 'Fagerson')
WHERE ne1 = 'SCO' AND ne2 = 'ENG';

UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Gabin' AND nomj = 'Villière')
WHERE ne1 = 'FRA' AND ne2 = 'ITA';

UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Ryan' AND nomj = 'Elias')
WHERE ne1 = 'WAL' AND ne2 = 'SCO';

UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Grégory' AND nomj = 'Alldritt')
WHERE ne1 = 'FRA' AND ne2 = 'IRL';

UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Marcus' AND nomj = 'Smith')
WHERE ne1 = 'ITA' AND ne2 = 'ENG';
   
UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Antoine' AND nomj = 'Dupont')
WHERE ne1 = 'SCO' AND ne2 = 'FRA';

UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Marcus' AND nomj = 'Smith')
WHERE ne1 = 'ENG' AND ne2 = 'WAL';

UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Josh' AND nomj = 'van der Flier')
WHERE ne1 = 'IRL' AND ne2 = 'ITA';

UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Julien' AND nomj = 'Marchand')
WHERE ne1 = 'WAL' AND ne2 = 'FRA';

UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Ali' AND nomj = 'Price')
WHERE ne1 = 'ITA' AND ne2 = 'SCO';

UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Jamison' AND nomj = 'Gibson-Park')
WHERE ne1 = 'ENG' AND ne2 = 'IRL';

UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Josh' AND nomj = 'Adams')
WHERE ne1 = 'WAL' AND ne2 = 'ITA';

UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Dan' AND nomj = 'Sheehan')
WHERE ne1 = 'IRL' AND ne2 = 'SCO';

UPDATE Match
SET nj = (SELECT nj FROM Joueur WHERE prej = 'Antoine' AND nomj = 'Dupont')
WHERE ne1 = 'FRA' AND ne2 = 'ENG';
COMMIT;

-- Marquer

-- Première journée
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('3', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Aki'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('44', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Conway'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('51', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Conway'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('60', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Ringrose'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('5', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('45', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('53', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('21', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('75', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Basham'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('76', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Sheedy'));

INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('18', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'White'));
INSERT INTO Marquer (tps, action, point, nm) 
VALUES ('66', 'Essais de Pénalité', 7, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('20', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('40+1', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('72', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('53', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('17', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('34', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('48', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('63', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));

INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('26', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Jelonch'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('40+1', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Villière'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('49', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Villière'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('82', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Villière'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('68', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Penaud'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('40+2', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('70', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('83', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Ntamack'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('5', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('35', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('17', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Menoncello'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('18', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Garbisi'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('30', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Garbisi'));
COMMIT;

-- Deuxième journée
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('32', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Francis'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('5', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Biggar'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('8', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Biggar'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('25', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Biggar'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('58', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Biggar'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('70', 'Coup de pied tombé', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Biggar'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('12', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Graham'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('16', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('20', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('29', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('50', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));

INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('2', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Dupont'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('54', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Baille'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('3', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('7', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('17', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('36', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('40+1', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('44', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('79', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('8', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Hansen'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('45', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'van der Flier'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('50', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Gibson-Park'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('9', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Carbery'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('46', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Carbery'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('49', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Carbery'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('73', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Carbery'));

INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('9', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('19', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'George'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('39', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'George'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('44', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Daly'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('72', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Sinckler'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('11', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('20', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('41', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('73', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
COMMIT;

-- Troisième journée
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('29', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Darge'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('80', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'van der Merwe'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('30', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('80+1', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Hogg'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('12', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('8', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Willemse'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('13', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Moefana'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('40+2', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Fickou'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('42', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Danty'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('59', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Penaud'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('73', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Penaud'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('9', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('40+3', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('43', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));

INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('43', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Dombrandt'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('3', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('6', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('31', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('40+2', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('68', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('72', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('54', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Adams'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('61', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Tompkins'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('80', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Hardy'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('62', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Biggar'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('80+1', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Biggar'));

INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('4', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Carbery'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('21', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Gibson-Park'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('30', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Lowry'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('57', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Lowry'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('38', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'O''Mahony'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('52', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Lowe'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('76', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Lowe'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('70', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Baird'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('80+2', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Treadwell'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('5', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Carbery'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('22', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Carbery'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('58', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('71', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('77', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('80+3', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('14', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Padovani'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('40+1', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Garbisi'));
COMMIT;

-- Quatrième journée
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('5', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Biggar'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('17', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Biggar'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('39', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Biggar'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('9', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Jelonch'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('11', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('3', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('47', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));

INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('30', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Braley'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('66', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Capuozzo'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('80+3', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Capuozzo'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('31', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Garbisi'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('67', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Garbisi'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('4', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Garbisi'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('18', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Johnson'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('22', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Harris'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('37', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Harris'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('48', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Graham'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('61', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Hogg'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('23', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('38', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('50', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('63', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));

INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('18', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('33', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('40+1', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('53', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('61', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('6', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Lowe'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('37', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Keenan'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('72', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Conan'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('76', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Bealham'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('39', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('74', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('78', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('3', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('66', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
COMMIT;

-- Cinquième journée
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('28', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Watkin'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('52', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Lake'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('69', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Adams'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('29', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Bigar'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('53', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Bigar'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('70', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Bigar'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('79', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Padovani'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('80+1', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Garbisi'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('12', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Garbisi'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('32', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Garbisi'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('57', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Garbisi'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('16', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Padovani'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('34', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Padovani'));

INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('17', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Sheehan'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('28', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Healy'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('60', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'van der Flier'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('80', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Murray'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('19', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('29', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('61', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('35', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Schoeman'));

INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('16', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Fickou'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('40', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Cros'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('61', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Dupont'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('40+2', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('62', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('9', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('24', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('48', 'Essais', 5, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Steward'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('50', 'Transformation', 2, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('20', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Marquer (tps, action, point, nm, nj) 
VALUES ('30', 'Pénalité', 3, (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
COMMIT;

-- Composer & Survenir

-- Première journée
-- Irlande - Pays de Galles
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Keenan'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Conway'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Ringrose'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Aki'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Hansen'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Sexton'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Gibson-Park'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Conan'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'van der Flier'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Doris'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Ryan'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Beirne'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Furlong'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Kelleher'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Porter'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Conway'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('69', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Gibson-Park'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Conan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Ryan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Furlong'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Kelleher'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Porter'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Sheehan'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Healy'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Bealham'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Baird'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'O''Mahony'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Murray'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Carbery'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Hume'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Sheehan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Healy'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Bealham'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Baird'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'O''Mahony'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('69', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Murray'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Carbery'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Hume'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Williams' AND prej = 'Liam'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'McNicholl'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Adams'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Tompkins'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Rees-Zammit'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Biggar'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Williams' AND prej = 'Tomos'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Wainwright'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Basham'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Jenkins'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Beard'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Rowlands'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Francis'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Elias'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Jones'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('57', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Williams' AND prej = 'Liam'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'McNicholl'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('49', 'Carton Jaune', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Adams'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('71', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Biggar'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Jenkins'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('71', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Rowlands'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Francis'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Elias'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Jones'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Lake'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Thomas'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Lewis'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Carter'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Moriarty'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Gareth'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Sheedy'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Watkin'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Lake'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Thomas'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Lewis'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('71', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Carter'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Moriarty'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('57', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Gareth'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('71', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Sheedy'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Watkin'));
COMMIT;

-- Écosse - Angleterre
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Hogg'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Graham'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Harris'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Johnson'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'van der Merwe'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Russell'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Price'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Fagerson' AND prej = 'Matt'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Watson'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Ritchie'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Gilchrist'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Gray'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Fagerson' AND prej = 'Zander'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Turner'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Sutherland'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Johnson'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('13', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Price'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('24', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Price'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('63', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Price'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Ritchie'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Gray'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Fagerson' AND prej = 'Zander'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Turner'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Sutherland'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'McInally'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Schoeman'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Nel'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Skinner'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Bradbury'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'White'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Kinghorn'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Tuipulotu'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'McInally'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Schoeman'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Nel'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Skinner'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Bradbury'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('13', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'White'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('24', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'White'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('63', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'White'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Tuipulotu'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Steward'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Malins'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Daly'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Slade'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Marchant'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Smith'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Youngs'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Simmonds'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Curry'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Ludlam'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Isiekwe'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Itoje'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Sinckler'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Cowan-Dickie'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Genge'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('80+1', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Marchant'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Smith'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('71', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Simmonds'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('78', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Simmonds'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Ludlam'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('78', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Isiekwe'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Sinckler'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Carton Jaune', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Cowan-Dickie'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('78', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Cowan-Dickie'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Genge'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'George'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Marler'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Stuart'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Ewels'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Dombrandt'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Randall'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Ford'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Nowell'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('71', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'George'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Marler'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Stuart'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('78', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Ewels'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Dombrandt'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Ford'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('80+1', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Nowell'));
COMMIT;

-- France - Italie
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Jaminet'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Penaud'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Fickou'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Danty'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Villière'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Ntamack'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Dupont'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Alldritt'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Cretin'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Jelonch'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Willemse'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Woki'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Atonio'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Marchand'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Baille'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('75', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('58', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Danty'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('70', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Dupont'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('70', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Alldritt'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('56', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Willemse'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Atonio'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('58', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Marchand'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Baille'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Mauvaka'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Gros'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Bamba'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Taofifénua' AND prej = 'Yoram'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Cros'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Lucu'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Moefana'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Ramos'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('58', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Mauvaka'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Gros'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Bamba'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('56', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Taofifénua' AND prej = 'Yoram'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('70', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Cros'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('70', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Lucu'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('58', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Moefana'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('75', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Ramos'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Padovani'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Menoncello'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Brex'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Zanon'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Ioane'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Garbisi'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Varney'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Halafihi'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Lamaro'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Negri'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Ruzza'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Cannone'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Pasquali'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Lucchesi'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Fischetti'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('58', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Menoncello'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Varney'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('56', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Halafihi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('70', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Negri'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Ruzza'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Cannone'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Cannone'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Pasquali'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Lucchesi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Fischetti'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Faiva'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Nemer'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Zilocchi'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Fuser'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Pettinelli'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Zuliani'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Braley'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Marin'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Faiva'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Nemer'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Zilocchi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Fuser'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('56', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Pettinelli'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('70', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Zuliani'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Braley'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Marin'));
COMMIT;

-- Deuxième journée
-- Pays de Galles - Écosse
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Williams' AND prej = 'Liam'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Cuthbert'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Watkin'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Tompkins'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Rees-Zammit'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Biggar'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Williams' AND prej = 'Tomos'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Moriarty'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Morgan'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Basham'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Beard'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Rowlands'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Francis'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Elias'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Jones'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('67', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Tompkins'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('78', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Biggar'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('71', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Williams' AND prej = 'Tomos'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('57', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Moriarty'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('75', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Rowlands'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('59', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Francis'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Elias'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Jones'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Lake'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Thomas'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Lewis'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Seb'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Wainwright'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Gareth'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Sheedy'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Jonathan'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Lake'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Thomas'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('59', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Lewis'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('75', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Seb'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('57', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Wainwright'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('78', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Sheedy'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('67', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Jonathan'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Hogg'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Graham'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Harris'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Tuipulotu'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'van der Merwe'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Russell'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Price'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Fagerson' AND prej = 'Matt'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Watson'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Skinner'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Gilchrist'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Gray'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Nel'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'McInally'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Schoeman'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('72', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Tuipulotu'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('78', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'van der Merwe'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('68', 'Carton Jaune', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Price'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('31', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Fagerson' and prej = 'Matt'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Gray'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('44', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Nel'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('44', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'McInally'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Schoeman'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Schoeman'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Turner'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Sutherland'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Fagerson' AND prej = 'Zander'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Bradbury'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Darge'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'White'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Kinghorn'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Redpath'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('44', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Turner'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('44', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Sutherland'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Sutherland'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('44', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Fagerson' and prej = 'Zander'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('31', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Bradbury'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Darge'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'White'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('72', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Kinghorn'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('78', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Redpath'));
COMMIT;

-- France - Irlande
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Jaminet'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Penaud'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Fickou'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Moefana'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Villière'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Ntamack'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Dupont'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Alldritt'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Jelonch'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Cros'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Willemse'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Woki'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Atonio'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Marchand'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Baille'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('70', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Dupont'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('73', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Cros'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Willemse'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Woki'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Atonio'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Marchand'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Baille'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Mauvaka'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Gros'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Bamba'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Taofifénua' AND prej = 'Romain'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Flament'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Cretin'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Lucu'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Ramos'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Mauvaka'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Gros'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Bamba'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Taofifénua' AND prej = 'Romain'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Flament'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('73', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Cretin'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('70', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Lucu'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Keenan'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Conway'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Ringrose'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Aki'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Hansen'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Carbery'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Gibson-Park'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Conan'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'van der Flier'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Doris'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Ryan'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Beirne'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Furlong'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Kelleher'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Porter'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Aki'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('79', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Carbery'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Gibson-Park'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Conan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('73', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Furlong'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('26', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Kelleher'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('73', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Porter'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Sheehan'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Healy'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Bealham'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Henderson'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'O''Mahony'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Murray'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Carty'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Henshaw'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('26', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Sheehan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('73', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Healy'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('73', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Bealham'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('58', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Henderson'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'O''Mahony'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('58', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'O''Mahony'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Murray'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('79', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Carty'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Henshaw'));
COMMIT;

-- Italie - Angleterre
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Padovani'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Mori'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Brex'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Zanon'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Ioane'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Garbisi'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Varney'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Halafihi'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Lamaro'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Steyn' AND prej = 'Braam'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Ruzza'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Cannone'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Ceccarelli'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Lucchesi'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Fischetti'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('47', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Padovani'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Mori'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Varney'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('38', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Halafihi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('72', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Ruzza'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('40', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Ceccarelli'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('52', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Lucchesi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('46', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Fischetti'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Faiva'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Traorè'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Pasquali'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Zambonin'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Negri'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Pettinelli'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Fusco'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Marin'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('52', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Faiva'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('46', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Traorè'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('40', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Pasquali'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('72', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Zambonin'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('38', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Negri'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Negri'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Pettinelli'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Fusco'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Marin'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Steward'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Malins'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Marchant'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Slade'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Nowell'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Smith'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Randall'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Dombrandt'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Curry'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Itoje'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Isiekwe'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Ewels'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Stuart'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'George'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Genge'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('74', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Marchant'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('17', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Nowell'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Randall'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Curry'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Isiekwe'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('40', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Stuart'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('56', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'George'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Genge'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Cowan-Dickie'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Marler'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Sinckler'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Chessum'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Simmonds'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Youngs'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Ford'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Daly'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('56', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Cowan-Dickie'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Marler'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('40', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Sinckler'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Chessum'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Simmonds'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Youngs'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('74', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Ford'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('17', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Daly'));
COMMIT;

-- Troisième journée
-- Écosse - France
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Hogg'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Graham'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Harris'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Tuipulotu'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'van der Merwe'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Russell'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Price'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Bradbury'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Darge'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Haining'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Gilchrist'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Skinner'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Fagerson' AND prej = 'Zander'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'McInally'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Schoeman'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('41', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Harris'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('48', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Price'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('58', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Price'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('69', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Price'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('44', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Haining'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Gilchrist'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('46', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Fagerson' and prej = 'Zander'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('46', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'McInally'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Schoeman'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Turner'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Kebble'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Nel'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Hodgson'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Christie'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'White'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Kinghorn'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Bennett'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('46', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Turner'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Kebble'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('46', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Nel'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Hodgson'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('44', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Christie'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('48', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'White'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('58', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'White'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('69', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'White'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Kinghorn'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('41', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Bennett'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Jaminet'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Penaud'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Fickou'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Danty'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Moefana'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Ntamack'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Dupont'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Alldritt'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Jelonch'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Cros'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Woki'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Willemse'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Atonio'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Marchand'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Baille'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('71', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('74', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Dupont'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Jelonch'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('68', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Woki'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Willemse'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('47', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Atonio'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Marchand'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('58', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Baille'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Mauvaka'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Gros'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Bamba'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Taofifénua' AND prej = 'Romain'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Flament'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Cretin'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Lucu'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Ramos'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Mauvaka'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('58', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Gros'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('47', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Bamba'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Taofifénua' AND prej = 'Romain'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Flament'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('68', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Cretin'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('74', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Lucu'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('71', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'SCO' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Ramos'));
COMMIT;

-- Angleterre - Pays de Galles
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Steward'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Malins'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Daly'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Slade'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Nowell'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Smith'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Randall'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Dombrandt'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Curry'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Lawes'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Itoje'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Ewels'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Sinckler'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Cowan-Dickie'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Genge'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('74', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Daly'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Randall'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('41', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Curry'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('69', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Ewels'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('69', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Sinckler'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('25', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Cowan-Dickie'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('72', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Genge'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'George'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Marler'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Stuart'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Isiekwe'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Simmonds'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Youngs'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Ford'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Marchant'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('25', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'George'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('72', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Marler'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('68', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Stuart'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('68', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Isiekwe'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('41', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Simmonds'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Youngs'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('74', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Marchant'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Williams' AND prej = 'Liam'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Cuthbert'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Watkin'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Tompkins'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Adams'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Biggar'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Williams' AND prej = 'Tomos'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Faletau'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Basham'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Moriarty'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Beard'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Rowlands'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Francis'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Elias'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Jones'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('72', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Williams' and prej = 'Liam'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('79', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Williams' and prej = 'Liam'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('69', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Watkin'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('79', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Adams'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('69', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Williams' and prej = 'Tomos'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Basham'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('71', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Moriarty'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Francis'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('69', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Elias'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('45', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Jones'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Lake'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Thomas'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Brown'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Seb'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Morgan'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Hardy'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Anscombe'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'),(SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Jonathan'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('45', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Lake'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('45', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Thomas'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('45', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Brown'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('45', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Seb'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('45', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Morgan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('45', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Hardy'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('45', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Anscombe'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('45', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'WAL'), (SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Jonathan'));
COMMIT;

-- Irlande - Italie
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Lowry'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Hansen'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Ringrose'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Henshaw'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Lowe'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Carbery'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Gibson-Park'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Doris'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'van der Flier'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'O''Mahony'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Baird'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Beirne'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Furlong'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Sheehan'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Porter'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('3', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Ringrose'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('9', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Ringrose'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Ringrose'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('68', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Ringrose'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('68', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Henshaw'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Carbery'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Gibson-Park'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Doris'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Beirne'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Furlong'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('69', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Sheehan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('44', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Porter'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Herring'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Kilcoyne'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Bealham'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Treadwell'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Conan'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Casey'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Sexton'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Hume'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('69', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Herring'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('44', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Kilcoyne'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Bealham'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Treadwell'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Conan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Casey'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('3', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Hume'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('9', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Hume'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Hume'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Padovani'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Bruno'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Brex'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Marin'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Ioane'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Garbisi'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Varney'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Halafihi'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Lamaro'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Pettinelli'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Ruzza'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Cannone'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Ceccarelli'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Lucchesi'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Fischetti'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('20', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Bruno'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Marin'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('77', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Marin'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('77', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Garbisi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('41', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Varney'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('19', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Halafihi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Lamaro'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('77', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Lamaro'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Pettinelli'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Pettinelli'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('77', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Pettinelli'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('68', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Ruzza'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('49', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Cannone'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('41', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Ceccarelli'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('9', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Lucchesi'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Faiva'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Nemer'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Pasquali'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Sisi'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Zuliani'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Steyn' AND prej = 'Braam'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Fusco'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Zanon'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('9', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Faiva'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('19', 'Carton Rouge', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Faiva'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('20', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Nemer'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('41', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Pasquali'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('68', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Sisi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('49', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Zuliani'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Steyn' AND prej = 'Braam'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('41', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Fusco'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Zanon'));
COMMIT;

-- Quatrième journée
-- Pays de Galles - France
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Williams' AND prej = 'Liam'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Cuthbert'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Watkin'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Jonathan'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Adams'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Biggar'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Williams' AND prej = 'Tomos'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Faletau'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Navidi'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Seb'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Beard'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Rowlands'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Francis'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Elias'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Thomas'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('67', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Williams' and prej = 'Liam'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Seb'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('11', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Williams' and prej = 'Tomos'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Navidi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Jonathan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('60', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Francis'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Elias'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('67', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Thomas'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Lake'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Jones'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Lewis'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Moriarty'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Morgan'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Hardy'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Anscombe'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Rees-Zammit'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Lake'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('67', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Jones'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('60', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Lewis'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Moriarty'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Morgan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('11', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Hardy'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('67', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Anscombe'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Rees-Zammit'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Jaminet'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Moefana'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Fickou'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Danty'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Villière'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Ntamack'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Dupont'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Alldritt'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Jelonch'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Cros'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Willemse'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Woki'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Atonio'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Marchand'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Baille'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('80', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Danty'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('72', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Dupont'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Alldritt'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Woki'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('40', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Atonio'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Marchand'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Baille'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Mauvaka'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Gros'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Haouas'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Lebel'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Flament'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Cretin'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Lucu'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'),(SELECT nj FROM Joueur WHERE nomj = 'Ramos'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Mauvaka'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Gros'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('40', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Haouas'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('80', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Lebel'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Flament'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('65', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Cretin'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('72', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'FRA'), (SELECT nj FROM Joueur WHERE nomj = 'Lucu'));
COMMIT;

-- Italie - Écosse
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Padovani'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Bruno'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Brex'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Marin'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Ioane'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Garbisi'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Braley'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Halafihi'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Lamaro'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Pettinelli'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Ruzza'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Cannone'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Ceccarelli'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Nicotera'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Fischetti'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Padovani'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Bruno'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('72', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Pettinelli'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Cannone'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('52', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Ceccarelli'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('52', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Nicotera'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('52', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Fischetti'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Bigi'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Nemer'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Pasquali'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Sisi'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Steyn' AND prej = 'Braam'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Fusco'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Zanon'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Capuozzo'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('52', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Bigi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('52', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Nemer'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('52', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Pasquali'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Sisi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('72', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Steyn' AND prej = 'Braam'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Zanon'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('50', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Capuozzo'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Hogg'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Graham'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Harris'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Johnson'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Steyn' AND prej = 'Kyle'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Russell'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Price'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Fagerson' AND prej = 'Matt'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Watson'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Darge'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Gilchrist'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Skinner'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Fagerson' AND prej = 'Zander'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Turner'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Schoeman'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Johnson'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Price'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('63', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Fagerson' and prej = 'Matt'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Skinner'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('60', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Fagerson' and prej = 'Zander'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('60', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Turner'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('60', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Schoeman'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'McInally'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Dell'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Nel'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Hodgson'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Bradbury'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Vellacott'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Hastings'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Tuipulotu'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('60', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'McInally'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('60', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Dell'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('60', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Nel'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Hodgson'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('63', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Bradbury'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Vellacott'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Hastings'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ITA' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Tuipulotu'));
COMMIT;

-- Angleterre - Irlande
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Steward'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Malins'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Marchant'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Slade'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Nowell'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Smith'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Randall'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Simmonds'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Curry'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Lawes'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Ewels'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Itoje'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Sinckler'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'George'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Genge'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('80', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Steward'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('70', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Slade'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Randall'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('15', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Curry'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('2', 'Carton Rouge', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Ewels'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('39', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Sinckler'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('80', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'George'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('67', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Genge'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Blamire'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Marler'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Stuart'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Launchbury'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Dombrandt'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Youngs'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Ford'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Daly'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('80', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Blamire'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('67', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Marler'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('39', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Stuart'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('67', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Launchbury'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('15', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Dombrandt'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('67', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Dombrandt'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Youngs'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('80', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Ford'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('70', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Daly'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Keenan'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Conway'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Ringrose'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Aki'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Lowe'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Sexton'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Gibson-Park'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Doris'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'van der Flier'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'O''Mahony'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Ryan'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Beirne'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Furlong'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Sheehan'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Healy'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('80', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Sexton'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('68', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Gibson-Park'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'O''Mahony'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('2', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Ryan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('74', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Furlong'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Sheehan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Healy'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Herring'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Kilcoyne'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Bealham'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Henderson'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Conan'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Murray'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Carbery'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'),(SELECT nj FROM Joueur WHERE nomj = 'Henshaw'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Herring'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('53', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Kilcoyne'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('74', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Bealham'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('2', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Henderson'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Conan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('68', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Murray'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('80', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'ENG' AND ne2 = 'IRL'), (SELECT nj FROM Joueur WHERE nomj = 'Carbery'));
COMMIT;

-- Cinquième journée
-- Pays de Galles - Italie
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'McNicholl'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Rees-Zammit'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Watkin'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Halaholo'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Adams'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Biggar'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Gareth'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Faletau'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Navidi'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Seb'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Wyn Jones'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Beard'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Lewis'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Lake'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Thomas'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('59', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'McNicholl'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('46', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Halaholo'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Gareth'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('49', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Davies' AND prej = 'Seb'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('59', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Wyn Jones'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('40', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Lewis'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('75', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Lake'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('59', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Thomas'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Roberts'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Jones'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Brown'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Rowlands'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Moriarty'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Hardy'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Sheedy'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Tompkins'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('75', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Roberts'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('59', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Jones'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('40', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Brown'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('59', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Rowlands'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('49', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Moriarty'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Hardy'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('59', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Sheedy'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('46', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Tompkins'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Capuozzo'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Padovani'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Brex'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Marin'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Ioane'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Garbisi'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Braley'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Halafihi'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Lamaro'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Pettinelli'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Ruzza'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Fuser'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Ceccarelli'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Nicotera'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Fischetti'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('52', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Marin'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('59', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Braley'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('63', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Halafihi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('74', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Pettinelli'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('47', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Fuser'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('52', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Ceccarelli'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('52', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Nicotera'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('69', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Fischetti'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Bigi'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Traorè'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Pasquali'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Sisi'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Cannone'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Steyn' AND prej = 'Braam'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Fusco'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'),(SELECT nj FROM Joueur WHERE nomj = 'Zanon'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('52', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Bigi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('69', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Traorè'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('52', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Alongi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('74', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Sisi'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('47', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Cannone'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('63', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Steyn' AND prej = 'Braam'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('59', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Fusco'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('52', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'WAL' AND ne2 = 'ITA'), (SELECT nj FROM Joueur WHERE nomj = 'Zanon'));
COMMIT;

-- Irlande - Écosse
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Keenan'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Hansen'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Ringrose'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Aki'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Lowe'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Sexton'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Gibson-Park'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Conan'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'van der Flier'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Doris'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Henderson'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Beirne'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Furlong'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Sheehan'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Healy'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('73', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Keenan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Aki'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Gibson-Park'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('51', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Conan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Henderson'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('67', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Beirne'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Sheehan'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('51', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Healy'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Herring'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Kilcoyne'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Bealham'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Treadwell'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'O''Mahony'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Murray'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Carbery'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Henshaw'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Herring'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('51', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Kilcoyne'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('67', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Bealham'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Treadwell'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('51', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'O''Mahony'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Murray'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('73', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Carbery'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('55', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Henshaw'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Hogg'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Graham'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Harris'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Johnson'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Steyn' AND prej = 'Kyle'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Kinghorn'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Price'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Fagerson' AND prej = 'Matt'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Watson'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Darge'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Gilchrist'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Gray'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Fagerson' AND prej = 'Zander'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Turner'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Schoeman'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Harris'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('60', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Johnson'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('60', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Price'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Fagerson' AND prej = 'Matt'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('51', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Gilchrist'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Fagerson' AND prej = 'Zander'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('51', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Turner'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('73', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Schoeman'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Brown'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Dell'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Nel'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Skinner'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Bayliss'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'White'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Russell'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'),(SELECT nj FROM Joueur WHERE nomj = 'Bennett'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('51', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Brown'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('73', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Dell'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Nel'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('51', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Skinner'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Bayliss'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('60', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'White'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('77', 'Carton Jaune', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'White'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('66', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Russell'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('62', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'IRL' AND ne2 = 'SCO'), (SELECT nj FROM Joueur WHERE nomj = 'Bennett'));
COMMIT;

-- France - Angleterre
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Jaminet'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Penaud'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Danty'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Fickou'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Villière'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Ntamack'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Dupont'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Alldritt'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Jelonch'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Cros'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Willemse'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Woki'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Atonio'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Marchand'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Baille'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Jaminet'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Dupont'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('71', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Cros'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('49', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Willemse'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('71', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Woki'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Atonio'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('49', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Marchand'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('49', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Baille'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Mauvaka'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Gros'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Haouas'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Taofifénua' AND prej = 'Romain'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Flament'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Cretin'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Lucu'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Ramos'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('49', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Mauvaka'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('49', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Gros'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('54', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Haouas'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('49', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Taofifénua' AND prej = 'Romain'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('71', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Flament'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('71', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Cretin'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Lucu'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Ramos'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Furbank'), 15);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Steward'), 14);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Marchant'), 13);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Slade'), 12);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Nowell'), 11);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Smith'), 10);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Youngs'), 9);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Simmonds'), 8);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Underhill'), 7);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Lawes'), 6);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Isiekwe'), 5);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Itoje'), 4);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Stuart'), 3);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'George'), 2);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Genge'), 1);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Furbank'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('25', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Nowell'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Youngs'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Underhill'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Isiekwe'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('49', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Stuart'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Sortie', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Genge'));

INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Dolly'), 16);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Marler'), 17);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Sinckler'), 18);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Chessum'), 19);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Dombrandt'), 20);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Randall'), 21);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Ford'), 22);
INSERT INTO Composer (nm, nj, maillot) VALUES ((SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'),(SELECT nj FROM Joueur WHERE nomj = 'Daly'), 23);

INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Marler'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('49', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Sinckler'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('61', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Chessum'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Dombrandt'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('64', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Randall'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('76', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Ford'));
INSERT INTO Survenir (tps, evt, nm, nj)
VALUES ('25', 'Entrée', (SELECT nm FROM Match WHERE ne1 = 'FRA' AND ne2 = 'ENG'), (SELECT nj FROM Joueur WHERE nomj = 'Daly'));
COMMIT;
