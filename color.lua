local _, XGN = ...

local function ConstrainValue(value)
    if value > 255 then return 255 end
    if value < 0 then return 0 end
    return value
end

local function ColorText(msg, red, green, blue)
    red = ConstrainValue(red)
    green = ConstrainValue(green)
    blue = ConstrainValue(blue)
    -- |caarrggbb (aa, rr, gg, bb, being the color values in hex format and ARGB order)
    return string.format("|cFF%02x%02x%02x%s|r", red, green, blue, msg)
end

local function MakeLegendary(msg) return ColorText(msg, 255, 128, 0) end
local function MakeEpic(msg) return ColorText(msg, 163, 53, 238) end
local function MakeRare(msg) return ColorText(msg, 0, 112, 222) end
local function MakeUncommon(msg) return ColorText(msg, 30, 255, 0) end
local function MakeCommon(msg) return ColorText(msg, 255, 255, 255) end

XGN.ColorText = function(msg, percent)
    if (percent > 80) then return MakeLegendary(msg) end
    if (percent > 60) then return MakeEpic(msg) end
    if (percent > 40) then return MakeRare(msg) end
    if (percent > 20) then return MakeUncommon(msg) end
    return msg
end