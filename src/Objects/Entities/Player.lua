ReplicationHandler  = require(_G.Everest.Handlers.ReplicationHandler)
Inventory           = require(_G.Everest.Objects.Inventory)
Mob                 = require(_G.Everest.Objects.Entities.Mob)

Player = {}
Player.__index = Player
setmetatable(Player, Mob)

function Player.new(position, name)
	local new = Mob.new(position, Vector2.new(1.7,1.7), Inventory.new(100000), name)
	setmetatable(new, Player)
	
	new:SetHealth(100)
	new:SetWalkSpeed(5)
	new:SetImage(165812855, 166310217, Vector2.new(0,0), Vector2.new(260,256))	
	new:SetType("Player")
	
	return new	
end

function Player.newReplication(dataTable)
	return Player.new(Vector2.new(dataTable.PosX, dataTable.PosY), dataTable.NameLabel)
end

function Player.Serialize(self, dataTable)
	if not dataTable then
		dataTable = {}
		dataTable.Type = "Player"
	end	
	
	return Mob.Serialize(self, dataTable)
end

function Player.DeSerialize(self, dataTable)
	Mob.DeSerialize(self, dataTable)
end

function Player:Step(delta)
	if self:IsMoving() then
		self:MoveStep(delta)
	end
	self:BaseStep(delta)
	
	if self == _G.localPlayer then
		ReplicationHandler.Push(self:Serialize())
	end
end

function Player:AnimStep(delta)
	self.AnimLength = self.AnimLength + delta
	local length = math.floor((self.AnimLength * self.WalkSpeed)%4)
	local dir = self.MovementDirection
	
	if     dir == 0 then dir = 3
	elseif dir == 1 then dir = 2
	elseif dir == 2 then dir = 0
	elseif dir == 3 then dir = 1
	end
	
	if length == 0 then
		self:SetImage(165812855, 166310217, Vector2.new(0  ,dir*256), Vector2.new(260,256))
	elseif length == 1 or length == 3 then
		self:SetImage(165812855, 166310217, Vector2.new(260,dir*256), Vector2.new(260,256))
	elseif length == 2 then
		self:SetImage(165812855, 166310217, Vector2.new(520,dir*256), Vector2.new(260,256))
	end
end

function Player:StopAnim()

end

return Player