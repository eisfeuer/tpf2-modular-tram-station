local ModuleRepository = require("modutram.ModuleRepository")
local ThemeRepository = require("modutram.theme.ThemeRepository")

local function addTrackModules()
    local tracks = api.res.trackTypeRep.getAll()

    for __, trackName in pairs(tracks) do
        local mod = api.type.ModuleDesc.new()
        local track = api.res.trackTypeRep.get(api.res.trackTypeRep.find(trackName))

        for __, catenary in pairs({false, true}) do
            mod.fileName = "modutram_" .. tostring(trackName) .. (catenary and "catenary" or "")

            mod.availability.yearFrom = track.yearFrom
            mod.availability.yearTo = track.yearTo
            mod.cost.price = math.round(track.cost / 75 * 18000)

            mod.description.name = track.name .. (catenary and _(" with catenary") or "")
            mod.description.description = track.desc .. (catenary and _(" (with catenary)") or "")
            mod.description.icon = track.icon
            if mod.description.icon ~= "" then
                local icons = { 
                    ["standard.lua"] = "ui/tracks/standard.tga",
                    ["high_speed.lua"] = "ui/tracks/high_speed.tga"
                }
                local icon = icons[trackName]

                if icon then
                    mod.description.icon = icon
                else
                    mod.description.icon = string.gsub(mod.description.icon, ".tga", "")
                    mod.description.icon = mod.description.icon .. "_module" .. (catenary and "_catenary" or "") .. ".tga"
                end
            end

            mod.type = "modutram_train_320cm"
            mod.order.value = 0 + 10 * (catenary and 1 or 0)
            mod.metadata = {}
            mod.category.categories = { "Train", }

            mod.updateScript.fileName = "construction/station/tram/modular_tram_station/generic_modules/track.updateFn"
            mod.updateScript.params = {
                trackType = trackName,
                catenary = catenary
            }
            mod.getModelsScript.fileName = "construction/station/tram/modular_tram_station/generic_modules/track.getModelsFn"
            mod.getModelsScript.params = {
                trackType = trackName,
                catenary = catenary
            }

            api.res.moduleRep.add(mod.fileName, mod, true)
        end
    end
end

function data()
    return {
        info = {
            minorVersion = 1,
            severityAdd = "NONE",
            severityRemove = "NONE",
            name = _("Modular Tram Station"),
            description = _("modular_tram_station_desc"),
            tags = { "Tram Station" },
            authors = {
                {
                    name = "EISFEUER",
                    role = 'CREATOR',
                },
            },
        },
        postRunFn = function ()
            addTrackModules()

            local modulesForModularTramStation = {}
            local modulesInGame = api.res.moduleRep.getAll()
            local themeRepository = ThemeRepository:new{defaultTheme = 'era_c', paramName = _("modutram_theme"), tooltip = _("modutram_theme_tooltip")}

            for _, moduleFileName in ipairs(modulesInGame) do
                local module = api.res.moduleRep.get(api.res.moduleRep.find(moduleFileName))
                if ModuleRepository.isModutramItem(module) then
                    local moduleEntry = ModuleRepository.convertModule(module)
                    if moduleEntry.widthInCm then
                        module.metadata.modutram_widthInCm = moduleEntry.widthInCm
                    end
                    table.insert(modulesForModularTramStation, moduleEntry)
                    themeRepository:addModule(moduleFileName, module)
                end
            end

            local modutram = api.res.constructionRep.get(api.res.constructionRep.find('station/tram/modular_tram_station.con'))

            local themeParams = themeRepository:getConstructionParams()

            for i, template in pairs(modutram.constructionTemplates) do
                local dynamicConstructionTemplate = api.type.DynamicConstructionTemplate.new()
                local params = template.data.params
    
                for _, themeParamTemplate in pairs(themeParams) do
                    local themeParam = api.type.ScriptParam.new()

                    themeParam.key = themeParamTemplate.key
                    themeParam.name = themeParamTemplate.name
                    themeParam.tooltip = themeParamTemplate.tooltip
                    themeParam.values = themeParamTemplate.values
                    themeParam.yearFrom = themeParamTemplate.yearFrom
                    themeParam.yearTo = themeParamTemplate.yearTo
                    themeParam.defaultIndex = themeParamTemplate.defaultIndex
                    themeParam.uiType = 0
        
                    params[#params+1] = themeParam 
                end
    
                dynamicConstructionTemplate.params = params
                modutram.constructionTemplates[i].data = dynamicConstructionTemplate 
            end

            modutram.createTemplateScript.fileName = "construction/station/tram/modular_tram_station.createTemplateFn"
            modutram.createTemplateScript.params = {themes = themeRepository:getRepositoryTable(), defaultTheme = themeRepository:getDefaultTheme() }
            modutram.updateScript.fileName = "construction/station/tram/modular_tram_station.updateFn"
            modutram.updateScript.params = {modules = modulesForModularTramStation}
        end
    }
    end
    