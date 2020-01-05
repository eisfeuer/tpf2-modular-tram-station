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

function Position:add_to_matrix(matrix)
    return {
        matrix[1], matrix[2], matrix[3], matrix[4],
        matrix[5], matrix[6], matrix[7], matrix[8],
        matrix[9], matrix[10], matrix[11], matrix[12],
        matrix[13] + self.x, matrix[14] + self.y, matrix[15] + self.z, matrix[16]
    }
end

return Position