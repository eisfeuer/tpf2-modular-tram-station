local transf = require("transf")

local bench = {}

local function build(benchAsset, addModelFn, model, transform, xOffset)
    local matrix = transf.transl({x = 0, y = xOffset, z = -1})

    if transform then
        matrix = transf.mul(matrix, transform)
    end

    if benchAsset:getParentGridModule().class == "PlatformIsland" then
        addModelFn(model, transf.mul(transf.rotZTransl(math.pi, {x = -0.3, y = 0, z = 0}), matrix))
        addModelFn(model, transf.mul(transf.transl({x = 0.3, y = 0, z = 0}), matrix))
    else
        addModelFn(model, matrix)
    end
end

function bench.buildSingle(benchAsset, addModelFn, model, transform)
    build(benchAsset, addModelFn, model, transform, 0)
end

function bench.buildDouble(benchAsset, addModelFn, model, transform)
    build(benchAsset, addModelFn, model, transform, -1.5)
    build(benchAsset, addModelFn, model, transform, 1.5)
end

return bench