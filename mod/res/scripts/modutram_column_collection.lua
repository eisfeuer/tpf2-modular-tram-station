local Platform = require('modutram_platform')
local Track = require('modutram_track')
local t = require('modutram_types')
local c = require('modutram_constants')
local AssetModuleCollection = require('modutram_asset_module_collection')

local ColumnCollection = {}

local function is_platform_segment(segment)
    local platform_types = {
        t.PLATFORM_LEFT,
        t.PLATFORM_CARGO_LEFT,
        t.PLATFORM_RIGHT,
        t.PLATFORM_CARGO_RIGHT,
        t.PLATFORM_DOUBLE,
        t.PLATFORM_CARGO_DOUBLE
    }
    for index, platform_type in ipairs(platform_types) do
        if platform_type == segment.type then
            return true
        end
    end
    return false
end

local function is_track(segment)
    local track_types = {
        t.TRACK_UP_DOORS_LEFT,
        t.TRACK_UP_DOORS_RIGHT,
        t.TRACK_UP_CARGO_DOORS_LEFT,
        t.TRACK_UP_CARGO_DOORS_RIGHT,
        t.TRACK_DOWN_DOORS_LEFT,
        t.TRACK_DOWN_DOORS_RIGHT,
        t.TRACK_DOWN_CARGO_DOORS_LEFT,
        t.TRACK_DOWN_CARGO_DOORS_RIGHT,
        t.TRACK_DOUBLE_DOORS_LEFT,
        t.TRACK_DOUBLE_DOORS_RIGHT,
        t.TRACK_DOUBLE_CARGO_DOORS_LEFT,
        t.TRACK_DOUBLE_CARGO_DOORS_RIGHT,
    }
    for index, platform_type in ipairs(track_types) do
        if platform_type == segment.type then
            return true
        end
    end
    return false
end

local function create_column(segment)
    if is_platform_segment(segment) then
        return Platform:new{
            id = segment.grid_x,
            type = segment.type
        }
    elseif is_track(segment) then
        return Track:new{
            id = segment.grid_x,
            type = segment.type
        }
    end
end

local function add_to_column(column, segment)
    if column:is_platform() then
        column:add_segment(segment)
    end
end

local function calc_x_positions(self, direction)
    local position = 0

    local i = direction
    while self:get_column(i) do
        local distance = self:get_column(i):get_distance_to_neighbor(self:get_column(i - direction))
        position = position + distance * direction
        self:get_column(i):set_x_position(position)
        i = i + direction
    end
end

function ColumnCollection:new(o)
    o = o or {}
    o.columns = o.columns or {}
    o.asset_modules = o.asset_modules or AssetModuleCollection:new{}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ColumnCollection:add(segment, module_name)
    if is_platform_segment(segment) or is_track(segment) then
        if not self:get_column(segment.grid_x) then
            self:set_column(segment.grid_x, create_column(segment))
        end
        add_to_column(self:get_column(segment.grid_x), segment)
    else
        self.asset_modules:add_asset_module(segment, module_name)
    end
end

function ColumnCollection:get_column(index)
    return self.columns[index]
end

function ColumnCollection:set_column(index, column)
    self.columns[index] = column
end

function ColumnCollection:is_empty()
    return self:get_column(0) == nil
end

function ColumnCollection:calculate_x_positions()
    if self:get_column(0) then
        self:get_column(0):set_x_position(0)
        calc_x_positions(self, c.RIGHT)
        calc_x_positions(self, c.LEFT)
    end
end

local function calc_track_segment_range_for_track(track, left_neighbor_platform, right_neighbor_platform)
    if track:is_track() then
        local top_left = 0
        local top_right = 0
        local btm_left = 0
        local btm_right = 0
        if left_neighbor_platform and left_neighbor_platform:is_platform() then
            top_left = left_neighbor_platform.top_segment_id
            btm_left = left_neighbor_platform.btm_segment_id
        end
        if right_neighbor_platform and right_neighbor_platform:is_platform() then
            top_right = right_neighbor_platform.top_segment_id
            btm_right = right_neighbor_platform.btm_segment_id
        end
        track.top_segment_id = math.max(top_left, top_right)
        track.btm_segment_id = math.min(btm_left, btm_right)
    end
end

function ColumnCollection:calculate_track_segment_range()
    if self:get_column(0) then
        local i = -2
        local current_column = self:get_column(0)
        local left_neighbor = self:get_column(-1)
        local right_neighbor = self:get_column(1)
        repeat
            calc_track_segment_range_for_track(current_column, left_neighbor, right_neighbor)
            right_neighbor = current_column
            current_column = left_neighbor
            left_neighbor = self:get_column(i)
            i = i - 1
        until current_column == nil

        i = 3
        current_column = self:get_column(1)
        left_neighbor = self:get_column(0)
        right_neighbor = self:get_column(2)

        while current_column do
            calc_track_segment_range_for_track(current_column, left_neighbor, right_neighbor)
            left_neighbor = current_column
            current_column = right_neighbor
            right_neighbor = self:get_column(i)
            i = i + 1
        end
    end
end

function ColumnCollection:get_left_outer_column_grid_x()
    local i = 0
    local last_i = 0
    while self:get_column(i) do
        last_i = i
        i = i - 1        
    end
    return last_i
end

return ColumnCollection