local AssetCollection = require("modutram.blueprint.AssetCollection")
local GridModuleBlueprint = require("modutram.blueprint.GridModuleBlueprint")
local t = require("modutram.types")
local GridModuleColumn = require("modutram.blueprint.GridModuleColumn")

local SidePlatform = {}

local function hasBenches(params, gridY)
    if params:hasEvenLength() then
        return gridY ~= 0 and gridY ~= 1
    end

    return gridY ~= 0
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

function SidePlatform.buildPlatformLeft(theme, params)
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

function SidePlatform.buildPlatformRight(theme, params)
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

return SidePlatform