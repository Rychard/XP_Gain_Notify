local ADDON, XGN = ...

local events = {}

function events:ADDON_LOADED(addonName, ...)
    if ADDON ~= addonName then return end

    if not XGNConfig then XGNConfig = {} end
end

function events:PLAYER_LOGIN(...)
    XGN.xpLast = UnitXP("player")
    local version = XGN.version .. " [" .. XGN.versionDate .. "]"
    XGN.AddMessage("Experience Gain Notify " .. version .. " Loaded.")
end

function events:PLAYER_XP_UPDATE(...)
    local current = UnitXP("player")
    local target = UnitXPMax("player")
    local gained = current - XGN.xpLast
    XGN.Update(current, target, gained)
end

function events:PLAYER_LEVEL_UP(...)
  local current = UnitXP("player")
  local target = UnitXPMax("player")
  XGN.Update(current, target, 0)
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, ...)
  events[event](self, ...)
end)

for k, v in pairs(events) do frame:RegisterEvent(k) end
