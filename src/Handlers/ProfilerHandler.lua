CameraHandler       = require(_G.Everest.Handlers.CameraHandler)

local ProfilerHandler = {}
ProfilerHandler.__index = ProfilerHandler

local ProcessTimes = {}
local FpsHistory = {}
local ProjectedFpsHistory = {}

local debugGui = game.ReplicatedStorage.DebugGui:Clone()
debugGui.Parent = CameraHandler:GetContainer().Parent

function ProfilerHandler.Step(delta, frametime)
	local timer = tick()
	table.insert(FpsHistory, 1/delta)
	if #FpsHistory > 60 then
		table.remove(FpsHistory, 1)
	end
	table.insert(ProjectedFpsHistory, 1/frametime)
	if #ProjectedFpsHistory > 60 then
		table.remove(ProjectedFpsHistory, 1)
	end
	
	local fps = 0
	local projectedfps = 0
	local fpstot, projectedtot
	
	for i, v in pairs(FpsHistory) do
		fps = fps + v
		fpstot = i
	end
	
	for i, v in pairs(ProjectedFpsHistory) do
		projectedfps = projectedfps + v
		projectedtot = i
	end
	
	local output = "Projected Fps: " .. math.floor(projectedfps/projectedtot) .. "(".. math.floor((1/(projectedfps/projectedtot))*1000000)/1000 .." ms)\n"
	output = output.. "Real Fps: " .. math.floor(fps/fpstot) .. "\n"
	output = output .. "Entity count: " .. _G.CurrentEntityNumber .. "\n"
	output = output .. "Light count: " .. _G.LightCount .. "\n"
	output = output .. "Current position: " .. tostring(_G.localPlayer.Position) .. "\n"
	
	for i, v in pairs(ProcessTimes) do
		local average = 0
		local total
		for tot, num in pairs(v) do
			average = average + num
			total = tot
		end
		average = average / total
		output = output .. i .. ": " .. math.floor(average / (1/(projectedfps/projectedtot)) * 100) .. "% (".. math.floor(average*1000000)/1000 .." ms) \n"
	end
	output = output .. "\nohai providing me with your projected fps is a great way to help! :3"
	debugGui.Frame.TextLabel.Text = output
	ProfilerHandler.AddProcessTime("Handler", "Profiler", tick() - timer)
end

function ProfilerHandler.AddProcessTime(main, sub, amount)
	ProcessTimes["("..main..")"..sub] = ProcessTimes["("..main..")"..sub] or {}
	if #ProcessTimes["("..main..")"..sub] > 60 then
		table.remove(ProcessTimes["("..main..")"..sub], 1)
	end
	table.insert(ProcessTimes["("..main..")"..sub], amount)
end


return ProfilerHandler