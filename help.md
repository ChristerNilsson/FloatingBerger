## Floating Berger

The name *Floating Berger* comes from the fact that most players feel like they are in the middle of a Berger group.  
Most participants end up with around 50% winning results.  

If you divide a tournament into several physical Berger groups, fewer participants will experience this feeling.

The program handles both FairPair and Berger.

* FairPair: like Swiss, although the players face players with similar rating instead of points
* Berger: everyone meets everyone

All rounds are paired before the tournament starts, just like Berger.

The format is controlled using ROUNDS, see below.

### Pages

```
A Standings:  id • name • elo • rounds • points • performance rating
B Tables: table • white • elo • elo • black • result
C Names:  name • table • colour
```

### Keys for A, B and C

Press a key or click a button.

```
   ?      : Help
 A B C    : Page A, B or C
  ← →     : Round - • +
  I K     : Columns - • +
 ctrl p   : Print
ctrl - +  : Zoom - • +
```

### Keys for A Standings

```
# N E P R : sort on Id • Name • Elo • Points • performance Rating
   J L    : decimals for performance rating - • +
```

### Keys for B Tables

```
  ↑ ↓     : Table - • +
  0 1     : White 0 • 1
 Space    : ½
  Del     : Delete
```

### Parameters

```
TITLE = Name of tournament
ROUNDS = Number of rounds (n = number of players)
  • n is odd  => n     gives Berger otherwise FairPair
  • n is even => n - 1 gives Berger otherwise FairPair
P = Number of players (default all)

GAMES = Number of games per round
	• 1 => single round (default)
	• 2 => double round

SORT = Sort the players using elo rating
	• 0 => no sort
	• 1 => sort (default)

BALANCE = colour balance
	• 0 => no balance
	• 1 => balance (default)

A = Number of Columns for A (default 1)
B = Number of Columns for B (default 1)
C = Number of Columns for C (default 1)

1653 Christer Nilsson: elo + name. Use 1400 if elo is missing
```

**Number of Columns** is used together with **Zoom**, optimizing screen and printer layout.  

### Backup

Copy the url and save it in a secure place, e.g. a USB stick or mail.  
The url is also available in the **history** of your browser.

### Limitations

The program is best experienced on computers **with a keyboard**. (PC, Mac, Linux)  
But, phones and pads can be also be used.

### Swiss vs FairPair (matrix)

Tyresö Open 2024 (81 players, 8 rounds)  

* The players are aligned horizontally and vertically
* Elo sorted, the strongest player is in the upper, left, corner
* The cells contains the round numbers, 1 to 8
* The main diagonal is not used, as a player can't meet himself
* Links

  * [Swiss](https://member.schack.se/ShowTournamentServlet?id=13664&listingtype=2)
  * [FairPair](https://christernilsson.github.io/FloatingBerger/?TITLE=Tyres%C3%B6+Open+2024&GAMES=1&ROUNDS=8&SORT=1&ONE=1&BALANCE=1&A=29&B=30&C=30&p=2416+Hampus+S%C3%B6rensen&p=2413+Michael+Wiedenkeller&p=2366+Joar+%C3%96lund&p=2335+Joar+%C3%96stlund&p=2272+Vidar+Grahn&p=2235+Leo+Crevatin&p=2213+D+Vesterbaek+Pedersen&p=2141+Victor+Muntean&p=2113+Filip+Bj%C3%B6rkman&p=2109+Vidar+Seiger&p=2108+Pratyush+Tripathi&p=2093+Erik+Dingertz&p=2076+Michael+Duke&p=2065+Matija+Sakic&p=2048+Michael+Mattsson&p=2046+Lukas+Willstedt&p=2039+Lavinia+Valcu&p=2035+Oliver+Nilsson&p=2031+Lennart+Evertsson&p=2022+Jussi+Jakenberg&p=2001+Aryan+Banerjee&p=1985+Tim+Nordenfur&p=1977+Elias+Kingsley&p=1954+Per+Isaksson&p=1944+C+Rose+Mariano&p=1936+Lo+Ljungros&p=1923+Herman+Enholm&p=1907+Carina+Wickstr%C3%B6m&p=1897+Joel+%C3%85hfeldt&p=1896+Stefan+Nyberg&p=1893+Hans+R%C3%A5nby&p=1889+Mikael+Blom&p=1886+Joar+Berglund&p=1885+Mikael+Helin&p=1880+Olle+%C3%85lgars&p=1878+Jesper+Borin&p=1871+K+Sergelenbaatar&p=1852+Roy+Karlsson&p=1848+Fredrik+M%C3%B6llerstr%C3%B6m&p=1846+Kenneth+Fahlberg&p=1835+Peder+Gedda&p=1833+Karam+Masoudi&p=1828+Christer+Johansson&p=1827+Anders+Kallin&p=1818+Morris+Bergqvist&p=1803+Martti+Hamina&p=1800+Bj%C3%B6rn+L%C3%B6fstr%C3%B6m&p=1796+N+Bychkov+Zwahlen&p=1794+Jonas+Sandberg&p=1793+Rohan+Gore&p=1787+Kjell+Jernselius&p=1783+Radu+Cernea&p=1778+Mukhtar+Jamshedi&p=1768+Neo+Malmquist&p=1763+Joacim+Hultin&p=1761+Lars-%C3%85ke+Pettersson&p=1748+Andr%C3%A9+J+Lindebaum&p=1733+Lars+Eriksson&p=1733+Hugo+Hardwick&p=1728+Hugo+Sundell&p=1726+Simon+Johansson&p=1721+Jouni+Kaunonen&p=1709+Eddie+Parteg&p=1695+Sid+Van+Den+Brink&p=1691+Svante+N%C3%B6dtveidt&p=1688+Anders+Hillbur&p=1680+Sayak+Raj+Bardhan&p=1671+Salar+Banavi&p=1650+Patrik+Wiss&p=1641+Anton+Nordenfur&p=1624+Jens+Ahlstr%C3%B6m&p=1622+Hanns+Ivar+Uniyal&p=1579+Christer+Carmegren&p=1575+Christer+Nilsson&p=1524+M%C3%A5ns+N%C3%B6dtveidt&p=1480+Karl-Oskar+Rehnberg&p=1417+David+Broman&p=1406+Vida+Radon&p=1400+M+de+Lafonteyne&p=1400+Ivar+Arnshav&p=1400+Kristoffer+Schultz&p=0000+BYE)
  * [Swiss Matrix](X_Schweizer_78.png)  
  * [FairPair Matrix](X_FairPair_78.png)  
