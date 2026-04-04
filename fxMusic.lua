FxMusic = function(track)
	local fx = {name = "Music"}
	fx.Start = function(_)
		_.rec ={}

		music(track,-1,-1,false,true)
	end
	fx.Store=function(_,iFrame)
		_.rec[iFrame] = {track,ZIKframe,ZIKrow}
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
		ZIKtime=t
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
		_.name = string.format("Music t=%d      fr %d      row %d",ZIKtrack,ZIKframe,ZIKrow)
	end
	return fx
end
