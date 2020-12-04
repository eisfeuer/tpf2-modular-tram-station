local Theme = require("modutram.theme.Theme")
local ParamRespository = require("modular_tram_station.utils.ParamRepository")

local IslandPlatform = require("modular_tram_station.templates.partials.island_platform")
local SidePlatform = require("modular_tram_station.templates.partials.side_platform")
local Tracks = require("modular_tram_station.templates.partials.tracks")

local function placeLeftTracksAndPlatformsRecursive(result, theme, params, tracksLeft, gridX, xPos)
    if tracksLeft == 0 then
        return
    end

    xPos = xPos + theme:getWidthInCm('platform_right') / 2
    SidePlatform.buildPlatformRight(theme, params):place(result, math.floor(xPos) , gridX)

    if tracksLeft > 1 then
        gridX = gridX - 1
        xPos = xPos + math.floor((theme:getWidthInCm('platform_right') + theme:getWidthInCm('tram_down')) / 2)
        Tracks.buildTrackDown(theme, params):place(result, xPos , gridX)
        placeLeftTracksAndPlatformsRecursive(result, theme, params, tracksLeft - 1, gridX - 1, xPos + math.floor(theme:getWidthInCm('tram_down') / 2))
    end
end

local function placeRightTracksAndPlatformsRecursive(result, theme, params, tracksLeft, gridX, xPos)
    if tracksLeft == 0 then
        return
    end

    xPos = xPos + theme:getWidthInCm('platform_left') / 2
    SidePlatform.buildPlatformLeft(theme, params):place(result, math.floor(xPos) , gridX)

    if tracksLeft > 1 then
        gridX = gridX + 1
        xPos = xPos + math.floor((theme:getWidthInCm('platform_left') + theme:getWidthInCm('tram_up')) / 2)
        Tracks.buildTrackUp(theme, params):place(result, xPos , gridX)
        placeRightTracksAndPlatformsRecursive(result, theme, params, tracksLeft - 1, gridX + 1, xPos + math.floor(theme:getWidthInCm('tram_up') / 2))
    end
end

local function placeReversedLeftTracksAndPlatformsRecursive(result, theme, params, tracksLeft, gridX, xPos)
    xPos = xPos + theme:getWidthInCm('tram_up') / 2
    Tracks.buildTrackUp(theme, params):place(result, xPos , gridX)

    if tracksLeft <= 1 then
        return
    end

    gridX = gridX - 1
    xPos = xPos + math.floor((theme:getWidthInCm('platform_left') + theme:getWidthInCm('tram_up')) / 2)

    SidePlatform.buildPlatformLeft(theme, params):place(result, math.floor(xPos) , gridX)

    placeReversedLeftTracksAndPlatformsRecursive(result, theme, params, tracksLeft - 1, gridX - 1, xPos + math.floor(theme:getWidthInCm('platform_left') / 2))
end

local function placeReversedRightTracksAndPlatformsRecursive(result, theme, params, tracksLeft, gridX, xPos)
    xPos = xPos + theme:getWidthInCm('tram_down') / 2
    Tracks.buildTrackDown(theme, params):place(result, xPos , gridX)

    if tracksLeft <= 1 then
        return
    end

    gridX = gridX + 1
    xPos = xPos + math.floor((theme:getWidthInCm('platform_right') + theme:getWidthInCm('tram_down')) / 2)

    SidePlatform.buildPlatformRight(theme, params):place(result, math.floor(xPos) , gridX)

    placeReversedRightTracksAndPlatformsRecursive(result, theme, params, tracksLeft - 1, gridX + 1, xPos + math.floor(theme:getWidthInCm('platform_right') / 2))
end

return function (params)
    local params = ParamRespository:new(params)
    local theme = Theme:new{
        theme = params:getSelectedTheme(),
        defaultTheme = params:getDefaultTheme()
    }

    local result = {}

    
    if params:hasPlatformAtCenter() then
        local platformWidth = theme:getWidthInCm('platform_island')
        IslandPlatform:buildIslandPlatform(theme, params):place(result, 0, 0)

        placeReversedLeftTracksAndPlatformsRecursive(result, theme, params, params:getTracksLeft(), -1, math.floor(platformWidth / 2))
        placeReversedRightTracksAndPlatformsRecursive(result, theme, params, params:getTracksRight(), 1, math.floor(platformWidth / 2))
        return result
    end

    local trackWidth = theme:getWidthInCm('tram_bidirectional_right')
    Tracks.buildBidirectionalTracksBlueprint(theme, params):place(result, 0, 0)
    placeLeftTracksAndPlatformsRecursive(result, theme, params, params:getTracksLeft(), -1, math.floor(trackWidth / 2))
    placeRightTracksAndPlatformsRecursive(result, theme, params, params:getTracksRight(), 1, math.floor(trackWidth / 2))

    return result
end