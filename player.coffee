import {echo,global,range} from './global.js'
import {performance} from './rating.js'

export class Player

	constructor : (@id, @name, @elo) ->
		@opp = [] # används endast av Floating
		@col = "" # används endast av Floating
		@summa = 0
		@P = 0
		@PR = 0

	balance : ->
		b = 0
		for c in @col
			if c=='w' then b++
			if c=='b' then b--
		b

	toString: -> "#{String(@elo).padStart 4, '0'} #{@name}"

	update_P_and_PR : (longs,i) ->
		long = longs[i]
		#echo 'longs',longs
		@P = 0
		@PR = 0
		@elos = []
		for r in range global.settings.GAMES * global.settings.ROUNDS
			ch = long[r][3]
			value = '012'.indexOf ch
			opp = long[r][1]
			if value != -1
				elo = global.players[opp].elo
				@P += value/2
				if elo != 0
					@PR += value/2
					@elos.push Math.round elo

		# kalkylera performance rating mha vinstandel och elo-tal
		if @elos.length == 0 
			@PR = 0
		else
			andel = @PR
			perf = performance andel, @elos
			@PR = perf


# setP = (trs, index, translator) ->
# 	scoresP = 0
# 	scoresPR = 0
# 	elos = []
# 	for r in range settings.GAMES * settings.ROUNDS
# 		ch = longs[index][r][3]
# 		value = '012'.indexOf ch
# 		opp = longs[index][r][1]
# 		if value != -1
# 			elo = players[opp].elo
# 			scoresP += value
# 			if elo != 0
# 				scoresPR += value
# 				elos.push Math.round elo

# 	tdP  = trs[translator[index]].children[3 + settings.GAMES * settings.ROUNDS]
# 	tdP.textContent = if elos.length == 0 then '' else (scoresP/2).toFixed 1

# 	# kalkylera performance rating mha vinstandel och elo-tal
# 	if elos.length == 0 
# 		players[index].PR = 0
# 	else
# 		andel = scoresPR/2
# 		perf = performance andel, elos
# 		players[index].PR = perf

# setP_all = (trs,translator) ->
# 	#echo 'setP_all',longs.length,translator.length
# 	for i in range translator.length
# 		setP trs,i,translator

# setPR = (trs, index, translator) ->
# 	tdPR = trs[translator[index]].children[4 + settings.GAMES * settings.ROUNDS]
# 	tdPR.textContent = if players[index].PR == 0 then '' else players[index].PR.toFixed settings.DECIMALS

# setPR_all = (trs,translator) ->
# 	for i in range translator.length
# 		setPR trs,i,translator

