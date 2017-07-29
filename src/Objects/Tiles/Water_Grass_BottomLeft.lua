Tile = require(_G.Everest.Objects.Tile)

Water_Grass_BottomLeft = {}
Water_Grass_BottomLeft.__index = Water_Grass_BottomLeft
setmetatable(Water_Grass_BottomLeft, Tile)

Tile.Tiles[12] = Water_Grass_BottomLeft

function Water_Grass_BottomLeft.new(position)
	local new = Tile.new(position, false)
	setmetatable(new, Water_Grass_BottomLeft)
	
	new:SetImage(165480420)	
	
	return new
end

return Water_Grass_BottomLeft