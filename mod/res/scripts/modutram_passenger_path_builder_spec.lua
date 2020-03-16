local ColumnCollection = require('modutram_column_collection')
local Module = require('modutram_module')
local ModelCollection = require('modutram_model_collection')
local t = require('modutram_types')
local c = require('modutram_constants')
local Position = require('modutram_position')

local PassengerPathBuilder = require('modutram_passenger_path_builder')

local function setup_scenario_1(direction)
    local column_collection = ColumnCollection:new{}

    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -3, grid_y = 0})})
    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -3, grid_y = 1 * direction})})
    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -3, grid_y = 2 * direction})})

    column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = -2, grid_y = 0})})

    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0})})
    
    column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = 0, grid_y = 0})})

    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 1, grid_y = 0})})
    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 1, grid_y = 1 * direction})})

    column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 2, grid_y = 0})})

    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 3, grid_y = 0})})
    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 3, grid_y = 1 * direction})})
    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 3, grid_y = 2 * direction})})

    column_collection:calculate_track_segment_range()
    column_collection:calculate_x_positions()
    return column_collection
end

local function setup_scenario_2(direction)
    local column_collection = ColumnCollection:new{}

    column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = -3, grid_y = 0})})

    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -2, grid_y = 0})})
    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -2, grid_y = 1 * direction})})
    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -2, grid_y = 2 * direction})})

    column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = -1, grid_y = 0})})

    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 0})})
    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 1 * direction})})

    column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 1, grid_y = 0})})

    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 2, grid_y = 0})})
    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 2, grid_y = 1 * direction})})
    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 2, grid_y = 2 * direction})})
    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 2, grid_y = 3 * direction})})

    column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 3, grid_y = 0})})

    column_collection:calculate_track_segment_range()
    column_collection:calculate_x_positions()

    return column_collection
end

local function setup_scenario_3(direction)
    local column_collection = ColumnCollection:new{}

    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0})})
    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = direction})})

    column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})

    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})})

    column_collection:calculate_track_segment_range()
    column_collection:calculate_x_positions()

    return column_collection
end

describe('PassengerPathBuilder', function ()
    describe('add_bottom_part_to_model_collection', function ()
        it ('adds no path models when station has no platforms', function ()
            local model_collection = ModelCollection:new{}

            local column_collection = ColumnCollection:new{}
            column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
            column_collection:calculate_x_positions()

            local passenger_path_builder = PassengerPathBuilder:new{
                column_collection = column_collection,
                passenger_path_models = {
                    vertical_single_platform = 'v_single.mdl',
                    vertical_double_platform = 'v_double.mdl',
                    horizontal_single_track = 'h_single_track.mdl',
                    horizontal_double_track = 'h_double_track.mdl',
                    street_link = 'street_link.mdl'
                }
            }
            passenger_path_builder:add_bottom_part_to_model_collection(model_collection)

            assert.are.same({}, model_collection.models)
        end)

        it ('adds bottom path models to model collection 1', function ()
            local column_collection = setup_scenario_1(-1)
            local model_collection = ModelCollection:new{}

            local passenger_path_builder = PassengerPathBuilder:new{
                column_collection = column_collection,
                passenger_path_models = {
                    vertical_single_platform = 'v_single.mdl',
                    vertical_double_platform = 'v_double.mdl',
                    horizontal_single_track = 'h_single_track.mdl',
                    horizontal_double_track = 'h_double_track.mdl',
                    street_link_left = 'street_link_left.mdl',
                    street_link_right = 'street_link_right.mdl'
                }
            }
            passenger_path_builder:add_bottom_part_to_model_collection(model_collection)

            assert.are.same({
                {
                    id = 'street_link_left.mdl',
                    transf = Position:new{x = column_collection:get_column(-3).x_pos, y = -3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'h_double_track.mdl',
                    transf = Position:new{x = column_collection:get_column(-2).x_pos, y = -3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'v_single.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = -2 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'v_single.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = -3 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                  id = 'h_single_track.mdl',
                    transf = Position:new{x = column_collection:get_column(0).x_pos, y = -2.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'v_double.mdl',
                    transf = Position:new{x = column_collection:get_column(1).x_pos, y = -3 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'h_double_track.mdl',
                    transf = Position:new{x = column_collection:get_column(2).x_pos, y = -3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'street_link_right.mdl',
                    transf = Position:new{x = column_collection:get_column(3).x_pos, y = -3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }
                
            }, model_collection.models)
        end)

        it ('adds bottom path models to model collection 2 #katze', function ()
            local column_collection = setup_scenario_2(-1)
            local model_collection = ModelCollection:new{}

            local passenger_path_builder = PassengerPathBuilder:new{
                column_collection = column_collection,
                passenger_path_models = {
                    vertical_single_platform = 'v_single.mdl',
                    vertical_double_platform = 'v_double.mdl',
                    horizontal_single_track = 'h_single_track.mdl',
                    horizontal_double_track = 'h_double_track.mdl',
                    street_link_left = 'street_link_left.mdl',
                    street_link_right = 'street_link_right.mdl'
                }
            }
            passenger_path_builder:add_bottom_part_to_model_collection(model_collection)

            assert.are.same({
                {
                    id = 'street_link_left.mdl',
                    transf = Position:new{x = column_collection:get_column(-3).x_pos + (-c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.DISTANCE_BETWEEN_TWO_TRACKS / 2), y = -3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'h_double_track.mdl',
                    transf = Position:new{x = column_collection:get_column(-3).x_pos, y = -3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'h_single_track.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = -3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'v_double.mdl',
                    transf = Position:new{x = column_collection:get_column(0).x_pos, y = -3 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'v_double.mdl',
                    transf = Position:new{x = column_collection:get_column(0).x_pos, y = -4 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'h_double_track.mdl',
                    transf = Position:new{x = column_collection:get_column(1).x_pos, y = -4.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'h_double_track.mdl',
                    transf = Position:new{x = column_collection:get_column(3).x_pos, y = -4.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'street_link_right.mdl',
                    transf = Position:new{x = column_collection:get_column(3).x_pos + (c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS / 2), y = -4.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                },
                
            }, model_collection.models)
        end)

        it ('adds bottom path models to model collection 3', function ()
            local column_collection = setup_scenario_3(-1)
            local model_collection = ModelCollection:new{}

            local passenger_path_builder = PassengerPathBuilder:new{
                column_collection = column_collection,
                passenger_path_models = {
                    vertical_single_platform = 'v_single.mdl',
                    vertical_double_platform = 'v_double.mdl',
                    horizontal_single_track = 'h_single_track.mdl',
                    horizontal_double_track = 'h_double_track.mdl',
                    street_link_left = 'street_link_left.mdl',
                    street_link_right = 'street_link_right.mdl'
                }
            }
            passenger_path_builder:add_bottom_part_to_model_collection(model_collection)

            assert.are.same({
                {
                    id = 'street_link_left.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = -2.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'h_double_track.mdl',
                    transf = Position:new{x = column_collection:get_column(0).x_pos, y = -2.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'v_single.mdl',
                    transf = Position:new{x = column_collection:get_column(1).x_pos, y = -2 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'street_link_right.mdl',
                    transf = Position:new{x = column_collection:get_column(1).x_pos, y = -1.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                },
                
            }, model_collection.models)
        end)
    end)

    describe('add_top_part_to_model_collection', function ()
        it ('adds no path models when station has no platforms', function ()
            local model_collection = ModelCollection:new{}

            local column_collection = ColumnCollection:new{}
            column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})})
            column_collection:calculate_x_positions()

            local passenger_path_builder = PassengerPathBuilder:new{
                column_collection = column_collection,
                passenger_path_models = {
                    vertical_single_platform = 'v_single.mdl',
                    vertical_double_platform = 'v_double.mdl',
                    horizontal_single_track = 'h_single_track.mdl',
                    horizontal_double_track = 'h_double_track.mdl',
                    street_link_left = 'street_link_left.mdl',
                    street_link_right = 'street_link_right.mdl'
                }
            }
            passenger_path_builder:add_top_part_to_model_collection(model_collection)

            assert.are.same({}, model_collection.models)
        end)

        it ('adds top path models to model collection 1', function ()
            local column_collection = setup_scenario_1(1)
            local model_collection = ModelCollection:new{}

            local passenger_path_builder = PassengerPathBuilder:new{
                column_collection = column_collection,
                passenger_path_models = {
                    vertical_single_platform = 'v_single.mdl',
                    vertical_double_platform = 'v_double.mdl',
                    horizontal_single_track = 'h_single_track.mdl',
                    horizontal_double_track = 'h_double_track.mdl',
                    street_link_left = 'street_link_left.mdl',
                    street_link_right = 'street_link_right.mdl'
                }
            }
            passenger_path_builder:add_top_part_to_model_collection(model_collection)

            assert.are.same({
                {
                    id = 'street_link_left.mdl',
                    transf = Position:new{x = column_collection:get_column(-3).x_pos, y = 3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'h_double_track.mdl',
                    transf = Position:new{x = column_collection:get_column(-2).x_pos, y = 3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'v_single.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = 2 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'v_single.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = 3 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                  id = 'h_single_track.mdl',
                    transf = Position:new{x = column_collection:get_column(0).x_pos, y = 2.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'v_double.mdl',
                    transf = Position:new{x = column_collection:get_column(1).x_pos, y = 3 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'h_double_track.mdl',
                    transf = Position:new{x = column_collection:get_column(2).x_pos, y = 3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'street_link_right.mdl',
                    transf = Position:new{x = column_collection:get_column(3).x_pos, y = 3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }
                
            }, model_collection.models)
        end)

        it ('adds top path models to model collection 2', function ()
            local column_collection = setup_scenario_2(1)
            local model_collection = ModelCollection:new{}

            local passenger_path_builder = PassengerPathBuilder:new{
                column_collection = column_collection,
                passenger_path_models = {
                    vertical_single_platform = 'v_single.mdl',
                    vertical_double_platform = 'v_double.mdl',
                    horizontal_single_track = 'h_single_track.mdl',
                    horizontal_double_track = 'h_double_track.mdl',
                    street_link_left = 'street_link_left.mdl',
                    street_link_right = 'street_link_right.mdl'
                }
            }
            passenger_path_builder:add_top_part_to_model_collection(model_collection)

            assert.are.same({
                {
                    id = 'street_link_left.mdl',
                    transf = Position:new{x = column_collection:get_column(-3).x_pos + (-c.DISTANCE_BETWEEN_TWO_TRACKS / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM), y = 3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'h_double_track.mdl',
                    transf = Position:new{x = column_collection:get_column(-3).x_pos, y = 3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'h_single_track.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = 3.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'v_double.mdl',
                    transf = Position:new{x = column_collection:get_column(0).x_pos, y = 3 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'v_double.mdl',
                    transf = Position:new{x = column_collection:get_column(0).x_pos, y = 4 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'h_double_track.mdl',
                    transf = Position:new{x = column_collection:get_column(1).x_pos, y = 4.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'h_double_track.mdl',
                    transf = Position:new{x = column_collection:get_column(3).x_pos, y = 4.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'street_link_right.mdl',
                    transf = Position:new{x = column_collection:get_column(3).x_pos + (c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS / 2), y = 4.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                },
                
            }, model_collection.models)
        end)

        it ('adds top path models to model collection 3', function ()
            local column_collection = setup_scenario_3(1)
            local model_collection = ModelCollection:new{}

            local passenger_path_builder = PassengerPathBuilder:new{
                column_collection = column_collection,
                passenger_path_models = {
                    vertical_single_platform = 'v_single.mdl',
                    vertical_double_platform = 'v_double.mdl',
                    horizontal_single_track = 'h_single_track.mdl',
                    horizontal_double_track = 'h_double_track.mdl',
                    street_link_left = 'street_link_left.mdl',
                    street_link_right = 'street_link_right.mdl'
                }
            }
            passenger_path_builder:add_top_part_to_model_collection(model_collection)

            assert.are.same({
                {
                    id = 'street_link_left.mdl',
                    transf = Position:new{x = column_collection:get_column(-1).x_pos, y = 2.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'h_double_track.mdl',
                    transf = Position:new{x = column_collection:get_column(0).x_pos, y = 2.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'v_single.mdl',
                    transf = Position:new{x = column_collection:get_column(1).x_pos, y = 2 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                }, {
                    id = 'street_link_right.mdl',
                    transf = Position:new{x = column_collection:get_column(1).x_pos, y = 1.5 * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                },
                
            }, model_collection.models)
        end)
    end)
    
end)