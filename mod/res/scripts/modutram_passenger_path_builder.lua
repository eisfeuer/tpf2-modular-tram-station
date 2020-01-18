local PassengerPathBuilder = {}
local Position = require('modutram_position')
local c = require('modutram_constants')
local t = require('modutram_types')
local TrackCrosswalkPathing = require('modutram_track_crosswalk_pathing')

function PassengerPathBuilder:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local function get_track_crosswalk_path_model(track, path_models)
    if track.type == t.TRACK_DOUBLE_DOORS_RIGHT then
        return path_models.horizontal_double_track
    end
    return path_models.horizontal_single_track
end

local function get_vertical_path_model(platform, path_models)
    if platform and platform.type == t.PLATFORM_DOUBLE then
        return path_models.vertical_double_platform
    end
    return path_models.vertical_single_platform
end

local function get_start_position(column_collection)
    local last_track_position = nil
    local i = 0

    while column_collection:get_column(i) do
        if column_collection:get_column(i):is_track() then
            last_track_position = i
        end
        i = i - 1
    end

    if last_track_position then
        return last_track_position
    end

    if column_collection:get_column(1) and column_collection:get_column(1):is_track() then
        return 1
    end

    return nil
end

local function place_path_models(self, model_collection, handle_placing, handle_placing_last_platform, get_crosswalk_y_position)
    local start_position = get_start_position(self.column_collection)
    if start_position then
        local i = start_position

        local left_platform = self.column_collection:get_column(i - 1)
        local right_platform = self.column_collection:get_column(i + 1)

        if left_platform or right_platform then
            local current_track = self.column_collection:get_column(i)
            local last_crossway_position = nil

            while current_track and current_track:is_track() do
                local crosswalk_pathing = TrackCrosswalkPathing:new{
                    left_platform = left_platform,
                    right_platform = right_platform,
                    track = current_track
                }
                
                handle_placing(model_collection, left_platform, current_track, last_crossway_position, crosswalk_pathing)

                i = i + 2
                current_track = self.column_collection:get_column(i)

                last_crossway_position = get_crosswalk_y_position(crosswalk_pathing)
                left_platform = right_platform
                right_platform = self.column_collection:get_column(i + 1)
            end

            if left_platform and last_crossway_position then
                handle_placing_last_platform(left_platform, last_crossway_position)
            end
        end
    end
end

function PassengerPathBuilder:add_bottom_part_to_model_collection(model_collection)
    place_path_models(
        self,
        model_collection,
        function (model_collection, left_platform, current_track, last_crossway_position, crosswalk_pathing)
            crosswalk_pathing:add_bottom_left_vertical_pathes_to_model_collection(
                model_collection,
                get_vertical_path_model(left_platform, self.passenger_path_models),
                last_crossway_position
            )
            crosswalk_pathing:add_bottom_crosswalk_to_model_collection(
                model_collection,
                get_track_crosswalk_path_model(current_track, self.passenger_path_models)
            )
        end,
        function (last_platform, last_crossway_position)
            for i = last_platform.btm_segment_id - 1, last_crossway_position, -1 do
                model_collection:add({
                    id = get_vertical_path_model(last_platform, self.passenger_path_models),
                    transf = Position:new{x = last_platform.x_pos, y = (i - 1) * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                })
            end
        end,
        function (crosswalk_pathing)
            return crosswalk_pathing:get_bottom_crosswalk_y_position()
        end
    )                
end

function PassengerPathBuilder:add_top_part_to_model_collection(model_collection)
    place_path_models(
        self,
        model_collection,
        function (model_collection, left_platform, current_track, last_crossway_position, crosswalk_pathing)
            crosswalk_pathing:add_top_left_vertical_pathes_to_model_collection(
                model_collection,
                get_vertical_path_model(left_platform, self.passenger_path_models),
                last_crossway_position
            )
            crosswalk_pathing:add_top_crosswalk_to_model_collection(
                model_collection,
                get_track_crosswalk_path_model(current_track, self.passenger_path_models)
            )
        end,
        function (last_platform, last_crossway_position)
            for i = last_platform.top_segment_id + 1, last_crossway_position, 1 do
                model_collection:add({
                    id = get_vertical_path_model(last_platform, self.passenger_path_models),
                    transf = Position:new{x = last_platform.x_pos, y = (i + 1) * c.PLATFORM_SEGMENT_LENGTH}:as_matrix()
                })
            end
        end,
        function (crosswalk_pathing)
            return crosswalk_pathing:get_top_crosswalk_y_position()
        end
    )
end

return PassengerPathBuilder