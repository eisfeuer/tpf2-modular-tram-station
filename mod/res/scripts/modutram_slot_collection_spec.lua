local t = require('modutram_types')
local c = require('modutram_constants')
local Module = require('modutram_module')
local Position = require('modutram_position')
local ColumnCollection = require('modutram_column_collection')
local SlotBuilder = require('modutram_slot_builder')
local Platform = require('modutram_platform')

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
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
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
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
                SlotBuilder.track_up_doors_right(
                    Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = 0, grid_y = 0}),
                    Position:new{x = 0, y = 0}:as_matrix()
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
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 0, grid_y = 0}),
                    Position:new{x = 0, y = 0}:as_matrix()
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
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0}),
                    Position:new{x = 0, y = 0}:as_matrix()
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
            slotCollection:import_from_column_collection(columnCollection)

            assert.are.same({
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
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = -1, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.DISTANCE_BETWEEN_TWO_TRACKS / 2}:as_matrix()
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
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = -3, grid_y = 0}),
                    Position:new{x = -c.PLATFORM_SINGLE_WIDTH * 1.5 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM * 3 - c.DISTANCE_BETWEEN_TWO_TRACKS}:as_matrix()
                ),
                SlotBuilder.track_up_doors_right(
                    Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = 1, grid_y = 0}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM}:as_matrix()
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
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 3, grid_y = 0}),
                    Position:new{x = c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM * 3 + c.PLATFORM_DOUBLE_WIDTH}:as_matrix()
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