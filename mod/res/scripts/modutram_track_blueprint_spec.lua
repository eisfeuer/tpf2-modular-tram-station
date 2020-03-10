local TrackBlueprint = require('modutram_track_blueprint')
local t = require('modutram_types')
local Module = require('modutram_module')
local c = require('modutram_constants')

describe('TrackBlueprint', function ()
    
    describe('add_to_template', function ()
        it('adds track to template', function ()
            local template = {
                [123456] = 'a_module.module'
            }

            local track_blueprint = TrackBlueprint:new{
                track_type = t.TRACK_DOUBLE_DOORS_RIGHT,
                track_grid_x = 2,
                track_module = 'track.module'
            }
            template = track_blueprint:add_to_template(template)

            assert.are.same({
                [123456] = 'a_module.module',
                [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 2, grid_y = 0})] = 'track.module'
            }, template)
        end)
    end)

    describe('add_bus_lane', function ()
        it('adds a bus lane to track', function ()
            local template = {
                [123456] = 'a_module.module'
            }

            local track_blueprint = TrackBlueprint:new{
                track_type = t.TRACK_DOUBLE_DOORS_RIGHT,
                track_grid_x = 2,
                track_module = 'track.module'
            }

            track_blueprint:add_bus_lane()
            template = track_blueprint:add_to_template(template)

            assert.are.same({
                [123456] = 'a_module.module',
                [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 2, grid_y = 0})] = 'track.module',
                [Module.make_id({type = t.ASSET_BUS_LANE, grid_x = 2, grid_y = 0, asset_id = 1})] = c.DEFAULT_BUS_LANE_MODULE
            }, template)
        end)

        it('adds a bus lane with custom module to track', function ()
            local template = {
                [123456] = 'a_module.module'
            }

            local track_blueprint = TrackBlueprint:new{
                track_type = t.TRACK_DOUBLE_DOORS_RIGHT,
                track_grid_x = 2,
                track_module = 'track.module'
            }

            track_blueprint:add_bus_lane('custom_bus_lane.module')
            template = track_blueprint:add_to_template(template)

            assert.are.same({
                [123456] = 'a_module.module',
                [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 2, grid_y = 0})] = 'track.module',
                [Module.make_id({type = t.ASSET_BUS_LANE, grid_x = 2, grid_y = 0, asset_id = 1})] = 'custom_bus_lane.module'
            }, template)
        end)
    end)

    describe('add_tram_tracks', function ()
        it('adds tram tracks', function ()
            local template = {
                [123456] = 'a_module.module'
            }

            local track_blueprint = TrackBlueprint:new{
                track_type = t.TRACK_DOUBLE_DOORS_RIGHT,
                track_grid_x = 2,
                track_module = 'track.module'
            }

            track_blueprint:add_tram_tracks('tram_track.module')
            template = track_blueprint:add_to_template(template)

            assert.are.same({
                [123456] = 'a_module.module',
                [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 2, grid_y = 0})] = 'track.module',
                [Module.make_id({type = t.ASSET_TRAM_TRACKS, grid_x = 2, grid_y = 0, asset_id = 1})] = 'tram_track.module'
            }, template)
        end)
    end)

    describe('add_catenary', function ()
        it('adds catenary', function ()
            local template = {
                [123456] = 'a_module.module'
            }

            local track_blueprint = TrackBlueprint:new{
                track_type = t.TRACK_DOUBLE_DOORS_RIGHT,
                track_grid_x = 2,
                track_module = 'track.module'
            }

            track_blueprint:add_catenary('catenary.module')
            template = track_blueprint:add_to_template(template)

            assert.are.same({
                [123456] = 'a_module.module',
                [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 2, grid_y = 0})] = 'track.module',
                [Module.make_id({type = t.ASSET_CATENARY, grid_x = 2, grid_y = 0, asset_id = 1})] = 'catenary.module'
            }, template)
        end)
    end)

    describe('add_street_connection_top', function ()
        it('adds street connection at the top side (double track)', function ()
            local template = {
                [123456] = 'a_module.module'
            }

            local track_blueprint = TrackBlueprint:new{
                track_type = t.TRACK_DOUBLE_DOORS_RIGHT,
                track_grid_x = 2,
                track_module = 'track.module'
            }

            track_blueprint:add_street_connection_top()
            template = track_blueprint:add_to_template(template)

            assert.are.same({
                [123456] = 'a_module.module',
                [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 2, grid_y = 0})] = 'track.module',
                [Module.make_id({type = t.STREET_CONNECTION_DOUBLE, grid_x = 2, grid_y = 1})] = c.DEFAULT_STREET_CONNECTION_MODULES.connection_double
            }, template)
        end)

        it('adds street connection at the top side (single track up)', function ()
            local template = {
                [123456] = 'a_module.module'
            }

            local track_blueprint = TrackBlueprint:new{
                track_type = t.TRACK_UP_DOORS_RIGHT,
                track_grid_x = 2,
                track_module = 'track.module'
            }

            track_blueprint:add_street_connection_top()
            template = track_blueprint:add_to_template(template)

            assert.are.same({
                [123456] = 'a_module.module',
                [Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = 2, grid_y = 0})] = 'track.module',
                [Module.make_id({type = t.STREET_CONNECTION_OUT, grid_x = 2, grid_y = 1})] = c.DEFAULT_STREET_CONNECTION_MODULES.connection_out
            }, template)
        end)

        it('adds street connection at the top side (single track down)', function ()
            local template = {
                [123456] = 'a_module.module'
            }

            local track_blueprint = TrackBlueprint:new{
                track_type = t.TRACK_DOWN_DOORS_RIGHT,
                track_grid_x = 2,
                track_module = 'track.module'
            }

            track_blueprint:add_street_connection_top()
            template = track_blueprint:add_to_template(template)

            assert.are.same({
                [123456] = 'a_module.module',
                [Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 2, grid_y = 0})] = 'track.module',
                [Module.make_id({type = t.STREET_CONNECTION_IN, grid_x = 2, grid_y = 1})] = c.DEFAULT_STREET_CONNECTION_MODULES.connection_in
            }, template)
        end)
    end)

    describe('add_street_connection_bottom', function ()
        it('adds street connection at the bottom side (double track)', function ()
            local template = {
                [123456] = 'a_module.module'
            }

            local track_blueprint = TrackBlueprint:new{
                track_type = t.TRACK_DOUBLE_DOORS_RIGHT,
                track_grid_x = 2,
                track_module = 'track.module'
            }

            track_blueprint:add_street_connection_bottom()
            template = track_blueprint:add_to_template(template)

            assert.are.same({
                [123456] = 'a_module.module',
                [Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 2, grid_y = 0})] = 'track.module',
                [Module.make_id({type = t.STREET_CONNECTION_DOUBLE, grid_x = 2, grid_y = -1})] = c.DEFAULT_STREET_CONNECTION_MODULES.connection_double
            }, template)
        end)

        it('adds street connection at the bottom side (single track up)', function ()
            local template = {
                [123456] = 'a_module.module'
            }

            local track_blueprint = TrackBlueprint:new{
                track_type = t.TRACK_UP_DOORS_RIGHT,
                track_grid_x = 2,
                track_module = 'track.module'
            }

            track_blueprint:add_street_connection_bottom()
            template = track_blueprint:add_to_template(template)

            assert.are.same({
                [123456] = 'a_module.module',
                [Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = 2, grid_y = 0})] = 'track.module',
                [Module.make_id({type = t.STREET_CONNECTION_IN, grid_x = 2, grid_y = -1})] = c.DEFAULT_STREET_CONNECTION_MODULES.connection_in
            }, template)
        end)

        it('adds street connection at the bottom side (single track down)', function ()
            local template = {
                [123456] = 'a_module.module'
            }

            local track_blueprint = TrackBlueprint:new{
                track_type = t.TRACK_DOWN_DOORS_RIGHT,
                track_grid_x = 2,
                track_module = 'track.module'
            }

            track_blueprint:add_street_connection_bottom()
            template = track_blueprint:add_to_template(template)

            assert.are.same({
                [123456] = 'a_module.module',
                [Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 2, grid_y = 0})] = 'track.module',
                [Module.make_id({type = t.STREET_CONNECTION_OUT, grid_x = 2, grid_y = -1})] = c.DEFAULT_STREET_CONNECTION_MODULES.connection_out
            }, template)
        end)
    end)

end)