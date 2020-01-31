local PlatformBlueprint = {}
local SegmentBlueprint = require('modutram_platform_segment_blueprint')
local Module = require('modutram_module')

function PlatformBlueprint:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.decoration_functions = {}
    return o
end

function PlatformBlueprint:set_segment_decorations(decoration_functions)
    self.decoration_functions = decoration_functions
end

function PlatformBlueprint:add_to_template(template)
    local start_segment, end_segment = math.ceil(-(self.platform_segments - 1) / 2), math.ceil((self.platform_segments - 1) / 2)
    for i = start_segment, end_segment do
        template[Module.make_id({type = self.platform_type, grid_x = self.platform_grid_x, grid_y = i})] = self.platform_segment_module
        for index, func in ipairs(self.decoration_functions) do
            local segment_blueprint = SegmentBlueprint:new{
                platform_type = self.platform_type,
                grid_x = self.platform_grid_x,
                grid_y = i,
                start_segment = start_segment,
                end_segment = end_segment,
                template = template
            }

            func(segment_blueprint)
        end
        
    end
end

return PlatformBlueprint