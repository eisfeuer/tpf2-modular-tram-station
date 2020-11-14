local optional = require("modutram.helper.optional")

local ParamRepository = {}

function ParamRepository:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ParamRepository:getSelectedTheme()
    local themes = optional(self.capturedParams).themes

    if not themes then
        return {}
    end

    return themes[(self.modutram_theme or 0) + 1] or {}
end

function ParamRepository:getDefaultTheme()
    return optional(self.capturedParams).defaultTheme or {}
end

function ParamRepository:getTracks()
    return self.modutram_tracks + 1
end

function ParamRepository:getTracksLeft()
    if self.modutram_prefered_side_platform == 0 then
        return math.ceil(self:getTracks() / 2)
    end

    return math.floor(self:getTracks() / 2)
end

function ParamRepository:getTracksRight()
    if self.modutram_prefered_side_platform == 1 then
        return math.ceil(self:getTracks() / 2)
    end

    return math.floor(self:getTracks() / 2)
end

function ParamRepository:isLeftHandTraffic()
    return self.modutram_traffic_direction == 0
end

function ParamRepository:lightingEnabled()
    return self.modutram_lamps == 1
end

function ParamRepository:fenceEnabled()
    return self.modutram_fences == 1
end

function ParamRepository:shelterEnabled()
    return self.modutram_shelter > 0
end

function ParamRepository:getShelterSize()
    return self.modutram_shelter
end

function ParamRepository:getShelterTheme()
    local shelterThemes = {
        "shelter_small",
        "shelter_medium",
        "shelter_large"
    }
    return shelterThemes[self.modutram_shelter]
end

function ParamRepository:getLength()
    return  self.modutram_platform_length
end

function ParamRepository:hasEvenLength()
    return self:getLength() % 2 == 1
end

return ParamRepository