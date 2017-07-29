ProfilerHandler    = require(_G.Everest.Handlers.ProfilerHandler)
CameraHandler      = require(_G.Everest.Handlers.CameraHandler)
Tile               = require(_G.Everest.Objects.Tile)
BaseObject = require(_G.Everest.Objects.BaseObject)

Map = {}
Map.__index = Map
setmetatable(Map, BaseObject)

local insert, remove = table.insert, table.remove

function Map.new()
	local new = BaseObject.new()
	setmetatable(new, Map)
	
	new.Tiles = {}
	new.Entities = {}
	new.EntitiesByPosition = {}
	new.RenderedTiles = {}	
	new.CurrentEntities = {}
	new.CurrentRenderPosition = Vector2.new(0,0)
	new.LightSources = {}	
	
	return new
end

function Map.Serialize(self, dataTable)
	if not dataTable then
		dataTable = {}
		dataTable.Type = "Map"
	end	
	
	local tileTab = {}
	
	for _, v in pairs(self.Tiles) do
		for _, tile in pairs(v) do
			table.insert(tileTab, tile:Serialize())
		end
	end
	
	dataTable.Tiles = tileTab		
	
	local entTab = {}	
	
	for _, v in pairs(self.Entities) do
		table.insert(entTab, v:Serialize())
	end	
	
	dataTable.Entities = entTab
	
	return BaseObject.Serialize(self, dataTable)
end

function Map.newReplication(data)
	local newMap = Map.new()
	_G.Map = newMap
	
	for _, tile in pairs(data.Tiles) do
		local pos = Vector2.new(tile.PosX, tile.PosY)
		newMap:SetTile(pos, Tile.Tiles[tile.Type].new(pos))
	end
	
	for _, entity in pairs(data.Entities) do
		local newEntity = require(_G.Everest.Objects.Entities[entity.Type]).newReplication(entity)
		newEntity:EnforceGuid(entity.Guid)
		newMap:AddEntity(newEntity)
	end
	
	return newMap
end

function Map:SetTile(position, tile)
	self.Tiles[position.x] = self.Tiles[position.x] or {}
	self.Tiles[position.x][position.y] = tile
end

function Map:SetRenderedTiles(tiles)
	self.RenderedTiles = tiles
end

function Map:Step(delta)	
	local timer = tick()
	
	for tile,_ in pairs(self.RenderedTiles) do
		if tile.Step then
			tile:Step(delta)
		end
	end
	
	local posx = math.floor(self.CurrentRenderPosition.x / 10)
	local posy = math.floor(self.CurrentRenderPosition.y / 10)
	local difx = math.ceil((CameraHandler.Screen.AbsoluteSize.x / _G.TileSize)*0.05)
	local dify = math.ceil((CameraHandler.Screen.AbsoluteSize.y / _G.TileSize)*0.05)
	local entityList, entitiesByPosition, currentEntities = {}, self.EntitiesByPosition, self.CurrentEntities

	--Entities are clumped into 10x10 "chunks"
	--Attmpts to load entities in a rectangle closest to (screenSize / tileSize) * 1.5
	--Since the for loops are -size to +size 1.5 needs to be halfed. 1.5/2 = 0.75
	--Since entities are in 10x10 "chunks" 0.75 needs to be divided by 10 0.75/10 = 0.075
	for deltax = -difx, difx do
		for deltay = -dify, dify do
			if entitiesByPosition[posx+deltax] and entitiesByPosition[posx+deltax][posy+deltay] then
				for entity,_  in pairs(entitiesByPosition[posx+deltax][posy+deltay]) do
					entity:Step(delta)
					entityList[entity] = false
				end
			end
		end
	end
	
	--Remove unused entities
	local i = 0
	while true do
		i = i + 1
		local entity = currentEntities[i]
		if entity then
			if entityList[entity] == false then
				entityList[entity] = true
			elseif entityList[entity] == nil then
				if entity.DisconnectClick then
					entity:DisconnectClick()
				end
				remove(currentEntities, i)
				i = i - 1
			end
		else
			break
		end
	end
	
	local newEntities = {}	
	local numberLoaded = 0	
	
	--Insert new entities
	for entity, stat in pairs(entityList) do
		if stat == false then
			numberLoaded = numberLoaded + 1
			insert(currentEntities, entity)
			newEntities[entity] = true
			if numberLoaded > 500 then
				break
			end
		end
	end
	
	self.NewEntities = newEntities
	
	ProfilerHandler.AddProcessTime("Map", "Step", tick() - timer)
end

function Map:Render(delta, position, size)
	local timer = tick()
	
	self.CurrentRenderPosition = position	
	
	size = size * 0.5
	local xpos = math.ceil(position.X)
	local ypos = math.ceil(position.y)
	local xSize = math.ceil(size.X)
	local ySize = math.ceil(size.Y)	
	local renderedTiles = {}
	
	for x = -xSize, xSize do
		for y = -ySize, ySize do
			local tile = self.Tiles[xpos + x] and self.Tiles[xpos + x][ypos + y]
			if tile then
				renderedTiles[tile] = true
				if tile.Instance then
					if not _G.DisableTileLighting then
						tile:UpdateLightLevel(delta)
					end
				else
					if not _G.DisableTileRendering then
						tile:Render(delta)
					end
				end
			end
		end
	end	
		
	for tile, _ in pairs(self.RenderedTiles) do
		if not renderedTiles[tile] then
			tile:Cull()
		end
	end	
	
	self.RenderedTiles = renderedTiles
	
	ProfilerHandler.AddProcessTime("Map", "Render", tick() - timer)
end

function Map:Derender()
	print("Culling!")
	for tile, _ in pairs(self.RenderedTiles) do
		tile:Cull()
	end
end

function Map:AddEntity(entity)
	self.Entities[entity:GetGuid()] = entity
end

function Map:RemoveEntity(entity)
	self.Entities[entity:GetGuid()] = nil
end

function Map:GetTile(position)
	return self.Tiles[position.x] and self.Tiles[position.x][position.y]
end

function Map:GetRenderedTiles()
	return self.RenderedTiles
end

function Map:GetEntities()
	return self.Entities
end


return Map