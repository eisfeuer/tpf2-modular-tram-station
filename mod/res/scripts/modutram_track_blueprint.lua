local TrackBlueprint = {}
local Module = require('modutram_module')
local c = require('modutram_constants')
local t = require('modutram_types')

function TrackBlueprint:new(o)
    o = o or {}
    o.template = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TrackBlueprint:add_to_template(template)
    template[Module.make_id({type = self.track_type, grid_x = self.track_grid_x})] = self.track_module

    for key, value in pairs(self.template) do
        template[key] = value
    end

    return template
end

function TrackBlueprint:add_bus_lane(custom_bus_lane_module)
    local bus_lane_module = custom_bus_lane_module or c.DEFAULT_BUS_LANE_MODULE
    self.template[Module.make_id({type = t.ASSET_BUS_LANE, grid_x = self.track_grid_x, asset_id = 1})] = bus_lane_module
end

function TrackBlueprint:add_tram_tracks(tram_tracks_module)
    self.template[Module.make_id({type = t.ASSET_TRAM_TRACKS, grid_x = self.track_grid_x, asset_id = 1})] = tram_tracks_module
end

function TrackBlueprint:add_catenary(catenary_module)
    self.template[Module.make_id({type = t.ASSET_CATENARY, grid_x = self.track_grid_x, asset_id = 1})] = catenary_module
end

function TrackBlueprint:add_street_connection_top(custom_street_connection_modules)
    local street_connection_modules = custom_street_connection_modules or c.DEFAULT_STREET_CONNECTION_MODULES
    local street_connection_module_mapping = {
        [t.TRACK_UP_DOORS_RIGHT] = {
            type = t.STREET_CONNECTION_OUT,
            module = street_connection_modules['connection_out']
        },
        [t.TRACK_DOWN_DOORS_RIGHT] = {
            type = t.STREET_CONNECTION_IN,
            module = street_connection_modules['connection_in']
        },
        [t.TRACK_DOUBLE_DOORS_RIGHT] = {
            type = t.STREET_CONNECTION_DOUBLE,
            module = street_connection_modules['connection_double']
        }
    }

    self.template[Module.make_id({
        type = street_connection_module_mapping[self.track_type].type,
        grid_x = self.track_grid_x,
        grid_y = 1
    })] = street_connection_module_mapping[self.track_type].module
end

function TrackBlueprint:add_street_connection_bottom(custom_street_connection_modules)
    local street_connection_modules = custom_street_connection_modules or c.DEFAULT_STREET_CONNECTION_MODULES
    local street_connection_module_mapping = {
        [t.TRACK_UP_DOORS_RIGHT] = {
            type = t.STREET_CONNECTION_IN,
            module = street_connection_modules['connection_in']
        },
        [t.TRACK_DOWN_DOORS_RIGHT] = {
            type = t.STREET_CONNECTION_OUT,
            module = street_connection_modules['connection_out']
        },
        [t.TRACK_DOUBLE_DOORS_RIGHT] = {
            type = t.STREET_CONNECTION_DOUBLE,
            module = street_connection_modules['connection_double']
        }
    }

    self.template[Module.make_id({
        type = street_connection_module_mapping[self.track_type].type,
        grid_x = self.track_grid_x,
        grid_y = -1
    })] = street_connection_module_mapping[self.track_type].module
end

return TrackBlueprint