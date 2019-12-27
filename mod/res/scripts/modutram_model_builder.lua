local ModelBuilder = {}

function ModelBuilder:new (o, module_ids)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ModelBuilder:add_model(model)
    self.model_collection:add(model)
end

return ModelBuilder