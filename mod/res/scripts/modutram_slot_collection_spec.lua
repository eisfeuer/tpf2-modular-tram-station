local t = require('modutram_types')
local c = require('modutram_constants')
local Module = require('modutram_module')
local Position = require('modutram_position')

local SlotCollection = require('modutram_slot_collection')

describe('SlotCollection', function ()
    local identity_matrix = {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    }

    describe('new', function ()
        it('has slots', function ()
            local collection = SlotCollection:new{}
            assert.are.same({}, collection.slots)
        end)
    end)

    -- describe('import_from_column_collection', function ()
        
    -- end)

    describe('is_empty', function ()
        it('is_empty when collection has not slots', function ()
            local collection = SlotCollection:new{}
            assert.is_true(collection:is_empty())
            local collection2 = SlotCollection:new{slots = {
                {
                    id = '34578',
                    name = 'a_slot',
                    transf = identity_matrix
                }
            }}
            assert.is_false(collection2:is_empty())
        end)
    end)

    describe('get_slots', function ()
        it('generates all track and platform slots on center when slots are empty', function ()
            local collection = SlotCollection:new{}
            assert.are.same({
                {
                    id = Module.make_id({type = t.PLATFORM_DOUBLE}),
                    transf = Position:new{}:as_matrix(),
                    type = "eisfeuer_modutram_platform_double",
                    spacing = {
                        c.PLATFORM_SEGMENT_LENGTH,
                        c.PLATFORM_SEGMENT_LENGTH,
                        c.PLATFORM_DOUBLE_WIDTH / 2,
                        c.PLATFORM_DOUBLE_WIDTH / 2,
                    }
                }, {
                    id = Module.make_id({type = t.PLATFORM_LEFT}),
                    transf = Position:new{}:as_matrix(),
                    type = "eisfeuer_modutram_platform_single_left",
                    spacing = {
                        c.PLATFORM_SEGMENT_LENGTH,
                        c.PLATFORM_SEGMENT_LENGTH,
                        c.PLATFORM_SINGLE_WIDTH,
                        c.PLATFORM_SINGLE_WIDTH,
                    }
                }, {
                    id = Module.make_id({type = t.PLATFORM_RIGHT}),
                    transf = Position:new{}:as_matrix(),
                    type = "eisfeuer_modutram_platform_single_right",
                    spacing = {
                        c.PLATFORM_SEGMENT_LENGTH,
                        c.PLATFORM_SEGMENT_LENGTH,
                        c.PLATFORM_SINGLE_WIDTH,
                        c.PLATFORM_SINGLE_WIDTH,
                    }
                }, {
                    id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT}),
                    transf = Position:new{}:as_matrix(),
                    type = "eisfeuer_modutram_track_double_doors_right",
                    spacing = {
                        c.PLATFORM_SEGMENT_LENGTH,
                        c.PLATFORM_SEGMENT_LENGTH,
                        2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS,
                        2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS,
                    }
                }, {
                    id = Module.make_id({type = t.TRACK_UP_DOORS_RIGHT}),
                    transf = Position:new{}:as_matrix(),
                    type = "eisfeuer_modutram_track_up_doors_right",
                    spacing = {
                        c.PLATFORM_SEGMENT_LENGTH,
                        c.PLATFORM_SEGMENT_LENGTH,
                        2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
                        2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
                    }
                }, {
                    id = Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT}),
                    transf = Position:new{}:as_matrix(),
                    type = "eisfeuer_modutram_track_down_doors_right",
                    spacing = {
                        c.PLATFORM_SEGMENT_LENGTH,
                        c.PLATFORM_SEGMENT_LENGTH,
                        2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
                        2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
                    }
                }
            }, collection:get_slots())
        end)
    end)
end)