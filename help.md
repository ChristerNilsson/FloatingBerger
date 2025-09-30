## Floating Berger

Namnet *Floating Berger* kommer av att de flesta spelare upplever att de befinner sig mitt i en Berger-grupp.  
De flesta deltagare hamnar kring 50% vinstresultat.  

Delar man in en turnering i flera fysiska Berger-grupper, kommer färre deltagare att uppleva denna känsla.  

Programmet hanterar både Floating och Berger:

* Floating: som Schweizer, fast spelarna möter spelare med samma rating istf poäng
* Berger: alla möter alla

Alla ronder lottas innan turneringen startar, precis som i Berger.

Formatet styrs mha ROUNDS, se nedan.

### Sidor

```
A Ställning:  id • namn • elo • ronder • poäng • performance rating
B Bordslista: bordsnummer • vit • elo • elo • svart • resultat
C Namnlista:  namn • bordsnummer • färg
```

### Tangenter för A, B och C

```
   ?      : Hjälp
  w s     : Sida - • +
  ← →     : Rond - • +
  i k     : Gruppstorlek - • +
 ctrl p   : Utskrift
ctrl - +  : Zoom - • +
```

### Tangenter för A Ställning

```
# n e p r : Sortera på Id • Namn • Elo • Poäng • performance Rating
  a d     : decimaler för PR - • +
```

### Tangenter för B Bordslista

```
  ↑ ↓     : Bord - • +
  0 1     : Vit 0 • 1
 Space    : ½
  Del     : Radera
```

### Parametrar

```
TITLE = turneringens namn
ROUNDS = antal ronder

GAMES = antal partier per rond
	• 1 => enkelrond (default)
	• 2 => dubbelrond 

SORT = spelarna sorteras på elo
	• 0 => utan sortering 
	• 1 => med sortering (default)

BALANCE = färgbalans
	• 0 => utan färgbalans
	• 1 => med färgbalans (default)

A = Gruppstorlek (default 30)
B = Gruppstorlek (default 30)
C = Gruppstorlek (default 30)

1653 Christer Nilsson: elo + namn. Ange 1400 om elo saknas
```

**Gruppstorlek** anger hur många rader en grupp innehåller.  
Används tillsammans med **Zoom** när man vill optimera skärm och printer.  

### Backup

Kopiera urlen och spara på säker plats. T ex en USB-sticka eller mail.  
Urlen finns även i webläsarens historik, om ingen rensat.  

### Begränsningar

Programmet är avsett för datorer **med tangentbord**. (PC, Mac, Linux)  
Resultat kan även visas på mobil och platta.  