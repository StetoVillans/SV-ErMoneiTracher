# ER MONEI TRACHER

Il mio primo progetto per cercare di creare un money tracher, si svilupperà come sito web, così da poterci accedere anche da smartphone.
L'obbiettivo per ora è quello di creare un semplice programmino di gestione delle spese, quando sarà da implementare funzionalità aggiuntive se ne riparlerà.

# TECH STACK

- Backend -> Node.JS
- Frontend -> in scelta, provvisoriamente vanillaJS
- Database -> PostgreSQL

## Backend

Nel backend andrò ad utilizzare una struttura di tipo:
- Model 
- Controller
- Router
- Middleware
- Utils
Che gestiranno la maggior parte delle api e gestione dei dati tramite API RESTFUL.

## Frontend

Suca sarà da vedere meglio dopo

## Database


``` mermaid
erDiagram
    UTENTE {
        serial id-utente
        varchar(30) nome
        varchar(30) cognome
        citext email
        ENUM(ruolo) ruolo
        timestamp data-creazione
        ENUM(stato) stato
        varchar(255) psw-hash
    }

    CONTO {
        serial id
        serial id-utente external
        varchar(255) nome
        ENUM(tipo) tipo
        decimal saldo-attuale
    }

    MOVIMENTO {
        serial id-movimento
        serial id-utente external
        serial id-conto external
        serial id-categoria external
        decimal importo
        text descrizione
        ENUM(tipo) tipo
    }

    CATEGORIA {
        serial id
        varchar(255) nome
        enum(tipo) tipo
    }

    TAG {
        serial id
        string nome
        serial id-categoria external
    }

    MOVIMENTO-TAG {
        serial movimento_id external
        serial tag_id external
    }

    UTENTE ||--o{ CONTO : possiede
    UTENTE ||--o{ MOVIMENTO : registra
    CONTO ||--o{ MOVIMENTO : contiene
    CATEGORIA ||--o{ MOVIMENTO : classifica
    MOVIMENTO ||--o{ MOVIMENTO-TAG : ha
    TAG ||--o{ MOVIMENTO-TAG : collega
```

## Configuration

Prima di tutto, se si è su dispositivo windows, scaricare node.js dal sito di Node e questa estensione per VS Code:

Name: REST Client
Id: humao.rest-client
Description: REST Client for Visual Studio Code
Version: 0.25.1
Publisher: Huachao Mao
VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=humao.rest-client

Una volta installato provare a fare:

node --version

Quindi, se tutto ok, fare poi:

npm init -y

npm i fastify fastify-swagger uuid

Per scaricare i pacchetti di esecuzione di fastify (backend).

Fastify swagger ci darà un'ottima documentazione per le nostre openAPI.

uuid ci aiuterà a genererare uuid randomici.

Ci potrebbero essere due intoppi:
- il primo, l'installazione di node non ha messo la cartella all'interno di PATH, si può fare a mano
- L'esecuzione degli script è disabilitata sul dispositivo, powershell admin, e mettere dentro: Set-ExecutionPolicy RemoteSigned

Poi per il development

npm i -D nodemon

Poi modifichiamo gli script in package.json così:

"main": "server.js",
  "scripts": {
    "start": "node server",
    "dev": "nodemon server"
  },


### Init.sql

```sql
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
```

# Docker compose
```yml
services:
  db:
    image: postgres:18
    restart: always
    environment:
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}
    ports:
      - '5432:5432'
    volumes: 
      - db:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d

volumes:
  db:
    driver: local
```