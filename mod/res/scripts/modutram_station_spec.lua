local Station = require('modutram_station')
local t = require('modutram_types')
local Module = require('modutram_module')

describe('station', function ()
    describe('new', function ()
        it ('creates empty station', function ()
            local station = Station:new({}, {})
            assert.are.same({}, station.columns.columns)
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
    end)

    describe('is_empty', function ()
        it ('is empty when the station has no platforms or tracks', function ()
            local station1 = Station:new({}, {})
            local station2 = Station:new({}, {[Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 0})] = 'a_module'})

            assert.is_true(station1:is_empty())
            assert.is_false(station2:is_empty())
        end)
    end)

    describe('models', function ()
        it('has a question mark when station is empty', function ()
            local station = Station:new({}, {})
            assert.are.same({{
                id = 'asset/icon/marker_question.mdl',
                transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
            }}, station:get_models())
        end)
    end)
end)