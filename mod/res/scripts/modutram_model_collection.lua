local ModelCollection = {}

function ModelCollection:new (o)
    o = o or {}
    o.models = o.models or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return ModelCollection