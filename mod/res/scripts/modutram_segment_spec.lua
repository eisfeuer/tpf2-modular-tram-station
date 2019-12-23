local Segment = require('modutram_segment')
local c = require('modutram_constants')

describe('segment', function ()
    local segment = Segment:new{id = 5}

    it('has id', function ()
        assert.are.equal(5, segment.id)
    end)

    it('has y position', function ()
        assert.are.equal(5 * c.PLATFORM_SEGMENT_LENGTH, segment.y_pos)
    end)
end)