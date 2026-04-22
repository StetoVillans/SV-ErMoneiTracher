-- CREAZIONE ENUM PRIMA DELLA TABELLA
CREATE TYPE STATO_UTENTE AS ENUM ('attivo', 'disattivo');
CREATE TYPE RUOLO_UTENTE AS ENUM ('standard', 'pro', 'admin');

-- CREIAMO L'ESTENSIONE CITEXT PER LE MAIL
CREATE EXTENSION citext;

--CREAZIONE DELLE TABELLE 
CREATE TABLE IF NOT EXISTS tbl_utenti (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(30),
  cognome VARCHAR(30),
  email CITEXT,
  ruolo RUOLO_UTENTE,
  data_creazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  stato STATO_UTENTE,
  psw_hash VARCHAR(255)
);

CREATE TYPE TIPO_CATEGORIA AS ENUM ('ingresso', 'uscita');

CREATE TABLE IF NOT EXISTS tbl_categorie (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255),
  tipo TIPO_CATEGORIA
);

CREATE TYPE TIPO_CONTO AS ENUM ('Carta di credito', 'Contanti', 'Carta di debito', 'Banca');

CREATE TABLE IF NOT EXISTS tbl_conti (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255),
  tipo TIPO_CONTO,
  saldo_attuale DECIMAL,
  id_utente INT,
  CONSTRAINT fk_utente
    FOREIGN KEY (id_utente)
    REFERENCES tbl_utenti(id)
);

CREATE TABLE IF NOT EXISTS tbl_tags (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255),
  id_categoria INT,
  CONSTRAINT fk_categoria
    FOREIGN KEY (id_categoria)
    REFERENCES tbl_categorie(id)
);

CREATE TYPE TIPO_MOVIMENTO AS ENUM ('ingresso','uscita');

CREATE TABLE IF NOT EXISTS tbl_movimenti (
  id SERIAL PRIMARY KEY,
  importo DECIMAL,
  descrizione TEXT,
  tipo TIPO_MOVIMENTO,
  id_utente INT,
  CONSTRAINT fk_utente
    FOREIGN KEY (id_utente) 
    REFERENCES tbl_utenti(id),
  id_conto INT,
  CONSTRAINT fk_conto
    FOREIGN KEY (id_conto)
    REFERENCES tbl_conti(id),
  id_categoria INT,
  CONSTRAINT fk_categoria
    FOREIGN KEY (id_categoria)
    REFERENCES tbl_categorie(id)
);

CREATE TABLE IF NOT EXISTS tbl_tags (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255),
  id_categoria INT,
  CONSTRAINT fk_categoria
    FOREIGN KEY (id_categoria)
    REFERENCES tbl_categorie(id)
);

CREATE TABLE IF NOT EXISTS tbl_movimenti_tags (
  id_movimento INT,
  CONSTRAINT fk_movimento
    FOREIGN KEY (id_movimento) 
    REFERENCES tbl_movimenti(id),
  id_tag INT,
  CONSTRAINT fk_tag
    FOREIGN KEY (id_tag) 
    REFERENCES tbl_tags(id),
  PRIMARY KEY(id_movimento, id_tag)
);


-- INSERT
-- CATEGORIE
INSERT INTO tbl_categorie (nome, tipo) VALUES ('Salute', 'uscita'), ('Sport', 'uscita'), ('Cibo', 'uscita'), ('Moda', 'uscita'), ('Regali', 'uscita'), ('Trasporti Pubblici', 'uscita'), ('Auto\Moto', 'uscita'), ('Abbonamenti', 'uscita'), ('Stipendio', 'ingresso'), ('Bonifico','ingresso'), ('Paghetta', 'ingresso'), ('Investimenti', 'ingresso'), ('Prestiti', 'ingresso'), ('Regali', 'ingresso');

-- TAG CATEGORIA: SALUTE
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Visite', 1), ('Medicine', 1), ('Trattamenti', 1);

-- TAG CATEGORIA SPORT
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Palestra', 2), ('Sport Generale', 2), ('Attrezzatura', 2);

-- TAG CATEGORIA CIBO
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Pranzo', 3), ('Cena', 3), ('Caffe', 3), ('Merenda', 3), ('Spesa', 3);

-- TAG CATEGORIA MODA
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Vestiti', 4), ('Accessori', 4), ('Scarpe', 4);

-- TAG CATEGORIA REGALI
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Varie', 5);

-- TAG CATEGORIA TRASPORTI PUBBLICI
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Taxi', 6), ('Treno', 6), ('Aereo', 6), ('Barca', 6), ('Bus', 6);

-- TAG CATEGORIA AUTO\MOTO
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Ricambi', 7), ('Bollo', 7), ('Assicurazione', 7), ('Meccanico', 7), ('Estetica', 7);

-- TAG CATEGORIA ABBONAMENTI
INSERT INTO tbl_tags (nome, id_categoria) VALUES ('Musica', 8), ('Video', 8), ('AI', 8), ('Varie', 8);

-- UTENTI DEMO
INSERT INTO tbl_utenti (nome, cognome, email, ruolo, stato, psw_hash) VALUES ('Utente', 'Demo', 'utente.demo@gmail.com', 'standard', 'attivo', 'PSWUtenteDemo'), ('Admin', 'Demo', 'admin.demo@gmail.com', 'admin', 'attivo', 'PSWAdminDemo');

-- CONTO DEMO
INSERT INTO tbl_conti (nome, tipo, saldo_attuale, id_utente) VALUES ('Carta di esempio', 'Carta di credito', 20.00, 1);

-- MOVIMENTI DEMO
INSERT INTO tbl_movimenti (importo, descrizione, tipo, id_utente, id_conto, id_categoria) VALUES (20.00, 'Movimento di prova 1', 'uscita', 1, 1, 2);
