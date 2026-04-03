FxMusic = function(track)
	local fx = {name = "Music"}
	fx.Start = function(_)
		_.rec ={}

		music(track,-1,-1,false,true)
	end
	fx.Store=function(_,iFrame)
		local addSOUNDSTATE = 0x13FFC
--		local track=peek(addSOUNDSTATE)
		local frame = peek(addSOUNDSTATE+1)
		ZIKrow = peek(addSOUNDSTATE+2)
		_.rec[iFrame] = {track,frame,ZIKrow}
	end
	fx.MusicStop=function()
		music()
		for i = 0,3 do
			sfx(-1,nil,nil,i) 	--sfx(id note=-1 duration=-1 channel=0 volume=15 speed=0)
		end
	end
	fx.Restore=function(_,iFrame)
		local bak=_.rec[iFrame]
		if bak then
			_:MusicStop()
			music(bak[1],bak[2],bak[3],false,true)
		end
	end
	fx.tic = function(_,t)
		local iFrame=floor(t*60)
		if _.dt==0 and not _.musicpaused then
			_:Store(iFrame)
			_:MusicStop()
			_.musicpaused=true
		elseif _.dt>0 then
			if _.musicpaused then
				_:Restore(iFrame-1)
				_.musicpaused=false
			else
				_:Store(iFrame)
			end
		elseif _.dt < 0 and not _.musicpaused then
			_:Restore(iFrame)
		end

		-- 		_.name = string.format("Music t=%d f=%d r=%d    %.1f",_.track,_.frame,_.row,musictime-_.t)

	end
	return fx
end
