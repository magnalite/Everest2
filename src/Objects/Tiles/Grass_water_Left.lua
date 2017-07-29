Tile = require(_G.Everest.Objects.Tile)

Grass_Water_Left = {}
Grass_Water_Left.__index = Grass_Water_Left
setmetatable(Grass_Water_Left, Tile)

Tile.Tiles[1] = Grass_Water_Left

function Grass_Water_Left.new(position)
	local new = Tile.new(position, false)
	setmetatable(new, Grass_Water_Left)
	
	new:SetImage(165444715)	
	
	return new
end

return Grass_Water_Left