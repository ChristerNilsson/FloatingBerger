export echo = console.log
export range = _.range

export global = {
	settings : {TITLE:'Titel saknas', GAMES:1, ROUNDS:0, SORT:1, ONE:1, BALANCE:1, DECIMALS:3, A:30, B:30, C:30} # ONE = 1 # 0=dev 1=prod

	players : []
	player : null

	results : [] # ronder x bord. cell: 'x', '0', '1' eller '2'
	rounds  : [] # ronder x bord. cell: [w,b] 
	longs   : [] # players x ronder. cell: [w,b,col,res]

	currScreen : 'a'
	currRound : 0
	currTable : 0

	sortKey : '#'

	frirond : null # ingen frirond. Annars index för frironden

	berger : null
	floating : null
	#translator : null
}