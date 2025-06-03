local addonName, KHorrificVisions = ...
local kprint = KHorrificVisions.kprint
--local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--[[-------------------------------------------------------------------------
    UI Setup
---------------------------------------------------------------------------]]

-- Font Definitions
local Fonts = {
    MainHeader = CreateFont("MainHeaderFont"),
    FooterText = CreateFont("FooterTextFont"),
    Heading    = CreateFont("HeadingFont"),
    MainText   = CreateFont("MainTextFont")
}

-- Font Initialization
local function InitializeFonts()
    Fonts.MainHeader:SetFont("Fonts\\FRIZQT__.TTF", 16, "")
    Fonts.FooterText:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    Fonts.Heading:SetFont("Fonts\\FRIZQT__.TTF", 14, "")
    Fonts.MainText:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
end

--[[-------------------------------------------------------------------------
    Event Handling
---------------------------------------------------------------------------]]

local function MouseHandler(event, func, button, ...)
    if _G.type(func) == "function" then
        func(event, func, button, ...)
    else
        func:GetScript("OnClick")(func, button, ...)
    end

    KHorrificVisions.LibQTip:Release(tooltip)
    tooltip = nil
end

local function LoadData()
    -- TODO: this
end

--[[-------------------------------------------------------------------------
    Tooltip Population
---------------------------------------------------------------------------]]

local function PopulateTooltip(tooltip)
    tooltip:SetCellMarginH(10) -- Apply horizontal margin before adding data
    tooltip:SetFont(Fonts.MainHeader)

    local y, x = tooltip:AddLine()
    tooltip:SetCell(y, 1, colorize("K Horrific Visions", KHorrificVisions.Colors.Header))

    -- Tooltip Separator
    tooltip:SetFont(Fonts.MainText)
    tooltip:AddSeparator(3, 0, 0, 0, 0)

    tooltip:AddLine("KHorrificVisions will auto-open when entering a Horrific Vision")
    tooltip:AddLine("Or you can click the minimap icon to open it outside of one")

    tooltip:AddSeparator(3, 0, 0, 0, 0)
    tooltip:AddSeparator()
    tooltip:AddSeparator(3, 0, 0, 0, 0)

    tooltip:SetFont(Fonts.FooterText)
    tooltip:AddLine(colorize("Right-click the icon for options", KHorrificVisions.Colors.FooterDark))
end
KHorrificVisions.PopulateTooltip = PopulateTooltip

--[[-------------------------------------------------------------------------
    Global Initialization
---------------------------------------------------------------------------]]

local function Initialize()
    InitializeFonts()
    LoadData()
end
KHorrificVisions.Initialize = Initialize
