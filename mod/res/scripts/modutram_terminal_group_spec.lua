local ColumnCollection = require('modutram_column_collection')
local Module = require('modutram_module')
local Terminal = require('modutram_terminal')
local TerminalGroup = require('modutram_terminal_group')
local ModelCollection = require('modutram_model_collection')
local t = require('modutram_types')
local c = require('modutram_constants')
local Position = require('modutram_position')

local function prepare_column_collection()
    local column_collection = ColumnCollection:new{}

    column_collection:add(Module:new{id = Module.make_id{type = t.TRACK_UP_DOORS_RIGHT, grid_x = 0, grid_y = 0}})

    column_collection:add(Module:new{id = Module.make_id{type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0}})
    column_collection:add(Module:new{id = Module.make_id{type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1}})

    column_collection:add(Module:new{id = Module.make_id{type = t.PLATFORM_LEFT, grid_x = -1, grid_y = -1}})
    column_collection:add(Module:new{id = Module.make_id{type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0}})
    column_collection:add(Module:new{id = Module.make_id{type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 1}})
    column_collection:add(Module:new{id = Module.make_id{type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 2}})

    column_collection:calculate_track_segment_range()
    column_collection:calculate_x_positions()

    return column_collection
end

describe('TerminalGroup', function ()
    
    describe('is_track_left_from_the_platform', function ()
        it('is true when track is left from the platform', function ()
            local column_collection = ColumnCollection:new{}
            column_collection:add(Module:new{id = Module.make_id{type = t.TRACK_UP_DOORS_RIGHT, grid_x = 0, grid_y = 0}})
            column_collection:add(Module:new{id = Module.make_id{type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0}})

            local terminal_group = TerminalGroup:new{
                track = column_collection:get_column(0),
                platform = column_collection:get_column(1),
            }
            
            assert.is_true(terminal_group:is_track_left_from_the_platform())
        end)

        it('is false when track is left from the platform', function ()
            local column_collection = ColumnCollection:new{}
            column_collection:add(Module:new{id = Module.make_id{type = t.TRACK_UP_DOORS_RIGHT, grid_x = 0, grid_y = 0}})
            column_collection:add(Module:new{id = Module.make_id{type = t.PLATFORM_LEFT, grid_x = -1, grid_y = 0}})

            local terminal_group = TerminalGroup:new{
                track = column_collection:get_column(0),
                platform = column_collection:get_column(-1),
            }

            assert.is_false(terminal_group:is_track_left_from_the_platform())
        end)
    end)

    describe('as_terminal_group_item', function ()
        it ('creates terminal group item from a platform with even module count', function ()
            local column_collection = prepare_column_collection()

            local track = column_collection:get_column(0)
            local platform = column_collection:get_column(1)
            platform:set_height(0.2)

            local stop_mid_terminal = Terminal:new{model = 'models/stop_mid_terminal.mdl', terminal_position = 1}
            local stop_edge_terminal = Terminal:new{model = 'models/stop_edge_terminal.mdl', terminal_position = 0}
            local waiting_area_only_terminal = Terminal:new{model = 'models/waiting_area_only_terminal.mdl', terminal_position = 2}

            local model_collection = ModelCollection:new{}
            model_collection:add({
                id = 'model.mdl',
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    0, 0, 0, 1
                }
            })

            local terminal_group = TerminalGroup:new{
                track = track,
                platform = platform,
                stop_mid_terminal = stop_mid_terminal,
                stop_edge_terminal = stop_edge_terminal,
                waiting_area_only_terminal = waiting_area_only_terminal,
                models = model_collection
            }

            assert.are.same({
                tag = platform.id,
                terminals = {
                    {1, 0},
                    {2, 2},
                }
            }, terminal_group:as_terminal_group_item())
        end)

        it ('creates terminal group item from a platform with odd module count', function ()
            local column_collection = prepare_column_collection()
            column_collection:add(Module:new{id = Module.make_id{type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1}})
            column_collection:calculate_track_segment_range()
            column_collection:calculate_x_positions()

            local track = column_collection:get_column(0)
            local platform = column_collection:get_column(1)
            platform:set_height(0.2)

            local stop_mid_terminal = Terminal:new{model = 'models/stop_mid_terminal.mdl', terminal_position = 1}
            local stop_edge_terminal = Terminal:new{model = 'models/stop_edge_terminal.mdl', terminal_position = 0}
            local waiting_area_only_terminal = Terminal:new{model = 'models/waiting_area_only_terminal.mdl', terminal_position = 2}

            local model_collection = ModelCollection:new{}
            model_collection:add({
                id = 'model.mdl',
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    0, 0, 0, 1
                }
            })

            local terminal_group = TerminalGroup:new{
                track = track,
                platform = platform,
                stop_mid_terminal = stop_mid_terminal,
                stop_edge_terminal = stop_edge_terminal,
                waiting_area_only_terminal = waiting_area_only_terminal,
                models = model_collection
            }

            assert.are.same({
                tag = platform.id,
                terminals = {
                    {1, 2},
                    {2, 1},
                    {3, 2},
                }
            }, terminal_group:as_terminal_group_item())
        end)
    end)

    describe('add_to_model_collection', function ()
        describe('it adds models to model collection', function ()
            it ('add path model of platform with even module coount', function ()
                
                local column_collection = prepare_column_collection()

                local track = column_collection:get_column(0)
                local platform = column_collection:get_column(1)
                platform:set_height(0.2)

                local stop_mid_terminal = Terminal:new{model = 'models/stop_mid_terminal.mdl', terminal_position = 1}
                local stop_edge_terminal = Terminal:new{model = 'models/stop_edge_terminal.mdl', terminal_position = 0}
                local waiting_area_only_terminal = Terminal:new{model = 'models/waiting_area_only_terminal.mdl', terminal_position = 2}

                local model_collection = ModelCollection:new{}
                model_collection:add({
                    id = 'model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1
                    }
                })

                local terminal_group = TerminalGroup:new{
                    track = track,
                    platform = platform,
                    stop_mid_terminal = stop_mid_terminal,
                    stop_edge_terminal = stop_edge_terminal,
                    waiting_area_only_terminal = waiting_area_only_terminal,
                    models = model_collection,
                    tram_path_model = 'tram_path.mdl'
                }

                terminal_group:add_to_model_collection(model_collection)
                assert.are.same({
                    {
                        id = 'model.mdl',
                        transf = Position:new{}:as_matrix()
                    }, {
                        id = 'models/stop_edge_terminal.mdl',
                        transf = Position:new{}:add_to_matrix(platform.left_path_model_transformation)
                    }, {
                        id = 'models/waiting_area_only_terminal.mdl',
                        transf = Position:new{y = c.PLATFORM_SEGMENT_LENGTH}:add_to_matrix(platform.left_path_model_transformation)
                    }, {
                        id = 'tram_path.mdl',
                        transf = Position:new{y = -c.PLATFORM_SEGMENT_LENGTH}:add_to_matrix(platform.left_path_model_transformation)
                    }, {
                        id = 'tram_path.mdl',
                        transf = Position:new{y = 2 * c.PLATFORM_SEGMENT_LENGTH}:add_to_matrix(platform.left_path_model_transformation)
                    }
                }, model_collection.models)
            end)

            it ('add path model of platform with odd module count', function ()
                
                local column_collection = prepare_column_collection()
                column_collection:add(Module:new{id = Module.make_id{type = t.PLATFORM_LEFT, grid_x = 1, grid_y = -1}})
                column_collection:calculate_track_segment_range()
                column_collection:calculate_x_positions()

                local track = column_collection:get_column(0)
                local platform = column_collection:get_column(1)
                platform:set_height(0.2)

                local stop_mid_terminal = Terminal:new{model = 'models/stop_mid_terminal.mdl', terminal_position = 1}
                local stop_edge_terminal = Terminal:new{model = 'models/stop_edge_terminal.mdl', terminal_position = 0}
                local waiting_area_only_terminal = Terminal:new{model = 'models/waiting_area_only_terminal.mdl', terminal_position = 2}

                local model_collection = ModelCollection:new{}
                model_collection:add({
                    id = 'model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1
                    }
                })

                local terminal_group = TerminalGroup:new{
                    track = track,
                    platform = platform,
                    stop_mid_terminal = stop_mid_terminal,
                    stop_edge_terminal = stop_edge_terminal,
                    waiting_area_only_terminal = waiting_area_only_terminal,
                    models = model_collection,
                    tram_path_model = 'tram_path.mdl'
                }

                terminal_group:add_to_model_collection(model_collection)
                assert.are.same({
                    {
                        id = 'model.mdl',
                        transf = Position:new{}:as_matrix()
                    }, {
                        id = 'models/waiting_area_only_terminal.mdl',
                        transf = Position:new{y = -c.PLATFORM_SEGMENT_LENGTH}:add_to_matrix(platform.left_path_model_transformation)
                    }, {
                        id = 'models/stop_mid_terminal.mdl',
                        transf = Position:new{}:add_to_matrix(platform.left_path_model_transformation)
                    }, {
                        id = 'models/waiting_area_only_terminal.mdl',
                        transf = Position:new{y = c.PLATFORM_SEGMENT_LENGTH}:add_to_matrix(platform.left_path_model_transformation)
                    }, {
                        id = 'tram_path.mdl',
                        transf = Position:new{y = 2 * c.PLATFORM_SEGMENT_LENGTH}:add_to_matrix(platform.left_path_model_transformation)
                    }
                }, model_collection.models)
            end)
        end)
    end)

end)