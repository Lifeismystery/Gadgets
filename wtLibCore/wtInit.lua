--[[
                                G A D G E T S
      -----------------------------------------------------------------
                            wildtide@wildtide.net
                           DoomSprout: Rift Forums
      -----------------------------------------------------------------
      Gadgets Framework   : v0.9.4-beta
      Project Date (UTC)  : 2015-07-13T16:47:34Z
      File Modified (UTC) : 2013-01-04T22:17:01Z (Wildtide)
      -----------------------------------------------------------------
--]]

local toc, data = ...
local AddonId = toc.identifier

WT = {}
WT.Event = {}
WT.Event.Trigger = {}
WT.Command = {}
WT.NameCounters = {}
WT.Initializers = {}
WT.Faders = {}
wtxOptions = {} -- general purpose saved variables table (account wide)
-- This file implements waitSeconds, waitSignal, signal, and their supporting stuff.
-- This table is indexed by coroutine and simply contains the time at which the coroutine
-- should be woken up.
WT.WAITING_ON_TIME = {}
-- This table is indexed by signal and contains list of coroutines that are waiting
-- on a given signal
WT.WAITING_ON_SIGNAL = {}
-- Keep track of how long the game has been running.
WT.CURRENT_TIME = 0
function WT.waitSeconds(seconds)
    -- Grab a reference to the current running coroutine.
    local co = coroutine.running()
    -- If co is nil, that means we're on the main process, which isn't a coroutine and can't yield
    assert(co ~= nil, "The main thread cannot wait!")
    -- Store the coroutine and its wakeup time in the WAITING_ON_TIME table
    local wakeupTime = Inspect.Time.Real() + seconds
    WT.WAITING_ON_TIME[co] = wakeupTime
    -- And suspend the process
    return coroutine.yield(co)
end

function WT.wakeUpWaitingThreads()
    -- This function should be called once per game logic update with the amount of time
    -- that has passed since it was last called
    WT.CURRENT_TIME = Inspect.Time.Real()
	if next(WT.WAITING_ON_TIME) ~= nil then
		-- First, grab a list of the threads that need to be woken up. They'll need to be removed
		-- from the WAITING_ON_TIME table which we don't want to try and do while we're iterating
		-- through that table, hence the list.
		local threadsToWake = {}
		for co, wakeupTime in pairs(WT.WAITING_ON_TIME) do
			if wakeupTime < WT.CURRENT_TIME then
				table.insert(threadsToWake, co)
			end
		end
		if next(threadsToWake) ~= nil then
			-- Now wake them all up.
			for _, co in ipairs(threadsToWake) do
				WT.WAITING_ON_TIME[co] = nil -- Setting a field to nil removes it from the table
				coroutine.resume(co)
			end
			threadsToWake = {}
		end
	end
end

function WT.waitSignal(signalName)
    -- Same check as in waitSeconds; the main thread cannot wait
    local co = coroutine.running()
    assert(co ~= nil, "The main thread cannot wait!")

    if WT.WAITING_ON_SIGNAL[signalStr] == nil then
        -- If there wasn't already a list for this signal, start a new one.
        WT.WAITING_ON_SIGNAL[signalName] = { co }
    else
        table.insert(WAITING_ON_SIGNAL[signalName], co)
    end

    return WT.waitSeconds(0.1)
end

function WT.signal(signalName)
    local threads = WT.WAITING_ON_SIGNAL[signalName]
    if threads == nil then return end

    WT.WAITING_ON_SIGNAL[signalName] = nil
    for _, co in ipairs(threads) do
        coroutine.resume(co)
    end
end

function WT.runProcess(func)
    -- This function is just a quick wrapper to start a coroutine.
    local co = coroutine.create(func)
    return coroutine.resume(co)
end