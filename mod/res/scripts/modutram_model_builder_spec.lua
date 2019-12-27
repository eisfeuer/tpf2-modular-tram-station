local ColumnCollection = require('modutram_column_collection')
local ModelCollection = require('modutram_model_collection')

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
end)