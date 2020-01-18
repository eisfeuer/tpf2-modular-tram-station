local SlotBuilder = {}
local c = require('modutram_constants')
local t = require('modutram_types')
local Module = require('modutram_module')
local Position = require('modutram_position')
local Platform = require('modutram_platform')
local Track = require('modutram_track')

function SlotBuilder.platform_by_type(type, id, transf)
    if type == t.PLATFORM_DOUBLE then
        return SlotBuilder.platform_double(id, transf)
    elseif type == t.PLATFORM_LEFT then
        return SlotBuilder.platform_single_left(id, transf)
    elseif type == t.PLATFORM_RIGHT then
        return SlotBuilder.platform_single_right(id, transf)
    end
    return nil
end

function SlotBuilder.platform_double(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_platform_double",
        spacing = {
            c.PLATFORM_DOUBLE_WIDTH / 2,
            c.PLATFORM_DOUBLE_WIDTH / 2,
            c.PLATFORM_SEGMENT_LENGTH / 2,
            c.PLATFORM_SEGMENT_LENGTH / 2,
        }
    }
end

function SlotBuilder.platform_single_left(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_platform_single_left",
        spacing = {
            c.PLATFORM_SINGLE_WIDTH / 2,
            c.PLATFORM_SINGLE_WIDTH / 2,
            c.PLATFORM_SEGMENT_LENGTH / 2,
            c.PLATFORM_SEGMENT_LENGTH / 2,
        }
    }
end

function SlotBuilder.platform_single_right(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_platform_single_right",
        spacing = {
            c.PLATFORM_SINGLE_WIDTH / 2,
            c.PLATFORM_SINGLE_WIDTH / 2,
            c.PLATFORM_SEGMENT_LENGTH / 2,
            c.PLATFORM_SEGMENT_LENGTH / 2,
        }
    }
end

function SlotBuilder.track_double_doors_right(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_track_double_doors_right",
        spacing = {
            (2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS) / 2 - 0.1,
            (2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS) / 2 - 0.1,
            c.PLATFORM_SEGMENT_LENGTH / 2 - 0.1,
            c.PLATFORM_SEGMENT_LENGTH / 2 - 0.1,
        }
    }
end

function SlotBuilder.track_up_doors_right(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_track_up_doors_right",
        spacing = {
            c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
            c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
            c.PLATFORM_SEGMENT_LENGTH / 2 - 0.1,
            c.PLATFORM_SEGMENT_LENGTH / 2 - 0.1,
        }
    }
end

function SlotBuilder.track_down_doors_right(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_track_down_doors_right",
        spacing = {
            c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
            c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
            c.PLATFORM_SEGMENT_LENGTH / 2 - 0.1,
            c.PLATFORM_SEGMENT_LENGTH / 2 - 0.1,
        }
    }
end

function SlotBuilder.street_connection_in(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_street_connection_in",
        spacing = {
            c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
            c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
            c.PLATFORM_SEGMENT_LENGTH - 1,
            1,
        }
    }
end

function SlotBuilder.street_connection_out(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_street_connection_out",
        spacing = {
            c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
            c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
            1,
            c.PLATFORM_SEGMENT_LENGTH - 1,
        }
    }
end

function SlotBuilder.street_connection_double(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_street_connection_double",
        spacing = {
            (2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS) / 2 - 0.1,
            (2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS) / 2 - 0.1,
            1,
            c.PLATFORM_SEGMENT_LENGTH - 1,
        }
    }
end

local function get_horizontal_platform_entrance_spcings(platform_type)
    if platform_type == t.PLATFORM_DOUBLE then
        return c.PLATFORM_DOUBLE_WIDTH / 2 - 0.1
    end
    return c.PLATFORM_SINGLE_WIDTH / 2 - 0.1
end

local function get_top_platform_entrance_spacing(entrance_place)
    if entrance_place == 'btm' then
        return c.PLATFORM_SEGMENT_LENGTH - 1
    end
    return 1
end

local function get_bottom_platform_entrance_spacing(entrance_place)
    if entrance_place == 'btm' then
        return 1
    end
    return c.PLATFORM_SEGMENT_LENGTH - 1
end

function SlotBuilder.platform_entrance_general(platform_type, entrance_place, id, transf)
    return {
        id = id,
        transf = transf,
        type = 'eisfeuer_modutram_platform_entrance',
        spacing = {
            get_horizontal_platform_entrance_spcings(platform_type),
            get_horizontal_platform_entrance_spcings(platform_type),
            get_top_platform_entrance_spacing(entrance_place),
            get_bottom_platform_entrance_spacing(entrance_place)
        }
    }

end

local function get_neighbor_slot_id(type, column, direction)
    return Module.make_id({type = type, grid_x = column.id + direction, grid_y = 0})
end

local function get_neighbor_slot_transf(type, column, direction)
    local neighbor_dummy = Platform:new{type = type}
    if column:is_platform() then
        neighbor_dummy = Track:new{type = type}
    end
    local x_pos = column.x_pos + column:get_distance_to_neighbor(neighbor_dummy) * direction
    return Position:new{x = x_pos}:as_matrix()
end

function SlotBuilder.add_neighbor_slots_to_collection(slot_collection, column, direction)
    if column:is_track() then
        if direction == c.LEFT then
            if column.type == t.TRACK_UP_DOORS_RIGHT then
                table.insert(
                    slot_collection.slots,
                    SlotBuilder.platform_single_left(
                        get_neighbor_slot_id(t.PLATFORM_LEFT, column, direction),
                        get_neighbor_slot_transf(t.PLATFORM_LEFT, column, direction)
                    )
                )
            else
                table.insert(
                    slot_collection.slots,
                    SlotBuilder.platform_double(
                        get_neighbor_slot_id(t.PLATFORM_DOUBLE, column, direction),
                        get_neighbor_slot_transf(t.PLATFORM_DOUBLE, column, direction)
                    )
                )
                table.insert(
                    slot_collection.slots,
                    SlotBuilder.platform_single_right(
                        get_neighbor_slot_id(t.PLATFORM_RIGHT, column, direction),
                        get_neighbor_slot_transf(t.PLATFORM_RIGHT, column, direction)
                    )
                )
            end
        else
            if column.type == t.TRACK_DOWN_DOORS_RIGHT then
                table.insert(
                    slot_collection.slots,
                    SlotBuilder.platform_single_right(
                        get_neighbor_slot_id(t.PLATFORM_RIGHT, column, direction),
                        get_neighbor_slot_transf(t.PLATFORM_RIGHT, column, direction)
                    )
                )
            else
                table.insert(
                    slot_collection.slots,
                    SlotBuilder.platform_double(
                        get_neighbor_slot_id(t.PLATFORM_DOUBLE, column, direction),
                        get_neighbor_slot_transf(t.PLATFORM_DOUBLE, column, direction)
                    )
                )
                table.insert(
                    slot_collection.slots,
                    SlotBuilder.platform_single_left(
                        get_neighbor_slot_id(t.PLATFORM_LEFT, column, direction),
                        get_neighbor_slot_transf(t.PLATFORM_LEFT, column, direction)
                    )
                )
            end
        end
    else
        if direction == c.LEFT then
            if column.type == t.PLATFORM_RIGHT then
                table.insert(
                    slot_collection.slots,
                    SlotBuilder.track_down_doors_right(
                        get_neighbor_slot_id(t.TRACK_DOWN_DOORS_RIGHT, column, direction),
                        get_neighbor_slot_transf(t.TRACK_DOWN_DOORS_RIGHT, column, direction)
                    )
                )
            else
                table.insert(
                    slot_collection.slots,
                    SlotBuilder.track_double_doors_right(
                        get_neighbor_slot_id(t.TRACK_DOUBLE_DOORS_RIGHT, column, direction),
                        get_neighbor_slot_transf(t.TRACK_DOUBLE_DOORS_RIGHT, column, direction)
                    )
                )
                table.insert(
                    slot_collection.slots,
                    SlotBuilder.track_up_doors_right(
                        get_neighbor_slot_id(t.TRACK_UP_DOORS_RIGHT, column, direction),
                        get_neighbor_slot_transf(t.TRACK_UP_DOORS_RIGHT, column, direction)
                    )
                )
            end
        else
            if column.type == t.PLATFORM_LEFT then
                table.insert(
                    slot_collection.slots,
                    SlotBuilder.track_up_doors_right(
                        get_neighbor_slot_id(t.TRACK_UP_DOORS_RIGHT, column, direction),
                        get_neighbor_slot_transf(t.TRACK_UP_DOORS_RIGHT, column, direction)
                    )
                )
            else
                table.insert(
                    slot_collection.slots,
                    SlotBuilder.track_double_doors_right(
                        get_neighbor_slot_id(t.TRACK_DOUBLE_DOORS_RIGHT, column, direction),
                        get_neighbor_slot_transf(t.TRACK_DOUBLE_DOORS_RIGHT, column, direction)
                    )
                )
                table.insert(
                    slot_collection.slots,
                    SlotBuilder.track_down_doors_right(
                        get_neighbor_slot_id(t.TRACK_DOWN_DOORS_RIGHT, column, direction),
                        get_neighbor_slot_transf(t.TRACK_DOWN_DOORS_RIGHT, column, direction)
                    )
                )
            end
        end
    end
end

return SlotBuilder