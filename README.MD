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
        int id
        string nome
    }

    CONTO {
        int id
        int utente_id
        string nome
    }

    MOVIMENTO {
        int id
        int utente_id
        int conto_id
        int categoria_id
        decimal importo
    }

    CATEGORIA {
        int id
        string nome
    }

    TAG {
        int id
        string nome
    }

    MOVIMENTO_TAG {
        int movimento_id
        int tag_id
    }

    UTENTE ||--o{ CONTO : possiede
    UTENTE ||--o{ MOVIMENTO : registra
    CONTO ||--o{ MOVIMENTO : contiene
    CATEGORIA ||--o{ MOVIMENTO : classifica
    MOVIMENTO ||--o{ MOVIMENTO_TAG : ha
    TAG ||--o{ MOVIMENTO_TAG : collega
```