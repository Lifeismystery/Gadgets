local toc, data = ...
local AddonId = toc.identifier

--Frame Configuration Options
local AHealFrame = WT.UnitFrame:Template("Aileen Heal Frame")
AHealFrame.Configuration.Name = "Aileen Heal Frame"
AHealFrame.Configuration.RaidSuitable = true
AHealFrame.Configuration.UnitSuitable = false
AHealFrame.Configuration.FrameType = "Frame"
AHealFrame.Configuration.Width = 100
AHealFrame.Configuration.Height = 40
AHealFrame.Configuration.Resizable = { 55, 40, 500, 70 }
AHealFrame.Configuration.SupportsHoTPanel = true

function AHealFrame:Construct(options)

	local template =
	{
		elements =
		{
			{
				id="frameBackdrop", type="Frame", parent="frame", layer=0, alpha=1,
				attach =
				{
					{ point="BOTTOMLEFT", element="frame", targetPoint="BOTTOMLEFT",offsetX=4, offsetY=-1},
					{ point="TOPRIGHT", element="frame", targetPoint="TOPRIGHT", offsetX=-4, offsetY=1},
				},
				visibilityBinding="id",
				color={r=0,g=0,b=0,a=0},
				backgroundColor={r=0, g=0, b=0, a=0},
			},
			{
				id="barHealth", type="Bar", parent="frameBackdrop", layer=1,
				attach = {
					{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=1.25, offsetY=-1.25 },
					{ point="BOTTOMRIGHT", element="frame", targetPoint="BOTTOMRIGHT", offsetX=-1.25, offsetY=1.25 },
				},
				growthDirection="right",
				binding="healthPercent",
				color = {r=0, g=0.4, b=0, a=1},
				BarAlphaBinding="UnitBarAlpha",
				backgroundColorBinding="raidHealthColorFrame",
			},
			{
				id="unitBorder", type="Image", parent="frameBackdrop", layer=65, alpha=1,
				attach =
				{
					{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=-10.50, offsetY=-5.25 },
					{ point="BOTTOMRIGHT", element="frame", targetPoint="BOTTOMRIGHT", offsetX=10.50, offsetY=5.25 },
				},
				texAddon="Rift", texFile="raid_frame_click.png.dds",
				visibilityBinding="id",
				color={r=0,g=0,b=0,a=0},backgroundColor={r=0, g=0, b=0, a=0},
				alpha=1,ImageTextureBinding="AggrobarTexture"
			},
			{
				id="healthCap", type="HealthCap", parent="frameBackdrop", layer=15,
				attach = {
					{ point="TOPLEFT", element="barHealth", targetPoint="TOPLEFT" },
					{ point="BOTTOMRIGHT", element="barHealth", targetPoint="BOTTOMRIGHT" },
				},
				growthDirection="left",
				visibilityBinding="healthCap",
				binding="healthCapPercent",
				texAddon="Rift", texFile="raid_healthbar_red.png.dds",
				color={r=1, g=0, b=0, a=0.4},
			},
			{
				id="barAbsorb", type="Bar", parent="frameBackdrop", layer=19,
				attach = {
					{ point="TOPLEFT", element="barHealth", targetPoint="TOPLEFT", offsetX=1, offsetY=-1 },
					{ point="BOTTOMRIGHT", element="barHealth", targetPoint="BOTTOMRIGHT", offsetX=-1, offsetY=1 },
				},
				growthDirection="right",
				binding="absorbPercent", color={r=0,g=1,b=1,a=0.35},
				media="wtAbsorb",
				backgroundColor={r=0, g=0, b=0, a=0},
			},
			{
				id="imgRole", type="MediaSet", parent="frameBackdrop", layer=20,
				width = 14, height = 14,
				attach = {{ point="CENTER", element="barHealth", targetPoint="TOPLEFT", offsetX=12, offsetY=8 }},
				visibilityBinding="role",
				nameBinding="role",
				names = { ["tank"] = "octanusTank", ["heal"] = "octanusHeal", ["dps"] = "octanusDPS", ["support"] = "octanusSupport" },
			},
			{
				id="labelName", type="Label", parent="frameBackdrop", layer=20,alpha=1,
				attach = {{ point="TOPLEFT", element="barHealth", targetPoint="TOPLEFT", offsetX=4, offsetY=12 }},
				visibilityBinding="name",
				text="{nameShort}", maxLength=16, default="", fontSize=11, outline2=true,font="Montserrat-Bold",
				colorBinding="CallingFrameColor",
			},
			{
				id="labelStatus", type="Label", parent="frameBackdrop", layer=20,
				attach = {{ point="TOPCENTER", element="barHealth", targetPoint="TOPCENTER", offsetX=0,offsetY=0}},
				visibilityBinding="detailedStatus",outline2=true,
				text="{detailedStatus}", default="", fontSize=9,font="Montserrat-Bold",
			},
			{
			    id="imgMark", type="MediaSet", parent="frameBackdrop", layer=30,
			    attach = {{ point="TOPRIGHT", element="barHealth", targetPoint="TOPRIGHT", offsetX=-8, offsetY=1 }},
			    width = 12, height = 12,
			    nameBinding="mark",
			    names =
			    {
			        ["1"] = "riftMark01_mini",
			        ["2"] = "riftMark02_mini",
			        ["3"] = "riftMark03_mini",
			        ["4"] = "riftMark04_mini",
			        ["5"] = "riftMark05_mini",
			        ["6"] = "riftMark06_mini",
			        ["7"] = "riftMark07_mini",
			        ["8"] = "riftMark08_mini",
			        ["9"] = "riftMark09_mini",
			        ["10"] = "riftMark10_mini",
			        ["11"] = "riftMark11_mini",
			        ["12"] = "riftMark12_mini",
			        ["13"] = "riftMark13_mini",
			        ["14"] = "riftMark14_mini",
			        ["15"] = "riftMark15_mini",
			        ["16"] = "riftMark16_mini",
			        ["17"] = "riftMark17_mini",
			        ["18"] = "riftMark18_mini",
			        ["19"] = "riftMark10_mini",
			        ["20"] = "riftMark10_mini",
			        ["21"] = "riftMark10_mini",
			        ["22"] = "riftMark22_mini",
			        ["23"] = "riftMark23_mini",
			        ["24"] = "riftMark24_mini",
			        ["25"] = "riftMark25_mini",
			        ["26"] = "riftMark26_mini",
			        ["27"] = "riftMark09_mini",
					["28"] = "riftMark09_mini",
			        ["29"] = "riftMark09_mini",
			        ["30"] = "riftMark30_mini",
			    },
			    visibilityBinding="mark",alpha=1.0,
			},
			{
			    id="imgMark2", type="MediaSet", parent="frameBackdrop", layer=31,
			     attach = {{ point="TOPRIGHT", element="barHealth", targetPoint="TOPRIGHT", offsetX=-8, offsetY=1 }},
			    width = 12, height = 12,
			    nameBinding="mark",
			    names =
			    {
			        ["19"] = "riftMark02_mini",
			        ["20"] = "riftMark03_mini",
			        ["21"] = "riftMark04_mini",
			        ["27"] = "riftMark02_mini",
					["28"] = "riftMark03_mini",
			        ["29"] = "riftMark04_mini",
			    },
			    visibilityBinding="mark",alpha=1.0,
			},
			{
				id="imgReady", type="ImageSet", parent="frameBackdrop", layer=60,
				attach = {{ point="BOTTOMCENTER", element="barHealth", targetPoint="BOTTOMCENTER", offsetX=0,offsetY=0}}, -- visibilityBinding="id",
				texAddon=AddonId, texFile="img/wtReady.png", nameBinding="readyStatus", cols=1, rows=2,
				names = { ["ready"] = 0, ["notready"] = 1 }, defaultIndex = "hide",width = 16, height = 16,
			},
			{
				id="buffPanelDebuffs", type="BuffPanel", parent="frameBackdrop", layer=30,
				attach = {{ point="BOTTOMRIGHT", element="barHealth", targetPoint="BOTTOMRIGHT",offsetX=-8	, offsetY=-2.25}},
				visibilityBinding="IsPlayerOnline",
				rows=1, cols=5, iconSize=11, iconSpacing=1, borderThickness=0,
				auraType="debuff", showtooltips="disabled",
				rejectBuffs = options.BlackListDebuff,
				acceptBuffs = options.WhiteListDebuff,
				growthDirection = "left_up"
			},

			{
				id="buffPanelHoTs", type="BuffPanel", semantic="HoTPanel", parent="frameBackdrop", layer=30,
				attach = {{ point="TOPRIGHT", element="barHealth", targetPoint="TOPRIGHT", offsetX=-1, offsetY=35 }},
				rows=1, cols=5, iconSize=11, iconSpacing=0, borderThickness=1,
				visibilityBinding="IsPlayerOnline",
				auraType="hot",selfCast=true,
				growthDirection = "left_up",
				rejectBuffs = options.BlackListHots,
				acceptBuffs = options.WhiteListHots,
				showtooltips="disabled",
			},
		}
	}
	for idx,element in ipairs(template.elements) do
		local showElement = true
		if not options.showAbsorb and element.id == "barAbsorb" then showElement = false end
		if element.semantic == "HoTTracker" and not options.showHoTTracker then showElement = false	end
		if element.semantic == "HoTPanel" and not options.showHoTPanel then showElement = false	end
		if element.semantic == "DebuffPanel" and not options.showDebuffPanel then showElement = false	end
		if options.growthDirection and element.id == "barHealth" then element.growthDirection = options.growthDirection	end
		if showElement then
			self:CreateElement(element)
		end
	end

	self:EventAttach(
		Event.UI.Layout.Size,
		function(el)
			local newWidth = self:GetWidth()
			local newHeight = self:GetHeight()
			local fracWidth = newWidth / AHealFrame.Configuration.Width
			local fracHeight = newHeight / AHealFrame.Configuration.Height
			local fracMin = math.min(fracWidth, fracHeight)
			local fracMax = math.max(fracWidth, fracHeight)
			local labName = self.Elements.labelName
			local origFontSize = el.fontSize or 11
			local newFontSize = math.floor(origFontSize * fracMin)
		end,
		"LayoutSize")

	self:SetSecureMode("restricted")
	self:SetMouseoverUnit(self.UnitSpec)
	self:SetMouseMasking("limited")
	if options.clickToTarget then
		self:EventMacroSet(Event.UI.Input.Mouse.Left.Click, "target @" .. self.UnitSpec)
	end
	if options.contextMenu then
		self:EventAttach(Event.UI.Input.Mouse.Right.Click, function(self, h)
			if self.UnitId then Command.Unit.Menu(self.UnitId) end
		end, "Event.UI.Input.Mouse.Right.Click")
	end

end