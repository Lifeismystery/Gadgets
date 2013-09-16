--[[
                                G A D G E T S
      -----------------------------------------------------------------
                            wildtide@wildtide.net
                           DoomSprout: Rift Forums 
      -----------------------------------------------------------------
      Gadgets Framework   : v0.4.8
      Project Date (UTC)  : 2013-07-04T23:34:42Z
      File Modified (UTC) : 2013-05-20T07:13:55Z (Wildtide)
      -----------------------------------------------------------------     
--]]

local toc, data = ...
local AddonId = toc.identifier
local TXT = Library.Translate

-- Events ---------------------------------------------------------------------
WT.Event.Trigger.SettingsChanged, WT.Event.SettingsChanged = Utility.Event.Create(AddonId, "SettingsChanged")
-------------------------------------------------------------------------------
wtxGadgets = wtxGadgets or {}

local window = nil
local btnOK = nil
local btnCancel = nil
local txtBlackList = nil

local radFormatShort = nil
local radFormatLong = nil
local radFormatNone = nil

local ufDialog = false

local function OnWindowClosed()
	WT.Utility.ClearKeyFocus(window)		
end

local function SaveSettings()

	wtxOptions.buffsBlacklist = {}
	local blacklist = txtBlackList:GetText():wtSplit("\r")
	for idx, buff in ipairs(blacklist) do
		local blBuff = buff:wtTrim()
		if blBuff:len() > 0 then
			wtxOptions.buffsBlacklist[blBuff] = true
		end
	end
	
	if radFormatLong:GetSelected() then
		wtxOptions.numberFormat = "long"
	elseif radFormatNone:GetSelected() then
		wtxOptions.numberFormat = "none"
	else
		wtxOptions.numberFormat = "short"
	end
	
	if wtxOptions.prRoles == true then
		ProfileRolesOption = true
	else
	    ProfileRolesOption = false
	end
	
	OnWindowClosed()
	window:SetVisible(false)
	
	WT.Event.Trigger.SettingsChanged()

end

local function GetBlacklistedBuffs()
	local blacklist = ""
	if wtxOptions.buffsBlacklist then
		local sorted = {}
		for buff in pairs(wtxOptions.buffsBlacklist) do
			table.insert(sorted, buff)
		end
		table.sort(sorted)
		for idx, buff in ipairs(sorted) do
			blacklist = blacklist .. buff .. "\n"
		end	
	end
	return blacklist
end

function WT.Gadget.ShowSettings()

	if not window then
	
		window = UI.CreateFrame("SimpleWindow", "winGadgetSettings", WT.Context)
		window:SetCloseButtonVisible(true)		
		window:SetTitle(TXT.Settings)
		window:SetPoint("CENTER", UIParent, "CENTER")
	--	window:SetLayer(10010)
		window:SetWidth(800)
		window:SetHeight(650)
		
		window.Event.Close = OnWindowClosed

		local tabs = UI.CreateFrame("SimpleTabView", "buffTabs", window)
		tabs:SetPoint("TOPLEFT", window:GetContent(), "TOPLEFT", 8, 8)
		tabs:SetPoint("BOTTOMRIGHT", window:GetContent(), "BOTTOMRIGHT", -8, -50)
		tabs:SetTabPosition("left")


		local btnOK = UI.CreateFrame("RiftButton", "btnOK", window)
		btnOK:SetPoint("TOPLEFT", tabs, "BOTTOMLEFT", 0, 4)
		btnOK:SetText("Save")
		btnOK.Event.LeftPress = SaveSettings

		local contentOptions = UI.CreateFrame("Frame", "contentOptions", tabs.tabContent)
		contentOptions:SetAllPoints(window:GetContent())
		
		local labNumberFormat = UI.CreateFrame("Text", "txtNumberFormat", contentOptions)
		labNumberFormat:SetText("Number Format:")
		labNumberFormat:SetFontSize(14)
		labNumberFormat:SetPoint("TOPLEFT", contentOptions, "TOPLEFT", 8, 8)
		
		radFormatShort = UI.CreateFrame("SimpleRadioButton", "radFormatShort", contentOptions)
		radFormatShort:SetText("Abbreviated (1.2K)")
		radFormatShort:SetPoint("TOPLEFT", labNumberFormat, "TOPLEFT", 150, 0)

		radFormatLong = UI.CreateFrame("SimpleRadioButton", "radFormatLong", contentOptions)
		radFormatLong:SetText("Comma Separated (1,234)")
		radFormatLong:SetPoint("TOPLEFT", radFormatShort, "BOTTOMLEFT", 0, 4)

		radFormatNone = UI.CreateFrame("SimpleRadioButton", "radFormatLong", contentOptions)
		radFormatNone:SetText("No Formatting (1234)")
		radFormatNone:SetPoint("TOPLEFT", radFormatLong, "BOTTOMLEFT", 0, 4)
		
		local radGroupNumFormat = Library.LibSimpleWidgets.RadioButtonGroup("radGroupNumFormat")
		radGroupNumFormat:AddRadioButton(radFormatShort)
		radGroupNumFormat:AddRadioButton(radFormatLong)
		radGroupNumFormat:AddRadioButton(radFormatNone)
		
		local selOption = wtxOptions.numberFormat or "short"
		if selOption == "none" then
			radFormatNone:SetSelected(true)
		elseif selOption == "long" then
			radFormatLong:SetSelected(true)
		else
			radFormatShort:SetSelected(true)
		end
		
		local contentBuffSettings = UI.CreateFrame("Frame", "contentBuffSettings", tabs.tabContent)
		contentBuffSettings:SetAllPoints(window:GetContent())

		local labBlackList = UI.CreateFrame("Text", "txtBlackListHeader", contentBuffSettings)
		labBlackList:SetText(TXT.BuffBlackList)
		labBlackList:SetFontSize(14)
		labBlackList:SetPoint("TOPLEFT", contentBuffSettings, "TOPLEFT", 8, 8)
		
		local frmBlackList = UI.CreateFrame("Frame", "frmBuffBlackList", contentBuffSettings)
		frmBlackList:SetBackgroundColor(1,1,1,1)
		frmBlackList:SetPoint("TOPLEFT", labBlackList, "BOTTOMLEFT", 0, 0)
		frmBlackList:SetPoint("RIGHT", contentBuffSettings, "CENTERX", -8, nil)
		frmBlackList:SetHeight(200)
			
		txtBlackList = UI.CreateFrame("SimpleTextArea", "txtBuffBlackList", frmBlackList)
		txtBlackList:SetBackgroundColor(0.3,0.3,0.3,1.0)
		txtBlackList:SetText(GetBlacklistedBuffs())
		txtBlackList:SetPoint("TOPLEFT", frmBlackList, "TOPLEFT", 1, 1)
		txtBlackList:SetPoint("BOTTOMRIGHT", frmBlackList, "BOTTOMRIGHT", -1, -1)
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-----------------------------Profile settings--------------------------------------------
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
		local contentProfileSettings = UI.CreateFrame("Frame", "contentProfileSettings", tabs.tabContent)
		contentProfileSettings:SetAllPoints(window:GetContent())
-------------------------------Save Profile----------------------------------------------
		local labProfile = UI.CreateFrame("Text", "txtProfile", contentProfileSettings)
		labProfile:SetText("Enter name to save Profile")
		labProfile:SetFontSize(14)
		labProfile:SetPoint("TOPLEFT", contentProfileSettings, "TOPLEFT", 8, 8)
			
		txtProfile = UI.CreateFrame("RiftTextfield", "txtProfile", labProfile)
		txtProfile:SetBackgroundColor(0.2, 0.2, 0.2, 1.0)
		txtProfile:SetText("")
		txtProfile:SetPoint("TOPLEFT", labProfile, "TOPLEFT", 200, 1)
		txtProfile:SetWidth(200)
		local n = txtProfile:GetText()
		
		local btnSaveProfile = UI.CreateFrame("Frame", "btnSaveProfile", contentProfileSettings)
		btnSaveProfile:SetWidth(100)
		btnSaveProfile:SetHeight(20)
		btnSaveProfile:SetBackgroundColor(0.2,0.4,0.6,1.0)
		btnSaveProfile:SetPoint("TOPLEFT", txtProfile, "TOPLEFT", 220, 0)	
		btnSaveProfile.Event.MouseIn = function() btnSaveProfile:SetBackgroundColor(0.4,0.6,0.8,1.0) end
		btnSaveProfile.Event.MouseOut = function() btnSaveProfile:SetBackgroundColor(0.2,0.4,0.6,1.0) end
		btnSaveProfile.Event.LeftClick =
			function ()
				local layoutName = txtProfile:GetText()
				if layoutName == nil then
					print("Please enter profile name.")
				else
					wtxLayouts[layoutName] = wtxGadgets
					print("Profile "..layoutName.." has been saved.")
					WT.Gadget.RecommendReload()	

				end		
			end
			
		local btnSaveProfileTxt = UI.CreateFrame("Text", "txtbtnSaveProfileTxt", btnSaveProfile)
		btnSaveProfileTxt:SetText("Save profile")
		btnSaveProfileTxt:SetFontSize(14)
		btnSaveProfileTxt:SetPoint("TOPLEFT", btnSaveProfile, "TOPLEFT", 10, 0)
-------------------------------Delete Profile--------------------------------------------		
		local labProfileDelete = UI.CreateFrame("Text", "txtProfileDelete", contentProfileSettings)
		labProfileDelete:SetText("Select profile for delete")
		labProfileDelete:SetFontSize(14)
		labProfileDelete:SetPoint("TOPLEFT", contentProfileSettings, "TOPLEFT", 8, 35)

		layoutNameList = UI.CreateFrame("SimpleSelect", "Profile List", contentProfileSettings)
		layoutNameList:SetPoint("TOPLEFT", labProfileDelete, "TOPLEFT", 200, 1)
		layoutNameList:SetHeight(25)
		layoutNameList:SetLayer(3)
		layoutNameList:SetFontSize(14)
		getlayoutNameList(layoutName)
		layoutNameList:ResizeToFit()
		
		local btnDeleteProfile = UI.CreateFrame("Frame", "btnDeleteProfile", contentProfileSettings)
		btnDeleteProfile:SetWidth(100)
		btnDeleteProfile:SetHeight(20)
		btnDeleteProfile:SetBackgroundColor(0.2,0.4,0.6,1.0)
		btnDeleteProfile:SetPoint("TOPLEFT", labProfileDelete, "TOPLEFT", 420, 1)	
		btnDeleteProfile.Event.MouseIn = function() btnDeleteProfile:SetBackgroundColor(0.4,0.6,0.8,1.0) end
		btnDeleteProfile.Event.MouseOut = function() btnDeleteProfile:SetBackgroundColor(0.2,0.4,0.6,1.0) end
		btnDeleteProfile.Event.LeftClick = 
			function ()
				if layoutNameList:GetSelectedItem()  then
					local layoutName = layoutNameList:GetSelectedItem()
					wtxLayouts[layoutName] = nil
					print("Profile "..layoutName.." has been deleted.")
					WT.Gadget.RecommendReload()	
				end
			end 
					
		local btnDeleteProfileTxt = UI.CreateFrame("Text", "txtbtnDeleteProfileTxt", btnDeleteProfile)
		btnDeleteProfileTxt:SetText("Delete profile")
		btnDeleteProfileTxt:SetFontSize(14)
		btnDeleteProfileTxt:SetPoint("TOPLEFT", btnDeleteProfile, "TOPLEFT", 10, 0)	
-------------------------------Profile - Roles--------------------------------------------	
		local labProfileRoles = UI.CreateFrame("Text", "txtProfileRoles", contentProfileSettings)
		labProfileRoles:SetText("__________________________Profile - Roles_____________________________")
		labProfileRoles:SetFontSize(18)
		labProfileRoles:SetPoint("TOPLEFT", contentProfileSettings, "TOPLEFT", 8, 70)
		
		local ProfileRoles = UI.CreateFrame("SimpleCheckbox", "ProfileRoles", contentProfileSettings)
		ProfileRoles:SetPoint("TOPLEFT", labProfileRoles, "TOPLEFT", 8, 50)
		ProfileRoles:SetFontSize(14)
		ProfileRoles:SetText("Show window Importlayout when you change role")	
		ProfileRoles.Event.CheckboxChange  = 
			function ()	
				if ProfileRoles:GetChecked() == true then
				ProfileRolesOption = true
				wtxOptions.prRoles = ProfileRolesOption
				end
				if ProfileRoles:GetChecked() == false then
				ProfileRolesOption = false
				wtxOptions.prRoles  = ProfileRolesOption
				end
			end
			if wtxOptions.prRoles == true then 
				ProfileRoles:SetChecked(true) 
			else  
				ProfileRoles:SetChecked(false) 
			end
			
------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
		tabs:AddTab("General", contentOptions)
		tabs:AddTab("Buffs/Debuffs", contentBuffSettings)
		tabs:AddTab("Profiles", contentProfileSettings)
		
	end

	window:SetVisible(true)
end

function getlayoutNameList(layoutName)
	addlist = nil
	addlist = {}
	for i, v in pairs(wtxLayouts) do
		table.insert(addlist, ""..i)	-- Concatenated to a string incase the user saves thier entry as a number
	end
	layoutNameList:SetItems(addlist)
	layoutNameList:SetSelectedItem(layoutName, silent)
end

local function RoleChange(hEvent, unitId)
	if wtxOptions.prRoles == true then
		if unit == player then WT.Gadget.ShowImportDialog() end
	end
end	
Command.Event.Attach(Event.Unit.Detail.Role, RoleChange, "RoleChange")