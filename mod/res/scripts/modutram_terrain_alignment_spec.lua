local ColumnCollection = require('modutram_column_collection')
local Module = require('modutram_module')
local c = require('modutram_constants')
local t = require('modutram_types')
local TerrainAlignment = require('modutram_terrain_alignment')

describe('TerrainAlignment', function ()
    
    local column_collection = ColumnCollection:new{}

    column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = -3, grid_y = 0})})

    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -2, grid_y = 0})})
    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = -2, grid_y = 1})})

    column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = -1, grid_y = 0})})

    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 0, grid_y = 0})})

    column_collection:add(Module:new{id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 1, grid_y = 0})})

    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 2, grid_y = 0})})
    column_collection:add(Module:new{id = Module.make_id({type = t.PLATFORM_LEFT, grid_x = 2, grid_y = -1})})

    column_collection:calculate_track_segment_range()
    column_collection:calculate_x_positions()

    describe('new', function ()
        
        it ('creates terrain aligment for single platform', function ()
            local platform = column_collection:get_column(2)
            local terrain_alignment = TerrainAlignment:new{column = platform}

            assert.are.equal(platform.x_pos - c.PLATFORM_SINGLE_WIDTH / 2, terrain_alignment.left_edge)
            assert.are.equal(platform.x_pos + c.PLATFORM_SINGLE_WIDTH / 2, terrain_alignment.right_edge)
            assert.are.equal(c.PLATFORM_SEGMENT_LENGTH * 1.5, terrain_alignment.top_edge)
            assert.are.equal(c.PLATFORM_SEGMENT_LENGTH * -2.5, terrain_alignment.btm_edge)
        end)

        it ('creates terrain alignment for double plaform', function ()
            local platform = column_collection:get_column(0)
            local terrain_alignment = TerrainAlignment:new{column = platform}

            assert.are.equal(platform.x_pos - c.PLATFORM_DOUBLE_WIDTH / 2, terrain_alignment.left_edge)
            assert.are.equal(platform.x_pos + c.PLATFORM_DOUBLE_WIDTH / 2, terrain_alignment.right_edge)
            assert.are.equal(c.PLATFORM_SEGMENT_LENGTH * 1.5, terrain_alignment.top_edge)
            assert.are.equal(c.PLATFORM_SEGMENT_LENGTH * -1.5, terrain_alignment.btm_edge)
        end)

        it ('creates terrain alignment for single track', function ()
            local track = column_collection:get_column(-1)
            local terrain_alignment = TerrainAlignment:new{column = track}

            assert.are.equal(track.x_pos - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, terrain_alignment.left_edge)
            assert.are.equal(track.x_pos + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, terrain_alignment.right_edge)
            assert.are.equal(c.PLATFORM_SEGMENT_LENGTH * 2.5, terrain_alignment.top_edge)
            assert.are.equal(c.PLATFORM_SEGMENT_LENGTH * -1.5, terrain_alignment.btm_edge)
        end)

        it ('create terrain alignment for double track', function ()
            local track = column_collection:get_column(1)
            local terrain_alignment = TerrainAlignment:new{column = track}

            assert.are.equal(track.x_pos - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - c.DISTANCE_BETWEEN_TWO_TRACKS / 2, terrain_alignment.left_edge)
            assert.are.equal(track.x_pos + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS / 2, terrain_alignment.right_edge)
            assert.are.equal(c.PLATFORM_SEGMENT_LENGTH * 1.5, terrain_alignment.top_edge)
            assert.are.equal(c.PLATFORM_SEGMENT_LENGTH * -2.5, terrain_alignment.btm_edge)
        end)

    end)

    describe ('get_vertex', function ()
        it ('returns top left vertex', function ()
            local track = column_collection:get_column(-1)
            local terrain_alignment = TerrainAlignment:new{column = track}

            assert.are.same(
                {track.x_pos - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, c.PLATFORM_SEGMENT_LENGTH * 2.5, 0.0},
                terrain_alignment:get_vertex_top_left()
            )
        end)

        it ('returns top right vertex', function ()
            local track = column_collection:get_column(-1)
            local terrain_alignment = TerrainAlignment:new{column = track}

            assert.are.same(
                {track.x_pos + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, c.PLATFORM_SEGMENT_LENGTH * 2.5, 0.0},
                terrain_alignment:get_vertex_top_right()
            )
        end)

        it ('returns bottom left vertex', function ()
            local track = column_collection:get_column(-1)
            local terrain_alignment = TerrainAlignment:new{column = track}

            assert.are.same(
                {track.x_pos - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, c.PLATFORM_SEGMENT_LENGTH * -1.5, 0.0},
                terrain_alignment:get_vertex_btm_left()
            )
        end)

        it ('returns bottom right vertex', function ()
            local track = column_collection:get_column(-1)
            local terrain_alignment = TerrainAlignment:new{column = track}

            assert.are.same(
                {track.x_pos + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, c.PLATFORM_SEGMENT_LENGTH * -1.5, 0.0},
                terrain_alignment:get_vertex_btm_right()
            )
        end)
    end)

    describe ('create_terrain_polygon_for', function ()
        
        it ('creates terraign polygon for given column collection', function ()
            local polygon = TerrainAlignment.create_terrain_polygon_for(column_collection)

            assert.are.same({
                {column_collection:get_column(-3).x_pos - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, c.PLATFORM_SEGMENT_LENGTH * 2.5, 0.0},
                {column_collection:get_column(-2).x_pos - c.PLATFORM_SINGLE_WIDTH / 2, c.PLATFORM_SEGMENT_LENGTH * 2.5, 0.0},
                {column_collection:get_column(-2).x_pos + c.PLATFORM_SINGLE_WIDTH / 2, c.PLATFORM_SEGMENT_LENGTH * 2.5, 0.0},
                {column_collection:get_column(0).x_pos - c.PLATFORM_DOUBLE_WIDTH / 2, c.PLATFORM_SEGMENT_LENGTH * 2.5, 0.0},
                {column_collection:get_column(0).x_pos - c.PLATFORM_DOUBLE_WIDTH / 2, c.PLATFORM_SEGMENT_LENGTH * 1.5, 0.0},
                {column_collection:get_column(0).x_pos + c.PLATFORM_DOUBLE_WIDTH / 2, c.PLATFORM_SEGMENT_LENGTH * 1.5, 0.0},
                {column_collection:get_column(1).x_pos + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS / 2, c.PLATFORM_SEGMENT_LENGTH * 1.5, 0.0},
                {column_collection:get_column(2).x_pos + c.PLATFORM_SINGLE_WIDTH / 2, c.PLATFORM_SEGMENT_LENGTH * 1.5, 0.0},

                {column_collection:get_column(2).x_pos + c.PLATFORM_SINGLE_WIDTH / 2, c.PLATFORM_SEGMENT_LENGTH * -2.5, 0.0},
                {column_collection:get_column(1).x_pos + c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS / 2, c.PLATFORM_SEGMENT_LENGTH * -2.5, 0.0},
                {column_collection:get_column(0).x_pos + c.PLATFORM_DOUBLE_WIDTH / 2, c.PLATFORM_SEGMENT_LENGTH * -2.5, 0.0},
                {column_collection:get_column(0).x_pos + c.PLATFORM_DOUBLE_WIDTH / 2, c.PLATFORM_SEGMENT_LENGTH * -1.5, 0.0},
                {column_collection:get_column(0).x_pos - c.PLATFORM_DOUBLE_WIDTH / 2, c.PLATFORM_SEGMENT_LENGTH * -1.5, 0.0},
                {column_collection:get_column(-2).x_pos + c.PLATFORM_SINGLE_WIDTH / 2, c.PLATFORM_SEGMENT_LENGTH * -1.5, 0.0},
                {column_collection:get_column(-2).x_pos - c.PLATFORM_SINGLE_WIDTH / 2, c.PLATFORM_SEGMENT_LENGTH * -1.5, 0.0},
                {column_collection:get_column(-3).x_pos - c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM, c.PLATFORM_SEGMENT_LENGTH * -1.5, 0.0},
            }, polygon)
        end)

    end)

    describe('create_terrain_alignment_list_from_polygon', function ()

        it ('creates terraign alignment list from polygon', function ()
            local polygon = {
                {-1, 1, 0},
                {1, 1, 0},
                {1, -1, 0},
                {-1, -1, 0}
            }
    
            assert.are.same({
                type = 'EQUAL',
                faces = { polygon }
            }, TerrainAlignment.create_terrain_alignment_list_from_polygon(polygon))
        end)
        
    end)

    describe('create_ground_faces_from_polygon', function ()
        it ('creates groud faces from polygon', function ()
            local polygon = {
                {-1, 1, 0},
                {1, 1, 0},
                {1, -1, 0},
                {-1, -1, 0}
            }

            assert.are.same({  
				face =  polygon,
				modes = {
					{
						type = "FILL",
						key = "town_concrete"
					},
					{
						type = "STROKE_OUTER",
						key = "building_paving"
					},
				}
			}, TerrainAlignment.create_ground_faces_from_polygon(polygon, 'town_concrete', 'building_paving'))
        end)
    end)

end)