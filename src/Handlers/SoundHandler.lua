SoundHandler = {}
musicSound   = nil

function SoundHandler.PlayBackgroundMusic(soundId)
	if not musicSound then
		musicSound        = Instance.new("Sound")
		musicSound.Parent = Workspace
		musicSound.Volume = 0.2
	end
	musicSound:Stop()
	musicSound.SoundId = "rbxassetid://"..soundId
	musicSound:Play()
end

function SoundHandler.PlayGlobalSound(soundId, volume, pitch)
	local sound        = Instance.new("Sound")
	sound.Parent       = Workspace
	sound.SoundId      = "rbxassetid://"..soundId
	sound.Volume       = volume or 1
	sound.Pitch        = pitch or 1
	sound.PlayOnRemove = true
	sound:Destroy()
end

function SoundHandler.PlayWorldSound(soundId, position, volume, pitch)

end

return SoundHandler