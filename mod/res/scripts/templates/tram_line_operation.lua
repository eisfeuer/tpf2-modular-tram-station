local Theme = require("modutram.theme.Theme")
local ParamRespository = require("utils.ParamRepository")
local t = require("modutram.types")

local GridModuleColumn = require("modutram.blueprint.GridModuleColumn")
local GridModuleBlueprint = require("modutram.blueprint.GridModuleBlueprint")
local AssetCollection = require("modutram.blueprint.AssetCollection")

local function hasBenches(params, gridY)
    if params:hasEvenLength() then
        return gridY ~= 0 and gridY ~= 1
    end

    return gridY ~= 0
end

local function hasBenchesIsland(params, gridY)
    if params:hasEvenLength() then
        return gridY ~= 0 and gridY ~= 1
    end

    return math.abs(gridY) > 1
end

local function buildSitePlatformAssets(theme, params, gridY)
    local collection = AssetCollection:new{}

    if params:fenceEnabled() then
        collection:addModule(6, theme:get("fence"))
    end

    if params:lightingEnabled() then
        collection:addModule(5, theme:get("lighting"))
    end

    if hasBenches(params, gridY) then
        if gridY > 0 then
            collection:addModule(8, theme:get("billboard_small"))
            collection:addModule(7, theme:get("benches"))
            collection:addModule(15, theme:get("station_name_sign"))
        else
            collection:addModule(7, theme:get("billboard_small"))
            collection:addModule(8, theme:get("benches"))
            collection:addModule(16, theme:get("station_name_sign"))
        end
    end

    if gridY == 0 and params:shelterEnabled() then
        local shelterAssetId = params:hasEvenLength() and 2 or 1
        collection:addModule(shelterAssetId, theme:get(params:getShelterTheme()))
    end

    if gridY == 0 and not params:hasEvenLength() and theme:has("destination_display") then
        if params:shelterEnabled() then
            local assetId = 13 + math.min(params:getShelterSize(), 2) - 1
            collection:addModule(assetId, theme:get('destination_display'))
        else
            collection:addModule(12, theme:get('destination_display'))
        end
    end

    if gridY == 1 and params:hasEvenLength() and theme:has("destination_display") then
        if params:shelterEnabled() then
            local assetId = 10 + math.min(params:getShelterSize(), 2) - 1
            collection:addModule(assetId, theme:get('destination_display'))
        else
            collection:addModule(9, theme:get('destination_display'))
        end
    end

    if gridY == -math.floor(params:getLength() / 2) then
        collection:addModule(9, theme:get("bus_station_sign"))
    end

    if gridY == math.ceil(params:getLength() / 2) then
        collection:addModule(14, theme:get("bus_station_sign"))
    end

    return collection
end

local function buildIslandPlatformAssets(theme, params, gridY)
    local collection = AssetCollection:new{}
    local hasShelters = params:shelterEnabled() and params:getLength() > 0

    if params:lightingEnabled() then
        collection:addModule(5, theme:get("lighting"))
    end

    if gridY == -1 and hasShelters and not params:hasEvenLength() then
        collection:addModule(4, theme:get(params:getShelterTheme()))
    end

    if gridY == 0 then
        if hasShelters then
            local shelterAssetId = params:hasEvenLength() and 1 or 2
            collection:addModule(shelterAssetId, theme:get(params:getShelterTheme()))
        end

        if theme:has("destination_display") then
            if params:hasEvenLength() then
                collection:addModule(14, theme:get("destination_display"))
            else
                collection:addModule(11, theme:get("destination_display"))
            end
        end
    end

    if gridY == 1 and hasShelters and params:hasEvenLength() then
        collection:addModule(3, theme:get(params:getShelterTheme()))
    end

    if hasBenches(params, gridY) then
        if gridY > 0 then
            collection:addModule(8, theme:get("billboard_small"))
        else
            collection:addModule(7, theme:get("billboard_small"))
        end
    end

    if hasBenchesIsland(params, gridY) then
        if gridY > 0 then
            collection:addModule(7, theme:get("benches"))
            collection:addModule(15, theme:get("station_name_sign"))
        else
            collection:addModule(8, theme:get("benches"))
            collection:addModule(16, theme:get("station_name_sign"))
        end
    end

    if gridY == -math.floor(params:getLength() / 2) then
        collection:addModule(9, theme:get("bus_station_sign"))
    end

    if gridY == math.ceil(params:getLength() / 2) then
        collection:addModule(14, theme:get("bus_station_sign"))
    end

    return collection
end

local function buildBidirectionalTracksBlueprint(theme, params)
    local startPos = -math.floor(params:getLength() / 2)
    local endPos = math.ceil(params:getLength() / 2)

    local slotType = params:isLeftHandTraffic() and t.TRAM_BIDIRECTIONAL_LEFT or t.TRAM_BIDIRECTIONAL_RIGHT
    local moduleName = theme:get(params:isLeftHandTraffic() and "tram_bidirectional_left" or "tram_bidirectional_right")

    local column = GridModuleColumn:new{}

    column:addBlueprint(startPos - 1, GridModuleBlueprint:new{slotType = slotType, moduleName = moduleName})
    for i = startPos, endPos do
        column:addBlueprint(i, GridModuleBlueprint:new{slotType = slotType, moduleName = moduleName})
    end
    column:addBlueprint(endPos + 1, GridModuleBlueprint:new{slotType = slotType, moduleName = moduleName})

    return column
end

local function buildTrackUp(theme, params)
    local startPos = -math.floor(params:getLength() / 2)
    local endPos = math.ceil(params:getLength() / 2)

    local column = GridModuleColumn:new{}

    column:addBlueprint(startPos - 1, GridModuleBlueprint:new{slotType = t.TRAM_UP, moduleName = theme:get("tram_up")})
    for i = startPos, endPos do
        column:addBlueprint(i, GridModuleBlueprint:new{slotType = t.TRAM_UP, moduleName = theme:get("tram_up")})
    end
    column:addBlueprint(endPos + 1, GridModuleBlueprint:new{slotType = t.TRAM_UP, moduleName = theme:get("tram_up")})

    return column
end

local function buildTrackDown(theme, params)
    local startPos = -math.floor(params:getLength() / 2)
    local endPos = math.ceil(params:getLength() / 2)

    local column = GridModuleColumn:new{}
    column:addBlueprint(startPos - 1, GridModuleBlueprint:new{slotType = t.TRAM_DOWN, moduleName = theme:get("tram_down")})
    for i = startPos, endPos do
        column:addBlueprint(i, GridModuleBlueprint:new{slotType = t.TRAM_DOWN, moduleName = theme:get("tram_down")})
    end
    column:addBlueprint(endPos + 1, GridModuleBlueprint:new{slotType = t.TRAM_DOWN, moduleName = theme:get("tram_down")})

    return column
end

local function buildIslandPlatform(theme, params)
    local startPos = -math.floor(params:getLength() / 2)
    local endPos = math.ceil(params:getLength() / 2)

    local column = GridModuleColumn:new{}
    column:addBlueprint(startPos - 1, GridModuleBlueprint:new{slotType = t.PLATFORM_ISLAND, moduleName = theme:get("platform_island_ramp")})
    for i = startPos, endPos do
        column:addBlueprint(i, GridModuleBlueprint:new{
            slotType = t.PLATFORM_ISLAND,
            moduleName = theme:get("platform_island"),
            assets = buildIslandPlatformAssets(theme, params, i)
        })
    end
    column:addBlueprint(endPos + 1, GridModuleBlueprint:new{slotType = t.PLATFORM_ISLAND, moduleName = theme:get("platform_island_ramp")})

    return column
end

local function buildPlatformLeft(theme, params)
    local startPos = -math.floor(params:getLength() / 2)
    local endPos = math.ceil(params:getLength() / 2)

    local column = GridModuleColumn:new{}
    column:addBlueprint(startPos - 1, GridModuleBlueprint:new{slotType = t.PLATFORM_LEFT, moduleName = theme:get("platform_left_ramp")})
    for i = startPos, endPos do
        column:addBlueprint(i, GridModuleBlueprint:new{
            slotType = t.PLATFORM_LEFT,
            moduleName = theme:get("platform_left"),
            assets = buildSitePlatformAssets(theme, params, i)
        })
    end
    column:addBlueprint(endPos + 1, GridModuleBlueprint:new{slotType = t.PLATFORM_LEFT, moduleName = theme:get("platform_left_ramp")})

    return column
end

local function buildPlatformRight(theme, params)
    local startPos = -math.floor(params:getLength() / 2)
    local endPos = math.ceil(params:getLength() / 2)

    local column = GridModuleColumn:new{}
    column:addBlueprint(startPos - 1, GridModuleBlueprint:new{slotType = t.PLATFORM_RIGHT, moduleName = theme:get("platform_right_ramp")})
    for i = startPos, endPos do
        column:addBlueprint(i, GridModuleBlueprint:new{
            slotType = t.PLATFORM_RIGHT,
            moduleName = theme:get("platform_right"),
            assets = buildSitePlatformAssets(theme, params, i)
        })
    end
    column:addBlueprint(endPos + 1, GridModuleBlueprint:new{slotType = t.PLATFORM_RIGHT, moduleName = theme:get("platform_right_ramp")})

    return column
end

local function placeLeftTracksAndPlatformsRecursive(result, theme, params, tracksLeft, gridX, xPos)
    if tracksLeft <= 0 then
        return
    end

    if tracksLeft == 1 then
        buildPlatformRight(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('platform_right') / 2) , gridX)
        return
    end

    buildIslandPlatform(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('platform_island') / 2) , gridX)

    xPos = xPos + theme:getWidthInCm('platform_island')
    gridX = gridX - 1

    if tracksLeft == 2 then
        if params:isLeftHandTraffic() then
            buildTrackDown(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('tram_down') / 2) , gridX)
        else
            buildTrackUp(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('tram_up') / 2) , gridX)
        end
        return
    end

    local trackWidth = params:isLeftHandTraffic() and theme:getWidthInCm('tram_bidirectional_left') or theme:getWidthInCm('tram_bidirectional_right')
    buildBidirectionalTracksBlueprint(theme, params):place(result, math.floor(xPos + trackWidth / 2) , gridX)

    placeLeftTracksAndPlatformsRecursive(result, theme, params, tracksLeft - 2, gridX - 1, xPos + trackWidth)
end

local function placeRightTracksAndPlatformsRecursive(result, theme, params, tracksLeft, gridX, xPos)
    if tracksLeft <= 0 then
        return
    end

    if tracksLeft == 1 then
        buildPlatformLeft(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('platform_left') / 2) , gridX)
        return
    end

    buildIslandPlatform(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('platform_island') / 2) , gridX)

    xPos = xPos + theme:getWidthInCm('platform_island')
    gridX = gridX + 1

    if tracksLeft == 2 then
        if params:isLeftHandTraffic() then
            buildTrackUp(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('tram_up') / 2) , gridX)
        else
            buildTrackDown(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('tram_down') / 2) , gridX)
        end
        return
    end

    local trackWidth = params:isLeftHandTraffic() and theme:getWidthInCm('tram_bidirectional_left') or theme:getWidthInCm('tram_bidirectional_right')
    buildBidirectionalTracksBlueprint(theme, params):place(result, math.floor(xPos + trackWidth / 2) , gridX)

    placeRightTracksAndPlatformsRecursive(result, theme, params, tracksLeft - 2, gridX + 1, xPos + trackWidth)
end

return function (params)
    params = ParamRespository:new(params)

    local result = {}

    local theme = Theme:new{
        theme = params:getSelectedTheme(),
        defaultTheme = params:getDefaultTheme()
    }

    local trackWidth = params:isLeftHandTraffic() and theme:getWidthInCm('tram_bidirectional_left') or theme:getWidthInCm('tram_bidirectional_right')
    local bidirectionalTrackBlueprint = buildBidirectionalTracksBlueprint(theme, params)
    bidirectionalTrackBlueprint:place(result, 0, 0)
    placeLeftTracksAndPlatformsRecursive(result, theme, params, params:getTracksLeft(), -1, math.floor(trackWidth / 2))
    placeRightTracksAndPlatformsRecursive(result, theme, params, params:getTracksRight(), 1, math.floor(trackWidth / 2))

    return result
end