# ½ • ↑ ↓ ← →

import {Player} from './player.js'
import {Floating} from './floating.js'
import {helpText} from './texts.js'
import {performance} from './rating.js'

echo = console.log
range = _.range

ALIGN_LEFT   = {style: "text-align:left"}
ALIGN_CENTER = {style: "text-align:center"}
ALIGN_RIGHT  = {style: "text-align:right"}

ALFABET = '123456789012345678901234567890123456789012345678901234567890123456789012345678'
NAMES_PER_COL = 30

KEYS = {}
KEYS.a = "  b c  ← →  # n e p r  m l"
KEYS.b = "a   c  ← →  ↑ ↓  0 Space 1  Del"
KEYS.c = "a b    ← →"

## V A R I A B L E R ##

settings = {TITLE:'Titel saknas', GAMES:1, ROUNDS:0, SORT:1, ONE:1, BALANCE:1, DECIMALS:0} # ONE = 1 # 0=dev 1=prod

# Tillståndet ges av dessa variabler:
players = []

results = [] # ronder x bord. cell: 'x', '0', '1' eller '2'
rounds  = [] # ronder x bord. cell: [w,b] 
longs   = [] # players x ronder. cell: [w,b,col,res]

currScreen = 'a'
currRound = 0
currTable = 0

frirond = null # ingen frirond. Annars index för frironden

berger = null

## F U N K T I O N E R ##

addBord = (bord,res,c0,c1) ->
	vit = players[c0].name
	svart = players[c1].name
	vit_elo = players[c0].elo
	svart_elo = players[c1].elo
	tr1 = document.createElement 'tr'
	color = if bord == currTable then 'yellow' else 'white'

	koppla 'td', tr1, {text : bord + settings.ONE}
	koppla 'td', tr1, {style:"text-align:left", text : vit}
	koppla 'td', tr1, {style:"text-align:left", text : vit_elo}
	koppla 'td', tr1, {style:"text-align:left", text : svart_elo}
	koppla 'td', tr1, {style:"text-align:left", text : svart}
	koppla 'td', tr1, {style:"text-align:center; background-color:#{color}", text : prettyResult res}
	tr1
	
changeRound = (delta) -> # byt rond och uppdatera bordslistan
	currRound = (currRound + delta) %% rounds.length
	currTable = 0
	
	setScreen currScreen
	showTables()
	showNames()

changeTable = (delta) -> # byt bord
	currTable = (currTable + delta) %% tableCount()

convert = (input,a,b) -> # byt alla tecken i input som finns i a mot tecken med samma index i b
	if input in a then b[a.indexOf input] else input # a och b är strängar

convertLong = (input,a,b) -> # byt alla tecken i input som finns i a mot sträng med samma index i b. b är separerad med |
	i = a.indexOf input
	b = b.split '|'
	if input in a then b[i] else input

createSortEvents = -> # Spelarlistan sorteras beroende på vilken kolumn man klickar på. # Namn Elo P eller PR

	ths = document.querySelectorAll '#stallning th'

	index = -1
	for _th in ths
		index++
		do (_th,index) ->
			_th.addEventListener 'click', (event) ->
				key = _th.textContent
				if !isNaN parseInt key
					key = parseInt(key) - settings.ONE
					showTables() # key
					return
				sortColumn index, key in "# Namn".split ' '

export expand = (games, rounds) -> # make a double round from a single round
	result = []
	echo 'rounds',rounds
	for round in rounds
		result.push ([w,b] for [w,b] in round)
		if games == 2 then result.push ([b,w] for [w,b] in round)
	return result

export findNumberOfDecimals = (lst) -> # leta upp minsta antal decimaler som krävs för unikhet i listan
	best = 0
	for i in range 6
		unik = _.uniq (item.toFixed(i) for item in lst)
		if unik.length > best then [best,ibest] = [unik.length,i]
	ibest

invert = (lst) ->
	result = _.clone lst
	for item,i in lst
		result[item] = i
	result

koppla = (typ, parent, attrs = {}) ->
  elem = document.createElement typ

  if 'text' of attrs
    elem.textContent = attrs.text
    delete attrs.text

  if 'html' of attrs
    elem.innerHTML = attrs.html
    delete attrs.html

  for own key of attrs
    elem.setAttribute key, attrs[key]

  parent.appendChild elem
  elem

export longForm = (rounds, results) -> # produces the long form for ONE round (spelarlistan). If there is a BYE, put it last in the list
	result = []
	for i in range rounds.length
		[w,b] = rounds[i]
		res = results[i]
		result.push [w,b,'w',res]
		result.push [b,w,'b',other res]

	result.sort (a,b) -> a[0] - b[0]
	result

makeBerger = -> # lotta en hel berger-turnering.
# 
	n = players.length
	half = n // 2 
	A = [0...n]
	rounds = []
	for i in range settings.ROUNDS
		rounds.push savePairing i, A, half, n
		A.pop()
		A = A.slice(half).concat A.slice(0,half)
		A.push n-1
	rounds

makeFloating = -> # lotta en hel floating-turnering
	floating = new Floating players, settings
	showMatrix floating
	echo 'summa',floating.summa
	echo players
	floating.rounds

makeURL = ->
	url = "./"

	url += "?TITLE=#{settings.TITLE}"
	url += "&GAMES=#{settings.GAMES}"
	url += "&ROUNDS=#{settings.ROUNDS}"
	url += "&SORT=#{settings.SORT}"
	url += "&ONE=#{settings.ONE}"
	url += "&BALANCE=#{settings.BALANCE}"

	for player in players
		url += "&p=#{player}"

	for r in range rounds.length
		s = results[r].join ''
		s = _.trimEnd s, 'x'
		if s != '' then url += "&r#{r+1}=#{s}"

	url = url.replaceAll ' ', '+'
	url

export other = (input) -> convert input, "012x","210x"

parseTextarea = -> # läs in initiala uppgifter om spelarna
	raw = document.getElementById "textarea"

	lines = raw.value
	lines = lines.split "\n"

	rounds = null

	for line in lines 
		if line.length == 0 or line[0] == '#' then continue
		if line.includes '='
			[key, val] = line.split '='
			key = key.trim()
			val = val.trim()
			if key == 'TITLE' then settings.TITLE = val
			if key == 'GAMES' then settings.GAMES = val
			if key == 'ROUNDS' then settings.ROUNDS = val
			if key == 'SORT' then settings.SORT = val
			if key == 'ONE' then settings.ONE = val
			if key == 'BALANCE' then settings.BALANCE = val
		else
			players.push line

	if players.length % 2 == 1
		frirond = players.length
		players.push '0000 BYE'
	else
		frirond = null

	if settings.ROUNDS == 0 then settings.ROUNDS = players.length - 1

	if rounds == null then rounds = []

	url = makeURL()
	players = []
	rounds = []
	window.location.href = url
	echo 'window.location.href = url'

parseURL = -> 
	params = new URLSearchParams window.location.search

	settings.TITLE = safeGet params, "TITLE"
	settings.GAMES = parseInt safeGet params, "GAMES", "1"
	settings.SORT = parseInt safeGet params, "SORT", "1"
	settings.ONE = parseInt safeGet params, "ONE", "1"
	settings.BALANCE = parseInt safeGet params, "BALANCE", "1"

	players = []
	persons = params.getAll "p"

	if window.location.href.includes 'BYE' then frirond = persons.length - 1
	if settings.SORT == 1 then persons.sort().reverse()

	settings.ROUNDS = parseInt safeGet params, "ROUNDS", "#{players.length-1}"

	i = 0
	for person in persons
		i += 1
		elo = parseInt person.slice 0,4
		name = person.slice(4).trim()
		players.push new Player players.length, name, elo

	# initialisera rounds med 'x' i alla celler
	n = players.length // 2
	rounds = []
	for i in range settings.GAMES * settings.ROUNDS
		rounds.push new Array(n).fill 'x'

	readResults params

export prettyResult = (ch) -> # översätt interna resultat till externa
	if ch == 'x' then return "-"
	if ch == '0' then return "0 - 1"
	if ch == '1' then return "½ - ½"
	if ch == '2' then return "1 - 0"

readResults = (params) -> # Resultaten läses från urlen
	results = []
	n = players.length
	if frirond then n -= 2
	n //= 2
	
	for r in range settings.GAMES * settings.ROUNDS
		result = safeGet params, "r#{r+1}", new Array(n).fill "x"
		arr = []
		for ch in result 
			if ch=='0' then arr.push '0'
			if ch=='1' then arr.push '1'
			if ch=='2' then arr.push '2'
			if ch=='x' then arr.push 'x'
		results.push arr

roundsContent = (long, i, _tr) -> # rondernas data + poäng + PR. i anger spelarnummer
	for [w,b,color,result] in long
		opponent = settings.ONE + if w == i then b else w
		result = convert result, 'x201FG', ' 10½11'
		attr = if color == 'w' then "right:0px;" else "left:0px;"
		cell = koppla 'td', _tr, {style: "position:relative;"}
		div1 = koppla 'div', cell, {style: "position:absolute; top:0px;  font-size:0.7em;" + attr, text: opponent}
		div2 = koppla 'div', cell, {style: "position:absolute; top:12px; font-size:1.1em; transform: translate(-10%, -10%)" + attr, text: result}
	div3 = koppla 'td', _tr, {style : "text-align:right"} # P
	div4 = koppla 'td', _tr, {style : "text-align:right"} # PR

safeGet = (params,key,standard="") -> # Hämta parametern given av key från urlen
	if params.get key then return params.get(key).trim()
	if params.get ' ' + key then return params.get(' ' + key).trim()
	standard

savePairing = (r, A, half, n) -> # skapa en bordslista utifrån berger.
	lst = if r % 2 == 1 then [[A[n - 1], A[0]]] else [[A[0], A[n - 1]]]
	for i in [1...half]
		lst.push [A[i], A[n - 1 - i]]
	if frirond then lst.push lst.shift()
	lst.sort()

setAllPR = (delta) ->
	#echo 'setAllPR'

	trs = document.querySelectorAll '#stallning tr'
	translator = []
	for i in range trs.length
		translator.push Math.round(trs[i].children[0].textContent) - 1
	translator = invert translator

	decimals = settings.DECIMALS + delta
	if 0 <= decimals <= 6 then settings.DECIMALS = decimals

	trs = document.querySelectorAll '#stallning tr'
	for index in range players.length
		if players[index].PR > 0
			_tdPR = trs[translator[index]].children[4 + settings.GAMES * settings.ROUNDS]
			_tdPR.textContent = players[translator[index]].PR.toFixed settings.DECIMALS

setByeResults = ->
	if not frirond then return
	for r in range rounds.length
		round = rounds[r]
		for t in range round.length
			[w,b] = round[t]
			if berger
				if w == frirond then results[r][t] = '2'
				if b == frirond then results[r][t] = '0'
			else
				if w == frirond then results[r][t] = '0'
				if b == frirond then results[r][t] = '2'

setCursor = (round, table) -> # Den gula bakgrunden uppdateras beroende på piltangenterna
	ths = document.querySelectorAll '#stallning th'
	for _th,index in ths
		color = if index == currRound + 3 then 'yellow' else 'white'
		_th.style = "background-color:#{color}"

	trs = document.querySelectorAll '#tables tr'
	for _tr,index in trs
		color = if index == currTable + 0 then 'yellow' else 'white'
		_tr.children[5].style = "background-color:#{color}"

setP = (trs, index, translator) ->
	scoresP = 0
	scoresPR = 0
	elos = []
	for r in range settings.GAMES * settings.ROUNDS
		ch = longs[index][r][3]
		value = '012'.indexOf ch
		opp = longs[index][r][1]
		if value != -1
			elo = players[opp].elo
			scoresP += value
			if elo != 0
				scoresPR += value
				elos.push Math.round elo

	_tdP  = trs[translator[index]].children[3 + settings.GAMES * settings.ROUNDS]
	_tdP.textContent = if elos.length == 0 then '' else (scoresP/2).toFixed 1

	# kalkylera performance rating mha vinstandel och elo-tal
	if elos.length == 0 
		players[index].PR = 0
	else
		andel = scoresPR/2
		perf = performance andel, elos
		players[index].PR = perf

setP_all = (trs,translator) ->
	echo 'setP_all',longs.length,translator.length
	for i in range translator.length
		setP trs,i,translator

setPR = (trs, index, translator) ->
	_tdPR = trs[translator[index]].children[4 + settings.GAMES * settings.ROUNDS]
	_tdPR.textContent = if players[index].PR == 0 then '' else players[index].PR.toFixed settings.DECIMALS

setPR_all = (trs,translator) ->
	for i in range translator.length
		setPR trs,i,translator

setResult = (key, res) -> # Uppdatera results samt gui:t.
	old = results[currRound][currTable]
	[w,b] = rounds[currRound][currTable]
	if frirond and (w==frirond or b==frirond) then return

	cell = old + res # transition, 16 possibilities

	if cell in 'xx 00 11 22'.split ' ' # lyckad kontrollinmatning, gå till nästa bord
		currTable = (currTable + 1) %% tableCount()
		#echo 'currTable',currTable
		return

	if cell in '01 02 10 12 20 21'.split ' '
		echo 'exit'
		return # inmatning stämmer ej, lämna

	# uppdatera och gå till nästa bord
	results[currRound][currTable] = res

	updateLongs()

	one = settings.ONE

	trs = document.querySelectorAll '#stallning tr'
	translator = []
	for i in range trs.length
		translator.push Math.round(trs[i].children[0].textContent) - 1
	translator = invert translator

	_td = trs[translator[w]].children[3 + currRound].children[1]
	_td.textContent = "0½1"[res]

	_td = trs[translator[b]].children[3 + currRound].children[1]
	_td.textContent = "1½0"[res]

	setP trs, b, translator
	setP trs, w, translator

	setPR trs, b, translator
	setPR trs, w, translator

	# Sätt tables
	trs = document.querySelectorAll '#tables tr'
	_tr = trs[currTable] # Ska vara NOLL!
	tr5 = _tr.children[5]

	tr5.textContent = prettyResult res
	currTable = (currTable + 1) %% tableCount()

	history.replaceState {}, "", makeURL() # för att slippa omladdning av sidan

setScreen = (key) ->

	currScreen = key

	header = document.getElementById 'header'
	header.innerHTML = ''
	_h2 = koppla 'h2', header

	koppla 'pre', header, {text: KEYS[key]}

	if key == 'a' then _h2.textContent = "A Ställning för " + settings.TITLE
	if key == 'b' then _h2.textContent = "B Bordslista rond #{currRound + settings.ONE} för #{settings.TITLE}"
	if key == 'c' then _h2.textContent = "C Namnlista rond #{currRound + settings.ONE} för #{settings.TITLE}"

	document.getElementById('stallning').style.display = if key=='a' then 'flex' else 'none'
	document.getElementById('tables').style.display    = if key=='b' then 'flex' else 'none'
	document.getElementById('names').style.display     = if key=='c' then 'flex' else 'none'

showInfo = (message) -> # Visa helpText på skärmen
	root = document.getElementById('info')
	root.innerHTML = ""
	div1 = koppla 'div', root
	div2 = koppla 'div', div1, {class:"help"} 
	pre1 = koppla 'pre', div2
	pre1.innerHTML = message

showMatrix = (floating) -> # Visa matrisen Alla mot alla. Dot betyder: inget möte
	SPACING = ' '
	n = players.length
	if n > ALFABET.length then n = ALFABET.length
	echo '    ' + (ALFABET[i] for i in range n).join SPACING
	for i in range n
		line = floating.matrix[i].slice 0,n
		echo ALFABET[i] + '   ' + line.join(SPACING) + '   ' + players[i].elo + ' ' + Math.round players[i].summa

showNames = ->
	persons = []
	for [w,b],i in rounds[currRound]
		pw = [players[w].name, "#{i + settings.ONE} • W"]
		pb = [players[b].name, "#{i + settings.ONE} • B"]
		if pw[0] == 'BYE' 
			pb[1] = 'BYE'
			persons.push pb
		else if pb[0] == 'BYE' 
			pw[1] = 'BYE'
			persons.push pw
		else
			persons.push pw
			persons.push pb

	persons.sort()
	
	# Dela upp i kolumner om max 30 spelare vardera
	chunkIntoColumns = (items, size) ->
		cols = []
		for i in range 0, items.length, size
			cols.push items.slice i, i + size
		cols

	# Bygg kolumnerna (fylls kolumnvis: 30 + 30 + 30 + 10)
	columns = chunkIntoColumns persons,NAMES_PER_COL

	root = document.getElementById 'names'
	root.innerHTML = '' # rensa

	container = koppla 'div', root
	container.className = 'columns'

	columns.forEach (col) =>
		colDiv = koppla 'div', container, {class:'column'}
		tabell = koppla 'table', colDiv

		col.forEach (p) => 
			tr1 = koppla 'tr',tabell
			td1 = koppla 'td',tr1, {class:'name', text:p[0]}
			td2 = koppla 'td',tr1, {class:'seat', text:p[1]}
  
showPlayers = (longs) -> # Visa spelarlistan. (longs lagrad som lista av spelare)

	root = document.getElementById 'stallning'
	root.innerHTML = ''

	_div = koppla 'div', root
	_table = koppla 'table', _div
	_thead = koppla 'thead', _table
	koppla 'th', _thead, {text:"#"}
	koppla 'th', _thead, {text:"Namn"}
	koppla 'th', _thead, {text:"Elo"}

	for i in range rounds.length
		koppla 'th', _thead, {text:"#{i + settings.ONE}"}

	koppla 'th', _thead, {text:"P"}
	koppla 'th', _thead, {text:"PR"}

	for long, i in longs
		player = players[i]
		if player.name == 'BYE' then continue
		_tr = koppla 'tr', _table
		koppla 'td', _tr, {text: "#{i + settings.ONE}"}
		koppla 'td', _tr, {style:"text-align:left" , text: player.name}
		koppla 'td', _tr, {style:"text-align:left" , text: player.elo}
		roundsContent long, i, _tr
	

showTables = -> # Visa bordslistan

	if rounds.length == 0 then return

	root = document.getElementById 'tables'
	root.innerHTML = ''

	_div = koppla 'div', root
	_table = koppla 'table', _div
	_thead = koppla 'thead', _table
	koppla 'th', _thead, {text:"Bord"}
	koppla 'th', _thead, {text:"Vit"}
	koppla 'th', _thead, {text:"Elo"}
	koppla 'th', _thead, {text:"Elo"}
	koppla 'th', _thead, {text:"Svart"}
	koppla 'th', _thead, {text:"Resultat"}
	
	for [w,b], iTable in rounds[currRound]
		_table.appendChild addBord iTable, results[currRound][iTable], w, b

sortColumn = (index,stigande) ->
	table = document.querySelector '#stallning table'
	rader = Array.from table.querySelectorAll 'tr'

	rader.sort (a, b) ->
		cellA = a.children[index].textContent.trim()
		cellB = b.children[index].textContent.trim()

		# Försök jämföra som tal, annars som text
		numA = parseFloat cellA
		numB = parseFloat cellB
		if !isNaN(numA) and !isNaN(numB)
			return if stigande then numA - numB else numB - numA
		else
			return if stigande then cellA.localeCompare cellB else cellB.localeCompare cellA

	# Lägg tillbaka raderna i sorterad ordning
	for rad in rader
		table.appendChild rad

tableCount = -> players.length // 2 # Beräkna antal bord

updateLongs = -> # Uppdaterar longs utifrån rounds och results
	longs = (longForm rounds[r],results[r] for r in range rounds.length)
	longs = _.zip ...longs # transponerar matrisen

main = -> # Hämta urlen i första hand, textarean i andra hand.

	params = new URLSearchParams window.location.search

	if params.size == 0 
		document.getElementById("button").addEventListener "click", parseTextarea
		showInfo helpText
		return

	document.getElementById("textarea").style = 'display: none'
	document.getElementById("button").style = 'display: none'

	parseURL()

	if players.length < 4
		showInfo "Du måste ange minst fyra spelare!"
		return

	berger = settings.ROUNDS == players.length - 1
	floating = settings.ROUNDS <= players.length // 2

	if not berger ^ floating #settings.ROUNDS >= players.length // 2 and settings.ROUNDS != players.length - 1
		showInfo "Antalet ronder du angivit är ej acceptabelt!"
		return

	rounds = if berger then makeBerger() else makeFloating()
	rounds = expand settings.GAMES, rounds

	arr = []
	for p in players
		arr.push "[#{(o+1 for o in p.opp)}]"
	echo arr.join "\n"	

	for i in range settings.ROUNDS
		results.push Array(tableCount()).fill 'x'

	readResults params

	setByeResults()

	updateLongs()

	showPlayers longs
	showTables()
	showNames()

	trs = document.querySelectorAll '#stallning tr'
	translator = []
	for i in range trs.length
		translator.push Math.round(trs[i].children[0].textContent) - 1
	translator = invert translator

	setP_all trs,translator
	setPR_all trs,translator

	setScreen 'a'

	createSortEvents()
	setCursor currRound,currTable

	document.title = settings.TITLE

	document.addEventListener 'keydown', (event) -> # Hanterar alla tangenttryckningar
		start = new Date()
		key = event.key
		if key in ['a','b','c'] then setScreen key
		
		if key == 'ArrowLeft'  then changeRound -1
		if key == 'ArrowRight' then changeRound +1
		if key == 'ArrowUp'    then changeTable -1
		if key == 'ArrowDown'  then changeTable +1

		del = 'Delete'
		if key == del then setResult key, 'x' # "  -  "
		if key == '0' then setResult key, '0' # "0 - 1"
		if key == ' ' then setResult key, '1' # "½ - ½"
		if key == '1' then setResult key, '2' # "1 - 0"

		if key == 'm' then setAllPR +1
		if key == 'l' then setAllPR -1

		if key == 'd'
			echo 'Dump:'
			echo 'currRound',currRound
			echo 'currTable',currTable
			echo '  settings',settings
			echo '  players',players
			echo '  rounds',rounds
			echo '  results', results
			echo '  longs',longs

		gxr = settings.GAMES * settings.ROUNDS

		if key == '#' then sortColumn 0,    true
		if key == 'n' then sortColumn 1,    true
		if key == 'e' then sortColumn 2,    false
		if key == 'p' then sortColumn 3+gxr,false
		if key == 'r' then sortColumn 4+gxr,false

		setCursor currRound,currTable
		#echo 'cpu', key, new Date() - start

start = new Date()
main()
#echo 'cpu',new Date() - start
