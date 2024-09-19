function MT:PreDeathKnight(settings)
    settings.dkBloodPlagueCount = 0
    settings.dkBloodPlagueFirst = 0
end

function MT:CheckDeathKnight(settings, unit, inRange)
    if not inRange then
        return
    end

    local bp = C_UnitAuras.GetAuraDataBySpellName(unit, "Blood Plague","HARMFUL")
    if not bp then
        return
    end
    if bp.sourceUnit ~= "player" then
        return
    end

    settings.dkBloodPlagueCount = settings.dkBloodPlagueCount + 1
    local left = bp.expirationTime - GetTime()
    if settings.dkBloodPlagueCount == 1 then
        settings.dkBloodPlagueFirst = left
    elseif left < settings.dkBloodPlagueFirst then
        settings.dkBloodPlagueFirst = left
    end
end