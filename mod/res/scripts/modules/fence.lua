local fence = {}

local function isBetween(startY, endY, subjectY)
    return subjectY >= startY and subjectY <= endY
end

local function isFenceIn(startY, endY, fenceY, fenceWidth)
    return isBetween(startY, endY, fenceY - fenceWidth / 2) or isBetween(startY, endY, fenceY + fenceWidth / 2)
end

local function isOccupied(modutram, gridModule, fenceY, fenceWidth)
    if gridModule:hasAsset(1) then
        local shelterSize = gridModule:getAsset(1):getOption('shelterSize', 0)
        
        if isFenceIn(-shelterSize / 2, shelterSize / 2, fenceY, fenceWidth) then
            return true
        end
    end

    if gridModule:hasAsset(2) then
        local shelterSize = gridModule:getAsset(2):getOption('shelterSize', 0)

        if gridModule.class == "PlatformLeft" then
            if isFenceIn(-modutram.config.gridModuleLength / 2, -(modutram.config.gridModuleLength - shelterSize) / 2,  fenceY, fenceWidth) then
                return true
            end
        else
            if isFenceIn((modutram.config.gridModuleLength - shelterSize) / 2, modutram.config.gridModuleLength / 2, fenceY, fenceWidth) then
                return true
            end
        end
    end

    if gridModule:getNeighborBottom():hasAsset(2) then
        local shelterSize = gridModule:getNeighborBottom():getAsset(2):getOption('shelterSize', 0)

        if gridModule.class == "PlatformLeft" then
            if isFenceIn((modutram.config.gridModuleLength - shelterSize) / 2, modutram.config.gridModuleLength / 2, fenceY, fenceWidth) then
                return true
            end
        else
            if isFenceIn(-modutram.config.gridModuleLength / 2, -(modutram.config.gridModuleLength - shelterSize) / 2,  fenceY, fenceWidth) then
                return true
            end
        end
    end

    return false
end

local function isSplashGuard(modutram, gridModule, yPos, splashGuardModel, fenceSplashGuardRatio)
    if not splashGuardModel then
        return false
    end

    if gridModule.class == 'PlatformLeft' then
        yPos = yPos * -1
    end

    local column = gridModule:getColumn()
    local centerGridY = (column.topGridY + column.bottomGridY) / 2
    local centerY = centerGridY * modutram.config.gridModuleLength

    local fenceTopGridY = column.topGridY
    local fenceBottomGridY = column.bottomGridY

    while fenceTopGridY > centerGridY and not modutram.grid:get(gridModule:getGridX(), fenceTopGridY):getOption('isRegularPlatform', true) do
        fenceTopGridY = fenceTopGridY - 1
    end

    while fenceBottomGridY < centerGridY and not modutram.grid:get(gridModule:getGridX(), fenceBottomGridY):getOption('isRegularPlatform', true) do
        fenceBottomGridY = fenceBottomGridY + 1
    end

    local halfGridLength = fenceTopGridY - fenceBottomGridY + 1
    local halfTotalLength = halfGridLength / 2 * modutram.config.gridModuleLength
    local absoluteYPos = gridModule:getAbsoluteY() + yPos
    
    if absoluteYPos < centerY - halfTotalLength * fenceSplashGuardRatio then
        return false
    end

    return absoluteYPos <= centerY + halfTotalLength * fenceSplashGuardRatio
end

function fence.build(modutram, module, addModelFn, fenceWidth, fenceModel, splashGuardModel, fenceSplashGuardRatio)
    local fenceSegments = math.floor(modutram.config.gridModuleLength / fenceWidth)
    local start = (-modutram.config.gridModuleLength + fenceWidth) / 2
    local gridModule = module:getParentGridModule()

    for i = 0, fenceSegments - 1 do
        local fenceY = start + i * fenceWidth
        if not isOccupied(modutram, gridModule, fenceY, fenceWidth) then
            addModelFn(
                isSplashGuard(modutram, gridModule, fenceY, splashGuardModel, fenceSplashGuardRatio or 0.7) and splashGuardModel or fenceModel,
                {
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    0, fenceY, -1, 1
                }
            )
        end
    end
end

return fence