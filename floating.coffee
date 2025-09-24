import { Edmonds } from './blossom.js'  

range = _.range
echo = console.log

export class Floating
	constructor : (@players, @settings) ->
		@N = @players.length
		if @settings.sort==1 then @players.sort (a,b) -> a.elo - b.elo
		@matrix = (("•" for i in range @N) for j in range @N)
		@summa = 0
		@rounds = []

		for r in range @settings.ROUNDS
			edges = @makeEdges()
			edmonds = new Edmonds edges
			magic = edmonds.maxWeightMatching edges
			@rounds.push @updatePlayers magic,r

	makeEdges : ->
		edges = [] 
		for i in range @N
			a = @players[i]
			for j in range @N
				if i==j then @matrix[i][j] = ' '
				b = @players[j]
				diff = Math.abs a.elo - b.elo
				if @ok a,b then edges.push [i, j, 10000 - diff ** 1.01]
		edges

	ok : (a,b) -> 
		if a.id == b.id then return false
		if a.id in b.opp then return false
		if @settings.BALANCE == 0 then return true
		Math.abs(a.balance() + b.balance()) < 2

	save : (a, b, ca, cb, ia, ib) ->
		a.col += ca
		b.col += cb
		@tables.push [ia, ib]

	updatePlayers : (magic,r) -> 
		@tables = []
		# echo 'matrix',@matrix
		flip = false # om två spelare har diff==0, ska varannan bli vit, varannan svart
		for id in magic
			i = id
			j = magic[id]
			if i == @matrix.length or j == @matrix[0].length then continue
			@matrix[i][j] = "#{'123456789abcdefgh'[r]}"
			if i > j then continue
			@summa += Math.abs @players[i].elo - @players[j].elo
			a = @players[i]
			b = @players[j]
			a.opp.push j
			b.opp.push i
			diff = a.balance() - b.balance()
			if diff > 0
				@save a,b,'b','w',j,i
			else if diff < 0
				@save a,b,'w','b',i,j
			else 
				if flip
					@save a,b,'b','w',j,i 
				else 
					@save a,b,'w','b',i,j
				flip = not flip
		@tables
