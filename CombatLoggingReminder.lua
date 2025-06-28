local function IsInRaid()
	return UnitInRaid("player") == 1
end

local function IsEnteringInstance()
	local x, y = GetPlayerMapPosition("player")
	if x == nil or y == nil then
		return true
	end
	return x == y and y == 0
end

local function IsEnteringRaid()
	return IsInRaid() and IsEnteringInstance()
end

local function EnableCombatLogging()
	LoggingCombat(1)
	DEFAULT_CHAT_FRAME:AddMessage("Combat Logging Enabled")
end

local function DisableCombatLogging()
	LoggingCombat(0)
	DEFAULT_CHAT_FRAME:AddMessage("Combat Logging Disabled")
end

local function HandlePlayerEnteringWorld(self, event, msg)
	if IsEnteringRaid() and LoggingCombat() ~= 1 then
		StaticPopup_Show("ENABLE_COMBAT_LOGGING")
	end
	if not IsEnteringRaid() and not IsInRaid() and LoggingCombat() == 1 then
		DisableCombatLogging()
	end
end

local EventFrame = CreateFrame("Frame", "EventFrame")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:SetScript("OnEvent", HandlePlayerEnteringWorld)

StaticPopupDialogs["ENABLE_COMBAT_LOGGING"] = {
	text = "Would you like to enable Combat Logging?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = EnableCombatLogging,
	timeout = 30,
	whileDead = true,
	hideOnEscape = true
}
