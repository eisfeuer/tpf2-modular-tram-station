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

return ModuleInterface