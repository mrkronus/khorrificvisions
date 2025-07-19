local addonName, KHorrificVisions = ...
local kprint = KHorrificVisions.kprint

--[[-------------------------------------------------------------------------
	Variables
---------------------------------------------------------------------------]]

-- [[ Localization ]]
--local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local ItemInfoCache = {}
ItemInfoCache.cache = {}
ItemInfoCache.pending = {}

--[[-------------------------------------------------------------------------
	Item Info Cache
---------------------------------------------------------------------------]]

function ItemInfoCache:GetItemInfo(itemID)
    if self.cache[itemID] then
        return self.cache[itemID]
    end
    if not self.pending[itemID] then
        local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
            itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expansionID, setID,
            isCraftingReagent = C_Item.GetItemInfo(itemID)
        if itemName then
            self.cache[itemID] = {
                name = itemName,
                link = itemLink,
                quality = itemQuality,
                level = itemLevel,
                minLevel = itemMinLevel,
                type = itemType,
                subType = itemSubType,
                stackCount = itemStackCount,
                equipLoc = itemEquipLoc,
                texture = itemTexture,
                sellPrice = sellPrice,
                classID = classID,
                subclassID = subclassID,
                bindType = bindType,
                expansionID = expansionID,
                setID = setID,
                isCraftingReagent = isCraftingReagent
            }
            return self.cache[itemID]
        end
        self.pending[itemID] = true
    end

    return nil
end

function ItemInfoCache:PreCacheItems(nodesTable)
    for _, subTable in pairs(nodesTable) do
        for _, subTableNode in pairs(subTable) do
            if subTableNode.itemID then
                if not self.cache[subTableNode.itemID] and not self.pending[subTableNode.itemID] then
                    C_Item.RequestLoadItemDataByID(subTableNode.itemID)
                    Item:CreateFromItemID(subTableNode.itemID)
                    local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
                        itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expansionID, setID,
                        isCraftingReagent = C_Item.GetItemInfo(subTableNode.itemID)
                    if itemName then
                        self.cache[subTableNode.itemID] = {
                            name = itemName,
                            link = itemLink,
                            quality = itemQuality,
                            level = itemLevel,
                            minLevel = itemMinLevel,
                            type = itemType,
                            subType = itemSubType,
                            stackCount = itemStackCount,
                            equipLoc = itemEquipLoc,
                            texture = itemTexture,
                            sellPrice = sellPrice,
                            classID = classID,
                            subclassID = subclassID,
                            bindType = bindType,
                            expansionID = expansionID,
                            setID = setID,
                            isCraftingReagent = isCraftingReagent
                        }
                    else
                        self.pending[subTableNode.itemID] = true
                    end
                end
            end
        end
    end
end

KHorrificVisions.ItemInfoCache = ItemInfoCache

--[[-------------------------------------------------------------------------
	Event Frame
---------------------------------------------------------------------------]]

local itemInfoCacheEventFrame = CreateFrame("Frame")
itemInfoCacheEventFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
itemInfoCacheEventFrame:SetScript("OnEvent", function(_, _, itemID, success)
    if success and ItemInfoCache.pending[itemID] then
        ItemInfoCache.cache[itemID] = { C_Item.GetItemInfo(itemID) }
        ItemInfoCache.pending[itemID] = nil
    end
end)
