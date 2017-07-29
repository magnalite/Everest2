CameraHandler   = require(_G.Everest.Handlers.CameraHandler)
LightingHandler = require(_G.Everest.Handlers.LightingHandler)
ProfilerHandler = require(_G.Everest.Handlers.ProfilerHandler)
BaseObject      = require(_G.Everest.Objects.BaseObject)

Tile = {}
Tile.__index = Tile
setmetatable(Tile, BaseObject)

Tile.Tiles = {}

local min = math.min

function Tile.new(position, walkable, solid)
	local new = BaseObject.new()
	setmetatable(new, Tile)
	
	new.Position = position	
	new.Walkable = walkable
	new.Solid    = solid
	new.posx     = position.x
	new.posy     = position.y	
	new.LightLevel = 0
	
	return new
end

function Tile.Serialize(self, dataTable)
	if not dataTable then
		dataTable = {}
		dataTable.Type = self.TileID
	end	
	
	dataTable.PosX  = self.posx
	dataTable.PosY  = self.posy
	dataTable.Solid = self.Solid
	
	return BaseObject.Serialize(self, dataTable)
end

function Tile:SetImage(id)
	self.ImageId = id
	local inst = self:GetInstance()
	if inst then
		inst.Image = "rbxassetid://"..id
	end
end

function Tile:SetWalkable(walkable)
	self.Walkable = walkable
end

function Tile:SetSolid(solid)
	self.Solid = solid
end

function Tile:SetLightLevel(brightness, delta)
	self.LightLevel = brightness / LightingHandler.MAX_RANGE
end

function Tile:RawSetLightLevel(brightness)
	self.LightLevel = brightness
	self.Instance.ImageTransparency = 1 - brightness
end

function Tile:UpdateLightLevel(delta)
	if self.Instance and math.abs(self.Instance.ImageTransparency - (1 - self.LightLevel)) > 0.05 then
		print("Updating!" , tick(), " --- ", math.abs(self.Instance.ImageTransparency - (1 - self.LightLevel)))
		self.Instance.ImageTransparency = self.Instance.ImageTransparency + min(1, delta * 10) * ((1 - self.LightLevel) - self.Instance.ImageTransparency)
	end
	--self.LightLevel = _G.DayLight
end

function Tile:PlayerStepped()

end

function Tile:Render(delta)	
	if not self.Instance then
		local position         = self.Position
		self.Instance          = Instance.new("ImageLabel", CameraHandler:GetContainer())	
		self.Instance.Size     = UDim2.new(0, _G.TileSize, 0, _G.TileSize)
		self.Instance.Position = UDim2.new(0, position.X * _G.TileSize, 0,  -position.Y * _G.TileSize)
		self.Instance.Image    = "rbxassetid://"..self:GetImage()
		self.Instance.BackgroundColor3 = Color3.new(0,0,0)
		self.Instance.ZIndex   = 2
		self.Instance.BorderSizePixel = 0
		self:RawSetLightLevel(_G.DayLight)
	else
		self:UpdateLightLevel(delta)
	end
end

function Tile:Cull()
	if self.Instance then
		self.Instance:Destroy()
		self.Instance = nil
	end
end

function Tile:ApplyMetaData(MetaData)
	error("Attempt to apply metadata to base tile")
end

function Tile:IsWalkable()
	return self.Walkable
end

function Tile:IsSolid()
	return self.Solid
end

function Tile:GetImage()
	return self.ImageId or 0
end

function Tile:GetInstance()
	return self.Instance
end

function Tile:GetPosition()
	return self.Position
end

function Tile:GetLightLevel()
	return self.LightLevel or _G.DayLight
end

return Tile