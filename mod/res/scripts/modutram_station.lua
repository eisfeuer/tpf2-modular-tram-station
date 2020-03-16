local ModelCollection = require('modutram_model_collection')
local ColumnCollection = require('modutram_column_collection')
local Module = require('modutram_module')
local SlotCollection = require('modutram_slot_collection')
local ModelBuilder = require('modutram_model_builder')
local PassengerPathBuilder = require('modutram_passenger_path_builder')
local TerrainAlignment = require('modutram_terrain_alignment')
local ModuleInterface = require('modutram_module_interface')

local Station = {}

function Station:new (o, module_ids)
    o = o or {}
    o.terminal_groups = o.terminal_groups or {}
    o.columns = o.columns or ColumnCollection:new{}
    o.models = o.models or ModelCollection:new{}
    o.slots = o.slots or SlotCollection:new{}
    o.builder = o.builder or ModelBuilder:new{
        model_collection = o.models,
        column_collection = o.columns,
        terminal_groups = o.terminal_groups
    }
    for module_id, module_name in pairs(module_ids) do
        o.columns:add(Module:new{id = module_id}, module_name)
    end
    o.columns:calculate_x_positions()
    o.columns:calculate_track_segment_range()
    o.slots:import_from_column_collection(o.columns)
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

function Station:get_data()
    local terrain_alignment_polygon = TerrainAlignment.create_terrain_polygon_for(self.columns)

    local result = { }
            
    result.station = self

    result.models = {}
    result.slots = self:get_slots()
    result.edgeLists = {}
    result.terminalGroups = {}

    if self:is_empty() then
        result.terrainAlignmentLists = {}
        result.groundFaces = {}
    else
        result.terrainAlignmentLists = { TerrainAlignment.create_terrain_alignment_list_from_polygon(terrain_alignment_polygon) }
        result.groundFaces = { TerrainAlignment.create_ground_faces_from_polygon(terrain_alignment_polygon, "industry_floor_high_priority.gtex.lua",  "pedestrian_connection_border.lua") }
    end

    result.terminateConstructionHook = function()	
        local passenger_path_builder = PassengerPathBuilder:new{
            column_collection = self.columns,
            passenger_path_models = {
                vertical_single_platform = 'station/tram/path/passenger_vertical_single_platform.mdl',
                vertical_double_platform = 'station/tram/path/passenger_vertical_double_platform_btm.mdl',
                horizontal_single_track = 'station/tram/path/passenger_horizontal_single_track.mdl',
                horizontal_double_track = 'station/tram/path/passenger_horizontal_double_track.mdl',
                street_link_left = 'station/tram/path/passenger_street_link_left.mdl',
                street_link_right = 'station/tram/path/passenger_street_link_right.mdl',
            }
        }

        require('inspect').inspect(self.models)

        for i, terminal_group in ipairs(self.terminal_groups) do
            table.insert(result.terminalGroups, terminal_group:as_terminal_group_item())
            terminal_group:add_to_model_collection(self.models)
        end

        passenger_path_builder:add_bottom_part_to_model_collection(self.models)
        passenger_path_builder:add_top_part_to_model_collection(self.models)

        local models = result.models
        result.models = self:get_models()
        for i, model in ipairs(models) do
            table.insert(result.models, model)
        end
    end
    return result
end

function Station:is_top_segment_of_a_platform(segment_id)
    local mod = Module:new{id = segment_id}
    local platform = self.columns:get_column(mod.grid_x)

    if not platform or not platform:is_platform() then
        return false
    end

    return mod.grid_y == platform.top_segment_id
end

function Station:is_bottom_segment_of_a_platform(segment_id)
    local mod = Module:new{id = segment_id}
    local platform = self.columns:get_column(mod.grid_x)

    if not platform or not platform:is_platform() then
        return false
    end

    return mod.grid_y == platform.btm_segment_id
end

function Station:module(module_slot_id)
    return ModuleInterface:new{
        column_collection = self.columns,
        column_module = Module:new{id = module_slot_id}
    }
end

function Station:planning_mode_is_active()
    return self.planning_mode == 1
end

return Station