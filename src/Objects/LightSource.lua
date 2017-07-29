LightingHandler     = require(_G.Everest.Handlers.LightingHandler)
BaseObject          = require(_G.Everest.Objects.BaseObject)


LightSource = {}
LightSource.__index = LightSource
setmetatable(LightSource, BaseObject)

local floor = math.floor

function LightSource.new(map, position, brightness)
	local new = BaseObject.new()
	setmetatable(new, LightSource)
	
	new.Map        = map
	new.Brightness = brightness
	new:SetPosition(position)	
	
	return new
end

function LightSource:SetPosition(position)
	if position ~= self.Position then	
		self.Position = position
		LightingHandler.RequiresUpdate = true
		local sectPosX, sectPosY = floor(position.x/25), floor(position.y/25)
		if sectPosX ~= self.sectPosX or sectPosY ~= self.sectPosY then
			if self.Map.LightSources[self.sectPosX] 
				and self.Map.LightSources[self.sectPosX][self.sectPosY] 
				and self.Map.LightSources[self.sectPosX][self.sectPosY][self] then
				self.Map.LightSources[self.sectPosX][self.sectPosY][self] = nil
			end
			self.Map.LightSources[sectPosX]                 = self.Map.LightSources[sectPosX] or {}
			self.Map.LightSources[sectPosX][sectPosY]       = self.Map.LightSources[sectPosX][sectPosY] or {}
			self.Map.LightSources[sectPosX][sectPosY][self] = true
			self.sectPosX = sectPosX
			self.sectPosY = sectPosY
		end
	end
end

return LightSource