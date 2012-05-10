--[[
	This file is part of Wildtide's WT Addon Framework
	Wildtide @ Blightweald (EU) / DoomSprout @ forums.riftgame.com

	wtGadgetButton
	Handles the Gadget Button
--]]

local toc, data = ...
local AddonId = toc.identifier

local STR = WT.Strings


local btnGadget = UI.CreateFrame("Texture", AddonId .. "_btnGadget", WT.Context)
btnGadget:SetTexture(AddonId, "img/btnGadgetMenu.png")

local btnDragging = false
local btnStartX = 0
local btnStartY = 0
local btnMouseStartX = 0
local btnMouseStartY = 0
local btnDragged = false

local function btnDragStart()
	WT.Utility.DeAnchor(btnGadget)
	local mouse = Inspect.Mouse()
	btnDragging = true
	btnStartX = btnGadget:GetLeft()
	btnStartY = btnGadget:GetTop()
	btnMouseStartX = mouse.x
	btnMouseStartY = mouse.y
	btnDragged = false	
end

local draggedEnough = false
local function btnDragMove()
	if btnDragging then
		local mouse = Inspect.Mouse()

		if not draggedEnough then
			local deltaX = math.abs(mouse.x - btnMouseStartX)
			local deltaY = math.abs(mouse.y - btnMouseStartY)
			if deltaX > 8 or deltaY > 8 then
				draggedEnough = true
			end
		end

		if not draggedEnough then return end

		local x = mouse.x - btnMouseStartX + btnStartX
		local y = mouse.y - btnMouseStartY + btnStartY
		btnGadget:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, y)
		wtxOptions.btnGadgetX = x
		wtxOptions.btnGadgetY = y
		btnDragged = true	
	end
end

local function btnDragStop()
	btnDragging = false
	draggedEnough = false
	-- try to detect a left click instead of a drag
	if not btnDragged then
		if WT.Gadget.Locked() then
			WT.Gadget.UnlockAll()
		else
			WT.Gadget.LockAll()
		end
	end
end

local menuItems = {}
local menuItemsAdd = 1
local menuItemsToggleLock = 2
menuItems[menuItemsAdd] = {text=STR.AddGadget, value=function() WT.Gadget.ShowCreationUI() end } 
menuItems[menuItemsToggleLock] = {text=STR.UnlockGadgets, value=function() WT.Gadget.Command.toggle() end }

local btnMenu = WT.Control.Menu.Create(btnGadget, menuItems)
btnMenu:SetPoint("TOPRIGHT", btnGadget, "CENTER")

local function btnShowMenu()
	btnMenu:Toggle()
end

btnGadget.Event.LeftDown = btnDragStart
btnGadget.Event.MouseMove = btnDragMove
btnGadget.Event.LeftUp = btnDragStop
btnGadget.Event.LeftUpoutside = btnDragStop
btnGadget.Event.RightClick = btnShowMenu



-- API METHODS

function WT.Gadget.ResetButton()
	WT.Utility.DeAnchor(btnGadget)
	btnGadget:ClearPoint("LEFT")
	btnGadget:ClearPoint("TOP")
	btnGadget:SetPoint("CENTER", UIParent, "CENTER")
	wtxOptions.btnGadgetX = btnGadget:GetLeft()
	wtxOptions.btnGadgetY = btnGadget:GetTop()
end



local function Initialize()
	if (wtxOptions.btnGadgetX and wtxOptions.btnGadgetY) then
		btnGadget:SetPoint("TOPLEFT", UIParent, "TOPLEFT", wtxOptions.btnGadgetX, wtxOptions.btnGadgetY)
	else
		btnGadget:SetPoint("CENTER", UIParent, "CENTER")
	end
end


-- Register an initializer to handle loading of gadgets
table.insert(WT.Initializers, Initialize)

table.insert(WT.Event.GadgetsLocked, 
{
	function()
		menuItems[menuItemsToggleLock].text = STR.UnlockGadgets
		btnMenu:SetItems(menuItems)
	end, 
	AddonId, AddonId .. "_GadgetsLocked"
})

table.insert(WT.Event.GadgetsUnlocked, 
{
	function()
		menuItems[menuItemsToggleLock].text = STR.LockGadgets
		btnMenu:SetItems(menuItems)
	end, 
	AddonId, AddonId .. "_GadgetsUnlocked"
})
