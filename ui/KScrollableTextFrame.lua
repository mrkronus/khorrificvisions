local addonName, Addon = ...
local kprint = Addon.kprint
--local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--[[-------------------------------------------------------------------------
    KScrollableTextFrame
---------------------------------------------------------------------------]]

Addon.KNZothTheme = {}
Addon.KNZothTheme.__index = Addon.KNZothTheme

function Addon.KNZothTheme:New()
    local self               = setmetatable({}, Addon.KNZothTheme)

    self.BACKDROP_COLOR      = { r = 0.1, g = 0, b = 0.2, a = 0.85 } -- Deep void purple
    self.BORDER_COLOR        = { r = 0.6, g = 0, b = 0.8, a = 1 } -- Void-touched glow
    self.TITLE_BAR_COLOR     = { r = 0, g = 0.1, b = 0.4, a = 0.75 } -- Shadowy deep blue
    self.SCROLL_BG_COLOR     = { r = 0.15, g = 0, b = 0.3, a = 1 } -- Eldritch-darkened scroll background
    self.SCROLL_THUMB_COLOR  = { r = 0.3, g = 0, b = 0.5, a = 1 } -- Muted purple for eerie contrast
    self.SCROLL_BUTTON_COLOR = { r = 0.1, g = 0, b = 0.3, a = 1 } -- Flat-shaded sinister buttons

    return self
end

Addon.KScrollableTextFrame = setmetatable({}, { __index = Addon.KScrollableFrame })

function Addon.KScrollableTextFrame:New()
    local theme = Addon.KNZothTheme:New() -- Restoring N'Zoth theme
    local viewSettings = Addon.KViewSettings:New(true, true, 0.6, 1.0, true)

    local self = Addon.KScrollableFrame:New("KScrollableTextFrameUI", 550, 300, theme, viewSettings)
    setmetatable(self, { __index = Addon.KScrollableTextFrame })

    --self:AddPlaceholderText()

    return self
end
