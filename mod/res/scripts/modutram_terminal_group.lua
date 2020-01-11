local Position = require('modutram_position')
local c = require('modutram_constants')

local TerminalGroup = {}

function TerminalGroup:new (o) 
    setmetatable(o, self)
    self.__index = self
    return o
end

local function get_stop_terminal_position_from_platform(platform)
    return math.ceil(platform:get_ideal_segment_count() / 2) - 1
end

local function get_stop_terminal(self)
    if self.platform:get_ideal_segment_count() % 2 == 0 then
        return self.stop_edge_terminal
    end
    return self.stop_mid_terminal
end

function TerminalGroup:is_track_left_from_the_platform()
    return self.platform.id > self.track.id
end

function TerminalGroup:as_terminal_group_item()
    local model_collection_position = self.models:get_position_of_next_added_item()
    local terminals = {}

    local stop_terminal_position = get_stop_terminal_position_from_platform(self.platform)
    local stop_terminal = get_stop_terminal(self)

    for i = 0, self.platform:get_ideal_segment_count() - 1 do
        if i == stop_terminal_position then
            table.insert(terminals, {model_collection_position + i, stop_terminal.terminal_position})
        else
            table.insert(terminals, {model_collection_position + i, self.waiting_area_only_terminal.terminal_position})
        end
    end
    return {
        tag = self.platform.id,
        terminals = terminals
    }
end

local function get_path_model_tranformation(self, index)
    local position = Position:new{y = index * c.PLATFORM_SEGMENT_LENGTH}
    if self:is_track_left_from_the_platform() then
        return position:add_to_matrix(self.platform.left_path_model_transformation)
    end
    return position:add_to_matrix(self.platform.right_path_model_transformation)
end

function TerminalGroup:add_to_model_collection(model_collection)
    local non_terminal_models = {}

    local stop_terminal_position = self.platform.btm_segment_id + get_stop_terminal_position_from_platform(self.platform)
    local stop_terminal = get_stop_terminal(self)

    for i = self.track.btm_segment_id, self.track.top_segment_id do
        local is_terminal = i >= self.platform.btm_segment_id and i <= self.platform.top_segment_id
        if is_terminal then
            if i == stop_terminal_position then
                model_collection:add({
                    id = stop_terminal.model,
                    transf = get_path_model_tranformation(self, i)
                })
            else
                model_collection:add({
                    id = self.waiting_area_only_terminal.model,
                    transf = get_path_model_tranformation(self, i)
                })
            end
        else
            table.insert(non_terminal_models, {
                id = self.tram_path_model,
                transf = get_path_model_tranformation(self, i)
            })
        end
    end

    for i, model in ipairs(non_terminal_models) do
        model_collection:add(model)
    end
end

return TerminalGroup