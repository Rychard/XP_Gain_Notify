local _, XGN = ...

XGN.version = "v2.0.1-alpha"
XGN.versionDate = "9/16/2019"

XGN.xpLast = 0
XGN.xpLastPet = 0

local function UpdatePlayer(current, target, gained)
    local percent = ((floor((current / target) * 10000)) / 100)
    local remaining = target - current
    local repetitions = ceil(remaining / gained)
    XGN.xpLast = current

    if gained == 0 then return end
    if repetitions <= 0 then return end
    if repetitions == (1 / 0) then return end

    local msgGained = XGN.ColorText(string.format("%sXP", gained), percent)
    local msgPercent = XGN.ColorText(string.format("%.2f%%", percent), percent)
    local msgRemaining = XGN.ColorText(string.format("%dXP", remaining), percent)
    local msgRepetitions = XGN.ColorText(string.format("%d", repetitions), percent)

    local msg = string.format("Gained %s. (%s) %s to go (%s Repetitions)", msgGained, msgPercent, msgRemaining, msgRepetitions)
    XGN.AddMessage(msg)
end

local function UpdatePet(gained)
    if UnitClass("player") ~= "Hunter" then return end
    if not UnitExists("pet") then return end

    local levelPlayer = UnitLevel("player")
    local levelPet = UnitLevel("pet")
    if (levelPet == levelPlayer) then return end

    local current, target = GetPetExperience()
    XGN.xpLastPet = current

    local percent = (floor((current / target) * 10000) / 100)
    local remaining = target - current
    local repetitions = ceil(remaining / gained)

    local msgGained = XGN.ColorText(string.format("%sXP", gained), percent)
    local msgPercent = XGN.ColorText(string.format("%.2f%%", percent), percent)
    local msgRemaining = XGN.ColorText(string.format("%dXP", remaining), percent)
    local msgRepetitions = XGN.ColorText(string.format("%d", repetitions), percent)

    local msg = string.format("<PET> Gained %s. (%s) %s to go (%s Repetitions)", msgGained, msgPercent, msgRemaining, msgRepetitions)
    XGN.AddMessage(msg)
end

XGN.Update = function(current, target, gained)
    UpdatePlayer(current, target, gained)
    UpdatePet(gained)
end