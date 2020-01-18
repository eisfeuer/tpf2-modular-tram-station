local SlotBuilder = require('modutram_slot_builder')
local Module = require('modutram_module')
local c = require('modutram_constants')
local t = require('modutram_types')
local Position = require('modutram_position')
local SlotCollection = require('modutram_slot_collection')
local Platform = require('modutram_platform')
local Track = require('modutram_Track')

describe('SlotBuilder', function ()
    describe('platform_double', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.PLATFORM_DOUBLE}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_platform_double",
                spacing = {
                    c.PLATFORM_DOUBLE_WIDTH / 2,
                    c.PLATFORM_DOUBLE_WIDTH / 2,
                    c.PLATFORM_SEGMENT_LENGTH / 2,
                    c.PLATFORM_SEGMENT_LENGTH / 2,
                }
            }, SlotBuilder.platform_double(
                Module.make_id({type = t.PLATFORM_DOUBLE}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('platform_single_left', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.PLATFORM_LEFT}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_platform_single_left",
                spacing = {
                    c.PLATFORM_SINGLE_WIDTH / 2,
                    c.PLATFORM_SINGLE_WIDTH / 2,
                    c.PLATFORM_SEGMENT_LENGTH / 2,
                    c.PLATFORM_SEGMENT_LENGTH / 2,
                }
            }, SlotBuilder.platform_single_left(
                Module.make_id({type = t.PLATFORM_LEFT}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('platform_single_right', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.PLATFORM_RIGHT}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_platform_single_right",
                spacing = {
                    c.PLATFORM_SINGLE_WIDTH / 2,
                    c.PLATFORM_SINGLE_WIDTH / 2,
                    c.PLATFORM_SEGMENT_LENGTH / 2,
                    c.PLATFORM_SEGMENT_LENGTH / 2,
                }
            }, SlotBuilder.platform_single_right(
                Module.make_id({type = t.PLATFORM_RIGHT}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('track_double_doors_right', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_track_double_doors_right",
                spacing = {
                    (2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS) / 2 - 0.1,
                    (2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS) / 2 - 0.1,
                    c.PLATFORM_SEGMENT_LENGTH / 2 - 0.1,
                    c.PLATFORM_SEGMENT_LENGTH / 2 - 0.1,
                }
            }, SlotBuilder.track_double_doors_right(
                Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('track_up_doors_right', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.TRACK_UP_DOORS_RIGHT}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_track_up_doors_right",
                spacing = {
                    c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
                    c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
                    c.PLATFORM_SEGMENT_LENGTH / 2 - 0.1,
                    c.PLATFORM_SEGMENT_LENGTH / 2 - 0.1,
                }
            }, SlotBuilder.track_up_doors_right(
                Module.make_id({type = t.TRACK_UP_DOORS_RIGHT}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('track_down_doors_right', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_track_down_doors_right",
                spacing = {
                    c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
                    c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
                    c.PLATFORM_SEGMENT_LENGTH / 2 - 0.1,
                    c.PLATFORM_SEGMENT_LENGTH / 2 - 0.1,
                }
            }, SlotBuilder.track_down_doors_right(
                Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('street_connection_in', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.STREET_CONNECTION_IN}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_street_connection_in",
                spacing = {
                    c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
                    c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
                    c.PLATFORM_SEGMENT_LENGTH - 1,
                    1,
                }
            }, SlotBuilder.street_connection_in(
                Module.make_id({type = t.STREET_CONNECTION_IN}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('street_connection_out', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.STREET_CONNECTION_OUT}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_street_connection_out",
                spacing = {
                    c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
                    c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM - 0.1,
                    1,
                    c.PLATFORM_SEGMENT_LENGTH - 1,
                }
            }, SlotBuilder.street_connection_out(
                Module.make_id({type = t.STREET_CONNECTION_OUT}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('street_connection_double', function ()
        it('creates slot', function ()
            assert.are.same({
                id = Module.make_id({type = t.STREET_CONNECTION_DOUBLE}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_street_connection_double",
                spacing = {
                    (2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS) / 2 - 0.1,
                    (2 * c.DISTANCE_BETWEEN_TRACK_AND_PLATFORM + c.DISTANCE_BETWEEN_TWO_TRACKS) / 2 - 0.1,
                    1,
                    c.PLATFORM_SEGMENT_LENGTH - 1,
                }
            }, SlotBuilder.street_connection_double(
                Module.make_id({type = t.STREET_CONNECTION_DOUBLE}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('platform by type', function ()
        it('creates platform by type', function ()
            assert.are.same(SlotBuilder.platform_double(
                Module.make_id({type = t.PLATFORM_DOUBLE}),
                Position:new{}:as_matrix()
            ), SlotBuilder.platform_by_type(
                t.PLATFORM_DOUBLE,
                Module.make_id({type = t.PLATFORM_DOUBLE}),
                Position:new{}:as_matrix()
            ))

            assert.are.same(SlotBuilder.platform_single_left(
                Module.make_id({type = t.PLATFORM_LEFT}),
                Position:new{}:as_matrix()
            ), SlotBuilder.platform_by_type(
                t.PLATFORM_LEFT,
                Module.make_id({type = t.PLATFORM_LEFT}),
                Position:new{}:as_matrix()
            ))

            assert.are.same(SlotBuilder.platform_single_right(
                Module.make_id({type = t.PLATFORM_RIGHT}),
                Position:new{}:as_matrix()
            ), SlotBuilder.platform_by_type(
                t.PLATFORM_RIGHT,
                Module.make_id({type = t.PLATFORM_RIGHT}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('platform_entrance_general', function ()
        it ('creates top right single platform entrance slots', function ()
            assert.are.same({
                id = Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_RIGHT_TOP}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_platform_entrance",
                spacing = {
                    c.PLATFORM_SINGLE_WIDTH / 2 - 0.1,
                    c.PLATFORM_SINGLE_WIDTH / 2 - 0.1,
                    1,
                    c.PLATFORM_SEGMENT_LENGTH - 1,
                }
            }, SlotBuilder.platform_entrance_general(
                t.PLATFORM_RIGHT,
                'top',
                Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_RIGHT_TOP}),
                Position:new{}:as_matrix()
            ))
        end)

        it ('creates bottom right single platform entrance slots', function ()
            assert.are.same({
                id = Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_RIGHT_BTM}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_platform_entrance",
                spacing = {
                    c.PLATFORM_SINGLE_WIDTH / 2 - 0.1,
                    c.PLATFORM_SINGLE_WIDTH / 2 - 0.1,
                    c.PLATFORM_SEGMENT_LENGTH - 1,
                    1,
                }
            }, SlotBuilder.platform_entrance_general(
                t.PLATFORM_RIGHT,
                'btm',
                Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_RIGHT_BTM}),
                Position:new{}:as_matrix()
            ))
        end)

        it ('creates top left single platform entrance slots', function ()
            assert.are.same({
                id = Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_LEFT_TOP}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_platform_entrance",
                spacing = {
                    c.PLATFORM_SINGLE_WIDTH / 2 - 0.1,
                    c.PLATFORM_SINGLE_WIDTH / 2 - 0.1,
                    1,
                    c.PLATFORM_SEGMENT_LENGTH - 1,
                }
            }, SlotBuilder.platform_entrance_general(
                t.PLATFORM_LEFT,
                'top',
                Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_LEFT_TOP}),
                Position:new{}:as_matrix()
            ))
        end)

        it ('creates bottom left single platform entrance slots', function ()
            assert.are.same({
                id = Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_LEFT_BTM}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_platform_entrance",
                spacing = {
                    c.PLATFORM_SINGLE_WIDTH / 2 - 0.1,
                    c.PLATFORM_SINGLE_WIDTH / 2 - 0.1,
                    c.PLATFORM_SEGMENT_LENGTH - 1,
                    1,
                }
            }, SlotBuilder.platform_entrance_general(
                t.PLATFORM_LEFT,
                'btm',
                Module.make_id({type = t.PLATFORM_ENTRANCE_SINGLE_LEFT_BTM}),
                Position:new{}:as_matrix()
            ))
        end)

        it ('creates top double platform entrance slots', function ()
            assert.are.same({
                id = Module.make_id({type = t.PLATFORM_ENTRANCE_DOUBLE_TOP}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_platform_entrance",
                spacing = {
                    c.PLATFORM_DOUBLE_WIDTH / 2 - 0.1,
                    c.PLATFORM_DOUBLE_WIDTH / 2 - 0.1,
                    1,
                    c.PLATFORM_SEGMENT_LENGTH - 1,
                }
            }, SlotBuilder.platform_entrance_general(
                t.PLATFORM_DOUBLE,
                'top',
                Module.make_id({type = t.PLATFORM_ENTRANCE_DOUBLE_TOP}),
                Position:new{}:as_matrix()
            ))
        end)

        it ('creates bottom double platform entrance slots', function ()
            assert.are.same({
                id = Module.make_id({type = t.PLATFORM_ENTRANCE_DOUBLE_BTM}),
                transf = Position:new{}:as_matrix(),
                type = "eisfeuer_modutram_platform_entrance",
                spacing = {
                    c.PLATFORM_DOUBLE_WIDTH / 2 - 0.1,
                    c.PLATFORM_DOUBLE_WIDTH / 2 - 0.1,
                    c.PLATFORM_SEGMENT_LENGTH - 1,
                    1,
                }
            }, SlotBuilder.platform_entrance_general(
                t.PLATFORM_DOUBLE,
                'btm',
                Module.make_id({type = t.PLATFORM_ENTRANCE_DOUBLE_BTM}),
                Position:new{}:as_matrix()
            ))
        end)
    end)

    describe('add_neighbor_slots_to_collection', function ()
        it('creates slots for all possible left neighbors of a double platform an adds it to slot collection', function ()
            local slotCollection = SlotCollection:new{}
            SlotBuilder.add_neighbor_slots_to_collection(
                slotCollection,
                Platform:new{type = t.PLATFORM_DOUBLE, id = -1, x_pos = -20},
                c.LEFT
            )
            assert.are.same({
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = -2}),
                    Position:new{x = -20 - Track:new{type = t.TRACK_DOUBLE_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_DOUBLE})}:as_matrix()
                ),
                SlotBuilder.track_up_doors_right(
                    Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = -2}),
                    Position:new{x = -20 - Track:new{type = t.TRACK_UP_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_DOUBLE})}:as_matrix()
                ),
            }, slotCollection.slots)
        end)

        it('creates slots for all possible right neighbors of a double platform an adds it to slot collection', function ()
            local slotCollection = SlotCollection:new{}
            SlotBuilder.add_neighbor_slots_to_collection(
                slotCollection,
                Platform:new{type = t.PLATFORM_DOUBLE, id = 1, x_pos = 20},
                c.RIGHT
            )
            assert.are.same({
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 2}),
                    Position:new{x = 20 + Track:new{type = t.TRACK_DOUBLE_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_DOUBLE})}:as_matrix()
                ),
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 2}),
                    Position:new{x = 20 + Track:new{type = t.TRACK_DOWN_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_DOUBLE})}:as_matrix()
                ),
            }, slotCollection.slots)
        end)

        it('creates slots for all possible left neighbors of a single left platform an adds it to slot collection', function ()
            local slotCollection = SlotCollection:new{}
            SlotBuilder.add_neighbor_slots_to_collection(
                slotCollection,
                Platform:new{type = t.PLATFORM_LEFT, id = -1, x_pos = -20},
                c.LEFT
            )
            assert.are.same({
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = -2}),
                    Position:new{x = -20 - Track:new{type = t.TRACK_DOUBLE_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_LEFT})}:as_matrix()
                ),
                SlotBuilder.track_up_doors_right(
                    Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = -2}),
                    Position:new{x = -20 - Track:new{type = t.TRACK_UP_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_LEFT})}:as_matrix()
                ),
            }, slotCollection.slots)
        end)

        it('creates slots for all possible right neighbors of a single left platform an adds it to slot collection', function ()
            local slotCollection = SlotCollection:new{}
            SlotBuilder.add_neighbor_slots_to_collection(
                slotCollection,
                Platform:new{type = t.PLATFORM_LEFT, id = 1, x_pos = 20},
                c.RIGHT
            )
            assert.are.same({
                SlotBuilder.track_up_doors_right(
                    Module.make_id({type = t.TRACK_UP_DOORS_RIGHT, grid_x = 2}),
                    Position:new{x = 20 + Track:new{type = t.TRACK_UP_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_LEFT})}:as_matrix()
                ),
            }, slotCollection.slots)
        end)

        it('creates slots for all possible left neighbors of a single right platform an adds it to slot collection', function ()
            local slotCollection = SlotCollection:new{}
            SlotBuilder.add_neighbor_slots_to_collection(
                slotCollection,
                Platform:new{type = t.PLATFORM_RIGHT, id = -1, x_pos = -20},
                c.LEFT
            )
            assert.are.same({
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = -2}),
                    Position:new{x = -20 - Track:new{type = t.TRACK_DOWN_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_RIGHT})}:as_matrix()
                ),
            }, slotCollection.slots)
        end)

        it('creates slots for all possible right neighbors of a single right platform an adds it to slot collection', function ()
            local slotCollection = SlotCollection:new{}
            SlotBuilder.add_neighbor_slots_to_collection(
                slotCollection,
                Platform:new{type = t.PLATFORM_RIGHT, id = 1, x_pos = 20},
                c.RIGHT
            )
            assert.are.same({
                SlotBuilder.track_double_doors_right(
                    Module.make_id({type = t.TRACK_DOUBLE_DOORS_RIGHT, grid_x = 2}),
                    Position:new{x = 20 + Track:new{type = t.TRACK_DOUBLE_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_RIGHT})}:as_matrix()
                ),
                SlotBuilder.track_down_doors_right(
                    Module.make_id({type = t.TRACK_DOWN_DOORS_RIGHT, grid_x = 2}),
                    Position:new{x = 20 + Track:new{type = t.TRACK_DOWN_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_RIGHT})}:as_matrix()
                ),
            }, slotCollection.slots)
        end)

        it('creates slots for all possible left neighbors of a double track an adds it to slot collection', function ()
            local slotCollection = SlotCollection:new{}
            SlotBuilder.add_neighbor_slots_to_collection(
                slotCollection,
                Track:new{type = t.TRACK_DOUBLE_DOORS_RIGHT, id = -1, x_pos = -20},
                c.LEFT
            )
            assert.are.same({
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = -2}),
                    Position:new{x = -20 - Track:new{type = t.TRACK_DOUBLE_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_DOUBLE})}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -2}),
                    Position:new{x = -20 - Track:new{type = t.TRACK_DOUBLE_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_RIGHT})}:as_matrix()
                ),
            }, slotCollection.slots)
        end)

        it('creates slots for all possible right neighbors of a double track an adds it to slot collection', function ()
            local slotCollection = SlotCollection:new{}
            SlotBuilder.add_neighbor_slots_to_collection(
                slotCollection,
                Track:new{type = t.TRACK_DOUBLE_DOORS_RIGHT, id = 1, x_pos = 20},
                c.RIGHT
            )
            assert.are.same({
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2}),
                    Position:new{x = 20 + Track:new{type = t.TRACK_DOUBLE_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_DOUBLE})}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 2}),
                    Position:new{x = 20 + Track:new{type = t.TRACK_DOUBLE_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_LEFT})}:as_matrix()
                ),
            }, slotCollection.slots)
        end)

        it('creates slots for all possible left neighbors of a up track an adds it to slot collection', function ()
            local slotCollection = SlotCollection:new{}
            SlotBuilder.add_neighbor_slots_to_collection(
                slotCollection,
                Track:new{type = t.TRACK_UP_DOORS_RIGHT, id = -1, x_pos = -20},
                c.LEFT
            )
            assert.are.same({
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = -2}),
                    Position:new{x = -20 - Track:new{type = t.TRACK_UP_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_LEFT})}:as_matrix()
                ),
            }, slotCollection.slots)
        end)

        it('creates slots for all possible right neighbors of a up track an adds it to slot collection', function ()
            local slotCollection = SlotCollection:new{}
            SlotBuilder.add_neighbor_slots_to_collection(
                slotCollection,
                Track:new{type = t.TRACK_UP_DOORS_RIGHT, id = 1, x_pos = 20},
                c.RIGHT
            )
            assert.are.same({
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = 2}),
                    Position:new{x = 20 + Track:new{type = t.TRACK_UP_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_DOUBLE})}:as_matrix()
                ),
                SlotBuilder.platform_single_left(
                    Module.make_id({type = t.PLATFORM_LEFT, grid_x = 2}),
                    Position:new{x = 20 + Track:new{type = t.TRACK_UP_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_LEFT})}:as_matrix()
                ),
            }, slotCollection.slots)
        end)

        it('creates slots for all possible left neighbors of a down track an adds it to slot collection', function ()
            local slotCollection = SlotCollection:new{}
            SlotBuilder.add_neighbor_slots_to_collection(
                slotCollection,
                Track:new{type = t.TRACK_DOWN_DOORS_RIGHT, id = -1, x_pos = -20},
                c.LEFT
            )
            assert.are.same({
                SlotBuilder.platform_double(
                    Module.make_id({type = t.PLATFORM_DOUBLE, grid_x = -2}),
                    Position:new{x = -20 - Track:new{type = t.TRACK_DOWN_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_DOUBLE})}:as_matrix()
                ),
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = -2}),
                    Position:new{x = -20 - Track:new{type = t.TRACK_DOWN_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_RIGHT})}:as_matrix()
                ),
            }, slotCollection.slots)
        end)

        it('creates slots for all possible right neighbors of a down track an adds it to slot collection', function ()
            local slotCollection = SlotCollection:new{}
            SlotBuilder.add_neighbor_slots_to_collection(
                slotCollection,
                Track:new{type = t.TRACK_DOWN_DOORS_RIGHT, id = 1, x_pos = 20},
                c.RIGHT
            )
            assert.are.same({
                SlotBuilder.platform_single_right(
                    Module.make_id({type = t.PLATFORM_RIGHT, grid_x = 2}),
                    Position:new{x = 20 + Track:new{type = t.TRACK_DOWN_DOORS_RIGHT}:get_distance_to_neighbor(Platform:new{type = t.PLATFORM_RIGHT})}:as_matrix()
                ),
            }, slotCollection.slots)
        end)
    end)
end)