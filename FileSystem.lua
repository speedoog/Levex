
FS = {}

function MemStream(ptr)
    local ms = {add = ptr,offset = 0}

    ms.Ptr = function(_) return _.add+_.offset end
    ms.Inc = function(_) _.offset = _.offset+1 end
    ms.Read = function(_)
        local data = peek(_:Ptr())
        _:Inc()
        return data
    end
    ms.ReadTable = function(_,n)
        local data = {}
        for i = 1,n do
            table.insert(data,_:Read())
        end
        return data
    end
    return ms
end

function FS_Load(FS)
    local ms = MemStream(gAddMap)
    local nFileCount = ms:Read()
    for ifile = 0,nFileCount-1 do
        local f = MemStream()
        f.name = ""
        while true do
            local c = ms:Read()
            if c == 0 then break end
            f.name = f.name..string.char(c)
        end

        local szlo = ms:Read()
        local szhi = ms:Read()
        f.size = (szhi<<8)+szlo

        table.insert(FS,f)
    end

    local baseAddress = ms:Ptr()
    for k,f in pairs(FS) do
        f.add = baseAddress
        baseAddress = baseAddress+f.size
    end
end

FS_Load(FS)

function FS_Open(fn)
    for k,f in pairs(FS) do
        if f.name == fn then
            f.offset = 0
            return f
        end
    end
    return nil
end

function FS_LoadScene(file)
    local scene = {npix = 0,items = {}}

    local f = FS_Open(file)
    if f == nil then
        return scene
    end

    while true do
        local b = f:Read()
        if b == 0 then -- EOF
            break
        end

        local item
        local cmd = string.char(b)

        item = CreateItem(cmd)

        if item then
            local count = f:Read()
            local params = f:ReadTable(count)
            item:Load(params)
            table.insert(scene.items,item)
        end
    end

    ComputeTotalPix(scene)
    return scene
end
