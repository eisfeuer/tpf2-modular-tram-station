local ColumnCollection = require('modutram_column_collection')
local Module = require('modutram_module')
local t = require('modutram_types')

describe('ColumnCollection', function ()
    describe('new', function ()
        it('creates empty collection', function ()
            local collection = ColumnCollection:new{}
            assert.are.same({}, collection.columns)
        end)
    end)

    describe('add', function ()
        it('creates a new platform', function ()
            local collection = ColumnCollection:new{}
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 0
                })}
            )

            assert.are.equal(0, collection:get_column(0):find_segment(0).id)
        end)

        it('adds segment to platform', function ()
            local collection = ColumnCollection:new{}
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 0
                })}
            )
            collection:add(
                Module:new{id = Module.make_id({
                    type = t.PLATFORM_DOUBLE,
                    grid_x = 0,
                    grid_y = 1
                })}
            )

            assert.are.equal(2, #collection:get_column(0).segments)
            assert.are.equal(1, collection:get_column(0):find_segment(1).id)
        end)
    end)

    describe('is_empty', function ()
        local collection = ColumnCollection:new{}
        assert.is_true(collection:is_empty())
        collection:add(
            Module:new{id = Module.make_id({
                type = t.PLATFORM_DOUBLE,
                grid_x = 0,
                grid_y = 0
            })}
        )
        assert.is_false(collection:is_empty())
    end)
end)