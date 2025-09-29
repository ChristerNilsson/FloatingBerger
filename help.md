## Floating Berger version 1.2

Namnet Floating Berger kommer av att de flesta spelare upplever att de befinner sig i mitten av sin egen lilla virtuella Berger-grupp. De flesta hamnar kring 50% vinstresultat.

Delar man in en turnering i flera fysiska Berger-grupper, kommer färre deltagare att uppleva denna känsla.

Programmet hanterar både Floating och Berger:

* Floating: som Schweizer, fast spelarna möter spelare med samma rating istf poäng
* Berger: alla möter alla

Alla ronder lottas innan turneringen startar, precis som i Berger.

Formatet styrs mha ROUNDS, se nedan.

### Tangenter för sidorna A, B och C

```
?       : Hjälp
w       : Sida +
s       : Sida -

←       : Rond -
→       : Rond +

↑       : Bord -
↓       : Bord +

shift ↑ : Gruppstorlek -
shift ↓ : Gruppstorlek +

ctrl p  : Utskrift
ctrl -  : Zoom -
ctrl +  : Zoom +
```

### Tangenter för sida A Ställning
```
#       : Sortera på # (spelarens nummer)
n       : Sortera på Namn
e       : Sortera på Elo
p       : Sortera på P  (poäng)
r       : Sortera på PR (performance rating)

shift ← : decimaler för PR -
shift → : decimaler för PR +
```
### Tangenter för sida B Bordslista
```
0       : Vit förlust
Space   : Remi
1       : Vit vinst
Del     : Tag bort resultat
```
### Parametrar
```
TITLE = turneringens namn
ROUNDS = antal ronder

GAMES = antal partier per rond
	• 1 => enkelrond 
	• 2 => dubbelrond 

SORT = spelarna sorteras på elo
	• 0 => utan sortering 
	• 1 => med sortering

BALANCE = färgbalans
	• 0 => utan färgbalans
	• 1 => med färgbalans

A = Gruppstorlek för Players
B = Gruppstorlek för Tables
C = Gruppstorlek för Names

1653 Christer Nilsson: elo + namn. Ange 1400 om elo saknas
```

Med Gruppstorlek menas hur många rader en grupp ska innehålla.  
Används när man vill utnyttja skärm och printer optimalt.  

### Backup

Kopiera urlen och spara på säker plats. T ex på en USB-sticka.  
Urlen finns även i webläsarens historik, om ingen rensat.  

