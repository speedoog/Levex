FxBalls = function()
    local fx = {
        name = "Balls",
        cls = false,
        start = function()
        end,
        tic = function(self, t, dt)
            local t = floor(t * 60)

            for i = 0, 10000 do
                x = rand(240) - 1
                y = rand(136) - 1
                if rand() > 0.8 then
                    c = 0
                else
                    c = pix(x, y - 3 * rand())
                end
                pix(x, y, c)
            end

            --	for i=0,0 do rect(0,rand(136), 240,1, 0) end
            --	for i=0,10 do rect(rand(240),0, 1,136, 0) end

            for c = 1, 4 do
                for i = 0, 16 do
                    circ(120 + 100 * sin(t / 11 + 1.3 * c), 68 + 50 * sin(t / 9 + c), 8 + sin(t / 10 + c) * 6, c)
                end
            end
        end
    }
    return fx
end
