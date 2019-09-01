local _, XGN = ...

XGN.GetChatTabIndex = function(tabName)
    for i = 1, 10 do
        if GetChatWindowInfo(i) == tabName then
            return i
        end
    end
    return nil
end

XGN.AddMessage = function(msg)
    local tabIndex = 1
    if XGNConfig.chatFrame then
        --tabIndex = XGN.GetChatTabIndex(XGNConfig.chatFrame)
        tabIndex = XGNConfig.chatFrame
    end

    if not tabIndex then
        tabIndex = 1
    end

    _G["ChatFrame" .. tabIndex]:AddMessage(msg)
end
