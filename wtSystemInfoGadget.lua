local toc, data = ...
local AddonId = toc.identifier
local TXT = Library.Translate



local gadgetIndex = 0
local SysGadgets = {}

local function Create(configuration)

	local wrapper = UI.CreateFrame("Frame", WT.UniqueName("wtSys"), WT.Context)
	wrapper:SetWidth(200)
	wrapper:SetHeight(40)	
	wrapper:SetSecureMode("restricted")
	local SysFrame = UI.CreateFrame("Text", WT.UniqueName("wtSys"), wrapper)
	SysFrame:SetText("")
	SysFrame:SetFontSize(14)
	SysFrame:SetFont(AddonId,"font\\Montserrat-Bold.otf")
	SysFrame:SetEffectGlow({ 		blurX = 4,			--Controls how much blurring exists along the X axis. Defaults to 2.
		blurY = 4,			--Controls how much blurring exists along the Y axis. Defaults to 2.
		colorR = 0,		--Controls the red channel of the glow effect. Defaults to 0.
		colorG = 0,		--Controls the green channel of the glow effect. Defaults to 0.
		colorB = 0,		--Controls the blue channel of the glow effect. Defaults to 0.
		colorA = 1,			--Controls the alpha channel of the glow effect. Defaults to 1.
		offsetX = 0,		--Controls the glow offset along the X axis. Defaults to 0.
		offsetY = 0,		--Controls the glow offset along the Y axis. Defaults to 0.
		strength = 3,		--Controls the strength of the glow. Defaults to 1.  
		})
	SysFrame:SetFontColor(1.0, 1.0, 1.0, 1.0)
	SysFrame:SetPoint("TOPLEFT", wrapper, "TOPLEFT", 0, -3)
	local txtDetail = UI.CreateFrame("Text", WT.UniqueName("wtSys"), wrapper)
	txtDetail:SetText("")
	txtDetail:SetFontSize(14)
	txtDetail:SetFont(AddonId,"font\\Montserrat-Bold.otf")
	txtDetail:SetFontColor(1.0, 1.0, 1.0, 1.0)
	txtDetail:SetEffectGlow({ 		blurX = 4,			--Controls how much blurring exists along the X axis. Defaults to 2.
		blurY = 4,			--Controls how much blurring exists along the Y axis. Defaults to 2.
		colorR = 0,		--Controls the red channel of the glow effect. Defaults to 0.
		colorG = 0,		--Controls the green channel of the glow effect. Defaults to 0.
		colorB = 0,		--Controls the blue channel of the glow effect. Defaults to 0.
		colorA = 1,			--Controls the alpha channel of the glow effect. Defaults to 1.
		offsetX = 0,		--Controls the glow offset along the X axis. Defaults to 0.
		offsetY = 0,		--Controls the glow offset along the Y axis. Defaults to 0.
		strength = 3,		--Controls the strength of the glow. Defaults to 1.  
		})
	txtDetail:SetPoint("TOPLEFT", SysFrame, "BOTTOMLEFT", 0, -8)
	SysFrame.detail = txtDetail
	local txtDetail2 = UI.CreateFrame("Text", WT.UniqueName("wtSys"), wrapper)
	txtDetail2:SetText("")
	txtDetail2:SetFontSize(14)
	txtDetail2:SetFont(AddonId,"font\\Montserrat-Bold.otf")
	txtDetail2:SetFontColor(1.0, 1.0, 1.0, 1.0)
	txtDetail2:SetEffectGlow({ 		blurX = 4,			--Controls how much blurring exists along the X axis. Defaults to 2.
		blurY = 4,			--Controls how much blurring exists along the Y axis. Defaults to 2.
		colorR = 0,		--Controls the red channel of the glow effect. Defaults to 0.
		colorG = 0,		--Controls the green channel of the glow effect. Defaults to 0.
		colorB = 0,		--Controls the blue channel of the glow effect. Defaults to 0.
		colorA = 1,			--Controls the alpha channel of the glow effect. Defaults to 1.
		offsetX = 0,		--Controls the glow offset along the X axis. Defaults to 0.
		offsetY = 0,		--Controls the glow offset along the Y axis. Defaults to 0.
		strength = 3,		--Controls the strength of the glow. Defaults to 1.  
		})
	txtDetail2:SetPoint("TOPLEFT", SysFrame, "BOTTOMLEFT", 0, 5)
	SysFrame.detail2 = txtDetail2
	table.insert(SysGadgets, SysFrame)
	return wrapper, { resizable={200, 40, 240, 40} }
	
end


local dialog = false

local function ConfigDialog(container)	
	dialog = WT.Dialog(container)
		:Label("This gadget displays the System Usage for the Rift client, updated once per second.")
end

local function GetConfiguration()
	return dialog:GetValues()
end

local function SetConfiguration(config)
	dialog:SetValues(config)
end


WT.Gadget.RegisterFactory("System Usage",
	{
		name="System Usage",
		description="System Usage Information",
		author="Aileen",
		version="1.0.0",
		iconTexAddon=AddonId,
		iconTexFile="img/menuIcons/wtCPU.png",
		["Create"] = Create,
		["ConfigDialog"] = ConfigDialog,
		["GetConfiguration"] = GetConfiguration, 
		["SetConfiguration"] = SetConfiguration, 
	})
local delta = 0
local lasttimereal = Inspect.Time.Real()
local lasttimeframe = Inspect.Time.Frame()
local lastgarbageclear = Inspect.Time.Real()
local function OnTick(hEvent, frameDeltaTime, frameIndex)
	delta = delta + frameDeltaTime
	local cpuInfo = nil
	local latInfo = nil
	local cpuState = "#00FF00"
	local processState = "#00FF00"
	local renderState = "#00FF00"
	local fpsState = "#00FF00"
	local wdState = "#00FF00"
	local delayState = "#00FF00"
	local deltaState = "#00FF00"
	local wd = Inspect.System.Watchdog()
	if (delta >= 1) then
		delta = 0
		local addons = {}
		local grandTotal = 0
		local renderTotal = 0
		for addonId, cpuData in pairs(Inspect.Addon.Cpu()) do
			if cpuData then
				local total = 0
				for k,v in pairs(cpuData) do
					total = total + v
					if string.find(k, "render time") then renderTotal = renderTotal + v end
					if string.find(k, "update time") then renderTotal = renderTotal + v end
				end
				grandTotal = grandTotal + total
				addons[addonId] = total
			end
		end
		if grandTotal > 0.2 then
			cpuState = "#FF0000"
		end
		if (grandTotal-renderTotal) > 0.1 then
			processState = "#FF0000"
		end
		if renderTotal > 0.1 then
			renderState = "#FF0000"
		end
		cpuInfo = string.format("CPU: <font color='%s'>%.01f%%</font> (P: <font color='%s'>%.01f%%</font> / R: <font color='%s'>%.01f%%</font>)", cpuState,grandTotal * 100,processState,(grandTotal-renderTotal)*100, renderState,renderTotal*100)
		local realdiff =  math.abs((Inspect.Time.Real() - lasttimereal))
		local framediff =  math.abs((Inspect.Time.Frame() - lasttimeframe))
		local garbagecleardiff = math.abs((Inspect.Time.Real() - lastgarbageclear))
		lasttimereal = Inspect.Time.Real()
		lasttimeframe = Inspect.Time.Frame()
		if realdiff > 1.05 then
			delayState = "#FF0000"
		end
		if framediff > 1.05 then
			deltaState = "#FF0000"
		end
		if (garbagecleardiff > 30000) then
			collectgarbage()
			lastgarbageclear = Inspect.Time.Real()
		end
		latInfo = string.format("Delay: <font color='%s'>%.2f ms</font> Delta: <font color='%s'>%.2f ms</font>", delayState,tostring(realdiff),deltaState,tostring(framediff))
	end
	local FPS = math.ceil(WT.FPS)
	if FPS < 25 then
		fpsState = "#FF0000"
	end
	if wd < 0.1 then
		wdState = "#FF0000"
	end
	local SysText = string.format("FPS: <font color='%s'>%s</font> WatchDog: <font color='%s'>%.03f ms</font>",fpsState,FPS,wdState,wd)
	for idx, gadget in ipairs(SysGadgets) do
		gadget:SetText(SysText,true)
		if cpuInfo then
			gadget.detail:SetText(cpuInfo,true)
		end
		if latInfo then
			gadget.detail2:SetText(latInfo,true)
		end
	end
end

Command.Event.Attach(WT.Event.Tick, OnTick, AddonId .. "_OnTick" )