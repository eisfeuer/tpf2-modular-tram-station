local Matrix = require('modutram_matrix')

local function matrix_is_very_near_to(expected, passed)
    for i = 1, 16 do
        if expected[i] < passed[i] - 0.000001 or expected[i] > passed[i] + 0.0000001 then
            print('Matrices are not equal at position ' .. i .. '. Expected: ' .. expected[i] .. ' Passed in: ' .. passed[i])
            return false
        end
    end
    return true
end

describe('matrix', function ()
    describe('rotate_around_z_axis', function ()
        local matrix = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            1, 2, 4, 1,
        }

        local rotated_matrix = Matrix.rotate_around_z_axis(90, matrix)        

        assert.are_not.equal(matrix, rotated_matrix)
        assert.is_true(matrix_is_very_near_to({
            0, -1, 0, 0,
            1, 0, 0, 0,
            0, 0, 1, 0,
            1, 2, 4, 1,
        }, rotated_matrix))
    end)
end)