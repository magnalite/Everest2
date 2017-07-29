CameraHandler      = require(_G.Everest.Handlers.CameraHandler)
ProfilerHandler    = require(_G.Everest.Handlers.ProfilerHandler)
Entity             = nil

EntityDepthHandler = {}

local sort = table.sort
local insert = table.insert

function depthSort(a, b)
	return a.Posy > b.Posy or (a.Posy == b.Posy and a.Posx > b.Posx)
end

function EntityDepthHandler:Init()
	Entity = require(_G.Everest.Objects.Entity)
end

local oldEntityUse = {}
local framesSinceSort = 0
local oldMap = _G.Map

function EntityDepthHandler:Step(delta)
	local timer       = tick()
	local entityList  = _G.Map.CurrentEntities
	local newEntities = _G.Map.NewEntities
	local entityUse   = {}
	
	if _G.Map ~= oldMap then
		oldMap = _G.Map
		oldEntityUse = {}
		sort(entityList, depthSort)
		print("Map change!!!")
	end
	
	framesSinceSort = framesSinceSort + 1
	
	--Sort entities by depth
	if _G.EntityMoved and framesSinceSort > 0 then
		sort(entityList, depthSort)
		_G.EntityMoved = false
		framesSinceSort = 0
	end
	
	local guiInstances = CameraHandler.EntityContainer:GetChildren()
	
	--Assign their gui
	for i,entity in ipairs(entityList) do
		if (entity.Instance ~= guiInstances[i*2] or newEntities[entity]) and entity.UseInstance then
			if not guiInstances[i*2] then
				entity:UseInstance(
					Instance.new("ImageButton", CameraHandler.EntityContainer),
					Instance.new("ImageButton", CameraHandler.EntityContainer))
			else
				entity:UseInstance(guiInstances[i*2-1], guiInstances[i*2])
			end
		end
	end

	--Cull all unused guis
	for i = #entityList*2 + 1, #guiInstances do
		for _, v in pairs(guiInstances[i]:GetChildren()) do
			v.Parent = nil
		end
		guiInstances[i]:Destroy()
	end
	
	_G.CurrentEntityNumber = #entityList
	oldEntityUse = entityUse --To refresh entities which have been freshly loaded this frame
	ProfilerHandler.AddProcessTime("Handler", "EntityDepth", tick()-timer)
end

function EntityDepthHandler:RequestInstance(objectRequesting)
	local instance = Instance.new("ImageButton", CameraHandler.EntityContainer)
	return instance
end

function EntityDepthHandler:RecycleInstance(instance)
	--instance.Parent = nil
	--instance.Size = UDim2.new(0,0,0,0)
end

return EntityDepthHandler

