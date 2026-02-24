CreateFxText=function(x,y,txt,c)
    local fxText = {
        name = "ScrollText",
        x=x,
        y=y,
        text = txt,
        c=c,
        start = function() end,
        tic = function(self, t, dt)
            print(self.text, self.x, self.y, self.c)
        end
    }
    return fxText
end
