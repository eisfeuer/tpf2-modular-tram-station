local ModelCollection = {}

function ModelCollection:new (o)
    o = o or {}
    o.models = o.models or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ModelCollection:add(model)
    table.insert(self.models, model)
end

function ModelCollection:count()
    return #self.models
end

function ModelCollection:get_position_of_next_added_item()
    return self:count()
end

return ModelCollection