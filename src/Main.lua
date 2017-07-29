wait(0.5)
local startupTime, lastReplication = tick(), tick()
_G.Everest = script.Parent
_G.Objects = {}
_G.TileSize = 32
_G.DayLight = 1

CameraHandler       = require(_G.Everest.Handlers.CameraHandler)
EntityDepthHandler  = require(_G.Everest.Handlers.EntityDepthHandler)
InputHandler        = require(_G.Everest.Handlers.InputHandler)
LightingHandler     = require(_G.Everest.Handlers.LightingHandler)
ProfilerHandler     = require(_G.Everest.Handlers.ProfilerHandler)
CraftingHandler     = require(_G.Everest.Handlers.CraftingHandler)
ReplicationHandler  = require(_G.Everest.Handlers.ReplicationHandler)
NotificationHandler = require(_G.Everest.Handlers.NotificationHandler)
SoundHandler        = require(_G.Everest.Handlers.SoundHandler)
Entity              = require(_G.Everest.Objects.Entity)
Map                 = require(_G.Everest.Objects.Map)
TestMap             = require(_G.Everest.Objects.Maps.TestMap)
Torch               = require(_G.Everest.Objects.Entities.Torch)
Tree                = require(_G.Everest.Objects.Entities.Tree)
WoodenWall          = require(_G.Everest.Objects.Entities.WoodenWall)
MineHole            = require(_G.Everest.Objects.Entities.MineHole)
Player              = require(_G.Everest.Objects.Entities.Player)
Grass_Center        = require(_G.Everest.Objects.Tiles.Grass_Center)

CameraHandler:Init()
EntityDepthHandler:Init()

repeat wait() until game.Players.LocalPlayer.Character
game.Players.LocalPlayer.Character:Destroy()
game.StarterGui:SetCoreGuiEnabled(1, false)
game.StarterGui:SetCoreGuiEnabled(2, false)

local testMap = TestMap
_G.Map = TestMap

--local player = Player.new(Vector2.new(3,-6))


print("Loading map state")
mapData = workspace.RequestMapState:InvokeServer()
print("Received")

print("Instancing map")
_G.Map = Map.newReplication(mapData)
_G.Map:EnforceGuid(mapData.Guid)
testMap = _G.Map


local player = Player.new(Vector2.new(0,0), game.Players.LocalPlayer.Name)
testMap:AddEntity(player)
--testMap:AddEntity(Tree.new(Vector2.new(6, -4)))
--testMap:AddEntity(Tree.new(Vector2.new(4, -4)))
--testMap:AddEntity(Tree.new(Vector2.new(5, -4)))
--testMap:AddEntity(Tree.new(Vector2.new(7, -4)))
--testMap:AddEntity(Tree.new(Vector2.new(8, -4)))
--testMap:AddEntity(Tree.new(Vector2.new(4, -5)))
--testMap:AddEntity(Tree.new(Vector2.new(4, -6)))
--testMap:AddEntity(Tree.new(Vector2.new(4, -7)))
--testMap:AddEntity(Tree.new(Vector2.new(8, -5)))
--testMap:AddEntity(Tree.new(Vector2.new(8, -6)))
--testMap:AddEntity(Tree.new(Vector2.new(8, -7)))
--testMap:AddEntity(Tree.new(Vector2.new(7, -7)))
--testMap:AddEntity(Tree.new(Vector2.new(5, -7)))

--for i = 1, 10000 do
--	if i%1000 == 0 then
--		print(i)
--		wait()
--	end
--	local x,y = math.random(-100,100), math.random(-100, 100)
--	if testMap.Tiles[x][y].Walkable then
--		testMap:AddEntity(Tree.new(Vector2.new(x, y)))
--	end
--end

--for i = 1, 1000 do
--	local x,y = math.random(-100,100), math.random(-100, 100)
--	if testMap.Tiles[x][y].Walkable then
--		print(x,y)
--		testMap:AddEntity(MineHole.new(Vector2.new(x, y)))
--	end
--end

--testMap:AddEntity(Torch.new(Vector2.new(0, 0)))

--for x = -100, 100 do
--	for y = -100, 100 do
--		if x~=0 and y~= 0 then
--			testMap:AddEntity(Tree.new(Vector2.new(x, y)))
--		end
--	end
--end


--[[testMap:AddEntity(WoodenWall.new(Vector2.new(4, -1)))
testMap:AddEntity(WoodenWall.new(Vector2.new(5, -1)))
testMap:AddEntity(WoodenWall.new(Vector2.new(6, -1)))
testMap:AddEntity(WoodenWall.new(Vector2.new(7, -1)))
testMap:AddEntity(WoodenWall.new(Vector2.new(8, -1)))
testMap:AddEntity(WoodenWall.new(Vector2.new(9, -1)))
testMap:AddEntity(WoodenWall.new(Vector2.new(9, -2)))
testMap:AddEntity(WoodenWall.new(Vector2.new(9, -3)))
testMap:AddEntity(WoodenWall.new(Vector2.new(10, -3)))
testMap:AddEntity(WoodenWall.new(Vector2.new(10, -5)))
testMap:AddEntity(WoodenWall.new(Vector2.new(10, -6)))
testMap:AddEntity(WoodenWall.new(Vector2.new(10, -7)))
testMap:AddEntity(WoodenWall.new(Vector2.new(9, -7)))
testMap:AddEntity(WoodenWall.new(Vector2.new(9, -8)))
testMap:AddEntity(WoodenWall.new(Vector2.new(8, -8)))
testMap:AddEntity(WoodenWall.new(Vector2.new(7, -8)))
testMap:AddEntity(WoodenWall.new(Vector2.new(6, -8)))
testMap:AddEntity(WoodenWall.new(Vector2.new(5, -8)))
testMap:AddEntity(WoodenWall.new(Vector2.new(4, -8)))
testMap:AddEntity(WoodenWall.new(Vector2.new(4, -7)))
testMap:AddEntity(WoodenWall.new(Vector2.new(3, -7)))
testMap:AddEntity(WoodenWall.new(Vector2.new(3, -6)))
testMap:AddEntity(WoodenWall.new(Vector2.new(3, -5)))
testMap:AddEntity(WoodenWall.new(Vector2.new(3, -4)))
testMap:AddEntity(WoodenWall.new(Vector2.new(3, -3)))
testMap:AddEntity(WoodenWall.new(Vector2.new(3, -2)))
testMap:AddEntity(WoodenWall.new(Vector2.new(4, -2)))]]--


CameraHandler:FollowEntity(player)
_G.localPlayer = player

function step(delta)
	--print("FPS:"..1/delta)
	--print("Object count - " .. #_G.Objects)
	--if math.abs(math.abs(math.sin(tick()*.01)) - _G.DayLight) >= 0.001 then
		--_G.DayLight = math.abs(math.sin(tick()*.01))
		--LightingHandler.RequiresUpdate = true
	--end
	_G.DayLight = 0.4

	local frameTime = tick()	
	
	if not player:IsMoving() then
		
		local moveVec = Vector2.new()
		local playerPos = player:GetPosition()
		
		if (InputHandler.Keys["d"] or InputHandler.Keys[""]) and _G.Map:GetTile(playerPos + Vector2.new(1,0)) and _G.Map:GetTile(playerPos + Vector2.new(1,0)):IsWalkable() then
			moveVec = Vector2.new(1,0)
		elseif (InputHandler.Keys["a"] or InputHandler.Keys[""]) and _G.Map:GetTile(playerPos - Vector2.new(1,0)) and _G.Map:GetTile(playerPos - Vector2.new(1,0)):IsWalkable() then
			moveVec = -Vector2.new(1,0)
		elseif (InputHandler.Keys["w"] or InputHandler.Keys[""]) and _G.Map:GetTile(playerPos + Vector2.new(0,1)) and _G.Map:GetTile(playerPos + Vector2.new(0,1)):IsWalkable() then
			moveVec = Vector2.new(0,1)
		elseif (InputHandler.Keys["s"] or InputHandler.Keys[""]) and _G.Map:GetTile(playerPos - Vector2.new(0,1)) and _G.Map:GetTile(playerPos - Vector2.new(0,1)):IsWalkable() then
			moveVec = -Vector2.new(0,1)
		end
		
		player:MoveTo(player:GetPosition() + moveVec)
		
	end
	
	_G.Map:Step(delta)
	EntityDepthHandler:Step(delta)
	local screenSize = CameraHandler:GetScreenSize() * 1.1
	_G.Map:Render(delta, player:GetPosition(), Vector2.new(screenSize.X / _G.TileSize, screenSize.Y / _G.TileSize))
	CameraHandler:Step(delta)
	LightingHandler.Step(delta)	
	
	local ProcessingTime = tick() - frameTime
	ProfilerHandler.Step(delta, ProcessingTime)
	
	if tick() - lastReplication > 0.1 then
		ReplicationHandler.Replicate()
		lastReplication = tick()
	end
end

--SoundHandler.PlayBackgroundMusic(164508682)

print("Startup time : " .. tick() - startupTime)
print("Game loop starting")

_G.StartupComplete = true

NotificationHandler.NewNotification("Welcome to Everest! My 2D wonderland!")


local timer = tick()
game:GetService("RunService").RenderStepped:connect(function()
	if not _G.Hault then
		local initTime = tick()
		step((initTime - timer))
		timer = initTime
	end
end)

InputHandler.Events["e"] = function() player:GetInventory():ToggleDisplay() CraftingHandler:HideCraftingMenu() end
InputHandler.Events["c"] = function() CraftingHandler:ToggleCraftingMenu(player:GetInventory()) player:GetInventory():Hide() end

wait(5)
NotificationHandler.NewNotification("Use wasd to move")
wait(3)
NotificationHandler.NewNotification("Click on objects (eg trees) to interact with them")
wait(3)
NotificationHandler.NewNotification("Push e to open your inventory")
wait(3)
NotificationHandler.NewNotification("Push c to open the crafting menu")
wait(3)
NotificationHandler.NewNotification("Have fun and please leave feedback!")

while wait(math.random(30,60)) do
	NotificationHandler.NewNotification("Remember this is pre alpha!")
	wait(3)
	NotificationHandler.NewNotification("Therefore it is not representitive or release gameplay!")
end