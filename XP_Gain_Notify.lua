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

    XGN.pct85 = "|cFFFF8000";
    XGN.pct70 = "|cFFA335EE";
    XGN.pct55 = "|cFF0070DE";
    XGN.pct40 = "|cFF1EFF00";
    XGN.pct25 = "|cFFFFFFFF";
    XGN.pct00 = "|cFFFFFFFF";

  XGN_version = "v1.7";
  XGN_versionDate = "11/29/2010";
  XGN_debug = false;

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
    local version = " |cFF1EFF00" .. XGN_version .. "|r [|cFF1EFF00" .. XGN_versionDate .. "|r] ";
    XGN_AddMessage("Experience Gain Notify" .. version .. "Loaded.");
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
      XGN_AddMessage(XGN.msg);

      -- Now that we've outputted our character's XP information...
      -- I think it would be nice to do the same for our pet.  (Hunters only!)

      local cClass = UnitClass("player");
      if(cClass == "Hunter" and UnitExists("pet")) then
        local cLevel = UnitLevel("player");
        local pLevel = UnitLevel("pet");

        if(pLevel < cLevel) then
          local petXP_curr, petXP_next = GetPetExperience();
          local petXP_togo = petXP_next - petXP_curr;
          local petXP_percent = (floor((petXP_curr / petXP_next) * 10000) / 100);
          local petXP_repetition = ceil(petXP_togo / XGN.xpgain);
          local petXP_msg = "|cFF1EFF00<PET>|r +"..XGN.xpgain.."XP. ("..petXP_percent.."%) "..petXP_togo.."XP to go. "..petXP_repetition.." Repetitions."
          XGN_AddMessage(petXP_msg);
        end -- end if
      end -- end if
    end -- end if
  end -- end if
end -- end function

function XGN_AddMessage(msg, label, red, green, blue)
  if (not red) then red = 1
  elseif (not green) then green = 1
  elseif (not blue) then blue = 1
  elseif (not label) then label = false
  end
  if ( label ) then
    ChatFrame1:AddMessage(msg, red, green, blue);
  else
    msg = "|cFF1EFF00<XGN>|r " .. msg;
    ChatFrame1:AddMessage(msg, red, green, blue);
  return 1;
  end
end