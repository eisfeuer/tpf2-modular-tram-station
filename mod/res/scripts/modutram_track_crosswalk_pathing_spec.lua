local ColumnCollection = require('modutram_column_collection')
local Module = require('modutram_module')
local ModelCollection = require('modutram_model_collection')
local t = require('modutram_types')
local c = require('modutram_constants')
local Position = require('modutram_position')
local TrackCrosswayPathing = require('modutram_track_crosswalk_pathing')

describe("TrackCrosswalkPathing", function ()
    describe('get_bottom_crosswalk_y_position', function ()
        it ('gets y position of bottom of right platform when left platform does not exists', function ()
            local column_collection = ColumnCollection:new{}
            column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1})})
            column_collection:calculate_track_segment_range()
            column_collection:calculate_x_positions()

            local pathing = TrackCrosswayPathing:new{
                left_platform = nil,
                right_platform = column_collection:get_column(1),
                track = column_collection:get_column(0)
            }

            assert.are.equal(-1, pathing:get_bottom_crosswalk_y_position())
        end)

        it ('gets y position of bottom of left platform when right platform does not exists', function ()
            local column_collection = ColumnCollection:new{}
            column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = -1})})
            column_collection:calculate_track_segment_range()
            column_collection:calculate_x_positions()

            local pathing = TrackCrosswayPathing:new{
                left_platform = column_collection:get_column(-1),
                right_platform = nil,
                track = column_collection:get_column(0)
            }

            assert.are.equal(-1, pathing:get_bottom_crosswalk_y_position())
        end)

        it ('gets y position 1', function ()
            local column_collection = ColumnCollection:new{}
            column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -1})})
            column_collection:calculate_track_segment_range()
            column_collection:calculate_x_positions()

            local pathing = TrackCrosswayPathing:new{
                left_platform = column_collection:get_column(-1),
                right_platform = column_collection:get_column(1),
                track = column_collection:get_column(0)
            }

            assert.are.equal(-1, pathing:get_bottom_crosswalk_y_position())
        end)

        it ('gets y position 2', function ()
            local column_collection = ColumnCollection:new{}
            column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -1})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -2})})
            column_collection:calculate_track_segment_range()
            column_collection:calculate_x_positions()

            local pathing = TrackCrosswayPathing:new{
                left_platform = column_collection:get_column(-1),
                right_platform = column_collection:get_column(1),
                track = column_collection:get_column(0)
            }

            assert.are.equal(-2, pathing:get_bottom_crosswalk_y_position())
        end)
    end)

    describe('add_crosswalk_to_model_collection', function ()
        it ('adds track crossway path model to model collection (left platform only)', function ()
            local column_collection = ColumnCollection:new{}
            column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1})})
            column_collection:calculate_track_segment_range()
            column_collection:calculate_x_positions()

            local pathing = TrackCrosswayPathing:new{
                left_platform = nil,
                right_platform = column_collection:get_column(1),
                track = column_collection:get_column(0)
            }

            local model_collection = ModelCollection:new()
            pathing:add_bottom_crosswalk_to_model_collection(model_collection, 'model.mdl')

            assert.are.same({{
                id = "model.mdl",
                transf = Position:new{x = column_collection:get_column(0).x_pos, y = - 2.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
            }}, model_collection.models)
        end)

        it ('adds track crossway path model to model collection (right platform only)', function ()
            local column_collection = ColumnCollection:new{}
            column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = -1})})
            column_collection:calculate_track_segment_range()
            column_collection:calculate_x_positions()

            local pathing = TrackCrosswayPathing:new{
                left_platform = column_collection:get_column(-1),
                right_platform = nil,
                track = column_collection:get_column(0)
            }

            local model_collection = ModelCollection:new()
            pathing:add_bottom_crosswalk_to_model_collection(model_collection, 'model.mdl')

            assert.are.same({{
                id = "model.mdl",
                transf = Position:new{x = column_collection:get_column(0).x_pos, y = - 2.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
            }}, model_collection.models)
        end)

        it ('adds track crossway path model to model collection (equal platform position)', function ()
            local column_collection = ColumnCollection:new{}
            column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -1})})
            column_collection:calculate_track_segment_range()
            column_collection:calculate_x_positions()

            local pathing = TrackCrosswayPathing:new{
                left_platform = column_collection:get_column(-1),
                right_platform = column_collection:get_column(1),
                track = column_collection:get_column(0)
            }

            local model_collection = ModelCollection:new()
            pathing:add_bottom_crosswalk_to_model_collection(model_collection, 'model.mdl')

            assert.are.same({{
                id = "model.mdl",
                transf = Position:new{x = column_collection:get_column(0).x_pos, y = - 2.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
            }}, model_collection.models)
        end)

        it ('adds track crossway path model to model collection (unequal platform position)', function ()
            local column_collection = ColumnCollection:new{}
            column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -1})})
            column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -2})})
            column_collection:calculate_track_segment_range()
            column_collection:calculate_x_positions()

            local pathing = TrackCrosswayPathing:new{
                left_platform = column_collection:get_column(-1),
                right_platform = column_collection:get_column(1),
                track = column_collection:get_column(0)
            }

            local model_collection = ModelCollection:new()
            pathing:add_bottom_crosswalk_to_model_collection(model_collection, 'model.mdl')

            assert.are.same({{
                id = "model.mdl",
                transf = Position:new{x = column_collection:get_column(0).x_pos, y = - 3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
            }}, model_collection.models)
        end)

        describe('add_bottom_left_vertical_pathes_to_model_collection', function ()
            it ('adds no vertical passenger pathes to model collection when left platform is nil', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local pathing = TrackCrosswayPathing:new{
                    left_platform = nil,
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }

                local model_collection = ModelCollection:new()
                pathing:add_bottom_left_vertical_pathes_to_model_collection(model_collection, 'model.mdl', nil)

                assert.are.same({}, model_collection.models)
            end)

            it ('adds no vertical passenger pathes to model collection when left platform is larger then the right one', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -2})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }

                local model_collection = ModelCollection:new()
                pathing:add_bottom_left_vertical_pathes_to_model_collection(model_collection, 'model.mdl', nil)

                assert.are.same({}, model_collection.models)
            end)

            it ('adds no vertical passenger pathes to model collection when both platforms are equal', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }

                local model_collection = ModelCollection:new()
                pathing:add_bottom_left_vertical_pathes_to_model_collection(model_collection, 'model.mdl', nil)

                assert.are.same({}, model_collection.models)
            end)

            it ('adds vertical passenger pathes to model collection when last crosswalk is larger the the platform', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -2})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }

                local model_collection = ModelCollection:new()
                pathing:add_bottom_left_vertical_pathes_to_model_collection(model_collection, 'model.mdl', -3)

                assert.are.same({{
                    id = 'model.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = -4 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }}, model_collection.models)
            end)

            it ('adds vertical passenger pathes to model collection when right platform is larger then the left', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -2})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }

                local model_collection = ModelCollection:new()
                pathing:add_bottom_left_vertical_pathes_to_model_collection(model_collection, 'model.mdl', nil)

                assert.are.same({{
                    id = 'model.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = -3 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }}, model_collection.models)
            end)

            it ('adds vertical pathes from the last crossway', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -2})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -3})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }

                local model_collection = ModelCollection:new()
                pathing:add_bottom_left_vertical_pathes_to_model_collection(model_collection, 'model.mdl', -2)

                assert.are.same({{
                    id = 'model.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = -3 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'model.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = -4 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }}, model_collection.models)
            end)

            it ('adds vertical pathes to the last crossway when last crossway is largen then current crossway', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }

                local model_collection = ModelCollection:new()
                pathing:add_bottom_left_vertical_pathes_to_model_collection(model_collection, 'model.mdl', -2)

                assert.are.same({{
                    id = 'model.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = -3 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }}, model_collection.models)
            end)
        end)

        describe('get_top_crosswalk_y_position', function ()
            it ('gets y position of bottom of right platform when left platform does not exists', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()
    
                local pathing = TrackCrosswayPathing:new{
                    left_platform = nil,
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }
    
                assert.are.equal(1, pathing:get_top_crosswalk_y_position())
            end)
    
            it ('gets y position of bottom of left platform when right platform does not exists', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()
    
                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = nil,
                    track = column_collection:get_column(0)
                }
    
                assert.are.equal(1, pathing:get_top_crosswalk_y_position())
            end)
    
            it ('gets y position 1', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()
    
                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }
    
                assert.are.equal(1, pathing:get_top_crosswalk_y_position())
            end)
    
            it ('gets y position 2', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 2})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()
    
                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }
    
                assert.are.equal(2, pathing:get_top_crosswalk_y_position())
            end)
        end)

        describe('add_top_crosswalk_to_model_collection', function ()
            it ('adds track crossway path model to model collection (left platform only)', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()
    
                local pathing = TrackCrosswayPathing:new{
                    left_platform = nil,
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }
    
                local model_collection = ModelCollection:new()
                pathing:add_top_crosswalk_to_model_collection(model_collection, 'model.mdl')
    
                assert.are.same({{
                    id = "model.mdl",
                    transf = Position:new{x = column_collection:get_column(0).x_pos, y = 2.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }}, model_collection.models)
            end)
    
            it ('adds track crossway path model to model collection (right platform only)', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()
    
                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = nil,
                    track = column_collection:get_column(0)
                }
    
                local model_collection = ModelCollection:new()
                pathing:add_top_crosswalk_to_model_collection(model_collection, 'model.mdl')
    
                assert.are.same({{
                    id = "model.mdl",
                    transf = Position:new{x = column_collection:get_column(0).x_pos, y = 2.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }}, model_collection.models)
            end)
    
            it ('adds track crossway path model to model collection (equal platform position)', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()
    
                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }
    
                local model_collection = ModelCollection:new()
                pathing:add_top_crosswalk_to_model_collection(model_collection, 'model.mdl')
    
                assert.are.same({{
                    id = "model.mdl",
                    transf = Position:new{x = column_collection:get_column(0).x_pos, y = 2.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }}, model_collection.models)
            end)
    
            it ('adds track crossway path model to model collection (unequal platform position)', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 2})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()
    
                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }
    
                local model_collection = ModelCollection:new()
                pathing:add_top_crosswalk_to_model_collection(model_collection, 'model.mdl')
    
                assert.are.same({{
                    id = "model.mdl",
                    transf = Position:new{x = column_collection:get_column(0).x_pos, y = 3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }}, model_collection.models)
            end)
        end)

        describe('add_top_left_vertical_pathes_to_model_collection', function ()
            it ('adds no vertical passenger pathes to model collection when left platform is nil', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local pathing = TrackCrosswayPathing:new{
                    left_platform = nil,
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }

                local model_collection = ModelCollection:new()
                pathing:add_top_left_vertical_pathes_to_model_collection(model_collection, 'model.mdl', nil)

                assert.are.same({}, model_collection.models)
            end)

            it ('adds no vertical passenger pathes to model collection when left platform is larger then the right one', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 2})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }

                local model_collection = ModelCollection:new()
                pathing:add_top_left_vertical_pathes_to_model_collection(model_collection, 'model.mdl', nil)

                assert.are.same({}, model_collection.models)
            end)

            it ('adds no vertical passenger pathes to model collection when both platforms are equal', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }

                local model_collection = ModelCollection:new()
                pathing:add_top_left_vertical_pathes_to_model_collection(model_collection, 'model.mdl', nil)

                assert.are.same({}, model_collection.models)
            end)

            it ('adds vertical passenger pathes to model collection when last crosswalk is larger the the platform', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 2})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }

                local model_collection = ModelCollection:new()
                pathing:add_top_left_vertical_pathes_to_model_collection(model_collection, 'model.mdl', 3)

                assert.are.same({{
                    id = 'model.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = 4 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }}, model_collection.models)
            end)

            it ('adds vertical passenger pathes to model collection when right platform is larger then the left', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 2})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }

                local model_collection = ModelCollection:new()
                pathing:add_top_left_vertical_pathes_to_model_collection(model_collection, 'model.mdl', nil)

                assert.are.same({{
                    id = 'model.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = 3 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }}, model_collection.models)
            end)

            it ('adds vertical pathes from the last crossway', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 2})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 3})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }

                local model_collection = ModelCollection:new()
                pathing:add_top_left_vertical_pathes_to_model_collection(model_collection, 'model.mdl', 2)

                assert.are.same({{
                    id = 'model.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = 3 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'model.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = 4 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }}, model_collection.models)
            end)

            it ('adds vertical pathes to the last crossway when last crossway is largen then current crossway', function ()
                local column_collection = ColumnCollection:new{}
                column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
                column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 1})})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local pathing = TrackCrosswayPathing:new{
                    left_platform = column_collection:get_column(-1),
                    right_platform = column_collection:get_column(1),
                    track = column_collection:get_column(0)
                }

                local model_collection = ModelCollection:new()
                pathing:add_top_left_vertical_pathes_to_model_collection(model_collection, 'model.mdl', 2)

                assert.are.same({{
                    id = 'model.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = 3 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }}, model_collection.models)
            end)
        end)

    end)
end)