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
        serial id-utente
        varchar(255) nome
        ENUM(tipo) tipo
        decimal saldo-attuale
    }

    MOVIMENTO {
        serial id-movimento
        serial id-utente
        serial id-conto
        serial id-categoria
        decimal importo
        text descrizione
        ENUM(tipo) tipo
    }

    CATEGORIA {
        serial id
        string nome
        da finire
    }

    TAG {
        serial id
        string nome
        serial id-categoria
    }

    MOVIMENTO-TAG {
        serial movimento_id
        serial tag_id
    }

    UTENTE ||--o{ CONTO : possiede
    UTENTE ||--o{ MOVIMENTO : registra
    CONTO ||--o{ MOVIMENTO : contiene
    CATEGORIA ||--o{ MOVIMENTO : classifica
    MOVIMENTO ||--o{ MOVIMENTO-TAG : ha
    TAG ||--o{ MOVIMENTO-TAG : collega
```
