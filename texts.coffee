export helpText = """<h3>Floating Berger version 1.2</h3>Namnet Floating Berger kommer av att de flesta spelare upplever att de är i mitten av sin egen lilla virtuella Berger-grupp. De flesta hamnar kring 50% vinstresultat.

Delar man in en turnering i flera fysiska Berger-grupper, kommer färre deltagare att uppleva denna känsla.

Programmet hanterar både Floating och Berger:

* Floating: som Schweizer, fast spelarna möter spelare med samma rating istf poäng
* Berger: alla möter alla

Alla ronder lottas innan turneringen startar, precis som i Berger.

Formatet styrs mha ROUNDS, se nedan.
<h3>Handhavande</h3>A   B   C   (Ställning, Bord och Namn)

a   a   a   : Visa Ställning
b   b   b   : Visa Bordslista
c   c   c   : Visa Namnlista

←   ←   ←   : Rond - 1
→   →   →   : Rond + 1

    ↑       : Bord - 1
    ↓       : Bord + 1

#           : Sortera på # (spelarens nummer)
n           : Sortera på Namn
e           : Sortera på Elo
p           : Sortera på P  (poäng)
r           : Sortera på PR (performance rating)

m           : + decimaler för PR (more)
l           : - decimaler för PR (less)

    0       : Vit förlust
  Space     : Remi
    1       : Vit vinst
   Del      : Tag bort

ctrl p • skriver ut
ctrl + • zoomar in
ctrl - • zoomar ut
<h3>Parametrar</h3>TITLE   = turneringens namn
ROUNDS  = antal ronder
GAMES   = antal partier per rond • 1=enkelrond • 2=dubbelrond 
SORT    = spelarnas sorteras på elo • 0=utan sortering • 1=med sortering
BALANCE = färgbalans • 0=utan färgbalans • 1=med färgbalans

1653 Christer Nilsson: elo + namn. Ange 1400 om elo saknas
<h3>Backup</h3>Kopiera urlen och spara på säker plats. T ex på en USB-sticka.
Urlen finns även i webläsarens historik, om ingen rensat.

"""
