local AssetCollection = require("modutram.blueprint.AssetCollection")
local GridModuleBlueprint = require("modutram.blueprint.GridModuleBlueprint")
local t = require("modutram.types")
local GridModuleColumn = require("modutram.blueprint.GridModuleColumn")

local IslandPlatform = {}

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

local function buildIslandPlatformAssets(theme, params, gridY)
    local collection = AssetCollection:new{}
    local hasShelters = params:shelterEnabled() and params:getLength() > 0

    if params:lightingEnabled() and theme:has("lighting") then
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

    if theme:has("billboard_small") and hasBenches(params, gridY) then
        if gridY > 0 then
            collection:addModule(8, theme:get("billboard_small"))
        else
            collection:addModule(7, theme:get("billboard_small"))
        end
    end

    if hasBenchesIsland(params, gridY) then
        if gridY > 0 then
            if (theme:has("benches")) then
                collection:addModule(7, theme:get("benches"))
            end

            if (theme:has("station_name_sign")) then
                collection:addModule(15, theme:get("station_name_sign"))
            end
        else
            if (theme:has("benches")) then
                collection:addModule(8, theme:get("benches"))
            end

            if (theme:has("station_name_sign")) then
                collection:addModule(16, theme:get("station_name_sign"))
            end
        end
    end

    if theme:has("bus_station_sign") and gridY == -math.floor(params:getLength() / 2) then
        collection:addModule(9, theme:get("bus_station_sign"))
    end

    if theme:has("bus_station_sign") and gridY == math.ceil(params:getLength() / 2) then
        collection:addModule(14, theme:get("bus_station_sign"))
    end

    return collection
end

function IslandPlatform:buildIslandPlatform(theme, params)
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

return IslandPlatform