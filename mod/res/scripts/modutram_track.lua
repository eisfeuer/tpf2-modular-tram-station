local c = require('modutram_constants')
local t = require('modutram_types')

local Track = {}

function Track:new (o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self
    return o
end

function Track:is_track()
    return true
end

function Track:is_platform()
    return false
end

function Track:is_double_track()
    return self.type == t.TRACK_DOUBLE_DOORS_RIGHT
end

function Track:get_distance_from_center_to_platform_edge()
    if self:is_double_track() then
        return c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS / 2
    end
    return c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM
end

function Track:get_distance_to_neighbor(platform)
    if not platform:is_platform() then
        error('track neighbor must be a platform')
    end
    return platform:get_distance_to_neighbor(self)
end

function Track:set_x_position(x_pos)
    self.x_pos = x_pos
end

return Track