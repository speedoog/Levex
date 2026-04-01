FxMusic = function(track)
	local fx = {name = "Music"}
	fx.Start = function(_)
		local addMUSICTRACKS = 0x13E64
		local patternsSize = floor((6*4*16)/8)
		local info = addMUSICTRACKS+patternsSize
		_.tempo = 150+peek(info)
		_.rows = 64-peek(info+1)
		_.speed = 6+peek(info+2)

		TEMPO = 150
		SPD = 8
		rowsPerBeat = 8
		BPM = 3*TEMPO/SPD
		BPM = (24*TEMPO)/(rowsPerBeat*SPD)

		BPS = BPM/60
		RPS = BPS*8 --rowsPerBeat

		music(track,-1,-1,false,true)
	end
	-- fx.tic = function(_,t)
	-- 	if _.dt==0 then
	-- 		music()
	-- 	else
	-- 		local addSOUNDSTATE=0x13FFC
	-- 		_.track=peek(addSOUNDSTATE)
	-- 		_.frame=peek(addSOUNDSTATE+1)
	-- 		_.row=peek(addSOUNDSTATE+2)

	--		BPM = (3*_.tempo/_.speed)
	--		BPS = BPM/60
	--		RPS = BPS*8 --rowsPerBeat

	-- 		currentRowGlobal = _.frame*_.rows+_.row
	-- 		musictime = currentRowGlobal/RPS

	-- 		_.name = string.format("Music t=%d f=%d r=%d    %.1f",_.track,_.frame,_.row,musictime-_.t)

	-- 		if keyp(1) then
	-- 			_.frame=_.frame-1
	-- 			poke(addSOUNDSTATE+1, _.frame)
	-- 		end
	-- 	end
	-- end
	return fx
end
