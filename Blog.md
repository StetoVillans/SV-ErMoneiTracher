# Perchè questo file?

Il motivo di questo file è mantenere una motivazione dietro le mie scelte ed avere uno storico da tenere pubblico per il processo che ho seguito per ogni scelta del progetto.

## LO STACK

Per il momento mi sono appoggiato su uno stack facile, su cui so già mettere le mani senza dover strafare nulla, l'obbiettivo è fare un progetto da cui imparare, non vendere qualcosa.

Per questo motivo lo stack che andrò a seguire, come scritto nel README.MD è:
- Backend -> Node
- Frontend -> Vanilla js e html
- Database -> Postgresql

Un parte del progetto in futuro potrebbe includere la sostituzione di una delle tecnologie, come il frontend con uno basato su react.

## 31-03-2026 .GITIGNORE

Prima di iniziare, controllo il .gitignore che abbia tutto quello che mi interessa (per ora) che ignori.

Quando ho creato il repo l'ho creato con il modello node quindi le cartelle principali create da un backend node dovrebbe già ignorarle, come node_modules, .env etc... ma verifichiamo.

R. Sì, se vai a guardare il file .ignore a questo commit si può vedere come l'inserimento del file .ignore da modello ha messo tutto quello di cui necessitiamo per ora.

## 31-03-2026 STRUTTURA CARTELLE 

Adesso andiamo intanto a creare la struttura delle cartelle per il nostro progetto, così da separare backend, database e frontend. 

Quindi:
mkdir backend database frontend

Da qui, in database e backend non andiamo a creare nessuna cartella poichè:
- Per il backend quando andiamo a creare il progetto node creeerà lui la struttura di cartelle
- Per il database non ci dovrebbe interessare creare cartelle per dividere il tutto, le faremo all'eventualità.

Però possiamo farle per il frontend, sicuramente ci serviranno:
cd frontend
mkdir html css js media 

Per ora facciamo solo queste, non sono quelle perfette o che occupano tutti i casi d'uso del fronend, però ci bastano per adesso per creare un frontend base per operatività.

## 31-03-2026 CHE SI FA

Direi proprio che la prima cosa che mi conviene più fare è definire lo schema del db, ho già fatto uno spunto nel file ReadME.md in uno schema mermaid:

``` mermaid
flowchart TD
    A[Utente] -->|1;N| B(Movimento)
    A[Utente] -->|1;N| C(Conto)
    B --> |1;1| D(Categoria)
    C --> |1;N| B
    E(Tag) --> |N;N| B
    E --> |1;N| D
```

Però sicuramente intanto possiamo definire i campi, li ho segnati in uno schema che mi sono fatto su carta quindi potrei aggiungerli allo schema mermaid, devo un'attimo sgooglare come si aggiungevano i campi alle tabelle di mermaid.

Ho detto una cazzata, su marmaid non si possono mettere le tabelle, però le posso scrivere in markdown, visto che scriverle in markdown sarebbe un pugno in culo uso questo strumento che ho trovato:

https://www.tablesgenerator.com/markdown_tables

Note: 
- In postgres il tipo "serial" è un valore auto incrementale, quindi funge la funzione di AUTO INCREMENT che avevo visto in MySQL a scuola e a cui ero abituato.

## Tabella Utente

Stavo scrivendo le proprietà che mi interessano della tabella e per trovare il giusto tipo da dare al campo email ho trovato questo thread di stack overflow molto utile:

https://stackoverflow.com/questions/62113787/what-should-be-the-data-type-of-field-email-in-postgresql-database-in-pgadmin

Dove si parla di questo campo CITEXT dove ignora il maiuscolo e minuscolo quando fa una comparazione di valori, e nel caso delle mail che è molto importante che non si duplichino è giusto che non permetta due ingressi di questo tipo: steph.villans@gmail.com e Steph.Villans@gmail.com

Dice anche che questo type fa parte di un estensione di nome citext, dovrei approfondire cosa sono le estensioni in postgres.

| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-utente  	| serial      	| Si 	|    	|
| Nome       	| varchar(30) 	|    	|    	|
| Cognome    	| varchar(30) 	|    	|    	|
| Email      	| citext      	|    	|    	|
| ruolo-utente      	| ENUM(ruolo-utente)     	|    	|    	|

ENUM vuol dire che il tipo di dato lo andrò a creare io, in questo caso sarà così:

CREATE TYPE ruolo-utente AS ENUM ('standard', 'pro', 'admin');


### Estensioni POSTGRESQL

Beh ci ho guardato e le estensioni sono proprio quello che si può immaginare, componenti aggiuntivi per postgresql che ne permettono l'ampliazione delle funzionalità.

Giusto per esser completi, l'estensione citext che interessa a me in sostanza, trasforma tutte le stringhe con questo tipo in minuscolo nel momento in cui si devono confrontare con altri valori.

Da tenere a mente che comunque memorizza nel db il valore AS-IS, nel senso che se io mi registro scrivendo:
    Steph.Villans@Gmail.com
Quando fa i confronti li farà con il valore "steph.villans@gmail.com" ma il valore registrato sul db sarà sempre "Steph.Villans@Gmail.com".



