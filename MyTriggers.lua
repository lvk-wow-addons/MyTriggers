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
MT.__frames = {}

MT.__currentProfileKey = UnitName("player") .. " - " .. GetRealmName()
MT.__currentProfile = PlaterDB and PlaterDB.profiles and PlaterDB.profiles[PlaterDB and PlaterDB.profileKeys and PlaterDB.profileKeys[MT.__currentProfileKey]]
MT.__platerColors = {
    ["HUNTER"] = {0.67, 0.83, 0.45},
    ["WARLOCK"] = {0.58, 0.51, 0.79},
    ["PRIEST"] = {1.0, 1.0, 1.0},
    ["PALADIN"] = {0.96, 0.55, 0.73},
    ["MAGE"] = {0.41, 0.8, 0.94},
    ["ROGUE"] = {1.0, 0.96, 0.41},
    ["DRUID"] = {1.0, 0.49, 0.04},
    ["SHAMAN"] = {0.0, 0.44, 0.87},
    ["WARRIOR"] = {0.78, 0.61, 0.43},
    ["DEATHKNIGHT"] = {0.77, 0.12, 0.23},
    ["MONK"] = {0.0, 1.00, 0.59},
    ["DEMONHUNTER"] = {0.64, 0.19, 0.79},
    ["EVOKER"] = {0.20, 0.58, 0.50},

    ["dark1"] = {0.1215, 0.1176, 0.1294},
    ["dark2"] = {0.2215, 0.2176, 0.2294},
    ["dark3"] = {0.3215, 0.3176, 0.3294},

    ["aliceblue"] = {0.941176, 0.972549, 1, 1},
    ["antiquewhite"] = {0.980392, 0.921569, 0.843137, 1},
    ["aqua"] = {0, 1, 1, 1},
    ["aquamarine"] = {0.498039, 1, 0.831373, 1},
    ["azure"] = {0.941176, 1, 1, 1},
    ["beige"] = {0.960784, 0.960784, 0.862745, 1},
    ["bisque"] = {1, 0.894118, 0.768627, 1},
    ["black"] = {0, 0, 0, 1},
    ["blanchedalmond"] = {1, 0.921569, 0.803922, 1},
    ["blue"] = {0, 0, 1, 1},
    ["blueviolet"] = {0.541176, 0.168627, 0.886275, 1},
    ["brown"] = {0.647059, 0.164706, 0.164706, 1},
    ["burlywood"] = {0.870588, 0.721569, 0.529412, 1},
    ["cadetblue"] = {0.372549, 0.619608, 0.627451, 1},
    ["chartreuse"] = {0.498039, 1, 0, 1},
    ["chocolate"] = {0.823529, 0.411765, 0.117647, 1},
    ["coral"] = {1, 0.498039, 0.313725, 1},
    ["cornflowerblue"] = {0.392157, 0.584314, 0.929412, 1},
    ["cornsilk"] = {1, 0.972549, 0.862745, 1},
    ["crimson"] = {0.862745, 0.0784314, 0.235294, 1},
    ["cyan"] = {0, 1, 1, 1},
    ["darkblue"] = {0, 0, 0.545098, 1},
    ["darkcyan"] = {0, 0.545098, 0.545098, 1},
    ["darkgoldenrod"] = {0.721569, 0.52549, 0.0431373, 1},
    ["darkgray"] = {0.662745, 0.662745, 0.662745, 1},
    ["darkgreen"] = {0, 0.392157, 0, 1},
    ["darkkhaki"] = {0.741176, 0.717647, 0.419608, 1},
    ["darkmagenta"] = {0.545098, 0, 0.545098, 1},
    ["darkolivegreen"] = {0.333333, 0.419608, 0.184314, 1},
    ["darkorange"] = {1, 0.54902, 0, 1},
    ["darkorchid"] = {0.6, 0.196078, 0.8, 1},
    ["darkred"] = {0.545098, 0, 0, 1},
    ["darksalmon"] = {0.913725, 0.588235, 0.478431, 1},
    ["darkseagreen"] = {0.560784, 0.737255, 0.560784, 1},
    ["darkslateblue"] = {0.282353, 0.239216, 0.545098, 1},
    ["darkslategray"] = {0.184314, 0.309804, 0.309804, 1},
    ["darkturquoise"] = {0, 0.807843, 0.819608, 1},
    ["darkviolet"] = {0.580392, 0, 0.827451, 1},
    ["deeppink"] = {1, 0.0784314, 0.576471, 1},
    ["deepskyblue"] = {0, 0.74902, 1, 1},
    ["dimgray"] = {0.411765, 0.411765, 0.411765, 1},
    ["dimgrey"] = {0.411765, 0.411765, 0.411765, 1},
    ["dodgerblue"] = {0.117647, 0.564706, 1, 1},
    ["firebrick"] = {0.698039, 0.133333, 0.133333, 1},
    ["firebrickdark"] = {0.258039, 0.033333, 0.033333, 1},
    ["floralwhite"] = {1, 0.980392, 0.941176, 1},
    ["forestgreen"] = {0.133333, 0.545098, 0.133333, 1},
    ["fuchsia"] = {1, 0, 1, 1},
    ["gainsboro"] = {0.862745, 0.862745, 0.862745, 1},
    ["ghostwhite"] = {0.972549, 0.972549, 1, 1},
    ["gold"] = {1, 0.843137, 0, 1},
    ["goldenrod"] = {0.854902, 0.647059, 0.12549, 1},
    ["gray"] = {0.501961, 0.501961, 0.501961, 1},
    ["green"] = {0, 0.501961, 0, 1},
    ["greenyellow"] = {0.678431, 1, 0.184314, 1},
    ["honeydew"] = {0.941176, 1, 0.941176, 1},
    ["hotpink"] = {1, 0.411765, 0.705882, 1},
    ["indianred"] = {0.803922, 0.360784, 0.360784, 1},
    ["indigo"] = {0.294118, 0, 0.509804, 1},
    ["ivory"] = {1, 1, 0.941176, 1},
    ["khaki"] = {0.941176, 0.901961, 0.54902, 1},
    ["lavender"] = {0.901961, 0.901961, 0.980392, 1},
    ["lavenderblush"] = {1, 0.941176, 0.960784, 1},
    ["lawngreen"] = {0.486275, 0.988235, 0, 1},
    ["lemonchiffon"] = {1, 0.980392, 0.803922, 1},
    ["lightblue"] = {0.678431, 0.847059, 0.901961, 1},
    ["lightcoral"] = {0.941176, 0.501961, 0.501961, 1},
    ["lightcyan"] = {0.878431, 1, 1, 1},
    ["lightgoldenrodyellow"] = {0.980392, 0.980392, 0.823529, 1},
    ["lightgray"] = {0.827451, 0.827451, 0.827451, 1},
    ["lightgreen"] = {0.564706, 0.933333, 0.564706, 1},
    ["lightpink"] = {1, 0.713725, 0.756863, 1},
    ["lightsalmon"] = {1, 0.627451, 0.478431, 1},
    ["lightseagreen"] = {0.12549, 0.698039, 0.666667, 1},
    ["lightskyblue"] = {0.529412, 0.807843, 0.980392, 1},
    ["lightslategray"] = {0.466667, 0.533333, 0.6, 1},
    ["lightsteelblue"] = {0.690196, 0.768627, 0.870588, 1},
    ["lightyellow"] = {1, 1, 0.878431, 1},
    ["lime"] = {0, 1, 0, 1},
    ["limegreen"] = {0.196078, 0.803922, 0.196078, 1},
    ["linen"] = {0.980392, 0.941176, 0.901961, 1},
    ["magenta"] = {1, 0, 1, 1},
    ["maroon"] = {0.501961, 0, 0, 1},
    ["mediumaquamarine"] = {0.4, 0.803922, 0.666667, 1},
    ["mediumblue"] = {0, 0, 0.803922, 1},
    ["mediumorchid"] = {0.729412, 0.333333, 0.827451, 1},
    ["mediumpurple"] = {0.576471, 0.439216, 0.858824, 1},
    ["mediumseagreen"] = {0.235294, 0.701961, 0.443137, 1},
    ["mediumslateblue"] = {0.482353, 0.407843, 0.933333, 1},
    ["mediumspringgreen"] = {0, 0.980392, 0.603922, 1},
    ["mediumturquoise"] = {0.282353, 0.819608, 0.8, 1},
    ["mediumvioletred"] = {0.780392, 0.0823529, 0.521569, 1},
    ["midnightblue"] = {0.0980392, 0.0980392, 0.439216, 1},
    ["mintcream"] = {0.960784, 1, 0.980392, 1},
    ["mistyrose"] = {1, 0.894118, 0.882353, 1},
    ["moccasin"] = {1, 0.894118, 0.709804, 1},
    ["navajowhite"] = {1, 0.870588, 0.678431, 1},
    ["navy"] = {0, 0, 0.501961, 1},
    ["none"] ={0, 0, 0, 0},
    ["oldlace"] = {0.992157, 0.960784, 0.901961, 1},
    ["olive"] = {0.501961, 0.501961, 0, 1},
    ["olivedrab"] = {0.419608, 0.556863, 0.137255, 1},
    ["orange"] = {1, 0.647059, 0, 1},
    ["orangered"] = {1, 0.270588, 0, 1},
    ["orchid"] = {0.854902, 0.439216, 0.839216, 1},
    ["palegoldenrod"] = {0.933333, 0.909804, 0.666667, 1},
    ["palegreen"] = {0.596078, 0.984314, 0.596078, 1},
    ["paleturquoise"] = {0.686275, 0.933333, 0.933333, 1},
    ["palevioletred"] = {0.858824, 0.439216, 0.576471, 1},
    ["papayawhip"] = {1, 0.937255, 0.835294, 1},
    ["peachpuff"] = {1, 0.854902, 0.72549, 1},
    ["peru"] = {0.803922, 0.521569, 0.247059, 1},
    ["pink"] = {1, 0.752941, 0.796078, 1},
    ["plum"] = {0.866667, 0.627451, 0.866667, 1},
    ["powderblue"] = {0.690196, 0.878431, 0.901961, 1},
    ["purple"] = {0.501961, 0, 0.501961, 1},
    ["red"] = {1, 0, 0, 1},
    ["rosybrown"] = {0.737255, 0.560784, 0.560784, 1},
    ["royalblue"] = {0.254902, 0.411765, 0.882353, 1},
    ["saddlebrown"] = {0.545098, 0.270588, 0.0745098, 1},
    ["salmon"] = {0.980392, 0.501961, 0.447059, 1},
    ["sandybrown"] = {0.956863, 0.643137, 0.376471, 1},
    ["seagreen"] = {0.180392, 0.545098, 0.341176, 1},
    ["seashell"] = {1, 0.960784, 0.933333, 1},
    ["sienna"] = {0.627451, 0.321569, 0.176471, 1},
    ["silver"] = {0.752941, 0.752941, 0.752941, 1},
    ["skyblue"] = {0.529412, 0.807843, 0.921569, 1},
    ["slateblue"] = {0.415686, 0.352941, 0.803922, 1},
    ["slategray"] = {0.439216, 0.501961, 0.564706, 1},
    ["snow"] = {1, 0.980392, 0.980392, 1},
    ["springgreen"] = {0, 1, 0.498039, 1},
    ["steelblue"] = {0.27451, 0.509804, 0.705882, 1},
    ["tan"] = {0.823529, 0.705882, 0.54902, 1},
    ["teal"] = {0, 0.501961, 0.501961, 1},
    ["thistle"] = {0.847059, 0.74902, 0.847059, 1},
    ["tomato"] = {1, 0.388235, 0.278431, 1},
    ["transparent"] ={0, 0, 0, 0},
    ["turquoise"] = {0.25098, 0.878431, 0.815686, 1},
    ["violet"] = {0.933333, 0.509804, 0.933333, 1},
    ["wheat"] = {0.960784, 0.870588, 0.701961, 1},
    ["white"] = {1, 1, 1, 1},
    ["whitesmoke"] = {0.960784, 0.960784, 0.960784, 1},
    ["yellow"] = {1, 1, 0, 1},
    ["yellowgreen"] = {0.603922, 0.803922, 0.196078, 1}
}

MT.__enemyColor = {0.9172, 0.2874, 0.2078, 1}
MT.__aggroColor = {0.5, 0.5, 1, 1}
function MT:QuaziiNameplateColor(unitID)
    local guid = UnitGUID(unitID)

    result = MT.__enemyColor
    -- local threat = UnitThreatSituation("player", unitID)
    -- if threat and threat >= 2 then
    --     result = MT.__aggroColor
    -- end

    if not guid then
        return result[1], result[2], result[3], result[4]
    end

    local enemyID = string.match(guid, "^[^%-]+%-%d+%-%d+%-%d+%-%d+%-(%d+)%-%x+$")
    if not enemyID then
        return result[1], result[2], result[3], result[4]
    end

    enemyID = tonumber(enemyID)
    
    local colors = MT.__currentProfile and MT.__currentProfile.npc_colors
    if not colors then
        return result[1], result[2], result[3], result[4]
    end

    local color = colors[enemyID]
    if not color then
        return result[1], result[2], result[3], result[4]
    end
    color = color[3]

    local tbl = MT.__platerColors[color]
    if not tbl then
        return result[1], result[2], result[3], result[4]
    end

    return tbl[1], tbl[2], tbl[3], tbl[4]
end

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

function MT:OnShowCastbar(id)
    if MT.__castbarsVisible[id] then return end

    MT.__castbarsVisible[id] = true
    MT.__castbars = MT.__castbars + 1
    if MT.__castbars == 1 then
        WeakAuras.ScanEvents("MT_WEAKAURA_CASTBAR")
    end
end

function MT:OnHideCastbar(id)
    if not MT.__castbarsVisible[id] then return end

    MT.__castbarsVisible[id] = nil
    MT.__castbars = MT.__castbars - 1
    if MT.__castbars == 0 then
        WeakAuras.ScanEvents("MT_WEAKAURA_CASTBAR")
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

function MT:HideFrame(frame)
    if frame and frame:IsShown() then
        frame:Hide()
        table.insert(MT.__frames, frame)
    end
end

function MT:RestoreFrames()
    local frames = MT.__frames
    MT.__frames = {}

    for _, frame in ipairs(frames) do
        if frame and not frame:IsShown() then
            frame:Show()
        end
    end
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

eventHandler.RegisterEvent("UNIT_SPELLCAST_FAILED", function(unitTarget, castGUID, spellID, ...)
    if spellID == 192222 then
        MT.__shaLiquidMagmaTotemFailed = MT.__shaLiquidMagmaTotemFailed + 1
        WeakAuras.ScanEvents("MT_SHA_LIQUID_MAGMA_TOTEM")
    end
end)

eventHandler.RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", function(unitTarget, castGUID, spellID, ...)
    if unitTarget == "player" then
        if MT.__shaLiquidMagmaTotemFailed > 0 then
            MT.__shaLiquidMagmaTotemFailed = 0
            WeakAuras.ScanEvents("MT_SHA_LIQUID_MAGMA_TOTEM")
        end

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

eventHandler.RegisterEvent({ "PLAYER_REGEN_DISABLED" }, function(...)
    MT:HideFrame(ObjectiveTrackerFrame)
    MT:HideFrame(ChatFrame1)
    MT:HideFrame(ChatFrame1Tab)
    MT:HideFrame(ChatFrame1EditBox)

    MT:HideFrame(ChatFrame2)
    MT:HideFrame(ChatFrame2Tab)
    MT:HideFrame(ChatFrame2EditBox)

    MT:HideFrame(ChatFrame3)
    MT:HideFrame(ChatFrame3Tab)
    MT:HideFrame(ChatFrame3EditBox)

    MT:HideFrame(ChatFrame4)
    MT:HideFrame(ChatFrame4Tab)
    MT:HideFrame(ChatFrame4EditBox)

    MT:HideFrame(ChatFrame5)
    MT:HideFrame(ChatFrame5Tab)
    MT:HideFrame(ChatFrame5EditBox)

    MT:HideFrame(ChatFrame6)
    MT:HideFrame(ChatFrame6Tab)
    MT:HideFrame(ChatFrame6EditBox)

    MT:HideFrame(ChatFrame7)
    MT:HideFrame(ChatFrame7Tab)
    MT:HideFrame(ChatFrame7EditBox)

    MT:HideFrame(ChatFrame8)
    MT:HideFrame(ChatFrame8Tab)
    MT:HideFrame(ChatFrame8EditBox)

    MT:HideFrame(ChatFrame9)
    MT:HideFrame(ChatFrame9Tab)
    MT:HideFrame(ChatFrame9EditBox)

    MT:HideFrame(ChatFrame10)
    MT:HideFrame(ChatFrame10Tab)
    MT:HideFrame(ChatFrame10EditBox)

    MT:HideFrame(ChatFrame11)
    MT:HideFrame(ChatFrame11Tab)
    MT:HideFrame(ChatFrame11EditBox)

    MT:HideFrame(ChatFrame12)
    MT:HideFrame(ChatFrame12Tab)
    MT:HideFrame(ChatFrame12EditBox)

    MT:HideFrame(ChatFrame13)
    MT:HideFrame(ChatFrame13Tab)
    MT:HideFrame(ChatFrame13EditBox)

    MT:HideFrame(ChatFrame14)
    MT:HideFrame(ChatFrame14Tab)
    MT:HideFrame(ChatFrame14EditBox)

    MT:HideFrame(ChatFrame15)
    MT:HideFrame(ChatFrame15Tab)
    MT:HideFrame(ChatFrame15EditBox)

    MT:HideFrame(ChatFrame16)
    MT:HideFrame(ChatFrame16Tab)
    MT:HideFrame(ChatFrame16EditBox)

    MT:HideFrame(ChatFrame17)
    MT:HideFrame(ChatFrame17Tab)
    MT:HideFrame(ChatFrame17EditBox)
end)

eventHandler.RegisterEvent({ "PLAYER_REGEN_ENABLED" }, function(...)
    MT:RestoreFrames()
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
MT.__shaLiquidMagmaTotemFailed = 0
MT:InitializeCache()