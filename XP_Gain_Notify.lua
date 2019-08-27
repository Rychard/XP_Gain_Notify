-- Intializing Variables
  XGN = {}
    XGN.xpgain = nil;
    XGN.currxp = nil;
    XGN.prevxp = nil;
    XGN.percentxp = nil;
    XGN.percentxpcolor = nil;
    XGN.repetition = nil;
    XGN.exptogo = nil;
    -- XGN.firstkill = nil;
    XGN.msg = nil;
    XGN.on = nil;
    XGN.variablesloaded = nil;
    XGN.default_on = true;
    XGN.default_channel = 1;
    XGN.default_red = 1;
    XGN.default_blue = 1;
    XGN.default_green = 1;

function XGN_Slash(var1)
  -- XGN_AddMessage("Var1 = "..var1); -- Debug
  -- XGNConfigFrame:Show(); -- Later.

  if (var1 == "party") then
    SendChatMessage((UnitXPMax("player") - UnitXP("player")).."XP needed to level.", "PARTY");
  elseif (var1 == "self") then
    XGN_AddMessage((UnitXPMax("player") - UnitXP("player")).."XP needed to level.");
  elseif (var1 == "1") then
    XGNConfig.channel = "1";
    XGN_AddMessage("|cFF1EFF00This is where Experience Gain Notify will report gains.|r");
  elseif (var1 == "2") then
    XGNConfig.channel = "2";
    XGN_AddMessage("|cFF1EFF00This is where Experience Gain Notify will report gains.|r");
  elseif (var1 == "3") then
    XGNConfig.channel = "3";
    XGN_AddMessage("|cFF1EFF00This is where Experience Gain Notify will report gains.|r");
  elseif (var1 == "4") then
    XGNConfig.channel = "4";
    XGN_AddMessage("|cFF1EFF00This is where Experience Gain Notify will report gains.|r");
  elseif (var1 == "5") then
    XGNConfig.channel = "5";
    XGN_AddMessage("|cFF1EFF00This is where Experience Gain Notify will report gains.|r");
  elseif (var1 == "6") then
    XGNConfig.channel = "6";
    XGN_AddMessage("|cFF1EFF00This is where Experience Gain Notify will report gains.|r");
  elseif (var1 == "7") then
    XGNConfig.channel = "7";
    XGN_AddMessage("|cFF1EFF00This is where Experience Gain Notify will report gains.|r");
  elseif (var1 == "8") then
    XGNConfig.channel = "8";
    XGN_AddMessage("|cFF1EFF00This is where Experience Gain Notify will report gains.|r");
  elseif (var1 == "9") then
    XGNConfig.channel = "9";
    XGN_AddMessage("|cFF1EFF00This is where Experience Gain Notify will report gains.|r");
  end
end

function XGN_AddMessage(msg, label, red, green, blue)
  if (not red) then
    red = 1
  elseif (not green) then
    green = 1
  elseif (not blue) then
    blue = 1
  elseif (not label) then
    label = false
  end

  if ( not label ) then
    getglobal("ChatFrame"..XGNConfig.channel):AddMessage(msg, red, green, blue);
  else
    getglobal("ChatFrame"..XGNConfig.channel):AddMessage("XGN: " .. msg, red, green, blue);
  return 1;
  end
end

function XGN.OnLoad()
  -- Registering Events
  this:RegisterEvent("PLAYER_XP_UPDATE"); -- Fired after doing anything that nets an experience gain
  this:RegisterEvent("VARIABLES_LOADED"); -- Fired immediately after this addon is loaded

  -- Slash Commands
  SLASH_XGN1 = "/xgn";
  SLASH_XGN2 = "/xpgainnotify";
  SlashCmdList["XGN"] = function(var1) XGN_Slash(var1) end
end

function XGN_VARIABLES_LOADED()
  -- Initialize our SavedVariable
  if ( not XGNConfig ) then
     XGNConfig = {};
  end
  if ( not XGNConfig.on ) then
    XGNConfig.on = XGN.default_on;
    XGN.on = XGN.default_on;
  end
  if ( not XGNConfig.channel ) then
    XGNConfig.channel = XGN.default_channel;
  end
  if ( not XGNConfig.red ) then
    XGNConfig.red = XGN.default_red;
  end
  if ( not XGNConfig.blue ) then
    XGNConfig.blue = XGN.default_blue;
  end
  if ( not XGNConfig.green ) then
    XGNConfig.green = XGN.default_green;
  end
  -- Record that we have been loaded.
  XGN_variablesLoaded = true;

  -- Report "Mod Loaded" to Chat Frame
  XGN_AddMessage("<XGN> Experience Gain Notify v1.2 Loaded.");
end

function XGN_TestColors()
  XGN.pct85 = "|cFFFF8000";
  XGN.pct70 = "|cFFA335EE";
  XGN.pct55 = "|cFF0070DE";
  XGN.pct40 = "|cFF1EFF00";
  XGN.pct25 = "|cFFFFFFFF";
  XGN.pct00 = "|cFFFFFFFF";

  XGN_AddMessage("<XGN> Test.");
  -- 85% +
  XGN_AddMessage(XGN.pct85.."+1XP. (85%) 15XP to go.  15 Repititions.|r");
  -- 70% +
  XGN_AddMessage(XGN.pct70.."+1XP. (70%) 30XP to go.  30 Repititions.|r");
  -- 55% +
  XGN_AddMessage(XGN.pct55.."+1XP. (55%) 45XP to go.  45 Repititions.|r");
  -- 40% +
  XGN_AddMessage(XGN.pct40.."+1XP. (40%) 60XP to go.  60 Repititions.|r");
  -- 25% +
  XGN_AddMessage(XGN.pct25.."+1XP. (25%) 75XP to go.  75 Repititions.|r");
  -- 0% +
  XGN_AddMessage(XGN.pct00.."+1XP. (1%) 99XP to go.  99 Repititions.|r");
  XGN_AddMessage("<XGN> End Test.");
  return 0;
end

-- Events that trigger
function XGN.OnEvent(event, a1, a2, a3, a4, a5, a6, a7)
  -- START **PLAYER_XP_UPDATE**
  if (event == "PLAYER_XP_UPDATE") then
    XGN.percentxp = ((floor((UnitXP("player") / UnitXPMax("player")) * 10000)) / 100);

    -- Check for zero.
    if(XGN.currxp == "0" ) then
      XGN.currxp = UnitXP("player");
      XGN_AddMessage("|cFF1EFF00First experience gain of session.  Starting.|r");
    end
    -- Check for nil.
    if(XGN.currxp == nil ) then
      XGN.currxp = UnitXP("player");
      XGN_AddMessage("|cFF1EFF00First experience gain of session.  Starting.|r");
    end

    XGN.prevxp = XGN.currxp;
    XGN.currxp = UnitXP("player");
    XGN.xpgain = (XGN.currxp - XGN.prevxp);
    XGN.exptogo = (UnitXPMax("player") - UnitXP("player"));
    XGN.repetition = ceil(XGN.exptogo / XGN.xpgain);
    if( XGN.firstkill == 1 ) then
    -- Do Nothing
    -- XGN.firstkill = 0;
    else
      if( XGN.repetition > 0 ) then
        if( XGN.repetition == (1/0)) then
        -- Do nothing
        else
          if (XGN.percentxp > 85) then
            XGN.percentxpcolor = "|cFFFF8000"
          elseif (XGN.percentxp > 70) then
            XGN.percentxpcolor = "|cFFA335EE"
          elseif (XGN.percentxp > 55) then
            XGN.percentxpcolor = "|cFF0070DE"
          elseif (XGN.percentxp > 40) then
            XGN.percentxpcolor = "|cFF1EFF00"
          elseif (XGN.percentxp > 25) then
            XGN.percentxpcolor = "|cFFFFFFFF"
          else
            XGN.percentxpcolor = "|cFFFFFFFF"
          end

          XGN.msg ="";
          -- Amount of XP gained.
          XGN.msg = XGN.msg.."+"..XGN.xpgain.."XP. "
          -- Percentage of this level completed.
          XGN.msg = XGN.msg.."("..XGN.percentxpcolor..XGN.percentxp.."%|r) "
          -- Amount of XP till next level.
          XGN.msg = XGN.msg..XGN.percentxpcolor..UnitXPMax("player")-UnitXP("player").."|rXP to go. "
          -- Repititions till level
          XGN.msg = XGN.msg..XGN.repetition.." Repetitions."
          -- Write message to chat window.
          XGN_AddMessage(XGN.msg, false);
        end
      end
    end
  end
  -- EXIT **PLAYER_XP_UPDATE**

  -- START **VARIABLES_LOADED**
  if (event == "VARIABLES_LOADED") then
    XGN_VARIABLES_LOADED();
  end
  -- EXIT **VARIABLES_LOADED**

end
-- EOF