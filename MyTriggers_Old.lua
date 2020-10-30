function MyTriggers_DefaultSettings()
    return MT:Settings()
end

function MyTriggers_GetLastSpell()
    return MT:GetLastSpell()
end

function MyTriggers_SetLastSpell(spell)
    MT:SetLastSpell(spell)
end

function MyTriggers_IsAoeSelected()
    return MT:IsAoeSelected()
end

function MyTriggers_IsSingleSelected()
    return MT:IsSingleSelected()
end

function MyTriggers_IsAutoSelection()
    return MT:IsAutoSelection()
end

function MyTriggers_SetSelection(mode)
    MT:SetSelection(mode)
end

function MyTriggers_ToggleSelection()
    MT:ToggleSelection()
end

function MyTriggers_ShowMode()
    MT:ShowMode()
end

function MyTriggers_GetInRangeOfAoeSpell()
    MT:GetInRangeOfAoeSpell()
end

function MyTriggers_Check(settings)
    return settings.Check()
end

function MyTriggers_Test()
    MT:Test()
end


function MyTriggers_GetDreadstalkerCount()
    return MT:GetDreadstalkerCount()
end

function MyTriggers_GetImpCount()
    return MT:GetImpCount()
end
