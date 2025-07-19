--[[-------------------------------------------------------------------------
	Addon Data Initialization
---------------------------------------------------------------------------]]

local addonName, Addon = ...
local kprint = Addon.kprint

local addonNameText = "KHorrificVisions"
local addonNameTextWithSpaces = "K Horrific Visions"
local addonNameTextWithIcon = "\124TInterface/Icons/inv_eyeofnzothpet:0\124t " .. addonNameTextWithSpaces
local addonIcon = [[Interface/Icons/inv_eyeofnzothpet]]

local addonTooltipName = "KHorrificVisionsTooltip"
local addonDBName = "KHorrificVisionsDB"
local addonOptionsDBName = "KHorrificVisions"
local addonOptionsDBShortName = "ksa"

-- TODO: localization
--local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local libIcon = LibStub("LibDBIcon-1.0", true)
local LibAceAddon = LibStub("AceAddon-3.0"):NewAddon(addonNameText, "AceConsole-3.0", "AceEvent-3.0")
local LibQTip = LibStub('LibQTip-1.0')
local LibDataBroker = LibStub("LibDataBroker-1.1")

Addon.LibAceAddon = LibAceAddon
Addon.LibQTip = LibQTip

--[[-------------------------------------------------------------------------
	AceAddon / AceOptions initialization
---------------------------------------------------------------------------]]

function LibAceAddon:GetDBDataVersion()
    if self.db.profile.dataVersion == nil then
        return "0.0.0"
    end
    return self.db.profile.dataVersion
end

Addon.AceOptions = {
    name = addonNameTextWithIcon,
    handler = LibAceAddon,
    type = "group",
    args = {
        enableMinimapButton = {
            type = "toggle",
            width = "full",
            order = 1,
            name = "Hide minimap button",
            desc = "Toggles the visibility of the minimap icon for this addon.",
            get = "ShouldHideMinimapButton",
            set = "ToggleMinimapButton",
        },
        showDebugOutput = {
            type = "toggle",
            width = "full",
            order = 89,
            name = "Show debug output in chat",
            desc = "Toggles the display debugging Text in the chat window. " .. colorize("Recommended to leave off.", Addon.Colors.Red),
            get = "ShouldShowDebugOutput",
            set = "ToggleShowDebugOutput",
            confirm = true
        },
    },
}

Addon.AceOptionsDefaults = {
    profile =  {
        showDebugOutput = false,
    },
    global = {
        minimap = {
            hide = false,
            lock = false,
            radius = 90,
            minimapPos = 200
        }
    }
}

function LibAceAddon:OpenHandynotesSettings()
end

function LibAceAddon:ShouldHideMinimapButton(info)
    return self.db.global.minimap.hide
end

function LibAceAddon:ToggleMinimapButton(info, value)
    self.db.global.minimap.hide = value
    if value then
        libIcon:Hide(addonNameText)
    else
        libIcon:Show(addonNameText)
    end
end

-- function LibAceAddon:ShouldFitToScreen(info)
--     return self.db.profile.fitToScreen
-- end

-- function LibAceAddon:ToggleFitToScreen(info, value)
--     self.db.profile.fitToScreen = value
-- end

function LibAceAddon:ShouldShowDebugOutput(info)
    return self.db.profile.showDebugOutput
end

function LibAceAddon:ToggleShowDebugOutput(info, value)
    self.db.profile.showDebugOutput = value
end

--[[-------------------------------------------------------------------------
	Tooltip Callback Methods
---------------------------------------------------------------------------]]

local function tipOnClick(clickedframe, button)
    if button == "LeftButton" then
        if IsAltKeyDown() or IsControlKeyDown() then
            Addon.HorrificVisionsFrame:ResetBoxes()
        else
            if Addon.HorrificVisionsFrame.frame:IsVisible() then
                Addon.HorrificVisionsFrame.frame:Hide()
            else
                Addon.HorrificVisionsFrame.frame:Show()
            end
        end
    elseif button == "RightButton" then
        Settings.OpenToCategory(addonNameTextWithSpaces)
    end
end

local function tipOnEnter(self)
    if self.tooltip then
        self.tooltip:Release()
        self.tooltip = nil
    end

    local tooltip = LibQTip:Acquire(addonTooltipName, 2, "LEFT", "LEFT")
    self.tooltip = tooltip

    --
    -- Call addons specific code to populate the tooltip content
    --
    Addon.PopulateTooltip(tooltip)

	tooltip:SetAutoHideDelay(0.01, self)
    tooltip:SmartAnchorTo(self)

    tooltip:UpdateScrolling()

    tooltip:Show()
end

local function tipOnLeave(self)
    -- Do nothing intentionally
end

--[[-------------------------------------------------------------------------
	Addon Initialize
---------------------------------------------------------------------------]]

local function GetCurrentDataVersion()
    return C_AddOns.GetAddOnMetadata(addonNameText, "X-Nominal-Version")
end

function LibAceAddon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New(addonDBName, Addon.AceOptionsDefaults, true)
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonNameText, Addon.AceOptions, {addonOptionsDBName, addonOptionsDBShortName})
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonNameText, addonNameTextWithSpaces)

    self.db.profile.dataVersion = GetCurrentDataVersion()

    local dataobj = LibDataBroker:NewDataObject(addonNameText, {
        type = "launcher",
        icon = addonIcon,
        OnClick = tipOnClick,
        OnLeave = tipOnLeave,
        OnEnter = tipOnEnter
    })

    libIcon:Register(addonNameText, dataobj, self.db.global.minimap)

    --
    -- Call Addon Initialize from addon specific code
    --
    Addon.Initialize()
    if Addon.RegisterWithHandyNotes then
        Addon.RegisterWithHandyNotes()
    end
end