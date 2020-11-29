local Theme = require("modutram.theme.Theme")
local ParamRespository = require("utils.ParamRepository")

local IslandPlatform = require("templates.partials.island_platform")
local SidePlatform = require("templates.partials.side_platform")
local Tracks = require("templates.partials.tracks")

local function placeLeftTracksAndPlatformsRecursive(result, theme, params, tracksLeft, gridX, xPos)
    if tracksLeft <= 0 then
        return
    end

    if tracksLeft == 1 then
        SidePlatform.buildPlatformRight(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('platform_right') / 2) , gridX)
        return
    end

    IslandPlatform:buildIslandPlatform(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('platform_island') / 2) , gridX)

    xPos = xPos + theme:getWidthInCm('platform_island')
    gridX = gridX - 1

    if tracksLeft == 2 then
        if params:isLeftHandTraffic() then
            Tracks.buildTrackDown(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('tram_down') / 2) , gridX)
        else
            Tracks.buildTrackUp(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('tram_up') / 2) , gridX)
        end
        return
    end

    local trackWidth = params:isLeftHandTraffic() and theme:getWidthInCm('tram_bidirectional_left') or theme:getWidthInCm('tram_bidirectional_right')
    Tracks.buildBidirectionalTracksBlueprint(theme, params):place(result, math.floor(xPos + trackWidth / 2) , gridX)

    placeLeftTracksAndPlatformsRecursive(result, theme, params, tracksLeft - 2, gridX - 1, xPos + trackWidth)
end

local function placeRightTracksAndPlatformsRecursive(result, theme, params, tracksLeft, gridX, xPos)
    if tracksLeft <= 0 then
        return
    end

    if tracksLeft == 1 then
        SidePlatform.buildPlatformLeft(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('platform_left') / 2) , gridX)
        return
    end

    IslandPlatform:buildIslandPlatform(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('platform_island') / 2) , gridX)

    xPos = xPos + theme:getWidthInCm('platform_island')
    gridX = gridX + 1

    if tracksLeft == 2 then
        if params:isLeftHandTraffic() then
            Tracks.buildTrackUp(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('tram_up') / 2) , gridX)
        else
            Tracks.buildTrackDown(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('tram_down') / 2) , gridX)
        end
        return
    end

    local trackWidth = params:isLeftHandTraffic() and theme:getWidthInCm('tram_bidirectional_left') or theme:getWidthInCm('tram_bidirectional_right')
    Tracks.buildBidirectionalTracksBlueprint(theme, params):place(result, math.floor(xPos + trackWidth / 2) , gridX)

    placeRightTracksAndPlatformsRecursive(result, theme, params, tracksLeft - 2, gridX + 1, xPos + trackWidth)
end

local function placeReverseLeftTracksAndPlatformsRecursive(result, theme, params, tracksLeft, gridX, xPos)
    if tracksLeft <= 1 then
        Tracks.buildTrackUp(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('tram_up') / 2) , gridX)
        return
    end

    Tracks.buildBidirectionalTracksBlueprint(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('tram_bidirectional_right') / 2) , gridX)

    xPos = xPos + theme:getWidthInCm('tram_bidirectional_right')
    gridX = gridX - 1

    if tracksLeft == 2 then
        SidePlatform.buildPlatformRight(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('platform_right') / 2) , gridX)
        return
    end

    local platformWidth = theme:getWidthInCm('platform_island')
    IslandPlatform:buildIslandPlatform(theme, params):place(result, xPos + platformWidth / 2, gridX)

    placeReverseLeftTracksAndPlatformsRecursive(result, theme, params, tracksLeft - 2, gridX - 1, xPos + platformWidth)
end

local function placeReverseRightTracksAndPlatformsRecursive(result, theme, params, tracksLeft, gridX, xPos)
    if tracksLeft <= 1 then
        Tracks.buildTrackDown(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('tram_down') / 2) , gridX)
        return
    end

    Tracks.buildBidirectionalTracksBlueprint(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('tram_bidirectional_right') / 2) , gridX)

    xPos = xPos + theme:getWidthInCm('tram_bidirectional_right')
    gridX = gridX + 1

    if tracksLeft == 2 then
        SidePlatform.buildPlatformLeft(theme, params):place(result, math.floor(xPos + theme:getWidthInCm('platform_left') / 2) , gridX)
        return
    end

    local platformWidth = theme:getWidthInCm('platform_island')
    IslandPlatform:buildIslandPlatform(theme, params):place(result, xPos + platformWidth / 2, gridX)

    placeReverseRightTracksAndPlatformsRecursive(result, theme, params, tracksLeft - 2, gridX + 1, xPos + platformWidth)
end

return function (params)
    params = ParamRespository:new(params)

    local result = {}

    local theme = Theme:new{
        theme = params:getSelectedTheme(),
        defaultTheme = params:getDefaultTheme()
    }

    

    if params:hasPlatformAtCenter() then
        local platformWidth = theme:getWidthInCm('platform_island')
        IslandPlatform:buildIslandPlatform(theme, params):place(result, 0, 0)

        placeReverseLeftTracksAndPlatformsRecursive(result, theme, params, params:getTracksLeft(), -1,  math.floor(platformWidth / 2))
        placeReverseRightTracksAndPlatformsRecursive(result, theme, params, params:getTracksRight(), 1,  math.floor(platformWidth / 2))

        return result
    end

    local trackWidth = params:isLeftHandTraffic() and theme:getWidthInCm('tram_bidirectional_left') or theme:getWidthInCm('tram_bidirectional_right')
    local bidirectionalTrackBlueprint = Tracks.buildBidirectionalTracksBlueprint(theme, params)
    bidirectionalTrackBlueprint:place(result, 0, 0)
    placeLeftTracksAndPlatformsRecursive(result, theme, params, params:getTracksLeft(), -1, math.floor(trackWidth / 2))
    placeRightTracksAndPlatformsRecursive(result, theme, params, params:getTracksRight(), 1, math.floor(trackWidth / 2))

    return result
end