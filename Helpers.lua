local addonName, AddonNamespace = ...

AddonNamespace.Colors = {
    Header       = "FFFFD700",
    SubHeader    = "FFFFFF00",
    Footer       = "FFF5F5F5",
    FooterDark   = "FFA9A9A9",
    Acquired     = "FF00FF00",
    Incomplete   = "FFA9A9A9",

    Alliance     = "FF4A54E8",
    Horde        = "FFE50D12",

	CLASSIC		 = "FFE6CC80",
	TBC			 = "FF1EFF00",
	WOTLK		 = "FF66ccff",
	CATA		 = "FFff3300",
	MOP			 = "FF00FF96",
	WOD			 = "FFff8C1A",
	LEGION		 = "FFA335EE",
	BFA 		 = "FFFF7D0A",
	SHADOWLANDS  = "FFE6CC80",
	DRAGONFLIGHT = "FF33937F",

	Yellow 		 = "FFFFFF00",
	White 		 = "FFFFFFFF",
    Grey         = "FFA9A9A9",
    Red          = "FFFF0000",

	Common 		 = "FFFFFFFF",
	Uncommon 	 = "FF1EFF00",
	Rare 		 = "FF0070DD",
	Epic 		 = "FFA335EE",
	Legendary 	 = "FFFF8000",
	Artifact 	 = "FFE6CC80",
	WowToken	 = "FF00CCFF",

	DeathKnight  = "FFC41F3B",
	DemonHunter  = "FFA330C9",
	Druid 		 = "FFFF7D0A",
	Evoker       = "FF33937F",
	Hunter 		 = "FFABD473",
	Mage 		 = "FF69CCF0",
	Monk 		 = "FF00FF96",
	Paladin 	 = "FFF58CBA",
	Priest 		 = "FFFFFFFF",
	Rogue 		 = "FFFFF569",
	Shaman 		 = "FF0070DE",
	Warlock 	 = "FF9482C9",
	Warrior 	 = "FFC79C6E",
};

AddonNamespace.TextIcons =
{
    GreenCheck = '\124A:ui-lfg-readymark-raid:13:13\124a',
    GreenCheckLite = '\124A:UI-LFG-ReadyMark:20:20\124a',
    QuestQuestion = '\124A:QuestTurnin:20:20\124a',
    QuestExclamation = '\124A:QuestNormal:20:20\124a',
    RoleIconTank = '\124A:groupfinder-icon-role-large-tank:20:20\124a',
    RoleIconHealer = '\124A:groupfinder-icon-role-large-healer:20:20\124a',
    RoleIconDps = '\124A:groupfinder-icon-role-large-dps:20:20\124a',
    RoleIconGeneric = '\124A:ui-lfg-roleicon-generic:20:20\124a',
    RoleIconPending = '\124A:ui-lfg-roleicon-pending:20:20\124a',
    Horde = '\124A:horde_icon_and_flag-icon:20:20\124a',
    Alliance = '\124A:alliance_icon_and_flag-icon:20:20\124a',
}

AddonNamespace.RaidMarkerValues =
{
    Star = 1,
    Circle = 2,
    Diamond = 3,
    Triangle = 4,
    Moon = 5,
    Square = 6,
    Cross = 7,
    Skull = 8,
}

AddonNamespace.RaidIcons =
{
	Star = "\124A:GM-raidMarker8:20:20\124a",
	Circle = "\124A:GM-raidMarker7:20:20\124a",
	Diamond = "\124A:GM-raidMarker6:20:20\124a",
	Triangle = "\124A:GM-raidMarker5:20:20\124a",
	Moon = "\124A:GM-raidMarker4:20:20\124a",
	Square = "\124A:GM-raidMarker3:20:20\124a",
	Cross = "\124A:GM-raidMarker2:20:20\124a",
	Skull = "\124A:GM-raidMarker1:20:20\124a",
}

--local horde_icon = "|TInterface/Icons/inv_bannerpvp_01:16:16|t";
--local alliance_icon = "|TInterface/Icons/inv_bannerpvp_02:16:16|t";
AddonNamespace.FactionIcons =
{
	["Alliance"] = "\124A:poi-alliance:20:20\124a",
	["Horde"] = "\124A:poi-horde:20:20\124a"
}

AddonNamespace.FactionColors =
{
	["Alliance"] = AddonNamespace.Colors.Alliance,
	["Horde"] = AddonNamespace.Colors.Horde
}

AddonNamespace.RoleIcons = {
	["TANK"] = "\124A:groupfinder-icon-role-large-tank:20:20\124a",
	["HEALER"] = "\124A:groupfinder-icon-role-large-heal:20:20\124a",
	["DAMAGER"] = "\124A:groupfinder-icon-role-large-dps:20:20\124a",
	["NONE"] = ""
}

AddonNamespace.Specializations = {
    -- Mage
    [62] = "Arcane",
    [63] = "Fire",
    [64] = "Frost",

    -- Paladin
    [65] = "Holy",
    [66] = "Protection",
    [70] = "Retribution",

    -- Warrior
    [71] = "Arms",
    [72] = "Fury",
    [73] = "Protection",

    -- Druid
    [102] = "Balance",
    [103] = "Feral",
    [104] = "Guardian",
    [105] = "Restoration",

    -- Death Knight
    [250] = "Blood",
    [251] = "Frost",
    [252] = "Unholy",

    -- Hunter
    [253] = "Beast Mastery",
    [254] = "Marksmanship",
    [255] = "Survival",

    -- Priest
    [256] = "Discipline",
    [257] = "Holy",
    [258] = "Shadow",

    -- Rogue
    [259] = "Assassination",
    [260] = "Outlaw",
    [261] = "Subtlety",

    -- Shaman
    [262] = "Elemental",
    [263] = "Enhancement",
    [264] = "Restoration",

    -- Warlock
    [265] = "Affliction",
    [266] = "Demonology",
    [267] = "Destruction",

    -- Monk
    [268] = "Brewmaster",
    [269] = "Windwalker",
    [270] = "Mistweaver",

    -- Demon Hunter
    [577] = "Havoc",
    [581] = "Vengeance",

    -- Evoker
    [1467] = "Devastation",
    [1468] = "Preservation",
    [1473] = "Augmentation"
}

AddonNamespace.SpecializationToRoleText = {
--[[ 
    from
    https://wowpedia.fandom.com/wiki/Specialization
]]--

	-- Mage
	[62] = "DAMAGER", -- Arcane
	[63] = "DAMAGER", -- Fire
	[64] = "DAMAGER", -- Frost

	-- Paladin
	[65] = "HEALER", -- Holy (Heal)
	[66] = "TANK", -- Protection (Tank)
	[70] = "DAMAGER", -- Retribution (DPS)

	-- Warrior
	[71] = "DAMAGER", -- Arms (DPS)
	[72] = "DAMAGER", -- Fury (DPS)
	[73] = "TANK", -- Protection (Tank)

	-- Hunter
	[253] = "DAMAGER", -- Beast Mastery
	[254] = "DAMAGER", -- Marksmanship
	[255] = "DAMAGER", -- Survival

	-- Priest
	[256] = "HEALER", -- Discipline (Heal)
	[257] = "HEALER", -- Holy (Heal)
	[258] = "DAMAGER", -- Shadow (DPS)

	-- Rogue
	[259] = "DAMAGER", -- Assassination
	[260] = "DAMAGER", -- Outlaw
	[261] = "DAMAGER", -- Subtlety

	-- Shaman
	[262] = "DAMAGER", -- Elemental (DPS)
	[263] = "DAMAGER", -- Enhancement (DPS)
	[264] = "HEALER", -- Restoration (Heal)

	-- Warlock
	[265] = "DAMAGER", -- Affliction
	[266] = "DAMAGER", -- Demonology
	[267] = "DAMAGER", -- Destruction

	-- Monk
	[268] = "TANK", -- Brewmaster (Tank)
	[269] = "DAMAGER", -- Windwalker (DPS)
	[270] = "HEALER", -- Mistweaver (Heal)

	-- Druid
	[102] = "DAMAGER", -- Balance (DPS Owl)
	[103] = "DAMAGER", -- Feral (DPS Cat)
	[104] = "TANK", -- Guardian (Tank Bear)
	[105] = "HEALER", -- Restoration (Heal)

	-- Death Knight
	[250] = "TANK", -- Blood (Tank)
	[251] = "DAMAGER", -- Frost (DPS)
	[252] = "DAMAGER", -- Unholy (DPS)

	-- Demon Hunter
	[577] = "DAMAGER", -- Havoc (DPS)
	[581] = "TANK", -- Vengeance (Tank)

	-- Evoker
	[1467] = "DAMAGER", -- Devastation (DPS)
	[1468] = "HEALER", -- Preservation (Heal)
	[1473] = "DAMAGER", -- Augmentation (DPS)
}

---@diagnostic disable-next-line: lowercase-global
function getClassIcon(class)
    return ("\124TInterface/Icons/classicon_%s:0\124t"):format(strlower(class))
end

---@diagnostic disable-next-line: lowercase-global
local function kprint(string, ...)
    if string ~= nil then
        if AddonNamespace.LibAceAddon:ShouldShowDebugOutput() then
            print(colorize(addonName..": ", AddonNamespace.Colors.Header)..colorize(string, AddonNamespace.Colors.White), ...)
    --     else
    --         print(addonName..": kprint disabled!")
        end
    -- else
    --     print(addonName..": kprint called with nil!")
    end
end
AddonNamespace.kprint = kprint

---@diagnostic disable-next-line: lowercase-global
function colorize(string, color)
    if color and string then
        return string.format("\124c%s%s\124r", color, string)
    else
        return string
    end
end

---@diagnostic disable-next-line: lowercase-global
function classToColor(class)
    local classToColorTable =
    {
        ["DEATHKNIGHT"] = AddonNamespace.Colors.DeathKnight,
        ["DEMONHUNTER"] = AddonNamespace.Colors.DemonHunter,
        ["DRUID"] = AddonNamespace.Colors.Druid,
        ["EVOKER"] = AddonNamespace.Colors.Evoker,
        ["HUNTER"] = AddonNamespace.Colors.Hunter,
        ["MAGE"] = AddonNamespace.Colors.Mage,
        ["MONK"] = AddonNamespace.Colors.Monk,
        ["PALADIN"] = AddonNamespace.Colors.Paladin,
        ["PRIEST"] = AddonNamespace.Colors.Priest,
        ["ROGUE"] = AddonNamespace.Colors.Rogue,
        ["SHAMAN"] = AddonNamespace.Colors.Shaman,
        ["WARLOCK"] = AddonNamespace.Colors.Warlock,
        ["WARRIOR"] = AddonNamespace.Colors.Warrior,
    }

    local color = classToColorTable[class]
    if color ~= nil then
        return color
    end

    return AddonNamespace.Colors.Grey
end

---@diagnostic disable-next-line: lowercase-global
function commaFormatInt(i)
    return tostring(i):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end