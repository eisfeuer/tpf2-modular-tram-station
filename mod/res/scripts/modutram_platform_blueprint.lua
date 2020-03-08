local PlatformBlueprint = {}
local SegmentBlueprint = require('modutram_platform_segment_blueprint')
local Module = require('modutram_module')
local t = require('modutram_types')

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

    if self.has_platform_access_top then
        local slots_by_platform_type = {
            [t.PLATFORM_DOUBLE] = t.PLATFORM_ENTRANCE_DOUBLE_TOP,
            [t.PLATFORM_LEFT] = t.PLATFORM_ENTRANCE_SINGLE_LEFT_TOP,
            [t.PLATFORM_RIGHT] = t.PLATFORM_ENTRANCE_SINGLE_RIGHT_TOP
        }

        template[Module.make_id({type = slots_by_platform_type[self.platform_type], grid_x = self.platform_grid_x, grid_y = end_segment + 1})] = self.platform_access_module
    end

    if self.has_platform_access_btm then
        local slots_by_platform_type = {
            [t.PLATFORM_DOUBLE] = t.PLATFORM_ENTRANCE_DOUBLE_BTM,
            [t.PLATFORM_LEFT] = t.PLATFORM_ENTRANCE_SINGLE_LEFT_BTM,
            [t.PLATFORM_RIGHT] = t.PLATFORM_ENTRANCE_SINGLE_RIGHT_BTM
        }

        template[Module.make_id({type = slots_by_platform_type[self.platform_type], grid_x = self.platform_grid_x, grid_y = start_segment - 1})] = self.platform_access_module
    end
end

return PlatformBlueprint