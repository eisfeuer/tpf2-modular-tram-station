local t = require('modutram_types')
local c = require('modutram_constants')

local TerrainAlignment = {}
local function create_vertex(x_pos, y_pos)
    return {x_pos, y_pos, 0.0}
end

function TerrainAlignment:new(o)
    o = o or {}

    if not o.column then
        error('TerrainAlignment object needs a column')
    end

    local width = c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM
    if o.column.type == t.PLATFORM_DOUBLE then
        width = c.PLATFORM_DOUBLE_WIDTH / 2
    elseif o.column.type == t.PLATFORM_LEFT or o.column.type == t.PLATFORM_RIGHT then
        width = c.PLATFORM_SINGLE_WIDTH / 2
    elseif o.column.type == t.TRACK_DOUBLE_DOORS_RIGHT then
        width = c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS / 2
    end

    o.left_edge = o.column.x_pos - width
    o.right_edge = o.column.x_pos + width
    o.top_edge = (o.column.top_segment_id + 1.5) * c.PLATFORM_SEGMENT_LENGTH
    o.btm_edge = (o.column.btm_segment_id - 1.5) * c.PLATFORM_SEGMENT_LENGTH

    setmetatable(o, self)
    self.__index = self
    return o
end

function TerrainAlignment:get_vertex_top_left()
    return create_vertex(self.left_edge, self.top_edge)
end

function TerrainAlignment:get_vertex_top_right()
    return create_vertex(self.right_edge, self.top_edge)
end

function TerrainAlignment:get_vertex_btm_left()
    return create_vertex(self.left_edge, self.btm_edge)
end

function TerrainAlignment:get_vertex_btm_right()
    return create_vertex(self.right_edge, self.btm_edge)
end

local function floats_are_very_close(float_1, float_2)
    return float_1 - 0.00001 < float_2 and float_1 + 0.00001 > float_2
end

local function add_vertices_forward(current_terrain_alignment, last_terrain_alignment, polygon)
    if not last_terrain_alignment or not floats_are_very_close(last_terrain_alignment.top_edge, current_terrain_alignment.top_edge) then
        table.insert(polygon, current_terrain_alignment:get_vertex_top_left())
    end

    table.insert(polygon, current_terrain_alignment:get_vertex_top_right())
end

local function add_vertices_backward(current_terrain_alignment, last_terrain_alignment, polygon)
    table.insert(polygon, last_terrain_alignment:get_vertex_btm_right())
     
    if not current_terrain_alignment or not floats_are_very_close(last_terrain_alignment.btm_edge, current_terrain_alignment.btm_edge) then
        table.insert(polygon, last_terrain_alignment:get_vertex_btm_left())
    end
end

function TerrainAlignment.create_terrain_polygon_for(column_collection)
     local terrain_aligments_stack = {}
     local polygon = {}

     local i = column_collection:get_left_outer_column_grid_x()

     while column_collection:get_column(i) do
         local terrain_alignment = TerrainAlignment:new{column = column_collection:get_column(i)}
         add_vertices_forward(terrain_alignment, terrain_aligments_stack[#terrain_aligments_stack], polygon)
         table.insert(terrain_aligments_stack, terrain_alignment)
         i = i + 1
     end

     while #terrain_aligments_stack > 0 do
        local terrain_alignment = table.remove(terrain_aligments_stack)
        add_vertices_backward(terrain_aligments_stack[#terrain_aligments_stack], terrain_alignment, polygon)   
     end

     return polygon
end

function TerrainAlignment.create_terrain_alignment_list_from_polygon(polygon)
    return {
        type = 'EQUAL',
        faces = { polygon }
    }
end

function TerrainAlignment.create_ground_faces_from_polygon(polygon, fill, stroke)
    return {
        face =  polygon,
        modes = {
            {
                type = "FILL",
                key = fill
            },
            {
                type = "STROKE_OUTER",
                key = stroke
            },
        }
    }
end

return TerrainAlignment