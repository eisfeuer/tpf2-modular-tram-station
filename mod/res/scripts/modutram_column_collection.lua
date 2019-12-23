local Platform = require('modutram_platform')
local t = require('modutram_types')

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

local function create_column(segment)
    if is_platform_segment(segment) then
        return Platform:new{
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

function ColumnCollection:new(o)
    o = o or {}
    o.columns = o.columns or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ColumnCollection:add(segment)
    if not self:get_column(segment.grid_x) then
        self:set_column(segment.grid_x, create_column(segment))
    end
    add_to_column(self:get_column(segment.grid_x), segment)
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

return ColumnCollection