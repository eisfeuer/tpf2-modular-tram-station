local AssetIdCollection = require('modutram_asset_id_collection')
local t = require('modutram_types')
local Module = require('modutram_module')

describe('AssetIdCollection', function ()
    
    describe('new', function ()
        it('has an empty collection', function ()
            local asset_id_collection = AssetIdCollection:new{}
            assert.are.same({}, asset_id_collection.asset_ids)
        end)
    end)

    describe('add_asset_module', function ()
        it ('adds asset id', function ()
            local asset_id_collection = AssetIdCollection:new{}
            asset_id_collection:add_asset_module(t.ASSET_DECORATION, 3, 'lamp.module')
            asset_id_collection:add_asset_module(t.ASSET_SHELTER, 4, 'shelter.module')
            asset_id_collection:add_asset_module(t.ASSET_DECORATION, 5, 'bench.module')

            assert.are.same({
                [t.ASSET_DECORATION] = {
                    [3] = 'lamp.module',
                    [5] = 'bench.module'
                },
                [t.ASSET_SHELTER] = {
                    [4] = 'shelter.module'
                }
            }, asset_id_collection.asset_ids)
        end)

        it('adds no asset id when asset id already in collection', function ()
            local asset_id_collection = AssetIdCollection:new{}

            asset_id_collection:add_asset_module(t.ASSET_DECORATION, 3, 'bench.module')
            asset_id_collection:add_asset_module(t.ASSET_DECORATION, 3, 'lamp.module')

            assert.are.same({
                [t.ASSET_DECORATION] = {
                    [3] = 'bench.module'
                }
            }, asset_id_collection.asset_ids)
        end)
    end)

    describe('has_asset_id', function ()
        it ('checks whether an asset id is in the collection', function ()
            local asset_id_collection = AssetIdCollection:new{}

            asset_id_collection:add_asset_module(t.ASSET_DECORATION, 3, 'bench.module')

            assert.is_true(asset_id_collection:has_asset_id(t.ASSET_DECORATION, 3))
            assert.is_false(asset_id_collection:has_asset_id(t.ASSET_DECORATION, 4))
            assert.is_false(asset_id_collection:has_asset_id(t.ASSET_SHELTER, 3))

            assert.is_true(asset_id_collection:has_asset_id(t.ASSET_DECORATION, 3, 'bench.module'))
            assert.is_false(asset_id_collection:has_asset_id(t.ASSET_DECORATION, 3, 'lamp.module'))
            assert.is_false(asset_id_collection:has_asset_id(t.ASSET_DECORATION, 4, 'bench.module'))
            assert.is_false(asset_id_collection:has_asset_id(t.ASSET_SHELTER, 3, 'bench.module'))
        end)
    end)

    describe('has_asset', function ()
        it ('checks whether this collection contains the id of given asset module', function ()
            local asset_module_1 = Module:new{id = Module.make_id({type = t.ASSET_DECORATION, grid_x = 1, grid_y = 1, asset_id = 3})}
            local asset_module_2 = Module:new{id = Module.make_id({type = t.ASSET_DECORATION, grid_x = 1, grid_y = 1, asset_id = 4})}
            local asset_module_3 = Module:new{id = Module.make_id({type = t.ASSET_SHELTER, grid_x = 1, grid_y = 1, asset_id = 3})}

            local asset_id_collection = AssetIdCollection:new{}

            asset_id_collection:add_asset_module(t.ASSET_DECORATION, 3, 'bench.module')

            assert.is_true(asset_id_collection:has_asset(asset_module_1))
            assert.is_false(asset_id_collection:has_asset(asset_module_2))
            assert.is_false(asset_id_collection:has_asset(asset_module_3))

            assert.is_true(asset_id_collection:has_asset(asset_module_1, 'bench.module'))
            assert.is_false(asset_id_collection:has_asset(asset_module_1, 'lamp.module'))
            assert.is_false(asset_id_collection:has_asset(asset_module_2, 'bench.module'))
            assert.is_false(asset_id_collection:has_asset(asset_module_3, 'bench.module'))
        end)
    end)

end)