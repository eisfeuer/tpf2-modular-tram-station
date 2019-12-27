local Track = require('modutram_track')
local t = require('modutram_types')

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
end)