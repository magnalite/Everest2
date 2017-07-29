Entity              = require(_G.Everest.Objects.Entity)

WoodenWall = {}
WoodenWall.__index = WoodenWall
setmetatable(WoodenWall, Entity)

function WoodenWall.new(position)
	local new = Entity.new(position, Vector2.new(1, 2))
	setmetatable(new, WoodenWall)
	
	new:SetImage(170291652, 170291658, Vector2.new(), Vector2.new())
	new:SetType("WoodenWall")
	
	local tile = _G.Map:GetTile(Vector2.new(math.floor(position.x), math.floor(position.y)))
	if tile then
		tile:SetWalkable(false)
		tile:SetSolid(true)
	end
	
	return new
end

return WoodenWall