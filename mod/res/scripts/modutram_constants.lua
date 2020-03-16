return {
    PLATFORM_SEGMENT_LENGTH = 18,
    TRACK_REMOVE_AREA_LENGTH = 3.6,
    DISTANCE_BETWEEN_TWO_TRACKS = 3,
    DISTANCE_BETWEEN_TRACK_AND_PLATFORM = 1.325,
    DISTANCE_BETWEEN_VEHICLE_AND_PERSON_LANE = 2.325,
    PLATFORM_DOUBLE_WIDTH = 5.4,
    PLATFORM_SINGLE_WIDTH = 3.3,
    LEFT = -1,
    RIGHT = 1,
    PLATFORM_PATH_MODELS = {
        bus = {
            waiting_area_only_terminal = { model = 'station/tram/path/bus_waiting.mdl', terminal_position = 0 },
            stop_edge_terminal = { model = 'station/tram/path/bus_stop_edge.mdl', terminal_position = 0 },
            stop_mid_terminal = { model = 'station/tram/path/bus_stop_mid.mdl', terminal_position = 0 },
            vehicle_lane_without_terminal = { model = 'station/tram/path/bus_lane_only.mdl', terminal_position = 0 },
        },
        tram_not_electric = {
            waiting_area_only_terminal = { model = 'station/tram/path/tram_not_electric_waiting.mdl', terminal_position = 0 },
            stop_edge_terminal = { model = 'station/tram/path/tram_not_electric_stop_edge.mdl', terminal_position = 0 },
            stop_mid_terminal = { model = 'station/tram/path/tram_not_electric_stop_mid.mdl', terminal_position = 0 },
            vehicle_lane_without_terminal = { model = 'station/tram/path/tram_not_electric_lane_only.mdl', terminal_position = 0 },
        },
        tram_not_electric_and_bus = {
            waiting_area_only_terminal = { model = 'station/tram/path/tram_not_electric_and_bus_waiting.mdl', terminal_position = 0 },
            stop_edge_terminal = { model = 'station/tram/path/tram_not_electric_and_bus_stop_edge.mdl', terminal_position = 0 },
            stop_mid_terminal = { model = 'station/tram/path/tram_not_electric_and_bus_stop_mid.mdl', terminal_position = 0 },
            vehicle_lane_without_terminal = { model = 'station/tram/path/tram_not_electric_and_bus_lane_only.mdl', terminal_position = 0 },
        },
        tram = {
            waiting_area_only_terminal = { model = 'station/tram/path/tram_waiting.mdl', terminal_position = 0 },
            stop_edge_terminal = { model = 'station/tram/path/tram_stop_edge.mdl', terminal_position = 0 },
            stop_mid_terminal = { model = 'station/tram/path/tram_stop_mid.mdl', terminal_position = 0 },
            vehicle_lane_without_terminal = { model = 'station/tram/path/tram_lane_only.mdl', terminal_position = 0 },
        },
        tram_and_bus = {
            waiting_area_only_terminal = { model = 'station/tram/path/tram_and_bus_waiting.mdl', terminal_position = 0 },
            stop_edge_terminal = { model = 'station/tram/path/tram_and_bus_stop_edge.mdl', terminal_position = 0 },
            stop_mid_terminal = { model = 'station/tram/path/tram_and_bus_stop_mid.mdl', terminal_position = 0 },
            vehicle_lane_without_terminal = { model = 'station/tram/path/tram_and_bus_lane_only.mdl', terminal_position = 0 },
        },
        platform_access_ramp = 'station/tram/path/platform_access_ramp.mdl',
        platform_access_ramp_mirrored = 'station/tram/path/platform_access_ramp_mirrored.mdl',
        platform_access_plain = 'station/tram/path/platform_access_plain.mdl',
        platform_access_plain_linkable = 'station/tram/path/platform_access_plain_linkable.mdl'
    },
    DEFAULT_ASSET_SLOT_TYPE = 'g_decoration',
    DEFAULT_ASSET_SLOT_SPACING = {0.1 ,0.1, 0.1, 0.1},
    DEFAULT_BUS_LANE_MODULE = 'modules/bus_lane.module',
    DEFAULT_STREET_CONNECTION_MODULES = {
        connection_in = 'modules/street_connection_in.module',
        connection_out = 'modules/street_connection_out.module',
        connection_double = 'modules/street_connection_double.module'
    },
    STREET_CONNECTION_PATH_LENGHT = 0.8
}