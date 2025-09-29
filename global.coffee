export echo = console.log
export range = _.range

export global =

	players : []
	player : null

	results : [] # ronder x bord. cell: 'x', '0', '1' eller '2'
	rounds  : [] # ronder x bord. cell: [w,b] 
	longs   : [] # players x ronder. cell: [w,b,col,res]

	currScreen : 0 # a
	currRound : 0
	currTable : 0

	sortKey : '#'

	frirond : null # ingen frirond. Annars index för frironden

	berger : null
	floating : null

export settings =
	TITLE : 'Titel saknas'
	GAMES : 1 # antal partier per rond
	ROUNDS : 0 # antal ronder
	SORT : 1 # om spelarna initialt ska sorteras på elo
	ONE : 1 # ONE = 1 # 0=dev 1=prod 
	BALANCE : 1 # färgbalans
	DECIMALS : 0 # Antal decimaler i PR
	A : 29 # antal spelare i en A-grupp
	B : 30 # antal bord i en B-grupp
	C : 30 # antal namn i en C=grupp
