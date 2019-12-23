local ModelCollection = require('modutram_model_collection')

describe('ModelCollection', function ()
    describe('new', function ()
        it('creates empty model collection', function ()
            local modelCollection = ModelCollection:new{}
            assert.are.same({}, modelCollection.models)
        end)
    end)
end)