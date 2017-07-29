Entity = require(_G.Everest.Objects.Entity)

Mob = {}
Mob.__index = Mob
setmetatable(Mob, Entity)

function Mob.new(position, size, inventory, nameLabel)
	local new = Entity.new(position, size, inventory)
	setmetatable(new, Mob)

	new.AnimLength = 0
	new.NameLabel = nameLabel	
	
	if nameLabel then
		print("Adding name", nameLabel)
		new.LabelInstance = Instance.new("TextLabel")
		new.LabelInstance.Text = nameLabel
		new.LabelInstance.Size = UDim2.new(1,0,0,50)
		new.LabelInstance.Position = UDim2.new(0,0,0,-50)
		new.LabelInstance.ZIndex = 9
		new.LabelInstance.BackgroundTransparency = 1
	end
	
	return new	
end

function Mob.Serialize(self, dataTable)
	if not dataTable then
		dataTable = {}
		dataTable.Type = "Mob"
	end	
	
	dataTable.NameLabel = self.NameLabel
	dataTable.WalkSpeed = self:GetWalkSpeed()
	
	return Entity.Serialize(self, dataTable)
end

function Mob.DeSerialize(self, dataTable)
	self.NameLabel = dataTable.NameLabel
	self:SetWalkSpeed(dataTable.WalkSpeed)
	self:MoveTo(Vector2.new(dataTable.PosX, dataTable.PosY))	
	
	Entity.DeSerialize(self, dataTable)
end

function Mob:SetWalkSpeed(speed)
	self.WalkSpeed = speed
end
--0 = north  1 = east 2 = south 3 = west
function Mob:SetMovementDirection(dir)
	self.MovementDirection = dir
end
--Should be overrided if mob is to be animated
--MoveStep will need to be called in overrided :Step() function
function Mob:Step(delta)
	if self:IsMoving() then
		self:MoveStep(delta)
	end
	
	self:BaseStep(delta)
end

function Mob:MoveStep(delta)
	local currentPos = self:GetPosition()
	local directionVec = self.PositionMoveTo - currentPos
	local vecMove = directionVec.unit * delta * self:GetWalkSpeed()
	if vecMove.magnitude < directionVec.magnitude then
		self:SetPosition(currentPos + vecMove)
		self:AnimStep(delta)
	else
		self:SetPosition(self.PositionMoveTo)
		self:StopAnim()
		self.Moving = false
	end
end
--Should be overrided if mob is to be animated
function Mob:AnimStep(delta)
	
end
--Should be overrided if mob is to be animated
function Mob:StopAnim()
	
end

function Mob:MoveTo(position)
	self.Moving = true
	self.PositionMoveTo = position
	local dir = position - self:GetPosition()
	if dir.Y > 0 then
		self:SetMovementDirection(0)
	elseif dir.Y < 0 then
		self:SetMovementDirection(2)
	elseif dir.X > 0 then
		self:SetMovementDirection(1)
	elseif dir.X < 0 then 
		self:SetMovementDirection(3)
	end
end

function Mob:IsMoving()
	return self.Moving
end

function Mob:GetWalkSpeed()
	return self.WalkSpeed
end
--0 = north  1 = east 2 = south 3 = west
function Mob:GetMovementDirection()
	return self.MovementDirection
end

return Mob