local Module = require('modutram_module')
local c = require('modutram_constants')
local Position = require('modutram_position')

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

function ModelBuilder:add_segment_models_for_tram_track(module_id, models)
    local track_module = Module:new{ id = module_id }
    local track = self.column_collection:get_column(track_module.grid_x)
    if track:is_track() then
        for i = track.btm_segment_id, track.top_segment_id do
            for j, model in ipairs(models) do
                local pos = Position:new({x = track.x_pos, y = i * c.PLATFORM_SEGMENT_LENGTH})
                self:add_model({
                    id = model.id,
                    transf = pos:add_to_matrix(model.transf)
                })
            end
        end
    else
        print('WARNING Track segments added to non track module. Track segments were not placed.')
    end
end

return ModelBuilder