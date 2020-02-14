local AssetModuleCollection = {}

function AssetModuleCollection:new(o)
    o = o or {}
    o.asset_modules = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local function add_asset_module_recursive(collection, positions, asset_module_name)
    local current_position = table.remove(positions)

    if #positions > 0 then
        if not collection[current_position] then
            collection[current_position] = {}
        end

        add_asset_module_recursive(collection[current_position], positions, asset_module_name)
    end
    
    if not collection[current_position] then
        collection[current_position] = asset_module_name
    end
end

local function has_asset_module_recursive(collection, positions, asset_module_name)
    if #positions > 0 then
        local current_position = table.remove(positions)

        if not collection[current_position] then
            return false
        end

        return has_asset_module_recursive(collection[current_position], positions, asset_module_name)
    end

    return asset_module_name == nil or collection == asset_module_name
end

function AssetModuleCollection:add_asset_module(asset_module, asset_module_name)
    local positions = { asset_module.asset_id, asset_module.grid_y, asset_module.grid_x, asset_module.type }
    add_asset_module_recursive(self.asset_modules, positions, asset_module_name)
end

function AssetModuleCollection:is_placed_on_module(column_module, asset_type, asset_id, asset_module_name)
    local positions = { asset_id, column_module.grid_y, column_module.grid_x, asset_type }
    return has_asset_module_recursive(self.asset_modules, positions, asset_module_name)
end

return AssetModuleCollection