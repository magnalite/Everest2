NotificationHandler = require(_G.Everest.Handlers.NotificationHandler)
ToolTipHandler      = require(_G.Everest.Handlers.ToolTipHandler)
Entity              = require(_G.Everest.Objects.Entity)
Map                 = require(_G.Everest.Objects.Map)
Tile                = require(_G.Everest.Objects.Tile)

MineHole = {}
MineHole.__index = MineHole
setmetatable(MineHole, Entity)

function MineHole.new(position)
	local new = Entity.new(position, Vector2.new(1, 1))
	setmetatable(new, MineHole)
	
	new:SetImage(171828568, 171828574, Vector2.new(), Vector2.new())
	new:SetType("MineHole")
	
	local tile = _G.Map:GetTile(Vector2.new(math.floor(position.x), math.floor(position.y)))
	tile:SetWalkable(false)
	tile:SetSolid(false)
	tile.HasEntity = true
	
	return new
end

function MineHole:LeftClicked()
	ToolTipHandler:ProvideOptions({"Climb Down"}, self:GetPosition(), self)
end

function MineHole:OptionChosen(option)
	if option == "Climb Down" then
		local dist = (_G.localPlayer:GetPosition() - self:GetPosition()).magnitude
		if dist > 1.5 then
			NotificationHandler.NewNotification("You must be closer to climb down")
		else
			self:Climbed()
		end
	end
end

function MineHole:Climbed()
	_G.Map:RemoveEntity(_G.localPlayer)
	_G.Map:Derender()
	local newMap = Map.new()
	for x = -100, 100 do
		for y = -100, 100 do
			newMap:SetTile(Vector2.new(x,y), Tile.Tiles[14].new(Vector2.new(x,y)))
		end
	end
	_G.Map = newMap
	newMap:AddEntity(_G.localPlayer)
	_G.localPlayer.Map = newMap
	_G.localPlayer:SetPosition(Vector2.new(0,0))
end

return MineHole