fxScrollText = {
	name = "ScrollText",
	Warning = [[
A very small percentage of individuals
may experience epileptic seizures
or blackouts when exposed to
certain light patterns or flashing lights.

Exposure to certain patterns or backgrounds
on a television screen or when playing
video games may trigger epileptic seizures
or blackouts in these individuals.

These conditions may trigger previously
undetected epileptic symptoms or seizures
in persons who have no history of prior seizures
or epilepsy.

If you, or anyone in your family has an
epileptic condition or has had
seizures of any kind,
consult your physician before playing.
]],
	start = function() end,
	tic = function(self, t, dt)
		local y = max(136 - (t*10), 0)
		print(self.Warning, 0, y, 15)
	end
}
