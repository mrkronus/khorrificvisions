local addonName, KHorrificVisions = ...
local kprint = KHorrificVisions.kprint

--[[-------------------------------------------------------------------------
	Variables
---------------------------------------------------------------------------]]

-- [[ Localization ]]
--local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

-- https://www.icy-veins.com/wow/horrific-visions-tributes-guide
local bufflist = {
    { name = "Steeled Mind",                 filter = "HELFUL", getValue = function(aura) return aura.points[1] .. "% sanity reduction." end },
    { name = "Clear Sight",                  filter = "HELFUL", getValue = function(aura) return "rank " .. (aura.spellId == 472248 and "3." or aura.spellId == 472246 and "2." or "1.") end },
    { name = "Experimental Destabilization", filter = "HELFUL", getValue = function(aura) return "rank " .. (aura.spellId == 472264 and "3." or aura.spellId == 472263 and "2." or "1.") end },
    { name = "Vision Hunter",                filter = "HELFUL", getValue = function(aura) return "rank " .. (aura.spellId == 472267 and "3." or aura.spellId == 472266 and "2." or "1.") end },
    { name = "Elite Extermination",          filter = "HELFUL", getValue = function(aura) return "rank " .. (aura.spellId == 1215783 and "3." or aura.spellId == 1215782 and "2." or "1.") end },
}


--[[-------------------------------------------------------------------------
	Slash Command
---------------------------------------------------------------------------]]

local function GetAuraIfExistsOnUnit(unit, auraName, auraType)
    local auraIndex = 1
    while true do
        local aura = C_UnitAuras.GetAuraDataByIndex(unit, auraIndex, auraType)
        if aura then
            if aura.name == auraName then
                return aura
            end

            auraIndex = auraIndex + 1
        else
            -- end of list
            return nil
        end
    end
end

local function GetBuffIfExistsOnUnit(unit, buffName)
    return GetAuraIfExistsOnUnit(unit, buffName, "HELPFUL")
end

local function GetDebuffIfExistsOnUnit(unit, debuffName)
    return GetAuraIfExistsOnUnit(unit, debuffName, "HARMFUL")
end

local function CheckHorrificBuffs()
    for _, buff in ipairs(bufflist) do
        local currentAura = GetBuffIfExistsOnUnit("player", buff.name)
        if currentAura then
            print("Player has", currentAura.name, "at", buff.getValue(currentAura), "(", currentAura.spellId, ")")
        else
            print("Player does *not* currently have", buff.name)
        end
    end
end

SLASH_HVB1 = "/hvb"
SlashCmdList["HVB"] = CheckHorrificBuffs