local PlatformBlueprint = require('modutram_platform_blueprint')
local t = require('modutram_types')
local Module = require('modutram_module')

describe('PlatformBlueprint', function ()

    describe('add_to_template', function ()
    
        it ('adds three platform segments to template', function ()
            local platform_blueprint = PlatformBlueprint:new{
                has_platform_access_top = false,
                has_platform_access_btm = false,
                platform_access_module = 'platform_access_ramp.module',
                platform_segments = 3,
                platform_segment_module = 'platform_double.module',
                platform_type = t.PLATFORM_DOUBLE,
                platform_grid_x = 5
            }

            local template = {}

            platform_blueprint:add_to_template(template)

            assert.are.same({
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = -1})] = 'platform_double.module',
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = 0})] = 'platform_double.module',
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = 1})] = 'platform_double.module'
            }, template)
        end)

        it ('adds four platform segments to template', function ()
            local platform_blueprint = PlatformBlueprint:new{
                has_platform_access_top = false,
                has_platform_access_btm = false,
                platform_access_module = 'platform_access_ramp.module',
                platform_segments = 4,
                platform_segment_module = 'platform_double.module',
                platform_type = t.PLATFORM_DOUBLE,
                platform_grid_x = 5
            }

            local template = {}

            platform_blueprint:add_to_template(template)

            assert.are.same({
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = -1})] = 'platform_double.module',
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = 0})] = 'platform_double.module',
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = 1})] = 'platform_double.module',
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = 2})] = 'platform_double.module',
            }, template)
        end)

        it ('adds three platform segments with access on top to template', function ()
            local platform_blueprint = PlatformBlueprint:new{
                has_platform_access_top = true,
                has_platform_access_btm = false,
                platform_access_module = 'platform_access_ramp.module',
                platform_segments = 3,
                platform_segment_module = 'platform_double.module',
                platform_type = t.PLATFORM_DOUBLE,
                platform_grid_x = 5
            }

            local template = {}

            platform_blueprint:add_to_template(template)

            assert.are.same({
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = -1})] = 'platform_double.module',
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = 0})] = 'platform_double.module',
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = 1})] = 'platform_double.module',
                [Module.make_id({type = t.PLATFORM_ENTRANCE_DOUBLE_TOP, grid_x = 5, grid_y = 2})] = 'platform_access_ramp.module'
            }, template)
        end)

        it ('adds three platform segments with bottom entrance to template', function ()
            local platform_blueprint = PlatformBlueprint:new{
                has_platform_access_top = false,
                has_platform_access_btm = true,
                platform_access_module = 'platform_access_ramp.module',
                platform_segments = 3,
                platform_segment_module = 'platform_double.module',
                platform_type = t.PLATFORM_DOUBLE,
                platform_grid_x = 5
            }

            local template = {}

            platform_blueprint:add_to_template(template)

            assert.are.same({
                [Module.make_id({type = t.PLATFORM_ENTRANCE_DOUBLE_BTM, grid_x = 5, grid_y = -2})] = 'platform_access_ramp.module',
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = -1})] = 'platform_double.module',
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = 0})] = 'platform_double.module',
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = 1})] = 'platform_double.module'
            }, template)
        end)

        it ('adds three platform segments with top and bottom entrance to template', function ()
            local platform_blueprint = PlatformBlueprint:new{
                has_platform_access_top = true,
                has_platform_access_btm = true,
                platform_access_module = 'platform_access_ramp.module',
                platform_segments = 3,
                platform_segment_module = 'platform_double.module',
                platform_type = t.PLATFORM_DOUBLE,
                platform_grid_x = 5
            }

            local template = {}

            platform_blueprint:add_to_template(template)

            assert.are.same({
                [Module.make_id({type = t.PLATFORM_ENTRANCE_DOUBLE_BTM, grid_x = 5, grid_y = -2})] = 'platform_access_ramp.module',
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = -1})] = 'platform_double.module',
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = 0})] = 'platform_double.module',
                [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = 1})] = 'platform_double.module',
                [Module.make_id({type = t.PLATFORM_ENTRANCE_DOUBLE_TOP, grid_x = 5, grid_y = 2})] = 'platform_access_ramp.module',
            }, template)
        end)

        describe('set_segment_decorations', function ()
            it ('decorates platform with assets', function ()
                local platform_blueprint = PlatformBlueprint:new{
                    has_platform_access_top = false,
                    has_platform_access_btm = false,
                    platform_access_module = 'platform_access_ramp.module',
                    platform_segments = 3,
                    platform_segment_module = 'platform_double.module',
                    platform_type = t.PLATFORM_DOUBLE,
                    platform_grid_x = 5
                }

                local template = {}

                local deco_function_1 = function (segment_blueprint)
                    segment_blueprint:add_asset(1, t.ASSET_DECORATION, 'asset.module')
                end
                local deco_function_2 = function (segment_blueprint)
                    segment_blueprint:add_asset(2, t.ASSET_SHELTER, 'shelter.module')
                end

                platform_blueprint:set_segment_decorations({deco_function_1, deco_function_2})

                platform_blueprint:add_to_template(template)

                assert.are.same({
                    [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = -1})] = 'platform_double.module',
                    [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = 0})] = 'platform_double.module',
                    [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 5, grid_y = 1})] = 'platform_double.module',
                    [Module.make_id({type = t.ASSET_DECORATION, grid_x = 5, grid_y = -1, asset_id = 1})] = 'asset.module',
                    [Module.make_id({type = t.ASSET_DECORATION, grid_x = 5, grid_y = 0, asset_id = 1})] = 'asset.module',
                    [Module.make_id({type = t.ASSET_DECORATION, grid_x = 5, grid_y = 1, asset_id = 1})] = 'asset.module',
                    [Module.make_id({type = t.ASSET_SHELTER, grid_x = 5, grid_y = -1, asset_id = 2})] = 'shelter.module',
                    [Module.make_id({type = t.ASSET_SHELTER, grid_x = 5, grid_y = 0, asset_id = 2})] = 'shelter.module',
                    [Module.make_id({type = t.ASSET_SHELTER, grid_x = 5, grid_y = 1, asset_id = 2})] = 'shelter.module',
                }, template)
            end)
        end)

    end)

end)