CameraHandler      = require(_G.Everest.Handlers.CameraHandler)
EntityDepthHandler = require(_G.Everest.Handlers.EntityDepthHandler)
LightingHandler    = require(_G.Everest.Handlers.LightingHandler)
ProfilerHandler    = require(_G.Everest.Handlers.ProfilerHandler)
ReplicationHandler = require(_G.Everest.Handlers.ReplicationHandler)
BaseObject         = require(_G.Everest.Objects.BaseObject)
Inventory          = require(_G.Everest.Objects.Inventory)

Entity = {}
Entity.__index = Entity
setmetatable(Entity, BaseObject)

Entity.EntityList = {}

local min, floor = math.min, math.floor

function Entity.new(position, size, inventory, map)
	local new = BaseObject.new()
	setmetatable(new, Entity)
	new.Size      = size
	new.Map = map or _G.Map	
	--new:CreateInstance()
	--new:SetSize(size)
	new:SetPosition(position)
	--new:SetInventory(inventory)
	
	new.Inventory = inventory
	
	Entity.EntityList[#Entity.EntityList + 1] = new
	
	ReplicationHandler.ReferencePush(new)
	
	return new
end

function Entity.Serialize(self, dataTable)
	if not dataTable then
		dataTable = {}
		dataTable.Type = self.Type and self.Type or "Entity"
	end	
	
	dataTable.SizeX    = self:GetSize().x
	dataTable.SizeY    = self:GetSize().y
	dataTable.PosX     = self:GetPosition().x
	dataTable.PosY     = self:GetPosition().Y
	dataTable.Health   = self:GetHealth()
	
	if self.ImpulseDir then
		dataTable.ImpulseDir = self.ImpulseDir
	end
	
	if self.ImpulsePower then
		dataTable.ImpulsePower = self.ImpulsePower
	end
	
	return BaseObject.Serialize(self, dataTable)
end

function Entity.DeSerialize(self, dataTable)
	self:SetSize(Vector2.new(dataTable.SizeX, dataTable.SizeY))
	if not self.Moving then
		self:SetPosition(Vector2.new(dataTable.PosX, dataTable.PosY))
	end
	self:SetHealth(dataTable.Health)
end

function Entity.SetPosition(self, position, renderOffset, shouldTween)
	shouldTween = shouldTween or false	
	
	if position ~= self.Position then
		_G.EntityMoved = true
	end
	
	self.Position = position
	self.Posx = position.x
	self.Posy = position.y
	self.CurrentTile = self.Map.Tiles[floor(self.Posx)] and self.Map.Tiles[floor(self.Posx)][floor(self.Posy)]
	
	local entTab = _G.Map.EntitiesByPosition
	local curSectPosx, curSectPosy = math.floor(position.X/10), math.floor(position.Y/10)
	
	if curSectPosx ~= self.oldSectPosx or curSectPosy ~= self.oldSectPosy then
		
		if entTab[self.oldSectPosx] and entTab[self.oldSectPosx][self.oldSectPosy] and entTab[self.oldSectPosx][self.oldSectPosy][self] then
			entTab[self.oldSectPosx][self.oldSectPosy][self] = nil
		end
		
		entTab[curSectPosx] = entTab[curSectPosx] or {}
		entTab[curSectPosx][curSectPosy] = entTab[curSectPosx][curSectPosy] or {}
		entTab[curSectPosx][curSectPosy][self] = true
		
		self.oldSectPosx = curSectPosx
		self.oldSectPosy = curSectPosy
	end
	
	if renderOffset then
		position = position + renderOffset
	end	
	
	local newpos = UDim2.new(0, (position.X - (self.Size.X / 2) + 0.5) * _G.TileSize, 0,  ((-position.Y - self.Size.Y + 1)* _G.TileSize))
	
	if self.Instance then
		if shouldTween then	
			self.ClippingInstance:TweenPosition(newpos, "Out", "Quad", 0.1, true)
			self.Instance:TweenPosition(newpos, "Out", "Quad", 0.1, true)
		else
			self.ClippingInstance.Position = newpos
			self.Instance.Position = newpos
		end
	end
end

function Entity:SetHealth(health)
	self.Health = health
end

function Entity:SetSize(size)
	self.Size = size or Vector2.new()
	if self.ClippingInstance then
		self.ClippingInstance.Size = UDim2.new(0, _G.TileSize * size.X, 0, _G.TileSize * size.Y)
		self.Instance.Size = UDim2.new(0, _G.TileSize * size.X, 0, _G.TileSize * size.Y)
	end
end

function Entity:SetLightLevel(brightness, delta)
	local lightLevel = self.LightLevel + min(1, delta * 4) * (brightness - self.LightLevel)
	if self.LightLevel ~= lightLevel then
		self.LightLevel = lightLevel
		self.Instance.ImageTransparency = 1 - lightLevel
	end
end

function Entity:RawSetLightLevel(brightness)
	self.LightLevel = brightness
	self.Instance.ImageTransparency = 1 - brightness
end

function Entity:CreateInstance()
	local a, b = EntityDepthHandler:RequestInstance(self), EntityDepthHandler:RequestInstance(self)
	self:UseInstance(b, a)
end

function Entity:UseInstance(clippingInstance, instance)
	
	for _, v in pairs(clippingInstance:getChildren()) do
		v.Parent = nil
	end	
	
	for _, v in pairs(instance:getChildren()) do
		v.Parent = nil
	end	
	
	self.ClippingInstance = clippingInstance
	self.ClippingInstance.ZIndex = 4
	self.ClippingInstance.BackgroundTransparency = 1
	self.ClippingInstance.ImageTransparency = 0
	
	self.Instance = instance
	self.Instance.ZIndex = 4
	self.Instance.BackgroundTransparency = 1
	
	--self.ClippingInstance.Parent = CameraHandler.Container
	--self.Instance.Parent = CameraHandler.Container
	
	self:SetSize(self.Size or Vector2.new())
	self:SetPosition(self.Position or Vector2.new())
	self:SetImage(self:GetAllImageData())
	self:RawSetLightLevel(self.LightLevel or _G.DayLight)
	self:ConnectClick()
end

function Entity:SetImage(imageId, clippingId, position, size)
	if self.Instance then	
		self.Instance.Image = "rbxassetid://"..imageId
		self.Instance.ImageRectOffset = position
		self.Instance.ImageRectSize = size
		
		self.ClippingInstance.Image = "rbxassetid://"..clippingId
		self.ClippingInstance.ImageRectOffset = position
		self.ClippingInstance.ImageRectSize = size
	end
	
	self.ImageId = imageId
	self.ClippingId = clippingId
	self.ImagePosition = position
	self.ImageSize = size
end

function Entity:SetType(type)
	self.Type = type
end

function Entity:SetInventory(inventory)
	self.Inventory = inventory or Inventory.new()
end
--when overriding :Step call :BaseStep to persist all base entity step functions
function Entity:Step(delta)
	self:BaseStep(delta)
end

function Entity:BaseStep(delta)
	if self.LabelInstance then
		self.LabelInstance.Parent = self.Instance
	end	
	
	local brightness = self.CurrentTile.LightLevel
	if self.LightLevel ~= brightness then
		--local lightLevel = self.LightLevel + min(1, delta * 4) * (brightness - self.LightLevel)
		self.LightLevel = brightness
		if self.Instance then
			self.Instance.ImageTransparency = 1 - brightness
		end
	end	
	
	
	--self:SetLightLevel(_G.Map.Tiles[floor(self.Posx)][floor(self.Posy)].LightLevel, delta)
	
	local power = self.ImpulsePower or 0
	if power > 0 then
		self:CalculateImpulse(delta)
	end
end

function Entity:Destroy()
	ReplicationHandler.DeleteEntity(self.Guid)
	self:DisconnectClick()
	_G.Objects[self.Guid] = nil
	_G.Map.EntitiesByPosition[self.oldSectPosx][self.oldSectPosy][self] = nil
	table.remove(Entity.EntityList, self:GetEntityListId())
	table.remove(_G.Objects, self.GuidTableId)
	_G.Map:RemoveEntity(self)
	EntityDepthHandler:RecycleInstance(self:GetInstance())
	EntityDepthHandler:RecycleInstance(self:GetClippingInstance())
	setmetatable(self, {})
end

function Entity:Damage(amount)
	Entity:SetHealth(Entity:GetHealth() - amount)
end

function Entity:CalculateLighting(delta)
	self:SetLightLevel(_G.Map.Tiles[math.floor(self.Posx)][math.floor(self.Posy)].LightLevel, delta)
end

function Entity:CalculateImpulse(delta)
	local power = self.ImpulsePower or 0
	local pos   = self.Position
	local dir = self.ImpulseDir or Vector2.new()
	local newpos = pos + (dir * power * delta)		
	
	if _G.Map.Tiles[math.floor(newpos.X)][math.floor(newpos.Y)].Walkable then
		pos = newpos
		self.ImpulsePower = math.max(0, power - (delta)*power^2)
	else	
		self.ImpulsePower = 0
	end

	self:SetPosition(pos)
end

function Entity:ConnectClick()
	if self.LeftClickConnect then self.LeftClickConnect:disconnect() end
	if self.RightClickConnect then self.RightClickConnect:disconnect() end
	self.LeftClickConnect = self.Instance.MouseButton1Click:connect(function()
		self:LeftClicked()
	end)
	self.RightClickConnect = self.Instance.MouseButton2Click:connect(function()
		self:RightClicked()
	end)
end

function Entity:DisconnectClick()
	if self.LeftClickConnect then self.LeftClickConnect:disconnect() end
	if self.RightClickConnect then self.RightClickConnect:disconnect() end
end

function Entity:LeftClicked()

end

function Entity:RightClicked()
	
end

function Entity:OptionChosen(option)
	
end

--Will override previous impulse
function Entity:Impulse(dir, power)
	self.ImpulseDir = dir.unit
	self.ImpulsePower = power
	
	ReplicationHandler.ReferencePush(self)
end

--Combines current impulse with new impulse
function Entity:AdditiveImpulse(dir, power)
	local newDir = (dir*power + self.ImpulseDir*self.ImpulsePower)
	
	self:Impulse(newDir.unit, newDir.magnitude)
end

function Entity:GetEntityListId()
	local id
	for i, v in pairs(Entity.EntityList) do
		if v == self then return i end
	end
	return id
end

function Entity:GetPosition()
	return self.Position or Vector2.new()
end

function Entity:GetSize()
	return self.Size or Vector2.new()
end

function Entity:GetHealth()
	return self.Health or 100
end

function Entity:GetInstance()
	return self.Instance
end

function Entity:GetClippingInstance()
	return self.ClippingInstance
end

function Entity:GetImage()
	return self.ImageId or 0
end

function Entity:GetClippingId()
	return self.ClippingId or 0
end

function Entity:GetImagePosition()
	return self.ImagePosition or Vector2.new()
end

function Entity:GetImageSize()
	return self.ImageSize or Vector2.new()
end

function Entity:GetAllImageData()
	return self.ImageId or 0, self.ClippingId or 0, self.ImagePosition or Vector2.new(),self.ImageSize or Vector2.new()
end

function Entity:GetLightLevel()
	return self.LightLevel or _G.DayLight
end

function Entity:GetType()
	return self.Type or "BaseEntity"
end

function Entity:GetInventory()
	return self.Inventory
end

return Entity