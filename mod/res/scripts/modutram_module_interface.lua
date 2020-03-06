local t = require('modutram_types')

local ModuleInterface = {}

function ModuleInterface:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ModuleInterface:has_placed_asset_on_slot(asset_type, asset_slot, asset_module_name)
    return self.column_collection.asset_modules:is_placed_on_module(self.column_module, asset_type, asset_slot, asset_module_name)
end

function ModuleInterface:has_tram_tracks()
    return self:has_placed_asset_on_slot(t.ASSET_TRAM_TRACKS, 1)
end

function ModuleInterface:has_catenary()
    return self:has_placed_asset_on_slot(t.ASSET_CATENARY, 1)
end

function ModuleInterface:has_bus_lane()
    return self:has_placed_asset_on_slot(t.ASSET_BUS_LANE, 1)
end

function ModuleInterface:get_track()
    if self.column_module.grid_y ~= 0 then
        error ('asset is not placed on a track')
    end

    local track = self.column_collection:get_column(self.column_module.grid_x)
    if not track:is_track() then
        error ('asset is not placed on a track')
    end

    return track
end

function ModuleInterface:get_grid_x()
    return self.column_module.grid_x
end

function ModuleInterface:get_grid_y()
    return self.column_module.grid_y
end

return ModuleInterface