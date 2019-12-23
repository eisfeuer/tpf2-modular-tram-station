local Position = {}

function Position:new (o)
    o = o or {}
    o.x = o.x or 0
    o.y = o.y or 0
    o.z = o.z or 0

    setmetatable(o, self)
    self.__index = self
    return o
end

function Position:as_matrix()
    return {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        self.x, self.y, self.z, 1
    }
end

return Position