local SlotCollection = {}
local Module = require('modutram_module')
local c = require('modutram_constants')
local t = require('modutram_types')
local Position = require('modutram_position')

local default_slots = {
    {
        id = Module.make_id({type = t.PLATFORM_DOUBLE}),
        transf = Position:new{}:as_matrix(),
        type = "eisfeuer_modutram_platform_double",
        spacing = {
            c.PLATFORM_DOUBLE_WIDTH / 2,
            c.PLATFORM_DOUBLE_WIDTH / 2,
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_SEGMENT_LENGTH
        }
    }, {
        id = Module.make_id({type = t.PLATFORM_LEFT}),
        transf = Position:new{}:as_matrix(),
        type = "eisfeuer_modutram_platform_single_left",
        spacing = {
            c.PLATFORM_SINGLE_WIDTH,
            c.PLATFORM_SINGLE_WIDTH,
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_SEGMENT_LENGTH
        }
    }, {
        id = Module.make_id({type = t.PLATFORM_RIGHT}),
        transf = Position:new{}:as_matrix(),
        type = "eisfeuer_modutram_platform_single_right",
        spacing = {
            c.PLATFORM_SINGLE_WIDTH,
            c.PLATFORM_SINGLE_WIDTH,
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_SEGMENT_LENGTH
        }
    }, {
        id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT}),
        transf = Position:new{}:as_matrix(),
        type = "eisfeuer_modutram_track_double_doors_right",
        spacing = {
            2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS,
            2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS,
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_SEGMENT_LENGTH
        }
    }, {
        id = Module.make_id({type = t.TRACK_UP_DOORS_RIGHT}),
        transf = Position:new{}:as_matrix(),
        type = "eisfeuer_modutram_track_up_doors_right",
        spacing = {
            2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
            2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_SEGMENT_LENGTH }
    }, {
        id = Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT}),
        transf = Position:new{}:as_matrix(),
        type = "eisfeuer_modutram_track_down_doors_right",
        spacing = {
            2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
            2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_SEGMENT_LENGTH }
    }
}

function SlotCollection:new (o)
    o = o or {}
    o.slots = o.slots or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SlotCollection:is_empty()
    return #self.slots == 0
end

function SlotCollection:get_slots()
    if self:is_empty() then
        return default_slots
    end
    return self.slots
end

return SlotCollection