ProfilerHandler    = require(_G.Everest.Handlers.ProfilerHandler)

LightingHandler = {}
LightingHandler.__index = LightingHandler

LightingHandler.MAX_RANGE = 12

LightingHandler.LightObjects = {
	--{Position = Vector2.new(5.5,-5.5), Brightness = LightingHandler.MAX_RANGE},
	--{Position = Vector2.new(6,-5), Brightness = 10},
	--{Position = Vector2.new(9,-5), Brightness = 10},
	}

local frames_since_update = 0

function LightingHandler.CalculateTileLighting(delta)
	frames_since_update = frames_since_update +1  
	if LightingHandler.RequiresUpdate  or frames_since_update > 10 then	
		frames_since_update = 0
		LightingHandler.RequiresUpdate = nil
		local tiles = _G.Map.Tiles
		local tilesToUpdate = {}
		local tilesDone = {}
		local tilesCanUpdate =	_G.Map.RenderedTiles	
		
		for tile, _ in pairs(tilesCanUpdate) do
			tile.LightLevel = _G.DayLight
		end
		
		local sectPos = Vector2.new(math.floor(_G.Map.CurrentRenderPosition.x / 25), math.floor(_G.Map.CurrentRenderPosition.y / 25))		
		local lights = 0		
		
		for sectx = -1, 1 do
			if _G.Map.LightSources[sectPos.x + sectx] then
				for secty = -1, 1 do
					if _G.Map.LightSources[sectPos.x + sectx][sectPos.y + secty] then
						for light, _ in pairs(_G.Map.LightSources[sectPos.x + sectx][sectPos.y + secty]) do
							lights = lights + 1
							local pos = light.Position
							local posx, posy = pos.x, pos.y
							local posx_int, posy_int = posx + 0.5, posy + 0.5
							posx_int, posy_int = posx_int - posx_int % 1, posy_int - posy_int % 1
							local offsetx, offsety = posx - posx_int, posy - posy_int
							local nextIntensity = light.Brightness
							local prevIntensity = tilesDone[tile]
							if offsetx < 0 then
								local nbTile = tiles[posx_int - 1][posy_int]
								if nbTile then
									local nbNextIntensity = nextIntensity - 1 - offsetx
									local nbPrevIntensity = tilesDone[nbTile]
									tilesToUpdate[#tilesToUpdate + 1] = nbTile
									tilesDone[nbTile] = (nbPrevIntensity and nbNextIntensity < nbPrevIntensity) and nbPrevIntensity or nbNextIntensity
								end
								nextIntensity = nextIntensity + offsetx
							elseif offsetx > 0 then
								local nbTile = tiles[posx_int + 1][posy_int]
								if nbTile then
									local nbNextIntensity = nextIntensity - 1 + offsetx
									local nbPrevIntensity = tilesDone[nbTile]
									tilesToUpdate[#tilesToUpdate + 1] = nbTile
									tilesDone[nbTile] = (nbPrevIntensity and nbNextIntensity < nbPrevIntensity) and nbPrevIntensity or nbNextIntensity
								end
								nextIntensity = nextIntensity - offsetx
							end
							if offsety < 0 then
								local nbTile = tiles[posx_int][posy_int - 1]
								if nbTile then
									local nbNextIntensity = nextIntensity - 1 - offsety
									local nbPrevIntensity = tilesDone[nbTile]
									tilesToUpdate[#tilesToUpdate + 1] = nbTile
									tilesDone[nbTile] = (nbPrevIntensity and nbNextIntensity < nbPrevIntensity) and nbPrevIntensity or nbNextIntensity
								end
								nextIntensity = nextIntensity + offsety
							elseif offsety > 0 then
								local nbTile = tiles[posx_int][posy_int + 1]
								if nbTile then
									local nbNextIntensity = nextIntensity - 1 + offsety
									local nbPrevIntensity = tilesDone[nbTile]
									tilesToUpdate[#tilesToUpdate + 1] = nbTile
									tilesDone[nbTile] = (nbPrevIntensity and nbNextIntensity < nbPrevIntensity) and nbPrevIntensity or nbNextIntensity
								end
								nextIntensity = nextIntensity - offsety
							end
							local tile = tiles[posx_int][posy_int]
							tilesToUpdate[#tilesToUpdate + 1] = tile
							tilesDone[tile] = (prevIntensity and nextIntensity < prevIntensity) and prevIntensity or nextIntensity
						end
					end
				end
			end
		end
		
		_G.LightCount = lights		
		
		for index, tile in ipairs(tilesToUpdate) do
			local currentPosition = tile.Position
			local posx, posy = currentPosition.x, currentPosition.y
			local intensity = tilesDone[tile]
			if intensity > tile.LightLevel and intensity > _G.DayLight * LightingHandler.MAX_RANGE then
				tile:SetLightLevel(intensity, delta)
				if not tile.Solid then
					for deltax = -1, 1, 2 do
						local nextTile = tiles[posx + deltax] and tiles[posx + deltax][posy]
						if nextTile and intensity - 1 > (tilesDone[nextTile] or 0) then
							tilesDone[nextTile] = intensity - 1
							tilesToUpdate[#tilesToUpdate + 1] = nextTile
						end
					end
					for deltay = -1, 1, 2 do
						local nextTile = tiles[posx][posy + deltay]
						if nextTile and intensity - 1 > (tilesDone[nextTile] or 0) then
							tilesDone[nextTile] = intensity - 1
							tilesToUpdate[#tilesToUpdate + 1] = nextTile
						end
					end
					for deltax = -1, 1, 2 do
						for deltay = -1, 1, 2 do
							local nextTile = tiles[posx + deltax] and tiles[posx + deltax][posy + deltay]
							if nextTile and intensity - 1.41421 > (tilesDone[nextTile] or 0) then
								tilesDone[nextTile] = intensity - 1.41421 -- 2^.5 - 1 (Distance of diagonal, to form circle of light)
								tilesToUpdate[#tilesToUpdate + 1] = nextTile
							end
						end
					end
				end
			end
		end
	end
end



function LightingHandler.Step(delta)
	local timer = tick()
	--LightingHandler.LightObjects[1].Position = Vector2.new(math.sin(tick())*5, math.cos(tick())*5)
	--LightingHandler.LightObjects[2].Position =	_G.localPlayer.Position + Vector2.new(math.sin(tick())*5, math.cos(tick())*5)
	--LightingHandler.LightObjects[3].Position = _G.localPlayer.Position - Vector2.new(math.sin(tick()*2)*5, math.cos(tick()*2)*5)
	--LightingHandler.LightObjects[1].Position = _G.localPlayer.Position
	LightingHandler.CalculateTileLighting(delta)
	
	ProfilerHandler.AddProcessTime("Handler", "Lighting", tick()-timer)
end

return LightingHandler