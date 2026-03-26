
function rgbToHsv(r,g,b)
    r,g,b = r/255,g/255,b/255
    local max,min = math.max(r,g,b),math.min(r,g,b)
    local h,s,v
    v = max
    local d = max-min
    if max == 0 then
        s = 0
    else
        s = d/max
    end
    if max == min then
        h = 0
    else
        if max == r then
            h = (g-b)/d
            if g < b then
                h = h+6
            end
        elseif max == g then
            h = (b-r)/d+2
        elseif max == b then
            h = (r-g)/d+4
        end
        h = h/6
    end
    return h,s,v
end

function hsvToRgb(h,s,v)
    local r,g,b
    local i = math.floor(h*6)
    local f = h*6-i
    local p = v*(1-s)
    local q = v*(1-f*s)
    local t = v*(1-(1-f)*s)
    i = i%6
    if i == 0 then
        r,g,b = v,t,p
    elseif i == 1 then
        r,g,b = q,v,p
    elseif i == 2 then
        r,g,b = p,v,t
    elseif i == 3 then
        r,g,b = p,q,v
    elseif i == 4 then
        r,g,b = t,p,v
    elseif i == 5 then
        r,g,b = v,p,q
    end
    return math.floor(r*255),math.floor(g*255),math.floor(b*255)
end

function make_gradient(r1,g1,b1,r2,g2,b2,steps)
    steps = math.abs(steps)
    local out = {}
    local h1 = 0
    local s1 = 0
    local v1 = 0
    h1,s1,v1 = rgbToHsv(r1,g1,b1)
    local h2 = 0
    local s2 = 0
    local v2 = 0
    h2,s2,v2 = rgbToHsv(r2,g2,b2)
    local stepamount = 1/(steps-1)
    local prog = 0
    local i = 0
    for i = 1,steps,1 do
        local temph = lerp(h1,h2,prog)
        local temps = lerp(s1,s2,prog)
        local tempv = lerp(v1,v2,prog)
        out[i] = {}
        out[i].r,out[i].g,out[i].b = hsvToRgb(temph,temps,tempv)
        prog = prog+stepamount
    end
    return out
end

function make_gradient_direct(r1,g1,b1,r2,g2,b2,steps)
    steps = math.abs(steps)
    local out = {}
    local stepamount = 1/(steps-1)
    local prog = 0
    local i = 0
    for i = 1,steps,1 do
        out[i] = {}
        out[i].r = lerp(r1,r2,prog)
        out[i].g = lerp(g1,g2,prog)
        out[i].b = lerp(b1,b2,prog)
        prog = prog+stepamount
    end
    return out
end
