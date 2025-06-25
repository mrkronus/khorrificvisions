local addonName, KHorrificVisions = ...
local kprint = KHorrificVisions.kprint
--local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--[[-------------------------------------------------------------------------
    Constants and Configuration
---------------------------------------------------------------------------]]

local THEME         = KHorrificVisions.UI.UIThemeColors
local POTION_COLORS = KHorrificVisions.UI.PotionColors
local FRAME         = KHorrificVisions.UI.Frame

local FRAME_SIZE    = { width = 350, height = 150 }
local TITLE_OFFSET  = { x = 0, y = -8 }

local TEXT_TITLE_DEFAULT    = "Select a color to mark the bad potion"
local TEXT_TITLE_BAD_POTION = " is the bad one!"
local RESET_TOOLTIP_TEXT    = "Reset Potion Colors"
local BAD_POTION_BOX_TEXT   = "Bad"

local POTION_BOX_SPACING    = 10
local POTION_BOX_SIZE       = { width = 55, height = 25 }
local NORMAL_POTION_FONT    = { file = "Fonts\\FRIZQT__.TTF", size = 14 }
local BAD_POTION_FONT       = { file = "Fonts\\FRIZQT__.TTF", size = 16, effect = "OUTLINE" }

-- https://www.icy-veins.com/wow/horrific-visions-potions-guide#which-color-does-what
local potionColorStatusMappings = {
    Good   = { Black = "Green", Green = "Red", Red = "Blue", Blue = "Purple", Purple = "Black" },
    Sick   = { Black = "Red", Blue = "Green", Green = "Purple", Purple = "Green", Red = "Purple" },
    Slug   = { Black = "Blue", Blue = "Red", Green = "Black", Purple = "Red", Red = "Black" },
    Spicy  = { Black = "Purple", Blue = "Black", Green = "Blue", Purple = "Blue", Red = "Green" }
}

-- https://www.wowhead.com/news/pick-up-100-sanity-potions-in-horrific-visions-376961
local potionBuffSpellIDs = {
    -- Sickening Potion: https://www.wowhead.com/spell=315849/sickening-potion
    Sick = { id = 315849, icon = "spell_nature_sicklypolymorph", title = "Sickening Potion", shortDesc = "5% less damage",
        desc = "Take 5% less damage from all sources. On expiration or removal you will Vomit uncontrollably for a short time."
    },

    -- Sluggish Potion: https://www.wowhead.com/spell=315845/sluggish-potion
    Slug = { id = 316100, icon = "spell_nature_slow", title = "Sluggish Potion", shortDesc = "2% heal / 5 sec",
        desc = "Heals 2% of maximum health every 5 seconds. On expiration or removal will slow movement speed for a short time."
    },

    -- Spicy Potion: https://www.wowhead.com/spell=315817/spicy-potion
    Spicy = { id = 315817, icon = "ability_monk_breathoffire", title = "Spicy Potion", shortDesc = "breath fire",
        desc = "Frequently breath fire dealing damage to nearby enemies. On expiration or removal you will catch fire yourself for a short time."
    }
}

-- This is the value the game does the screen effect at
local LOW_POWER_THRESHOLD = 200

-- MapIds for valid Horrific Visions maps
-- https://wago.tools/db2/UiMap?filter%5BName_lang%5D=vision&page=1
local validVisionsMapIDs = {
    [1379] = true, -- 8.3 Visions of N'Zoth - Prototype
    [1469] = true, -- BFA Vision of Orgrimmar
    [1470] = true, -- BFA Vision of Stormwind
    [2403] = true, -- Revisited Vision of Orgrimmar
    [2404] = true, -- Revisited Vision of Stormwind
}


--[[-------------------------------------------------------------------------
    HorrificVisionsUI Base Frame/Class
---------------------------------------------------------------------------]]

local StoryUI = KHorrificVisions.StoryUIFrame

local HorrificVisionsUI = {}
HorrificVisionsUI.__index = HorrificVisionsUI

function HorrificVisionsUI:new()
    local self = setmetatable({}, HorrificVisionsUI)

    -- Create main UI frame
    self.frame = CreateFrame("Frame", "KHorrificVisionsFrame", UIParent, "BackdropTemplate")
    self.frame:SetSize(FRAME_SIZE.width, FRAME_SIZE.height)
    self.frame:SetPoint("CENTER")
    self:SetupFrameAppearance()

    -- Title Text
    self.titleText = self:CreateTextElement(self.frame, TEXT_TITLE_DEFAULT, "GameFontHighlight", 14, THEME.TITLE_TEXT_COLOR, "TOP", TITLE_OFFSET.x, TITLE_OFFSET.y)

    -- Buttons
    self.closeButton = self:CreateIconButton(
        "KHorrificVisionsFrameCloseButton", 10,
        {"TOPRIGHT", self.frame, "TOPRIGHT", -8, -8},
        "Interface/AddOns/KHorrificVisions/assets/close", THEME.CLOSE_NORMAL_COLOR, THEME.CLOSE_HOVER_COLOR,
        FRAME.CLOSE_TOOLTIP_TEXT, function() self.frame:Hide() end
    )

    self.resetButton = self:CreateIconButton(
        "KHorrificVisionsFrameResetButton", 14,
        {"RIGHT", self.closeButton, "LEFT", -FRAME.BUTTON_SPACING, 0},
        "Interface/AddOns/KHorrificVisions/assets/reset", THEME.RESET_NORMAL_COLOR, THEME.RESET_HOVER_COLOR,
        RESET_TOOLTIP_TEXT, function() self:ResetBoxes() end
    )

    self.hiddenButton = self:CreateTransparentButton(
        "KHorrificVisionsFrameHiddenButton", 16,
        {"TOPLEFT", self.frame, "TOPLEFT", 8, -8},
        function() if StoryUI.frame then StoryUI.frame:Show() end end
    )

    -- Create potion selection boxes
    self.boxes = {}
    for i, color in ipairs(POTION_COLORS) do
        self:CreatePotionBox(color, i)
    end

    -- kick off inital update
    self:UpdatePartyFrames()
    self:RegisterEvents()

    return self
end

function HorrificVisionsUI:SetupFrameAppearance()
    self.frame:SetBackdrop(FRAME.BACKDROP_CONFIG)
    self.frame:SetBackdropColor(THEME.BACKDROP_COLOR.r, THEME.BACKDROP_COLOR.g, THEME.BACKDROP_COLOR.b, THEME.BACKDROP_COLOR.a)
    self.frame:SetBackdropBorderColor(THEME.BORDER_COLOR.r, THEME.BORDER_COLOR.g, THEME.BORDER_COLOR.b, THEME.BORDER_COLOR.a)
    self.frame:SetMovable(true)
    self.frame:EnableMouse(true)
    self.frame:RegisterForDrag("LeftButton")
    self.frame:SetScript("OnDragStart", function() self.frame:StartMoving() end)
    self.frame:SetScript("OnDragStop", function() self.frame:StopMovingOrSizing() end)
    self.frame:Hide()
end

function HorrificVisionsUI:CreateTextElement(parent, text, font, size, color, point, offsetX, offsetY)
    local textElement = parent:CreateFontString(nil, "OVERLAY", font)
    textElement:SetPoint(point, parent, point, offsetX, offsetY)
    textElement:SetTextColor(color.r, color.g, color.b, color.a)
    textElement:SetFont(font, size)
    textElement:SetText(text)
    return textElement
end

function HorrificVisionsUI:CreateIconButton(name, size, point, texture, normalColor, hoverColor, tooltipText, onClick)
    local button = CreateFrame("Button", name, self.frame)
    button:SetSize(size, size)
    button:SetPoint(unpack(point))

    button.Icon = button:CreateTexture("$parentIcon", "ARTWORK")
    button.Icon:SetAllPoints(button)
    button.Icon:SetTexture(texture)
    button.Icon:SetVertexColor(normalColor.r, normalColor.g, normalColor.b, normalColor.a)

    button:SetScript("OnEnter", function()
        button.Icon:SetVertexColor(hoverColor.r, hoverColor.g, hoverColor.b, hoverColor.a)
        GameTooltip:SetOwner(button, "ANCHOR_TOP")
        GameTooltip:SetText(tooltipText, 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function()
        button.Icon:SetVertexColor(normalColor.r, normalColor.g, normalColor.b, normalColor.a)
        GameTooltip:Hide()
    end)

    if onClick then
        button:SetScript("OnClick", onClick)
    end

    return button
end

function HorrificVisionsUI:CreateTransparentButton(name, size, point, onClick)
    local button = CreateFrame("Button", name, self.frame)
    button:SetSize(size, size)
    button:SetPoint(unpack(point))
    button.bg = button:CreateTexture(nil, "BACKGROUND")
    button.bg:SetAllPoints()
    button.bg:SetColorTexture(1, 1, 1, 0)

    button:SetScript("OnEnter", function()
        GameTooltip:SetOwner(button, "ANCHOR_TOP")
        GameTooltip:SetText("|cffFF5500His |cFFD5D500eyes|r are everywhere|r", 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    if onClick then
        button:SetScript("OnClick", onClick)
    end
    return button
end

--[[-------------------------------------------------------------------------
	Potion Boxes
---------------------------------------------------------------------------]]

function HorrificVisionsUI:CreatePotionBox(color, index)
    local box = CreateFrame("Button", "Box" .. color.name, self.frame, "BackdropTemplate")
    box:SetSize(POTION_BOX_SIZE.width, POTION_BOX_SIZE.height)
    box:SetPoint("TOPLEFT", self.frame, "TOPLEFT", (index - 1) * (POTION_BOX_SIZE.width + POTION_BOX_SPACING) + 15, -30)
    box:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
    box:SetBackdropColor(color.r, color.g, color.b, 1)
    box:SetBackdropBorderColor(FRAME.COLOR_WHITE.r, FRAME.COLOR_WHITE.g, FRAME.COLOR_WHITE.b, FRAME.COLOR_WHITE.a)

    local label = self:CreateTextElement(box, color.name, "GameFontHighlight", 12, FRAME.COLOR_WHITE, "CENTER", 0, 0)
    box:SetFontString(label)
    box.colorName = color.name

    box:SetScript("OnClick", function() self:HandleBoxClick(color.name) end)

    self.boxes[color.name] = box
end

function HorrificVisionsUI:HandleBoxClick(clickedColor)
    local clickedBox = self.boxes[clickedColor]
    if not clickedBox or self.haveClicked then return end -- Prevent multiple clicks

    self.haveClicked = true

    -- Remove tooltip scripts from all boxes before setting new ones
    for _, box in pairs(self.boxes) do
        box:SetScript("OnEnter", nil)
        box:SetScript("OnLeave", nil)
    end

    -- Iterate over all statuses and update respective boxes
    for status, mappings in pairs(potionColorStatusMappings) do
        local targetColor = mappings[clickedColor]
        if targetColor then
            local targetBox = self.boxes[targetColor]
            if targetBox then
                local label = targetBox:GetFontString()
                label:SetText(status)
                label:SetTextColor(FRAME.COLOR_WHITE.r, FRAME.COLOR_WHITE.g, FRAME.COLOR_WHITE.b, FRAME.COLOR_WHITE.a)
                label:SetShadowOffset(0, 0)
                label:SetShadowColor(FRAME.COLOR_BLACK.r, FRAME.COLOR_BLACK.g, FRAME.COLOR_BLACK.b, FRAME.COLOR_BLACK.a)
                label:SetFont(NORMAL_POTION_FONT.file, NORMAL_POTION_FONT.size, BAD_POTION_FONT.effect)

                -- Assign tooltips only for Sick, Slug, and Spicy
                if potionBuffSpellIDs[status] then
                    targetBox:SetScript("OnEnter", function(self)
                        local spell = potionBuffSpellIDs[status]
                        if spell then
                            GameTooltip:Hide()
                            GameTooltip:ClearLines()
                            --GameTooltip:SetWidth(350)

                            if ( self:GetCenter() > UIParent:GetCenter() ) then
                                GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                            else
                                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                            end

                            if spell.icon and spell.title then
                                local fontString = GameTooltip:CreateFontString(nil, "ARTWORK")
                                fontString:SetFontObject(GameTooltipTextLeft1:GetFontObject())
                                fontString:SetText("|TInterface\\Icons\\"..spell.icon..":24:24|t "..spell.title)
                                GameTooltip:AddLine(fontString:GetText(), nil, nil, nil, true)
                            end

                            if spell.desc then
                                GameTooltip:AddLine(colorize(spell.desc, KHorrificVisions.Colors.White), nil, nil, nil, true)
                            end

                            GameTooltip:Show()
                        end
                    end)
                    targetBox:SetScript("OnLeave", function()
                        GameTooltip:Hide()
                    end)
                end
            end
        end
    end

    -- Apply styling for "Bad" selection
    if clickedBox then
        local label = clickedBox:GetFontString()
        label:SetText(BAD_POTION_BOX_TEXT)
        label:SetTextColor(1, 0, 0, 1) -- Red
        label:SetShadowOffset(2, -2)
        label:SetShadowColor(FRAME.COLOR_BLACK.r, FRAME.COLOR_BLACK.g, FRAME.COLOR_BLACK.b, FRAME.COLOR_BLACK.a)
        label:SetFont(BAD_POTION_FONT.file, BAD_POTION_FONT.size, BAD_POTION_FONT.effect)
    end

    self.titleText:SetText(clickedColor .. TEXT_TITLE_BAD_POTION)
    self.frame:Hide()
    self.frame:Show()
end

function HorrificVisionsUI:ResetBoxes()
    for _, box in pairs(self.boxes) do
        local label = box:GetFontString()
        label:SetText(box.colorName)
        label:SetTextColor(FRAME.COLOR_WHITE.r, FRAME.COLOR_WHITE.g, FRAME.COLOR_WHITE.b, FRAME.COLOR_WHITE.a)
        label:SetShadowOffset(0, 0)
        label:SetShadowColor(FRAME.COLOR_BLACK.r, FRAME.COLOR_BLACK.g, FRAME.COLOR_BLACK.b, FRAME.COLOR_BLACK.a)
        label:SetFont(NORMAL_POTION_FONT.file, NORMAL_POTION_FONT.size, BAD_POTION_FONT.effect)
        box:SetScript("OnEnter", function(self) end)
    end

    self.haveClicked = false
    self.titleText:SetText(TEXT_TITLE_DEFAULT)
    self.frame:Hide()
    self.frame:Show()
end


--[[-------------------------------------------------------------------------
	Party Frames
---------------------------------------------------------------------------]]

function HorrificVisionsUI:CreatePartyUnitFrame(unit)
    if not UnitExists(unit) then return end

    local partyUnitFrame = CreateFrame("Frame", unit .. "AltPowerFrame", self.frame)
    partyUnitFrame:SetSize(155, 20)

    -- Border for the Alternate Power Bar (1px thin border)
    partyUnitFrame.altPowerBarBackdrop = CreateFrame("Frame", nil, partyUnitFrame, "BackdropTemplate")
    partyUnitFrame.altPowerBarBackdrop:SetAllPoints(partyUnitFrame)
    partyUnitFrame.altPowerBarBackdrop:SetBackdrop({
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 2
    })
    partyUnitFrame.altPowerBarBackdrop:SetBackdropBorderColor(0, 0, 0, 1)

    -- Alternate Power Bar
    partyUnitFrame.altPowerBar = CreateFrame("StatusBar", nil, partyUnitFrame)
    partyUnitFrame.altPowerBar:SetSize(partyUnitFrame:GetWidth() - 3, partyUnitFrame:GetHeight() - 3)
    partyUnitFrame.altPowerBar:SetPoint("CENTER", partyUnitFrame.altPowerBarBackdrop, "CENTER", 0, 0)
    partyUnitFrame.altPowerBar:SetMinMaxValues(0, UnitPowerMax(unit, Enum.PowerType.Alternate))
    partyUnitFrame.altPowerBar:SetValue(UnitPowerMax(unit, Enum.PowerType.Alternate))
    partyUnitFrame.altPowerBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    partyUnitFrame.altPowerBar:SetStatusBarColor(0.3, 0, 0.5)
    partyUnitFrame.altPowerBar:Hide()
    C_Timer.After(0.1, function() partyUnitFrame.altPowerBar:Show() end)

    -- Name Display
    partyUnitFrame.name = partyUnitFrame.altPowerBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    partyUnitFrame.name:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    partyUnitFrame.name:SetPoint("LEFT", partyUnitFrame, "LEFT", 3, 0)
    partyUnitFrame.name:SetText(UnitName(unit))

    -- Numerical Alt Power Display
    partyUnitFrame.altPowerText = partyUnitFrame.altPowerBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    partyUnitFrame.altPowerText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    partyUnitFrame.altPowerText:SetPoint("RIGHT", partyUnitFrame, "RIGHT", -3, 0)
    partyUnitFrame.altPowerText:SetText(string.format("%d", UnitPower(unit, Enum.PowerType.Alternate)))

    -- Apply Class Colors
    local _, class = UnitClass(unit)
    local color = RAID_CLASS_COLORS[class]
    if color then
        partyUnitFrame.name:SetTextColor(color.r, color.g, color.b)
        partyUnitFrame.altPowerText:SetTextColor(color.r, color.g, color.b)
    end

    -- Update Power Bar on Event
    partyUnitFrame:RegisterEvent("UNIT_POWER_UPDATE")
    partyUnitFrame:SetScript("OnEvent", function(_, _, argUnit, powerType)
        if argUnit == unit and powerType == "ALTERNATE" then
            local currentPower = UnitPower(unit, Enum.PowerType.Alternate)
            partyUnitFrame.altPowerBar:SetMinMaxValues(0, UnitPowerMax(unit, Enum.PowerType.Alternate))
            partyUnitFrame.altPowerBar:SetValue(currentPower)
            partyUnitFrame.altPowerText:SetText(string.format("%d", currentPower))

            -- Apply low power styling
            if currentPower <= LOW_POWER_THRESHOLD then
                partyUnitFrame.altPowerBar:SetStatusBarColor(0.7, 0, 0.2)
                partyUnitFrame.altPowerText:SetTextColor(0.7, 0, 0.2)
            else
                partyUnitFrame.altPowerBar:SetStatusBarColor(0.3, 0, 0.5)
                local _, class = UnitClass(unit)
                local color = RAID_CLASS_COLORS[class]
                if color then
                    partyUnitFrame.altPowerText:SetTextColor(color.r, color.g, color.b)
                end
            end
        end
    end)

    partyUnitFrame:Hide()
    return partyUnitFrame
end

function HorrificVisionsUI:UpdatePartyFrames()
    -- Clear and reset existing frames
    for unit, frame in pairs(self.partyFrames or {}) do
        if not UnitExists(unit) then
            frame:Hide()
            frame = nil
        end
    end

    -- Rebuild the party frames map
    self.partyFrames = {}

    -- Create player frame
    if UnitExists("player") then
        self.partyFrames["player"] = self:CreatePartyUnitFrame("player")
        self.partyFrames["player"]:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 15, -65)
        self.partyFrames["player"]:Show()
    end

    -- Create party member frames dynamically
    for i = 1, MAX_PARTY_MEMBERS do
        local unit = "party" .. i
        if UnitExists(unit) then
            self.partyFrames[unit] = self:CreatePartyUnitFrame(unit)
            local column = i % 2
            local row = math.floor(i / 2)
            self.partyFrames[unit]:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 15 + (column * 162), (-25 * row) - 65)
            self.partyFrames[unit]:Show()
        end
    end
end


--[[-------------------------------------------------------------------------
	Events
---------------------------------------------------------------------------]]

function HorrificVisionsUI:OnEvent(event)
    if event == "GROUP_ROSTER_UPDATE" then
        self:UpdatePartyFrames()
    else
        local currentMapID = C_Map.GetBestMapForUnit("player") -- Get current zone's map ID
        kprint("currentMapID:", currentMapID)

        if validVisionsMapIDs[currentMapID] then
            self.frame:Show()
            self:ResetBoxes()
        else
            self.frame:Hide()
        end
    end
end

-- Register the frame to listen for events
function HorrificVisionsUI:RegisterEvents()
    self.frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    self.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.frame:SetScript("OnEvent", function(_, event)
        self:OnEvent(event)
    end)
end


--[[-------------------------------------------------------------------------
	Instance of the UI
---------------------------------------------------------------------------]]

local horrificVisionsUI = HorrificVisionsUI:new()
KHorrificVisions.HorrificVisionsFrame = horrificVisionsUI


--[[-------------------------------------------------------------------------
	Slash Command
---------------------------------------------------------------------------]]

SLASH_KHV1 = "/hv" -- Define the slash command
SlashCmdList["KHV"] = function(msg)
    msg = string.lower(msg)
    if msg == "reset" then
        return horrificVisionsUI:ResetBoxes()
    end

    if horrificVisionsUI.frame:IsVisible() then
        horrificVisionsUI.frame:Hide()
    else
        horrificVisionsUI.frame:Show()
    end
end