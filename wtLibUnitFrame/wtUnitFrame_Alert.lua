-- Adelea (Thank you for this)
local addon, shared = ...
local id = addon.identifier

local GJK = {buffID={}}

GJK.AbilityNames = {
	["Unholy Dominion"] = true,
	["Mindsear"] = true,
    ["Infernal Radiance"] = true,
	["Spirit Shackle"] = true,
    ["Ensnaring Creepers"] = true,
    ["Aggressive Infection"] = true,
}

local buffID = ""
local buffUnit = ""
function GJK.Event_Buff_Add_Worker(u,t)
	for k,v in pairs(Inspect.Buff.Detail(u,t)) do
		if GJK.AbilityNames[v.name] and WT.Units[u] then
			GJK.buffID[u] = k
			WT.Units[u]["buffAlert"] = true
		end
	end
end

function GJK.Event_Buff_Add(u,t)
	local job = coroutine.create(GJK.Event_Buff_Add_Worker)
	coroutine.resume(job, u,t)
end
function GJK.Event_Buff_Remove_Worker(u,t)
	for k,v in pairs(t) do
		if GJK.buffID[u] == k then
			WT.Units[u]["buffAlert"] = false
			GJK.buffID[u] = nil
		end
	end
end
function GJK.Event_Buff_Remove(u,t)
	local job = coroutine.create(GJK.Event_Buff_Remove)
	coroutine.resume(job, u,t)
end

table.insert(Event.Buff.Add, { GJK.Event_Buff_Add, addon.identifier, "Event.Buff.Add" })
table.insert(Event.Buff.Remove, { GJK.Event_Buff_Remove, addon.identifier, "Event.Buff.Remove" })