local transf = require("transf")
local destinationDisplay = {}

function destinationDisplay.build(assetModule, addModelFn, model, islandPlatformModel)
    local isIslandPlatform = assetModule:getParentGridModule().class == 'PlatformIsland'

    if isIslandPlatform and islandPlatformModel == true then
        addModelFn(model, transf.transl({x = 0.5, y = 0, z = -2}))
        addModelFn(model, transf.rotZTransl(math.pi, {x = -0.5, y = 0, z = -2}))
        return
    end

    if isIslandPlatform then
        addModelFn(islandPlatformModel, transf.transl{x = 0, y = 0, z = -2})
    else
        addModelFn(model, transf.transl{x = 0, y = 0, z = -2})
    end
end

return destinationDisplay