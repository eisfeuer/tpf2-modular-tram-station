local AssetIdCollection = {}

function AssetIdCollection:new(o)
    o = o or {}
    o.asset_ids = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function AssetIdCollection:add_asset_module(asset_type, asset_id, asset_module_name)
    if asset_id <= 0 then
        error('asset id MUST be geather than 0')
    end

    if self:has_asset_id(asset_type, asset_id) then
        return
    end

    if self.asset_ids[asset_type] then
        self.asset_ids[asset_type][asset_id] = asset_module_name
    else
        self.asset_ids[asset_type] = { [asset_id] = asset_module_name }
    end
end

function AssetIdCollection:find_asset_module(asset_type, asset_id)
    return self.asset_ids[asset_type] and self.asset_ids[asset_type][asset_id]
end

function AssetIdCollection:has_asset_id(asset_type, asset_id, asset_module_name)
    if asset_module_name then
        return self:find_asset_module(asset_type, asset_id) == asset_module_name
    end
    return self:find_asset_module(asset_type, asset_id) ~= nil
end

function AssetIdCollection:has_asset(asset_module, asset_module_name)
    return self:has_asset_id(asset_module.type, asset_module.asset_id, asset_module_name)
end

return AssetIdCollection