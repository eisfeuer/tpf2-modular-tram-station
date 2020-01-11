local Module = require('modutram_module')
local c = require('modutram_constants')
local Position = require('modutram_position')
local TerminalGroup = require('modutram_terminal_group')
local Terminal = require('modutram_terminal')

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
        error('Track segments added to non track module. Track segments were not placed.')
    end
end

local function get_vehicle_path_models_by_type(vehicle_type)
    local vehicle_path_models = c.PLATFORM_PATH_MODELS[vehicle_type]
    if not vehicle_path_models then
        error('Vehicle type invalid, please check whether you has spelled correctly')
    end
    return vehicle_path_models
end

function ModelBuilder:add_vehicle_and_platform_lanes_for(vehicle_type, module_id, direction)
    local path_models = get_vehicle_path_models_by_type(vehicle_type)
    local track_module = Module:new{id = module_id}
    local track = self.column_collection:get_column(track_module.grid_x)
    if track:is_track() then
        local platform = self.column_collection:get_column(track_module.grid_x + direction)
        if platform and platform:is_platform() then
            local terminal_group = TerminalGroup:new{
                platform = platform,
                track = track,
                stop_mid_terminal = Terminal:new(path_models.stop_mid_terminal),
                stop_edge_terminal = Terminal:new(path_models.stop_edge_terminal),
                waiting_area_only_terminal = Terminal:new(path_models.waiting_area_only_terminal),
                models = self.model_collection,
                tram_path_model = path_models.vehicle_lane_without_terminal.model
            }
            table.insert(self.terminal_groups, terminal_group:as_terminal_group_item())
            terminal_group:add_to_model_collection(self.model_collection)
        end
    else
        error('lanes must be added on a track module')
    end
end

return ModelBuilder