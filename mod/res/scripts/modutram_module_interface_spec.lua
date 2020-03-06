local ModuleInterface = require('modutram_module_interface')
local ColumnCollection = require('modutram_column_collection')
local t = require('modutram_types')
local Module = require('modutram_module')

describe('ModuleInterface', function ()
    describe('get_grid_x', function ()
        it('returns grid x', function ()
            local column_collection = ColumnCollection:new{}

            local platform_module = Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 1,
                    grid_y = 0
                })
            }

            column_collection:add(platform_module, 'platform.module')

            local module_interface = ModuleInterface:new{
                column_collection = column_collection,
                column_module = platform_module
            }

            assert.are.equal(1, module_interface:get_grid_x())
        end)
    end)

    describe('get_grid_y', function ()
        it('returns grid y', function ()
            local column_collection = ColumnCollection:new{}

            local platform_module = Module:new{
                id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 1,
                    grid_y = 2
                })
            }

            column_collection:add(platform_module, 'platform.module')

            local module_interface = ModuleInterface:new{
                column_collection = column_collection,
                column_module = platform_module
            }

            assert.are.equal(2, module_interface:get_grid_y())
        end)
    end)

    describe('has_placed_asset_on_slot', function ()
        local column_collection = ColumnCollection:new{}

        local platform_module = Module:new{
            id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 1,
                grid_y = 0
            })
        }

        local asset_module = Module:new{
            id = Module.make_id({
                type = t.ASSET_SHELTER,
                grid_x = 1,
                grid_y = 0,
                asset_id = 1
            })
        }

        column_collection:add(platform_module, 'platform.module')
        column_collection:add(asset_module, 'shelter.module')

        local module_interface = ModuleInterface:new{
            column_collection = column_collection,
            column_module = platform_module
        }

        assert.is_true(module_interface:has_placed_asset_on_slot(t.ASSET_SHELTER, 1))
        assert.is_true(module_interface:has_placed_asset_on_slot(t.ASSET_SHELTER, 1, 'shelter.module'))

        assert.is_false(module_interface:has_placed_asset_on_slot(t.ASSET_SHELTER, 0))
        assert.is_false(module_interface:has_placed_asset_on_slot(t.ASSET_STATION_SIGN, 1))
        assert.is_false(module_interface:has_placed_asset_on_slot(t.ASSET_SHELTER, 1, 'bench.module'))
    end)

    describe('has_tram_tracks', function ()
        it ('checks whether module has tram tracks', function ()
            local column_collection = ColumnCollection:new{}

            local track_module_1 = Module:new{
                id = Module.make_id({
                    type = t.TRACK_DOUBLE_DOORS_RIGHT,
                    grid_x = 1,
                    grid_y = 0
                })
            }
            local track_module_2 = Module:new{
                id = Module.make_id({
                    type = t.TRACK_DOUBLE_DOORS_RIGHT,
                    grid_x = 3,
                    grid_y = 0
                })
            }

            local tram_tracks = Module:new{
                id = Module.make_id({
                    type = t.ASSET_TRAM_TRACKS,
                    grid_x = 1,
                    grid_y = 0,
                    asset_id = 1
                })
            }

            column_collection:add(track_module_1, 'track.module')
            column_collection:add(track_module_2, 'track.module')
            column_collection:add(tram_tracks, 'tram_track.module')

            local module_interface_1 = ModuleInterface:new{
                column_collection = column_collection,
                column_module = track_module_1
            }
            local module_interface_2 = ModuleInterface:new{
                column_collection = column_collection,
                column_module = track_module_2
            }

            assert.is_true(module_interface_1:has_tram_tracks())
            assert.is_false(module_interface_2:has_tram_tracks())
        end)
    end)

    describe('has_catenary', function ()
        it ('checks whether module has catenary', function ()
            local column_collection = ColumnCollection:new{}

            local track_module_1 = Module:new{
                id = Module.make_id({
                    type = t.TRACK_DOUBLE_DOORS_RIGHT,
                    grid_x = 1,
                    grid_y = 0
                })
            }
            local track_module_2 = Module:new{
                id = Module.make_id({
                    type = t.TRACK_DOUBLE_DOORS_RIGHT,
                    grid_x = 3,
                    grid_y = 0
                })
            }

            local catenary = Module:new{
                id = Module.make_id({
                    type = t.ASSET_CATENARY,
                    grid_x = 1,
                    grid_y = 0,
                    asset_id = 1
                })
            }

            column_collection:add(track_module_1, 'track.module')
            column_collection:add(track_module_2, 'track.module')
            column_collection:add(catenary, 'tram_track.module')

            local module_interface_1 = ModuleInterface:new{
                column_collection = column_collection,
                column_module = track_module_1
            }
            local module_interface_2 = ModuleInterface:new{
                column_collection = column_collection,
                column_module = track_module_2
            }

            assert.is_true(module_interface_1:has_catenary())
            assert.is_false(module_interface_2:has_catenary())
        end)
    end)

    describe('has_bus_lane', function ()
        it ('checks whether module has catenary', function ()
            local column_collection = ColumnCollection:new{}

            local track_module_1 = Module:new{
                id = Module.make_id({
                    type = t.TRACK_DOUBLE_DOORS_RIGHT,
                    grid_x = 1,
                    grid_y = 0
                })
            }
            local track_module_2 = Module:new{
                id = Module.make_id({
                    type = t.TRACK_DOUBLE_DOORS_RIGHT,
                    grid_x = 3,
                    grid_y = 0
                })
            }

            local bus_lane = Module:new{
                id = Module.make_id({
                    type = t.ASSET_BUS_LANE,
                    grid_x = 1,
                    grid_y = 0,
                    asset_id = 1
                })
            }

            column_collection:add(track_module_1, 'track.module')
            column_collection:add(track_module_2, 'track.module')
            column_collection:add(bus_lane, 'bus_lane.module')

            local module_interface_1 = ModuleInterface:new{
                column_collection = column_collection,
                column_module = track_module_1
            }
            local module_interface_2 = ModuleInterface:new{
                column_collection = column_collection,
                column_module = track_module_2
            }

            assert.is_true(module_interface_1:has_bus_lane())
            assert.is_false(module_interface_2:has_bus_lane())
        end)
    end)

    describe('get_track', function ()
        local column_collection = ColumnCollection:new{}

            local track_module = Module:new{
                id = Module.make_id({
                    type = t.TRACK_DOUBLE_DOORS_RIGHT,
                    grid_x = 0,
                    grid_y = 0
                })
            }

            local catenary = Module:new{
                id = Module.make_id({
                    type = t.ASSET_CATENARY,
                    grid_x = 0,
                    grid_y = 0,
                    asset_id = 1
                })
            }

            column_collection:add(track_module, 'track.module')
            column_collection:add(catenary, 'tram_track.module')
            column_collection:calculate_x_positions()

            local module_interface = ModuleInterface:new{
                column_collection = column_collection,
                column_module = catenary
            }

            assert.are.equal(t.TRACK_DOUBLE_DOORS_RIGHT, module_interface:get_track().type)
            assert.are.equal(0, module_interface:get_track().x_pos)
    end)
end)