SheepWhisperer_InRangeOfAoeSpells = {
    -- Warrior
    ["1/1"] = "",
    ["1/2"] = "",
    ["1/3"] = "",

    -- Paladin
    ["2/1"] = "",
    ["2/2"] = "",
    ["2/3"] = "",

    -- Hunter
    ["3/1"] = "",
    ["3/2"] = "",
    ["3/3"] = "",

    -- Rogue
    ["4/1"] = "",
    ["4/2"] = "",
    ["4/3"] = "",

    -- Priest
    ["5/1"] = "",
    ["5/2"] = "",
    ["5/3"] = "Mind Flay",

    -- Death Knight
    ["6/1"] = "",
    ["6/2"] = "",
    ["6/3"] = "",

    -- Shaman
    ["7/1"] = "",
    ["7/2"] = "",
    ["7/3"] = "",

    -- Mage
    ["8/1"] = "",
    ["8/2"] = "",
    ["8/3"] = "",

    -- Warlock
    ["9/1"] = "",
    ["9/2"] = "",
    ["9/3"] = "",
    
    -- Monk
    ["10/1"] = "",
    ["10/2"] = "",
    ["10/3"] = "",

    -- Druid
    ["11/1"] = "",
    ["11/2"] = "",
    ["11/3"] = "",
    ["11/4"] = "",

    -- Demon Hunter
    ["12/1"] = "Chaos Strike",
    ["12/2"] = "",
}

function MyTriggers_ChatPrint(str)
	DEFAULT_CHAT_FRAME:AddMessage("[MyTriggers] "..str, 0.25, 1.0, 0.25);
end

function MyTriggers_ErrorPrint(str)
	DEFAULT_CHAT_FRAME:AddMessage("[MyTriggers] "..str, 1.0, 0.5, 0.5);
end

function MyTriggers_DebugPrint(str)
	-- DEFAULT_CHAT_FRAME:AddMessage("[MyTriggers] "..str, 0.75, 1.0, 0.25);
end

function MyTriggers_DefaultSettings()
    local settings = { }
    
    settings.lastRefresh = nil
    settings.refreshRate = 0.1

    settings.aoeEnemyThreshold = 5
    settings.priWorldBoss = true
    settings.priElite = true
    settings.bossHealth = 15000000
    settings.inRangeOfAoeSpell = MyTriggers_GetInRangeOfAoeSpell()

    settings.isPriority = false
    settings.isAoePriority = false
    settings.isSingleTargetPriority = false
    settings.isAoeReached = false

    return settings
end

function MyTriggers_GetInRangeOfAoeSpell()
    local classDisplayName, class, classID = UnitClass("player");
    local spec = GetSpecialization()

    local key = tostring(classID) .. "/" .. tostring(spec)
    return SheepWhisperer_InRangeOfAoeSpells[key]
end

function MyTriggers_Check(settings)
    MyTriggers_CheckPriorityTarget(settings)
    MyTriggers_CountForAoe(settings)

    settings.isAoePriority = settings.isPriority or settings.isAoeReached
    settings.isSingleTargetPriority = settings.isPriority and not settings.isAoeReached
end

function MyTriggers_CountForAoe(settings)
    if not settings.lastRefresh or settings.lastRefresh < GetTime() - settings.refreshRate then
        settings.lastRefresh = GetTime()
        
        local counter = 0
        
        for i = 1, 40 do
            local unit = "nameplate" .. i
            if UnitExists(unit) and not UnitIsFriend("player", unit) then
                local inRange = true
                if settings.inRangeOfAoeSpell ~= "" then
                    inRange = IsSpellInRange(settings.inRangeOfAoeSpell, unit) == 1
                end
                
                if inRange then
                    counter = counter + 1
                    if counter >= settings.aoeEnemyThreshold then
                        break
                    end
                end
            end
        end
        
        MyTriggers_DebugPrint("enemy count in range: " .. tostring(counter))
        settings.isAoeReached = counter >= settings.aoeEnemyThreshold
    end
end

function MyTriggers_CheckPriorityTarget(settings)
    local isBoss = false

    if UnitExists("target") and not UnitIsFriend("player", "target") and UnitHealth("target") > 0 then
        local c = UnitClassification("target")
        if c == "worldboss" then
            MyTriggers_DebugPrint("classification: world boss")
            isBoss = settings.priWorldBoss
        elseif c == "elite" or c == "rareelite" then
            MyTriggers_DebugPrint("classification: elite")
            isBoss = settings.priElite
        else
            local health = UnitHealthMax("target")
            if health >= settings.bossHealth then
                MyTriggers_DebugPrint("priority due to health: " .. tostring(health))
                isBoss = true
            else
                MyTriggers_DebugPrint("not priority, classification: " .. c .. ", health: " .. tostring(health))
            end
        end
    end

    settings.isPriority = isBoss
end

function MyTriggers_Test()
    local settings = MyTriggers_DefaultSettings()

    MyTriggers_Check(settings)

    if settings.isAoeReached then
        MyTriggers_DebugPrint("aoe threshold reached: YES")
    else
        MyTriggers_DebugPrint("aoe threshold reached: NO");
    end
    if settings.isAoePriority then
        MyTriggers_DebugPrint("aoe priority: YES")
    else
        MyTriggers_DebugPrint("aoe priority: NO");
    end

    if settings.isSingleTargetPriority then
        MyTriggers_DebugPrint("single target priority: YES")
    else
        MyTriggers_DebugPrint("single target priority: NO");
    end
end