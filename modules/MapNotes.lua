--[[-------------------------------------------------------------------------
    Addon Initialization
---------------------------------------------------------------------------]]

local addonName, KHorrificVisions = ...
local kprint = KHorrificVisions.kprint

local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
if not HandyNotes then return end


--[[-------------------------------------------------------------------------
    Map Toggle Commands
---------------------------------------------------------------------------]]

-- Toggle Orgrimmar map
-- /run WorldMapFrame:Show(); WorldMapFrame:SetMapID(2403)

-- Toggle Stormwind map
-- /run WorldMapFrame:Show(); WorldMapFrame:SetMapID(2404)


--[[-------------------------------------------------------------------------
    Icon Definitions
---------------------------------------------------------------------------]]

local icons = {
    -- Minimap tracking icons
    MINIMAP_TRACKING_AUCTIONEER = "Interface\\Minimap\\Tracking\\Auctioneer",
    MINIMAP_TRACKING_BANKER = "Interface\\Minimap\\Tracking\\Banker",
    MINIMAP_TRACKING_BATTLEMASTER = "Interface\\Minimap\\Tracking\\BattleMaster",
    MINIMAP_TRACKING_FLIGHTMASTER = "Interface\\Minimap\\Tracking\\FlightMaster",
    MINIMAP_TRACKING_INNKEEPER = "Interface\\Minimap\\Tracking\\Innkeeper",
    MINIMAP_TRACKING_MAILBOX = "Interface\\Minimap\\Tracking\\Mailbox",
    MINIMAP_TRACKING_REPAIR = "Interface\\Minimap\\Tracking\\Repair",
    MINIMAP_TRACKING_STABLEMASTER = "Interface\\Minimap\\Tracking\\StableMaster",
    MINIMAP_TRACKING_TRAINER_CLASS = "Interface\\Minimap\\Tracking\\Class",
    MINIMAP_TRACKING_TRAINER_PROFESSION = "Interface\\Minimap\\Tracking\\Profession",
    MINIMAP_TRACKING_TRIVIAL_QUESTS = "Interface\\Minimap\\Tracking\\TrivialQuests",
    MINIMAP_TRACKING_VENDOR_AMMO = "Interface\\Minimap\\Tracking\\Ammunition",
    MINIMAP_TRACKING_VENDOR_FOOD = "Interface\\Minimap\\Tracking\\Food",
    MINIMAP_TRACKING_VENDOR_POISON = "Interface\\Minimap\\Tracking\\Poisons",
    MINIMAP_TRACKING_VENDOR_REAGENT = "Interface\\Minimap\\Tracking\\Reagents",

    -- Faction icons
    FACTION_ALLIANCE = "Interface\\TargetingFrame\\UI-PVP-Alliance",
    FACTION_HORDE = "Interface\\TargetingFrame\\UI-PVP-Horde",
    FACTION_STANDING_LABEL4 = "Interface\\TargetingFrame\\UI-PVP-FFA",

    -- Other UI icons
    ARENA = "Interface\\PVPFrame\\PVP-ArenaPoints-Icon",
    PORTAL = "Interface\\Icons\\Spell_Arcane_PortalDalaran",
    ZARHAAL = "Interface\\Icons\\Ability_racial_etherealconnection",
    ODD_CRYSTAL = "Interface\\Icons\\Inv_misc_gem_bloodgem_02",

    -- Custom addon assets
    TRASH_CAN = "Interface\\AddOns\\KHorrificVisions\\assets\\trash",
    FOOD = "Interface\\AddOns\\KHorrificVisions\\assets\\food",
    NOTE = "Interface\\AddOns\\KHorrificVisions\\assets\\note",
    BAD_POTION = "Interface\\AddOns\\KHorrificVisions\\assets\\badpotion",
    COMBAT_BUFF = "Interface\\AddOns\\KHorrificVisions\\assets\\combatbuff",

    DEATHCYCLE = "Interface\\Icons\\inv_motorcyclefelreavermount_shadow",
    MANIFOLD = "Interface\\Icons\\inv_10_engineering_manufacturedparts_mechanicalparts_color1",
    ENGINE_BLOCK = "Interface\\Icons\\ability_vehicle_siegeengineram",
    GRYPHON = "Interface\\Icons\\inv_misc_elitegryphon",
    WINDRIDER = "Interface\\Icons\\ability_mount_wyvern_01",
    WOLF = "Interface\\Icons\\ability_mount_blackdirewolf",
    PANTHER = "Interface\\Icons\\ability_mount_onyxpanther_black",
    STALLION = "Interface\\Icons\\ability_mount_nightmarehorse",
    BLACK_BLOOD_BAR = "Interface\\Icons\\inv_blacksmithing_70_demonsteelbar",
}

local iconCategories =
{
	Potions = "Potions",
	Mailboxes = "Mailboxes",
	Mounts = "Mounts",
	Buffs = "Buffs",
	Crystals = "Crystals"
}


--[[-------------------------------------------------------------------------
    Common Tables
---------------------------------------------------------------------------]]

local function addNamedValueToTable(sourceTable, title, subTitle)
    -- Create a shallow copy of the sourceTable
    local newTable = {}

    for key, value in pairs(sourceTable) do
        newTable[key] = value
    end

    -- Assign values only if they are provided
    if title then newTable.title = title end
    if subTitle then newTable.subTitle = subTitle end

    return newTable
end

local function createCommonEntry(icon, category, title, explainer, scale, alpha)
    return { icon = icon, category = category, scale = scale or 1.2, alpha = alpha or 1.0, title = title, explainer = explainer }
end


--[[-------------------------------------------------------------------------
    Common Tables
---------------------------------------------------------------------------]]

local Potion = createCommonEntry(icons.BAD_POTION, iconCategories.Potions, "Bad Potion", "This potion removes 100 sanity. The rest are safe.")

local Deathcycle = createCommonEntry(icons.DEATHCYCLE, iconCategories.Mounts, "Voidfire Deathcycle", "Killing the Deathcycle and it's rider, Haymar the Devout, will\nallow you to begin the journey to collecting the parts needed to build the\nmount. After defeating them both, click the bike again and send it to Dornogal,\nwhere it will give you hints on how to compelte it.\n\nRequires at least 1 mask active to see.")
local Manifold = createCommonEntry(icons.MANIFOLD, iconCategories.Mounts, "Magic-Lined Manifold", "Looted at the entrance of the Auction House in the Trade\nDistrict area of Vision of Stormwind.\n\nRequires at least 1 mask active to see and\nthe Deathcycle defeated.")
local EngineBlock = createCommonEntry(icons.MANIFOLD, iconCategories.Mounts, "Void-Forged Engine Block", "Looted inside the Engineering shop in the Drag\narea of Vision of Orgrimmar.\n\nRequires at least 1 mask active to see and\nthe Deathcycle defeated in Stormwind.")

local Mail = createCommonEntry(icons.MINIMAP_TRACKING_MAILBOX, iconCategories.Mailboxes, "Mailbox", "Chance to summon Mail Muncher, which has\na 100% chance to drop itself as a mount.")

local Horseshoe = createCommonEntry(icons.MINIMAP_TRACKING_STABLEMASTER, iconCategories.Mounts, "Horseshoe", "Collect all 4, use them at the anvil in Dwarven District for Void-Forged Stallion mount.")
local HorseshoeForge = createCommonEntry(icons.STALLION, iconCategories.Mounts, "Anvil", "Use collected horseshoes here to summon Void-Forged Stallion.")

local TrashPile = createCommonEntry(icons.TRASH_CAN, iconCategories.Mounts, "Trash Pile", "Chance to summon Nesting Swarmite, which has\na 100% chance to drop itself as a mount.")

local Gryphon = createCommonEntry(icons.GRYPHON, iconCategories.Mounts, "Claw Marked Bowl", "Place food in the bowl to summon Void-Scarred Gryphon (requires 2 masks).")
local GryphonNote = createCommonEntry(icons.NOTE, iconCategories.Mounts, "Ripped Note", "Explains the food required for Claw Marked Bowl (requires 2 masks).")

local BigKeech = createCommonEntry(icons.PANTHER, iconCategories.Mounts, "Big Keech", "Drops two items for crafting the Void-Crystal Panther:\nDesign: Void-Crystal Panther (Jewelcrafters only)\nVoid-Bound Orb of Mystery (everyone)\n\nRequires at least one mask to be active.")
local BlackBloodBar = createCommonEntry(icons.BLACK_BLOOD_BAR, iconCategories.Mounts, "Black Blood Infused Bar", "Looted from Black Blood Infused Bar, two are needed\nto craft the Void-Crystal Panther. There is one in\nStormwind and one in Orgrimmar.")

local Wolf = createCommonEntry(icons.MINIMAP_TRACKING_STABLEMASTER, iconCategories.Mounts, "Wolf", "Acquire 2 stacks of Tattered Wolf Rider Gear, then burn the rug\nin Leatherworking shop in the Drag to summon Void-Scarred Pack Mother.\n\nRequires 1 mask to be active.")
local WolfRug = createCommonEntry(icons.WOLF, iconCategories.Mounts, "Wolf Rug", "With 2 stacks of Tattered Wolf Rider Gear, burn the rug in this building to\nsummon the Void-Scarred Pack Mother.\n\nRequires 1 mask to be active.")

local Windrider = createCommonEntry(icons.WINDRIDER, iconCategories.Mounts, "Void-Scarred Wyvern", "After clearing Valley of Wisdom, take the\nelevetor up and defeat three waves of enemies to get the\nReins of the Void-Scarred Windrider.\n\nRequires 3 masks to be active.")

local CombatBuff = createCommonEntry(icons.COMBAT_BUFF, iconCategories.Buffs, "Buff", "Only two combat buffs will be available per run.", 2.5)

local OddCrystal = createCommonEntry(icons.ODD_CRYSTAL, iconCategories.Crystals, "Odd Crystal", "Trade these in for Corrupted Mementos with Zarhaal in the visions.\nOnly 10 in total will be available at a time, 2 per area.")
local Zarhaal = createCommonEntry(icons.ZARHAAL, iconCategories.Crystals, "Zarhaal", "Turn in Odd Crystals to him in exchange for Corrupted Mementos.")


--[[-------------------------------------------------------------------------
    Node Data for Horrific Visions
---------------------------------------------------------------------------]]

local nodes = {
    [2404] = { -- Revisited Stormwind

        -- Bad Potion Location (Avoid This!)
        [51765852] = addNamedValueToTable(Potion, "Bad Potion", "Drinking this potion will remove 100 sanity. Located near\nMorgan Pestle at the back of the starting road."),

        -- Mailbox Locations (Chance to Summon Mail Muncher)
        [49688700] = Mail, -- Mage Quarter
        [54635751] = Mail, -- Trade District
        [61687604] = Mail, -- Cathedral Square
        [62073082] = Mail, -- Dwarven District
        [75716456] = Mail, -- Old Town

        -- Trash Pile Locations (Chance to Summon Nesting Swarmite)
		-- https://www.wowhead.com/news/how-to-obtain-mounts-in-the-horrific-vision-of-stormwind-void-scarred-gryphon-376851#nesting-swarmite
        [55804930] = TrashPile, -- Trade District
        [62903070] = TrashPile, -- Old Town
        [73606270] = TrashPile, -- Dwarven District
        [66107630] = TrashPile, -- Cathedral Square
        [52607730] = TrashPile, -- Mage Quarter

        -- Horseshoe Locations (Required to Summon Void-Forged Stallion)
		-- https://www.wowhead.com/news/how-to-obtain-mounts-in-the-horrific-vision-of-stormwind-void-scarred-gryphon-376851#void-forged-stallions-reins
        [56005550] = addNamedValueToTable(Horseshoe, "Cathedral Horseshoe", "Found on a grassy patch southeast of the Cathedral fountain."),
        [75505670] = addNamedValueToTable(Horseshoe, "Old Town Horseshoe", "Located just outside the entrance of Pig and Whistle Tavern."),
        [61507550] = addNamedValueToTable(Horseshoe, "Trade District Horseshoe", "Next to the mailbox between the Bank and the Inn."),
        [50908400] = addNamedValueToTable(Horseshoe, "Mage Quarter Horseshoe", "Near Larson Clothiers store entrance."),
        [63003730] = HorseshoeForge, -- Location where horseshoes are used

        -- Gryphon Mount Locations (Void-Scarred Gryphon)
		-- https://www.wowhead.com/news/how-to-obtain-mounts-in-the-horrific-vision-of-stormwind-void-scarred-gryphon-376851#reins-of-the-void-scarred-gryphon
		-- https://www.method.gg/guides/mounts/void-scarred-gryphon-mount
        [67607300] = Gryphon, -- Claw Marked Bowl Location
        [66007177] = addNamedValueToTable(GryphonNote, nil, "Located before Inquisitor Darkspeak, near the buildings on the right."),
        [68217296] = addNamedValueToTable(GryphonNote, nil, "Found after Inquisitor Darkspeak, at the top of the stairs."),

        -- Buff Locations (Permanent Buffs During Vision)
		-- https://www.wowhead.com/news/learn-how-to-obtain-hidden-buffs-in-the-vision-of-stormwind-376973
        [57604960] = addNamedValueToTable(CombatBuff, "10% Haste Buff", "Step on the bear rug and defeat three waves of mobs to receive the Bear Spirit buff."),
        [54205780] = addNamedValueToTable(CombatBuff, "7% Versatility Buff", "Defeat Agustus Moulaine inside the shop to receive the Requited Bulwark buff."),
        [60303690] = addNamedValueToTable(CombatBuff, "10% Damage Buff", "Carefully navigate past the mines and step on the green mine at the top to receive the Empowered buff."),
        [62307690] = addNamedValueToTable(CombatBuff, "10% Crit Chance Buff", "Defeat the Neglected Guild Bank inside the back of Stormwind bank to receive the Enriched buff."),

        -- Voidfire Deathcycle Mount Locations
        [62103034] = Deathcycle,
        [61507270] = Manifold,

        -- Void-Crystal Panther Mount Locations
        [63703710] = addNamedValueToTable(BlackBloodBar, nil, "By the anvil."),

        -- Odd Crystal Locations
		-- https://www.wowhead.com/guide/horrific-vision-odd-crystal-locations-stormwind-orgrimmar
		[57304790] = addNamedValueToTable(Zarhaal, "Zarhaal", "Located inside a side building"),
		[54605940] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Behind boxes."),
		[53005190] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Hidden left of the Cathedral entrance."),
		[58405510] = addNamedValueToTable(OddCrystal, "Odd Crystal", "On top of a hill."),
		[64603090] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Corner behind boxes."),
		[62703700] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Corner by the middle forge."),
		[63404170] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Corner by chest spawn."),
		[67304470] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Beside the boss forge."),
		[69007310] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Behind Inquisitor, left of stairs."),
		[62007690] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Behind the Mail Muncher mailbox."),
		[66107570] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Behind a destroyed cart."),
		[60406880] = addNamedValueToTable(OddCrystal, "Odd Crystal", "In the corner of an alleyway."),
		[75605340] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Inside the bar, upper level."),
		[75606460] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Behind the Mail Muncher mailbox."),
		[74605920] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Middle area behind boxes."),
		[76506850] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Behind stables near Shaw."),
		[47408160] = addNamedValueToTable(OddCrystal, "Odd Crystal", "In transition house behind the counter."),
		[44208790] = addNamedValueToTable(OddCrystal, "Odd Crystal", "On the upper walkway in the corner."),
		[47708940] = addNamedValueToTable(OddCrystal, "Odd Crystal", "On a platform above the upper walkway."),
		[52408340] = addNamedValueToTable(OddCrystal, "Odd Crystal", "In transition house behind the counter.")
    },

    [2403] = { -- Revisited Orgrimmar

        -- Bad Potion Location (Avoid This!)
        [46828078] = addNamedValueToTable(Potion, "Bad Potion", "Found inside the second hut to the left of the starting area,\nnear the dead Voidbound Ravager."),

        -- Mailbox Locations (Chance to Summon Mail Muncher)
        [39304900] = Mail, -- Valley of Strength
        [39708030] = Mail, -- Valley of Spirits
        [52707580] = Mail, -- Valley of Wisdom
        [60105130] = Mail, -- Valley of Honor
        [67673924] = Mail, -- The Drag

        -- Trash Pile Locations (Chance to Summon Nesting Swarmite)
		-- https://www.wowhead.com/news/how-to-obtain-mounts-in-the-horrific-vision-of-stormwind-void-scarred-gryphon-376851#nesting-swarmite
        [47607450] = TrashPile, -- Valley of Strength
        [40307940] = TrashPile, -- Valley of Spirits
        [50804510] = TrashPile, -- Valley of Wisdom
        [69004970] = TrashPile, -- Valley of Honor
        [57406080] = TrashPile, -- The Drag

        -- Wolf Mount Locations (Void-Scarred Pack Mother)
        [59505400] = WolfRug,
        [67203620] = addNamedValueToTable(Wolf, nil, "Worn Wolf Saddle is inside the Auction House, near the right side of the auctioneer."),
        [39204950] = addNamedValueToTable(Wolf, nil, "Bag of Wolf Tack is beside the main tent building, behind the Voidcrazed Hulk."),

        -- Void-Crystal Panther Mount Locations
        [70503320] = BigKeech,
        [45005270] = addNamedValueToTable(BlackBloodBar, nil, "By an altar surrounded by corrupted mobs."),

        -- Void-Scarred Windrider
        [46075280] = Windrider,

        -- Voidfire Deathcycle Mount Locations
        [56905680] = EngineBlock,

        -- Buff Locations (Permanent Buffs During Vision)
		-- https://www.wowhead.com/news/horrific-vision-of-orgrimmar-what-npcs-provide-buffs-311412
        [32106430] = addNamedValueToTable(CombatBuff, "10% Haste & Movement Speed Buff", "Defeat Bwemba to receive the Spirit of Wind buff. Only available if Warpweaver Dushar is NOT up."),
        [44667697] = addNamedValueToTable(CombatBuff, "10% Damage Buff", "Defeat Naros to receive the Smith's Strength buff. Only available if Gamon is NOT up."),
        [54277833] = addNamedValueToTable(CombatBuff, "10% Health Buff", "Defeat Gamon to receive the Heroes' Bulwark buff. Only available if Naros is NOT up."),
        [57676513] = addNamedValueToTable(CombatBuff, "10% Crit Chance Buff", "Defeat Warpweaver Dushar to receive the Spirit of Wind buff. Only available if Bwemba is NOT up."),

        -- Odd Crystal Locations
		-- https://www.wowhead.com/guide/horrific-vision-odd-crystal-locations-stormwind-orgrimmar
		[54007100] = addNamedValueToTable(Zarhaal, "Zarhaal", "Located behind the Auction House"),
		[53508200] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Inside the first hut on the right."),
		[49406870] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Hidden behind boxes."),
		[48708380] = addNamedValueToTable(OddCrystal, "Odd Crystal", "In the bank, behind the counter."),
		[57706510] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Inside the Transmog hut."),
		[57605860] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Inside the Orphanage."),
		[60405510] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Inside the Leatherworking hut."),
		[57904860] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Inside the hut behind the Inquisitor."),
		[33406570] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Center building, bottom floor."),
		[35406940] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Top floor of the building."),
		[37908450] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Behind the pillar in the hut behind the Embassy."),
		[38508070] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Inside the Embassy."),
		[65805060] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Inside the cacti."),
		[68204290] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Underneath the bridge."),
		[67003740] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Inside the Auction House."),
		[63903040] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Go right behind Rexxar's building."),
		[38904990] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Left in the big tent."),
		[41704480] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Inside the first hut on the right."),
		[48404410] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Up the hill."),
		[51004520] = addNamedValueToTable(OddCrystal, "Odd Crystal", "Between the pillar and boxes.")
    }
}


--[[-------------------------------------------------------------------------
	Handynotes Hooks
---------------------------------------------------------------------------]]

local HandyNotesHandler = {}

function HandyNotesHandler:OnEnter(uMapID, coord)
	if ( self:GetCenter() > UIParent:GetCenter() ) then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

	local mapNode = nodes[uMapID][coord]
	--DevTools_Dump(mapNode)

    GameTooltip:AddLine(mapNode.title)
	if mapNode.subTitle then
    	GameTooltip:AddLine(mapNode.subTitle)
	end

	if mapNode.explainer then
    	GameTooltip:AddLine("\n"..mapNode.explainer)
	end

    GameTooltip:Show()
end

function HandyNotesHandler:OnLeave()
    GameTooltip:Hide()
end

function HandyNotesHandler:OnClick()
    GameTooltip:Hide()
end

local function iterator(table, prev)
	if not table then return end
	local LibAceAddon = KHorrificVisions.LibAceAddon

	local coord, value = next(table, prev)
	while coord do
		if value then
			local category = value.category
			if LibAceAddon.db.profile["show_" .. category] then
				-- An iterator function that will loop over and return 5 values
				-- (coord, mapFile, iconpath, scale, alpha, dungeonLevel)
				-- for every node in the requested zone. If the mapFile return value is nil, we assume it is the
				-- same mapFile as the argument passed in. Mainly used for continent mapFile where the map passed
				-- in is a continent, and the return values are coords of subzone maps. If the return dungeonLevel
				-- is nil, we assume it is the same as the argument passed in.
				--print("value in table: ", coord, nil, value.icon, value.scale, value.alpha)
				return coord, nil, value.icon, value.scale, value.alpha
			end
		end
		coord, value = next(table, coord)
	end
end

function HandyNotesHandler:GetNodes2(uiMapId, minimap)
	--print("requested mapID", uiMapId)
    return iterator, nodes[uiMapId], nil
end

local HandyNotesOptions = {
	type = "group",
	name = "K Horrific Visions",
	desc = "Enable or disable icons in the Horrific Visions",
    args = {},
}

local function CreateCatagorySettings()
	local LibAceAddon = KHorrificVisions.LibAceAddon

    -- Ensure args table is initialized
    HandyNotesOptions.args = HandyNotesOptions.args or {}

	for category, name in pairs(iconCategories) do
		local key = "show_"..name

        -- Ensure default value exists
        if LibAceAddon.db.profile[key] == nil then
            LibAceAddon.db.profile[key] = true
        end

        -- Add new entries without overwriting existing ones
        if not HandyNotesOptions.args[key] then
            HandyNotesOptions.args[key] = {
                type = "toggle",
                width = "full",
                name = "Show "..category.." icons on the map",
                desc = "Toggles the display of "..category.." icons in the Horrific Visions map",
                get = function(info) return LibAceAddon.db.profile[key] end,
                set = function(info, value) LibAceAddon.db.profile[key] = value end,
            }
        end
	end
end

function RegisterWithHandyNotes()
	CreateCatagorySettings()
    HandyNotes:RegisterPluginDB("KHorrificVisionsHandyNotesAddon", HandyNotesHandler, HandyNotesOptions)

    KHorrificVisions.AceOptions.args.openHandyNotesText = {
        type = "description",
        order = 90,
        name = "Map options are available in the HandyNotes settings, if installed.",
        fontSize = "medium",
    }

    KHorrificVisions.AceOptions.args.openHandynotes = {
        type = "execute",
        order = 91,
        name = "Open HandyNotes",
        func = function() Settings.OpenToCategory("HandyNotes") end,
    }
end
KHorrificVisions.RegisterWithHandyNotes = RegisterWithHandyNotes