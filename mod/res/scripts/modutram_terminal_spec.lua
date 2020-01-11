local Terminal = require('modutram_terminal')

describe('terminal', function ()
    describe('to_array', function ()
        it('converts terminal to array necessary for output', function ()
            local terminal = Terminal:new{model = 'terminal/model.mdl', terminal_position = 2}
            assert.are.same({'terminal/model.mdl', 2}, terminal:to_array())
        end)
    end)
end)