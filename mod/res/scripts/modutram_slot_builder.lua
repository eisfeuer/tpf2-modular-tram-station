local SlotBuilder = {}
local c = require('modutram_constants')

function SlotBuilder.platform_double(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_platform_double",
        spacing = {
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_DOUBLE_WIDTH / 2,
            c.PLATFORM_DOUBLE_WIDTH / 2,
        }
    }
end

function SlotBuilder.platform_single_left(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_platform_single_left",
        spacing = {
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_SINGLE_WIDTH,
            c.PLATFORM_SINGLE_WIDTH,
        }
    }
end

function SlotBuilder.platform_single_right(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_platform_single_right",
        spacing = {
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_SINGLE_WIDTH,
            c.PLATFORM_SINGLE_WIDTH,
        }
    }
end

function SlotBuilder.track_double_doors_right(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_track_double_doors_right",
        spacing = {
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_SEGMENT_LENGTH,
            2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS,
            2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS,
        }
    }
end

function SlotBuilder.track_up_doors_right(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_track_up_doors_right",
        spacing = {
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_SEGMENT_LENGTH,
            2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
            2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
        }
    }
end

function SlotBuilder.track_down_doors_right(id, transf)
    return {
        id = id,
        transf = transf,
        type = "eisfeuer_modutram_track_down_doors_right",
        spacing = {
            c.PLATFORM_SEGMENT_LENGTH,
            c.PLATFORM_SEGMENT_LENGTH,
            2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
            2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM,
        }
    }
end

return SlotBuilder