local NatBomb = require('natbomb')
local t = require('modutram_types')

local DIGIT_SPACES = {7, 7, 6, 4}

local Module = {}

local function to_signed_id(unsigned_id)
    if unsigned_id then
        return unsigned_id - 64
    end
    return 0
end

function Module:new (o)
    local ids = NatBomb.explode(DIGIT_SPACES, o.id or 0)

    o = o or {}
    o.type = ids[1] or t.UNKNOWN
    o.grid_x = to_signed_id(ids[2])
    o.grid_y = to_signed_id(ids[3])
    o.asset_id = ids[4] or 0
    o.asset_decoration_id = ids[5] or 0

    setmetatable(o, self)
    self.__index = self
    return o
end

function Module.make_id(options)
    return NatBomb.implode(DIGIT_SPACES, {
        options.type or t.UNKNOWN,
        (options.grid_x or 0) + 64,
        (options.grid_y or 0) + 64,
        options.asset_id or 0,
        options.asset_decoration_id or 0
    })
end

return Module