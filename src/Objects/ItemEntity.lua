ReplicationHandler = require(_G.Everest.Handlers.ReplicationHandler)
Entity  = require(_G.Everest.Objects.Entity)

ItemEntity = {}
ItemEntity.__index = ItemEntity
setmetatable(ItemEntity, Entity)

function ItemEntity.new(position)
	local new = Entity.new(position, Vector2.new(0.5, 0.5))
	setmetatable(new, ItemEntity)	
	
	new:SetType("ItemEntity")	
	
	return new
end

function ItemEntity.Serialize(self, dataTable)
	if not dataTable then
		dataTable = {}
		dataTable.Type = self.Type
	end	

	dataTable.Ownership = self.Ownership	
	
	return Entity.Serialize(self, dataTable)
end

function ItemEntity.DeSerialize(self, dataTable)
	self.Ownership = dataTable.Ownership
	Entity.DeSerialize(self, dataTable)
end

function ItemEntity:Step(delta)
	self:BaseStep(delta)
	if _G.localPlayer then
		local dir = _G.localPlayer.Position - self.Position
		local dist = dir.magnitude
		if dist > 2 and self.Ownership == _G.localPlayer.Guid then
			self.Ownership = nil
			ReplicationHandler.Push(self:Serialize())
		elseif dist < 2 and dist > 0.5 and (self.Ownership == nil or self.Ownership == _G.localPlayer.Guid) then
			self.Ownership = _G.localPlayer.Guid
			--self:SetPosition(self.Position + (dir.unit * (1/dist) * delta))
			self:AdditiveImpulse(dir, (1/dist) * 0.3)
		elseif dist < 0.5 and (self.Ownership == nil or self.Ownership == _G.localPlayer.Guid) then
			if _G.localPlayer.Inventory:AttemptAdd(self:CreateItem(_G.localPlayer.Inventory)) then
				self:Destroy()
			end
		end
	end
end

return ItemEntity