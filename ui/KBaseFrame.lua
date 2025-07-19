local addonName, Addon = ...
local kprint = Addon.kprint
--local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


--[[-------------------------------------------------------------------------
    Constants and Configuration
---------------------------------------------------------------------------]]

Addon.KViewSettings = {}
Addon.KViewSettings.__index = Addon.KViewSettings

function Addon.KViewSettings:New(hasResizeGripper, hasTitleBar, titleBarAlpha, scale, defaultVisibility)
    local self = setmetatable({}, Addon.KViewSettings)

    self.hasResizeGripper = hasResizeGripper or false
    self.hasTitleBar = hasTitleBar or false
    self.titleBarAlpha = titleBarAlpha or 0.75
    self.scale = scale or 1.0
    self.defaultVisibility = defaultVisibility or true

    return self
end

Addon.KViewTheme = {}
Addon.KViewTheme.__index = Addon.KViewTheme

function Addon.KViewTheme:New()
    local self = setmetatable({}, Addon.KViewTheme)

    self.BACKDROP_COLOR         = { r = 0.1, g = 0.2, b = 0.4, a = 0.85 }   -- Steel blue
    self.BORDER_COLOR           = { r = 0.9, g = 0.9, b = 0.9, a = 1 }      -- White border
    self.TITLE_BAR_COLOR        = { r =   0, g = 0.2, b = 0.6, a = 0.75 }   -- Deep blue title bar
    self.SCROLL_BG_COLOR        = { r = 0.2, g = 0.3, b = 0.5, a = 1 }      -- Soft steel blue background
    self.SCROLL_THUMB_COLOR     = { r = 0.8, g = 0.7, b = 0.4, a = 1 }      -- Gold for scroll thumb
    self.SCROLL_BUTTON_COLOR    = { r = 0.6, g = 0.5, b = 0.3, a = 1 }      -- Gold-brown scroll buttons

    return self
end


--[[-------------------------------------------------------------------------
    KBaseFrame
---------------------------------------------------------------------------]]

Addon.KBaseFrame = {}
Addon.KBaseFrame.__index = Addon.KBaseFrame

function Addon.KBaseFrame:New(name, width, height, theme, viewSettings)
    local self = setmetatable({}, Addon.KBaseFrame)

    self.theme = theme or Addon.KViewTheme:New()
    self.viewSettings = viewSettings or Addon.KViewSettings:New()

    -- Create main frame
    self.frame = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    self.frame:SetSize(width, height)
    self.frame:SetPoint("CENTER")
    self.frame:SetScale(self.viewSettings.scale)
    self.frame:SetShown(self.viewSettings.defaultVisibility)
    self.frame:SetMovable(true)
    self.frame:EnableMouse(true)
    self.frame:SetResizable(true)
    self.frame:RegisterForDrag("LeftButton")
    self.frame:SetScript("OnDragStart", function() self.frame:StartMoving() end)
    self.frame:SetScript("OnDragStop", function() self.frame:StopMovingOrSizing() end)
    --self.frame:SetMinResize(200, 150) -- Prevent collapsing too small
    --self.frame:SetMaxResize(700, 500) -- Limit max size for better UI flow
    self.frame:Hide()

    self:ApplyTheme()
    self:CreateCloseButton()

    if self.viewSettings.hasTitleBar then
        self:CreateTitleBar()
    end

    if self.viewSettings.hasResizeGripper then
        self:CreateResizeHandle()
    end

    return self
end

function Addon.KBaseFrame:ApplyTheme()
    self.frame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
    self.frame:SetBackdropColor(self.theme.BACKDROP_COLOR.r, self.theme.BACKDROP_COLOR.g, self.theme.BACKDROP_COLOR.b, self.theme.BACKDROP_COLOR.a)
    self.frame:SetBackdropBorderColor(self.theme.BORDER_COLOR.r, self.theme.BORDER_COLOR.g, self.theme.BORDER_COLOR.b, self.theme.BORDER_COLOR.a)
end

function Addon.KBaseFrame:CreateTitleBar()
    self.titleBar = CreateFrame("Frame", "$parentTitleBar", self.frame, "BackdropTemplate")
    self.titleBar:SetHeight(25)
    self.titleBar:SetPoint("TOP", self.frame, "TOP", 0, 0)
    self.titleBar:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
    self.titleBar:SetBackdropColor(
        self.theme.TITLE_BAR_COLOR.r,
        self.theme.TITLE_BAR_COLOR.g,
        self.theme.TITLE_BAR_COLOR.b,
        self.viewSettings.titleBarAlpha
    )

    self.frame:SetScript("OnSizeChanged", function(_, width, height)
        self:HandleFrameResize(width, height)
    end)
end

function Addon.KBaseFrame:CreateCloseButton()
    local CLOSE_HOVER_COLOR   = { r = 0.65, g = 0.17, b = 0.25, a = 1 }
    local CLOSE_NORMAL_COLOR  = { r = 0.59, g = 0.12, b = 0.20, a = 1 }
    self.closeButton = self:CreateIconButton(
        "$parentCloseButton", 10,
        {"TOPRIGHT", self.frame, "TOPRIGHT", -8, -8},
        "Interface/AddOns/KHorrificVisions/assets/close", CLOSE_NORMAL_COLOR, CLOSE_HOVER_COLOR,
        "Close", function() self.frame:Hide() end
    )
end

function Addon.KBaseFrame:CreateIconButton(name, size, point, texture, normalColor, hoverColor, tooltipText, onClick)
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

function Addon.KBaseFrame:CreateResizeHandle()
    self.resizeHandle = CreateFrame("Frame", "$parentResizeHandle", self.frame)
    self.resizeHandle:SetSize(16, 16)
    self.resizeHandle:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", -2, 2)

    self.resizeHandle.bg = self.resizeHandle:CreateTexture(nil, "BACKGROUND")
    self.resizeHandle.bg:SetAllPoints()
    self.resizeHandle.bg:SetColorTexture(0.2, 0, 0.3, 1)

    self.resizeHandle:SetScript("OnMouseDown", function()
        self.frame:StartSizing("BOTTOMRIGHT")
    end)

    self.resizeHandle:SetScript("OnMouseUp", function()
        self.frame:StopMovingOrSizing()
    end)
end

function Addon.KBaseFrame:HandleFrameResize(width, height)
    self.titleBar:SetWidth(width)
end