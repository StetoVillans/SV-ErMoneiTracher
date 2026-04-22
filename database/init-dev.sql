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
INSERT INTO tbl_utenti (nome, cognome, email, ruolo, stato, psw_hash) VALUES 
('Utente', 'Demo', 'utente.demo@gmail.com', 'standard', 'attivo', 'PSWUtenteDemo'), 
('Admin', 'Demo', 'admin.demo@gmail.com', 'admin', 'attivo', 'PSWAdminDemo'),
('Mario', 'Rossi', 'mario.rossi@gmail.com', 'standard', 'attivo', 'PSWUtenteDemo'),
('Giacomo', 'Verdi', 'giacomo.verdi@gmail.com', 'pro', 'attivo', 'PSWUtenteDemo'),
('Rosa', 'Gialli', 'rosa.gialli@gmail.com', 'pro', 'attivo', 'PSWUtenteDemo'),
('Antonio', 'Bianchi', 'antonio.bianchi@gmail.com', 'standard', 'attivo', 'PSWUtenteDemo'),
('Roberto', 'Blu', 'roberto.blu@gmail.com', 'standard', 'attivo', 'PSWUtenteDemo'),
('Stefano', 'Gialli', 'stefano.gialli@yahoo.it', 'standard', 'attivo', 'PSWUtenteDemo'),
('Enrico', 'Papi', 'enrico.papi@yahoo.it', 'standard', 'attivo', 'PSWUtenteDemo'),
('Robert', 'Downey JR', 'robert.downeyjr@yahoo.it', 'pro', 'disattivo', 'PSWUtenteDemo');

-- CONTO DEMO
INSERT INTO tbl_conti (nome, tipo, saldo_attuale, id_utente) VALUES 
('Credito utente demo', 'Carta di credito', 200.00, 1),
('Debito utente demo', 'Carta di debito', 2000.00, 1),
('Nemo', 'Carta di credito', 1000.00, 2),
('Dori', 'Carta di debito', 2000.00, 2),
('Scemo chi legge', 'Carta di credito', 100000.00, 3),
('Cazzo ho letto', 'Carta di debito', 856.00, 3),
('Thuram', 'Carta di credito', 151.00, 4),
('Chiellini', 'Carta di debito', 14678.00, 4),
('Credito Rosa', 'Carta di credito', 9782.00, 5),
('Debito Rosa', 'Carta di debito', 1234.00, 5),
('Zaino', 'Contanti', 0.00, 6),
('Marsupio', 'Banca', 1.00, 6),
('Salmone', 'Contanti', 124.00, 7),
('Tonno', 'Banca', 77.00, 7),
('Antonio', 'Contanti', 159753.00, 8),
('Marco', 'Banca', 957.00, 8),
('New Holland', 'Contanti', 357.00, 9),
('Lamborghini', 'Banca', 159.00, 9),
('HP', 'Contanti', 852.00, 10),
('Lenovo', 'Banca', 258.00, 10),;

-- 20 MOVIMENTI DEMO PER UTENTE DEMO (id_utente = 1)
INSERT INTO tbl_movimenti (importo, descrizione, tipo, id_utente, id_conto, id_categoria) VALUES
(20.00, 'Spesa supermercato Conad', 'uscita', 1, 1, 2),
(55.00, 'Rifornimento benzina', 'uscita', 1, 2, 3),
(1200.00, 'Stipendio mensile', 'ingresso', 1, 2, 1),
(9.99, 'Abbonamento streaming', 'uscita', 1, 1, 4),
(35.50, 'Cena pizza con amici', 'uscita', 1, 1, 5),
(18.00, 'Farmacia prodotti vari', 'uscita', 1, 1, 6),
(250.00, 'Vendita oggetto usato', 'ingresso', 1, 2, 7),
(70.00, 'Bollette luce e gas', 'uscita', 1, 2, 8),
(15.00, 'Colazione e bar', 'uscita', 1, 1, 5),
(500.00, 'Bonus annuale', 'ingresso', 1, 2, 1),
(42.90, 'Acquisto scarpe sportive', 'uscita', 1, 1, 9),
(7.50, 'Parcheggio centro città', 'uscita', 1, 1, 10),
(65.00, 'Cena sushi', 'uscita', 1, 1, 5),
(300.00, 'Rimborso spese lavoro', 'ingresso', 1, 2, 7),
(24.99, 'Acquisto libro online', 'uscita', 1, 1, 11),
(89.00, 'Manutenzione auto', 'uscita', 1, 2, 3),
(130.00, 'Regalo compleanno ricevuto', 'ingresso', 1, 2, 7),
(12.00, 'Lavanderia automatica', 'uscita', 1, 1, 12),
(220.00, 'Freelance progetto web', 'ingresso', 1, 2, 1),
(31.40, 'Pranzo fuori ufficio', 'uscita', 1, 1, 5);
