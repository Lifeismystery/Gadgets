--[[ 
	This file is part of Wildtide's WT Addon Framework 
	Wildtide @ Blightweald (EU) / DoomSprout @ forums.riftgame.com

	WT.Element.ImageSet
	
		Provides a ImageSet element, which is used to store a set of identically shaped images (tiles), and
		select an image by specifying an index or a name (names can be used for bindings)	
--]]

-- Create the class.
local wtImageSet = WT.Element:Subclass("ImageSet", "Mask")

-- The Construct method builds the element up. The element (self) is an instance of the relevant
-- UI.Frame as specified in the Subclass() call above
function wtImageSet:Construct()

	-- self is a Mask

	local config = self.Configuration
	local unitFrame = self.UnitFrame

	-- Validate the configuration
	if not config.texAddon then error("ImageSet missing required configuration item: texAddon") end
	if not config.texFile then error("ImageSet missing required configuration item: texFile") end
	if not config.rows then error("ImageSet missing required configuration item: rows") end
	if not config.cols then error("ImageSet missing required configuration item: cols") end
	
	-- Create a copy of any names provided in the config
	self.names = {}
	if config.names then
		for k,v in pairs(config.names) do self.names[k] = v end
	end
	
	self.rows = config.rows
	self.cols = config.cols
	
	self.image = UI.CreateFrame("Texture", WT.UnitFrame.UniqueName(), self)
	self.image:SetTexture(config.texAddon, config.texFile)
	
	self.totalWidth = self.image:GetWidth()
	self.totalHeight = self.image:GetHeight()
	self.tileWidth = self.totalWidth / config.cols
	self.tileHeight = self.totalHeight / config.rows
	
	-- do we have an override to set the width/height of the image
	if config.width then
		self.totalWidth = config.width * self.cols
		self.image:SetWidth(self.totalWidth)
		self.tileWidth = config.width
	end
	if config.height then
		self.totalHeight = config.height * self.rows
		self.image:SetHeight(self.totalHeight)
		self.tileHeight = config.height
	end
	
	-- wrapIndex can be a number which forces the index to be between 0 and (wrapIndex - 1), otherwise the index
	-- wraps around the max number of tiles the source image can hold
	self.wrapIndex = config.wrapIndex or (self.rows * self.cols) 
	
	-- Set the mask to the size of an individual tile
	self:SetWidth(self.tileWidth)
	self:SetHeight(self.tileHeight)
	
	self.defaultIndex = config.defaultIndex or 0
	self:SetIndex(self.defaultIndex)
	
	if config.indexBinding then
		unitFrame:CreateBinding(config.indexBinding, self, self.SetIndex, config.defaultIndex or 0)
	end

	if config.nameBinding then
		unitFrame:CreateBinding(config.nameBinding, self, self.SetName, config.defaultName or "")
	end

end

function wtImageSet:SetIndex(index)
	if index == "hide" then
		self:SetWidth(0)
	else
		self:SetWidth(self.tileWidth)
		local idx = index % self.wrapIndex 
		local col = (idx % self.cols)
		local row = math.floor(idx / self.cols)
		self.image:SetPoint("TOPLEFT", self, "TOPLEFT", -col * self.tileWidth, -row * self.tileHeight)
	end
end

function wtImageSet:SetName(name)
	if (not name) or (name == "") or (not self.names[name]) then 
		self:SetIndex(self.defaultIndex) 
		return
	end	
	self:SetIndex(self.names[name])
end
