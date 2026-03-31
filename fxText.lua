FxText = function(x,y,txt,c,fnPrint)
	if fnPrint == nil then fnPrint = FontWrap end
	if c==nil then c=gWhite end
	local fx = { name="txt "..txt, x=x, y=y, txt=txt, c=c, fnPrint=fnPrint, fnStyle=StyleNone}

	fx.tic = function(_,t)
		local e = #_.txt
		if _.speed then e = floor(t*_.speed) end
		local tsub = _.txt:sub(0,e)
		_.fnStyle(tsub,_.x,_.y,_.c,_.fnPrint,_.c2)
	end

	return fx
end
