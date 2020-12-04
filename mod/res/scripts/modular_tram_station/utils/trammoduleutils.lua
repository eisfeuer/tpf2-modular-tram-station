local transf = require("transf")

local trammoduleutils = {}

local function addCrossingLane(module, addModelFn)
    addModelFn(
            "station/tram/modular_tram_station/path/passenger_lane.mdl",
            transf.scaleXYZRotZTransl(
                {x = module:getOption("widthInCm", 1) / 100, y = 0, z = 0},
                0,
                {x = -module:getOption("widthInCm", 1) / 200, y = 0, z = 0}
            )
        )
end

local function addCrossingLink(module, addModelFn, side)
    addModelFn(
            "station/tram/modular_tram_station/path/passenger_link.mdl",
            transf.scaleXYZRotZTransl(
                {x = 0, y = 1, z = 0},
                0,
                {x = module:getOption("widthInCm", 1) / 200 * side, y = 0, z = 0})
        )
    addModelFn(
        "station/tram/modular_tram_station/path/passenger_link.mdl",
        transf.scaleXYZRotZTransl(
            {x = 0, y = -1, z = 0},
            0,
            {x = module:getOption("widthInCm", 1) / 200 * side, y = 0, z = 0})
    )
end

function trammoduleutils.addCrossing(module, addModelFn)
    local hasLeftConnection = module:getNeighborLeft():getOption("hasCrossingConnection", false)
    local hasRightConnection = module:getNeighborRight():getOption("hasCrossingConnection", false)

    if hasLeftConnection and hasRightConnection then
        addCrossingLane(module, addModelFn)
        return 
    end

    if hasLeftConnection and not module:hasNeighborRight() then
        addCrossingLane(module, addModelFn)
        addCrossingLink(module, addModelFn, 1)
        return
    end

    if hasRightConnection and not module:hasNeighborLeft() then
        addCrossingLane(module, addModelFn)
        addCrossingLink(module, addModelFn, -1)
    end
end

return trammoduleutils