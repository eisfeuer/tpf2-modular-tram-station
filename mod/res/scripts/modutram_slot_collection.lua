local SlotCollection = {}
local Module = require('modutram_module')
local c = require('modutram_constants')
local t = require('modutram_types')
local Position = require('modutram_position')
local SlotBuilder = require('modutram_slot_builder')

local FLIPPED_IDENTITY_MATRIX = {
    -1, 0, 0, 0,
    0, -1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
}

local default_slots = {
    SlotBuilder.platform_double(Module.make_id({type = t.PLATFORM_DOUBLE}), Position:new{}:as_matrix()),
    SlotBuilder.platform_single_left(Module.make_id({type = t.PLATFORM_LEFT}), Position:new{}:as_matrix()),
    SlotBuilder.platform_single_right(Module.make_id({type = t.PLATFORM_RIGHT}), Position:new{}:as_matrix()),
    SlotBuilder.track_double_doors_right(Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT}), Position:new{}:as_matrix()),
    SlotBuilder.track_up_doors_right(Module.make_id({type = t.TRACK_UP_DOORS_RIGHT}), Position:new{}:as_matrix()),
    SlotBuilder.track_down_doors_right(Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT}), Position:new{}:as_matrix())
}

function SlotCollection:new (o)
    o = o or {}
    o.slots = o.slots or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SlotCollection:import_platform(platform, position)
    local max, min = platform:slot_range()
    for i = min, max do
        table.insert(self.slots, SlotBuilder.platform_by_type(
            platform.type,
            Module.make_id({type = platform.type, grid_x = platform.id, grid_y = i}),
            Position:new{x = position, y = i * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
        ))
    end
end

function SlotCollection:import_track(track, position)
    if track.type == t.TRACK_DOWN_DOORS_RIGHT then
        table.insert(self.slots, SlotBuilder.street_connection_out(
            Module.make_id({type = t.STREET_CONNECTION_OUT, grid_x = track.id, grid_y = -1}),
            Position:new{x = position, y = (track.btm_segment_id - 0.5) * c.PLATFORM_SEGMENT_LENGTH - 1}:add_to_matrix(FLIPPED_IDENTITY_MATRIX)
        ))
        table.insert(self.slots, SlotBuilder.track_down_doors_right(
            Module.make_id({type = track.type, grid_x = track.id, grid_y = 0}),
            Position:new{x = position, y = 0}:as_matrix()
        ))
        table.insert(self.slots, SlotBuilder.street_connection_in(
            Module.make_id({type = t.STREET_CONNECTION_IN, grid_x = track.id, grid_y = 1}),
            Position:new{x = position, y = (track.top_segment_id + 0.5) * c.PLATFORM_SEGMENT_LENGTH + 1}:add_to_matrix(FLIPPED_IDENTITY_MATRIX)
        ))
    elseif track.type == t.TRACK_UP_DOORS_RIGHT then
        table.insert(self.slots, SlotBuilder.street_connection_in(
            Module.make_id({type = t.STREET_CONNECTION_IN, grid_x = track.id, grid_y = -1}),
            Position:new{x = position, y = (track.btm_segment_id - 0.5) * c.PLATFORM_SEGMENT_LENGTH - 1}:as_matrix()
        ))
        table.insert(self.slots, SlotBuilder.track_up_doors_right(
            Module.make_id({type = track.type, grid_x = track.id, grid_y = 0}),
            Position:new{x = position, y = 0}:as_matrix()
        ))
        table.insert(self.slots, SlotBuilder.street_connection_out(
            Module.make_id({type = t.STREET_CONNECTION_OUT, grid_x = track.id, grid_y = 1}),
            Position:new{x = position, y = (track.top_segment_id + 0.5) * c.PLATFORM_SEGMENT_LENGTH + 1}:as_matrix()
        ))
    elseif track.type == t.TRACK_DOUBLE_DOORS_RIGHT then
        table.insert(self.slots, SlotBuilder.street_connection_double(
            Module.make_id({type = t.STREET_CONNECTION_DOUBLE, grid_x = track.id, grid_y = -1}),
            Position:new{x = position, y = (track.btm_segment_id - 0.5) * c.PLATFORM_SEGMENT_LENGTH - 1}:add_to_matrix(FLIPPED_IDENTITY_MATRIX)
        ))
        table.insert(self.slots, SlotBuilder.track_double_doors_right(
            Module.make_id({type = track.type, grid_x = track.id, grid_y = 0}),
            Position:new{x = position, y = 0}:as_matrix()
        ))
        table.insert(self.slots, SlotBuilder.street_connection_double(
            Module.make_id({type = t.STREET_CONNECTION_DOUBLE, grid_x = track.id, grid_y = 1}),
            Position:new{x = position, y = (track.top_segment_id + 0.5) * c.PLATFORM_SEGMENT_LENGTH + 1}:as_matrix()
        ))
    end
end

local function import_half_from_column_collection(self, column_collection, direction)
    local current_column = column_collection:get_column(0)

    local index = direction
    while column_collection:get_column(index) do
        current_column = column_collection:get_column(index)
        if current_column:is_platform() then
            self:import_platform(current_column, current_column.x_pos)
        elseif current_column:is_track() then
            self:import_track(current_column, current_column.x_pos)
        end
        index = index + direction
    end

    SlotBuilder.add_neighbor_slots_to_collection(self, current_column, direction)
end

function SlotCollection:import_from_column_collection(column_collection)
    local current_column = column_collection:get_column(0)
    if column_collection:get_column(0) then
        if current_column:is_platform() then
            self:import_platform(current_column, current_column.x_pos)
        elseif current_column:is_track() then
            self:import_track(current_column, current_column.x_pos)
        end
        import_half_from_column_collection(self, column_collection, c.LEFT)
        import_half_from_column_collection(self, column_collection, c.RIGHT)
    end
end

function SlotCollection:is_empty()
    return #self.slots == 0
end

function SlotCollection:get_slots()
    if self:is_empty() then
        return default_slots
    end
    return self.slots
end

return SlotCollection