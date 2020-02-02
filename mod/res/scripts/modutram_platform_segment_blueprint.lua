local Module = require('modutram_module')
local PlatformSegmentBlueprint = {}

function PlatformSegmentBlueprint:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function PlatformSegmentBlueprint:add_asset(asset_id, asset_type, asset_module)
    self.template[Module.make_id({type = asset_type, grid_x = self.grid_x, grid_y = self.grid_y, asset_id = asset_id})] = asset_module
end

function PlatformSegmentBlueprint:is_platform_type(platform_type)
    return self.platform_type == platform_type
end

function PlatformSegmentBlueprint:get_current_segment()
    return self.grid_y
end

function PlatformSegmentBlueprint:is_top_platform_segment()
    return self:get_current_segment() == self.end_segment
end

function PlatformSegmentBlueprint:is_bottom_platform_segment()
    return self:get_current_segment() == self.start_segment
end

return PlatformSegmentBlueprint