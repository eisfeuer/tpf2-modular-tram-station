local AssetIdCollection = {}

function AssetIdCollection:new(o)
    o = o or {}
    o.asset_ids = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function AssetIdCollection:add_asset_id(asset_type, asset_id)
    if asset_id <= 0 then
        error('asset id MUST be geather than 0')
    end

    if self:has_asset_id(asset_type, asset_id) then
        return
    end

    if not self.asset_ids[asset_type] then
        self.asset_ids[asset_type] = { asset_id }
    else
        table.insert(self.asset_ids[asset_type], asset_id)
    end
end

function AssetIdCollection:has_asset_id(asset_type, asset_id)
    if not self.asset_ids[asset_type] then
        return false
    end

    for i, current_asset_id in ipairs(self.asset_ids[asset_type]) do
        if current_asset_id == asset_id then
            return true
        end
    end

    return false
end

function AssetIdCollection:has_asset(asset_module)
    return self:has_asset_id(asset_module.type, asset_module.asset_id)
end

return AssetIdCollection