local addonName, KHorrificVisions = ...
local kprint = KHorrificVisions.kprint
--local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--[[-------------------------------------------------------------------------
    Constants and Configuration
---------------------------------------------------------------------------]]

local THEME         = KHorrificVisions.UI.UIThemeColors
local FRAME         = KHorrificVisions.UI.Frame

local FRAME_SIZE    = { width = 775, height = 325 }


--[[-------------------------------------------------------------------------
	Story UI Frame
---------------------------------------------------------------------------]]

local StoryUI = {}
StoryUI.__index = StoryUI

local nzothTexureRatio = 242 / 220

function StoryUI:New()
     local self = setmetatable({}, StoryUI)

    self.frame = CreateFrame("Frame", "CollectionsUIFrame", UIParent, "BackdropTemplate")
    self.frame:SetSize(FRAME_SIZE.width, FRAME_SIZE.height)
    self.frame:SetPoint("CENTER")

    self.frame.nzothTexure = self.frame:CreateTexture("nzoth", "BORDER")
    self.frame.nzothTexure:SetPoint("BOTTOMLEFT", self.frame, "BOTTOMLEFT", 4, 4)
    self.frame.nzothTexure:SetTexture("interface/questframe/worldquest") -- Use the path from `GetAtlasInfo()`
    self.frame.nzothTexure:SetTexCoord(0.478515625, 0.951171875, 0.001953125, 0.431640625) -- Apply UV mapping
    self.frame.nzothTexure:SetSize(FRAME_SIZE.height * nzothTexureRatio, FRAME_SIZE.height) -- Match atlas dimensions
    self.frame.nzothTexure:SetAlpha(0.75) -- Match atlas dimensions

    self:SetupFrameAppearance()
    self:ScrollableContent()
    self:SetupScrollBar()

    self:SetupResizeHandle()

    self.closeButton = self:CreateIconButton(
        "KHorrificVisionsFrameCloseButton", 10,
        {"TOPRIGHT", self.frame, "TOPRIGHT", -8, -8},
        "Interface/AddOns/KHorrificVisions/assets/close", THEME.CLOSE_NORMAL_COLOR, THEME.CLOSE_HOVER_COLOR,
        FRAME.CLOSE_TOOLTIP_TEXT, function() self.frame:Hide() end
    )

    -- OnSizeChanged
    self.frame:SetScript("OnSizeChanged", function(_, width, height)
        self:HandleFrameResize(width, height)
    end)

    return self
end

function StoryUI:SetupFrameAppearance()
    self.frame:SetBackdrop(FRAME.BACKDROP_CONFIG)
    self.frame:SetBackdropColor(THEME.BACKDROP_COLOR.r, THEME.BACKDROP_COLOR.g, THEME.BACKDROP_COLOR.b, THEME.BACKDROP_COLOR.a)
    self.frame:SetBackdropBorderColor(THEME.BORDER_COLOR.r, THEME.BORDER_COLOR.g, THEME.BORDER_COLOR.b, THEME.BORDER_COLOR.a)
    self.frame:SetMovable(true)
    self.frame:EnableMouse(true)
    self.frame:SetResizable(true)
    self.frame:RegisterForDrag("LeftButton")
    self.frame:SetScript("OnDragStart", function() self.frame:StartMoving() end)
    self.frame:SetScript("OnDragStop", function() self.frame:StopMovingOrSizing() end)
    --self.frame:SetMinResize(200, 150) -- Prevent collapsing too small
    --self.frame:SetMaxResize(700, 500) -- Limit max size for better UI flow
    self.frame:Hide()
end

function StoryUI:ScrollableContent()
    self.scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", self.frame, "UIPanelScrollFrameTemplate")
    self.scrollFrame:SetSize(FRAME_SIZE.width, FRAME_SIZE.height)
    self.scrollFrame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 10, -20)

    -- Scroll Content
    self.scrollChild = CreateFrame("Frame", "$parentScrollChild", self.scrollFrame)
    self.scrollChild:SetSize(FRAME_SIZE.width - 40, FRAME_SIZE.height * 1.5)
    self.scrollFrame:SetScrollChild(self.scrollChild)

    self.contentText = self.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    local myFont = CreateFont("MyCustomFont")
    myFont:SetFont("Interface/AddOns/KHorrificVisions/media/accid___.ttf", 14, "OUTLINE")
    self.contentText:SetFontObject(myFont)
    self.contentText:SetPoint("TOPLEFT", self.scrollChild, "TOPLEFT", 5, -5)
    self.contentText:SetJustifyH("LEFT")
    self.contentText:SetWidth(FRAME_SIZE.width - 50)
    self.contentText:SetWordWrap(true)
    self.contentText:SetText(getStoredString())
end

function StoryUI:SetupScrollBar()
    local scrollBar = self.scrollFrame.ScrollBar
    local scrollUpButton = self.scrollFrame.ScrollBar.ScrollUpButton
    local scrollDownButton = self.scrollFrame.ScrollBar.ScrollDownButton

    -- Up Button
    local upTexture = scrollUpButton:CreateTexture(nil, "ARTWORK")
    upTexture:SetAllPoints()
    upTexture:SetSize(16, 16)
    upTexture:SetTexture("Interface/AddOns/KHorrificVisions/assets/upchev.blp")
    upTexture:SetVertexColor(0.35, 0.49, 0.65, 0.8)
    scrollUpButton:SetNormalTexture(upTexture)
    scrollUpButton:SetHighlightTexture(upTexture)
    scrollUpButton:SetPushedTexture(upTexture)
    scrollUpButton:SetDisabledTexture(upTexture)
    scrollUpButton:SetScale(0.666666) -- Scale up 50%

    -- Down Button
    local downTexture = scrollDownButton:CreateTexture(nil, "ARTWORK")
    downTexture:SetAllPoints()
    downTexture:SetSize(16, 16)
    downTexture:SetTexture("Interface/AddOns/KHorrificVisions/assets/downchev.blp")
    downTexture:SetVertexColor(0.35, 0.49, 0.65, 0.8)
    scrollDownButton:SetNormalTexture(downTexture)
    scrollDownButton:SetHighlightTexture(downTexture)
    scrollDownButton:SetPushedTexture(downTexture)
    scrollDownButton:SetDisabledTexture(downTexture)
    scrollDownButton:SetScale(0.66666)

    -- Thumb
    local thumbTexture = scrollBar:GetThumbTexture()
    thumbTexture:SetTexture(nil)
    thumbTexture:SetColorTexture(0.17, 0.24, 0.31, 1)
    thumbTexture:SetSize(10, 20)
end

function StoryUI:SetupResizeHandle()
    self.resizeHandle = CreateFrame("Frame", "$parentResizeHandle", self.frame)
    self.resizeHandle:SetSize(10, 10)
    self.resizeHandle:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", -6, 6)

    self.resizeHandle.bg = self.resizeHandle:CreateTexture(nil, "BACKGROUND")
    self.resizeHandle.bg:SetAllPoints()
    self.resizeHandle.bg:SetTexture("Interface/AddOns/KHorrificVisions/assets/resize.blp")
    self.resizeHandle.bg:SetVertexColor(0.30, 0.44, 0.60, 0.6)

    self.resizeHandle:SetScript("OnMouseDown", function() self.frame:StartSizing("BOTTOMRIGHT") end)
    self.resizeHandle:SetScript("OnMouseUp", function() self.frame:StopMovingOrSizing() end)
end

function StoryUI:CreateIconButton(name, size, point, texture, normalColor, hoverColor, tooltipText, onClick)
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

function StoryUI:HandleFrameResize(width, height)
    self.scrollFrame:SetSize(width - 37, height - 35)
    self.scrollChild:SetSize(width - 40, height * 1.5)
    self.contentText:SetWidth(width - 50)
    if width > height then
        self.frame.nzothTexure:SetSize(height * nzothTexureRatio, height) -- Match atlas dimensions
    else
        self.frame.nzothTexure:SetSize(width, width / nzothTexureRatio) -- Match atlas dimensions
    end
end


--[[-------------------------------------------------------------------------
	Instance of the UI
---------------------------------------------------------------------------]]

local storyUI = StoryUI:New()
KHorrificVisions.StoryUIFrame = storyUI


--[[-------------------------------------------------------------------------
	Slash Command
---------------------------------------------------------------------------]]

SLASH_KHVC1 = "/hvc"
SlashCmdList["KHVC"] = function(msg)
    if storyUI.frame:IsVisible() then
        storyUI.frame:Hide()
    else
        storyUI.frame:Show()
    end
end