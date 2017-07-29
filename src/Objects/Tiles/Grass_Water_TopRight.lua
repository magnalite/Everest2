Tile = require(_G.Everest.Objects.Tile)

Grass_Water_TopRight = {}
Grass_Water_TopRight.__index = Grass_Water_TopRight
setmetatable(Grass_Water_TopRight, Tile)

Tile.Tiles[6] = Grass_Water_TopRight

function Grass_Water_TopRight.new(position)
	local new = Tile.new(position, false)
	setmetatable(new, Grass_Water_TopRight)
	
	new:SetImage(165446232)	
	
	return new
end

return Grass_Water_TopRight