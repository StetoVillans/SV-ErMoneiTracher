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

Intanto scrivo i primi campi standard che mi vengono immediatamente in mente senza neanche pensarci:


| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-utente  	| serial      	| Si 	|    	|
| Nome       	| varchar(30) 	|    	|    	|
| Cognome    	| varchar(30) 	|    	|    	|


Stavo scrivendo le proprietà che mi interessano della tabella e per trovare il giusto tipo da dare al campo email ho trovato questo thread di stack overflow molto utile:

https://stackoverflow.com/questions/62113787/what-should-be-the-data-type-of-field-email-in-postgresql-database-in-pgadmin

Dove si parla di questo campo CITEXT dove ignora il maiuscolo e minuscolo quando fa una comparazione di valori, e nel caso delle mail che è molto importante che non si duplichino è giusto che non permetta due ingressi di questo tipo: steph.villans@gmail.com e Steph.Villans@gmail.com

Dice anche che questo type fa parte di un estensione di nome citext, dovrei approfondire cosa sono le estensioni in postgres.

<details>
<summary><strong> Estensioni POSTGRESQL </strong></summary>

Estensioni POSTGRESQL

Beh ci ho guardato e le estensioni sono proprio quello che si può immaginare, componenti aggiuntivi per postgresql che ne permettono l'ampliazione delle funzionalità.

Giusto per esser completi, l'estensione citext che interessa a me in sostanza, trasforma tutte le stringhe con questo tipo in minuscolo nel momento in cui si devono confrontare con altri valori.

Da tenere a mente che comunque memorizza nel db il valore AS-IS, nel senso che se io mi registro scrivendo:
    Steph.Villans@Gmail.com
Quando fa i confronti li farà con il valore "steph.villans@gmail.com" ma il valore registrato sul db sarà sempre "Steph.Villans@Gmail.com".

</details>

***


| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-utente  	| serial      	| Si 	|    	|
| Nome       	| varchar(30) 	|    	|    	|
| Cognome    	| varchar(30) 	|    	|    	|
| Email      	| citext      	|    	|    	|

Per il ruolo dell'utente andiamo ad usare ENUM.

ENUM vuol dire che il tipo di dato lo andrò a creare io, in questo caso sarà così:

CREATE TYPE ruolo-utente AS ENUM ('standard', 'pro', 'admin');


| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-utente  	| serial      	| Si 	|    	|
| Nome       	| varchar(30) 	|    	|    	|
| Cognome    	| varchar(30) 	|    	|    	|
| Email      	| citext      	|    	|    	|
| ruolo-utente      	| ENUM(ruolo-utente)     	|    	|    	|

Poi abbiamo sicuramente:
- data-creazione, probabilmente il data-type è il date, però ho trovato che c'è anche timestamp, quindi voglio vedere cosa è più adatto, PS. si il giusto è TIMESTAMP, e si aggiunge valore di DEFAULT NOW()
- stato, enum attivo/disattivo

Questione password, direi che ci facciamo un campo dedicato in cui viene salvata la password hashata con un algoritmo non reversibile.

Mi sono informato adesso nel cryptare le password, ho letto un paio di articoli interessanti:
- https://blog.codinghorror.com/youre-probably-storing-passwords-incorrectly/
- https://web.archive.org/web/20070915191117/http://www.matasano.com/log/958/enough-with-the-rainbow-tables-what-you-need-to-know-about-secure-password-schemes/

(Bellini comunque!)

E quanto ho potuto apprendere è:
- non inventarmi nulla
- Usa quello che gente molto più intelligente di te ha già fatto

Quindi usiamo bcrypt, ma come lo implemento nel mio db? GOOGLE!

E qui ho trovato una domanda stack overflow che fa proprio al caso mio:
https://stackoverflow.com/questions/2647158/how-can-i-hash-passwords-in-postgresql

### Implementare bcrypt nel db, CA' DEVO FA'?

Allora stavo leggendo la domanda di stack overflow ma ho notato una cosa, in quella domanda mandano la password in chiaro al db e il db la salva dopo averla criptata, però non mi fa impazzire come cosa.

Perchè questo vorrebbe dire che la password deve fare 2 salti non in chiaro, da frontend a backend, e da backend a database.

Quindi, visto che il mio backend vuole essere node.js guardo se è possibile cryptare con bcrypt nel backend.
N.B. per questo tiro una bella sgippata, facendo cross reference sgooglando.

In node.js esiste un pacchetto dedicato ad utilizzare bcrypt.
npm install bcrypt

Fa l'esempio di usare questi dati:```
```js
const bcrypt = require('bcrypt');

const plainPassword = req.body.password;
const saltRounds = 12;

const passwordHash = await bcrypt.hash(plainPassword, saltRounds);

// salva passwordHash nel db
```
Per un'ipotetico Login

e per il register:
```js
const bcrypt = require('bcrypt');

// password inserita dall'utente
const plainPassword = req.body.password;

// hash preso dal db
const passwordHashFromDb = user.password_hash;

const isValid = await bcrypt.compare(plainPassword, passwordHashFromDb);

if (!isValid) {
return res.status(401).json({ error: 'Credenziali non valide' });
}
```

In sostanza i metodi principali sono .hash e .compare.

Quindi, nel consisto che è il salting che usa bcrypt? visto che lo si usa per l'hashing devo sapere che cazzo vor dì.

Una spiegazione buona si trova in questa Question:
https://stackoverflow.com/questions/25586073/bcrypt-what-is-meant-salt-and-cost

La sostanza è: Evitare raimbow table attack.

Gli attacchi rainbow table sono attacchi che salvano un tot di password hashate e poi le vanno a provare nei sistemi.
Se noi salvassimo le password hashandole solo queste sarebbero vulnerabili a questo tipo di attacco, poichè se qualcuno ha una password come "prova123" questa sarebbe facile da hashare e provare.

AD ESEMPIO: 
password non hashata = prova123 
password hashata = e32ae4e0d9158c00684ec73ce7803ab1

Se qualcun'altro hashasse la password prova123, riuscirebbe a ricavare lo stesso hash, ed entrare.

Il salting cerca di prevenire questo, una volta che viene salvata una password si aggiunge il salt, ovvero una stringa di caratteri alfanumerici casuale che permette di salvare la password in maniera molto più sicura

AD ESEMPIO: 
password non hashata = prova123 
SALT = "d15sa1ca515d" 
password hashata (salt + psw) = 0c435e1ba4ad9ab1994b29f7ebcb2356

Sono hash completamente diversi, ma una raimbow table non avrà mai al suo interno un hash di "d15sa1ca515dprova123".

La password di esempio rimane debole, ma bcrypt aggiunge in questo modo un layer di sicurezza.

***



Quindi nella tabella, la password la salviamo così:

| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-utente  	| serial      	| Si 	|    	|
| Nome       	| varchar(30) 	|    	|    	|
| Cognome    	| varchar(30) 	|    	|    	|
| Email      	| citext      	|    	|    	|
| ruolo-utente      	| ENUM(ruolo-utente)     	|    	|    	|
| data-creazione      	| TIMESTAMP DEFAULT NOW()     	|    	|    	|
| stato-utente   	| ENUM(stato-utente)     	|    	|    	|
| psw-hash     	| VARCHAR(255)     	|    	|    	|


con lo stato:
CREATE TYPE stato-utente AS ENUM ('attivo', 'disattivo');

# 01-04-2026

## Continuiamo il DB SCHEMA

Ieri abbiamo direi finito la tabella per gli utenti, per ora di quella mi sento relativamente contento per quella, quindi intanto continuiamo con le altre, tanto sicuramente andrà completata viste le relazioni con le altre tabelle.

## TABELLA MOVIMENTO

L'obbiettivo di questa tabella è quello di salvare ogni singolo movimento monetario che viene eseguito, quindi:
- Uscita
- Ingressi
- Trasferimenti

Direi che questi sono i 3 casi principali, che in realtà tratterei come 2 tipi, nel senso che un trasferimento è solo un uscita da un conto ed un ingresso su un'altro.

Un movimento quindi ha sicuramente:
- id-movimento, PK per gestire il fatto che siano univochi
- id-contoid-conto, FK, indica su che conto è stato effettuato un movimento
- importo, a quanto ammonta il movimento
- descrizione, una descrizione sul movimento
- id-categoria, FK indica a quale categoria appartiene il movimento
- tipo-movimento, ENUM ingresso/uscita per determinare che tipo di movimento è stato fatto.
- id-tag, FK

Il problema qui è l'id-tag, poichè per la mia interpretazione ogni movimento può avere più tag assegnati, ma come salvo per ogni record in movimenti pià id-tag?

Qui si sgoogla.

Ok, avevo un ricordo da scuola e immaginavo fosse così ma volevo esserne sicuro.

Essendo che nel nostro schema, un movimento può avere più tag e un tag può avere più movimenti, quindi la relazione tra le due tabelle è N:N (Molti a Molti), si può creare una tabella ponte con solo i campi che ci interessano.

## TABELLA MOVIMENTO-TAG

| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-movimento  	| serial      	| 	|  SI  	|
| id-tag       	| serial 	|    	|   SI 	|

Nella quale la PK è creata dalla combinazione dei due ID, quindi PK è (id-movimento, id-tag).

## TABELLA MOVIMENTO

Quindi i dati che ci interessa avere poi nella tabella di Movimenti è questo (senza id-tag)

| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-movimento  	| serial      	| SI 	|    	|
| id-conto       	| serial 	|    	|    SI	|
| importo       	| decimal (2 posizioni di precisione) 	|    	|   	|
| descrizione       	| text 	|    	|    	|
| id-categoria       	| serial 	|    	|    SI	|
| tipo-movimento       	| ENUM(ingresso/uscita) 	|    	|    SI	|

PS. Aggiungo anche l'id dell'utente che fa il movimento, perchè è vero che il conto è legato all'utente, ma potenzialmente può rendere i dati più consistenti e completi segnare anche chi è l'utente che ha fatto il movimento

| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-movimento  	| serial      	| SI 	|    	|
| id-conto       	| serial 	|    	|    SI	|
| importo       	| decimal (2 posizioni di precisione) 	|    	|   	|
| descrizione       	| text 	|    	|    	|
| id-categoria       	| serial 	|    	|    SI	|
| tipo-movimento       	| ENUM(ingresso/uscita) 	|    	|    	|
| id-utente       	| serial 	|    	|    SI	|


## CORREGGIAMO mermeid

Visto il cambiamento affrontato nel db schema, aggiorniamo lo schema mermeid:


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

## TABELLA TAG

Per quanto riguarda la tabella tag, dobbiamo salvare relativamente poco:

| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-tag  	| serial      	| SI 	|    	|
| nome | varchar(255) | | |
| id-categoria | serial | | SI |

STOP!

Ho messo in pausa la scrittura della tabella perchè ho sbagliato tutto finora, ho usato per mermail il diagramma di flusso, dovevo usare il componente mermaid erDiagram, che mi permette di gestire le relazioni tra tabelle, mettendo anche gli attributi.

La documentazione basa di questa cosa è la seguente:

Basic Elements

    Entities: entity EntityName
    Attributes: Listed within entities
    Relationships: Various types of connections between entities
    Cardinality: |o--o|, }o--o{, etc.

Relationship Types

    One-to-One: ||--||
    One-to-Many: ||--o{
    Many-to-One: }o--||
    Many-to-Many: }o--o{

Comunque per altre info:
https://docs.mermaidviewer.com/diagrams/er.html

Per lo schema del mio db:
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
        serial utente_id
        string nome
        da finire
    }

    MOVIMENTO {
        serial id-movimento
        serial utente_id
        serial conto_id
        serial categoria_id
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

Ok quindi, aggiustato questo, possiamo continuare a modellare il db, mancano queste tabelle:
- conto
- categoria

## TABELLA CONTO

Allora la tabella con le prime cose che mi vengono in mente è così:

| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-conto  	| serial      	| SI 	|    	|
| id-user       	| serial 	|    	|    SI	|
| nome       	| varchar(255) 	|    	|   	|
| saldo-iniziale   	| decimal (2 posizioni di precisione) |  |  |
| saldo-attuale       	| decimal (2 posizioni di precisione) |  |  |

Per ora mi vengono in mente queste suddivisioni, forse un'altro campo che potrebbe essere utile è:
- tipo di conto, e mettere un enum con tipo banca, contanti, carta di debito, carta di credito, non mi serve particolarmente però potrebbe essere utile, nel senso che potrei magari voler filtrare quante spese ho fatto tra diverse carte di credito e sommarle

Ora che ci penso probabilmente la distinzione tra saldo-iniziale e saldo-attuale non serve, tanto il saldo iniziale si mette solo quando si crea il conto, dopo non si modifica più, quindi se invece che metterlo come campo lo faccio inserire in fase di creazione conto e poi lo metto direttamente in saldo attuale direi che cambia poco.

Quindi direi che per ora la tabella conto è la seguente:

| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-conto  	| serial      	| SI 	|    	|
| id-user       	| serial 	|    	|    SI	|
| nome       	| varchar(255) 	|    	|   	|
| tipo   	| ENUM(carte,banca,contanti) |  |  |
| saldo-attuale       	| decimal (2 posizioni di precisione) |  |  |

Vado a modificare lo schema db nel readme...

Fatto.

## TABELLA CATEGORIA

Allora come prima, la butto giù su due piedi, poi la ragiono meglio:


| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-categoria  	| serial      	| SI 	|    	|
| id-movimento       	| serial 	|    	|    SI	|
| nome       	| varchar(255) 	|    	|   	|

Al momento mi vengono solo queste cose sinceramente, perchè l'obbiettivo delle categorie è semplicemente dividere le spese, per evitare di fare un grosso enum invece di usare una tabella.

Perchè l'alternativa era quella di creare un grosso enum per tutte le categorie possibili nella tabella movimento, ma se voglio aggiungere una categoria mi sembra poco lineare come ragionamento.

Una cosa che potrebbe aver senso potrebbe essere dare una proprietà alle categorie che rende le spese in quella categorie non contante nelle statistiche (?) non so se potrebbe aver senso.

A pensarci nel privato non mi viene in mente una situazione nella quale vorrei che una spesa che faccio non mi venga segnata, anche perchè rimuoverebbe la logica di segnare le spese in sè per sè, c'è creerebbe delle discrepanze nelle spese e quanto segnato e renderebbe la cosa controintuitiva.

Ah cazzo non ci avevo pensato, il tipo di movimento, ovvero la categoria, è una categoria che si applica solo alle entrate o solo alle spese? o tutte e due.

Ad esempio stipendio, è sicuramente un'entrata, quindi si può fare la separazione tra queste categorie, così che quando si fa per aggiungere una categoria al movimento, appaiano solo le categorie relative ad uscite o entrate.

Quindi direi la tabella definitiva (per ora) è:

| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-categoria  	| serial      	| SI 	|    	|
| id-movimento       	| serial 	|    	|    SI	|
| nome       	| varchar(255) 	|    	|   	|
| tipo       	| ENUM(ingresso,uscita) 	|    	|   	|

Aggiornato anche in readME.md

# 02-04-2026

Allora il db schema lo abbiamo fatto, penso che a livello di ordine di cose da fare nel progetto mi convenga fare prima tutto il db, poi buona parte del backend, poi il frontend.

Questo perchè avendo un db completamente funzionante abbiamo tutti i dati per un'applicazione, una volta che ho il db completo vuol dire che posso fare il backend per usare i dati nel db, e una volta fatto questo il frontend per creare l'app effettiva.

Però sì direi che continuiamo con il db.

## DB IN DOCKER

Quindi, in generale nel progetto, lo scopo è quello di containerizzare tutto, quindi intanto cerchiamo l'immagine docker per postgresql.

Basta andare su docker hub e la troviamo facilmente:
https://hub.docker.com/_/postgres

Visto che noi dobbiamo usare un db normalissimo senza troppe pretese non ci dovrebbe servire creare un dockerfile dedicato, non abbiam bisogno di immagini particolari.

Dalla pagina possiamo vedere un esempio di docker compose e di tutte le variabili d'ambiente di cui può avere bisogno.

Noi non abbiamo troppe pretese, abbiamo bisogno di un db funzionante, che non deve venir esposto direttamente su internet, che mantega i dati in maniera persistente (quindi sicuramente faremo dei volumi) e possibilmente una soluzione per backuppare i dati.

Allora, postgres si potrebbe in realtà eseguire anche solo con:

```bash
docker pull postgres

docker run --name devdb -e POSTGRES_PASSWORD=mysecretpassword -p 5432:5432 -d postgres
```

Con il primo comando eseguirà il pull e con il seconddo eseguiamo il container di base, ovviamente questo sarà un semplice db in esecuzione, quindi senza schermata di amministrazione nè nulla.

Se installassimo un db manager come pgAdmin potremmo connetterci al db in localhost 5432 e potremmo lavorare sul database.

## DOCKER COMPOSE

Andiamo quindi a scegliere un docker compose per il nostro db, ho trovato questo:

```yml
version: '3.8'
services:
  db:
    image: postgres:14.1-alpine
    restart: always
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    ports:
      - '5432:5432'
    volumes: 
      - db:/var/lib/postgresql/data
volumes:
  db:
    driver: local
```

Da questo sicuramente togliamo il tag version visto che è deprecato, poi vado su docker hub a vedere qual'è l'ultima stable di postgres e usiamo quella:

```yml
services:
  db:
    image: postgres:16-alpine
    restart: always
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    ports:
      - '5432:5432'
    volumes: 
      - db:/var/lib/postgresql/data
volumes:
  db:
    driver: local
```

Per quanto riguarda la politica di restart ci va bene che si riaccenda ogni volta, per le variabili d'ambiente la facciamo pescare da file .env, se non ti ricordi come i docker compose leggono le variabili d'ambiente:

https://docs.docker.com/compose/how-tos/environment-variables/set-environment-variables/

Articolo di documentazione che spiega bene come usarle, nel nostro caso le dichiariamo semplicemente con: 

`${variabile}`

Tanto il docker compose cercherà il file .env nella directory del progetto.

Visto che nel nostro caso abbiamo un solo .env e un solo docker compose, infatti per ora abbiamo solo il db, ma dopo metteremo insieme anche backend e frontend nel docker compose.

Quindi il nostro docker compose attuale è il seguente:

```yml
services:
  db:
    image: postgres:18
    restart: always
    environment:
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    ports:
      - '5432:5432'
    volumes: 
      - db:/var/lib/postgresql/data

volumes:
  db:
    driver: local
```

Controlliamo ora sulla documentazione se ci sono altre variabili d'ambiente di cui abbiamo bisogno:

- POSTGRES_DB, nome del db di default

Dalla documentazione mi sembra di trovare solo questa che mi può servire per ora, quindi ormai che ci sono parliamo anche delle porte del db.

Docker compose definisce 2 porte, quella aperta verso l'host e quella usata internamente.

Nel nostro caso, internamente ci va bene che usi la 5432 non ci interessa, sull'host non la esponiamo per 2 motivi:
- Non ci interessa esporla sull'host, aggiunge un punto di accesso non voluto
- Docker compose definisce 2 porte, quella aperta verso l'host e quella usata internamente.

Nel nostro caso, internamente ci va bene che usi la 5432 non ci interessa, sull'host non la esponiamo per 2 motivi:
- Non ci interessa esporla sull'host, aggiunge un punto di accesso non voluto
- I container Docker comunicano tra loro tramite la rete interna, quindi il database sarà comunque raggiungibile dagli altri servizi (es. backend) usando il nome del servizio come hostname (es. db:5432)

È importante notare che più container possono usare la stessa porta interna senza alcun problema, poiché sono isolati a livello di rete.

I conflitti si verificano solo quando si tenta di esporre la stessa porta sull’host.








