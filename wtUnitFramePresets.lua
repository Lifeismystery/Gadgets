--[[
                                G A D G E T S
      -----------------------------------------------------------------
                            wildtide@wildtide.net
                           DoomSprout: Rift Forums
      -----------------------------------------------------------------
      Gadgets Framework   : v0.10.0
      Project Date (UTC)  : 2013-09-17T18:45:13Z
      File Modified (UTC) : 2013-09-16T14:06:04Z (lifeismystery)
      -----------------------------------------------------------------
--]]
--for k,v in pairs(WT) do print(tostring(k).."="..tostring(v)) end
local toc, data = ...
local AddonId = toc.identifier
local TXT = Library.Translate

local dialog, dialog2 = false
local preview = nil

local testUnit =
{
	id = "UnitFramePresets1",
	unitSpec = "player",
	name = "Lifeismystery",
	lvl = "65",
	hp = "84.5K",
	mp = "17.0K",
	range = "16"
}

local function OnhealthPercent(unitFrame, healthPercent)
	if healthPercent then
		if unitFrame.bar_HP and unitFrame.Backdrop_HP then
			local Unit = unitFrame.Unit
			local delta = (1 - healthPercent) / 100 * (unitFrame.realWidth_HP + 1)
			if unitFrame.HP_bar_insert == false then delta = -delta end
			if healthPercent >= 99.7 then delta = unitFrame.realWidth_HP + 1  end
			unitFrame.bar_HP:SetPoint("TOPLEFT", unitFrame.barMask_HP, "TOPLEFT", delta, 0)
			unitFrame.bar_HP:SetPoint("BOTTOMRIGHT", unitFrame.barMask_HP, "BOTTOMRIGHT", delta, 0)

			unitFrame.bar_HP:SetVisible(true)
			unitFrame.Backdrop_HP:SetVisible(true)
		end
	else
		if unitFrame.bar_HP and unitFrame.Backdrop_HP then
			unitFrame.bar_HP:SetVisible(false)
			unitFrame.Backdrop_HP:SetVisible(false)
		end
	end
end

local function OnresourcePercent(unitFrame, resourcePercent)
	if resourcePercent then
		if unitFrame.bar_MPE and unitFrame.Backdrop_MPE then
			local UnitFrame = unitFrame.Unit
			if UnitFrame["resourceText"] == TXT.Mana then
			unitFrame.canvasSettings.fill_MPE_back = { type = "solid", r = 0.24, g = 0.49, b = 1.0, a = 1.0  }
			unitFrame.bar_MPE:SetShape(unitFrame.canvasSettings.path_MPEmask, unitFrame.canvasSettings.fill_MPE_back, unitFrame.canvasSettings.stroke_HP)
			elseif UnitFrame["resourceText"] == TXT.Energy then
			unitFrame.canvasSettings.fill_MPE_back = { type = "solid", r = 0.86, g = 0.43, b = 0.88, a = 1.0  }
			unitFrame.bar_MPE:SetShape(unitFrame.canvasSettings.path_MPEmask, unitFrame.canvasSettings.fill_MPE_back, unitFrame.canvasSettings.stroke_HP)
			elseif UnitFrame["resourceText"] == TXT.Power then
			unitFrame.canvasSettings.fill_MPE_back = { type = "solid", r = 0.81, g = 0.58, b = 0.16, a = 1.0 }
			unitFrame.bar_MPE:SetShape(unitFrame.canvasSettings.path_MPEmask, unitFrame.canvasSettings.fill_MPE_back, unitFrame.canvasSettings.stroke_HP)
			elseif UnitFrame["resourceText"] == "" then
			unitFrame.canvasSettings.fill_MPE_back = { type = "solid", r = 0.31, g = 0.31, b = 0.31, a = 1.0 }
			unitFrame.bar_MPE:SetShape(unitFrame.canvasSettings.path_MPEmask, unitFrame.canvasSettings.fill_MPE_back, unitFrame.canvasSettings.stroke_HP)
			end
			local delta = (1 - resourcePercent) / 100 * unitFrame.realWidth_MPE + 1
			if resourcePercent >= 99.7 then delta = unitFrame.realWidth_MPE + 1 end
			if unitFrame.MPE_bar_insert == false then delta = -delta end
			unitFrame.bar_MPE:SetPoint("TOPLEFT", unitFrame.barMask_MPE, "TOPLEFT", delta, 0)
			unitFrame.bar_MPE:SetPoint("BOTTOMRIGHT", unitFrame.barMask_MPE, "BOTTOMRIGHT", delta, 0)
			unitFrame.bar_MPE:SetVisible(true)
			unitFrame.Backdrop_MPE:SetVisible(true)
		end
	elseif unitFrame.bar_MPE and unitFrame.Backdrop_MPE then
		local UnitFrame = unitFrame.Unit
		if UnitFrame and UnitFrame["resourceText"] == "" then
			unitFrame.canvasSettings.fill_MPE_back = { type = "solid", r = 0.31, g = 0.31, b = 0.31, a = 1.0 }
			unitFrame.bar_MPE:SetShape(unitFrame.canvasSettings.path_MPEmask, unitFrame.canvasSettings.fill_MPE_back, unitFrame.canvasSettings.stroke_HP)
			unitFrame.bar_MPE:SetVisible(true)
			unitFrame.Backdrop_MPE:SetVisible(true)
			unitFrame.bar_MPE:SetPoint("TOPLEFT", unitFrame.barMask_MPE, "TOPLEFT", 0, 0)
			unitFrame.bar_MPE:SetPoint("BOTTOMRIGHT", unitFrame.barMask_MPE, "BOTTOMRIGHT", 0, 0)
		else
				if unitFrame.bar_MPE and unitFrame.Backdrop_MPE then
			unitFrame.bar_MPE:SetVisible(false)
			unitFrame.Backdrop_MPE:SetVisible(false)
		end
	end
	else
		if unitFrame.bar_MPE and unitFrame.Backdrop_MPE then
			unitFrame.bar_MPE:SetVisible(false)
			unitFrame.Backdrop_MPE:SetVisible(false)
		end
	end
end

local function OnhealthCapPercent(unitFrame, healthCapPercent)
	if healthCapPercent then
		if unitFrame.bar_HealthCap and unitFrame.bar_HP then
			local delta = (100 - healthCapPercent) / 100 * unitFrame.realWidth_HP
			if unitFrame.HP_bar_insert == true then delta = -delta end
			--if healthCapPercent == 100 then delta = unitFrame.realWidth_HP end
			unitFrame.bar_HealthCap:SetPoint("TOPLEFT", unitFrame.barMask_HealthCap, "TOPLEFT", delta, 0)
			unitFrame.bar_HealthCap:SetPoint("BOTTOMRIGHT", unitFrame.barMask_HealthCap, "BOTTOMRIGHT", delta, 0)
			unitFrame.bar_HealthCap:SetVisible(true)
		end
	else
		if unitFrame.bar_HealthCap and unitFrame.bar_HP then
			unitFrame.bar_HealthCap:SetVisible(false)
		end
	end
end

local function OnnameShort(unitFrame, nameShort)
	if nameShort then
		local UnitFrame = unitFrame.Unit
		if UnitFrame.level then
			unitFrame.labelName:SetText(" "..nameShort)
		if UnitFrame.blocked and not UnitFrame.health and not UnitFrame.healthMax and not UnitFrame.offline then
				unitFrame.labelName:SetFontColor(1, 1, 1, 1.0)
		else
			if UnitFrame.player then
				if UnitFrame.offline	then
					unitFrame.labelName:SetFontColor(0.3, 0.3, 0.3, 1.0 )
				elseif UnitFrame.calling == "mage" then
					unitFrame.labelName:SetFontColor(0.8, 0.36, 1.0, 1.0 )
				elseif  UnitFrame.calling == "cleric" then
					unitFrame.labelName:SetFontColor(0.47, 0.94, 0.0, 1.0 )
				elseif  UnitFrame.calling == "rogue" then
					unitFrame.labelName:SetFontColor( 1.0, 0.86, 0.04, 1.0 )
				elseif  UnitFrame.calling == "warrior" then
					unitFrame.labelName:SetFontColor(1.0, 0.15, 0.15, 1.0 )
				elseif  UnitFrame.calling == "primalist" then
					unitFrame.labelName:SetFontColor(0.29, 0.83, 0.98, 1.0 )
				end
			else
				if 	UnitFrame.relation == "hostile" then
					unitFrame.labelName:SetFontColor(0.81, 0.02, 0.04, 1.0)
				elseif 	UnitFrame.relation == "friendly" then
					unitFrame.labelName:SetFontColor(0.17, 1.0, 0.01,1.0)
				elseif not UnitFrame.relation then
					unitFrame.labelName:SetFontColor(1.0, 0.93, 0, 1.0)
				end
			end
		end
			unitFrame.labellvl:SetText(UnitFrame.level.."")
			local lvl = WT.Player.level or 1
		    if lvl == 0 then unitFrame.labellvl:SetFontColor(0.9, 0.9, 0.9, 1.0) end
			if UnitFrame.level == "??" then unitFrame.labellvl:SetFontColor(0.9, 0, 0, 1.0)
			else
			local xpLevel = UnitFrame.level - lvl
			if 	xpLevel == 0  and UnitFrame.player then
				unitFrame.labellvl:SetFontColor(1.0, 1.0, 1.0, 1.0)
			elseif xpLevel >= 5 then
				unitFrame.labellvl:SetFontColor(0.9 , 0, 0, 1.0)
			elseif xpLevel > 2 and xpLevel <= 4 then
				unitFrame.labellvl:SetFontColor(0.9 ,0.5 , 0, 1.0)
			elseif xpLevel >= -2 and xpLevel <= 2 then
				unitFrame.labellvl:SetFontColor(0.9 , 0.9, 0, 1.0)
			elseif xpLevel < -2 and xpLevel >= -5 then
				unitFrame.labellvl:SetFontColor(0, 0.9, 0, 1.0)
			else
				unitFrame.labellvl:SetFontColor(0.9, 0.9, 0.9, 1.0)
			end
			end
		else
			unitFrame.labelName:SetText("")
			unitFrame.labellvl:SetText("")
		end
	end
end

local function CommaFormat(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

local function OnHP(unitFrame, healthPercent)
	if healthPercent then
	local UnitFrame = unitFrame.Unit
		if unitFrame.labelHP then
		local HP = string.format("%0.0f", healthPercent)
		local health = UnitFrame.health
		if (health >= 1000000) then
			health = CommaFormat(string.format("%.1f", health / 1000000)) .. "M"
		elseif health >= 10000 then
			health = CommaFormat(string.format("%.1f", health / 1000)) .. "K"
		end
		if healthPercent == 100 then
		unitFrame.labelHP:SetText(""..health)
		else
		unitFrame.labelHP:SetText(HP.."%".." ".."-".." "..health)
		end
		else
		end
	else
	unitFrame.labelHP:SetText("")
	end
end

local function OnMPE(unitFrame, resourcePercent)
	if resourcePercent then
		if unitFrame.labelMPE then
			local UnitFrame = unitFrame.Unit
			local MPE = string.format("%0.0f", resourcePercent)
			if UnitFrame["resourceText"] == TXT.Mana then
				local mana = UnitFrame.mana
				if (mana >= 1000000) then
					mana = CommaFormat(string.format("%.1f", mana / 1000000)) .. "M"
				elseif mana >= 1000 then
					mana = CommaFormat(string.format("%.1f", mana / 1000)) .. "K"
				end
				if resourcePercent == 100 then
				unitFrame.labelMPE:SetText(" "..mana)
				else
				unitFrame.labelMPE:SetText(MPE.."%".." ".."-".." "..mana)
				end
			elseif UnitFrame["resourceText"] == TXT.Energy then
			unitFrame.labelMPE:SetText(string.format("%0.0f", UnitFrame.energy))
			elseif UnitFrame["resourceText"] == TXT.Power then
			unitFrame.labelMPE:SetText(string.format("%0.0f", UnitFrame.power))
			else
			unitFrame.labelMPE:SetText("")
			end
		else
		unitFrame.labelMPE:SetText("")
		end
	else
	unitFrame.labelMPE:SetText("")
	end
end

local function OnInCombat(unitFrame, inCombat)
	if inCombat then
		unitFrame.Combat:SetVisible(true)
	else
		unitFrame.Combat:SetVisible(false)
	end
end

local function OnPvP(unitFrame, pvp)
	if pvp then
		unitFrame.bar_PvP:SetVisible(true)
		unitFrame.bar_PvP:SetShape(unitFrame.canvasSettings.path_PvP, unitFrame.canvasSettings.fill_PvP, unitFrame.canvasSettings.strokeBack)
	else
		unitFrame.bar_PvP:SetVisible(true)
		unitFrame.bar_PvP:SetShape(unitFrame.canvasSettings.path_PvP, unitFrame.canvasSettings.fill_Grey, unitFrame.canvasSettings.strokeBack)
	end
end

local function OnAggro(unitFrame, aggro)
	if aggro then
		--unitFrame.aggro:SetVisible(true)
		--unitFrame.aggro:SetShape(unitFrame.canvasSettings.path_aggro, unitFrame.canvasSettings.fill_aggro, unitFrame.canvasSettings.strokeBack)
	else
		--unitFrame.aggro:SetVisible(false)
		--unitFrame.aggro:SetShape(unitFrame.canvasSettings.path_aggro, unitFrame.canvasSettings.fill_Grey, unitFrame.canvasSettings.strokeBack)
	end
end

local function OnguaranteedLoot(unitFrame, guaranteedLoot)
	if guaranteedLoot then
		unitFrame.bar_Rare:SetVisible(true)
		unitFrame.bar_Rare:SetShape(unitFrame.canvasSettings.path_PvP, unitFrame.canvasSettings.fill_Rare, unitFrame.canvasSettings.strokeBack)
	else
		unitFrame.bar_Rare:SetVisible(true)
		unitFrame.bar_Rare:SetShape(unitFrame.canvasSettings.path_PvP, unitFrame.canvasSettings.fill_Grey, unitFrame.canvasSettings.strokeBack)
	end
end

local function OntierColor(unitFrame, tierColor)
	if tierColor == "group" then
		unitFrame.bar_Rare:SetVisible(true)
		unitFrame.bar_Rare:SetShape(unitFrame.canvasSettings.path_PvP, unitFrame.canvasSettings.fill_tierGroup, unitFrame.canvasSettings.strokeBack)
	elseif tierColor == "raid" then
		unitFrame.bar_Rare:SetVisible(true)
		unitFrame.bar_Rare:SetShape(unitFrame.canvasSettings.path_PvP, unitFrame.canvasSettings.fill_tierRaid, unitFrame.canvasSettings.strokeBack)
	else
		unitFrame.bar_Rare:SetShape(unitFrame.canvasSettings.path_PvP, unitFrame.canvasSettings.fill_Grey, unitFrame.canvasSettings.strokeBack)
	end
end

local function OnRangeChange(unitFrame, range)
    if range and unitFrame.text_range == true then

		local UnitFrame = unitFrame.Unit
		if UnitFrame.id ~= WT.Player.id then
			if unitFrame.RangeFormat == "rangeShot" then
				Range = string.format("%.0f", range)
			else
				Range = string.format("%.1f", range)
			end
			if range <= 2.9 then
			unitFrame.txtRange:SetText(Range)
			unitFrame.txtRange:SetFontColor(0.6, 1, 0.6, 1)
			unitFrame.Range:SetVisible(true)
			unitFrame.txtRange:SetVisible(true)
			elseif range <= 20 then
			unitFrame.txtRange:SetText(Range)
			unitFrame.txtRange:SetFontColor(1, 1, 0.6, 1)
			unitFrame.Range:SetVisible(true)
			unitFrame.txtRange:SetVisible(true)
			elseif range <= 28 then
			unitFrame.txtRange:SetText(Range)
			unitFrame.txtRange:SetFontColor(1, 1, 0.6, 1)
			unitFrame.Range:SetVisible(true)
			unitFrame.txtRange:SetVisible(true)
			elseif range <= 30 then
			unitFrame.txtRange:SetText(Range)
			unitFrame.txtRange:SetFontColor(1, 0.7, 0.4, 1)
			unitFrame.Range:SetVisible(true)
			unitFrame.txtRange:SetVisible(true)
			elseif range <= 35 then
			unitFrame.txtRange:SetText(Range)
			unitFrame.txtRange:SetFontColor(1, 0.2, 0.2, 1)
			unitFrame.Range:SetVisible(true)
			unitFrame.txtRange:SetVisible(true)
			else
			unitFrame.txtRange:SetText(Range)
			unitFrame.txtRange:SetFontColor(1, 0.2, 0.2, 1)
			unitFrame.Range:SetVisible(true)
			unitFrame.txtRange:SetVisible(true)
			end
		else
			unitFrame.txtRange:SetText(" ")
			unitFrame.Range:SetVisible(false)
			unitFrame.txtRange:SetVisible(false)
		end
	else
		unitFrame.txtRange:SetText(" ")
		unitFrame.Range:SetVisible(false)
		unitFrame.txtRange:SetVisible(false)
	end
end

local function OnAbsorb(unitFrame, absorbPercent)
	if absorbPercent and unitFrame.bar_absorb then
		local UnitFrame = unitFrame.Unit
			local delta = (absorbPercent/100) * unitFrame.realWidth_HP
			unitFrame.bar_absorb:SetWidth(delta)
			if unitFrame.HP_bar_insert == false then delta = -delta end

			if unitFrame.ToLeft == true then
				unitFrame.bar_absorb:SetPoint("BOTTOMLEFT", unitFrame.Backdrop_HP, "BOTTOMLEFT", unitFrame.offset_absorb, unitFrame.offset_MPE)
			else
				unitFrame.bar_absorb:SetPoint("BOTTOMRIGHT", unitFrame.Backdrop_HP, "BOTTOMRIGHT", 0, unitFrame.offset_MPE)
			end

			unitFrame.bar_absorb:SetVisible(true)
	else
		if unitFrame.bar_absorb then
			unitFrame.bar_absorb:SetVisible(false)
		end
	end
end

local function UpdatePreview_Unit(configuration)
	local configuration = data.Unitframe_GetConfiguration()
	preview.config = configuration

	preview:SetWidth(350)
	preview:SetHeight(100)

	data.LayoutFrame(preview.frmUnit, configuration)
	data.UpdateFrame(preview, preview.frmUnit, testUnit)

	preview.frmUnit:SetPoint("CENTER", preview, "CENTER")
end
WT.Control.UpdatePreview_Unit = UpdatePreview_Unit

local function GetConfiguration()
	local config = dialog:GetValues()
	local config2 = dialog2:GetValues()
	for k,v in pairs(config2) do
		config[k] = v
	end
	if config.HP_bar_angle == true then
		config.HP_bar_angle = true
	else
		config.HP_bar_angle = false
	end
	if config.MPE_bar_angle == true then
		config.MPE_bar_angle = true
	else
		config.MPE_bar_angle = false
	end

	return config
end
data.Unitframe_GetConfiguration = GetConfiguration

local function SetConfiguration(config)
	if config.HP_bar_angle == true then
		config.HP_bar_angle = true
	else
		config.HP_bar_angle = false
	end
	if config.MPE_bar_angle == true then
		config.MPE_bar_angle = true
	else
		config.MPE_bar_angle = false
	end

	dialog:SetValues(config)
	dialog2:SetValues(config)

	WT.Preview["UnitframePreview"].config = config
	UpdatePreview_Unit()
end

local function ConfigDialog(container)
	if WT.Preview["UnitframePreview"] == nil then WT.Preview["UnitframePreview"] = {} end
	local lMedia = Library.Media.FindMedia("bar")
	local listMedia = {}
	for mediaId, media in pairs(lMedia) do
		table.insert(listMedia, { ["text"]=mediaId, ["value"]=mediaId })
	end

	local lfont = Library.Media.GetFontIds("font")
	local listfont = {}
	for v, k in pairs(lfont) do
		table.insert(listfont, { value=k })
	end

	local tabs = UI.CreateFrame("SimpleLifeTabView", "tabs", container)
	tabs:SetPoint("TOPLEFT", container, "TOPLEFT")
	tabs:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", 0, -20)

	local frmOptions = UI.CreateFrame("Frame", "frmOptions", tabs.tabContent)
	frmOptions:SetPoint("TOPLEFT", container, "TOPLEFT")
	frmOptions:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", 0, -20)

	local frmText = UI.CreateFrame("Frame", "frmText", tabs.tabContent)
	frmText:SetPoint("TOPLEFT", container, "TOPLEFT")
	frmText:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", 0, -20)

	tabs:SetTabPosition("top")
	tabs:AddTab("Options", frmOptions)
	tabs:AddTab("Text", frmText)


	dialog = WT.Dialog(frmOptions)
		:Checkbox("ToLeft", "Growth direction to left", false) --1
		:Combobox("unitSpec", "Unit to track", "player",
			{
				{text="Player", value="player"},
				{text="Target", value="player.target"},
				{text="Target's Target", value="player.target.target"},
				{text="Focus", value="focus"},
				{text="Focus's Target", value="focus.target"},
				{text="Pet", value="player.pet"},
			}, false)			--1
		:Title("HP bar Options") --3
		:SliderRange("HP_bar_Width", "HP bar width", 150, 400, 230, true) --4
		:SliderRange("HP_bar_Height", "HP bar height", 10, 100, 30, true)--5
		:Checkbox("HP_bar_angle", "Angle of the HP bar 30", false)--6
		:Checkbox("HP_asy_angles", "Asymmetry angles for HP", false)--7
		:ColorPicker("HP_bar_color", "HP bar color", 0.07, 0.07, 0.07, 0.85 )--8
		:ColorPicker("HP_bar_backgroundColor", "HP bar background color", 0.66, 0.22, 0.22, 1 )--9
		:Checkbox("HP_bar_insert", "HP bar insert", false)--10
		:Title("Mana/Power/Energy bar Options") --11
		:SliderRange("MPE_bar_Width", "MPE bar width", 150, 400, 230, true) --12
		:SliderRange("MPE_bar_Height", "MPE bar height", 10, 50, 10, true)--13
		:Checkbox("MPE_bar_angle", "Angle of the MPE bar 30", false)--14
		:Checkbox("MPE_asy_angles", "Asymmetry angles for MPE", false)--15
		:ColorPicker("MPE_bar_color", "MPE bar color", 0.07, 0.07, 0.07, 0.85 )--16
		:ColorPicker("MPE_bar_backgroundColor", "MPE bar background color", 0.00, 0.50, 0.94, 1 )--17
		:Checkbox("MPE_bar_insert", "MPE bar insert", false)--18
		:SliderRange("offset_MPE", "MPE offset from HP bar", 0, 10, 3, true) --19

	dialog2 = WT.Dialog(frmText)
		:Title("Text Options") --1
		:Checkbox("text_name", "Show name", true)--2
		:SliderRange("textFontSize_name", "Font Size Name", 6, 50, 16, true)  --3
		:Select("font_name", "Font name", "#Default", lfont, true, onchange) --4
		:Checkbox("text_HP", "Show HP", true)--5
		:SliderRange("textFontSize_HP", "Font Size HP", 6, 50, 16, true)  --6
		:Select("font_HP", "Font hp", "#Default", lfont, true, onchange) --7
		:Checkbox("text_MPE", "Show MPE", true) --8
		:SliderRange("textFontSize_MPE", "Font Size MPE", 6, 50, 16, true)  --9
		:Select("font_MPE", "Font mpe", "#Default", lfont, true, onchange) --10
		:Checkbox("text_range", "Show Range", true) --11
		:SliderRange("textFontSize_range", "Font Size Range", 6, 50, 16, true)  --12
		:Select("font_range", "Font range", "#Default", lfont, true, onchange) --13
		:Combobox("RangeFormat", "Range Format", "rangeShot",
			{
				{text="5", value="rangeShot"},
				{text="5.3", value="rangeFull"},
			}, false) --14

	preview = UI.CreateFrame("Frame", "frmUnitPreview", container)
	preview:SetPoint("TOPLEFT", container, "TOPRIGHT", 100, 0)
	preview:SetWidth(250)
	preview:SetHeight(200)
	preview:SetLayer(1)
	preview.config = GetConfiguration()
	WT.Preview["UnitframePreview"] = preview
	preview.frmUnit = data.ConstructFrame(preview)
	UpdatePreview_Unit()

	-- dialog
	dialog.fields[1].control.Event.CheckboxChange = UpdatePreview_Unit
	dialog.fields[4].control.Event.SliderChange = UpdatePreview_Unit
	dialog.fields[5].control.Event.SliderChange = UpdatePreview_Unit
	dialog.fields[6].control.Event.CheckboxChange = UpdatePreview_Unit
	dialog.fields[7].control.Event.CheckboxChange = UpdatePreview_Unit
	dialog.fields[8].control.OnColorChanged = UpdatePreview_Unit
	dialog.fields[9].control.OnColorChanged = UpdatePreview_Unit
	dialog.fields[10].control.Event.CheckboxChange = UpdatePreview_Unit
	dialog.fields[12].control.Event.SliderChange = UpdatePreview_Unit
	dialog.fields[13].control.Event.SliderChange = UpdatePreview_Unit
	dialog.fields[14].control.Event.CheckboxChange = UpdatePreview_Unit
	dialog.fields[15].control.Event.CheckboxChange = UpdatePreview_Unit
	dialog.fields[16].control.OnColorChanged = UpdatePreview_Unit
	dialog.fields[17].control.OnColorChanged = UpdatePreview_Unit
	dialog.fields[18].control.Event.CheckboxChange = UpdatePreview_Unit
	dialog.fields[19].control.Event.SliderChange = UpdatePreview_Unit
	-- dialog2
	dialog2.fields[2].control.Event.CheckboxChange = UpdatePreview_Unit
	dialog2.fields[3].control.Event.SliderChange = UpdatePreview_Unit
	dialog2.fields[5].control.Event.CheckboxChange = UpdatePreview_Unit
	dialog2.fields[6].control.Event.SliderChange = UpdatePreview_Unit
	dialog2.fields[8].control.Event.CheckboxChange = UpdatePreview_Unit
	dialog2.fields[9].control.Event.SliderChange = UpdatePreview_Unit
	dialog2.fields[11].control.Event.CheckboxChange = UpdatePreview_Unit
	dialog2.fields[12].control.Event.SliderChange = UpdatePreview_Unit
	dialog2.fields[14].control.GetText = UpdatePreview_Unit
end

local function UpdateFrame(config, frame, testUnit)
	frame:SetVisible(true)
	frame.Height = config.config.HP_bar_Height + config.config.MPE_bar_Height + config.config.offset_MPE
	frame.Width = config.config.HP_bar_Width
	frame.ToLeft = config.config.ToLeft
	frame.UnitSpec = testUnit.unitSpec
	frame.fontEntry_name = Library.Media.GetFont(config.config.font_name)
	frame.fontEntry_HP = Library.Media.GetFont(config.config.font_HP)
	frame.fontEntry_MPE = Library.Media.GetFont(config.config.font_MPE)
	frame.fontEntry_range = Library.Media.GetFont(config.config.font_range)
	frame.HP_bar_Width = config.config.HP_bar_Width
	frame.HP_bar_Height = config.config.HP_bar_Height
	frame.HP_bar_angle = config.config.HP_bar_angle
	frame.HP_bar_color = config.config.HP_bar_color
	frame.HP_asy_angles = config.config.HP_asy_angles
	frame.HP_bar_backgroundColor = config.config.HP_bar_backgroundColor
	frame.HP_bar_insert = config.config.HP_bar_insert
	frame.MPE_bar_Width = config.config.MPE_bar_Width
	frame.MPE_bar_Height = config.config.MPE_bar_Height
	frame.MPE_bar_angle = config.config.MPE_bar_angle
	frame.MPE_bar_color = config.config.MPE_bar_color
	frame.MPE_bar_backgroundColor = config.config.MPE_bar_backgroundColor
	frame.MPE_bar_insert = config.config.MPE_bar_insert
	frame.offset_MPE = config.config.offset_MPE
	frame.MPE_asy_angles = config.config.MPE_asy_angles
	frame.text_name = config.config.text_name
	frame.textFontSize_name = config.config.textFontSize_name
	frame.text_HP = config.config.text_HP
	frame.textFontSize_HP = config.config.textFontSize_HP
	frame.text_MPE = config.config.text_MPE
	frame.textFontSize_MPE = config.config.textFontSize_MPE
	frame.text_range = config.config.text_range
	frame.textFontSize_range = config.config.textFontSize_range

	frame.canvasSettings = {
		angle_HP = config.config.HP_bar_angle,
		angle_MPE = config.config.MPE_bar_angle,
		fill_HP = { type = "solid", r = config.config.HP_bar_color[1], g = config.config.HP_bar_color[2], b = config.config.HP_bar_color[3], a = config.config.HP_bar_color[4] },
		fill_HP_back = { type = "solid", r = config.config.HP_bar_backgroundColor[1], g = config.config.HP_bar_backgroundColor[2], b = config.config.HP_bar_backgroundColor[3], a = config.config.HP_bar_backgroundColor[4] },
		fill_MPE = { type = "solid", r = config.config.MPE_bar_color[1], g = config.config.MPE_bar_color[2], b = config.config.MPE_bar_color[3], a = config.config.MPE_bar_color[4] },
		fill_MPE_back = { type = "solid", r = config.config.MPE_bar_backgroundColor[1], g = config.config.MPE_bar_backgroundColor[2], b = config.config.MPE_bar_backgroundColor[3], a = config.config.MPE_bar_backgroundColor[4] },
	}

	if frame.text_name == true then
		frame.labelName:SetText(tostring(testUnit.name))
		frame.labelName:SetFontSize(frame.textFontSize_name)
		frame.labelName:SetFont(frame.fontEntry_name.addonId, frame.fontEntry_name.filename)
		frame.labelName:SetVisible(true)
		frame.labellvl:SetText(tostring(testUnit.lvl))
		frame.labellvl:SetFontSize(frame.textFontSize_name)
		frame.labellvl:SetFont(frame.fontEntry_name.addonId, frame.fontEntry_name.filename)
		frame.labelName:SetVisible(true)
	else
		frame.labelName:SetVisible(false)
		frame.labellvl:SetVisible(false)
	end
	if frame.text_HP == true then
		frame.labelHP:SetText(tostring(testUnit.hp))
		frame.labelHP:SetFontSize(frame.textFontSize_HP)
		frame.labelHP:SetFont(frame.fontEntry_HP.addonId, frame.fontEntry_HP.filename)
		frame.labelHP:SetVisible(true)
	else
		frame.labelHP:SetVisible(false)
	end
	if frame.text_MPE == true then
		frame.labelMPE:SetText(tostring(testUnit.mp))
		frame.labelMPE:SetFontSize(frame.textFontSize_MPE)
		frame.labelMPE:SetFont(frame.fontEntry_MPE.addonId, frame.fontEntry_MPE.filename)
		frame.labelMPE:SetVisible(true)
	else
		frame.labelMPE:SetVisible(false)
	end
	if frame.text_range == true then
		frame.txtRange:SetText(tostring(testUnit.range))
		frame.txtRange:SetFontSize(frame.textFontSize_range)
		frame.txtRange:SetFont(frame.fontEntry_range.addonId, frame.fontEntry_range.filename)
		frame.txtRange:SetVisible(true)
		frame.Range:SetVisible(true)
	else
		frame.Range:SetVisible(false)
		frame.txtRange:SetVisible(false)
	end

	frame:SetWidth(frame.Width)
	frame:SetHeight(frame.Height)
end
data.UpdateFrame = UpdateFrame

local function LayoutFrame(frame, config)
	config.fontEntry_name = Library.Media.GetFont(config.font_name)
	config.fontEntry_HP = Library.Media.GetFont(config.font_HP)
	config.fontEntry_MPE = Library.Media.GetFont(config.font_MPE)
	config.fontEntry_range = Library.Media.GetFont(config.font_range)
	config.canvasSettings = {
		frameIndent = 0,
		strokeBack = { r = 0, g = 0, b = 0, a = 1, thickness = 1 },
		stroke_HP = { r = 0, g = 0, b = 0, a = 1, thickness = 1 },
		stroke_step = { r = 0.7, g = 0.7, b = 0.7, a = 1, thickness = 0.85 },
		stroke_HealthCap = { r = 0, g = 0, b = 0, a = 1, thickness = 0},
		fill_HP = { type = "solid", r = config.HP_bar_color[1], g = config.HP_bar_color[2], b = config.HP_bar_color[3], a = config.HP_bar_color[4] },
		fill_HP_back = { type = "solid", r = config.HP_bar_backgroundColor[1], g = config.HP_bar_backgroundColor[2], b = config.HP_bar_backgroundColor[3], a = config.HP_bar_backgroundColor[4] },
		fill_HealthCap = { type = "texture", wrap = "clamp", smooth = true, source = AddonId ,  texture = "img/wtGlaze.png" },
		fill_MPE = { type = "solid", r = config.MPE_bar_color[1], g = config.MPE_bar_color[2], b = config.MPE_bar_color[3], a = config.MPE_bar_color[4] },
		fill_MPE_back = { type = "solid", r = config.MPE_bar_backgroundColor[1], g = config.MPE_bar_backgroundColor[2], b = config.MPE_bar_backgroundColor[3], a = config.MPE_bar_backgroundColor[4] },
		fill_PvP = { type = "solid", r = 1.0, g = 0, b = 0, a = 1.0  },
		fill_Rare = { type = "solid", r = 0, g = 0.7, b = 0.7, a = 1.0  },
		fill_absorb = { type = "solid", r = 0.1, g = 0.79, b = 0.79, a = 1.0  } ,
		fill_Grey= { type = "solid", r = 0.3, g = 0.3, b = 0.3, a = 0.85  },
		fill_tierGroup= { type = "solid", r = 1.0, g = 1.0, b = 0, a = 1.0  },
		fill_tierRaid= { type = "solid", r = 1.0, g = 0.5, b = 0, a = 1.0  },
	}
	if config.HP_bar_angle then
		config.canvasSettings.angle_HP = 30
	else
		config.canvasSettings.angle_HP = 0
	end
	if config.MPE_bar_angle then
		config.canvasSettings.angle_MPE = 30
	else
		config.canvasSettings.angle_MPE = 0
	end

	frame:SetWidth(config.HP_bar_Width)
	frame:SetHeight(config.HP_bar_Height + config.MPE_bar_Height + config.offset_MPE)

	frame.Backdrop_HP:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	frame.Backdrop_HP:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, -config.MPE_bar_Height -config.offset_MPE )
	frame.Backdrop_HP:SetLayer(1)
	frame.Backdrop_HP:SetVisible(true)

	frame.Backdrop_MPE:SetLayer(1)
	frame.Backdrop_MPE:SetVisible(true)
	frame.Backdrop_MPE:SetWidth(config.MPE_bar_Width)
	frame.Backdrop_MPE:SetHeight(config.MPE_bar_Height)
	local offset = 0
	if config.ToLeft == true then
		offset = config.HP_bar_Width - config.HP_bar_Width
	else
		offset = - (config.MPE_bar_Width - config.HP_bar_Width)
	end
	frame.Backdrop_MPE:SetPoint("TOPLEFT", frame.Backdrop_HP, "BOTTOMLEFT", offset, config.offset_MPE)

	frame.barMask_HP:SetPoint("TOPLEFT", frame.Backdrop_HP, "TOPLEFT", config.canvasSettings.frameIndent, config.canvasSettings.frameIndent)
	frame.barMask_HP:SetPoint("BOTTOMRIGHT", frame.Backdrop_HP, "BOTTOMRIGHT", -config.canvasSettings.frameIndent, -config.canvasSettings.frameIndent)
	frame.barMask_HP:SetLayer(3)

	local deltaHP = (1 - 75) / 100 * (config.HP_bar_Width + 1)
	if config.HP_bar_insert == false then deltaHP = -deltaHP end
	frame.bar_HP:SetPoint("TOPLEFT", frame.barMask_HP, "TOPLEFT", deltaHP, 0)
	frame.bar_HP:SetPoint("BOTTOMRIGHT", frame.barMask_HP, "BOTTOMRIGHT", deltaHP, 0)
	frame.bar_HP:SetLayer(3)

	frame.barMask_HealthCap:SetPoint("TOPLEFT", frame.Backdrop_HP, "TOPLEFT",  config.canvasSettings.frameIndent, config.canvasSettings.frameIndent)
	frame.barMask_HealthCap:SetPoint("BOTTOMRIGHT", frame.Backdrop_HP, "BOTTOMRIGHT", -config.canvasSettings.frameIndent, -config.canvasSettings.frameIndent)
	frame.barMask_HealthCap:SetLayer(4)

	frame.bar_HealthCap:SetPoint("TOPLEFT", frame.barMask_HealthCap, "TOPLEFT")
	frame.bar_HealthCap:SetPoint("BOTTOMRIGHT", frame.barMask_HealthCap, "BOTTOMRIGHT")

	frame.barMask_MPE:SetPoint("TOPLEFT", frame.Backdrop_MPE, "TOPLEFT", config.canvasSettings.frameIndent, config.canvasSettings.frameIndent)
	frame.barMask_MPE:SetPoint("BOTTOMRIGHT", frame.Backdrop_MPE, "BOTTOMRIGHT", -config.canvasSettings.frameIndent, -config.canvasSettings.frameIndent)
	frame.barMask_MPE:SetLayer(1)

	local deltaMPE = (1 - 50) / 100 * (config.MPE_bar_Width + 1)
	if config.MPE_bar_insert == false then deltaMPE = -deltaMPE end
	frame.bar_MPE:SetPoint("TOPLEFT", frame.barMask_MPE, "TOPLEFT", deltaMPE, 0)
	frame.bar_MPE:SetPoint("BOTTOMRIGHT", frame.barMask_MPE, "BOTTOMRIGHT", deltaMPE, 0)
	frame.bar_MPE:SetLayer(1)

	frame.bar_PvP:SetLayer(5)
	frame.bar_Rare:SetLayer(5)

	local pvpHeight = frame.Backdrop_HP:GetHeight() * 0.85
	if config.ToLeft == true then
		frame.bar_Rare:ClearAll()
		frame.bar_PvP:ClearAll()
		frame.bar_PvP:SetWidth(8)
		frame.bar_Rare:SetWidth(8)
		frame.bar_PvP:SetHeight(pvpHeight)
		frame.bar_Rare:SetHeight(pvpHeight)
		frame.bar_Rare:SetPoint("TOPLEFT", frame.Backdrop_HP, "TOPLEFT", config.canvasSettings.angle_HP + 14, -1)
		frame.bar_PvP:SetPoint("TOPLEFT", frame.bar_Rare, "TOPLEFT", 10, 0)
	else
		frame.bar_Rare:ClearAll()
		frame.bar_PvP:ClearAll()
		frame.bar_PvP:SetWidth(8)
		frame.bar_Rare:SetWidth(8)
		frame.bar_PvP:SetHeight(pvpHeight)
		frame.bar_Rare:SetHeight(pvpHeight)
		frame.bar_Rare:SetPoint("TOPRIGHT", frame.Backdrop_HP, "TOPRIGHT", -config.canvasSettings.angle_HP -14, -1)
		frame.bar_PvP:SetPoint("TOPRIGHT", frame.bar_Rare, "TOPRIGHT", -10, 0)
	end

	frame.bar_absorb:SetVisible(false)
	if config.HP_bar_angle == false then
		config.offset_absorb = 0
	elseif config.HP_bar_angle then
		config.offset_absorb = config.HP_bar_Height*math.tan(math.rad(180-30))
	else
		config.offset_absorb = config.HP_bar_Height*math.tan(math.rad(180-(90+0)))
	end

	if config.ToLeft == true then
		frame.bar_absorb:ClearAll()
		frame.bar_absorb:SetHeight(3)
		frame.bar_absorb:SetPoint("BOTTOMLEFT", frame.Backdrop_HP, "BOTTOMLEFT", config.offset_absorb, config.offset_MPE)
	else
		frame.bar_absorb:ClearAll()
		frame.bar_absorb:SetHeight(3)
		frame.bar_absorb:SetPoint("BOTTOMRIGHT", frame.Backdrop_HP, "BOTTOMRIGHT", -config.offset_absorb, config.offset_MPE)
	end

	frame.OnResize = function()
		--HP
		local tg_HP = math.tan(config.canvasSettings.angle_HP * math.pi / 180)
		local offset_HP = tg_HP * frame.Backdrop_HP:GetHeight() / frame:GetWidth()
		local indentOffset_HP = tg_HP * config.canvasSettings.frameIndent / frame:GetWidth()
		config.realWidth_HP = frame.Backdrop_HP:GetWidth() - math.abs(tg_HP * frame.Backdrop_HP:GetHeight()) - config.canvasSettings.frameIndent * 2
		if config.ToLeft == true then
			offset_HP = - offset_HP
		else
			offset_HP = offset_HP
		end
		config.canvasSettings.path_HP = {
			{ xProportional = 0, yProportional = 0 },
			{ xProportional = 1 - offset_HP, yProportional = 0 },
			{ xProportional = 1, yProportional = 1 },
			{ xProportional = offset_HP, yProportional = 1 },
			{ xProportional = 0, yProportional = 0 }
		}
		config.canvasSettings.path_HPmask = {
			{ xProportional = indentOffset_HP, yProportional = 0 },
			{ xProportional = 1 - offset_HP + indentOffset_HP, yProportional = 0 },
			{ xProportional = 1 - indentOffset_HP, yProportional = 1 },
			{ xProportional = offset_HP - indentOffset_HP, yProportional = 1 },
			{ xProportional = indentOffset_HP, yProportional = 0 },
		}
		config.canvasSettings.path_HP_ass_mask = {
		   { xProportional = indentOffset_HP + offset_HP, yProportional = 0 },
		   { xProportional = 1 - indentOffset_HP , yProportional = 0 },
		   { xProportional = 1 - offset_HP - indentOffset_HP, yProportional = 1 },
		   { xProportional = offset_HP + indentOffset_HP + offset_HP, yProportional = 1 },
		   { xProportional = 0, yProportional = 0 }
		}
		if config.HP_asy_angles == true then
			frame.Backdrop_HP:SetShape(config.canvasSettings.path_HP, config.canvasSettings.fill_HP, config.canvasSettings.strokeBack)
			frame.barMask_HP:SetShape(config.canvasSettings.path_HP_ass_mask)
			frame.bar_HP:SetShape(config.canvasSettings.path_HP_ass_mask, config.canvasSettings.fill_HP_back, config.canvasSettings.stroke_HP)
			frame.barMask_HealthCap:SetShape(config.canvasSettings.path_HP_ass_mask)
			frame.bar_HealthCap:SetShape(config.canvasSettings.path_HP_ass_mask, config.canvasSettings.fill_HealthCap, config.canvasSettings.stroke_HealthCap)
		else
			frame.Backdrop_HP:SetShape(config.canvasSettings.path_HP, config.canvasSettings.fill_HP, config.canvasSettings.strokeBack)
			frame.barMask_HP:SetShape(config.canvasSettings.path_HPmask)
			frame.bar_HP:SetShape(config.canvasSettings.path_HPmask, config.canvasSettings.fill_HP_back, config.canvasSettings.stroke_HP)
			frame.barMask_HealthCap:SetShape(config.canvasSettings.path_HPmask)
			frame.bar_HealthCap:SetShape(config.canvasSettings.path_HPmask, config.canvasSettings.fill_HealthCap, config.canvasSettings.stroke_HealthCap)
		end
		--MPE
		local tg_MPE = math.tan(config.canvasSettings.angle_MPE * math.pi / 180)
		local offset_MPE = - tg_MPE * frame.Backdrop_MPE:GetHeight() / frame:GetWidth()
		if config.ToLeft == true then
			offset_MPE = - offset_MPE
		else
			offset_MPE = offset_MPE
		end
		local indentOffset_MPE = tg_MPE * config.canvasSettings.frameIndent / frame:GetWidth()
		config.realWidth_MPE = frame.Backdrop_MPE:GetWidth() - math.abs(tg_MPE * frame.Backdrop_MPE:GetHeight()) - config.canvasSettings.frameIndent * 2
		config.canvasSettings.path_MPE = {
			{ xProportional = 0, yProportional = 0 },
			{ xProportional = 1 - offset_MPE, yProportional = 0 },
			{ xProportional = 1, yProportional = 1 },
			{ xProportional = offset_MPE, yProportional = 1 }
		}
		config.canvasSettings.path_MPEmask = {
			{ xProportional = indentOffset_MPE, yProportional = 0 },
			{ xProportional = 1 - offset_MPE + indentOffset_MPE, yProportional = 0 },
			{ xProportional = 1 - indentOffset_MPE, yProportional = 1 },
			{ xProportional = offset_MPE - indentOffset_MPE, yProportional = 1 }
		}
		config.canvasSettings.path_MPE_ass = {
		   { xProportional = 0, yProportional = 0 },
		   { xProportional = 1, yProportional = 0 },
		   { xProportional = 1 - offset_MPE, yProportional = 1 },
		   { xProportional = offset_MPE, yProportional = 1 }
		}
		if config.MPE_asy_angles == true then
			frame.Backdrop_MPE:SetShape(config.canvasSettings.path_MPE_ass, config.canvasSettings.fill_MPE, config.canvasSettings.strokeBack)
			frame.barMask_MPE:SetShape(config.canvasSettings.path_MPE_ass)
			frame.bar_MPE:SetShape(config.canvasSettings.path_MPE_ass, config.canvasSettings.fill_MPE_back, config.canvasSettings.stroke_HP)
		else
			frame.Backdrop_MPE:SetShape(config.canvasSettings.path_MPE, config.canvasSettings.fill_MPE, config.canvasSettings.strokeBack)
			frame.barMask_MPE:SetShape(config.canvasSettings.path_MPEmask)
			frame.bar_MPE:SetShape(config.canvasSettings.path_MPEmask, config.canvasSettings.fill_MPE_back, config.canvasSettings.stroke_HP)
		end
		--PvP
		local offset_PvP = tg_HP * frame.bar_PvP:GetHeight() / frame.bar_PvP:GetWidth()
		if config.ToLeft == true then
			offset_PvP = - offset_PvP
		else
			offset_PvP = offset_PvP
		end
		config.canvasSettings.path_PvP = {
			{ xProportional = 0, yProportional = 0 },
			{ xProportional = 1 , yProportional = 0},
			{ xProportional = 1 + offset_PvP, yProportional = 1},
			{ xProportional = offset_PvP, yProportional = 1},
			{ xProportional = 0, yProportional = 0 }
		}
		frame.bar_PvP:SetShape(config.canvasSettings.path_PvP, config.canvasSettings.fill_PvP, config.canvasSettings.strokeBack)
		--Rare
		frame.bar_Rare:SetShape(config.canvasSettings.path_PvP, config.canvasSettings.fill_Rare, config.canvasSettings.strokeBack)
		--Absorb
		local offset_absorb = tg_HP * frame.bar_absorb:GetHeight() / frame:GetWidth()
		local indentOffset_HP = tg_HP * config.canvasSettings.frameIndent / frame:GetWidth()
		frame.realWidth_absorb = frame:GetWidth() - math.abs(tg_HP * frame.bar_absorb:GetHeight()) - config.canvasSettings.frameIndent * 2
		config.canvasSettings.path_absorb = {
			{ xProportional = 0, yProportional = 0 },
			{ xProportional = 1 - offset_absorb, yProportional = 0 },
			{ xProportional = 1, yProportional = 1 },
			{ xProportional = offset_absorb, yProportional = 1 },
			{ xProportional = 0, yProportional = 0 }
		}
		frame.bar_absorb:SetShape(config.canvasSettings.path_absorb, config.canvasSettings.fill_absorb, config.canvasSettings.stroke_HP)
	end
	frame.OnResize()

	if config.text_name == true then
		frame.labelName:SetLayer(6)
		frame.labelName:SetText(tostring(testUnit.name))
		frame.labelName:SetEffectGlow({ strength = 3 })
		frame.labelName:SetFontSize(config.textFontSize_name)
		frame.labelName:SetFont(config.fontEntry_name.addonId, config.fontEntry_name.filename)

		frame.labellvl:SetLayer(6)
		frame.labellvl:SetText(tostring(testUnit.lvl))
		frame.labellvl:SetEffectGlow({ strength = 3 })
		frame.labellvl:SetFontSize(config.textFontSize_name)
		frame.labellvl:SetFont(config.fontEntry_name.addonId, config.fontEntry_name.filename)
		frame.labellvl:SetVisible(config.text_name)

		if config.ToLeft == true then
			frame.labelName:ClearAll()
			frame.labellvl:ClearAll()
			frame.labellvl:SetPoint("BOTTOMRIGHT", frame.Backdrop_HP, "TOPRIGHT",  0, 0)
			frame.labelName:SetPoint("TOPRIGHT", frame.labellvl, "TOPLEFT", 0, 0)
		else
			frame.labelName:ClearAll()
			frame.labellvl:ClearAll()
			frame.labelName:SetPoint("BOTTOMLEFT", frame.Backdrop_HP, "TOPLEFT",  0 , 0)
			frame.labellvl:SetPoint("TOPLEFT", frame.labelName, "TOPRIGHT", 0, 0)
		end
	end
	if config.text_HP == true then
		frame.labelHP:SetLayer(6)
		frame.labelHP:SetText("")
		frame.labelHP:SetEffectGlow({ strength = 3 })
		frame.labelHP:SetFontSize(config.textFontSize_HP or 12)
		frame.labelHP:SetFont(config.fontEntry_HP.addonId, config.fontEntry_HP.filename)
		if config.ToLeft == true then
			frame.labelHP:ClearAll()
			frame.labelHP:SetPoint("BOTTOMLEFT", frame.Backdrop_HP, "TOPLEFT", 0, 0)
		else
			frame.labelHP:ClearAll()
			frame.labelHP:SetPoint("BOTTOMRIGHT", frame.Backdrop_HP, "TOPRIGHT", 0, 0)
		end
	end
	if config.text_MPE == true then
		frame.labelMPE:SetLayer(6)
		frame.labelMPE:SetText("")
		frame.labelMPE:SetEffectGlow({ strength = 3 })
		frame.labelMPE:SetFontSize(config.textFontSize_MPE or 12)
		frame.labelMPE:SetFont(config.fontEntry_MPE.addonId, config.fontEntry_MPE.filename)
		if config.ToLeft == true then
			frame.labelMPE:ClearAll()
			frame.labelMPE:SetPoint("TOPLEFT", frame.Backdrop_MPE, "BOTTOMLEFT", 0, 0 )
		else
			frame.labelMPE:ClearAll()
			frame.labelMPE:SetPoint("TOPRIGHT", frame.Backdrop_MPE, "BOTTOMRIGHT", 0, 0 )
		end
	end
	if config.text_range == true then
		frame.Range:SetLayer(1)
		frame.txtRange:SetLayer(1)
		frame.txtRange:SetText("")
		frame.txtRange:SetEffectGlow({ strength = 3 })
		frame.txtRange:SetFontSize(config.textFontSize_range or 12)
		frame.txtRange:SetFont(config.fontEntry_range.addonId, config.fontEntry_range.filename)
		if config.ToLeft == true then
			frame.Range:ClearAll()
			frame.txtRange:ClearAll()
			frame.Range:SetHeight(20)
			frame.Range:SetWidth(20)
			frame.Range:SetTexture(AddonId, "img/DoubleArrow.png")
			frame.Range:SetPoint("TOPLEFT", frame, "TOPLEFT", - frame.Range:GetWidth(), -5)
			frame.txtRange:SetPoint("TOPRIGHT", frame.Range, "TOPRIGHT", -frame.Range:GetWidth(), frame.txtRange:GetHeight()/2)
		else
			frame.Range:ClearAll()
			frame.txtRange:ClearAll()
			frame.Range:SetHeight(20)
			frame.Range:SetWidth(20)
			frame.Range:SetTexture(AddonId, "img/DoubleArrow2.png")
			frame.Range:SetPoint("TOPRIGHT", frame, "TOPRIGHT", frame.Range:GetWidth(), -5)
			frame.txtRange:SetPoint("CENTERLEFT", frame.Range, "CENTERLEFT", frame.Range:GetWidth(), frame.txtRange:GetHeight()/2)
		end
		frame.Range:SetVisible(false)
	end

	frame.Combat:SetLayer(1)
	frame.Combat:SetVisible(true)
	if config.ToLeft == true then
		frame.Combat:ClearAll()
		frame.Combat:SetHeight(16)
		frame.Combat:SetWidth(16)
		frame.Combat:SetTexture(AddonId, "img/Sword2.png")
		frame.Combat:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", - frame.Combat:GetWidth() - 5, 0)
	else
		frame.Combat:ClearAll()
		frame.Combat:SetHeight(16)
		frame.Combat:SetWidth(16)
		frame.Combat:SetTexture(AddonId, "img/Sword.png")
		frame.Combat:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", frame.Combat:GetWidth() + 5, 0)
	end

	frame.bar_HealthCap:SetVisible(false)
	frame:SetVisible(false)

	-- hide Preview when UnitFramePresets id not selected
	WT.Preview["UnitframePreview"] = frame
	WT.Previews["UnitframePreview"] = WT.Preview["UnitframePreview"]

	WT.Preview.AttachHandle_Preview("UnitframePreview", frame, {})
end

local function ConstructFrame(UnitFrame)
	local frame = UI.CreateFrame("Frame", "UnitFrame", UnitFrame)
	frame.Backdrop_HP = UI.CreateFrame("Canvas", "Backdrop_HP", frame)
	frame.Backdrop_MPE = UI.CreateFrame("Canvas", "Backdrop_MPE", frame)
	frame.barMask_HP = UI.CreateFrame("Mask", "barMask_HP", frame.Backdrop_HP)
	frame.bar_HP = UI.CreateFrame("Canvas", "bar_HP", frame.barMask_HP)
	frame.barMask_HealthCap = UI.CreateFrame("Mask", "barMask_HealthCap", frame.Backdrop_HP)
	frame.bar_HealthCap = UI.CreateFrame("Canvas", "bar_HealthCap", frame.barMask_HealthCap)
	frame.barMask_MPE = UI.CreateFrame("Mask", "barMask_MPE", frame.Backdrop_MPE)
	frame.bar_MPE = UI.CreateFrame("Canvas", "bar_MPE", frame.barMask_MPE)
	frame.bar_PvP = UI.CreateFrame("Canvas", "bar_PvP", frame.Backdrop_HP)
	frame.bar_Rare = UI.CreateFrame("Canvas", "bar_Rare", frame.Backdrop_HP)
	frame.bar_absorb = UI.CreateFrame("Canvas", "bar_absorb", frame)
	frame.labelName = UI.CreateFrame("Text", "labelName", frame.Backdrop_HP)
	frame.labellvl = UI.CreateFrame("Text", "labellvl", frame.Backdrop_HP)
	frame.labelHP = UI.CreateFrame("Text", "labelHP", frame.Backdrop_HP)
	frame.labelMPE = UI.CreateFrame("Text", "labelMPE", frame.Backdrop_HP)
	frame.Range = UI.CreateFrame("Texture", "Range", frame)
	frame.txtRange = UI.CreateFrame("Text", "txtRange", frame)
	frame.Combat = UI.CreateFrame("Texture", "Combat", frame)

	LayoutFrame(frame, UnitFrame.config)

	return frame
end
data.ConstructFrame = ConstructFrame
data.LayoutFrame = LayoutFrame

local function Create(configuration)
	local UnitFrame = WT.UnitFrame:Create(configuration.unitSpec)
	UnitFrame.ToLeft = configuration.ToLeft

	UnitFrame.HP_bar_Width = configuration.HP_bar_Width
	UnitFrame.HP_bar_Height = configuration.HP_bar_Height
	UnitFrame.HP_bar_angle = configuration.HP_bar_angle
	UnitFrame.HP_bar_color = configuration.HP_bar_color
	UnitFrame.HP_bar_backgroundColor = configuration.HP_bar_backgroundColor
	UnitFrame.HP_bar_insert = configuration.HP_bar_insert
	UnitFrame.HP_asy_angles = configuration.HP_asy_angles

	UnitFrame.MPE_bar_Width = configuration.MPE_bar_Width
	UnitFrame.MPE_bar_Height = configuration.MPE_bar_Height
	UnitFrame.MPE_bar_angle = configuration.MPE_bar_angle
	UnitFrame.MPE_bar_color = configuration.MPE_bar_color or {0, 0, 0, 0.85}
	UnitFrame.MPE_bar_backgroundColor = configuration.MPE_bar_backgroundColor or {0.5, 0, 0, 0.85}
	UnitFrame.MPE_bar_insert = configuration.MPE_bar_insert
	UnitFrame.offset_MPE = configuration.offset_MPE
	UnitFrame.MPE_asy_angles = configuration.MPE_asy_angles

	UnitFrame.text_name = configuration.text_name
	UnitFrame.textFontSize_name = configuration.textFontSize_name
	UnitFrame.fontEntry_name = Library.Media.GetFont(configuration.font_name)

	UnitFrame.text_HP = configuration.text_HP
	UnitFrame.textFontSize_HP = configuration.textFontSize_HP
	UnitFrame.fontEntry_HP = Library.Media.GetFont(configuration.font_HP)

	UnitFrame.text_MPE = configuration.text_MPE
	UnitFrame.textFontSize_MPE = configuration.textFontSize_MPE
	UnitFrame.fontEntry_MPE = Library.Media.GetFont(configuration.font_MPE)

	UnitFrame.text_range = configuration.text_range
	UnitFrame.textFontSize_range = configuration.textFontSize_range
	UnitFrame.fontEntry_range = Library.Media.GetFont(configuration.font_range or "#Default")
	UnitFrame.RangeFormat = configuration.RangeFormat or "rangeShot"

	UnitFrame.clickToTarget = configuration.clickToTarget or true
	UnitFrame.contextMenu = configuration.contextMenu or true

	UnitFrame.canvasSettings = {
		unitFrameIndent = 0,
		strokeBack = { r = 0, g = 0, b = 0, a = 1, thickness = 1 },
		stroke_HP = { r = 0, g = 0, b = 0, a = 1, thickness = 1 },
		stroke_step = { r = 0.7, g = 0.7, b = 0.7, a = 1, thickness = 0.85 },
		stroke_HealthCap = { r = 0, g = 0, b = 0, a = 1, thickness = 0},
		fill_HP = { type = "solid", r = UnitFrame.HP_bar_color[1], g = UnitFrame.HP_bar_color[2], b = UnitFrame.HP_bar_color[3], a = UnitFrame.HP_bar_color[4] },
		fill_HP_back = { type = "solid", r = UnitFrame.HP_bar_backgroundColor[1], g = UnitFrame.HP_bar_backgroundColor[2], b = UnitFrame.HP_bar_backgroundColor[3], a = UnitFrame.HP_bar_backgroundColor[4] },
		fill_HealthCap = { type = "texture", wrap = "clamp", smooth = true, source = AddonId ,  texture = "img/wtGlaze.png" },
		fill_MPE = { type = "solid", r = UnitFrame.MPE_bar_color[1], g = UnitFrame.MPE_bar_color[2], b = UnitFrame.MPE_bar_color[3], a = UnitFrame.MPE_bar_color[4] },
		fill_MPE_back = { type = "solid", r = UnitFrame.MPE_bar_backgroundColor[1], g = UnitFrame.MPE_bar_backgroundColor[2], b = UnitFrame.MPE_bar_backgroundColor[3], a = UnitFrame.MPE_bar_backgroundColor[4] },
		fill_PvP = { type = "solid", r = 1.0, g = 0, b = 0, a = 1.0  },
		fill_Rare = { type = "solid", r = 0, g = 0.7, b = 0.7, a = 1.0  },
		fill_absorb = { type = "solid", r = 0.1, g = 0.79, b = 0.79, a = 1.0  } ,
		fill_Grey= { type = "solid", r = 0.3, g = 0.3, b = 0.3, a = 0.85  },
		fill_tierGroup= { type = "solid", r = 1.0, g = 1.0, b = 0, a = 1.0  },
		fill_tierRaid= { type = "solid", r = 1.0, g = 0.5, b = 0, a = 1.0  },
	}

	if UnitFrame.HP_bar_angle then
		UnitFrame.canvasSettings.angle_HP = 30
	else
		UnitFrame.canvasSettings.angle_HP = 0
	end

	if UnitFrame.MPE_bar_angle then
		UnitFrame.canvasSettings.angle_MPE = 30
	else
		UnitFrame.canvasSettings.angle_MPE = 0
	end

	UnitFrame:SetWidth(UnitFrame.HP_bar_Width)
	UnitFrame:SetHeight(UnitFrame.HP_bar_Height + UnitFrame.MPE_bar_Height + UnitFrame.offset_MPE)

	UnitFrame.Backdrop_HP = UI.CreateFrame("Canvas", "Backdrop_HP", UnitFrame)
	UnitFrame.Backdrop_MPE = UI.CreateFrame("Canvas", "Backdrop_MPE", UnitFrame)

	UnitFrame.Backdrop_HP:SetPoint("TOPLEFT", UnitFrame, "TOPLEFT", 0, 0)
	UnitFrame.Backdrop_HP:SetPoint("BOTTOMRIGHT", UnitFrame, "BOTTOMRIGHT", 0, -UnitFrame.MPE_bar_Height -UnitFrame.offset_MPE )
	UnitFrame.Backdrop_HP:SetLayer(1)
	UnitFrame.Backdrop_HP:SetVisible(false)
	UnitFrame.Backdrop_HP:SetWidth(UnitFrame.HP_bar_Width)
	UnitFrame.Backdrop_HP:SetHeight(UnitFrame.HP_bar_Height)

	UnitFrame.Backdrop_MPE:SetLayer(1)
	UnitFrame.Backdrop_MPE:SetVisible(false)
	UnitFrame.Backdrop_MPE:SetWidth(UnitFrame.MPE_bar_Width)
	UnitFrame.Backdrop_MPE:SetHeight(UnitFrame.MPE_bar_Height)

	local offset = 0
	if UnitFrame.ToLeft == true then
		offset = UnitFrame.HP_bar_Width - UnitFrame.HP_bar_Width
	else
		offset = - (UnitFrame.MPE_bar_Width - UnitFrame.HP_bar_Width)
	end
	UnitFrame.Backdrop_MPE:SetPoint("TOPLEFT", UnitFrame.Backdrop_HP, "BOTTOMLEFT", offset, UnitFrame.offset_MPE )

	UnitFrame.barMask_HP = UI.CreateFrame("Mask", "barMask_HP", UnitFrame.Backdrop_HP)
	UnitFrame.barMask_HP:SetPoint("TOPLEFT", UnitFrame.Backdrop_HP, "TOPLEFT", UnitFrame.canvasSettings.unitFrameIndent, UnitFrame.canvasSettings.unitFrameIndent)
	UnitFrame.barMask_HP:SetPoint("BOTTOMRIGHT", UnitFrame.Backdrop_HP, "BOTTOMRIGHT", -UnitFrame.canvasSettings.unitFrameIndent, -UnitFrame.canvasSettings.unitFrameIndent)
	UnitFrame.barMask_HP:SetLayer(3)

	UnitFrame.bar_HP = UI.CreateFrame("Canvas", "bar_HP", UnitFrame.barMask_HP)
	UnitFrame.bar_HP:SetPoint("TOPLEFT", UnitFrame.barMask_HP, "TOPLEFT")
	UnitFrame.bar_HP:SetPoint("BOTTOMRIGHT", UnitFrame.barMask_HP, "BOTTOMRIGHT")
	UnitFrame.bar_HP:SetLayer(3)

	UnitFrame.barMask_HealthCap = UI.CreateFrame("Mask", "barMask_HealthCap", UnitFrame.Backdrop_HP)
	UnitFrame.barMask_HealthCap:SetPoint("TOPLEFT", UnitFrame.Backdrop_HP, "TOPLEFT",  UnitFrame.canvasSettings.unitFrameIndent, UnitFrame.canvasSettings.unitFrameIndent)
	UnitFrame.barMask_HealthCap:SetPoint("BOTTOMRIGHT", UnitFrame.Backdrop_HP, "BOTTOMRIGHT", -UnitFrame.canvasSettings.unitFrameIndent, -UnitFrame.canvasSettings.unitFrameIndent)
	UnitFrame.barMask_HealthCap:SetLayer(4)

	UnitFrame.bar_HealthCap = UI.CreateFrame("Canvas", "bar_HealthCap", UnitFrame.barMask_HealthCap)
	UnitFrame.bar_HealthCap:SetPoint("TOPLEFT", UnitFrame.barMask_HealthCap, "TOPLEFT")
	UnitFrame.bar_HealthCap:SetPoint("BOTTOMRIGHT", UnitFrame.barMask_HealthCap, "BOTTOMRIGHT")

	UnitFrame.barMask_MPE = UI.CreateFrame("Mask", "barMask_MPE", UnitFrame.Backdrop_MPE)
	UnitFrame.barMask_MPE:SetPoint("TOPLEFT", UnitFrame.Backdrop_MPE, "TOPLEFT", UnitFrame.canvasSettings.unitFrameIndent, UnitFrame.canvasSettings.unitFrameIndent)
	UnitFrame.barMask_MPE:SetPoint("BOTTOMRIGHT", UnitFrame.Backdrop_MPE, "BOTTOMRIGHT", -UnitFrame.canvasSettings.unitFrameIndent, -UnitFrame.canvasSettings.unitFrameIndent)
	UnitFrame.barMask_MPE:SetLayer(1)

	UnitFrame.bar_MPE = UI.CreateFrame("Canvas", "bar_MPE", UnitFrame.barMask_MPE)
	UnitFrame.bar_MPE:SetPoint("TOPLEFT", UnitFrame.barMask_MPE, "TOPLEFT")
	UnitFrame.bar_MPE:SetPoint("BOTTOMRIGHT", UnitFrame.barMask_MPE, "BOTTOMRIGHT")
	UnitFrame.bar_MPE:SetLayer(1)

	UnitFrame.bar_PvP = UI.CreateFrame("Canvas", "bar_PvP", UnitFrame.Backdrop_HP)
	UnitFrame.bar_PvP:SetLayer(5)
	UnitFrame.bar_PvP:SetVisible(false)

	UnitFrame.bar_Rare = UI.CreateFrame("Canvas", "bar_Rare", UnitFrame.Backdrop_HP)
	UnitFrame.bar_Rare:SetLayer(5)
	UnitFrame.bar_Rare:SetVisible(false)

	UnitFrame.bar_PvP:SetWidth(8)
	UnitFrame.bar_Rare:SetWidth(8)

	local pvpHeight = UnitFrame.Backdrop_HP:GetHeight() * 0.85
	UnitFrame.bar_PvP:SetHeight(pvpHeight)
	UnitFrame.bar_Rare:SetHeight(pvpHeight)
	if UnitFrame.ToLeft == true then
		UnitFrame.bar_Rare:SetPoint("TOPLEFT", UnitFrame.Backdrop_HP, "TOPLEFT", UnitFrame.canvasSettings.angle_HP + 14, -1)
		UnitFrame.bar_PvP:SetPoint("TOPLEFT", UnitFrame.bar_Rare, "TOPLEFT", 10, 0)
	else
		UnitFrame.bar_Rare:SetPoint("TOPRIGHT", UnitFrame.Backdrop_HP, "TOPRIGHT", - UnitFrame.canvasSettings.angle_HP - 14, -1)
		UnitFrame.bar_PvP:SetPoint("TOPRIGHT", UnitFrame.bar_Rare, "TOPRIGHT", - 10, 0)
	end

	UnitFrame.bar_absorb = UI.CreateFrame("Canvas", "bar_absorb", UnitFrame)
	UnitFrame.bar_absorb:SetVisible(false)
	UnitFrame.bar_absorb:SetHeight(3)
	if UnitFrame.HP_bar_angle == false then
		UnitFrame.offset_absorb = 0
	elseif UnitFrame.HP_bar_angle then
		UnitFrame.offset_absorb = UnitFrame.HP_bar_Height*math.tan(math.rad(180-30))
	else
		UnitFrame.offset_absorb = UnitFrame.HP_bar_Height*math.tan(math.rad(180-(90+0)))
	end

	if UnitFrame.ToLeft == true then
		UnitFrame.bar_absorb:SetPoint("BOTTOMLEFT", UnitFrame.Backdrop_HP, "BOTTOMLEFT", UnitFrame.offset_absorb, UnitFrame.offset_MPE)
	else
		UnitFrame.bar_absorb:SetPoint("BOTTOMRIGHT", UnitFrame.Backdrop_HP, "BOTTOMRIGHT", -UnitFrame.offset_absorb, UnitFrame.offset_MPE)
	end

	UnitFrame.OnResize = function()
		--HP
		local tg_HP = math.tan(UnitFrame.canvasSettings.angle_HP * math.pi / 180)
		local offset_HP = tg_HP * UnitFrame.Backdrop_HP:GetHeight() / UnitFrame:GetWidth()
		local indentOffset_HP = tg_HP * UnitFrame.canvasSettings.unitFrameIndent / UnitFrame:GetWidth()
		UnitFrame.realWidth_HP = UnitFrame.Backdrop_HP:GetWidth() - math.abs(tg_HP * UnitFrame.Backdrop_HP:GetHeight()) - UnitFrame.canvasSettings.unitFrameIndent * 2
		if UnitFrame.ToLeft == true then
			offset_HP = - offset_HP
		else
			offset_HP = offset_HP
		end
		UnitFrame.canvasSettings.path_HP = {
			{ xProportional = 0, yProportional = 0 },
			{ xProportional = 1 - offset_HP, yProportional = 0 },
			{ xProportional = 1, yProportional = 1 },
			{ xProportional = offset_HP, yProportional = 1 },
			{ xProportional = 0, yProportional = 0 }
		}
		UnitFrame.canvasSettings.path_HPmask = {
			{ xProportional = indentOffset_HP, yProportional = 0 },
			{ xProportional = 1 - offset_HP + indentOffset_HP, yProportional = 0 },
			{ xProportional = 1 - indentOffset_HP, yProportional = 1 },
			{ xProportional = offset_HP - indentOffset_HP, yProportional = 1 },
			{ xProportional = indentOffset_HP, yProportional = 0 },
		}
		UnitFrame.canvasSettings.path_HP_ass_mask = {
		   { xProportional = indentOffset_HP + offset_HP, yProportional = 0 },
		   { xProportional = 1 - indentOffset_HP , yProportional = 0 },
		   { xProportional = 1 - offset_HP - indentOffset_HP, yProportional = 1 },
		   { xProportional = offset_HP + indentOffset_HP + offset_HP, yProportional = 1 },
		   { xProportional = 0, yProportional = 0 }
		}
		if UnitFrame.HP_asy_angles == true then
			UnitFrame.Backdrop_HP:SetShape(UnitFrame.canvasSettings.path_HP, UnitFrame.canvasSettings.fill_HP, UnitFrame.canvasSettings.strokeBack)
			UnitFrame.barMask_HP:SetShape(UnitFrame.canvasSettings.path_HP_ass_mask)
			UnitFrame.bar_HP:SetShape(UnitFrame.canvasSettings.path_HP_ass_mask, UnitFrame.canvasSettings.fill_HP_back, UnitFrame.canvasSettings.stroke_HP)
			UnitFrame.barMask_HealthCap:SetShape(UnitFrame.canvasSettings.path_HP_ass_mask)
			UnitFrame.bar_HealthCap:SetShape(UnitFrame.canvasSettings.path_HP_ass_mask, UnitFrame.canvasSettings.fill_HealthCap, UnitFrame.canvasSettings.stroke_HealthCap)
		else
			UnitFrame.Backdrop_HP:SetShape(UnitFrame.canvasSettings.path_HP, UnitFrame.canvasSettings.fill_HP, UnitFrame.canvasSettings.strokeBack)
			UnitFrame.barMask_HP:SetShape(UnitFrame.canvasSettings.path_HPmask)
			UnitFrame.bar_HP:SetShape(UnitFrame.canvasSettings.path_HPmask, UnitFrame.canvasSettings.fill_HP_back, UnitFrame.canvasSettings.stroke_HP)
			UnitFrame.barMask_HealthCap:SetShape(UnitFrame.canvasSettings.path_HPmask)
			UnitFrame.bar_HealthCap:SetShape(UnitFrame.canvasSettings.path_HPmask, UnitFrame.canvasSettings.fill_HealthCap, UnitFrame.canvasSettings.stroke_HealthCap)
		end
		--MPE
		local tg_MPE = math.tan(UnitFrame.canvasSettings.angle_MPE * math.pi / 180)
		local offset_MPE = - tg_MPE * UnitFrame.Backdrop_MPE:GetHeight() / UnitFrame:GetWidth()
		local indentOffset_MPE = tg_MPE * UnitFrame.canvasSettings.unitFrameIndent / UnitFrame:GetWidth()
		UnitFrame.realWidth_MPE = UnitFrame.Backdrop_MPE:GetWidth() - math.abs(tg_MPE * UnitFrame.Backdrop_MPE:GetHeight()) - UnitFrame.canvasSettings.unitFrameIndent * 2
		if UnitFrame.ToLeft == true then
			offset_MPE = - offset_MPE
		else
			offset_MPE = offset_MPE
		end
		UnitFrame.canvasSettings.path_MPE = {
			{ xProportional = 0, yProportional = 0 },
			{ xProportional = 1 - offset_MPE, yProportional = 0 },
			{ xProportional = 1, yProportional = 1 },
			{ xProportional = offset_MPE, yProportional = 1 }
		}
		UnitFrame.canvasSettings.path_MPEmask = {
			{ xProportional = indentOffset_MPE, yProportional = 0 },
			{ xProportional = 1 - offset_MPE + indentOffset_MPE, yProportional = 0 },
			{ xProportional = 1 - indentOffset_MPE, yProportional = 1 },
			{ xProportional = offset_MPE - indentOffset_MPE, yProportional = 1 }
		}
		UnitFrame.canvasSettings.path_MPE_ass = {
		   { xProportional = 0, yProportional = 0 },
		   { xProportional = 1, yProportional = 0 },
		   { xProportional = 1 - offset_MPE, yProportional = 1 },
		   { xProportional = offset_MPE, yProportional = 1 }
		}
		if UnitFrame.MPE_asy_angles == true then
			UnitFrame.Backdrop_MPE:SetShape(UnitFrame.canvasSettings.path_MPE_ass, UnitFrame.canvasSettings.fill_MPE, UnitFrame.canvasSettings.strokeBack)
			UnitFrame.barMask_MPE:SetShape(UnitFrame.canvasSettings.path_MPE_ass)
			UnitFrame.bar_MPE:SetShape(UnitFrame.canvasSettings.path_MPE_ass, UnitFrame.canvasSettings.fill_MPE_back, UnitFrame.canvasSettings.stroke_HP)
		else
			UnitFrame.Backdrop_MPE:SetShape(UnitFrame.canvasSettings.path_MPE, UnitFrame.canvasSettings.fill_MPE, UnitFrame.canvasSettings.strokeBack)
			UnitFrame.barMask_MPE:SetShape(UnitFrame.canvasSettings.path_MPEmask)
			UnitFrame.bar_MPE:SetShape(UnitFrame.canvasSettings.path_MPEmask, UnitFrame.canvasSettings.fill_MPE_back, UnitFrame.canvasSettings.stroke_HP)
		end
		--PvP
		local offset_PvP = tg_HP * UnitFrame.bar_PvP:GetHeight() / UnitFrame.bar_PvP:GetWidth()
		if UnitFrame.ToLeft == true then
			offset_PvP = - offset_PvP
		else
			offset_PvP = offset_PvP
		end
		UnitFrame.canvasSettings.path_PvP = {
			{ xProportional = 0, yProportional = 0 },
			{ xProportional = 1 , yProportional = 0},
			{ xProportional = 1 + offset_PvP, yProportional = 1},
			{ xProportional = offset_PvP, yProportional = 1},
			{ xProportional = 0, yProportional = 0 }
		}
		UnitFrame.bar_PvP:SetShape(UnitFrame.canvasSettings.path_PvP, UnitFrame.canvasSettings.fill_PvP, UnitFrame.canvasSettings.strokeBack)
		--Rare
		UnitFrame.bar_Rare:SetShape(UnitFrame.canvasSettings.path_PvP, UnitFrame.canvasSettings.fill_Rare, UnitFrame.canvasSettings.strokeBack)
		--Absorb
		local offset_absorb = tg_HP * UnitFrame.bar_absorb:GetHeight() / UnitFrame:GetWidth()
		local indentOffset_HP = tg_HP * UnitFrame.canvasSettings.unitFrameIndent / UnitFrame:GetWidth()
		UnitFrame.realWidth_absorb = UnitFrame:GetWidth() - math.abs(tg_HP * UnitFrame.bar_absorb:GetHeight()) - UnitFrame.canvasSettings.unitFrameIndent * 2
		UnitFrame.canvasSettings.path_absorb = {
			{ xProportional = 0, yProportional = 0 },
			{ xProportional = 1 - offset_absorb, yProportional = 0 },
			{ xProportional = 1, yProportional = 1 },
			{ xProportional = offset_absorb, yProportional = 1 },
			{ xProportional = 0, yProportional = 0 }
		}
		UnitFrame.bar_absorb:SetShape(UnitFrame.canvasSettings.path_absorb, UnitFrame.canvasSettings.fill_absorb, UnitFrame.canvasSettings.stroke_HP)
	end
	UnitFrame.OnResize()

	if UnitFrame.text_name == true then
		UnitFrame.labelName = UI.CreateFrame("Text", "labelName", UnitFrame.Backdrop_HP)
		UnitFrame.labelName:SetLayer(6)
		UnitFrame.labelName:SetText("")
		UnitFrame.labelName:SetEffectGlow({ strength = 3 })
		UnitFrame.labelName:SetFontSize(UnitFrame.textFontSize_name or 12)
		UnitFrame.labelName:SetFont(UnitFrame.fontEntry_name.addonId, UnitFrame.fontEntry_name.filename)

		UnitFrame.labellvl = UI.CreateFrame("Text", "labellvl", UnitFrame.Backdrop_HP)
		UnitFrame.labellvl:SetLayer(6)
		UnitFrame.labellvl:SetText("")
		UnitFrame.labellvl:SetEffectGlow({ strength = 3 })
		UnitFrame.labellvl:SetFontSize(UnitFrame.textFontSize_name or 12)
		UnitFrame.labellvl:SetFont(UnitFrame.fontEntry_name.addonId, UnitFrame.fontEntry_name.filename)

		if UnitFrame.ToLeft == true then
			UnitFrame.labellvl:SetPoint("BOTTOMRIGHT", UnitFrame.Backdrop_HP, "TOPRIGHT",  0, 0)
			UnitFrame.labelName:SetPoint("TOPRIGHT", UnitFrame.labellvl, "TOPLEFT", 0, 0)
		else
			UnitFrame.labelName:SetPoint("BOTTOMLEFT", UnitFrame.Backdrop_HP, "TOPLEFT",  0 , 0)
			UnitFrame.labellvl:SetPoint("TOPLEFT", UnitFrame.labelName, "TOPRIGHT", 0, 0)
		end

		UnitFrame:CreateBinding("nameShort", UnitFrame, OnnameShort, nil)
	end
	if UnitFrame.text_HP == true then
		UnitFrame.labelHP = UI.CreateFrame("Text", "labelHP", UnitFrame.Backdrop_HP)
		UnitFrame.labelHP:SetLayer(6)
		UnitFrame.labelHP:SetText("")
		UnitFrame.labelHP:SetEffectGlow({ strength = 3 })
		UnitFrame.labelHP:SetFontSize(UnitFrame.textFontSize_HP or 12)
		UnitFrame.labelHP:SetFont(UnitFrame.fontEntry_HP.addonId, UnitFrame.fontEntry_HP.filename)

		if UnitFrame.ToLeft == true then
			UnitFrame.labelHP:SetPoint("BOTTOMLEFT", UnitFrame.Backdrop_HP, "TOPLEFT", 0, 0)
		else
			UnitFrame.labelHP:SetPoint("BOTTOMRIGHT", UnitFrame.Backdrop_HP, "TOPRIGHT", 0, 0)
		end

		UnitFrame:CreateBinding("healthPercent", UnitFrame, OnHP, nil)
	end
	if UnitFrame.text_MPE == true then
		UnitFrame.labelMPE = UI.CreateFrame("Text", "labelMPE", UnitFrame.Backdrop_HP)
		UnitFrame.labelMPE:SetLayer(6)
		UnitFrame.labelMPE:SetText("")
		UnitFrame.labelMPE:SetEffectGlow({ strength = 3 })
		UnitFrame.labelMPE:SetFontSize(UnitFrame.textFontSize_MPE or 12)
		UnitFrame.labelMPE:SetFont(UnitFrame.fontEntry_MPE.addonId, UnitFrame.fontEntry_MPE.filename)

		if UnitFrame.ToLeft == true then
			UnitFrame.labelMPE:ClearAll()
			UnitFrame.labelMPE:SetPoint("TOPLEFT", UnitFrame.Backdrop_MPE, "BOTTOMLEFT", 0, 0 )
		else
			UnitFrame.labelMPE:ClearAll()
			UnitFrame.labelMPE:SetPoint("TOPRIGHT", UnitFrame.Backdrop_MPE, "BOTTOMRIGHT", 0, 0 )
		end

		UnitFrame:CreateBinding("resourcePercent", UnitFrame, OnMPE, nil)
	end
	if UnitFrame.text_range == true then
		UnitFrame.Range = UI.CreateFrame("Texture", "Range", UnitFrame)
		UnitFrame.Range:SetLayer(1)
		UnitFrame.Range:SetHeight(20)
		UnitFrame.Range:SetWidth(20)

		UnitFrame.txtRange = UI.CreateFrame("Text", "txtRange", UnitFrame)
		UnitFrame.txtRange:SetLayer(1)
		UnitFrame.txtRange:SetText("")
		UnitFrame.txtRange:SetEffectGlow({ strength = 3 })
		UnitFrame.txtRange:SetFontSize(UnitFrame.textFontSize_range or 12)
		UnitFrame.txtRange:SetFont(UnitFrame.fontEntry_range.addonId, UnitFrame.fontEntry_range.filename)

		if UnitFrame.ToLeft == true then
			UnitFrame.Range:SetTexture(AddonId, "img/DoubleArrow.png")
			UnitFrame.Range:SetPoint("TOPLEFT", UnitFrame, "TOPLEFT", - UnitFrame.Range:GetWidth(), -5)
			UnitFrame.txtRange:SetPoint("TOPRIGHT", UnitFrame.Range, "TOPRIGHT", -UnitFrame.Range:GetWidth(), UnitFrame.txtRange:GetHeight()/2)
		else
			UnitFrame.Range:SetTexture(AddonId, "img/DoubleArrow2.png")
			UnitFrame.Range:SetPoint("TOPRIGHT", UnitFrame, "TOPRIGHT", UnitFrame.Range:GetWidth(), -5)
			UnitFrame.txtRange:SetPoint("CENTERLEFT", UnitFrame.Range, "CENTERLEFT", UnitFrame.Range:GetWidth(), UnitFrame.txtRange:GetHeight()/2)
		end
		UnitFrame.Range:SetVisible(false)

		UnitFrame:CreateBinding("range", UnitFrame, OnRangeChange, nil)
	end

	UnitFrame.Combat = UI.CreateFrame("Texture", "Combat", UnitFrame)
	UnitFrame.Combat:SetLayer(1)
	UnitFrame.Combat:SetHeight(16)
	UnitFrame.Combat:SetWidth(16)
	UnitFrame.Combat:SetVisible(false)
	if UnitFrame.ToLeft == true then
		UnitFrame.Combat:SetTexture(AddonId, "img/Sword2.png")
		UnitFrame.Combat:SetPoint("BOTTOMLEFT", UnitFrame, "BOTTOMLEFT", - UnitFrame.Combat:GetWidth() - 5, 0)
	else
		UnitFrame.Combat:SetTexture(AddonId, "img/Sword.png")
		UnitFrame.Combat:SetPoint("BOTTOMRIGHT", UnitFrame, "BOTTOMRIGHT", UnitFrame.Combat:GetWidth() + 5, 0)
	end

	UnitFrame:CreateBinding("healthPercent", UnitFrame, OnhealthPercent, nil)
	UnitFrame:CreateBinding("resourcePercent", UnitFrame, OnresourcePercent, nil)
	UnitFrame:CreateBinding("healthCapPercent", UnitFrame, OnhealthCapPercent, nil)
	UnitFrame:CreateBinding("inCombat", UnitFrame, OnInCombat, nil)
	UnitFrame:CreateBinding("pvp", UnitFrame, OnPvP, nil)
	UnitFrame:CreateBinding("guaranteedLoot", UnitFrame, OnguaranteedLoot, nil)
	UnitFrame:CreateBinding("tierColor", UnitFrame, OntierColor, nil)
	UnitFrame:CreateBinding("aggro", UnitFrame, OnAggro, nil)
	UnitFrame:CreateBinding("absorbPercent", UnitFrame, OnAbsorb, nil)

	UnitFrame:SetSecureMode("restricted")
	UnitFrame:SetMouseoverUnit(UnitFrame.UnitSpec)

	if UnitFrame.clickToTarget then
		UnitFrame.Event.LeftClick = "target @" .. UnitFrame.UnitSpec
	end

	if UnitFrame.contextMenu then
		UnitFrame.Event.RightClick =
			function()
				if UnitFrame.UnitId then
					Command.Unit.Menu(UnitFrame.UnitId)
				end
			end
	end

	return UnitFrame
end

local function Reconfigure(config)

	assert(config.id, "No id provided in reconfiguration details")

	local gadgetConfig = wtxGadgets[config.id]
	local gadget = WT.Gadgets[config.id]

	assert(gadget, "Gadget id does not exist in WT.Gadgets")
	assert(gadgetConfig, "Gadget id does not exist in wtxGadgets")
	assert(gadgetConfig.type == "UnitFramePresets", "Reconfigure Gadget is not a UnitFramePresets")

	-- Detect changes to config and apply them to the gadget

	local requireRecreate = false

	if gadgetConfig.unitSpec ~= config.unitSpec then
		gadgetConfig.unitSpec = config.unitSpec
		requireRecreate = true
	end
	if gadgetConfig.HP_bar_Width ~= config.HP_bar_Width then
		gadgetConfig.HP_bar_Width = config.HP_bar_Width
		requireRecreate = true
	end
	if gadgetConfig.HP_bar_Height ~= config.HP_bar_Height then
		gadgetConfig.HP_bar_Height = config.HP_bar_Height
		requireRecreate = true
	end
	if gadgetConfig.HP_bar_angle ~= config.HP_bar_angle then
		gadgetConfig.HP_bar_angle = config.HP_bar_angle
		requireRecreate = true
	end
	if gadgetConfig.HP_asy_angles ~= config.HP_asy_angles then
		gadgetConfig.HP_asy_angles = config.HP_asy_angles
		requireRecreate = true
	end
	if gadgetConfig.HP_bar_color ~= config.HP_bar_color then
		gadgetConfig.HP_bar_color = config.HP_bar_color
		requireRecreate = true
	end
	if gadgetConfig.HP_bar_backgroundColor ~= config.HP_bar_backgroundColor then
		gadgetConfig.HP_bar_backgroundColor = config.HP_bar_backgroundColor
		requireRecreate = true
	end
	if gadgetConfig.HP_bar_insert ~= config.HP_bar_insert then
		gadgetConfig.HP_bar_insert = config.HP_bar_insert
		requireRecreate = true
	end
	if gadgetConfig.MPE_bar_Width ~= config.MPE_bar_Width then
		gadgetConfig.MPE_bar_Width = config.MPE_bar_Width
		requireRecreate = true
	end
	if gadgetConfig.MPE_bar_Height ~= config.MPE_bar_Height then
		gadgetConfig.MPE_bar_Height = config.MPE_bar_Height
		requireRecreate = true
	end
	if gadgetConfig.MPE_bar_angle ~= config.MPE_bar_angle then
		gadgetConfig.MPE_bar_angle = config.MPE_bar_angle
		requireRecreate = true
	end
	if gadgetConfig.MPE_asy_angles ~= config.MPE_asy_angles then
		gadgetConfig.MPE_asy_angles = config.MPE_asy_angles
		requireRecreate = true
	end
	if gadgetConfig.MPE_bar_color ~= config.MPE_bar_color then
		gadgetConfig.MPE_bar_color = config.MPE_bar_color
		requireRecreate = true
	end
	if gadgetConfig.MPE_bar_backgroundColor ~= config.MPE_bar_backgroundColor then
		gadgetConfig.MPE_bar_backgroundColor = config.MPE_bar_backgroundColor
		requireRecreate = true
	end
	if gadgetConfig.MPE_bar_insert ~= config.MPE_bar_insert then
		gadgetConfig.MPE_bar_insert = config.MPE_bar_insert
		requireRecreate = true
	end
	if gadgetConfig.offset_MPE ~= config.offset_MPE then
		gadgetConfig.offset_MPE = config.offset_MPE
		requireRecreate = true
	end
	if gadgetConfig.text_name ~= config.text_name then
		gadgetConfig.text_name = config.text_name
		requireRecreate = true
	end
	if gadgetConfig.textFontSize_name ~= config.textFontSize_name then
		gadgetConfig.textFontSize_name = config.textFontSize_name
		requireRecreate = true
	end
	if gadgetConfig.font_name ~= config.font_name then
		gadgetConfig.font_name = config.font_name
		gadget.font_name = config.font_name
		requireRecreate = true
	end
	if gadgetConfig.text_HP ~= config.text_HP then
		gadgetConfig.text_HP = config.text_HP
		requireRecreate = true
	end
	if gadgetConfig.textFontSize_HP ~= config.textFontSize_HP then
		gadgetConfig.textFontSize_HP = config.textFontSize_HP
		requireRecreate = true
	end
	if gadgetConfig.font_HP ~= config.font_HP then
		gadgetConfig.font_HP = config.font_HP
		requireRecreate = true
	end
	if gadgetConfig.text_MPE ~= config.text_MPE then
		gadgetConfig.text_MPE = config.text_MPE
		requireRecreate = true
	end
	if gadgetConfig.textFontSize_MPE ~= config.textFontSize_MPE then
		gadgetConfig.textFontSize_MPE = config.textFontSize_MPE
		requireRecreate = true
	end
	if gadgetConfig.text_range ~= config.text_range then
		gadgetConfig.text_range = config.text_range
		requireRecreate = true
	end
	if gadgetConfig.textFontSize_range ~= config.textFontSize_range then
		gadgetConfig.textFontSize_range = config.textFontSize_range
		requireRecreate = true
	end
	if gadgetConfig.font_range ~= config.font_range then
		gadgetConfig.font_range = config.font_range
		requireRecreate = true
	end
	if gadgetConfig.RangeFormat ~= config.RangeFormat then
		gadgetConfig.RangeFormat = config.RangeFormat
		requireRecreate = true
	end

	if requireRecreate then
		WT.Gadget.Delete(gadgetConfig.id)
		WT.Gadget.Create(gadgetConfig)
	end
end

WT.Gadget.RegisterFactory("UnitFramePresets",
	{
		name="UnitFrame Presets",
		description="UnitFrame Presets",
		author="Lifeismystery",
		version="1.1.0",
		iconTexAddon=AddonId,
		iconTexFile="img/menuIcons/unitFramePresets.png",
		["Create"] = Create,
		["ConfigDialog"] = ConfigDialog,
		["GetConfiguration"] = GetConfiguration,
		["SetConfiguration"] = SetConfiguration,
		["Reconfigure"] = Reconfigure,
	})
