Tile = require(_G.Everest.Objects.Tile)

Grass_Water_BottomRight = {}
Grass_Water_BottomRight.__index = Grass_Water_BottomRight
setmetatable(Grass_Water_BottomRight, Tile)

Tile.Tiles[8] = Grass_Water_BottomRight

function Grass_Water_BottomRight.new(position)
	local new = Tile.new(position, false)
	setmetatable(new, Grass_Water_BottomRight)
	
	new:SetImage(165446984)	
	
	return new
end

return Grass_Water_BottomRight