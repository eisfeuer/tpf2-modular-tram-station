local AssetModuleCollection = require('modutram_asset_module_collection')
local t = require('modutram_types')
local Module = require('modutram_module')

describe('AssetModuleCollection', function ()
    
    describe('new', function ()
        it('has an empty collection', function ()
            local asset_module_collection = AssetModuleCollection:new{}
            assert.are.same({}, asset_module_collection.asset_modules)
        end)
    end)

    describe('add_asset_module', function ()
        it ('adds asset module', function ()
            local asset_module_collection = AssetModuleCollection:new{}

            local asset_module_1 = Module:new{id = Module.make_id({type = t.ASSET_DECORATION, grid_x = 1, grid_y = 1, asset_id = 3})}
            local asset_module_2 = Module:new{id = Module.make_id({type = t.ASSET_SHELTER, grid_x = 1, grid_y = 1, asset_id = 4})}
            local asset_module_3 = Module:new{id = Module.make_id({type = t.ASSET_DECORATION, grid_x = 1, grid_y = 1, asset_id = 5})}
            local asset_module_4 = Module:new{id = Module.make_id({type = t.ASSET_DECORATION, grid_x = 0, grid_y = 1, asset_id = 5})}

            asset_module_collection:add_asset_module(asset_module_1, 'lamp.module')
            asset_module_collection:add_asset_module(asset_module_2, 'shelter.module')
            asset_module_collection:add_asset_module(asset_module_3, 'bench.module')
            asset_module_collection:add_asset_module(asset_module_4, 'bench.module')

            assert.are.same({
                [t.ASSET_DECORATION] = {
                    [0] = {
                        [1] = {
                            [5] = 'bench.module'
                        }
                    },
                    [1] = {
                        [1] = {
                            [3] = 'lamp.module',
                            [5] = 'bench.module'
                        }
                    }
                },
                [t.ASSET_SHELTER] = {
                    [1] = {
                        [1] = {
                            [4] = 'shelter.module'
                        }
                    }
                }
            }, asset_module_collection.asset_modules)
        end)

        it('adds no asset id when asset id already in collection', function ()
            local asset_module_collection = AssetModuleCollection:new{}

            local asset_module = Module:new{id = Module.make_id({type = t.ASSET_DECORATION, grid_x = 1, grid_y = 1, asset_id = 3})}

            asset_module_collection:add_asset_module(asset_module, 'bench.module')
            asset_module_collection:add_asset_module(asset_module, 'lamp.module')

            assert.are.same({
                [t.ASSET_DECORATION] = {
                    [1] = {
                        [1] = {
                            [3] = 'bench.module'
                        }
                    }
                }
            }, asset_module_collection.asset_modules)
        end)
    end)

    describe('is_placed_on_module', function ()
        it ('checks whether an asset id is in the collection', function ()
            local asset_module_collection = AssetModuleCollection:new{}

            local asset_module = Module:new{id = Module.make_id({type = t.ASSET_DECORATION, grid_x = 0, grid_y = 1, asset_id = 3})}
            local platform_module = Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 1})}

            asset_module_collection:add_asset_module(asset_module, 'bench.module')

            assert.is_true(asset_module_collection:is_placed_on_module(platform_module, t.ASSET_DECORATION, 3))
            assert.is_false(asset_module_collection:is_placed_on_module(platform_module, t.ASSET_DECORATION, 4))
            assert.is_false(asset_module_collection:is_placed_on_module(platform_module, t.ASSET_SHELTER, 3))

            assert.is_true(asset_module_collection:is_placed_on_module(platform_module, t.ASSET_DECORATION, 3, 'bench.module'))
            assert.is_false(asset_module_collection:is_placed_on_module(platform_module, t.ASSET_DECORATION, 3, 'lamp.module'))
            assert.is_false(asset_module_collection:is_placed_on_module(platform_module, t.ASSET_DECORATION, 4, 'bench.module'))
            assert.is_false(asset_module_collection:is_placed_on_module(platform_module, t.ASSET_SHELTER, 3, 'bench.module'))
        end)
    end)
end)