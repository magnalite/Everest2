LightingHandler     = require(_G.Everest.Handlers.LightingHandler)
Entity              = require(_G.Everest.Objects.Entity)
LightSource         = require(_G.Everest.Objects.LightSource)


Torch = {}
Torch.__index = Torch
setmetatable(Torch, Entity)

function Torch.new(position)
	local new = Entity.new(position, Vector2.new(1, 1))
	setmetatable(new, Torch)
	
	new:SetImage(171307649, 171307631, Vector2.new(), Vector2.new())
	new:SetType("Torch")
	
	local tile = _G.Map:GetTile(Vector2.new(math.floor(position.x), math.floor(position.y)))
	tile:SetWalkable(true)
	tile:SetSolid(false)
	tile.HasEntity = true
	
	new.LightSource = LightSource.new(_G.Map, position, 8)
	
	return new
end

function Torch.newReplication(data)
	return Torch.new(Vector2.new(data.PosX, data.PosY))
end

function Torch:SetPosition(position)
	Entity.SetPosition(self, position, Vector2.new(0,0.5))
	self.LightSource:SetPosition(position)
	LightingHandler.RequiresUpdate = true
end

return Torch