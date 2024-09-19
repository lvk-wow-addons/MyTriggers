function MT:PrePaladin(settings)
    settings.palJudgment = 0
end

function MT:CheckPaladin(settings, unit, inRange)
    if not inRange then
        return
    end

    local aura = C_UnitAuras.GetAuraDataBySpellName(unit, "Judgment","HARMFUL")
    if not aura then
        return
    end
    if aura.sourceUnit ~= "player" then
        return
    end

    settings.palJudgment = settings.palJudgment + 1
end