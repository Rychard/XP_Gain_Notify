local _, XGN = ...

local function Command(arg)
  local frameIndex = tonumber(arg)
  if frameIndex ~= nil and frameIndex > 0 and frameIndex <= 10 then
    XGNConfig.chatFrame = frameIndex
    XGN.AddMessage("Messages will be written here")
  end
end

-- Slash Commands
SLASH_XGN1 = "/xgn";
SlashCmdList["XGN"] = Command;