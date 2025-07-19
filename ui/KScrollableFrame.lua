local addonName, Addon = ...
local kprint = Addon.kprint
--local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--[[-------------------------------------------------------------------------
    Constants and Configuration
---------------------------------------------------------------------------]]

Addon.KScrollableFrame = setmetatable({}, { __index = Addon.KBaseFrame })

function Addon.KScrollableFrame:New(name, width, height, theme, viewSettings)
    local self = Addon.KBaseFrame:New(name, width, height, theme, viewSettings)
    setmetatable(self, { __index = Addon.KScrollableFrame })

    self:CreateScrollableText()
    self:CreateScrollbar()

    return self
end

function Addon.KScrollableFrame:CreateScrollableText()
    self.scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", self.frame, "UIPanelScrollFrameTemplate")
    self.scrollFrame:SetSize(self.frame:GetWidth() - 40, self.frame:GetHeight() - 50)
    self.scrollFrame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 10, -30)

    self.scrollChild = CreateFrame("Frame", "$parentScrollChild", self.scrollFrame)
    self.scrollChild:SetSize(self.frame:GetWidth() - 40, self.frame:GetHeight() * 1.5)
    self.scrollFrame:SetScrollChild(self.scrollChild)
end

function Addon.KScrollableFrame:CreateScrollbar()
    self.scrollBar = CreateFrame("Slider", "$parentScrollBar", self.frame)
    self.scrollBar:SetSize(16, self.frame:GetHeight() - 45)
    self.scrollBar:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -2, -25)
    self.scrollBar:SetOrientation("VERTICAL")
    self.scrollBar:SetMinMaxValues(1, 100)
    self.scrollBar:SetValueStep(1)

    -- Background
    self.scrollBar.bg = self.scrollBar:CreateTexture(nil, "BACKGROUND")
    self.scrollBar.bg:SetAllPoints()
    self.scrollBar.bg:SetColorTexture(0.15, 0, 0.3, 1)

    -- Thumb
    self.scrollBar.thumb = self.scrollBar:CreateTexture(nil, "OVERLAY")
    self.scrollBar.thumb:SetSize(16, 40)
    self.scrollBar.thumb:SetColorTexture(0.3, 0, 0.5, 1)
    self.scrollBar:SetThumbTexture(self.scrollBar.thumb)

    -- Buttons
    self.scrollUpButton = self:CreateScrollButton("$parentScrollUp", self.scrollBar, "TOP")
    self.scrollDownButton = self:CreateScrollButton("$parentScrollDown", self.scrollBar, "BOTTOM")
end

function Addon.KScrollableFrame:CreateScrollButton(name, parent, point)
    local button = CreateFrame("Button", name, parent)
    button:SetSize(16, 16)
    button:SetPoint(point, parent, point, 0, 0)

    button.bg = button:CreateTexture(nil, "BACKGROUND")
    button.bg:SetAllPoints()
    button.bg:SetColorTexture(0.1, 0, 0.3, 1)

    button:SetScript("OnMouseDown", function()
        button.bg:SetColorTexture(0.2, 0, 0.5, 1)
    end)

    button:SetScript("OnMouseUp", function()
        button.bg:SetColorTexture(0.1, 0, 0.3, 1)
    end)

    return button
end

function Addon.KScrollableFrame:HandleFrameResize(width, height)
    Addon.KBaseFrame.HandleFrameResize(width, height)
    self.scrollFrame:SetSize(width - 40, height - 50)
    self.scrollChild:SetSize(width - 40, height * 1.5)
    self.scrollBar:SetHeight(height - 45)
    self.placeholderText:SetWidth(width - 50)
end