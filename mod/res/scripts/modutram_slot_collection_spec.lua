local t = require('modutram_types')
local c = require('modutram_constants')
local Module = require('modutram_module')
local Position = require('modutram_position')
local ColumnCollection = require('modutram_column_collection')
local SlotBuilder = require('modutram_slot_builder')
local Platform = require('modutram_platform')

local SlotCollection = require('modutram_slot_collection')

local FLIPPED_IDENTITY_MATRIX = {
    -1, 0, 0, 0,
    0, -1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1,
}

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

    describe('import_platform', function ()
        it('imports platform', function ()
            local collection = SlotCollection:new{}
            local platform = Platform:new{type = t.PLATFORM_RIGHT, id = 0}

            platform:add_segment(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_RIGHT,
                    grid_x = 0,
                    grid_y = 0
                })
            })
            platform:add_segment(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_RIGHT,
                    grid_x = 0,
                    grid_y = 1
                })
            })

            collection:import_platform(platform, 1)

            assert.are.same({
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_RIGHT,
                    'btm',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_RIGHT_BTM, grid_x = 0, grid_y = -1}),
                    Position:new{x = 1, y = -10}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 0, grid_y = -1}),
                    Position:new{x = 1, y = -18}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 0, grid_y = 0}),
                    Position:new{x = 1, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 0, grid_y = 1}),
                    Position:new{x = 1, y = 18}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 0, grid_y = 2}),
                    Position:new{x = 1, y = 36}:as_matrix()
                ),
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_RIGHT,
                    'top',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_RIGHT_TOP, grid_x = 0, grid_y = 2}),
                    Position:new{x = 1, y = 28}:as_matrix()
                ),
            }, collection:get_slots())
        end)
    end)

    describe('import_from_column_collection', function ()
        it('import slots from station with one single platform right', function ()
            local slotCollection = SlotCollection:new{}
            local columnCollection = ColumnCollection:new{}
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_RIGHT,
                    grid_x = 0,
                    grid_y = 0
                })
            })
            columnCollection:calculate_x_positions()
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_RIGHT,
                    'btm',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_RIGHT_BTM, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -10}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -18}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 0, grid_y = 0}),
                    Position:new{x = 0, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 0, grid_y = 1}),
                    Position:new{x = 0, y = 18}:as_matrix()
                ),
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_RIGHT,
                    'top',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_RIGHT_TOP, grid_x = 0, grid_y = 1}),
                    Position:new{x = 0, y = 10}:as_matrix()
                ),
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM}:as_matrix()
                ),
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS / 2}:as_matrix()
                ),
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM}:as_matrix()
                )
            }, slotCollection:get_slots())
        end)

        it('import slots from station with two single platform right', function ()
            local slotCollection = SlotCollection:new{}
            local columnCollection = ColumnCollection:new{}
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_RIGHT,
                    grid_x = 0,
                    grid_y = 0
                })
            })
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_RIGHT,
                    grid_x = 0,
                    grid_y = 1
                })
            })
            columnCollection:calculate_x_positions()
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_RIGHT,
                    'btm',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_RIGHT_BTM, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -10}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -18}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 0, grid_y = 0}),
                    Position:new{x = 0, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 0, grid_y = 1}),
                    Position:new{x = 0, y = 18}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 0, grid_y = 2}),
                    Position:new{x = 0, y = 36}:as_matrix()
                ),
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_RIGHT,
                    'top',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_RIGHT_TOP, grid_x = 0, grid_y = 2}),
                    Position:new{x = 0, y = 28}:as_matrix()
                ),
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM}:as_matrix()
                ),
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS / 2}:as_matrix()
                ),
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM}:as_matrix()
                )
            }, slotCollection:get_slots())
        end)

        it('import slots from station with one single platform left', function ()
            local slotCollection = SlotCollection:new{}
            local columnCollection = ColumnCollection:new{}
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_LEFT,
                    grid_x = 0,
                    grid_y = 0
                })
            })
            columnCollection:calculate_x_positions()
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_LEFT,
                    'btm',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_LEFT_BTM, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -10}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -18}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 0, grid_y = 0}),
                    Position:new{x = 0, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 0, grid_y = 1}),
                    Position:new{x = 0, y = 18}:as_matrix()
                ),
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_LEFT,
                    'top',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_LEFT_TOP, grid_x = 0, grid_y = 1}),
                    Position:new{x = 0, y = 10}:as_matrix()
                ),
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.DISTANCE_BETWEEN_TWO_TRACKS / 2}:as_matrix()
                ),
                SlotBuilder.track_up_doors_right(
                    Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM}:as_matrix()
                ),
                SlotBuilder.track_up_doors_right(
                    Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM}:as_matrix()
                )
            }, slotCollection:get_slots())
        end)

        it('import slots from station with one single platform left', function ()
            local slotCollection = SlotCollection:new{}
            local columnCollection = ColumnCollection:new{}
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_LEFT,
                    grid_x = 0,
                    grid_y = 0
                })
            })
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_LEFT,
                    grid_x = 0,
                    grid_y = -1
                })
            })
            columnCollection:calculate_x_positions()
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_LEFT,
                    'btm',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_LEFT_BTM, grid_x = 0, grid_y = -2}),
                    Position:new{x = 0, y = -28}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 0, grid_y = -2}),
                    Position:new{x = 0, y = -36}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -18}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 0, grid_y = 0}),
                    Position:new{x = 0, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 0, grid_y = 1}),
                    Position:new{x = 0, y = 18}:as_matrix()
                ),
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_LEFT,
                    'top',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_LEFT_TOP, grid_x = 0, grid_y = 1}),
                    Position:new{x = 0, y = 10}:as_matrix()
                ),
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.DISTANCE_BETWEEN_TWO_TRACKS / 2}:as_matrix()
                ),
                SlotBuilder.track_up_doors_right(
                    Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM}:as_matrix()
                ),
                SlotBuilder.track_up_doors_right(
                    Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM}:as_matrix()
                )
            }, slotCollection:get_slots())
        end)

        it('import slots from station with one double platform', function ()
            local slotCollection = SlotCollection:new{}
            local columnCollection = ColumnCollection:new{}
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 0
                })
            })
            columnCollection:calculate_x_positions()
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_DOUBLE,
                    'btm',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_DOUBLE_BTM, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -10}:as_matrix()
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -18}:as_matrix()
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 0}),
                    Position:new{x = 0, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 1}),
                    Position:new{x = 0, y = 18}:as_matrix()
                ),
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_DOUBLE,
                    'top',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_DOUBLE_TOP, grid_x = 0, grid_y = 1}),
                    Position:new{x = 0, y = 10}:as_matrix()
                ),
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_DOUBLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.DISTANCE_BETWEEN_TWO_TRACKS / 2}:as_matrix()
                ),
                SlotBuilder.track_up_doors_right(
                    Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_DOUBLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM}:as_matrix()
                ),
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.PLATFORM_DOUBLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS / 2}:as_matrix()
                ),
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.PLATFORM_DOUBLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM}:as_matrix()
                )
            }, slotCollection:get_slots())
        end)

        it('import slots from station with two double platforms', function ()
            local slotCollection = SlotCollection:new{}
            local columnCollection = ColumnCollection:new{}
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 0
                })
            })
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 1
                })
            })
            columnCollection:calculate_x_positions()
            columnCollection:calculate_track_segment_range()
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_DOUBLE,
                    'btm',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_DOUBLE_BTM, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -10}:as_matrix()
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -18}:as_matrix()
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 0}),
                    Position:new{x = 0, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 1}),
                    Position:new{x = 0, y = 18}:as_matrix()
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 2}),
                    Position:new{x = 0, y = 36}:as_matrix()
                ),
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_DOUBLE,
                    'top',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_DOUBLE_TOP, grid_x = 0, grid_y = 2}),
                    Position:new{x = 0, y = 28}:as_matrix()
                ),
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_DOUBLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.DISTANCE_BETWEEN_TWO_TRACKS / 2}:as_matrix()
                ),
                SlotBuilder.track_up_doors_right(
                    Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_DOUBLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM}:as_matrix()
                ),
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.PLATFORM_DOUBLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS / 2}:as_matrix()
                ),
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.PLATFORM_DOUBLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM}:as_matrix()
                )
            }, slotCollection:get_slots())
        end)

        it('import slots from station with one track up', function ()
            local slotCollection = SlotCollection:new{}
            local columnCollection = ColumnCollection:new{}
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.TRACK_UP_DOORS_RIGHT,
                    grid_x = 0,
                    grid_y = 0
                })
            })
            columnCollection:calculate_x_positions()
            columnCollection:calculate_track_segment_range()
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
                SlotBuilder.street_connection_in(
                    Module.make_id({type = t.STREET_CONNECTION_IN, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -c.PLATFORM_SEGMENT_LENGTH * 1.5 - 1}:as_matrix()
                ),
                SlotBuilder.track_up_doors_right(
                    Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = 0, grid_y = 0}),
                    Position:new{x = 0, y = 0}:as_matrix()
                ),
                SlotBuilder.street_connection_out(
                    Module.make_id({type = t.STREET_CONNECTION_OUT, grid_x = 0, grid_y = 1}),
                    Position:new{x = 0, y = c.PLATFORM_SEGMENT_LENGTH * 1.5 + 1}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.PLATFORM_SINGLE_WIDTH / 2, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2, y = 0}:as_matrix()
                )
            }, slotCollection:get_slots())
        end)

        it('import slots from station with one track down', function ()
            local slotCollection = SlotCollection:new{}
            local columnCollection = ColumnCollection:new{}
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.TRACK_DOWN_DOORS_RIGHT,
                    grid_x = 0,
                    grid_y = 0
                })
            })
            columnCollection:calculate_x_positions()
            columnCollection:calculate_track_segment_range()
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
                SlotBuilder.street_connection_out(
                    Module.make_id({type = t.STREET_CONNECTION_OUT, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -c.PLATFORM_SEGMENT_LENGTH * 1.5 - 1}:add_to_matrix(FLIPPED_IDENTITY_MATRIX)
                ),
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 0, grid_y = 0}),
                    Position:new{x = 0, y = 0}:as_matrix()
                ),
                SlotBuilder.street_connection_in(
                    Module.make_id({type = t.STREET_CONNECTION_IN, grid_x = 0, grid_y = 1}),
                    Position:new{x = 0, y = c.PLATFORM_SEGMENT_LENGTH * 1.5 + 1}:add_to_matrix(FLIPPED_IDENTITY_MATRIX)
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.PLATFORM_DOUBLE_WIDTH / 2, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.PLATFORM_SINGLE_WIDTH / 2, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2, y = 0}:as_matrix()
                )
            }, slotCollection:get_slots())
        end)

        it('import slots from station with one track double', function ()
            local slotCollection = SlotCollection:new{}
            local columnCollection = ColumnCollection:new{}
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.TRACK_DOUBLE_DOORS_RIGHT,
                    grid_x = 0,
                    grid_y = 0
                })
            })
            columnCollection:calculate_x_positions()
            columnCollection:calculate_track_segment_range()
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
                SlotBuilder.street_connection_double(
                    Module.make_id({type = t.STREET_CONNECTION_DOUBLE, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -c.PLATFORM_SEGMENT_LENGTH * 1.5 - 1}:add_to_matrix(FLIPPED_IDENTITY_MATRIX)
                ),
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0}),
                    Position:new{x = 0, y = 0}:as_matrix()
                ),
                SlotBuilder.street_connection_double(
                    Module.make_id({type = t.STREET_CONNECTION_DOUBLE, grid_x = 0, grid_y = 1}),
                    Position:new{x = 0, y = c.PLATFORM_SEGMENT_LENGTH * 1.5 + 1}:as_matrix()
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.DISTANCE_BETWEEN_TWO_TRACKS / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.PLATFORM_DOUBLE_WIDTH / 2, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.DISTANCE_BETWEEN_TWO_TRACKS / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.PLATFORM_SINGLE_WIDTH / 2, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.DISTANCE_BETWEEN_TWO_TRACKS / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.DISTANCE_BETWEEN_TWO_TRACKS / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2, y = 0}:as_matrix()
                )
            }, slotCollection:get_slots())
        end)
        
        it('handles complex structures', function ()
            local slotCollection = SlotCollection:new{}
            local columnCollection = ColumnCollection:new{}
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_LEFT,
                    grid_x = 0,
                    grid_y = 0
                })
            })
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_LEFT,
                    grid_x = 0,
                    grid_y = 1
                })
            })
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_LEFT,
                    grid_x = 0,
                    grid_y = -1
                })
            })
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.TRACK_UP_DOORS_RIGHT,
                    grid_x = 1,
                    grid_y = 0
                })
            })
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 2,
                    grid_y = 0
                })
            })
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 2,
                    grid_y = 1
                })
            })
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.TRACK_DOWN_DOORS_RIGHT,
                    grid_x = 3,
                    grid_y = 0
                })
            })
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 2,
                    grid_y = 0
                })
            })
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.TRACK_DOUBLE_DOORS_RIGHT,
                    grid_x = -1,
                    grid_y = 0
                })
            })
            columnCollection:add(Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_RIGHT,
                    grid_x = -2,
                    grid_y = 0
                })
            })
            columnCollection:calculate_x_positions()
            columnCollection:calculate_track_segment_range()
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_LEFT,
                    'btm',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_LEFT_BTM, grid_x = 0, grid_y = -2}),
                    Position:new{x = 0, y = -28}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 0, grid_y = -2}),
                    Position:new{x = 0, y = -36}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 0, grid_y = -1}),
                    Position:new{x = 0, y = -18}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 0, grid_y = 0}),
                    Position:new{x = 0, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 0, grid_y = 1}),
                    Position:new{x = 0, y = 18}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 0, grid_y = 2}),
                    Position:new{x = 0, y = 36}:as_matrix()
                ),
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_LEFT,
                    'top',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_LEFT_TOP, grid_x = 0, grid_y = 2}),
                    Position:new{x = 0, y = 28}:as_matrix()
                ),
                SlotBuilder.street_connection_double(
                    Module.make_id({type = t.STREET_CONNECTION_DOUBLE, grid_x = -1, grid_y = -1}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.DISTANCE_BETWEEN_TWO_TRACKS / 2, y = -c.PLATFORM_SEGMENT_LENGTH * 2.5 - 1}:add_to_matrix(FLIPPED_IDENTITY_MATRIX)
                ),
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.DISTANCE_BETWEEN_TWO_TRACKS / 2}:as_matrix()
                ),
                SlotBuilder.street_connection_double(
                    Module.make_id({type = t.STREET_CONNECTION_DOUBLE, grid_x = -1, grid_y = 1}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.DISTANCE_BETWEEN_TWO_TRACKS / 2, y = c.PLATFORM_SEGMENT_LENGTH * 2.5 + 1}:as_matrix()
                ),
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_RIGHT,
                    'btm',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_RIGHT_BTM, grid_x = -2, grid_y = -1}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM * 2 - c.DISTANCE_BETWEEN_TWO_TRACKS, y = -10}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -2, grid_y = -1}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM * 2 - c.DISTANCE_BETWEEN_TWO_TRACKS, y = -18}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -2, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM * 2 - c.DISTANCE_BETWEEN_TWO_TRACKS, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -2, grid_y = 1}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM * 2 - c.DISTANCE_BETWEEN_TWO_TRACKS, y = 18}:as_matrix()
                ),
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_RIGHT,
                    'top',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_RIGHT_TOP, grid_x = -2, grid_y = 1}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM * 2 - c.DISTANCE_BETWEEN_TWO_TRACKS, y = 10}:as_matrix()
                ),
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = -3, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH * 1.5 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM * 3 - c.DISTANCE_BETWEEN_TWO_TRACKS}:as_matrix()
                ),
                SlotBuilder.street_connection_in(
                    Module.make_id({type = t.STREET_CONNECTION_IN, grid_x = 1, grid_y = -1}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, y = -c.PLATFORM_SEGMENT_LENGTH * 2.5 - 1}:as_matrix()
                ),
                SlotBuilder.track_up_doors_right(
                    Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM}:as_matrix()
                ),
                SlotBuilder.street_connection_out(
                    Module.make_id({type = t.STREET_CONNECTION_OUT, grid_x = 1, grid_y = 1}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, y = c.PLATFORM_SEGMENT_LENGTH * 2.5 + 1}:as_matrix()
                ),
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_DOUBLE,
                    'btm',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_DOUBLE_BTM, grid_x = 2, grid_y = -1}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + 2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2, y = -10}:as_matrix()
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = -1}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + 2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2, y = -18}:as_matrix()
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = 0}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + 2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2, y = 0}:as_matrix()
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = 1}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + 2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2, y = 18}:as_matrix()
                ),
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = 2}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + 2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2, y = 36}:as_matrix()
                ),
                SlotBuilder.platform_entrance_general(
                    t.PLATFORM_DOUBLE,
                    'top',
                    Module.make_id({type = t.PLATFORM_ENTRANCE_DOUBLE_TOP, grid_x = 2, grid_y = 2}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + 2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2, y = 28}:as_matrix()
                ),
                SlotBuilder.street_connection_out(
                    Module.make_id({type = t.STREET_CONNECTION_OUT, grid_x = 3, grid_y = -1}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM * 3 + c.PLATFORM_DOUBLE_WIDTH, y = -c.PLATFORM_SEGMENT_LENGTH * 1.5 - 1}:add_to_matrix(FLIPPED_IDENTITY_MATRIX)
                ),
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 3, grid_y = 0}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM * 3 + c.PLATFORM_DOUBLE_WIDTH}:as_matrix()
                ),
                SlotBuilder.street_connection_in(
                    Module.make_id({type = t.STREET_CONNECTION_IN, grid_x = 3, grid_y = 1}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM * 3 + c.PLATFORM_DOUBLE_WIDTH, y = c.PLATFORM_SEGMENT_LENGTH * 2.5 + 1}:add_to_matrix(FLIPPED_IDENTITY_MATRIX)
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 4, grid_y = 0}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM * 4 + c.PLATFORM_DOUBLE_WIDTH}:as_matrix()
                ),
            }, slotCollection:get_slots())
        end)
    end)

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
                SlotBuilder.platform_double(Module.make_id({type = t.PLATFORM_DOUBLE}), Position:new{}:as_matrix()),
                SlotBuilder.platform_single_left(Module.make_id({type = t.PLATFORM_LEFT}), Position:new{}:as_matrix()),
                SlotBuilder.platform_single_right(Module.make_id({type = t.PLATFORM_RIGHT}), Position:new{}:as_matrix()),
                SlotBuilder.track_double_doors_right(Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT}), Position:new{}:as_matrix()),
                SlotBuilder.track_up_doors_right(Module.make_id({type = t.TRACK_UP_DOORS_RIGHT}), Position:new{}:as_matrix()),
                SlotBuilder.track_down_doors_right(Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT}), Position:new{}:as_matrix()),
            }, collection:get_slots())
        end)
    end)

    describe('make_asset_slot', function ()
        it('makes new asset slot for asset', function ()
            local slot_collection = SlotCollection:new{}
            local segment_id = Module:make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = 1})
            local transformation_matrix = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                1, 2, 4, 1
            }

            local asset_slot = slot_collection:make_asset_slot(segment_id, 5, transformation_matrix)
            assert.are.equal(slot_collection, asset_slot.slot_collection)
            assert.are.equal(segment_id, asset_slot.segment_id)
            assert.are.same(transformation_matrix, asset_slot.transformation)
            assert.are.equal(5, asset_slot.asset_id)
        end)
    end)
end)