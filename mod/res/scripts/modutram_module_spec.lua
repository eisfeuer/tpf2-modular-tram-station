describe('Module', function ()
    local natbomb = require('natbomb')
    local Module = require('modutram_module')
    local t = require('modutram_types')

    describe('make_id', function ()

        it('generates module id', function ()
            local id = Module.make_id({
                type = t.TRACK_UP_DOORS_RIGHT,
                grid_x = 3,
                grid_y = 1,
                asset_id = 2,
                asset_decoration_id = 3
            })

            assert.are.equal(natbomb.implode({8, 7, 7, 6}, {t.TRACK_UP_DOORS_RIGHT, 3 +  64, 1 + 64, 2, 3}), id)
        end)
    end)

    describe('object', function ()
        local moduleId = natbomb.implode({8, 7, 7, 6}, {t.TRACK_UP_DOORS_RIGHT, 3 +  64, 1 + 64, 2, 3})
        local mod = Module:new{id = moduleId}

        it('has id', function ()
            assert.are.equal(moduleId, mod.id)
        end)

        it('has type', function ()
            assert.are.equal(t.TRACK_UP_DOORS_RIGHT, mod.type)
        end)

        it('has grid x position', function ()
            assert.are.equal(3, mod.grid_x)
        end)

        it('has grid y position', function ()
            assert.are.equal(1, mod.grid_y)
        end)

        it('has asset id', function ()
            assert.are.equal(2, mod.asset_id)
        end)

        it('has asset decoration id', function ()
            assert.are.equal(3, mod.asset_decoration_id)
        end)
    end)
end)