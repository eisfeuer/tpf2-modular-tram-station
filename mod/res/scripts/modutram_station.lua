local ModelCollection = require('modutram_model_collection')
local ColumnCollection = require('modutram_column_collection')
local Module = require('modutram_module')
local SlotCollection = require('modutram_slot_collection')
local ModelBuilder = require('modutram_model_builder')

local Station = {}

function Station:new (o, module_ids)
    o = o or {}
    o.columns = o.columns or ColumnCollection:new{}
    o.models = o.models or ModelCollection:new{}
    o.slots = o.slots or SlotCollection:new{}
    o.builder = o.builder or ModelBuilder:new{
        model_collection = o.models,
        column_collection = o.columns
    }
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

function Station:get_slots()
    return self.slots:get_slots()
end

return Station