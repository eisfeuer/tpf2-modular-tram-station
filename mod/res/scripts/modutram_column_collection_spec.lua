local ColumnCollection = require('modutram_column_collection')
local Module = require('modutram_module')
local t = require('modutram_types')
local c = require('modutram_constants')

describe('ColumnCollection', function ()
    describe('new', function ()
        it('creates empty collection', function ()
            local collection = ColumnCollection:new{}
            assert.are.same({}, collection.columns)
        end)
    end)

    describe('add', function ()
        it('creates a new platform', function ()
            local collection = ColumnCollection:new{}
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 0
                })}
            )

            assert.are.equal(0, collection:get_column(0):find_segment(0).id)
        end)

        it('creates a new platform and calculates position', function ()
            local collection = ColumnCollection:new{}
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.TRACK_UP_DOORS_RIGHT,
                    grid_x = 0,
                    grid_y = 0
                })}
            )
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 1,
                    grid_y = 0
                })}
            )
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_LEFT,
                    grid_x = -1,
                    grid_y = 0
                })}
            )

            collection:calculate_x_positions()

            assert.are.equal(-1, collection:get_column(-1).id)
            assert.are.equal(-c.PLATFORM_SINGLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, collection:get_column(-1).x_pos)

            assert.are.equal(0, collection:get_column(0).id)
            assert.are.equal(0, collection:get_column(0).x_pos)

            assert.are.equal(1, collection:get_column(1).id)
            assert.are.equal(c.PLATFORM_DOUBLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, collection:get_column(1).x_pos)
        end)

        it('adds segment to platform', function ()
            local collection = ColumnCollection:new{}
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 0
                })}
            )
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 1
                })}
            )

            assert.are.equal(2, #collection:get_column(0).segments)
            assert.are.equal(1, collection:get_column(0):find_segment(1).id)
        end)

        it ('creates a new track', function ()
            local collection = ColumnCollection:new{}
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.TRACK_DOUBLE_DOORS_RIGHT,
                    grid_x = 0,
                    grid_y = 0
                })}
            )

            assert.are.equal(0, collection:get_column(0).id)
        end)

        it ('ignores other types', function ()
            local collection = ColumnCollection:new{}
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.STREET_CONNECTION_DOUBLE,
                    grid_x = 0,
                    grid_y = 0
                })}
            )

            assert.are.equal(nil, collection:get_column(0))
            assert.is_true(collection:is_empty())
        end)

        it ('creates a new track and calculates x position', function ()
            local collection = ColumnCollection:new{}
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 0
                })}
            )

            collection:add(
                Module:new{id = Module.make_id({
                    type = t.TRACK_DOUBLE_DOORS_RIGHT,
                    grid_x = 1,
                    grid_y = 0
                })}
            )

            collection:add(
                Module:new{id = Module.make_id({
                    type = t.TRACK_UP_DOORS_RIGHT,
                    grid_x = -1,
                    grid_y = 0
                })}
            )

            collection:calculate_x_positions()

            assert.are.equal(-1, collection:get_column(-1).id)
            assert.are.equal(-c.PLATFORM_DOUBLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, collection:get_column(-1).x_pos)

            assert.are.equal(0, collection:get_column(0).id)
            assert.are.equal(0, collection:get_column(0).x_pos)

            assert.are.equal(1, collection:get_column(1).id)
            assert.are.equal(c.PLATFORM_DOUBLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS / 2, collection:get_column(1).x_pos)
        end)
    end)

    describe('calculate_track_segment_range', function ()
        local collection = ColumnCollection:new{}
        it('it has one segment when track has no neighbors', function ()
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.TRACK_DOWN_DOORS_RIGHT,
                    grid_x = 0,
                    grid_y = 0
                })}
            )

            collection:calculate_track_segment_range()

            assert.are.equal(0, collection:get_column(0).top_segment_id)
            assert.are.equal(0, collection:get_column(0).btm_segment_id)
        end)

        it('it has segment range of neightbor platform when track has only one neightbor platform', function ()
            local collection = ColumnCollection:new{}
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 0
                })}
            )
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 1
                })}
            )
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.TRACK_DOWN_DOORS_RIGHT,
                    grid_x = 1,
                    grid_y = 0
                })}
            )

            collection:calculate_track_segment_range()

            assert.are.equal(1, collection:get_column(1).top_segment_id)
            assert.are.equal(0, collection:get_column(1).btm_segment_id)
        end)

        it('it has segment range of maximum top and bottom of both neighbors', function ()
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 0
                })}
            )
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 1
                })}
            )
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.TRACK_DOUBLE_DOORS_RIGHT,
                    grid_x = -1,
                    grid_y = 0
                })}
            )
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = -2,
                    grid_y = 0
                })}
            )
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = -2,
                    grid_y = -1
                })}
            )

            collection:calculate_track_segment_range()

            assert.are.equal(0, collection:get_column(-1).top_segment_id)
            assert.are.equal(-1, collection:get_column(-1).btm_segment_id)
        end)
    end)

    describe('is_empty', function ()
        local collection = ColumnCollection:new{}
        assert.is_true(collection:is_empty())
        collection:add(
            Module:new{id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 0,
                grid_y = 0
            })}
        )
        assert.is_false(collection:is_empty())
    end)

    describe('get_left_outer_column_grid_x', function ()
        local column_collection = ColumnCollection:new{}

        column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = -3, grid_y = 0})})

        column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -2, grid_y = 0})})
        column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -2, grid_y = 1})})

        column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = -1, grid_y = 0})})

        column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 0})})

        column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 1, grid_y = 0})})

        column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 2, grid_y = 0})})
        column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 2, grid_y = -1})})

        column_collection:calculate_track_segment_range()
        column_collection:calculate_x_positions()

        assert.are.equal(-3, column_collection:get_left_outer_column_grid_x())
    end)
end)