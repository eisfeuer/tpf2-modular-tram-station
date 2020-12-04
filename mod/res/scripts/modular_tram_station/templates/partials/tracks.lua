local GridModuleColumn = require("modutram.blueprint.GridModuleColumn")
local GridModuleBlueprint = require("modutram.blueprint.GridModuleBlueprint")
local AssetCollection = require("modutram.blueprint.AssetCollection")
local t = require("modutram.types")

local Tracks = {}

local function getCatenary(theme, params, streetConnection)
    local assetCollection = AssetCollection:new{}

    if params:hasTramTracks() and params:isElectrified() then
        assetCollection:addModule(1, theme:get("catenary"))
    end

    if streetConnection and params:hasEnabledStreetConnections() then
        assetCollection:addModule(streetConnection, theme:get("tram_street_connection"))
    end

    return assetCollection
end

function Tracks.buildBidirectionalTracksBlueprint(theme, params)
    local startPos = -math.floor(params:getLength() / 2)
    local endPos = math.ceil(params:getLength() / 2)

    local moduleName = params:hasTramTracks() and theme:get("tram_bidirectional_right") or theme:get("rbs_bidirectional_right")

    local assetCollection = getCatenary(theme, params)
    local column = GridModuleColumn:new{}

    column:addBlueprint(startPos - 1, GridModuleBlueprint:new{
        slotType = t.TRAM_BIDIRECTIONAL_RIGHT,
        moduleName = moduleName,
        assets = getCatenary(theme, params, 4),
    })
    for i = startPos, endPos do
        column:addBlueprint(i, GridModuleBlueprint:new{
            slotType = t.TRAM_BIDIRECTIONAL_RIGHT,
            moduleName = moduleName,
            assets = assetCollection
        })
    end
    column:addBlueprint(endPos + 1, GridModuleBlueprint:new{
        slotType = t.TRAM_BIDIRECTIONAL_RIGHT,
        moduleName = moduleName,
        assets = getCatenary(theme, params, 3)
    })

    return column
end

local function buildOneWayTracks(theme, params, slotType, tramThemeType, rbsThemeType)
    local startPos = -math.floor(params:getLength() / 2)
    local endPos = math.ceil(params:getLength() / 2)

    local moduleName = params:hasTramTracks() and theme:get(tramThemeType) or theme:get(rbsThemeType)

    local assetCollection = getCatenary(theme, params)
    local column = GridModuleColumn:new{}

    column:addBlueprint(startPos - 1, GridModuleBlueprint:new{
        slotType = slotType,
        moduleName = moduleName,
        assets = getCatenary(theme, params, 4),
    })
    for i = startPos, endPos do
        column:addBlueprint(i, GridModuleBlueprint:new{
            slotType = slotType,
            moduleName = moduleName,
            assets = assetCollection
        })
    end
    column:addBlueprint(endPos + 1, GridModuleBlueprint:new{
        slotType = slotType,
        moduleName = moduleName,
        assets = getCatenary(theme, params, 3),
    })

    return column
end

function Tracks.buildTrackUp(theme, params)
    return buildOneWayTracks(theme, params, t.TRAM_UP, "tram_up", "rbs_up")
end

function Tracks.buildTrackDown(theme, params)
    return buildOneWayTracks(theme, params, t.TRAM_DOWN, "tram_down", "rbs_down")
end

return Tracks