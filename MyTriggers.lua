MyTriggers_InRangeOfAoeSpells = {
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
    ["8/2"] = "Fireball",
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
    settings.bossHealth = 15000
    settings.inRangeOfAoeSpell = MyTriggers_GetInRangeOfAoeSpell()

    settings.isPriority = false
    settings.isAoePriority = false
    settings.isSingleTargetPriority = false
    settings.isAoeReached = false

    return settings
end

local priMode = 2
local lastSpell = ""

function MyTriggers_GetLastSpell()
    return lastSpell
end

function MyTriggers_SetLastSpell(spell)
    lastSpell = spell
end

function MyTriggers_IsAoeSelected()
    return priMode == 1
end

function MyTriggers_IsSingleSelected()
    return priMode == 0
end

function MyTriggers_IsAutoSelection()
    return priMode == 2
end

function MyTriggers_SetSelection(mode)
    priMode = mode
    MyTriggers_ShowMode()
end

function MyTriggers_ToggleSelection()
    if priMode < 2 then
        priMode = priMode + 1
    else
        priMode = 0
    end
    MyTriggers_ShowMode()
end

function MyTriggers_ShowMode()
    if priMode == 0 then
        UIErrorsFrame:AddMessage("Single target mode selected", 1, 0, 0, 5)
    elseif priMode == 1 then
        UIErrorsFrame:AddMessage("AOE mode selected", 1, 0, 0, 5)
    else
        UIErrorsFrame:AddMessage("Automatic single target / aoe mode selected", 1, 0, 0, 5)
    end
end

function MyTriggers_GetInRangeOfAoeSpell()
    local classDisplayName, class, classID = UnitClass("player");
    local spec = GetSpecialization()

    local key = tostring(classID) .. "/" .. tostring(spec)
    return MyTriggers_InRangeOfAoeSpells[key]
end

function MyTriggers_Check(settings)
    MyTriggers_CheckPriorityTarget(settings)
    MyTriggers_CountForAoe(settings)
    MyTriggers_CheckSelection(settings)

    settings.isAoePriority = settings.aoeSelected or settings.isPriority or settings.isAoeReached
    settings.isSingleTargetPriority = settings.isPriority and not settings.isAoeReached
end

function MyTriggers_CheckSelection(settings)
    if priMode == 0 then
        settings.aoeSelected = false
    elseif priMode == 1 then
        settings.aoeSelected = true
    else
        settings.aoeSelected = settings.isAoeReached
    end
end

function MyTriggers_CountForAoe(settings)
    if not settings.lastRefresh or settings.lastRefresh < GetTime() - settings.refreshRate then
        settings.lastRefresh = GetTime()
        
        local counter = 0
        
        for i = 1, 40 do
            local unit = "nameplate" .. i
            if UnitExists(unit) and UnitAffectingCombat(unit) and not UnitIsFriend("player", unit) then
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

-- https://wago.io/r1wDoVIw-
local frame = CreateFrame("FRAME", "MyTriggersAddonFrame");
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
local MyTriggers_Warlock = {
    pguid = UnitGUID("player"),
    dreadstalkerCount = 0,
    dreadstalkerTime = {},

    impCount = 0,
    impTime = {}
}

local function eventHandler(self, e, timestamp, subEvent, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID, ...)
    local now = GetTime()

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
end
frame:SetScript("OnEvent", eventHandler);

function MyTriggers_GetDreadstalkerCount()
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

function MyTriggers_GetImpCount()
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