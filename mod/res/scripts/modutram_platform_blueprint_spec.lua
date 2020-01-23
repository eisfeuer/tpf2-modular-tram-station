local PlatformBlueprint = require('modutram_platform_blueprint')
local t = require('modutram_types')
local Module = require('modutram_module')

describe('PlatformBlueprint', function ()

    describe('add_to_template', function ()
    
        it ('adds three platform segments to template', function ()
            local platform_blueprint = PlatformBlueprint:new{
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

    end)

end)