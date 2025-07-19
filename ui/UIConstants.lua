local addonName, KHorrificVisions = ...
local kprint = KHorrificVisions.kprint
--local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--[[-------------------------------------------------------------------------
	Data
---------------------------------------------------------------------------]]

KHorrificVisions.UI = {}

-- Theme color constants
KHorrificVisions.UI.UIThemeColors = {
    BACKDROP_COLOR      = { r = 0.015, g = 0.005, b = 0.025, a = 0.7 }, -- 70% black background
    BORDER_COLOR        = { r = 0.1, g = 0.2, b = 0.6, a = 1 },         -- Deep void-blue border
    TITLE_TEXT_COLOR    = { r = 0.7, g = 0.6, b = 1, a = 1 },           -- Title text color
    CLOSE_HOVER_COLOR   = { r = 0.65, g = 0.17, b = 0.25, a = 1 },      -- Close button hover color
    CLOSE_NORMAL_COLOR  = { r = 0.59, g = 0.12, b = 0.2, a = 1 },       -- Close button normal color
    RESET_HOVER_COLOR   = { r = 0.15, g = 0.47, b = 0.27, a = 1 },      -- Reset button hover color
    RESET_NORMAL_COLOR  = { r = 0.13, g = 0.42, b = 0.22, a = 1 }       -- Reset button normal color
}

-- Muted/thematic potion colors
KHorrificVisions.UI.PotionColors = {
    { name = "Black",  r = 0,    g = 0,    b = 0 },
    { name = "Green",  r = 0.13, g = 0.42, b = 0.22 },
    { name = "Red",    r = 0.59, g = 0.12, b = 0.2 },
    { name = "Blue",   r = 0.07, g = 0.16, b = 0.31 },
    { name = "Purple", r = 0.35, g = 0.12, b = 0.474 }
}

-- More pure/saturated potion colors. Maybe add an option later
-- to use these instead for visubility/accessibility 
KHorrificVisions.UI.PotionColorsHighContrast = {
    { name = "Black",  r = 0,   g = 0,   b = 0 },
    { name = "Green",  r = 0,   g = 0.7, b = 0 },
    { name = "Red",    r = 0.7, g = 0,   b = 0 },
    { name = "Blue",   r = 0,   g = 0,   b = 0.7 },
    { name = "Purple", r = 0.4, g = 0,   b = 0.4 }
}

-- Common Frame Constants
KHorrificVisions.UI.Frame = {}
KHorrificVisions.UI.Frame.CLOSE_TOOLTIP_TEXT = "Close"
KHorrificVisions.UI.Frame.BUTTON_SPACING    = 4
KHorrificVisions.UI.Frame.COLOR_BLACK       = { r = 0, g = 0, b = 0, a = 1 }
KHorrificVisions.UI.Frame.COLOR_WHITE       = { r = 1, g = 1, b = 1, a = 1 }
KHorrificVisions.UI.Frame.BACKDROP_CONFIG   = {
    bgFile   = "Interface\\Buttons\\WHITE8x8",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    edgeSize = 12
}