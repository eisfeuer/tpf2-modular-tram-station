local Theme = require("modutram.theme.Theme")
local ParamRespository = require("modular_tram_station.utils.ParamRepository")
local SidePlatform = require("modular_tram_station.templates.partials.side_platform")
local Tracks = require("modular_tram_station.templates.partials.tracks")

return function (params)
    local params = ParamRespository:new(params)
    local theme = Theme:new{
        theme = params:getSelectedTheme(),
        defaultTheme = params:getDefaultTheme()
    }

    local result = {}

    local totalWidth = (theme:getWidthInCm('platform_left') + theme:getWidthInCm('tram_up')) * params:getTracks()
    local xPos = -totalWidth / 2
    local gridX = -params:getTracks()

    for _ = 0, params:getTracks() - 1 do
        xPos = xPos + theme:getWidthInCm('tram_up') / 2
        Tracks.buildTrackUp(theme, params):place(result, math.abs(xPos) , gridX)
        
        gridX = gridX + 1
        xPos = xPos + math.floor((theme:getWidthInCm('tram_up') + theme:getWidthInCm('platform_left')) / 2)
        
        SidePlatform.buildPlatformLeft(theme, params):place(result, math.abs(xPos), gridX)
        gridX = gridX + 1
        xPos = xPos + theme:getWidthInCm('platform_left') / 2
    end

    return result
end