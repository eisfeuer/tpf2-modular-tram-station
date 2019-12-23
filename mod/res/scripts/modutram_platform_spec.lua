local Platform = require('modutram_platform')
local t = require('modutram_types')
local Module = require('modutram_module')

describe('platform', function ()
    describe('new', function ()
        local platform = Platform:new{id = 3, x_pos = 30, type = t.PLATFORM_SINGLE_LEFT}

        it('has id', function ()
            assert.are.equal(3, platform.id)
        end)

        it('has x position', function ()
            assert.are.equal(30, platform.x_pos)
        end)

        it('has zero x position when x position is missing', function ()
            local zero_x_platform = Platform:new{id = 3, type = t.PLATFORM_SINGLE_LEFT}
            assert.are.equal(0, zero_x_platform.x_pos)
        end)

        it('has type', function ()
            assert.are.equal(t.PLATFORM_SINGLE_LEFT, platform.type)
        end)

        it('has no segments', function ()
            assert.are.same({}, platform.segments)
        end)

        it('has no top street connection', function ()
            assert.are.equal(nil, platform.street_top)
        end)

        it('has no bottom street connection', function ()
            assert.are.equal(nil, platform.street_btm)
        end)
    end)

    describe('add_segment', function ()
        it('adds segment', function ()
            local platform = Platform:new{id = 3, x_pos = 30, type = t.PLATFORM_DOUBLE}
            local segmentModule = Module:new({id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1
            })})
            local segmentModule2 = Module:new({id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 0
            })})
            local segmentModule3 = Module:new({id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 2
            })})

            platform:add_segment(segmentModule)

            assert.are.equal(1, #platform.segments)
            assert.are.equal(1, platform.segments[1].id)
            assert.are.equal(1, platform.top_segment_id)
            assert.are.equal(1, platform.btm_segment_id)

            platform:add_segment(segmentModule2)

            assert.are.equal(2, #platform.segments)
            assert.are.equal(0, platform.segments[2].id)
            assert.are.equal(1, platform.top_segment_id)
            assert.are.equal(0, platform.btm_segment_id)

            platform:add_segment(segmentModule3)

            assert.are.equal(3, #platform.segments)
            assert.are.equal(2, platform.segments[3].id)
            assert.are.equal(2, platform.top_segment_id)
            assert.are.equal(0, platform.btm_segment_id)
        end)
    end)

    describe('center_segment_id', function ()
        it ('returns nil when platform has no segments', function ()
            local platform = Platform:new{id = 3, x_pos = 30, type = t.PLATFORM_DOUBLE}
            assert.are.equal(nil, platform:center_segment_id())
        end)
        it('returs center slot id', function ()
            local platform = Platform:new{id = 3, x_pos = 30, type = t.PLATFORM_DOUBLE}
            local segmentModule = Module:new({id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1
            })})
            local segmentModule2 = Module:new({id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 0
            })})
            local segmentModule3 = Module:new({id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 2
            })})

            platform:add_segment(segmentModule)
            platform:add_segment(segmentModule2)
            platform:add_segment(segmentModule3)

            assert.are.equal(1, platform:center_segment_id())
        end)
    end)

    describe('find_segment', function ()
        it ('returns segment with given id', function ()
            local platform = Platform:new{id = 3, x_pos = 30, type = t.PLATFORM_DOUBLE}
            local segmentModule = Module:new({id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1
            })})
            local segmentModule2 = Module:new({id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 0
            })})
            local segmentModule3 = Module:new({id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 2
            })})

            platform:add_segment(segmentModule)
            platform:add_segment(segmentModule2)
            platform:add_segment(segmentModule3)

            assert.are.equal(2, platform:find_segment(2).id)
            assert.are.equal(nil, platform:find_segment(4))
        end)
    end)

    describe('slot_range', function ()
        it ('returns 0 when platform has no segments', function ()
            local platform = Platform:new{id = 3, x_pos = 30, type = t.PLATFORM_DOUBLE}
            local top, btm = platform:slot_range()
            assert.are.equal(0, top)
            assert.are.equal(0, btm)
        end)
        it ('returns grid range of platform slots', function ()
            local platform = Platform:new{id = 3, x_pos = 30, type = t.PLATFORM_DOUBLE}
            local segmentModule = Module:new({id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 1
            })})
            local segmentModule2 = Module:new({id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 0
            })})
            local segmentModule3 = Module:new({id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = 2
            })})
            local segmentModule4 = Module:new({id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 3,
                grid_y = -2
            })})

            platform:add_segment(segmentModule)
            platform:add_segment(segmentModule2)
            platform:add_segment(segmentModule3)
            platform:add_segment(segmentModule4)

            local top, btm = platform:slot_range()
            assert.are.equal(3, top)
            assert.are.equal(-1, btm)
        end)
    end)

    describe('is_platform', function ()
        it('is is platform', function ()
            local platform = Platform:new{id = 3, x_pos = 30, type = t.PLATFORM_DOUBLE}
            assert.is_true(platform:is_platform())
        end)
    end)

    describe('is_track', function ()
        it('is not a track', function ()
            local platform = Platform:new{id = 3, x_pos = 30, type = t.PLATFORM_DOUBLE}
            assert.is_false(platform:is_track())
        end)
    end)
end)