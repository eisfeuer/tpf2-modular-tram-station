local AssetSlot = require('modutram_asset_slot')
local SlotCollection = require('modutram_slot_collection')
local t = require('modutram_types')
local Module = require('modutram_module')

local function matrix_is_very_near_to(expected, passed)
    for i = 1, 16 do
        if expected[i] < passed[i] - 0.000001 or expected[i] > passed[i] + 0.0000001 then
            print('Matrices are not equal at position ' .. i .. '. Expected: ' .. expected[i] .. ' Passed in: ' .. passed[i])
            return false
        end
    end
    return true
end

describe('AssetSlot', function ()
    
    describe('new', function ()
         
        it ('creates a decoration slot', function ()
            local slot_collection = SlotCollection:new{}
            local segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = 1})
            local asset_slot = AssetSlot:new{slot_collection = slot_collection, segment_id = segment_id, asset_id = 3}

            assert.are.equal(t.ASSET_DECORATION, asset_slot.module_type)
            assert.are.equal('g_decoration', asset_slot.slot_type)
            assert.are.same({
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1,
            }, asset_slot.transformation)
            assert.are.same({0.1, 0.1, 0.1, 0.1}, asset_slot.spacing)
            assert.is_true(asset_slot.allow_global_slot)
        end)

    end)

    describe('of_type', function ()

        it ('changes typw of slot', function ()
            local slot_collection = SlotCollection:new{}
            local segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = 1})
            local asset_slot = AssetSlot:new{slot_collection = slot_collection, segment_id = segment_id, asset_id = 3}

            local decorated_asset_slot = asset_slot:of_type(t.ASSET_SHELTER, 'busstop_shelter')
            assert.are.equal(t.ASSET_SHELTER, asset_slot.module_type)
            assert.are.equal('busstop_shelter', asset_slot.slot_type)
        end)

    end)
    
    describe('with_spacing', function ()
        it ('disable global asset slots', function ()
            local slot_collection = SlotCollection:new{}
            local segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = 1})
            local asset_slot = AssetSlot:new{slot_collection = slot_collection, segment_id = segment_id, asset_id = 3}:with_spacing({2, 1, 2, 1})

            assert.are.same({2, 1, 2, 1}, asset_slot.spacing)
        end)
    end)

    describe('move', function ()
        it ('moves asset', function ()
            local slot_collection = SlotCollection:new{}
            local segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = 1})
            local pivot = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                2, 4, 3, 1
            }

            local asset_slot = AssetSlot:new{slot_collection = slot_collection, segment_id = segment_id, asset_id = 3, transformation = pivot}:move(2, 3, -5)
            assert.are.same({
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                4, 7, -2, 1
            }, asset_slot.transformation)
        end)
    end)

    describe('rotate', function ()
        it ('rotates slot around the z axis', function ()
            local slot_collection = SlotCollection:new{}
            local segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = 1})
            local pivot = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                2, 4, 3, 1
            }

            local asset_slot = AssetSlot:new{slot_collection = slot_collection, segment_id = segment_id, asset_id = 3, transformation = pivot}:rotate(90)

            assert.is_true(matrix_is_very_near_to({
                0, -1, 0, 0,
                1, 0, 0, 0,
                0, 0, 1, 0,
                2, 4, 3, 1
            }, asset_slot.transformation))
        end)
    end)

    describe('as_slot', function ()
        it('converts asset slot in tpf2 slot format', function (arg1, arg2, arg3)
            local slot_collection = SlotCollection:new{}
            local segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = 1})
            local pivot = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                2, 4, 3, 1
            }

            local asset_slot = AssetSlot:new{slot_collection = slot_collection, segment_id = segment_id, asset_id = 3, transformation = pivot}
                :with_spacing({1, 2, 3, 4}):of_type(t.ASSET_SHELTER, 'shelter')
            local slot_id = Module.make_id({type = t.ASSET_SHELTER, grid_x = 2, grid_y = 1, asset_id = 3})

            assert.are.same({
                id = slot_id,
                transf = pivot,
                type = 'shelter',
                spacing = {1, 2, 3, 4}
            }, asset_slot:as_slot())
        end)  
    end)

    describe('add_to_slots', function ()
        it ('adds global and non global slot to collection', function ()
            local slot_collection = SlotCollection:new{}
            local segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = 1})
            local pivot = {
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                2, 4, 3, 1
            }

            local asset_slot = AssetSlot:new{slot_collection = slot_collection, segment_id = segment_id, asset_id = 3, transformation = pivot}
                :with_spacing({1, 2, 3, 4}):of_type(t.ASSET_SHELTER, 'shelter'):add_to_slots()
            local slot_id = Module.make_id({type = t.ASSET_SHELTER, grid_x = 2, grid_y = 1, asset_id = 3})

            assert.are.same({{
                id = slot_id,
                transf = pivot,
                type = 'shelter',
                spacing = {1, 2, 3, 4}
            }}, slot_collection.slots)
        end)
    end)

    describe('catenary', function ()
        it ('change type to catenary', function ()
            local slot_collection = SlotCollection:new{}
            local segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = 1})
            local asset_slot = AssetSlot:new{slot_collection = slot_collection, segment_id = segment_id, asset_id = 3}

            local decorated_asset_slot = asset_slot:catenary()
            assert.are.equal(t.ASSET_CATENARY, asset_slot.module_type)
            assert.are.equal('eisfeuer_modutram_catenary', asset_slot.slot_type)
        end)
    end)

    describe('tram_tracks', function ()
        it ('change type to tram_tracks', function ()
            local slot_collection = SlotCollection:new{}
            local segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = 1})
            local asset_slot = AssetSlot:new{slot_collection = slot_collection, segment_id = segment_id, asset_id = 3}

            local decorated_asset_slot = asset_slot:tram_tracks()
            assert.are.equal(t.ASSET_TRAM_TRACKS, asset_slot.module_type)
            assert.are.equal('eisfeuer_modutram_tram_tracks', asset_slot.slot_type)
        end)
    end)

    describe('bus_lane', function ()
        it ('change type to bus_lane', function ()
            local slot_collection = SlotCollection:new{}
            local segment_id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2, grid_y = 1})
            local asset_slot = AssetSlot:new{slot_collection = slot_collection, segment_id = segment_id, asset_id = 3}

            local decorated_asset_slot = asset_slot:bus_lane()
            assert.are.equal(t.ASSET_BUS_LANE, asset_slot.module_type)
            assert.are.equal('eisfeuer_modutram_bus_lane', asset_slot.slot_type)
        end)
    end)

end)