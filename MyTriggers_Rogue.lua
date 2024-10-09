function MT:PreRogue(settings)
    settings.rogueBlind = 0
    settings.rogueBlindFirst = 100
    settings.rogueCrimsonTempest = 0
    settings.rogueCrimsonTempestFirst = 100
end

function MT:CheckRogue(settings, unit, inRange)
    if not inRange then
        return
    end

    local aura = C_UnitAuras.GetAuraDataBySpellName(unit, "Blind","HARMFUL")
    if aura then
        settings.rogueBlind = settings.rogueBlind + 1
        local left = aura.expirationTime - GetTime()
        if settings.rogueBlind == 1 then
            settings.rogueBlindFirst = left
        elseif left < settings.rogueBlindFirst then
            settings.rogueBlindFirst = left
        end
    end

    aura = C_UnitAuras.GetAuraDataBySpellName(unit, "Crimson Tempest", "HARMFUL")
    if aura then
        settings.rogueCrimsonTempest = settings.rogueCrimsonTempest + 1
        local left = aura.expirationTime - GetTime()
        if settings.rogueCrimsonTempest == 1 then
            settings.rogueCrimsonTempestFirst = left
        elseif left < settings.rogueCrimsonTempestFirst then
            settings.rogueCrimsonTempestFirst = left
        end
    end
end