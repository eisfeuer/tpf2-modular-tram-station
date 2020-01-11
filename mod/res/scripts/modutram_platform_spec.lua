local Platform = require('modutram_platform')
local t = require('modutram_types')
local Module = require('modutram_module')
local c = require('modutram_constants')
local Track = require('modutram_track')

local function round_to_5_digits(number)
    local factor = 10 ^ 5
    return math.floor(number * factor + 0.5) / factor
end

describe('platform', function ()
    describe('new', function ()
        local platform = Platform:new{id = 3, x_pos = 30, type = t.PLATFORM_LEFT}

        it('has id', function ()
            assert.are.equal(3, platform.id)
        end)

        it('has x position', function ()
            assert.are.equal(30, platform.x_pos)
        end)

        it('has zero x position when x position is missing', function ()
            local zero_x_platform = Platform:new{id = 3, type = t.PLATFORM_LEFT}
            assert.are.equal(0, zero_x_platform.x_pos)
        end)

        it('has type', function ()
            assert.are.equal(t.PLATFORM_LEFT, platform.type)
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

        it('has initial transformation matrix for path models', function ()
            assert.are.same({
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                30 + (c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM) * -1, 0, 0, 1
            }, platform.left_path_model_transformation)
            assert.are.equal(nil, platform.right_path_model_transformation)

            local double_platform = Platform:new{id = 3, x_pos = 30, type = t.PLATFORM_DOUBLE}
            assert.are.same({
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                30 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.PLATFORM_DOUBLE_WIDTH / 2, 0, 0, 1
            }, double_platform.left_path_model_transformation)
            assert.are.same({
                -1, 0, 0, 0,
                0, -1, 0, 0,
                0, 0, 1, 0,
                30 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2, 0, 0, 1
            }, double_platform.right_path_model_transformation)

            local right_platform = Platform:new{id = 3, x_pos = 30, type = t.PLATFORM_RIGHT}
            assert.are.equal(nil, right_platform.left_path_model_transformation)
            assert.are.same({
                -1, 0, 0, 0,
                0, -1, 0, 0,
                0, 0, 1, 0,
                30 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2, 0, 0, 1
            }, right_platform.right_path_model_transformation)
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

    describe('is_double_platform', function ()
        it('checks whether platform is a double platform', function ()
            local platform1 = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_LEFT}
            local platform2 = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_RIGHT}
            local platform3 = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_DOUBLE}

            assert.is_false(platform1:is_double_platform())
            assert.is_false(platform2:is_double_platform())
            assert.is_true(platform3:is_double_platform())
        end)
    end)

    describe('get_segment_count', function ()
        it('returns the count of segments', function ()
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

            assert.are.equal(5, platform:get_ideal_segment_count())
        end)
    end)

    describe('get_width', function ()
        it('gets width', function ()
            local platform1 = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_LEFT}
            local platform2 = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_RIGHT}
            local platform3 = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_DOUBLE}

            assert.are.equal(c.PLATFORM_SINGLE_WIDTH, platform1:get_width())
            assert.are.equal(c.PLATFORM_SINGLE_WIDTH, platform2:get_width())
            assert.are.equal(c.PLATFORM_DOUBLE_WIDTH, platform3:get_width())
        end)
    end)

    describe('set_height', function ()
        local double_platform = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_DOUBLE}
        double_platform:set_height(0.2)
        local left_platform = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_LEFT}
        left_platform:set_height(0.4)

        assert.are.equal(0.2, double_platform.left_path_model_transformation[11])
        assert.are.equal(0.2, double_platform.right_path_model_transformation[11])

        assert.are.equal(0.4, left_platform.left_path_model_transformation[11])
        assert.are.equal(nil, left_platform.right_path_model_transformation)
    end)

    describe('set_x_position', function ()
        it ('sets x position and recalculates position matrixes', function ()
            local double_platform = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_DOUBLE}
            double_platform:set_x_position(20)
            assert.are.equal(20, double_platform.x_pos)
            assert.are.equal(round_to_5_digits(20 - c.PLATFORM_DOUBLE_WIDTH/2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM), round_to_5_digits(double_platform.left_path_model_transformation[13]))
            assert.are.equal(20 + c.PLATFORM_DOUBLE_WIDTH/2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, double_platform.right_path_model_transformation[13])

            local left_platform = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_LEFT}
            left_platform:set_x_position(20)
            assert.are.equal(20, left_platform.x_pos)
            assert.are.equal(nil, left_platform.right_path_model_transformation)
            assert.are.equal(round_to_5_digits(20 - c.PLATFORM_SINGLE_WIDTH/2 - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM), round_to_5_digits(left_platform.left_path_model_transformation[13]))

            local right_platform = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_RIGHT}
            right_platform:set_x_position(20)
            assert.are.equal(20, right_platform.x_pos)
            assert.are.equal(nil, right_platform.left_path_model_transformation)
            assert.are.equal(round_to_5_digits(20 + c.PLATFORM_SINGLE_WIDTH/2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM), round_to_5_digits(right_platform.right_path_model_transformation[13]))
        end)
    end)

    describe('get_distance_to_neighbor', function ()
        it('gets distance between single platform and single track', function ()
            local track = Track:new{id = 1, x_pos = 12, type = t.TRACK_DOWN_CARGO_DOORS_RIGHT}
            local track2 = Track:new{id = 1, x_pos = 12, type = t.TRACK_UP_DOORS_RIGHT}
            local platform = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_LEFT}
            local platform2 = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_RIGHT}

            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2, platform:get_distance_to_neighbor(track))
            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2, platform:get_distance_to_neighbor(track2))
            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2, platform2:get_distance_to_neighbor(track))
            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2, platform2:get_distance_to_neighbor(track2))
        end)

        it('gets distance between double platform and single track', function ()
            local track = Track:new{id = 1, x_pos = 12, type = t.TRACK_DOWN_CARGO_DOORS_RIGHT}
            local track2 = Track:new{id = 1, x_pos = 12, type = t.TRACK_UP_DOORS_RIGHT}
            local platform = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_DOUBLE}

            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2, platform:get_distance_to_neighbor(track))
            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2, platform:get_distance_to_neighbor(track2))
        end)

        it('gets distance between double platform and double track', function ()
            local track = Track:new{id = 1, x_pos = 12, type = t.TRACK_DOUBLE_DOORS_RIGHT}
            local platform = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_DOUBLE}

            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TWO_TRACKS / 2, platform:get_distance_to_neighbor(track))
        end)

        it('gets distance between single platform and double track', function ()
            local track = Track:new{id = 1, x_pos = 12, type = t.TRACK_DOUBLE_DOORS_RIGHT}
            local platform = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_LEFT}
            local platform2 = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_RIGHT}

            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TWO_TRACKS / 2, platform:get_distance_to_neighbor(track))
            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TWO_TRACKS / 2, platform2:get_distance_to_neighbor(track))
        end)
    end)
end)