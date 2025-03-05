function MT:PreWarlock(settings)
    settings.warlockCorruption = 0
    settings.warlockAgony = 0
    settings.warlockSeeds = 0
end

function MT:CheckWarlock(settings, unit, inRange)
    if not inRange then
        return
    end

    local aura = C_UnitAuras.GetAuraDataBySpellName(unit, "Corruption","HARMFUL")
    if aura and aura.sourceUnit == "player" then
        settings.warlockCorruption = settings.warlockCorruption + 1
    end

    aura = C_UnitAuras.GetAuraDataBySpellName(unit, "Seed of Corruption","HARMFUL")
    if aura and aura.sourceUnit == "player" then
        settings.warlockSeeds = settings.warlockSeeds + 1
    end

    aura = C_UnitAuras.GetAuraDataBySpellName(unit, "Agony","HARMFUL")
    if aura and aura.sourceUnit == "player" then
        settings.warlockAgony = settings.warlockAgony + 1
    end
    -- local left = aura.expirationTime - GetTime()
    -- if settings.shaFlameShock == 1 then
    --     settings.shaFlameShockFirst = left
    -- elseif left < settings.shaFlameShockFirst then
    --     settings.shaFlameShockFirst = left
    -- end
end