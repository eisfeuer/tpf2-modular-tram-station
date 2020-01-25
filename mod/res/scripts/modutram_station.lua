local ModelCollection = require('modutram_model_collection')
local ColumnCollection = require('modutram_column_collection')
local Module = require('modutram_module')
local SlotCollection = require('modutram_slot_collection')
local ModelBuilder = require('modutram_model_builder')
local PassengerPathBuilder = require('modutram_passenger_path_builder')
local TerrainAlignment = require('modutram_terrain_alignment')

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
        o.columns:add(Module:new{id = module_id})
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

    result.models = self:get_models()
    result.slots = self:get_slots()
    result.edgeLists = {}
    result.terminalGroups = self.terminal_groups

    result.terrainAlignmentLists = { TerrainAlignment.create_terrain_alignment_list_from_polygon(terrain_alignment_polygon) }
    result.groundFaces = { TerrainAlignment.create_ground_faces_from_polygon(terrain_alignment_polygon, "industry_floor_high_priority.gtex.lua",  "pedestrian_connection_border.lua") }

    result.terminateConstructionHook = function()	
        local passenger_path_builder = PassengerPathBuilder:new{
            column_collection = self.columns,
            passenger_path_models = {
                vertical_single_platform = 'station/tram/path/passenger_vertical_single_platform.mdl',
                vertical_double_platform = 'station/tram/path/passenger_vertical_double_platform_btm.mdl',
                horizontal_single_track = 'station/tram/path/passenger_horizontal_single_track.mdl',
                horizontal_double_track = 'station/tram/path/passenger_horizontal_double_track.mdl'
            }
        }

        passenger_path_builder:add_bottom_part_to_model_collection(self.models)
        passenger_path_builder:add_top_part_to_model_collection(self.models)
    end
    return result
end

return Station