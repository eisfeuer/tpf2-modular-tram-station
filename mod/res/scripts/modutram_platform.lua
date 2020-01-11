local Segment = require('modutram_segment')
local t = require('modutram_types')
local c = require('modutram_constants')

local Platform = {}

local function get_path_model_x_position(direction, platform_x_position, platform_width)
    return platform_x_position + (platform_width / 2 + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM) * direction
end

local function create_path_model_transformation(direction, platform_x_position, platform_width)
    return {
        -direction, 0, 0, 0,
        0, -direction, 0, 0,
        0, 0, 1, 0,
        get_path_model_x_position(direction, platform_x_position, platform_width), 0, 0, 1
    }
end

function Platform:new (o)
    o = o or {}
    o.segments = o.segments or {}

    if not o.x_pos then
        o.x_pos = 0
    end

    if o.type == t.PLATFORM_LEFT then
        o.left_path_model_transformation = create_path_model_transformation(c.LEFT, o.x_pos, c.PLATFORM_SINGLE_WIDTH)
    elseif o.type == t.PLATFORM_RIGHT then
        o.right_path_model_transformation = create_path_model_transformation(c.RIGHT, o.x_pos, c.PLATFORM_SINGLE_WIDTH)
    elseif o.type == t.PLATFORM_DOUBLE then
        o.left_path_model_transformation = create_path_model_transformation(c.LEFT, o.x_pos, c.PLATFORM_DOUBLE_WIDTH)
        o.right_path_model_transformation = create_path_model_transformation(c.RIGHT, o.x_pos, c.PLATFORM_DOUBLE_WIDTH)
    end

    setmetatable(o, self)
    self.__index = self
    return o
end

function Platform:add_segment(segment_module)
    local segment = Segment:new{id = segment_module.grid_y}
    if not self.top_segment_id or self.top_segment_id < segment.id then
        self.top_segment_id = segment.id
    end
    if not self.btm_segment_id or self.btm_segment_id > segment.id then
        self.btm_segment_id = segment.id
    end
    table.insert(self.segments, segment)
end

function Platform:center_segment_id()
    if #self.segments == 0 then
        return nil
    end
    return math.floor((self.top_segment_id + self.btm_segment_id) / 2)
end

function Platform:slot_range()
    if #self.segments == 0 then
        return 0, 0
    end
    local min = self:center_segment_id()
    local max = min
    while self:find_segment(min) do
        min = min - 1
    end
    while self:find_segment(max) do
        max = max + 1
    end
    return max, min
end

function Platform:find_segment(segment_id)
    for i, segment in ipairs(self.segments) do
        if segment.id == segment_id then
            return segment, i
        end
    end
    return nil
end

function Platform:is_platform()
    return true
end

function Platform:is_track()
    return false
end

function Platform:is_double_platform()
    return self.type == t.PLATFORM_DOUBLE
end

function Platform:get_width()
    if self:is_double_platform() then
        return c.PLATFORM_DOUBLE_WIDTH
    end
    return c.PLATFORM_SINGLE_WIDTH
end

function Platform:get_distance_to_neighbor(track)
    if not track:is_track() then
        error('platform neighbor must be a track')
    end
    return self:get_width() / 2 + track:get_distance_from_center_to_platform_edge()
end

function Platform:set_height(height)
    if self.type ~= t.PLATFORM_LEFT then
        self.right_path_model_transformation[11] = height
    end
    if self.type ~= t.PLATFORM_RIGHT then
        self.left_path_model_transformation[11] = height
    end
end

function Platform:get_ideal_segment_count()
    return self.top_segment_id - self.btm_segment_id + 1
end

function Platform:set_x_position(x_pos)
    self.x_pos = x_pos
    if self.type == t.PLATFORM_LEFT then
        self.left_path_model_transformation[13] = get_path_model_x_position(c.LEFT, x_pos, c.PLATFORM_SINGLE_WIDTH)
    elseif self.type == t.PLATFORM_RIGHT then
        self.right_path_model_transformation[13] = get_path_model_x_position(c.RIGHT, x_pos, c.PLATFORM_SINGLE_WIDTH)
    elseif self.type == t.PLATFORM_DOUBLE then
        self.left_path_model_transformation[13] = get_path_model_x_position(c.LEFT, x_pos, c.PLATFORM_DOUBLE_WIDTH)
        self.right_path_model_transformation[13] = get_path_model_x_position(c.RIGHT, x_pos, c.PLATFORM_DOUBLE_WIDTH)
    end
end

return Platform