local StationBlueprint = require('modutram_station_blueprint')
local Module = require('modutram_module')
local t = require('modutram_types')
local c = require('modutram_constants')

describe('StationBlueprint', function ()
    
    local modules = {
        platform_left = 'platform_left.module',
        platform_right = 'platform_right.module',
        platform_double = 'platform_double.module',
        track_up_doors_right = 'track_up.module',
        track_down_doors_right = 'track_down.module',
        track_double_doors_right = 'track_double.module'
    }

    describe('create_template', function ()
        
        -- ] || || [] || || [] || || [
        describe('pattern 0', function ()
            
            it('creates template with one double track only', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 0,
                    modules = modules,
                    platforms_left = 0,
                    platforms_right = 0,
                    segments_per_platform = 1
                }
                assert.are.same(
                    {
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module'
                    },
                    station_blueprint:create_template()
                )
            end)

            it('creates template with double track and single platform left (type platform right)', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 0,
                    modules = modules,
                    platforms_left = 1,
                    platforms_right = 0,
                    segments_per_platform = 1
                }
                assert.are.same(
                    {
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0})] = 'platform_right.module',
                    },
                    station_blueprint:create_template()
                )
            end)

            it('creates template with double track and single platform left (type platform right) with two segments', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 0,
                    modules = modules,
                    platforms_left = 1,
                    platforms_right = 0,
                    segments_per_platform = 2
                }
                assert.are.same(
                    {
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 1})] = 'platform_right.module',
                    },
                    station_blueprint:create_template()
                )
            end)

            it('creates template with double track and single platform left (type platform right) with three segments', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 0,
                    modules = modules,
                    platforms_left = 1,
                    platforms_right = 0,
                    segments_per_platform = 3
                }
                assert.are.same(
                    {
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = -1})] = 'platform_right.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 1})] = 'platform_right.module',
                    },
                    station_blueprint:create_template()
                )
            end)

            it('creates template with double track and single platform left (type platform right) with four segments', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 0,
                    modules = modules,
                    platforms_left = 1,
                    platforms_right = 0,
                    segments_per_platform = 4
                }
                assert.are.same(
                    {
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = -1})] = 'platform_right.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 1})] = 'platform_right.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 2})] = 'platform_right.module',
                    },
                    station_blueprint:create_template()
                )
            end)

            it('creates template with double track and single platform right (type platform left)', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 0,
                    modules = modules,
                    platforms_left = 0,
                    platforms_right = 1,
                    segments_per_platform = 1
                }
                assert.are.same(
                    {
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module',
                        [Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})] = 'platform_left.module',
                    },
                    station_blueprint:create_template()
                )
            end)

            it('creates template with double track and single platform left and right', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 0,
                    modules = modules,
                    platforms_left = 1,
                    platforms_right = 1,
                    segments_per_platform = 2
                }
                assert.are.same(
                    {
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 1})] = 'platform_right.module',
                        [Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})] = 'platform_left.module',
                        [Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})] = 'platform_left.module',
                    },
                    station_blueprint:create_template()
                )
            end)

            it ('creates template with double platform left and single platform right', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 0,
                    modules = modules,
                    platforms_left = 2,
                    platforms_right = 1,
                    segments_per_platform = 1
                }
                assert.are.same(
                    {
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module',
                        [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = -1, grid_y = 0})] = 'platform_double.module',
                        [Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = -2, grid_y = 0})] = 'track_up.module',
                        [Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})] = 'platform_left.module',
                    },
                    station_blueprint:create_template()
                )
            end)

            it ('creates template with double platform and single platform left and single platform right', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 0,
                    modules = modules,
                    platforms_left = 3,
                    platforms_right = 1,
                    segments_per_platform = 1
                }
                assert.are.same(
                    {
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -3, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = -2, grid_y = 0})] = 'track_double.module',
                        [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = -1, grid_y = 0})] = 'platform_double.module',
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module',
                        [Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})] = 'platform_left.module',
                    },
                    station_blueprint:create_template()
                )
            end)

            it ('creates big station', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 0,
                    modules = modules,
                    platforms_left = 3,
                    platforms_right = 4,
                    segments_per_platform = 3
                }

                assert.are.same(
                    {
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module',

                        [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = -1, grid_y = -1})] = 'platform_double.module',
                        [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = -1, grid_y = 0})] = 'platform_double.module',
                        [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = -1, grid_y = 1})] = 'platform_double.module',

                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = -2, grid_y = 0})] = 'track_double.module',

                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -3, grid_y = -1})] = 'platform_right.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -3, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -3, grid_y = 1})] = 'platform_right.module',

                        [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 1, grid_y = -1})] = 'platform_double.module',
                        [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 1, grid_y = 0})] = 'platform_double.module',
                        [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 1, grid_y = 1})] = 'platform_double.module',

                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 2, grid_y = 0})] = 'track_double.module',

                        [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 3, grid_y = -1})] = 'platform_double.module',
                        [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 3, grid_y = 0})] = 'platform_double.module',
                        [Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 3, grid_y = 1})] = 'platform_double.module',

                        [Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 4, grid_y = 0})] = 'track_down.module',
                    },
                    station_blueprint:create_template()
                )
            end)

        end)

        -- ] || ] || ] |||| [ || [ || [
        describe('pattern 1', function ()
            
            it('creates template with one double track only', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 1,
                    modules = modules,
                    platforms_left = 0,
                    platforms_right = 0,
                    segments_per_platform = 1
                }
                assert.are.same(
                    {
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module'
                    },
                    station_blueprint:create_template()
                )
            end)

            it('creates template with double track and single platform left and right', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 1,
                    modules = modules,
                    platforms_left = 1,
                    platforms_right = 1,
                    segments_per_platform = 2
                }
                assert.are.same(
                    {
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 1})] = 'platform_right.module',
                        [Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})] = 'platform_left.module',
                        [Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 1})] = 'platform_left.module',
                    },
                    station_blueprint:create_template()
                )
            end)

            it ('creates template with two single platforms left and single platform right', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 1,
                    modules = modules,
                    platforms_left = 2,
                    platforms_right = 1,
                    segments_per_platform = 1
                }
                assert.are.same(
                    {
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -3, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = -2, grid_y = 0})] = 'track_down.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module',
                        [Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})] = 'platform_left.module',
                    },
                    station_blueprint:create_template()
                )
            end)

            it ('creates template with three single platforms left and single platform right', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 1,
                    modules = modules,
                    platforms_left = 3,
                    platforms_right = 1,
                    segments_per_platform = 1
                }
                assert.are.same(
                    {
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -5, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = -4, grid_y = 0})] = 'track_down.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -3, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = -2, grid_y = 0})] = 'track_down.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module',
                        [Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})] = 'platform_left.module',
                    },
                    station_blueprint:create_template()
                )
            end)

            it ('creates big station', function ()
                local station_blueprint = StationBlueprint:new{
                    platform_placing_pattern = 1,
                    modules = modules,
                    platforms_left = 3,
                    platforms_right = 4,
                    segments_per_platform = 1
                }

                assert.are.same(
                    {
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -5, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = -4, grid_y = 0})] = 'track_down.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -3, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = -2, grid_y = 0})] = 'track_down.module',
                        [Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -1, grid_y = 0})] = 'platform_right.module',
                        [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 0, grid_y = 0})] = 'track_double.module',
                        [Module.make_id({type = t.PLATFORM_LEFT, grid_x = 1, grid_y = 0})] = 'platform_left.module',
                        [Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = 2, grid_y = 0})] = 'track_up.module',
                        [Module.make_id({type = t.PLATFORM_LEFT, grid_x = 3, grid_y = 0})] = 'platform_left.module',
                        [Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = 4, grid_y = 0})] = 'track_up.module',
                        [Module.make_id({type = t.PLATFORM_LEFT, grid_x = 5, grid_y = 0})] = 'platform_left.module',
                        [Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = 6, grid_y = 0})] = 'track_up.module',
                        [Module.make_id({type = t.PLATFORM_LEFT, grid_x = 7, grid_y = 0})] = 'platform_left.module',
                        
                    },
                    station_blueprint:create_template()
                )
            end)

        end)

    end)

end)