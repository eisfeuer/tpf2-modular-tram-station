local t = require('modutram_types')
local c = require('modutram_constants')
local Position = require('modutram_position')
local Matrix = require('modutram_matrix')
local Module = require('modutram_module')

local AssetSlot = {}

function AssetSlot:new(o)
    o = o or {}

    if not o.slot_collection then
        error('Asset slot is not binded to a slot collection')
    end

    if not o.segment_id then
        error('Asset slot is not binded to a track or platform segment')
    end

    if not o.asset_id then
        error('Asset MUST have an asset_id')
    end

    if not o.transformation then
        o.transformation = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1
        }
    end

    if not o.module_type then
        o.module_type = t.ASSET_DECORATION
    end

    if not o.slot_type then
        o.slot_type = c.DEFAULT_ASSET_SLOT_TYPE
    end

    if not o.spacing then
        o.spacing = c.DEFAULT_ASSET_SLOT_SPACING
    end

    if o.allow_global_slot == nil then
        o.allow_global_slot = true
    end

    setmetatable(o, self)
    self.__index = self
    return o
end

function AssetSlot:of_type(module_type, slot_type)
    self.module_type = module_type
    self.slot_type = slot_type
    return self
end

function AssetSlot:with_spacing(spacing)
    self.spacing = spacing
    return self
end

function AssetSlot:move(x, y, z)
    self.transformation = Position:new{x = x, y = y, z = z}:add_to_matrix(self.transformation)
    return self
end

function AssetSlot:rotate(angle_in_degree)
    self.transformation = Matrix.rotate_around_z_axis(angle_in_degree, self.transformation)
    return self
end

function AssetSlot:as_slot()
    local segment_module = Module:new{id = self.segment_id}
    local asset_slot_id = Module.make_id({type = self.module_type, grid_x = segment_module.grid_x, grid_y = segment_module.grid_y, asset_id = self.asset_id})

    return {
        id = asset_slot_id,
        type = self.slot_type,
        transf = self.transformation,
        spacing = self.spacing
    }
end

function AssetSlot:add_to_slots()
    table.insert(self.slot_collection.slots, self:as_slot())
end

function AssetSlot:catenary()
    return self:of_type(t.ASSET_CATENARY, 'eisfeuer_modutram_catenary'):with_spacing({1, 1, 1, 1})
end

function AssetSlot:tram_tracks()
    return self:of_type(t.ASSET_TRAM_TRACKS, 'eisfeuer_modutram_tram_tracks'):with_spacing({1, 1, 1, 1})
end

function AssetSlot:bus_lane()
    return self:of_type(t.ASSET_BUS_LANE, 'eisfeuer_modutram_bus_lane'):with_spacing({1, 1, 1, 1})
end

return AssetSlot