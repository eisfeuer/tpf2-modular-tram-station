local StationBlueprint = {}
local Module = require('modutram_module')
local t = require('modutram_types')
local PlatformBlueprint = require('modutram_platform_blueprint')
local c = require('modutram_constants')

function StationBlueprint:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local function add_single_track_outer_open_doors_to_template(self, track_grid_x, direction, template)
    if direction == c.RIGHT then
        template[Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = track_grid_x, grid_y = 0})] = self.modules.track_up_doors_right
    else
        template[Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = track_grid_x, grid_y = 0})] = self.modules.track_down_doors_right
    end
end

local function add_single_track_inner_open_doors_to_template(self, track_grid_x, direction, template)
    if direction == c.LEFT then
        template[Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = track_grid_x, grid_y = 0})] = self.modules.track_up_doors_right
    else
        template[Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = track_grid_x, grid_y = 0})] = self.modules.track_down_doors_right
    end
end

local function add_single_platform_to_template_inner(self, platform_grid_x, direction, template)
    local platform_type = direction == c.LEFT and t.PLATFORM_RIGHT or t.PLATFORM_LEFT
    local platform_module = direction == c.LEFT and self.modules.platform_right or self.modules.platform_left
    
    local platform_blueprint = PlatformBlueprint:new{
        platform_type = platform_type,
        platform_grid_x = platform_grid_x,
        platform_segments = self.segments_per_platform,
        platform_segment_module = platform_module
    }
    platform_blueprint:add_to_template(template)
end

local function add_single_platform_to_template_outer(self, platform_grid_x, direction, template)
    local platform_type = direction == c.RIGHT and t.PLATFORM_RIGHT or t.PLATFORM_LEFT
    local platform_module = direction == c.RIGHT and self.modules.platform_right or self.modules.platform_left
    
    local platform_blueprint = PlatformBlueprint:new{
        platform_type = platform_type,
        platform_grid_x = platform_grid_x,
        platform_segments = self.segments_per_platform,
        platform_segment_module = platform_module
    }
    platform_blueprint:add_to_template(template)
end

local function add_double_track_to_template(self, track_grid_x, template)
    template[Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = track_grid_x, grid_y = 0})] = self.modules.track_double_doors_right
end

local function add_double_platform_to_template(self, platform_grid_x, template)
    local platform_blueprint = PlatformBlueprint:new{
        platform_type = t.PLATFORM_DOUBLE,
        platform_grid_x = platform_grid_x,
        platform_segments = self.segments_per_platform,
        platform_segment_module = self.modules.platform_double
    }
    platform_blueprint:add_to_template(template)
end

local function create_template_from_pattern_0(self, platforms, direction, current_platform_grid_x, template)
    local current_track_grid_x = current_platform_grid_x - 1

    if platforms < 1 then
        add_single_track_inner_open_doors_to_template(self, current_track_grid_x * direction, direction, template)
        return
    end

    if platforms < 2 then
        if current_track_grid_x > 0 then
            add_double_track_to_template(self, current_track_grid_x * direction, template)
        end
        add_single_platform_to_template_inner(self, current_platform_grid_x * direction, direction, template)
        return
    end

    if current_track_grid_x > 0 then
        add_double_track_to_template(self, current_track_grid_x * direction, template)
    end
    add_double_platform_to_template(self, current_platform_grid_x * direction, template)

    create_template_from_pattern_0(self, platforms - 2, direction, current_platform_grid_x + 2, template)
end

local function create_template_from_pattern_1(self, platforms, direction, current_platform_grid_x, template)
    if platforms <= 0 then
        return
    end

    local current_track_grid_x = current_platform_grid_x - 1

    if current_track_grid_x > 0 then
        add_single_track_outer_open_doors_to_template(self, current_track_grid_x * direction, direction, template)
    end

    add_single_platform_to_template_inner(self, current_platform_grid_x * direction, direction, template)

    create_template_from_pattern_1(self, platforms - 1, direction, current_platform_grid_x + 2, template)
end

local function create_template_from_pattern_2(self, platforms, direction, current_platform_grid_x, template)
    if platforms <= 0 then
        return
    end

    local current_track_grid_x = current_platform_grid_x + 1

    add_single_track_inner_open_doors_to_template(self, current_track_grid_x * direction, direction, template)
    add_single_platform_to_template_outer(self, current_platform_grid_x * direction, direction, template)

    create_template_from_pattern_2(self, platforms - 1, direction, current_platform_grid_x + 2, template)
end

function StationBlueprint:create_template()
    local template = {}

    -- ] || || [] || || [] || || [
    if self.platform_placing_pattern == 0 then
        add_double_track_to_template(self, 0, template)
        if self.platforms_left > 0 then
            create_template_from_pattern_0(self, self.platforms_left, c.LEFT, 1, template)
        end
        if self.platforms_right > 0 then
            create_template_from_pattern_0(self, self.platforms_right, c.RIGHT, 1, template)
        end
    -- ] || ] || ] |||| [ || [ || [
    elseif self.platform_placing_pattern == 1 then
        add_double_track_to_template(self, 0, template)
        if self.platforms_left > 0 then
            create_template_from_pattern_1(self, self.platforms_left, c.LEFT, 1, template)
        end
        if self.platforms_right > 0 then
            create_template_from_pattern_1(self, self.platforms_right, c.RIGHT, 1, template)
        end
    -- || [ || [ || [] || ] || ] ||
    elseif self.platform_placing_pattern == 2 then
        add_single_track_inner_open_doors_to_template(self, -1, c.LEFT, template)
        add_double_platform_to_template(self, 0, template)
        add_single_track_inner_open_doors_to_template(self, 1, c.RIGHT, template)
        create_template_from_pattern_2(self, self.platforms_left - 1, c.LEFT, 2, template)
        create_template_from_pattern_2(self, self.platforms_right - 1, c.RIGHT, 2, template)
    -- || [ || [ || [ || [
    elseif self.platform_placing_pattern == 3 then
        local from, to = -self.platforms_left, math.max(self.platforms_right - 1, 0)

        for i = from, to do
            template[Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = i * 2, grid_y = 0})] = self.modules.track_up_doors_right
            local platform_blueprint = PlatformBlueprint:new{
                platform_type = t.PLATFORM_LEFT,
                platform_grid_x = i * 2 + 1,
                platform_segments = self.segments_per_platform,
                platform_segment_module = self.modules.platform_left
            }
            platform_blueprint:add_to_template(template)
        end
    -- ] || ] || ] || ] ||
    elseif self.platform_placing_pattern == 4 then
        local from, to = math.min(-self.platforms_left + 1, 0), self.platforms_right

        for i = from, to do
            template[Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = i * 2, grid_y = 0})] = self.modules.track_down_doors_right
            local platform_blueprint = PlatformBlueprint:new{
                platform_type = t.PLATFORM_RIGHT,
                platform_grid_x = i * 2 - 1,
                platform_segments = self.segments_per_platform,
                platform_segment_module = self.modules.platform_right
            }
            platform_blueprint:add_to_template(template)
        end
    end

    return template
end

return StationBlueprint