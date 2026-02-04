

Parts = { Part2, Part2 }
iPart = 0

function PartNext()
	iPart = iPart+1
	if iPart>#Parts then iPart = 1 end
	PartCur = Parts[iPart]
	PartCur.init()
end

PartNext()

-- ############## Demo ##############

function main()

	if PartCur.tic() then
		PartNext()
	end

--	cls(t/100%16)

end