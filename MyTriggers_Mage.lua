function MT:InitMage(settings)
end

function MT:PreMage(settings)
    settings.mageArcaneExplosionCount = 0
end

function MT:CheckMage(settings, unit, inRange)
    settings.mageArcaneExplosionCheck = settings.mageArcaneExplosionCheck or settings.lrc:GetHarmMaxChecker(10)
    if not inRange then
        return
    end

    if settings.mageArcaneExplosionCheck(unit) then
        settings.mageArcaneExplosionCount = settings.mageArcaneExplosionCount + 1
    end
end