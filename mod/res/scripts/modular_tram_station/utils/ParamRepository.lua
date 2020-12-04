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

function ParamRepository:hasTramTracks()
    return self.modutram_base_vehicle > 0
end

function ParamRepository:isElectrified()
    return self.modutram_base_vehicle == 2
end

function ParamRepository:getTracks()
    return self.modutram_base_tracks + 1
end

function ParamRepository:getTracksLeft()
    return math.floor(self:getTracks() / 2)
end

function ParamRepository:getTracksRight()
    return math.ceil(self:getTracks() / 2)
end

function ParamRepository:isLeftHandTraffic()
    return false
end

function ParamRepository:lightingEnabled()
    return true
end

function ParamRepository:fenceEnabled()
    return true
end

function ParamRepository:shelterEnabled()
    return self.modutram_base_shelter > 0
end

function ParamRepository:hasPlatformAtCenter()
    return self.modutram_base_center_module == 1
end

function ParamRepository:getShelterSize()
    return self.modutram_base_shelter
end

function ParamRepository:getShelterTheme()
    local shelterThemes = {
        "shelter_small",
        "shelter_medium",
        "shelter_large"
    }
    return shelterThemes[self.modutram_base_shelter]
end

function ParamRepository:getLength()
    return self.modutram_base_platform_length
end

function ParamRepository:hasEvenLength()
    return self:getLength() % 2 == 1
end

function ParamRepository:hasEnabledStreetConnections()
    return self.modutram_base_street_connections > 0
end

return ParamRepository