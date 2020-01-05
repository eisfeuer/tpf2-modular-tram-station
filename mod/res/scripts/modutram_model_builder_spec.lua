local ColumnCollection = require('modutram_column_collection')
local ModelCollection = require('modutram_model_collection')
local Module = require('modutram_module')
local t = require('modutram_types')
local c = require('modutram_constants')

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
                }
            }, modelCollection.models)
        end)
    end)
end)