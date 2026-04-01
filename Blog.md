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

### Estensioni POSTGRESQL

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

## 01-04-2026 Continuiamo il DB SCHEMA

Ieri abbiamo direi finito la tabella per gli utenti, per ora di quella mi sento relativamente contento per quella, quindi intanto continuiamo con le altre, tanto sicuramente andrà completata viste le relazioni con le altre tabelle.

### TABELLA MOVIMENTO

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

### TABELLA MOVIMENTO-TAG

| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-movimento  	| serial      	| 	|  SI  	|
| id-tag       	| serial 	|    	|   SI 	|

Nella quale la PK è creata dalla combinazione dei due ID, quindi PK è (id-movimento, id-tag).

Quindi i dati che ci interessa avere poi nella tabella di Movimenti è questo (senza id-tag)

| Nome Campo 	| Tipo        	| PK 	| FK 	|
|------------	|-------------	|----	|----	|
| id-movimento  	| serial      	| SI 	|    	|
| id-conto       	| serial 	|    	|    SI	|
| importo       	| decimal (2 posizioni di precisione) 	|    	|   	|
| descrizione       	| text 	|    	|    	|
| id-categoria       	| serial 	|    	|    SI	|
| tipo-movimento       	| ENUM(ingresso/uscita) 	|    	|    SI	|

## 01-04-2026 CORREGGIAMO MARMEID

Visto il cambiamento affrontato nel db schema, aggiorniamo lo schema marmeid:


``` mermaid
flowchart TD
    A[Utente] -->|1;N| B(Movimento)
    A[Utente] -->|1;N| C(Conto)
    B --> |1;1| D(Categoria)
    C --> |1;N| B
    F(Movimento-Tag) --> |1;N| B
    E(Tag) --> |1;N| F
    E --> |1;N| D
```