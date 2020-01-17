local TrackCrosswalkPathing = {}
local Position = require('modutram_position')
local c = require('modutram_constants')

local function has_vertical_path_models(platform_position, crosswalk_position, last_crosswalk_position, direction)
    if platform_position * direction < crosswalk_position * direction then
        return true
    end

    return last_crosswalk_position ~= nil and platform_position * direction < last_crosswalk_position * direction
end

local function get_vertical_path_placing_range(platform_position, crosswalk_position, last_crosswalk_position, direction)
    if last_crosswalk_position == nil then
        return platform_position, crosswalk_position
    end

    if last_crosswalk_position * direction > crosswalk_position * direction then
        return platform_position, last_crosswalk_position
    end

    return platform_position, crosswalk_position
end

function TrackCrosswalkPathing:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TrackCrosswalkPathing:get_bottom_crosswalk_y_position()
    if self.left_platform == nil and self.right_platform == nil then
        return nil
    end

    if self.left_platform == nil then
        return self.right_platform.btm_segment_id
    end

    if self.right_platform == nil then
        return self.left_platform.btm_segment_id
    end

    return math.min(self.left_platform.btm_segment_id, self.right_platform.btm_segment_id)
end

function TrackCrosswalkPathing:add_bottom_crosswalk_to_model_collection(model_collection, model)
    local crosswalk_position = self:get_bottom_crosswalk_y_position()
    if crosswalk_position ~= nil then
        model_collection:add({
            id = model,
            transf = Position:new{x = self.track.x_pos, y = (crosswalk_position - 1.5) * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
        })
    end
end

function TrackCrosswalkPathing:add_bottom_left_vertical_pathes_to_model_collection(model_collection, model, last_crosswalk_position)
    if self.left_platform then
        local crosswalk_position = self:get_bottom_crosswalk_y_position()
        if has_vertical_path_models(self.left_platform.btm_segment_id, crosswalk_position, last_crosswalk_position, -1) then
            local from, to = get_vertical_path_placing_range(self.left_platform.btm_segment_id, crosswalk_position, last_crosswalk_position, -1)
            for i = from - 1, to, -1 do
                model_collection:add({
                    id = model,
                    transf = Position:new{x = self.left_platform.x_pos, y = (i - 1) * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                })
            end
        end
    end
end

return TrackCrosswalkPathing