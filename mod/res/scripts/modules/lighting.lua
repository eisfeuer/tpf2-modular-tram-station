local lighting = {}

local function hasShelterVeryLargeMiddleShelter(assetId, gridModule, gridModuleLength)
    if not gridModule:hasAsset(assetId) then
        return false
    end

    return gridModule:getAsset(assetId):getOption('ShelterSize', 0) > gridModuleLength - 0.1
end

local function isTopLampOccupied(gridModule, gridModuleLength)
    if gridModule:hasAsset(2) or gridModule:hasAsset(4) then
        return true
    end

    for _, assetId in pairs({1, 3}) do
        if hasShelterVeryLargeMiddleShelter(assetId, gridModule, gridModuleLength) then
            return true
        end

        if hasShelterVeryLargeMiddleShelter(assetId, gridModule:getNeighborTop(), gridModuleLength) then
            return true
        end
    end
    
    return false
end

local function isMidLampOccupied(gridModule, gridModuleLength)
    if gridModule:hasAsset(1) or gridModule:hasAsset(3) then
        return true
    end

    for _, assetId in pairs({1, 3}) do
        if hasShelterVeryLargeMiddleShelter(assetId, gridModule, gridModuleLength) then
            return true
        end

        if hasShelterVeryLargeMiddleShelter(assetId, gridModule:getNeighborBottom(), gridModuleLength) then
            return true
        end
    end
    
    return false
end

local function isBottomLampEnabled(gridModule, gridModuleLength)
    if not gridModule:hasNeighborBottom() then
        return not hasShelterVeryLargeMiddleShelter(1, gridModule, gridModuleLength)
            or hasShelterVeryLargeMiddleShelter(3, gridModule, gridModuleLength)
    end

    if not gridModule:getNeighborBottom():getOption("isRegularPlatform", true) then
        return not hasShelterVeryLargeMiddleShelter(1, gridModule, gridModuleLength)
            or hasShelterVeryLargeMiddleShelter(3, gridModule, gridModuleLength)
    end

    if gridModule:getNeighborBottom():hasAsset(5) then
        return false
    end

    return not hasShelterVeryLargeMiddleShelter(1, gridModule, gridModuleLength)
        or hasShelterVeryLargeMiddleShelter(3, gridModule, gridModuleLength)
end

local function getLampModule(gridModule, lampModel, islandPlatformLampModel)
    if not islandPlatformLampModel then
        return lampModel
    end

    return gridModule.class == "PlatformIsland" and islandPlatformLampModel or lampModel
end

function lighting.build(gridModule, gridModuleLength, addModelFn, lampModel, islandPlatformLampModel)
    local flipFactor = gridModule.class == 'PlatformLeft' and -1 or 1

    if not isTopLampOccupied(gridModule, gridModuleLength) then
        addModelFn(
           getLampModule(gridModule, lampModel, islandPlatformLampModel),
            {
                0, 1, 0, 0,
                -1, 0, 0, 0,
                0, 0, 1, 0,
                0, gridModuleLength / 2 * flipFactor, -3, 1
            }
        )
    end

    if not isMidLampOccupied(gridModule, gridModuleLength) then
        addModelFn(
           getLampModule(gridModule, lampModel, islandPlatformLampModel),
            {
                0, 1, 0, 0,
                -1, 0, 0, 0,
                0, 0, 1, 0,
                0, 0, -3, 1
            }
        )
    end

    if isBottomLampEnabled(gridModule, gridModuleLength) then
        addModelFn(
           getLampModule(gridModule, lampModel, islandPlatformLampModel),
            {
                0, 1, 0, 0,
                -1, 0, 0, 0,
                0, 0, 1, 0,
                0, -gridModuleLength / 2 * flipFactor, -3, 1
            }
        )
    end
end

return lighting