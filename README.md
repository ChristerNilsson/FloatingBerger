# Floating Berger

[Try it!](https://christernilsson.github.io/FloatingBerger/)

Byt ut elos och namn mot de som ska gälla i din turnering

```
TITLE = Sommarturnering RIO 2025
GAMES = 1
ROUNDS = 4
SORT = 0
BALANCE = 1

1698 Onni Aikio
1558 Helge Bergström
1549 Jonas Hök
1679 Lars Johansson
1400 Per Eriksson

1653 Christer Nilsson
1673 Per Hamnström
1504 Thomas Paulin
1706 Abbas Razavi
1650 Jouko Liistamo

1677 Cesar

```

Vid dubbelrond sätts GAMES = 2  

Skriv in VITS resultat i textrutan i den ordning Bordslistan anger  

Förklaring
```
r1 = rond 1

0 = vit förlust
1 = remi
2 = vit vinst
x = partiet ej spelat
```

# Handhavande

* Rondnummerna är klickbara. Då visas Bordslistan för klickad rond
* Övriga kolumner sorteras när man klickar på dem

* a togglar Spelarlistan
* b togglar Bordslistan
* c togglar Namnlistan

* ctrl p skriver ut sidan
* ctrl + zoomar in
* ctrl - zoomar ut

# Skillnader gentemot andra turneringssystem

* Ratingen styr vilka som möts. Skillnaden minimeras
* Man behöver ytterst sällan använda särskiljning
* Man lottar alla ronder direkt
* Man kan spela partierna i valfri ordning
* Turneringen behöver ej delas upp i flera Berger-grupper
* Alla spelare vet i vilken rond de ska möta varandra. Som Berger
* Enkel hantering av lottning, även dubbelrondigt
* Eftersom turneringens data finns i url:en, dvs länken, kan den enkelt publiceras

# Att tänka på

* När turneringen börjat får man bara modifiera resultaten. Dvs r1 = osv
* Man får EJ ändra elo, namn, SORT, ROUND eller GAMES under turneringens gång
	* Detta pga att lottningen kan påverkas
* Skriv alltid ut Bordslistorna!
	* De fungerar som backup

# Utveckling

ONE används för att visa noll- eller ett-baserade värden.  
