-- CREAZIONE DEL DB (SE NON ESISTE GIA')
CREATE DATABASE IF NOT EXISTS db_sv_monei_tracker;
USE db_sv_monei_tracker;

-- CREAZIONE ENUM PRIMA DELLA TABELLA
CREATE TYPE STATO_UTENTE AS ENUM ('attivo', 'disattivo');
CREATE TYPE RUOLO_UTENTE AS ENUM ('standard', 'pro', 'admin');

-- CREIAMO L'ESTENSIONE CITEXT PER LE MAIL
CREATE EXTENSION citext;

--CREAZIONE DELLE TABELLE 
CREATE TABLE tbl_utente IF NOT EXISTS (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(30),
  cognome VARCHAR(30),
  email CITEXT,
  ruolo RUOLO_UTENTE,
  data_creazione TIMESTAMP,
  stato STATO_UTENTE,
  psw_hash VARCHAR(255)
);

CREATE TYPE TIPO_CATEGORIA AS ENUM ('ingresso', 'uscita');

CREATE TABLE tbl_categoria IF NOT EXISTS (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255),
  tipo TIPO_CATEGORIA
);

CREATE TYPE TIPO_CONTO AS ENUM ('Carta di credito','Contanti','Carta di debito','Banca')

CREATE TABLE tbl_conto IF NOT EXISTS (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255),
  tipo TIPO_CONTO,
  saldo_attuale DECIMAL,
  id_utente REFERENCES tbl_utente(id)
)

CREATE TABLE tbl_tag IF NOT EXISTS (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255),
  id_categoria REFERENCES tbl_categoria(id)
)

CREATE TYPE TIPO_MOVIMENTO AS ENUM ('ingresso','uscita')

CREATE TABLE tbl_movimento IF NOT EXISTS (
  id SERIAL PRIMARY KEY,
  importo DECIMAL,
  descrizione TEXT,
  tipo TIPO_MOVIMENTO,
  id_utente REFERENCES tbl_utente(id),
  id_conto REFERENCES tbl_conto(id),
  id_categoria REFERENCES tbl_categoria(id)
)

CREATE TABLE tbl_movimento_tag IF NOT EXISTS (
  id_movimento REFERENCES tbl_movimento(id),
  id_tag REFERENCES tbl_tag(id),
  PRIMARY KEY(id_movimento, id_tag)
)
