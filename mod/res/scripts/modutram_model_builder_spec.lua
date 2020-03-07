local ColumnCollection = require('modutram_column_collection')
local ModelCollection = require('modutram_model_collection')
local Module = require('modutram_module')
local t = require('modutram_types')
local c = require('modutram_constants')
local Position = require('modutram_position')

local ModelBuilder = require('modutram_model_builder')

describe('ModelBuilder', function ()
    describe('add_model', function ()
        it ('adds a model to model collection', function ()
            local modelCollection = ModelCollection:new{}
            local columnCollection = ColumnCollection:new{}

            local modelBuilder = ModelBuilder:new{
                model_collection = modelCollection,
                column_collection = columnCollection
            }

            modelBuilder:add_model({
                id = 'path/to/model.mdl',
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    0, 0, 0, 1,
                }
            })

            assert.are.same({{
                id = 'path/to/model.mdl',
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    0, 0, 0, 1,
                }
            }}, modelCollection.models)
        end)
    end)

    describe('add_segment_models_for_tram_track', function ()
        it('adds models for every segment used in given tram track', function ()
            local modelCollection = ModelCollection:new{}
            local columnCollection = ColumnCollection:new{}
            local trackModuleId = Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 1, grid_y = 0})

            columnCollection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 0})})
            columnCollection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = -1})})
            columnCollection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 1})})
            columnCollection:add(Module:new{id = trackModuleId})
            columnCollection:calculate_track_segment_range()
            columnCollection:calculate_x_positions()

            local modelBuilder = ModelBuilder:new{
                model_collection = modelCollection,
                column_collection = columnCollection
            }

            modelBuilder:add_segment_models_for_tram_track(trackModuleId, {
                {
                    id = 'path/to/model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1,
                    }
                }, {
                    id = 'path/to/model2.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        3, 2, 1, 1,
                    }
                }
            })

            local x_pos = columnCollection:get_column(1).x_pos
            assert.are.same({
                {
                    id = 'path/to/model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        x_pos, -c.PLATFORM_SEGMENT_LENGTH * 2, 0, 1,
                    }
                }, {
                    id = 'path/to/model2.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        x_pos + 3, -c.PLATFORM_SEGMENT_LENGTH * 2 + 2, 1, 1,
                    }
                },{
                    id = 'path/to/model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        x_pos, -c.PLATFORM_SEGMENT_LENGTH, 0, 1,
                    }
                }, {
                    id = 'path/to/model2.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        x_pos + 3, -c.PLATFORM_SEGMENT_LENGTH + 2, 1, 1,
                    }
                }, {
                    id = 'path/to/model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        x_pos, 0, 0, 1,
                    }
                }, {
                    id = 'path/to/model2.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        x_pos + 3, 2, 1, 1,
                    }
                }, {
                    id = 'path/to/model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        x_pos, c.PLATFORM_SEGMENT_LENGTH, 0, 1,
                    }
                }, {
                    id = 'path/to/model2.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        x_pos + 3, c.PLATFORM_SEGMENT_LENGTH + 2, 1, 1,
                    }
                }, {
                    id = 'path/to/model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        x_pos, 2 * c.PLATFORM_SEGMENT_LENGTH, 0, 1,
                    }
                }, {
                    id = 'path/to/model2.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        x_pos + 3, 2 * c.PLATFORM_SEGMENT_LENGTH + 2, 1, 1,
                    }
                }
            }, modelCollection.models)
        end)
    end)

    describe('add_platform_access_passenger_lanes', function ()
        it('creates passenger lanes for platform access and adds it to model collection', function ()
            local modelCollection = ModelCollection:new{}
            local columnCollection = ColumnCollection:new{}

            local modelBuilder = ModelBuilder:new{
                model_collection = modelCollection,
                column_collection = columnCollection
            }

            modelBuilder:add_platform_access_passenger_lanes(Position:new{x = 2, y = 1, z = 3}, 0.15, 2.1)

            assert.are.same({
                {
                    id = c.PLATFORM_PATH_MODELS.platform_access_ramp,
                    transf = {
                        0, 0, 0, 0,
                        0, 2.1, 0, 0,
                        0, 0, 0.15, 0,
                        2, 1, 3, 1
                    }
                }, {
                    id = c.PLATFORM_PATH_MODELS.platform_access_plain,
                    transf = {
                        1, 0, 0, 0,
                        0, c.PLATFORM_SEGMENT_LENGTH - 2.1, 0, 0,
                        0, 0, 1, 0,
                        2, 1 + 2.1, 3, 1
                    }
                }
            }, modelCollection.models)
        end)

        it('creates ramp only when ramp length is equal to platform segment length', function ()
            local modelCollection = ModelCollection:new{}
            local columnCollection = ColumnCollection:new{}

            local modelBuilder = ModelBuilder:new{
                model_collection = modelCollection,
                column_collection = columnCollection
            }

            modelBuilder:add_platform_access_passenger_lanes(Position:new{x = 2, y = 1, z = 3}, 0.15, c.PLATFORM_SEGMENT_LENGTH)

            assert.are.same({
                {
                    id = c.PLATFORM_PATH_MODELS.platform_access_ramp,
                    transf = {
                        0, 0, 0, 0,
                        0, c.PLATFORM_SEGMENT_LENGTH, 0, 0,
                        0, 0, 0.15, 0,
                        2, 1, 3, 1
                    }
                }
            }, modelCollection.models)
        end)

        it('creates plane lane only when ramp length is 0', function ()
            local modelCollection = ModelCollection:new{}
            local columnCollection = ColumnCollection:new{}

            local modelBuilder = ModelBuilder:new{
                model_collection = modelCollection,
                column_collection = columnCollection
            }

            modelBuilder:add_platform_access_passenger_lanes(Position:new{x = 2, y = 1, z = 3}, 0.15, 0.0)

            assert.are.same({
                {
                    id = c.PLATFORM_PATH_MODELS.platform_access_plain,
                    transf = {
                        1, 0, 0, 0,
                        0, c.PLATFORM_SEGMENT_LENGTH, 0, 0,
                        0, 0, 1, 0,
                        2, 1, 3, 1
                    }
                }
            }, modelCollection.models)
        end)

        it('creates plane lane only when platform height is 0', function ()
            local modelCollection = ModelCollection:new{}
            local columnCollection = ColumnCollection:new{}

            local modelBuilder = ModelBuilder:new{
                model_collection = modelCollection,
                column_collection = columnCollection
            }

            modelBuilder:add_platform_access_passenger_lanes(Position:new{x = 2, y = 1, z = 3}, 0.0, 2.1)

            assert.are.same({
                {
                    id = c.PLATFORM_PATH_MODELS.platform_access_plain,
                    transf = {
                        1, 0, 0, 0,
                        0, c.PLATFORM_SEGMENT_LENGTH, 0, 0,
                        0, 0, 1, 0,
                        2, 1, 3, 1
                    }
                }
            }, modelCollection.models)
        end)

        it('creates ramp and linkable plain path', function ()
            local modelCollection = ModelCollection:new{}
            local columnCollection = ColumnCollection:new{}

            local modelBuilder = ModelBuilder:new{
                model_collection = modelCollection,
                column_collection = columnCollection
            }

            modelBuilder:add_platform_access_passenger_lanes(Position:new{x = 2, y = 1, z = 3}, 0.15, 2.1, {linkable = true})

            assert.are.same({
                {
                    id = c.PLATFORM_PATH_MODELS.platform_access_ramp,
                    transf = {
                        0, 0, 0, 0,
                        0, 2.1, 0, 0,
                        0, 0, 0.15, 0,
                        2, 1, 3, 1
                    }
                }, {
                    id = c.PLATFORM_PATH_MODELS.platform_access_plain_linkable,
                    transf = {
                        1, 0, 0, 0,
                        0, c.PLATFORM_SEGMENT_LENGTH - 2.1, 0, 0,
                        0, 0, 1, 0,
                        2, 1 + 2.1, 3, 1
                    }
                }
            }, modelCollection.models)

        end)

        it('creates ramp path with y offset', function ()
            local modelCollection = ModelCollection:new{}
            local columnCollection = ColumnCollection:new{}

            local modelBuilder = ModelBuilder:new{
                model_collection = modelCollection,
                column_collection = columnCollection
            }

            modelBuilder:add_platform_access_passenger_lanes(Position:new{x = 2, y = 1, z = 3}, 0.15, 2.1, {ramp_y_offset = 1.2})

            assert.are.same({
                {
                    id = c.PLATFORM_PATH_MODELS.platform_access_ramp,
                    transf = {
                        1.2, 0, 0, 0,
                        0, 2.1, 0, 0,
                        0, 0, 0.15, 0,
                        2, 1, 3, 1
                    }
                }, {
                    id = c.PLATFORM_PATH_MODELS.platform_access_plain,
                    transf = {
                        1, 0, 0, 0,
                        0, c.PLATFORM_SEGMENT_LENGTH - 2.1, 0, 0,
                        0, 0, 1, 0,
                        2, 1 + 2.1, 3, 1
                    }
                }
            }, modelCollection.models)
        end)

        it('creates mirrored path', function ()
            local modelCollection = ModelCollection:new{}
            local columnCollection = ColumnCollection:new{}

            local modelBuilder = ModelBuilder:new{
                model_collection = modelCollection,
                column_collection = columnCollection
            }

            modelBuilder:add_platform_access_passenger_lanes(Position:new{x = 2, y = 1, z = 3}, 0.15, 2.1, {mirrored = true})

            assert.are.same({
                {
                    id = c.PLATFORM_PATH_MODELS.platform_access_ramp_mirrored,
                    transf = {
                        0, 0, 0, 0,
                        0, 2.1, 0, 0,
                        0, 0, 0.15, 0,
                        2, 1, 3, 1
                    }
                }, {
                    id = c.PLATFORM_PATH_MODELS.platform_access_plain,
                    transf = {
                        -1, 0, 0, 0,
                        0, -(c.PLATFORM_SEGMENT_LENGTH - 2.1), 0, 0,
                        0, 0, 1, 0,
                        2, 1 - 2.1, 3, 1
                    }
                }
            }, modelCollection.models)
        end)

    end)

    describe('add vehicle and platform lanes for', function ()
        it ('adds vehicle and platform waiting langes', function ()
            local modelCollection = ModelCollection:new{}
            local columnCollection = ColumnCollection:new{}
            local terminal_groups = {}

            local trackModuleId = Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 1, grid_y = 0})

            columnCollection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 0})})
            columnCollection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = -1})})
            columnCollection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 1})})
            columnCollection:add(Module:new{id = trackModuleId})
            columnCollection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 2, grid_y = 0})})
            columnCollection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 2, grid_y = -1})})
            columnCollection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 2, grid_y = 1})})
            columnCollection:add(Module:new{id = Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 2, grid_y = 2})})
            columnCollection:calculate_track_segment_range()
            columnCollection:calculate_x_positions()

            local platform = columnCollection:get_column(0)

            local modelBuilder = ModelBuilder:new{
                model_collection = modelCollection,
                column_collection = columnCollection,
                terminal_groups = terminal_groups
            }

            modelBuilder:add_model({
                id = 'path/to/model.mdl',
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    0, 0, 0, 1,
                }
            })
            modelBuilder:add_vehicle_and_platform_lanes_for('tram', trackModuleId, c.LEFT)

            local mapped_terminal_groups = {}
            for i, terminal_group in ipairs(terminal_groups) do
                table.insert(mapped_terminal_groups, terminal_group:as_terminal_group_item())
                terminal_group:add_to_model_collection(modelCollection)
            end

            assert.are.same({
                {
                    tag = 0,
                    terminals = {
                        { 1, c.PLATFORM_PATH_MODELS.tram.waiting_area_only_terminal.terminal_position },
                        { 2, c.PLATFORM_PATH_MODELS.tram.stop_mid_terminal.terminal_position },
                        { 3, c.PLATFORM_PATH_MODELS.tram.waiting_area_only_terminal.terminal_position }
                    }
                }
            }, mapped_terminal_groups)

            assert.are.same({
                {
                    id = 'path/to/model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1,
                    }
                }, {
                    id = c.PLATFORM_PATH_MODELS.tram.stop_mid_terminal.model,
                    transf = Position:new{y = 0}:add_to_matrix(platform.right_path_model_transformation)
                }, {
                    id = c.PLATFORM_PATH_MODELS.tram.waiting_area_only_terminal.model,
                    transf = Position:new{y = -c.PLATFORM_SEGMENT_LENGTH}:add_to_matrix(platform.right_path_model_transformation)
                }, {
                    id = c.PLATFORM_PATH_MODELS.tram.waiting_area_only_terminal.model,
                    transf = Position:new{y = c.PLATFORM_SEGMENT_LENGTH}:add_to_matrix(platform.right_path_model_transformation)
                }, {
                    id = c.PLATFORM_PATH_MODELS.tram.vehicle_lane_without_terminal.model,
                    transf = Position:new{y = c.PLATFORM_SEGMENT_LENGTH * -2}:add_to_matrix(platform.right_path_model_transformation)
                }, {
                    id = c.PLATFORM_PATH_MODELS.tram.vehicle_lane_without_terminal.model,
                    transf = Position:new{y = c.PLATFORM_SEGMENT_LENGTH * 2}:add_to_matrix(platform.right_path_model_transformation)
                }, {
                    id = c.PLATFORM_PATH_MODELS.tram.vehicle_lane_without_terminal.model,
                    transf = Position:new{y = c.PLATFORM_SEGMENT_LENGTH * 3}:add_to_matrix(platform.right_path_model_transformation)
                }
            }, modelCollection.models)
        end)

        it ('adds nothing when platform not exists', function ()
            local modelCollection = ModelCollection:new{}
            local columnCollection = ColumnCollection:new{}
            local terminal_groups = {}

            local trackModuleId = Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 1, grid_y = 0})

            columnCollection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 0})})
            columnCollection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = -1})})
            columnCollection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 1})})
            columnCollection:add(Module:new{id = trackModuleId})

            local modelBuilder = ModelBuilder:new{
                model_collection = modelCollection,
                column_collection = columnCollection,
                terminal_groups = terminal_groups
            }

            modelBuilder:add_model({
                id = 'path/to/model.mdl',
                transf = {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    0, 0, 0, 1,
                }
            })
            modelBuilder:add_vehicle_and_platform_lanes_for('tram', trackModuleId, c.RIGHT)

            assert.are.same({}, terminal_groups)
            assert.are.same({
                {
                    id = 'path/to/model.mdl',
                    transf = {
                        1, 0, 0, 0,
                        0, 1, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1,
                    }
                }
            }, modelCollection.models)
        end)
    end)
end)