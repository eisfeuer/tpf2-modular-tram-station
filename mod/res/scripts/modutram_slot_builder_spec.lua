local SlotBuilder = require('modutram_slot_builder')
local Module = require('modutram_module')
local c = require('modutram_constants')
local t = require('modutram_types')
local Position = require('modutram_position')

describe('SlotBuilder', function ()
    describe('platform_double', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.PLATFORM_DOUBLE}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_platform_double",
                spacing = {
                    c.PLATFORM_SEGMENT_LENGTH,
                    c.PLATFORM_SEGMENT_LENGTH,
                    c.PLATFORM_DOUBLE_WIDTH / 2,
                    c.PLATFORM_DOUBLE_WIDTH / 2,
                }
            }, SlotBuilder.platform_double(
                Module.make_id({type = t.PLATFORM_DOUBLE}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('platform_single_left', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.PLATFORM_LEFT}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_platform_single_left",
                spacing = {
                    c.PLATFORM_SEGMENT_LENGTH,
                    c.PLATFORM_SEGMENT_LENGTH,
                    c.PLATFORM_SINGLE_WIDTH,
                    c.PLATFORM_SINGLE_WIDTH,
                }
            }, SlotBuilder.platform_single_left(
                Module.make_id({type = t.PLATFORM_LEFT}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('platform_single_right', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.PLATFORM_RIGHT}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_platform_single_right",
                spacing = {
                    c.PLATFORM_SEGMENT_LENGTH,
                    c.PLATFORM_SEGMENT_LENGTH,
                    c.PLATFORM_SINGLE_WIDTH,
                    c.PLATFORM_SINGLE_WIDTH,
                }
            }, SlotBuilder.platform_single_right(
                Module.make_id({type = t.PLATFORM_RIGHT}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('track_double_doors_right', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_track_double_doors_right",
                spacing = {
                    c.PLATFORM_SEGMENT_LENGTH,
                    c.PLATFORM_SEGMENT_LENGTH,
                    2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS,
                    2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS,
                }
            }, SlotBuilder.track_double_doors_right(
                Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('track_up_doors_right', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.TRACK_UP_DOORS_RIGHT}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_track_up_doors_right",
                spacing = {
                    c.PLATFORM_SEGMENT_LENGTH,
                    c.PLATFORM_SEGMENT_LENGTH,
                    2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
                    2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
                }
            }, SlotBuilder.track_up_doors_right(
                Module.make_id({type = t.TRACK_UP_DOORS_RIGHT}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('track_down_doors_right', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_track_down_doors_right",
                spacing = {
                    c.PLATFORM_SEGMENT_LENGTH,
                    c.PLATFORM_SEGMENT_LENGTH,
                    2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
                    2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
                }
            }, SlotBuilder.track_down_doors_right(
                Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT}),
                Position:new{}:as_matrix()
            ))
        end)
    end)
end)