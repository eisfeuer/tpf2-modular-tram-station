local Track = require('modutram_track')
local t = require('modutram_types')
local c = require('modutram_constants')
local Platform = require('modutram_platform')

describe('Track', function ()

    describe('new', function ()
        it('creates a track', function ()
            local track = Track:new{id = 1, type = t.TRACK_DOUBLE_DOORS_RIGHT}
            assert.are.same(1, track.id)
            assert.are.same(t.TRACK_DOUBLE_DOORS_RIGHT, track.type)
        end)
    end)

    it('is a track', function ()
        local track = Track:new{id = 1, type = t.TRACK_DOUBLE_DOORS_RIGHT}
        assert.is_true(track:is_track())
    end)

    it('is not a platform', function ()
        local track = Track:new{id = 1, type = t.TRACK_DOUBLE_DOORS_RIGHT}
        assert.is_false(track:is_platform())
    end)

    describe('is_double_track', function ()
        it('checks wheather track is a double track', function ()
            local track1 = Track:new{id = 1, type = t.TRACK_DOUBLE_DOORS_RIGHT}
            local track2 = Track:new{id = 1, type = t.TRACK_UP_DOORS_RIGHT}
            local track3 = Track:new{id = 1, type = t.TRACK_DOWN_DOORS_RIGHT}

            assert.is_true(track1:is_double_track())
            assert.is_false(track2:is_double_track())
            assert.is_false(track3:is_double_track())
        end)
    end)

    describe('get_distance_from_center_to_platform_edge', function ()
        it('gets distance to platform edge', function ()
            local track1 = Track:new{id = 1, type = t.TRACK_DOUBLE_DOORS_RIGHT}
            local track2 = Track:new{id = 1, type = t.TRACK_UP_DOORS_RIGHT}
            local track3 = Track:new{id = 1, type = t.TRACK_DOWN_DOORS_RIGHT}

            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS / 2, track1:get_distance_from_center_to_platform_edge())
            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, track2:get_distance_from_center_to_platform_edge())
            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, track2:get_distance_from_center_to_platform_edge())
        end)
    end)

    describe('get_distance_to_neighbor', function ()
        it('gets distance between single platform and single track', function ()
            local track = Track:new{id = 1, x_pos = 12, type = t.TRACK_DOWN_CARGO_DOORS_RIGHT}
            local track2 = Track:new{id = 1, x_pos = 12, type = t.TRACK_UP_DOORS_RIGHT}
            local platform = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_LEFT}
            local platform2 = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_RIGHT}

            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2, track:get_distance_to_neighbor(platform))
            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2, track:get_distance_to_neighbor(platform2))
            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2, track2:get_distance_to_neighbor(platform))
            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2, track2:get_distance_to_neighbor(platform2))
        end)

        it('gets distance between double platform and single track', function ()
            local track = Track:new{id = 1, x_pos = 12, type = t.TRACK_DOWN_CARGO_DOORS_RIGHT}
            local track2 = Track:new{id = 1, x_pos = 12, type = t.TRACK_UP_DOORS_RIGHT}
            local platform = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_DOUBLE}

            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2, track:get_distance_to_neighbor(platform))
            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2, track2:get_distance_to_neighbor(platform))
        end)

        it('gets distance between double platform and double track', function ()
            local track = Track:new{id = 1, x_pos = 12, type = t.TRACK_DOUBLE_DOORS_RIGHT}
            local platform = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_DOUBLE}

            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_DOUBLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TWO_TRACKS / 2, track:get_distance_to_neighbor(platform))
        end)

        it('gets distance between single platform and double track', function ()
            local track = Track:new{id = 1, x_pos = 12, type = t.TRACK_DOUBLE_DOORS_RIGHT}
            local platform = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_LEFT}
            local platform2 = Platform:new{id = 0, x_pos = 0, type = t.PLATFORM_RIGHT}

            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TWO_TRACKS / 2, track:get_distance_to_neighbor(platform))
            assert.are.equal(c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.PLATFORM_SINGLE_WIDTH / 2 + c.DISTANCE_BETWEEN_TWO_TRACKS / 2, track:get_distance_to_neighbor(platform2))
        end)
    end)

    describe('set_x_position', function ()
        it('sets x position', function ()
            local track = Track:new{id = 1, x_pos = 12, type = t.TRACK_DOUBLE_DOORS_RIGHT}
            track:set_x_position(20)
            assert.are.equal(20, track.x_pos)
        end)
    end)
end)