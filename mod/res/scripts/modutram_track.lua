local Track = {}

function Track:new (o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self
    return o
end

function Track:is_track()
    return true
end

function Track:is_platform()
    return false
end

return Track