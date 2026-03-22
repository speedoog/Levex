FxCls = function()
	local fx = { name = "cls"}
	fx.tic = function(_, t)
		cls()
	end
	return fx
end
FxClsStart = function()
	return {name = "cls", start=function() cls() end}
end
FxClsStop = function()
	return {name = "cls", stop=function() cls() end}
end
