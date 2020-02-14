local Station = require('modutram_station')
local t = require('modutram_types')
local Module = require('modutram_module')
local c = require('modutram_constants')

describe('station', function ()
    describe('new', function ()
        it ('creates empty station', function ()
            local station = Station:new({}, {})
            assert.are.same({}, station.columns.columns)
            assert.are.same({}, station.terminal_groups)
        end)

        it ('creates station with a platform', function ()
            local modules = {
                [Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 0
                })] = 'a_module'
            }

            local station = Station:new({}, modules)
            assert.are.equal(0, station:get_column(0).id)
            assert.are.equal(1, #station:get_column(0).segments)
        end)

        it('creates station with a track', function ()
            local modules = {
                [Module.make_id({
                    type = t.TRACK_DOUBLE_DOORS_RIGHT,
                    grid_x = 0,
                    grid_y = 0
                })] = 'a_module'
            }

            local station = Station:new({}, modules)
            assert.are.equal(0, station:get_column(0).id)
        end)

        it('creates station with a platform a two tracks', function ()
            local modules = {
                [Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 0
                })] = 'a_module',
                [Module.make_id({
                    type = t.TRACK_DOUBLE_DOORS_RIGHT,
                    grid_x = -1,
                    grid_y = 0
                })] = 'a_module',
                [Module.make_id({
                    type = t.TRACK_DOWN_DOORS_RIGHT,
                    grid_x = 1,
                    grid_y = 0
                })] = 'a_module'
            }

            local station = Station:new({}, modules)

            assert.are.equal(-1, station:get_column(-1).id)
            assert.are.equal(0, station:get_column(0).id)
            assert.are.equal(1, station:get_column(1).id)

            assert.are.equal(-c.PLATFORM_DOUBLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.DISTANCE_BETWEEN_TWO_TRACKS / 2, station:get_column(-1).x_pos)
            assert.are.equal(0, station:get_column(0).x_pos)
            assert.are.equal(c.PLATFORM_DOUBLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, station:get_column(1).x_pos)
        end)

        it('creates station with a track and two platforms', function ()
            local modules = {
                [Module.make_id({
                    type = t.TRACK_UP_DOORS_RIGHT,
                    grid_x = 0,
                    grid_y = 0
                })] = 'a_module',
                [Module.make_id({
                    type = t.PLATFORM_LEFT,
                    grid_x = -1,
                    grid_y = 0
                })] = 'a_module',
                [Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 1,
                    grid_y = 0
                })] = 'a_module'
            }

            local station = Station:new({}, modules)

            assert.are.equal(-1, station:get_column(-1).id)
            assert.are.equal(0, station:get_column(0).id)
            assert.are.equal(1, station:get_column(1).id)

            assert.are.equal(-c.PLATFORM_SINGLE_WIDTH / 2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, station:get_column(-1).x_pos)
            assert.are.equal(0, station:get_column(0).x_pos)
            assert.are.equal(c.PLATFORM_DOUBLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, station:get_column(1).x_pos)
        end)
    end)

    describe('is_empty', function ()
        it ('is empty when the station has no platforms or tracks', function ()
            local station1 = Station:new({}, {})
            local station2 = Station:new({}, {[Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 0})] = 'a_module'})

            assert.is_true(station1:is_empty())
            assert.is_false(station2:is_empty())
        end)
    end)

    describe('get_models', function ()
        it('has a question mark when station is empty', function ()
            local station = Station:new({}, {})
            assert.are.same({{
                id = 'asset/icon/marker_question.mdl',
                transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
            }}, station:get_models())
        end)
    end)

    describe('get_slots', function ()
        it('gets slots', function ()
            local station = Station:new({}, {})
            assert.are.equal(6, #station:get_slots())
        end)
    end)

    describe('is_top_segment_of_a_platform', function ()
        it ('checks whether given segment id comes from a segment which is on top of a platform', function ()
            local top_segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 1})
            local mid_segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 0})
            local btm_segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = -1})

            local station = Station:new({}, { 
                [top_segment_id] = 'a_module.module',
                [mid_segment_id] = 'a_module.module',
                [btm_segment_id] = 'a_module.module'
            })

            assert.is_true(station:is_top_segment_of_a_platform(top_segment_id))
            assert.is_false(station:is_top_segment_of_a_platform(mid_segment_id))
            assert.is_false(station:is_top_segment_of_a_platform(btm_segment_id))
        end)

        describe('is_bottom_segment_of_a_platform', function ()
            it ('checks whether given segment id comes from a segment which is at the bottom of a platform', function ()
                local top_segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 1})
                local mid_segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 0})
                local btm_segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = -1})
    
                local station = Station:new({}, { 
                    [top_segment_id] = 'a_module.module',
                    [mid_segment_id] = 'a_module.module',
                    [btm_segment_id] = 'a_module.module'
                })
    
                assert.is_false(station:is_bottom_segment_of_a_platform(top_segment_id))
                assert.is_false(station:is_bottom_segment_of_a_platform(mid_segment_id))
                assert.is_true(station:is_bottom_segment_of_a_platform(btm_segment_id))
            end)
        end)
    end)

    describe('module', function ()
        it ('checks whether asset slot is occupied', function ()
            local platform_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 0})
            local platform_asset_id = Module.make_id({type = t.ASSET_SHELTER, grid_x = 0, grid_y = 0, asset_id = 1})

            local station = Station:new({}, {
                [platform_id] = 'platform.module',
                [platform_asset_id] = 'shelter.module'
            })

            assert.is_true(station:module(platform_id):has_placed_asset_on_slot(t.ASSET_SHELTER, 1, 'shelter.module'))
        end)
    end)
end)