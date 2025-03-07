MT.__classChecks = {
    ["Death Knight/pre"] = function (settings) MT:PreDeathKnight(settings) end,
    ["Death Knight"] = function (settings, unit, inRange) MT:CheckDeathKnight(settings, unit, inRange) end,

    ["Paladin/pre"] = function (settings) MT:PrePaladin(settings) end,
    ["Paladin"] = function (settings, unit, inRange) MT:CheckPaladin(settings, unit, inRange) end,

    ["Mage/init"] = function(settings) MT:InitMage(settings) end,
    ["Mage/pre"] = function(settings) MT:PreMage(settings) end,
    ["Mage"] = function(settings, unit, inRange) MT:CheckMage(settings, unit, inRange) end,

    ["Priest/init"] = function(settings) MT:InitPriest(settings) end,
    ["Priest/pre"] = function(settings) MT:PrePriest(settings) end,
    ["Priest"] = function(settings, unit, inRange) MT:CheckPriest(settings, unit, inRange) end,

    ["Demon Hunter/pre"] = function (settings) MT:PreDemonHunter(settings) end,
    ["Demon Hunter"] = function (settings, unit, inRange) MT:CheckDemonHunter(settings, unit, inRange) end,

    ["Shaman/pre"] = function (settings) MT:PreShaman(settings) end,
    ["Shaman"] = function (settings, unit, inRange) MT:CheckShaman(settings, unit, inRange) end,
    ["Shaman/cast"] = function(spellName) MT:ShamanCast(spellName) end,

    ["Rogue/pre"] = function (settings) MT:PreRogue(settings) end,
    ["Rogue"] = function (settings, unit, inRange) MT:CheckRogue(settings, unit, inRange) end,

    ["Warlock/pre"] = function (settings) MT:PreWarlock(settings) end,
    ["Warlock"] = function (settings, unit, inRange) MT:CheckWarlock(settings, unit, inRange) end,

    ["Warrior/pre"] = function (settings) MT:PreWarrior(settings) end,
    ["Warrior"] = function (settings, unit, inRange) MT:CheckWarrior(settings, unit, inRange) end,
};

MT.rogueUniqueSpells = {}
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

        settings.lastSpell = MT.lastSpell
        settings.castingInterruptible = 0
        settings.castingInterruptibleOther = 0

        MT:CheckPriorityTarget(settings)
        MT:CountForAoe(settings)

        return settings
    end

    return settings
end

function MT:InitializeCache()
    MT.__cachedSettings["aoe"] = MT:DefaultSettings()
end

function MT:Check()
    return MT.__cachedSettings["aoe"].Check()
end

function MT:InitializeSettings(settings)
    settings.lrc = nil

    settings.nextRefresh = GetTime()
    settings.refreshRate = 0.1

    settings.isPriority = false
    settings.classCheck = MT.__classChecks[UnitClass("player")]
    settings.classPreCheck = MT.__classChecks[UnitClass("player") .. "/pre"]
    settings.classPostCheck = MT.__classChecks[UnitClass("player") .. "/post"]
    settings.lastSpell = ""

    settings.enemyCount = 0
    settings.meleeCount = 0

    settings.bossHealth = UnitHealthMax("player") * 2
    settings.inRangeOfAoeSpell = MT:GetInRangeOfAoeSpell()
    settings.priElite = true
    settings.priWorldBoss = true

    local init = MT.__classChecks[UnitClass("player") .. "/init"]
    if init then
        init(settings)
    end

    if settings.classPreCheck then
        settings.classPreCheck(settings)
    end
end

function MT:OnShow(id, isQueue)
    MT:OnUpdate(id, true, isQueue)
end

function MT:OnHide(id, isQueue)
    MT:OnUpdate(id, false, isQueue)
end

function MT:OnUpdate(id, isVisible, isQueue)
    if MT.__weakAuraStack[id] then
        LVK:Error("MT:OnShow/OnHide(%s, ...) triggers itself", id)
        return
    end

    if MT.__weakAuraVisible[id] == isVisible then
        return
    end

    MT.__weakAuraStack[id] = true
    MT.__weakAuraVisible[id] = isVisible

    if isQueue then
        if isVisible then
            MT.__queueIconsVisible[id] = true
        else
            MT.__queueIconsVisible[id] = nil
        end
    end

    WeakAuras.ScanEvents("MT_WEAKAURA_VISIBILITY", id)
    MT.__weakAuraStack[id] = nil
end

function MT:WA(id)
    if type(id) == "table" then
        for i,k in pairs(id) do
            if MT.__weakAuraVisible[k] then
                return true
            end
        end
        return false
    end
    return MT.__weakAuraVisible[id] or false
end

function MT:IsQueueVisible()
    return next(MT.__queueIconsVisible) ~= nil
end

function MT:RefreshWA()
    C_Timer.After(2, function()
        if not WeakAuras.IsOptionsOpen() then
            WeakAuras.ScanEvents("MT_WEAKAURA_VISIBILITY")
            WeakAuras.ScanEvents("PLAYER_ENTERING_WORLD")
            WeakAuras.ScanEvents("PLAYER_ROLES_ASSIGNED")
            WeakAuras.ScanEvents("ZONE_CHANGED_NEW_AREA")
            WeakAuras.ScanEvents("ZONE_CHANGED")
            WeakAuras.ScanEvents("ZONE_CHANGED_INDOORS")
            WeakAuras.ScanEvents("MT_ROLE_CHECK")
            WeakAuras.ScanEvents("PARTY_LEADER_CHANGED")
        end
    end)
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
        if MT.lastSpell ~= spell then
            MT.lastSpell = spell
            WeakAuras.ScanEvents("MT_WEAKAURA_SPELLCAST", spell)
        end

        table.insert(MT.__Last3Spells, spellName);
        if MT.__Last3Spells[4] then
            table.remove(MT.__Last3Spells, 1);
        end

        LVK:Debug("|y|Player cast|<|: |g|%s|<|", spell)
    else
        return MT.lastSpell
    end
end

function MT:GetInRangeOfAoeSpell()
    local classDisplayName, class, classID = UnitClass("player");
    local spec = GetSpecialization()

    local key = tostring(classID) .. "/" .. tostring(spec)
    return MyTriggers_InRangeOfAoeSpells[key]
end

function MT:CountForAoe(settings)
    settings.isCondemnedDemonInRange = false

    local now = GetTime()
    if now < settings.nextRefresh then
        return
    end

    settings.nextRefresh = now + settings.refreshRate
    local counter = 0
    local meleeCounter = 0

    if settings.classPreCheck then
        settings.classPreCheck(settings)
    end

    settings.lrc = settings.lrc or LibStub("LibRangeCheck-3.0")

    local isMeleeRange = settings.lrc:GetHarmMaxChecker(2)
    if not isMeleeRange then
        settings.lrc = settings.lrc or LibStub("LibRangeCheck-3.0")
        isMeleeRange = settings.lrc:GetHarmMaxChecker(2)
    end
    for i = 1, 40 do
        local unit = "nameplate" .. i
        if UnitExists(unit) and UnitAffectingCombat(unit) and not UnitIsFriend("player", unit) then
            local inRange = true

            local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo(unit)
            if name and (not notInterruptible) then
                settings.castingInterruptible = settings.castingInterruptible + 1
                if not UnitIsUnit("target", unit) then
                    settings.castingInterruptibleOther = settings.castingInterruptibleOther + 1
                end
            end
        
            if settings.inRangeOfAoeSpell ~= "" then
                inRange = C_Spell.IsSpellInRange(settings.inRangeOfAoeSpell, unit)
                if inRange then
                    if inRange and C_UnitAuras.GetAuraDataBySpellName(unit, "Unstoppable Conflict", "HARMFUL") then
                        settings.isCondemnedDemonInRange = true
                    end
                end
            end

            if isMeleeRange and isMeleeRange(unit) then
                meleeCounter = meleeCounter + 1
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
    settings.meleeCount = meleeCounter
end

function MT:CheckPriorityTarget(settings)
    local isPriority = false
    local isBoss = false

    if UnitExists("target") and not UnitIsFriend("player", "target") and UnitHealth("target") > 0 then
        local c = UnitClassification("target")
        if c == "worldboss" then
            isPriority = settings.priWorldBoss
        elseif c == "elite" or c == "rareelite" then
            isPriority = settings.priElite
        else
            local health = UnitHealthMax("target")
            if health >= settings.bossHealth then
                isPriority = true
            end
        end

        for k = 1, 8 do
            local key = "boss" .. k
            if UnitExists(key) and UnitIsUnit("target", key) then
                isBoss = true
                break
            end
        end
    end

    settings.isBoss = isBoss
    settings.isPriority = isPriority
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

--[[
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
--]]

function MT:StartCombat()
    WeakAuras.ScanEvents("MT_ROLE_CHECK")
    WeakAuras.ScanEvents("MT_COMBAT_START")
end

function MT:EndCombat()
    if MT.__timer then
        MT.__timer:Cancel()
        MT.__timer = nil
        WeakAuras.ScanEvents("MT_COMBAT_END")
    end
end

-- local frame = CreateFrame("FRAME", "MyTriggersAddonFrame")
-- frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
-- frame:RegisterEvent("PLAYER_REGEN_ENABLED")
-- frame:RegisterEvent("PLAYER_ENTER_COMBAT")
-- frame:RegisterEvent("PLAYER_REGEN_DISABLED")
-- frame:RegisterEvent("PLAYER_LEAVE_COMBAT")
-- frame:RegisterEvent("UNIT_COMBAT")

-- frame:RegisterEvent("PARTY_MEMBER_ENABLE")
-- frame:RegisterEvent("PARTY_MEMBER_DISABLE")
-- frame:RegisterEvent("PLAYER_ROLES_ASSIGNED")
-- frame:RegisterEvent("PARTY_LEADER_CHANGED")
-- frame:RegisterEvent("ROLE_CHANGED_INFORM")
-- frame:RegisterEvent("GROUP_ROSTER_UPDATE")
-- frame:RegisterEvent("GROUP_JOINED")

-- frame:RegisterEvent("ADDON_LOADED")

-- frame:SetScript("OnEvent", function(self, e, ...)
--     if e == "ADDON_LOADED" then
--         -- if select(1, ...) == "MyTriggers" then        
--         --     frame:UnregisterEvent("ADDON_LOADED")
--         --     C_Timer.After(5, function() WeakAuras.ScanEvents("MT_ROLE_CHECK") end)
--         --     MT:StartPeriodic()
--         -- end
--     elseif e == "PARTY_MEMBER_ENABLED" or e == "PARTY_MEMBER_DISABLE" or e == "PLAYER_ROLES_ASSIGNED" or e == "PARTY_LEADER_CHANGED" or e == "ROLE_CHANGED_INFORM" or e == "GROUP_ROSTER_UPDATE" or e == "GROUP_JOINED" then
--         -- WeakAuras.ScanEvents("MT_ROLE_CHECK")
--     end
--     if e == "PLAYER_REGEN_DISABLED" or e == "PLAYER_ENTER_COMBAT" then
--         -- WeakAuras.ScanEvents("MT_ROLE_CHECK")
--         -- MT:StartCombat()
--     elseif e == "PLAYER_REGEN_ENABLED" or e == "PLAYER_LEAVE_COMBAT" then
--         -- WeakAuras.ScanEvents("MT_ROLE_CHECK")
--         -- MT:EndCombat()
--     elseif e == "UNIT_COMBAT" then
--         if UnitAffectingCombat("player") or UnitAffectingCombat("party1") or UnitAffectingCombat("party2") or UnitAffectingCombat("party3") or UnitAffectingCombat("party4") then
--             MT:StartCombat()
--         end
--     elseif e == "UNIT_SPELLCAST_SUCCEEDED" then
--         -- local unitTarget, castGUID, spellID = ...
--         -- if unitTarget == "player" then
--         --     local spellName = C_Spell.GetSpellName(spellID)
--         --     MT:LastSpell(spellName)

--         --     if MT.castCheck then
--         --         MT.castCheck(spellName)
--         --     end
--         -- end
--     end
-- end)

function MT:StartPeriodic()
    local counter2 = 0
    local counter4 = 0

    -- Timer function, runs 4 times a second
    MT.__timer = C_Timer.NewTicker(0.25, function()
        WeakAuras.ScanEvents("MT_PERIODIC_4")

        counter2 = 1 - counter2
        if counter2 == 0 then
            WeakAuras.ScanEvents("MT_PERIODIC_2")
        end

        counter4 = (counter4 + 1) % 4
        if counter4 == 0 then
            WeakAuras.ScanEvents("MT_PERIODIC_1")
        end
    end)
end

function MT:Delay(event, delay)
    local timer = { }
    timer.elapsed = false

    timer.StartIfStopped = function()
        if not timer.timer then
            timer.elapsed = false
            timer.timer = C_Timer.NewTimer(delay, function()
                timer.elapsed = true
                timer.timer:Cancel()

                WeakAuras.ScanEvents(event)
            end)

            WeakAuras.ScanEvents(event)
        end
    end

    timer.Stop = function()
        if timer.timer then
            timer.timer:Cancel()
            timer.timer = nil
        end
        timer.elapsed = false
        WeakAuras.ScanEvents(event)
    end

    return timer
end

local eventHandler = LVK:EventHandler()
eventHandler.RegisterEvent("COMPANION_UPDATE", function(...)
    C_Timer.After(0.1, function() WeakAuras.ScanEvents("COMPANION_UPDATE") end)
end)

eventHandler.RegisterEvent("PLAYER_ENTERING_WORLD", function(...)
    C_Timer.After(1, function() WeakAuras.ScanEvents("COMPANION_UPDATE") end)
end)

eventHandler.RegisterEvent("PET_BAR_UPDATE", function(...)
    C_Timer.After(1, function() WeakAuras.ScanEvents("COMPANION_UPDATE") end)
end)

eventHandler.RegisterEvent("ADDON_LOADED", function(addon, ...)
    if addon == "MyTriggers" then
        eventHandler.UnregisterEvent("ADDON_LOADED")
        C_Timer.After(5, function() WeakAuras.ScanEvents("MT_ROLE_CHECK") end)
        MT:StartPeriodic()
        LVK:AnnounceAddon("MyTriggers")
    end
end)

eventHandler.RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", function(unitTarget, castGUID, spellID, ...)
    if unitTarget == "player" then
        local spellName = C_Spell.GetSpellName(spellID)
        MT:LastSpell(spellName)

        if MT.castCheck then
            MT.castCheck(spellName)
        end
    end
end)

eventHandler.RegisterEvent({ "PARTY_MEMBER_ENABLE", "PARTY_MEMBER_DISABLE", "PLAYER_ROLES_ASSIGNED", "PARTY_LEADER_CHANGED", "ROLE_CHANGED_INFORM", "GROUP_ROSTER_UPDATE", "GROUP_JOINED" }, function(...)
    WeakAuras.ScanEvents("MT_ROLE_CHECK")
end)

eventHandler.RegisterEvent({ "PLAYER_REGEN_DISABLED", "PLAYER_ENTER_COMBAT" }, function(...)
    WeakAuras.ScanEvents("MT_ROLE_CHECK")
    MT:StartCombat()
end)

eventHandler.RegisterEvent({ "PLAYER_REGEN_ENABLED", "PLAYER_LEAVE_COMBAT" }, function(...)
    WeakAuras.ScanEvents("MT_ROLE_CHECK")
    MT:EndCombat()
end)

eventHandler.RegisterEvent("UNIT_COMBAT", function(unitTarget, ...)
    if unitTarget == "player" or unitTarget == "party1" or unitTarget == "party2" or unitTarget == "party3" or unitTarget == "party4" then
        MT:StartCombat()
    end
end)

MT.castCheck = MT.__classChecks[UnitClass("player") .. "/cast"]
MT:InitializeCache()