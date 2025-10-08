# ½ • ↑ ↓ ← →

import {Player} from './player.js'
import {Floating} from './floating.js'
import {performance} from './rating.js'
import {echo,global,range,settings} from './global.js'

ALFABET = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890' # 100

BYE = "BYE"

KEYS = 
	'A' : "? GAP A B C GAP ArrowLeft ArrowRight GAP I K GAP # N E P R GAP J L".split ' '
	'B' : "? GAP A B C GAP ArrowLeft ArrowRight GAP I K GAP ArrowUp ArrowDown GAP 0 _ 1 Delete".split ' '
	'C' : "? GAP A B C GAP ArrowLeft ArrowRight GAP I K".split ' '

TOOLTIPS = 
	'?' : "Help"
	'A' : "Standings"
	'B' : "Tables"
	'C' : "Names"
	'ArrowLeft' : "Previous Round"
	'J' : "Shrink PR decimals"
	'L' : "Grow PR decimals"
	'ArrowRight' : "Next Round"
	'I' : "Shrink Group Size"
	'K' : "Grow Group Size"
	'ArrowUp' : "Previous Table"
	'0' : "White Loss"
	'_' : "Draw"
	'1' : "White Win"
	'Delete' : "Remove Result"
	'ArrowDown' : "Next Table"
	'#' : "Sort on id"
	'N' : "Sort on Name"
	'E' : "Sort on Elo"
	'P' : "Sort on Point"
	'R' : "Sort on performance Rating"

## F U N K T I O N E R ##

addBord = (bord,res,c0,c1) ->
	vit = global.players[c0].name
	svart = global.players[c1].name
	vit_elo = global.players[c0].elo
	svart_elo = global.players[c1].elo
	tr = document.createElement 'tr'

	tr.addEventListener "click", ->
		console.log "Du klickade på rad #{bord}"
		global.currTable = bord
		setCursor global.currRound,global.currTable

	color = if bord == global.currTable then 'yellow' else 'white'

	koppla 'td', tr, {text : bord + settings.ONE}
	koppla 'td', tr, {style:"text-align:left", text : vit}
	koppla 'td', tr, {style:"text-align:left", text : vit_elo}
	koppla 'td', tr, {style:"text-align:left", text : svart_elo}
	koppla 'td', tr, {style:"text-align:left", text : svart}
	koppla 'td', tr, {style:"text-align:center; background-color:#{color}", text : prettyResult res}

	tr
	
changeGroupSize = (key,letter) ->
	if key == 'I' then settings[letter] -= 1
	if key == 'K' then settings[letter] += 1
	if key in ['I', 'K']
		if letter == 'A' then showPlayers()
		if letter == 'B' then showTables()
		if letter == 'C' then showNames()

changeRound = (delta) -> # byt rond och uppdatera bordslistan
	global.currRound = (global.currRound + delta) %% global.rounds.length
	global.currTable = 0
	
	setScreen global.currScreen

changeTable = (delta) -> global.currTable = (global.currTable + delta) %% tableCount()

convert = (input,a,b) -> # byt alla tecken i input som finns i a mot tecken med samma index i b
	if input in a then b[a.indexOf input] else input # a och b är strängar

createSortEvents = -> # Spelarlistan sorteras beroende på vilken kolumn man klickar på. # Name Elo P eller PR

	ths = document.querySelectorAll '#players th'

	for th in ths
		do (th) ->
			th.addEventListener 'click', (event) ->
				key = th.textContent
				if key == '#'    then global.sortKey = '#'
				if key == 'Name' then global.sortKey = 'N'
				if key == 'Elo'  then global.sortKey = 'E'
				if key == 'P'    then global.sortKey = 'P'
				if key == 'PR'   then global.sortKey = 'R'
				if ['#','Name','Elo','P','PR'].includes key
					# echo 'click',global.sortKey
					showPlayers()

export expand = (games, rounds) -> # make a double round from a single round
	result = []
	for round in rounds
		result.push ([w,b] for [w,b] in round)
		if games == 2 then result.push ([b,w] for [w,b] in round)
	return result

# export findNumberOfDecimals = (lst) -> # leta upp minsta antal decimaler som krävs för unikhet i listan
# 	best = 0
# 	for i in range 6
# 		unik = _.uniq (item.toFixed(i) for item in lst)
# 		if unik.length > best then [best,ibest] = [unik.length,i]
# 	ibest

handleKey = (key) ->

	echo 'key 1',key
	if key.length == 1 then key = key.toUpperCase()
	echo 'key 2',key
	if key == '?' then showHelp()

	if key == 'ArrowLeft'  then changeRound -1
	if key == 'ArrowRight' then changeRound +1
	if key == 'ArrowUp'   and global.currScreen == 'B' then changeTable -1
	if key == 'ArrowDown' and global.currScreen == 'B' then changeTable +1

	del = 'Delete'
	if key == del and global.currScreen == 'B' then setResult key, 'x' # "  -  "
	if key == '0' and global.currScreen == 'B' then setResult key, '0' # "0 - 1"
	if key == ' ' and global.currScreen == 'B' then setResult key, '1' # "½ - ½"
	if key == '1' and global.currScreen == 'B' then setResult key, '2' # "1 - 0"

	if key == 'J' and global.currScreen == 'A' then setDecimals -1
	if key == 'L' and global.currScreen == 'A' then setDecimals +1

	if key == 'X' then showMatrix()
	if key == 'Y' then echo 'Dump', global
	
	if global.currScreen == 'A' and key in '#NEPR'
		global.sortKey = key
		showPlayers()

	if global.currScreen == 'A' then changeGroupSize key,'A'
	if global.currScreen == 'B' then changeGroupSize key,'B'
	if global.currScreen == 'C' then changeGroupSize key,'C'

	if key == 'A' then setScreen 'A'
	if key == 'B' then setScreen 'B'
	if key == 'C' then setScreen 'C'

	setCursor global.currRound, global.currTable

	if key == ' ' or key in 'Delete 0 1 # N E P R'.split ' '
		history.replaceState {}, "", makeURL() # för att slippa omladdning av sidan

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
	n = global.players.length
	half = n // 2 
	A = [0...n]
	global.rounds = []
	for i in range settings.ROUNDS
		global.rounds.push savePairing i, A, half, n
		A.pop()
		A = A.slice(half).concat A.slice(0,half)
		A.push n-1
	global.rounds

makeFloating = -> # lotta en hel floating-turnering
	global.floating = new Floating global.players, settings
	global.floating.rounds

makeURL = ->
	url = "./"

	url += "?TITLE=#{settings.TITLE}"
	url += "&GAMES=#{settings.GAMES}"
	url += "&ROUNDS=#{settings.ROUNDS}"
	url += "&SORT=#{settings.SORT}"
	url += "&sortKey=#{global.sortKey}".replace '#', '%23'
	url += "&ONE=#{settings.ONE}"
	url += "&BALANCE=#{settings.BALANCE}"
	url += "&A=#{settings.A}"
	url += "&B=#{settings.B}"
	url += "&C=#{settings.C}"

	for player in global.players
		url += "&p=#{player}"

	for r in range global.rounds.length
		s = global.results[r].join ''
		s = _.trimEnd s, 'x'
		if s != '' then url += "&r#{r+1}=#{s}"

	url = url.replaceAll ' ', '+'
	url

export other = (input) -> convert input, "012x","210x"

parseTextarea = -> # läs in initiala uppgifter om spelarna
	raw = document.getElementById "textarea"

	lines = raw.value
	lines = lines.split "\n"

	global.rounds = null
	global.players = []

	persons = []

	for line in lines 
		if line.length == 0 or line[0] == '#' then continue
		if line.includes '='
			[key, val] = line.split '='
			key = key.trim()
			val = val.trim()
			if key in "TITLE GAMES ROUNDS SORT ONE BALANCE A B C".split ' ' then settings[key] = val
		else
			persons.push line

	persons.sort().reverse()

	for person in persons
		elo = parseInt person.slice 0,4
		name = person.slice(4).trim()
		global.players.push new Player global.players.length, name, elo

	n = global.players.length
	if settings.A > n then settings.A = n
	if settings.B > n then settings.B = n
	if settings.C > n then settings.C = n

	if global.players.length % 2 == 1
		global.frirond = global.players.length
		global.players.push '0000 ' + BYE
	else
		global.frirond = null

	if settings.ROUNDS == 0 then settings.ROUNDS = global.players.length - 1

	if global.rounds == null then global.rounds = []

	url = makeURL()
	global.players = []
	global.rounds = []
	window.location.href = url
	echo 'window.location.href = url'

parseURL = -> 
	params = new URLSearchParams window.location.search

	settings.TITLE = safeGet params, "TITLE"
	settings.GAMES = parseInt safeGet params, "GAMES", "1"
	settings.SORT = parseInt safeGet params, "SORT", "1"
	global.sortKey = safeGet params, "sortKey", "#"

	settings.ONE = parseInt safeGet params, "ONE", "1"
	settings.BALANCE = parseInt safeGet params, "BALANCE", "1"

	settings.A = parseInt safeGet params, "A", "29"
	settings.B = parseInt safeGet params, "B", "30"
	settings.C = parseInt safeGet params, "C", "30"

	global.players = []
	persons = params.getAll "p"

	if window.location.href.includes BYE then global.frirond = persons.length - 1
	if settings.SORT == 1 then persons.sort().reverse()

	for person in persons
		elo = parseInt person.slice 0,4
		name = person.slice(4).trim()
		global.players.push new Player global.players.length, name, elo

	settings.ROUNDS = parseInt safeGet params, "ROUNDS", "#{global.players.length-1}"

	# initialisera rounds med 'x' i alla celler
	n = global.players.length // 2
	global.rounds = []
	for i in range settings.GAMES * settings.ROUNDS
		global.rounds.push new Array(n).fill 'x'

	readResults params

export prettyResult = (ch) -> # översätt interna resultat till externa
	if ch == 'x' then return "-"
	if ch == '0' then return "0 - 1"
	if ch == '1' then return "½ - ½"
	if ch == '2' then return "1 - 0"

readResults = (params) -> # Resultaten läses från urlen
	global.results = []
	n = global.players.length
	if global.frirond then n -= 2
	n //= 2
	
	for r in range settings.GAMES * settings.ROUNDS
		result = safeGet params, "r#{r+1}", new Array(n).fill "x"
		arr = []
		for ch in result 
			if ch=='0' then arr.push '0'
			if ch=='1' then arr.push '1'
			if ch=='2' then arr.push '2'
			if ch=='x' then arr.push 'x'
		global.results.push arr

roundsContent = (long, i, tr) -> # rondernas data + poäng + PR. i anger spelarnummer
	for [w,b,color,result] in long
		opponent = if w == i then b else w
		result = convert result, 'x012', ' 0½1'
		attr = if color == 'w' then "right:0px;" else "left:0px;"
		cell = koppla 'td', tr, {style: "position:relative;"}
		koppla 'div', cell, {style: "position:absolute; top:0px; font-size:0.7em;" + attr, text: settings.ONE + opponent}
		koppla 'div', cell, {style: "position:relative; font-size:1.1em; top:6px", text: result}

safeGet = (params,key,standard="") -> # Hämta parametern given av key från urlen
	if params.get key then return params.get(key).trim()
	if params.get ' ' + key then return params.get(' ' + key).trim()
	standard

savePairing = (r, A, half, n) -> # skapa en bordslista utifrån berger.
	lst = if r % 2 == 1 then [[A[n - 1], A[0]]] else [[A[0], A[n - 1]]]
	for i in [1...half]
		lst.push [A[i], A[n - 1 - i]]
	if global.frirond then lst.push lst.shift()
	lst.sort()

setByeResults = ->
	if global.frirond == null then return
	for r in range global.rounds.length
		round = global.rounds[r]
		for t in range round.length
			[w,b] = round[t]
			if global.berger
				if w == global.frirond then global.results[r][t] = '2'
				if b == global.frirond then global.results[r][t] = '0'
			else
				if w == global.frirond then global.results[r][t] = '0'
				if b == global.frirond then global.results[r][t] = '2'

setCursor = (round, table) -> # Den gula bakgrunden uppdateras beroende på piltangenterna
	ths = document.querySelectorAll '#players th'
	for th,index in ths
		if index == global.currRound + 3
			bgColor = 'yellow'
			color = 'black'
		else
			bgColor = 'black'
			color = 'white'
		th.style = "background-color:#{bgColor}; color:#{color};"

	trs = document.querySelectorAll '#tables tr'
	for tr,index in trs
		color = if index == global.currTable + 0 then 'yellow' else 'white'
		tr.children[5].style = "background-color:#{color}"

setDecimals = (delta) ->
	decimals = settings.DECIMALS + delta
	if 0 <= decimals <= 6 then settings.DECIMALS = decimals
	showPlayers()

setResult = (key, res) -> # Uppdatera results samt gui:t.
	old = global.results[global.currRound][global.currTable]
	[w,b] = global.rounds[global.currRound][global.currTable]
	if global.frirond and (w==global.frirond or b==global.frirond) then return

	cell = old + res # transition, 16 possibilities

	if cell in 'xx 00 11 22'.split ' ' # lyckad kontrollinmatning, gå till nästa bord
		global.currTable = (global.currTable + 1) %% tableCount()
		return

	if cell in '01 02 10 12 20 21'.split ' '
		echo 'exit'
		return # inmatning stämmer ej, lämna

	# uppdatera och gå till nästa bord
	global.results[global.currRound][global.currTable] = res

	updateLongs()

	# Uppdatera GUI för tables kirurgiskt
	trs = document.querySelectorAll '#tables tr'
	tr = trs[global.currTable] # Ska vara NOLL!
	tr5 = tr.children[5]

	tr5.textContent = prettyResult res
	global.currTable = (global.currTable + 1) %% tableCount()

setScreen = (letter) ->
	global.currScreen = letter

	if global.currScreen == 'A' then showPlayers()
	if global.currScreen == 'B' then showTables()
	if global.currScreen == 'C' then showNames()

	header = document.getElementById 'header'
	header.innerHTML = ''
	h2 = koppla 'h2', header

	echo KEYS,global.currScreen
	for key in KEYS[global.currScreen]
		skey = key
		if key == 'ArrowLeft' then skey = '←'
		if key == 'ArrowRight' then skey = '→'
		if key == 'ArrowUp' then skey = '↑'
		if key == 'ArrowDown' then skey = '↓'
		if key == 'Delete' then skey = 'Del'
		if key == 'GAP'
			btn = koppla 'span', header, {style: "display: inline-block; width: 0.5rem;"}
		else
			btn = koppla 'button', header, {text: skey, title: TOOLTIPS[key]}
			if key == '_'
				btn.style = "color: transparent"
				key = ' '
			do (key) -> btn.addEventListener 'click', () => handleKey key

	if global.currScreen == 'A' then h2.textContent = "A Standings for " + settings.TITLE
	if global.currScreen == 'B' then h2.textContent = "B Tables round #{global.currRound + settings.ONE} for #{settings.TITLE}"
	if global.currScreen == 'C' then h2.textContent = "C Names round #{global.currRound + settings.ONE} for #{settings.TITLE}"

	document.getElementById('players').style.display = if global.currScreen == 'A' then 'flex' else 'none'
	document.getElementById('tables').style.display  = if global.currScreen == 'B' then 'flex' else 'none'
	document.getElementById('names').style.display   = if global.currScreen == 'C' then 'flex' else 'none'

showHelp = ->
	r = await fetch "help.md"
	mdText = await r.text()
	win = window.open "", "_blank"
	win.document.write "<html><head><title>Help</title>
		<style>
			body {
			font-family: Arial, sans-serif;
			margin: 2em;
			line-height: 1.5;
			}
		</style>
		</head><body>#{marked.parse(mdText)}</body></html>"
	win.document.close()

showInfo = (message) -> # Visa helpText på skärmen
	pre = document.getElementById 'info'
	pre.className = "help"
	pre.innerHTML = message

showMatrix = -> # Visa matrisen Alla mot alla. Dot betyder: inget möte
	SPACING = ' '
	n = global.players.length
	if n > ALFABET.length then n = ALFABET.length

	if global.berger 
		if settings.GAMES == 2 then return
		global.matrix = (("•" for i in range n) for j in range n)
		m = global.matrix
		for r in range global.rounds.length
			round = global.rounds[r]
			for [i,j] in round
				if i == m.length or j == m[0].length then continue
				m[i][j] = "#{'123456789abcdefgh'[r]}"
				m[j][i] = "#{'123456789abcdefgh'[r]}"

		echo '    ' + (ALFABET[i] for i in range n).join SPACING
		for i in range n
			line = m[i].slice 0,n
			echo ALFABET[i] + '   ' + line.join(SPACING) + '   ' + global.players[i].elo  # + ' ' + Math.round global.players[i].summa
	else 
		echo '    ' + (ALFABET[i] for i in range n).join SPACING
		for i in range n
			line = global.floating.matrix[i].slice 0,n
			echo ALFABET[i] + '   ' + line.join(SPACING) + '   ' + global.players[i].elo  # + ' ' + Math.round global.players[i].summa

showNames = ->
	persons = []
	for [w,b],i in global.rounds[global.currRound]
		pw = [global.players[w].name, "#{i + settings.ONE} • W"]
		pb = [global.players[b].name, "#{i + settings.ONE} • B"]
		if pw[0] == BYE 
			pb[1] = BYE
			persons.push pb
		else if pb[0] == BYE
			pw[1] = BYE
			persons.push pw
		else
			persons.push pw
			persons.push pb

	persons.sort()
	groups = _.chunk persons,settings.C

	container = document.getElementById 'names'
	container.innerHTML = '' # rensa
	container.className = 'groups'

	groups.forEach (group) =>
		tabell = koppla 'table', container, {class:'group'}
		thead = koppla 'thead', tabell
		koppla 'th', thead, {text:"Name"}
		koppla 'th', thead, {text:"Table"}

		group.forEach (p) => 
			tr1 = koppla 'tr',tabell
			td1 = koppla 'td',tr1, {style: "text-align:left", text:p[0]}
			td2 = koppla 'td',tr1, {style: "text-align:center", text:p[1]}

showPlayers = -> # Visa spelarlistan.

	for player,i in global.players
		player.update_P_and_PR global.longs,i

	sortedPlayers = _.clone global.players

	# Tag bort BYE om den finns.
	if global.frirond != null then memory = _.first _.remove sortedPlayers, (item) -> item.name == BYE

	sortedPlayers.sort (a, b) =>
		if global.sortKey == '#' then return a.id - b.id
		if global.sortKey == 'N' then return a.name.localeCompare b.name, "sv"
		if global.sortKey == 'E' then return b.elo - a.elo
		if global.sortKey == 'P' then return b.P - a.P 
		if global.sortKey == 'R' then return b.PR - a.PR

	# Lägg tillbaka BYE i slutet
	if global.frirond != null then sortedPlayers.push memory

	groups = _.chunk sortedPlayers,settings.A
	if _.last(groups).length == 1 and _.last(groups)[0].name == BYE then groups.pop()
	container = document.getElementById 'players'
	container.innerHTML = ''
	container.className = 'groups'

	offset = 0
	groups.forEach (group) =>
		tabell = koppla 'table', container, {class:'group'}
		thead = koppla 'thead', tabell
		koppla 'th', thead, {text:"#" }
		koppla 'th', thead, {text:"Name"}
		koppla 'th', thead, {text:"Elo"}
		for i in range global.rounds.length
			koppla 'th', thead, {text:"#{i + settings.ONE}"}
		koppla 'th', thead, {text:"P"}
		koppla 'th', thead, {text:"PR"}

		group.forEach (player) =>
			if player.name == BYE then return
			tr = koppla 'tr', tabell, {style:"height: 28px"} # 27 ger ojämna höjder
			koppla 'td', tr, {text: player.id + settings.ONE}
			koppla 'td', tr, {style:"text-align:left", text: player.name} # .slice 0,20
			koppla 'td', tr, {text: player.elo}

			long = global.longs[player.id]
			roundsContent long, player.id, tr

			for i in range long.length, global.rounds.length
				koppla 'td', tr, {style:"text-align:left" , 'x'}

			koppla 'td', tr, {style:"text-align:right" , text: player.P.toFixed 1}
			koppla 'td', tr, {style:"text-align:right" , text: player.PR.toFixed settings.DECIMALS}

		offset += settings.A

	createSortEvents()

showTables = -> # Visa bordslistan
	if global.rounds.length == 0 then return
	round = global.rounds[global.currRound]
	groups = _.chunk round, settings.B

	container = document.getElementById 'tables'
	container.innerHTML = ''
	container.className = 'groups'

	offset = 0
	groups.forEach (group) =>
		tabell = koppla 'table', container, {class:'group'}
		thead = koppla 'thead', tabell
		for rubrik in "Table White Elo Elo Black Result".split ' '
			koppla 'th', thead, {text:rubrik}

		group.forEach ([w,b],iTable) =>
			tabell.appendChild addBord offset + iTable, global.results[global.currRound][offset + iTable], w,b
		offset += settings.B

tableCount = -> global.players.length // 2 # Beräkna antal bord

updateLongs = -> # Uppdaterar longs utifrån rounds och results
	global.longs = (longForm global.rounds[r],global.results[r] for r in range global.rounds.length)
	global.longs = _.zip ...global.longs # transponerar matrisen

main = -> # Hämta urlen i första hand, textarean i andra hand.

	params = new URLSearchParams window.location.search

	if params.size == 0 
		document.getElementById("help").addEventListener "click", showHelp
		document.getElementById("continue").addEventListener "click", parseTextarea
		return

	document.getElementById("help").style = 'display: none'
	document.getElementById("textarea").style = 'display: none'
	document.getElementById("continue").style = 'display: none'

	parseURL()

	if global.players.length < 4
		showInfo "You must have four or more players!"
		return

	global.berger = settings.ROUNDS == global.players.length - 1
	floatingFlag = settings.ROUNDS <= global.players.length // 2

	if not global.berger ^ floatingFlag #settings.ROUNDS >= players.length // 2 and settings.ROUNDS != players.length - 1
		showInfo "The number of rounds is not accepted!"
		return

	global.rounds = if global.berger then makeBerger() else makeFloating()

	global.rounds = expand settings.GAMES, global.rounds

	for i in range settings.ROUNDS
		global.results.push Array(tableCount()).fill 'x'

	readResults params
	setByeResults()
	updateLongs()
	setScreen 'A'
	setCursor global.currRound,global.currTable
	document.title = settings.TITLE

	document.addEventListener 'keydown', (event) -> # Hanterar alla tangenttryckningar
		return if event.ctrlKey or event.metaKey or event.altKey # förhindrar att ctrl p sorterar på poäng
		handleKey event.key

		# tvinga bordet att synas
		rad = document.querySelectorAll("#tables table tr")[global.currTable]
		rad.scrollIntoView { behavior: "smooth", block: "center" }

main()
