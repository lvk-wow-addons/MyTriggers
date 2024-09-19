function MT:InitPriest(settings)
end

function MT:PrePriest(settings)
end

function MT:CheckPriest(settings, unit, inRange)
    if not inRange then
        return
    end
end