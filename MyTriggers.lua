MT = { };
MT.__weakAuraVisible = {};
MT.__lastSpell = ""
MT.__priMode = 2
MT.__Last3Spells = {};
MT.__cachedSettings = {};

MT.__classChecks = {
    ["Death Knight/pre"] = function (settings) MT:PreDeathKnight(settings) end,
    ["Death Knight"] = function (settings, unit, inRange) MT:CheckDeathKnight(settings, unit, inRange) end
};

MT.__ignoredIds = {
    target = true,
    boss1 = true,
    boss2 = true,
    boss3 = true,
    boss4 = true,
    boss5 = true,
    boss6 = true,
    boss7 = true,
    boss8 = true,
    nameplate1 = true,
    nameplate2 = true,
    nameplate3 = true,
    nameplate4 = true,
    nameplate5 = true,
    nameplate6 = true,
    nameplate7 = true,
    nameplate8 = true,
    nameplate9 = true,
    nameplate10 = true,
    nameplate11 = true,
    nameplate12 = true,
    nameplate13 = true,
    nameplate14 = true,
    nameplate15 = true,
    nameplate16 = true,
    nameplate17 = true,
    nameplate18 = true,
    nameplate19 = true,
    nameplate20 = true,
};
MT.__ignoredIds["deathknight/blood/eat"] = true

function MT:DefaultSettings()
    local settings = { }
    
    MT:InitializeSettings(settings)

    settings.Check = function()
        settings.bossHealth = UnitHealthMax("player") * 2
        if not settings.inRangeOfAoeSpell then
            settings.inRangeOfAoeSpell = MT:GetInRangeOfAoeSpell()
        end

        MT:CheckPriorityTarget(settings)
        MT:CountForAoe(settings)
        MT:CheckSelection(settings)

        settings.isAoePriority = settings.aoeSelected or settings.isPriority or settings.isAoeReached
        settings.isSingleTargetPriority = (settings.isPriority and not settings.isAoeReached)
    
        return settings
    end

    return settings
end

function MT:ApplyDefaults(settings)
    settings.refreshRate = 0.1
    settings.bossHealth = UnitHealthMax("player") * 2
    settings.inRangeOfAoeSpell = MT:GetInRangeOfAoeSpell()
    settings.aoeEnemyThreshold = 5
    settings.priElite = true
    settings.priWorldBoss = true
end

function MT:InitializeSettings(settings)
    settings.nextRefresh = GetTime()
    settings.isPriority = false
    settings.isAoePriority = false
    settings.isSingleTargetPriority = false
    settings.isAoeReached = false
    settings.classCheck = MT.__classChecks[UnitClass("player")]
    settings.classPreCheck = MT.__classChecks[UnitClass("player") .. "/pre"]
    settings.classPostCheck = MT.__classChecks[UnitClass("player") .. "/post"]

    if settings.classPreCheck then
        settings.classPreCheck(settings)
    end

    settings.enemyCount = 0

    MT:ApplyDefaults(settings)
end

function MT:Settings(name, initialize)
    if not name then
        return MT:DefaultSettings()
    end

    local settings = MT.__cachedSettings[name]
    if not settings then
        settings = MT:DefaultSettings()
        if initialize then
            initialize(settings)
        end
        MT.__cachedSettings[name] = settings
    end
    return settings
end

function MT:WA(id, evaluator)
    if evaluator then
        local isVisible = evaluator()
        -- LVK:Debug("WA[" .. id .. "] = " .. (isVisible and "true" or "false"))
        
        if MT.__weakAuraVisible[id] ~= isVisible then
            MT.__weakAuraVisible[id] = isVisible
            WeakAuras.ScanEvents("MT_WEAKAURA_VISIBILITY", id, isVisible)
        end
        return isVisible
    end

    return MT.__weakAuraVisible[id] or false
end

function MT:UnitIsBoss(unitId)
    if (unitId == "boss1") or UnitIsUnit(unitId, "boss1") or false then return true end
    if (unitId == "boss2") or UnitIsUnit(unitId, "boss2") or false then return true end
    if (unitId == "boss3") or UnitIsUnit(unitId, "boss3") or false then return true end
    if (unitId == "boss4") or UnitIsUnit(unitId, "boss4") or false then return true end
    if (unitId == "boss5") or UnitIsUnit(unitId, "boss5") or false then return true end
    if (unitId == "boss6") or UnitIsUnit(unitId, "boss6") or false then return true end
    if (unitId == "boss7") or UnitIsUnit(unitId, "boss7") or false then return true end
    if (unitId == "boss8") or UnitIsUnit(unitId, "boss8") or false then return true end
    return false
end

function MT:LastSpell(spell)
    if spell then
        if MT.__lastSpell ~= spell then
            MT.__lastSpell = spell
            WeakAuras.ScanEvents("MT_LASTSPELL", spell)
        end

        table.insert(MT.__Last3Spells, spellName);
        if MT.__Last3Spells[4] then
            table.remove(MT.__Last3Spells, 1);
        end
    else
        return MT.__lastSpell
    end
end

function MT:IsAoeSelected()
    return MT.__priMode == 1
end

function MT:IsSingleSelected()
    return MT.__priMode == 0
end

function MT:IsAutoSelection()
    return MT.__priMode == 2
end

function MT:SetSelection(mode)
    MT.__priMode = mode
    MyTriggers_ShowMode()
end

function MT:ToggleSelection()
    if MT.__priMode < 2 then
        MT.__priMode = MT.__priMode + 1
    else
        MT.__priMode = 0
    end
    MyTriggers_ShowMode()
end

function MT:ShowMode()
    if MT.__priMode == 0 then
        UIErrorsFrame:AddMessage("Single target mode selected", 1, 0, 0, 5)
    elseif MT.__priMode == 1 then
        UIErrorsFrame:AddMessage("AOE mode selected", 1, 0, 0, 5)
    else
        UIErrorsFrame:AddMessage("Automatic single target / aoe mode selected", 1, 0, 0, 5)
    end
end

function MT:GetInRangeOfAoeSpell()
    local classDisplayName, class, classID = UnitClass("player");
    local spec = GetSpecialization()

    local key = tostring(classID) .. "/" .. tostring(spec)
    return MyTriggers_InRangeOfAoeSpells[key]
end

function MT:CheckSelection(settings)
    if priMode == 0 then
        settings.aoeSelected = false
    elseif priMode == 1 then
        settings.aoeSelected = true
    else
        settings.aoeSelected = settings.isAoeReached
    end
end

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

function MT:CountForAoe(settings)
    settings.isCondemnedDemonInRange = false
    if settings.aoeEnemyThreshold < 0 then
        settings.enemyCount = -1
        settings.isAoeReached = false
        return
    end

    local now = GetTime()
    if now < settings.nextRefresh then
        return
    end

    settings.nextRefresh = now + settings.refreshRate
    local counter = 0

    if settings.classPreCheck then
        settings.classPreCheck(settings)
    end

    for i = 1, 40 do
        local unit = "nameplate" .. i
        if UnitExists(unit) and not UnitIsFriend("player", unit) then
            local inRange = true
            if settings.inRangeOfAoeSpell ~= "" then
                inRange = C_Spell.IsSpellInRange(settings.inRangeOfAoeSpell, unit)
                if inRange then
                    if inRange and C_UnitAuras.GetAuraDataBySpellName(unit, "Unstoppable Conflict", "HARMFUL") then
                        settings.isCondemnedDemonInRange = true
                    end
                end
            end

            if settings.classCheck then
                settings.classCheck(settings, unit, inRange)
            end

            if inRange then
                counter = counter + 1
            end
        end
    end

    if settings.classPostCheck then
        settings.classPostCheck(settings)
    end
    
    -- LVK:Print("enemy count in range: " .. tostring(counter) .. ", bp: " .. tostring(settings.dkBloodPlagueCount))
    settings.enemyCount = counter
    settings.isAoeReached = counter >= settings.aoeEnemyThreshold
end

function MT:CheckPriorityTarget(settings)
    local isBoss = false

    if UnitExists("target") and not UnitIsFriend("player", "target") and UnitHealth("target") > 0 then
        local c = UnitClassification("target")
        if c == "worldboss" then
            LVK:Debug("classification: world boss")
            isBoss = settings.priWorldBoss
        elseif c == "elite" or c == "rareelite" then
            LVK:Debug("classification: elite")
            isBoss = settings.priElite
        else
            local health = UnitHealthMax("target")
            if health >= settings.bossHealth then
                LVK:Debug("priority due to health: " .. tostring(health) .. " [" .. tostring(settings.bossHealth) .. "]")
                isBoss = true
            else
                LVK:Debug("not priority, classification: " .. c .. ", health: " .. tostring(health))
            end
        end
    end

    settings.isPriority = isBoss
end

function MT:Test()
    local a = { }
    a.preCheck = function(settings) MT:PreDeathKnight(settings) end
    LVK:Print("1");
    local settings = MT:DefaultSettings()
    LVK:Print("2");
    a.preCheck(settings)
    LVK:Print("3");
    LVK:Dump(settings)
    settings.Check()
end

function MT:ShadowWordDeath(aura_env)
    if (not aura_env.damage) or (UnitLevel("player") > aura_env.damage_level) then
        local spellId = select(7, C_Spell.GetSpellInfo("Shadow Word: Death"))
        local description = C_Spell.GetSpellDescription(spellId)
        local match = string.match(description, "inflicts (%d+) Shadow damage", 1)
        
        aura_env.damage_level = UnitLevel("player")
        aura_env.damage = tonumber(match)
        -- LVK:Print("Shadow Word: Death, recalculated to deal " .. tostring(aura_env.damage) .. " damage")
    end
    
    local max = UnitHealthMax("target")
    if max == 0 then
        return false
    end
    local current = UnitHealth("target")
    
    local damage = aura_env.damage
    
    local threshold = max * 0.2
    if current <= threshold then
        damage = damage * 2.5
    end
    
    return damage >= current;
end

-- https://wago.io/r1wDoVIw-
if UnitClass("player") == "Warlock" then
    local frame = CreateFrame("FRAME", "MyTriggersAddonFrame");
    frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
    local MyTriggers_Warlock = {
        pguid = UnitGUID("player"),
        dreadstalkerCount = 0,
        dreadstalkerTime = {},
    
        impCount = 0,
        impTime = {}
    }
    
    local function eventHandler(self, e, ...)
        if e == "COMBAT_LOG_EVENT_UNFILTERED" then
            local now = GetTime()
            local timestamp, subEvent, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...
    
            if subEvent == "UNIT_DIED" then
                for index, value in pairs(MyTriggers_Warlock.dreadstalkerTime) do
                    if destGUID == index then
                        MyTriggers_Warlock.dreadstalkerTime[index] = nil
                        MyTriggers_Warlock.dreadstalkerCount = MyTriggers_Warlock.dreadstalkerCount - 1
                    end
                end
                for index, value in pairs(MyTriggers_Warlock.impTime) do
                    if destGUID == index then
                        MyTriggers_Warlock.impTime[index] = nil
                        MyTriggers_Warlock.impCount = MyTriggers_Warlock.impCount - 1
                    end
                end
            elseif subEvent == "SPELL_SUMMON" and sourceGUID == MyTriggers_Warlock.pguid then
                if spellID == 193331 or spellID == 193332 then
                    MyTriggers_Warlock.dreadstalkerTime[destGUID] = now
                    MyTriggers_Warlock.dreadstalkerCount = MyTriggers_Warlock.dreadstalkerCount + 1
                elseif spellID == 196273 or spellID == 196274 or spellID == 104317 or spellID == 196271 then
                    MyTriggers_Warlock.impTime[destGUID] = now
                    MyTriggers_Warlock.impCount = MyTriggers_Warlock.impCount + 1
                end
            elseif subEvent == "SPELL_INSTAKILL" then
                for index, value in pairs(MyTriggers_Warlock.impTime) do
                    if destGUID == index then
                        MyTriggers_Warlock.impTime[index] = nil
                        MyTriggers_Warlock.impCount = MyTriggers_Warlock.impCount - 1
                    end
                end
            end
        elseif e == "UNIT_SPELLCAST_SUCCEEDED" then
            local unitTarget, castGUID, spellID = ...;
            if unitTarget == "player" then
                local spellName = C_Spell.GetSpellInfo(spellID);
                if spellName then
                    MT:LastSpell(spellName);
                end
            end
        end
    end
    frame:SetScript("OnEvent", eventHandler);
end

function MT:GetDreadstalkerCount()
    local cutoff = GetTime() - 12
    if MyTriggers_Warlock.dreadstalkerTime ~= nil then      
        for index, value in pairs(MyTriggers_Warlock.dreadstalkerTime) do
            if value < cutoff then
                MyTriggers_Warlock.dreadstalkerTime[index] = nil
                MyTriggers_Warlock.dreadstalkerCount = MyTriggers_Warlock.dreadstalkerCount - 1               
            end
        end
    end
    return MyTriggers_Warlock.dreadstalkerCount or 0
end

function MT:GetImpCount()
    local cutoff = GetTime() - 12
    if MyTriggers_Warlock.impTime ~= nil then      
        for index, value in pairs(MyTriggers_Warlock.impTime) do
            if value < cutoff then
                MyTriggers_Warlock.impTime[index] = nil
                MyTriggers_Warlock.impCount = MyTriggers_Warlock.impCount - 1
            end
        end
    end
    return MyTriggers_Warlock.impCount or 0
end

MT.__cachedSettings["default"] = MT:DefaultSettings()
MT.__cachedSettings["default"].aoeEnemyThreshold = -1

MT.__cachedSettings["single"] = MT:DefaultSettings()
MT.__cachedSettings["single"].aoeEnemyThreshold = -1

MT.__cachedSettings["aoe2"] = MT:DefaultSettings()
MT.__cachedSettings["aoe2"].aoeEnemyThreshold = 2

MT.__cachedSettings["aoe3"] = MT:DefaultSettings()
MT.__cachedSettings["aoe3"].aoeEnemyThreshold = 3

MT.__cachedSettings["aoe5"] = MT:DefaultSettings()
MT.__cachedSettings["aoe5"].aoeEnemyThreshold = 5

LVK:AnnounceAddon("MyTriggers")