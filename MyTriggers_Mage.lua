function MT:InitMage(settings)
    settings.mageArcaneExplosionCheck = settings.lrc:GetHarmMaxChecker(10)
end

function MT:PreMage(settings)
    settings.mageArcaneExplosionCount = 0
end

function MT:CheckMage(settings, unit, inRange)
    if not inRange then
        return
    end

    if settings.mageArcaneExplosionCheck(unit) then
        settings.mageArcaneExplosionCount = settings.mageArcaneExplosionCount + 1
    end
end