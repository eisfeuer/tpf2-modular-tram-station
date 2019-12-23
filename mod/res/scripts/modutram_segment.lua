local c = require('modutram_constants')

local Segment = {}

function Segment:new (o)
    local id = o.id or 0

    o = o or {}
    o.y_pos = o.y_pos or id * c.PLATFORM_SEGMENT_LENGTH

    setmetatable(o, self)
    self.__index = self
    return o
end

return Segment