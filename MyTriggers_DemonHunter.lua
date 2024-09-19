function MT:PreDemonHunter(settings)
    settings.dhSigilOfFlame = 0
    settings.dhSigilOfFlameFirst = 100
end

function MT:CheckDemonHunter(settings, unit, inRange)
    if not inRange then
        return
    end

    local bp = C_UnitAuras.GetAuraDataBySpellName(unit, "Sigil of Flame","HARMFUL")
    if not bp then
        return
    end
    if bp.sourceUnit ~= "player" then
        return
    end

    settings.dhSigilOfFlame = settings.dhSigilOfFlame + 1
    local left = bp.expirationTime - GetTime()
    if settings.dhSigilOfFlameFirst == 1 then
        settings.dhSigilOfFlameFirst = left
    elseif left < settings.dhSigilOfFlameFirst then
        settings.dhSigilOfFlameFirst = left
    end
end