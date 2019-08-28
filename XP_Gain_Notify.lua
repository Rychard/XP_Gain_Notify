-- Intializing Variables
  XGN = {} -- Is an array that all variables are stored in.
    XGN.xpgain = nil;
    XGN.currxp = nil;
    XGN.prevxp = nil;
    XGN.percentxp = nil;
    XGN.percentxpcolor = nil;
    XGN.repetition = nil;
    XGN.exptogo = nil;
    XGN.msg = nil;
    XGN.on = nil;
    XGN.variablesloaded = nil;
    XGN.default_on = true;
    XGN.default_channel = 1;
    XGN.default_red = 1;
    XGN.default_blue = 1;
    XGN.default_green = 1;

-- Hook into the WoW API by setting our addon code to execute on certain events.
function XGN_OnLoad()
  XGNFrame:RegisterEvent("PLAYER_XP_UPDATE"); -- Fired after doing anything that nets an experience gain
  XGNFrame:RegisterEvent("VARIABLES_LOADED"); -- Fired immediately after this addon is loaded
end

-- Perform actions whenever an event occurs.
function XGN_OnEvent(self, event, ...)
  if (event == "PLAYER_XP_UPDATE") then
    XGN_ExperienceUpdate();
  elseif (event == "VARIABLES_LOADED") then
    XGN.currxp = UnitXP("player");
    XGN_AddMessage("<XGN> Experience Gain Notify v1.5 Loaded.");
  end
end

function XGN_ExperienceUpdate()
  XGN.percentxp = ((floor((UnitXP("player") / UnitXPMax("player")) * 10000)) / 100);
    XGN.prevxp = XGN.currxp;
  XGN.currxp = UnitXP("player");
  XGN.xpgain = (XGN.currxp - XGN.prevxp);
  XGN.exptogo = (UnitXPMax("player") - UnitXP("player"));
  XGN.repetition = ceil(XGN.exptogo / XGN.xpgain);

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

-- This has hard-coded chat frames in it.  Change it later.
function XGN_AddMessage(msg, label, red, green, blue)
  if (not red) then red = 1
  elseif (not green) then green = 1
  elseif (not blue) then blue = 1
  elseif (not label) then label = false
  end
  if ( not label ) then
    ChatFrame1:AddMessage(msg, red, green, blue);
  else
    ChatFrame1:AddMessage("XGN: " .. msg, red, green, blue);
  return 1;
  end
end

function XGN_TestColors()
  XGN.pct85 = "|cFFFF8000";
  XGN.pct70 = "|cFFA335EE";
  XGN.pct55 = "|cFF0070DE";
  XGN.pct40 = "|cFF1EFF00";
  XGN.pct25 = "|cFFFFFFFF";
  XGN.pct00 = "|cFFFFFFFF";
  XGN_AddMessage("<XGN> Test.");
  XGN_AddMessage(XGN.pct85.."+1XP. (85%) 15XP to go.  15 Repititions.|r");
  XGN_AddMessage(XGN.pct70.."+1XP. (70%) 30XP to go.  30 Repititions.|r");
  XGN_AddMessage(XGN.pct55.."+1XP. (55%) 45XP to go.  45 Repititions.|r");
  XGN_AddMessage(XGN.pct40.."+1XP. (40%) 60XP to go.  60 Repititions.|r");
  XGN_AddMessage(XGN.pct25.."+1XP. (25%) 75XP to go.  75 Repititions.|r");
  XGN_AddMessage(XGN.pct00.."+1XP. (1%) 99XP to go.  99 Repititions.|r");
  XGN_AddMessage("<XGN> End Test.");
  return 0;
end