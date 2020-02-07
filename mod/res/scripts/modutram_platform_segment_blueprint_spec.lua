local PlatformSegmentBlueprint = require('modutram_platform_segment_blueprint')
local t = require('modutram_types')
local Module = require('modutram_module')

describe('PlatformSegmentBlueprint', function ()
    describe('add_asset', function ()
        it ('adds assets to a platform segment', function ()
            local segment_blueprint = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1,
                start_segment = -1,
                end_segment = 2,
                template = {
                    [234567] = 'a_module'
                }
            }

            segment_blueprint:add_asset(2, t.ASSET_SHELTER,'asset.module')
            assert.are.same({
                [Module.make_id({type = t.ASSET_SHELTER, grid_x = 3, grid_y = 1, asset_id = 2})] = 'asset.module',
                [234567] = 'a_module'
            }, segment_blueprint.template)
        end)
    end)

    describe('is_platform_type', function ()
        it ('checks whether station is given type', function ()
            local segment_blueprint = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1,
                start_segment = -1,
                end_segment = 2,
                template = {
                    [234567] = 'a_module'
                }
            }

            assert.is_true(segment_blueprint:is_platform_type(t.PLATFORM_DOUBLE))
            assert.is_false(segment_blueprint:is_platform_type(t.PLATFORM_LEFT))
            assert.is_false(segment_blueprint:is_platform_type(t.PLATFORM_RIGHT))
        end)
    end)

    describe('is_top_platform_segment', function ()
        it ('checks whether platform segment is the top segment of this platform', function ()
            local top_segment_blueprint = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 2,
                start_segment = -1,
                end_segment = 2,
                template = {
                    [234567] = 'a_module'
                }
            }

            local other_segment_blueprint = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1,
                start_segment = -1,
                end_segment = 2,
                template = {
                    [234567] = 'a_module'
                }
            }

            assert.is_true(top_segment_blueprint:is_top_platform_segment())
            assert.is_false(other_segment_blueprint:is_top_platform_segment())
        end)
    end)

    describe('is_bottom_platform_segment', function ()
        it ('checks whether platform segment is the bottom segment of this platform', function ()
            local btm_segment_blueprint = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = -1,
                start_segment = -1,
                end_segment = 2,
                template = {
                    [234567] = 'a_module'
                }
            }

            local other_segment_blueprint = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1,
                start_segment = -1,
                end_segment = 2,
                template = {
                    [234567] = 'a_module'
                }
            }

            assert.is_true(btm_segment_blueprint:is_bottom_platform_segment())
            assert.is_false(other_segment_blueprint:is_bottom_platform_segment())
        end)
    end)

    describe('get_current_segment', function ()
        it ('returns current segment', function ()
            local segment_blueprint = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1,
                start_segment = -1,
                end_segment = 2,
                template = {
                    [234567] = 'a_module'
                }
            }

            assert.are.equal(1, segment_blueprint:get_current_segment())
        end)
    end)

    describe('get_total_segment_count', function ()
        it ('returns count of all segments', function ()
            local segment_blueprint_1 = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1,
                start_segment = -1,
                end_segment = 2,
                template = {
                    [234567] = 'a_module'
                }
            }
    
            local segment_blueprint_2 = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1,
                start_segment = -2,
                end_segment = 2,
                template = {
                    [234567] = 'a_module'
                }
            }
    
            local segment_blueprint_3 = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1,
                start_segment = 0,
                end_segment = 0,
                template = {
                    [234567] = 'a_module'
                }
            }
    
            assert.are.equal(4, segment_blueprint_1:get_total_segment_count())
            assert.are.equal(5, segment_blueprint_2:get_total_segment_count())
            assert.are.equal(1, segment_blueprint_3:get_total_segment_count())
        end)
    end)

    describe('has_even_segment_count', function ()
        it ('checks whether segment count is even', function ()
            local segment_blueprint_1 = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1,
                start_segment = -1,
                end_segment = 2,
                template = {
                    [234567] = 'a_module'
                }
            }
    
            local segment_blueprint_2 = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1,
                start_segment = -2,
                end_segment = 2,
                template = {
                    [234567] = 'a_module'
                }
            }

            local segment_blueprint_3 = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1,
                start_segment = 0,
                end_segment = 0,
                template = {
                    [234567] = 'a_module'
                }
            }

            assert.is_true(segment_blueprint_1:has_even_segment_count())
            assert.is_false(segment_blueprint_2:has_even_segment_count())
            assert.is_false(segment_blueprint_3:has_even_segment_count())
        end)
    end)

    describe('has_odd_segment_count', function ()
        it ('checks whether segment count is odd', function ()
            local segment_blueprint_1 = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1,
                start_segment = -1,
                end_segment = 2,
                template = {
                    [234567] = 'a_module'
                }
            }
    
            local segment_blueprint_2 = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1,
                start_segment = -2,
                end_segment = 2,
                template = {
                    [234567] = 'a_module'
                }
            }

            local segment_blueprint_3 = PlatformSegmentBlueprint:new{
                platform_type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1,
                start_segment = 0,
                end_segment = 0,
                template = {
                    [234567] = 'a_module'
                }
            }

            assert.is_false(segment_blueprint_1:has_odd_segment_count())
            assert.is_true(segment_blueprint_2:has_odd_segment_count())
            assert.is_true(segment_blueprint_3:has_odd_segment_count())
        end)
    end)
end)