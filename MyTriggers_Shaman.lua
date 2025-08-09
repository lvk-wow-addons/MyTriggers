function MT:PreShaman(settings)
    settings.shaFlameShock = 0
    settings.shaFlameShockFirst = 100
    settings.shaStaticCharge = 0
end

function MT:CheckShaman(settings, unit, inRange)
    if not inRange then
        return
    end

    local bp = C_UnitAuras.GetAuraDataBySpellName(unit, "Static Charge", "HARMFUL")
    if bp then
        settings.shaStaticCharge = settings.shaStaticCharge + 1
    end

    local bp = C_UnitAuras.GetAuraDataBySpellName(unit, "Flame Shock","HARMFUL")
    if bp and bp.sourceUnit == "player" then
        settings.shaFlameShock = settings.shaFlameShock + 1
        local left = bp.expirationTime - GetTime()
        if settings.shaFlameShock == 1 then
            settings.shaFlameShockFirst = left
        elseif left < settings.shaFlameShockFirst then
            settings.shaFlameShockFirst = left
        end
    end
end

function MT:ShamanCast(spellName)
    if spellName == "Liquid Magma Totem" or spellName == "Capacitor Totem" then
        MT.lastTotem = spellName
    elseif spellName == "Totemic Recall" then
        MT.lastTotem = ""
    end
end