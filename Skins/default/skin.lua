-- Default skin configuration.

-- Backgrounds (dotcur mostly, exception being default)
DefaultBackground = "Global/MenuBackground.png"
EvaluationBackground = DefaultBackground
DefaultGameplayBackground = DefaultBackground

-- Gameplay

--[[ Considerations.

	Playing field size is 800x600. This won't change.
	Screen.Width and Screen.Height are set automatically.
	"Centered" means to use the center of the image instead of the top-left.

]]

-- Audio
AudioManifest = {
	Miss = "miss.wav",
	Fail = function()
		return Global.CurrentGaugeType ~= LifeType.LT_GROOVE and "stage_failed.ogg" or ""
	end,
	ClickPlay = "drop.wav",

	--[[ 
	--  Better than autodetection.
	--	See, if you make a closure, Decision, Hover, then BGM
	--	will be called in that order. 
	--	That means you can choose them in a consistent way.
	--	ala LR2
	--]]
	SongSelectDecision = "select.wav",
	SongSelectHover = "click.wav",
	SongSelectBGM = function()
		return "loop" .. math.random(8) .. ".ogg" 
	end
}

Hitlightning = 1

-- 7K mode configuration.
-- Time that the 'miss' layer will be shown on BMS when a miss occurs.
OnMissBGATime = 0.5

ShowCursor = 1

-- Set screen filter transparency on 7K.
ScreenFilter = 0.97

-- Whether to display the in-game histogram.
Histogram = 0

-- Whether to go to song select inmediately on failure
GoToSongSelectOnFailure = 0

-- Whether to not wait for enter to be pressed to start playing
InmediateActivation = 1

-- Size of the playfield (For Green Number calculation)
PlayfieldSize = 768 * 0.8

-- How big is one 4/4 measure
UnitsPerMeasure = PlayfieldSize

-- 1 is first after processing SV, 1 is mmod, 2 is cmod, anything else is default.
-- default: first speed before processing SV
DefaultSpeedKind = function ()
	return System.ReadConfigF("SpeedClass", "Speed")
end
DefaultSpeedUnits = function()
	return System.ReadConfigF("SpeedAmount", "Speed")
end
