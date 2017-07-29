Tile = require(_G.Everest.Objects.Tile)

Water_Grass_TopRight = {}
Water_Grass_TopRight.__index = Water_Grass_TopRight
setmetatable(Water_Grass_TopRight, Tile)

Tile.Tiles[10] = Water_Grass_TopRight

function Water_Grass_TopRight.new(position)
	local new = Tile.new(position, false)
	setmetatable(new, Water_Grass_TopRight)
	
	new:SetImage(165479454)	
	
	return new
end

return Water_Grass_TopRight