--[[
	This file is part of Wildtide's WT Addon Framework
	Wildtide @ Blightweald (EU) / DoomSprout @ forums.riftgame.com
--]]

local toc, data = ...
local AddonId = toc.identifier

-- Load all of the built in media -----------------------------------------------------------------
Library.Media.AddTexture("wtBantoBar", AddonId, "img/BantoBar.png", {"bar", "colorize"})
Library.Media.AddTexture("wtDiagonal", AddonId, "img/Diagonal.png", {"bar", "colorize"})
Library.Media.AddTexture("wtGlaze2", AddonId, "img/Glaze2.png", {"bar", "colorize"})
Library.Media.AddTexture("wtHealbot", AddonId, "img/Healbot.png", {"bar", "colorize"})
Library.Media.AddTexture("wtOrbGreen", AddonId, "img/orb_green.tga", {"orb"})
Library.Media.AddTexture("wtOrbBlue", AddonId, "img/orb_blue.tga", {"orb"})
Library.Media.AddTexture("wtReadyCheck", AddonId, "img/wtReady.png", {"imgset", "readycheck"})
Library.Media.AddTexture("wtRankPips", AddonId, "img/wtRankPips.png", {"imgset", "elitestatus"})
Library.Media.AddTexture("wtRanks24", AddonId, "img/wtRanks24.png", {"imgset", "elitestatus"})
Library.Media.AddTexture("wtRanks38", AddonId, "img/wtRanks38.png", {"imgset", "elitestatus"})
Library.Media.AddTexture("wtSweep", AddonId, "img/Sweep.png", {"imgset", "sweep"})
---------------------------------------------------------------------------------------------------