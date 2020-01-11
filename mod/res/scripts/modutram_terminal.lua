local Terminal = {}

function Terminal:new (o) 
    setmetatable(o, self)
    self.__index = self
    return o
end

function Terminal:to_array()
    return {self.model, self.terminal_position}
end

return Terminal