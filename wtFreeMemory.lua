local toc, data = ...
local AddonId = toc.identifier
local TXT = Library.Translate


-- Provides a simple button that reloads the UI when clicked

local function Create(configuration)
	local control = UI.CreateFrame("RiftButton", WT.UniqueName("wtCleanMem"), WT.Context)
	control:SetText("Free Memory")
	control:SetSecureMode("restricted")
	control:EventAttach(Event.UI.Input.Mouse.Left.Click, function() collectgarbage() end,"Event.UI.Input.Mouse.Left.Click")
	return control
end


local dialog = false

local function ConfigDialog(container)
	dialog = WT.Dialog(container)
		:Label("The Free Memory button is useful for addon development. You probably don't want to use this if you're not a developer.")
end

local function GetConfiguration()
	return dialog:GetValues()
end

local function SetConfiguration(config)
	dialog:SetValues(config)
end


WT.Gadget.RegisterFactory("FreeMemory",
{
	name="FreeMemory",
	description="FreeMemory",
	author="Wildtide",
	version="1.0.0",
	iconTexAddon=AddonId,
	iconTexFile="img/menuIcons/wtReload.png",
	["Create"] = Create,
	["ConfigDialog"] = ConfigDialog,
	["GetConfiguration"] = GetConfiguration, 
	["SetConfiguration"] = SetConfiguration, 
})
