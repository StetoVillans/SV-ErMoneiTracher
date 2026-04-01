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
flowchart TD
    A[Utente] -->|1;N| B(Movimento)
    A[Utente] -->|1;N| C(Conto)
    B --> |1;1| D(Categoria)
    C --> |1;N| B
    B --> |1;N| F(Movimento-Tag)
    E(Tag) --> |1;N| F
    E --> |1;N| D
```