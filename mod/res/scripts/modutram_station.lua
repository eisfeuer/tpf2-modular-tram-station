local ModelCollection = require('modutram_model_collection')
local ColumnCollection = require('modutram_column_collection')
local Module = require('modutram_module')

local Station = {}

function Station:new (o, module_ids)
    o = o or {}
    o.columns = o.columns or ColumnCollection:new{}
    o.models = o.models or ModelCollection:new{}
    for module_id, module_name in pairs(module_ids) do
        o.columns:add(Module:new{id = module_id})
    end
    setmetatable(o, self)
    self.__index = self
    return o
end

function Station:get_models()
    if self:is_empty() then
        return {{
            id = 'asset/icon/marker_question.mdl',
            transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
        }}
    end
    return self.models.models
end

function Station:is_empty()
    return self.columns:is_empty()
end

function Station:get_column(index)
    return self.columns:get_column(index)
end

return Station