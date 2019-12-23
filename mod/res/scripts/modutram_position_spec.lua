local Position = require('modutram_position')

describe('Position', function ()
    describe('new', function ()
        it ('creates position and sets missing values to zero', function ()
            local pos = Position:new{x = 1}
            assert.are.equal(1, pos.x)
            assert.are.equal(0, pos.y)
            assert.are.equal(0, pos.z)
        end)
    end)

    describe('as_matrix', function ()
        it('returns position as transformation matrix', function ()
            local pos = Position:new{x = 1, y = 2, z = 3}
            assert.are.same({
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                1, 2, 3, 1
            }, pos:as_matrix())
        end)
    end)
end)