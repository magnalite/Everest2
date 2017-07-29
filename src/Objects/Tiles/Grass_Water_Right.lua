Tile = require(_G.Everest.Objects.Tile)

Grass_Water_Right = {}
Grass_Water_Right.__index = Grass_Water_Right
setmetatable(Grass_Water_Right, Tile)

Tile.Tiles[7] = Grass_Water_Right

function Grass_Water_Right.new(position)
	local new = Tile.new(position, false)
	setmetatable(new, Grass_Water_Right)
	
	new:SetImage(165446400)	
	
	return new
end

return Grass_Water_Right