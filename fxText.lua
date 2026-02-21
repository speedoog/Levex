CreateFxText=function(x,y,txt,c)
    local fxText = {
        name = "ScrollText",
        x=x,
        y=x,
        text = txt,
        c=c,
        start = function() end,
        tic = function(self, t, dt)
            print(self.text, x, y, c)
        end
    }
    return fxText
end
