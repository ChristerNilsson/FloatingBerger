## Floating Berger

The name *Floating Berger* comes from the fact that most players feel like they are in the middle of a Berger group.  
Most participants end up with around 50% winning results.  

If you divide a tournament into several physical Berger groups, fewer participants will experience this feeling.

The program handles both Floating and Berger.

* Floating: like Swiss, although the players face players with the same rating instead of points
* Berger: everyone meets everyone

All rounds are drawn before the tournament starts, just like Berger.

The format is controlled using ROUNDS, see below.


### Pages

```
A Standings:  id • name • elo • rounds • points • performance rating
B Tables: table • white • elo • elo • black • result
C Names:  name • table • colour
```

### Keys for A, B and C

```
   ?      : Help
  w s     : Page - • +
  ← →     : Round - • +
  i k     : Group size - • +
 ctrl p   : Print
ctrl - +  : Zoom - • +
```

### Keys for A Standings

```
# n e p r : sort on Id • Name • Elo • Points • performance Rating
  a d     : decimals for performance rating - • +
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
ROUNDS = Number of rounds

GAMES = Number of games per round
	• 1 => single round (default)
	• 2 => double round

SORT = Sort the players using elo rating
	• 0 => no sort
	• 1 => sort (default)

BALANCE = colour balance
	• 0 => no balance
	• 1 => balance (default)

A = Group size (default 30)
B = Group size (default 30)
C = Group size (default 30)

1653 Christer Nilsson: elo + name. Use 1400 if elo is missing
```

**Group size** states the number of lines in a group.  
Used together with **Zoom**, optimizing screen and printer layout.  

### Backup

Copy the url and save it in a secure place, e.g. a USB stick or mail.  
The url is also available in the **history** of your browser.

### Limitations

The program runs on computers **with a keyboard**. (PC, Mac, Linux)  
The result can also be viewed on phone or pad.  
