local PlatformBlueprint = {}
local Module = require('modutram_module')

function PlatformBlueprint:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function PlatformBlueprint:add_to_template(template)
    local start_segment, end_segment = math.ceil(-(self.platform_segments - 1) / 2), math.ceil((self.platform_segments - 1) / 2)
    for i = start_segment, end_segment do
        template[Module.make_id({type = self.platform_type, grid_x = self.platform_grid_x, grid_y = i})] = self.platform_segment_module
    end
end

return PlatformBlueprint