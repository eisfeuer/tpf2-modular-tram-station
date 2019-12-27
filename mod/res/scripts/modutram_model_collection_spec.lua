local ModelCollection = require('modutram_model_collection')

describe('ModelCollection', function ()
    describe('new', function ()
        it('creates empty model collection', function ()
            local modelCollection = ModelCollection:new{}
            assert.are.same({}, modelCollection.models)
        end)
    end)

    describe('add', function ()
        it('adds model to collection', function ()
            local modelCollection = ModelCollection:new{}
            modelCollection:add({
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