game_require "librd"
game_require "Animation"
skin_require "Global/Background"
skin_require "Global/FadeInScreen"

skin_require "song_wheel"
DifficultyList = skin_require "UI.difficultylist"
Options = skin_require "UI.options"

local font
local font_big

local TitleStart = 60
local Title = {
	Transform = Transformation(),
	AnimationStartX = TitleStart,
	AnimationEndX = 0,
	Duration = 0.3,
	CurrentTime = 0,
	Ease = Ease.Out
}

-- Screen Events
function OnSelect()
	TransformX = WheelExitX 
	ScreenFade.In()
	return 1
end

function OnRestore()
	ScreenFade.Out()

	Wheel.SelectedIndex = Wheel.SelectedIndex -- force OnSongChange event
end

function OnDirectoryChange()
	TransformX = WheelX
end


function KeyEvent(k, c, m)
	Options:KeyEvent(k, c)
end

function InitSongSelectBanner()
	bgSongSelectBanner = ScreenObject {
		Texture = "Global/filter.png",
		Size = Vec2(Screen.Width, 120),
		Z = 20
	}

	strSongSelectTitle = StringObject2D()
	with(strSongSelectTitle, {
		Font = font,
		FontSize = 100,
		Position = Vec2(40, -20),
		Text = "songselect...",
		Z = 21
	})

	Engine:AddTarget(strSongSelectTitle)

	Options:Init(font)
end

function Init()
	BackgroundAnimation:Init()
	ScreenFade.Init()

	-- Fonts
	font = Fonts.TruetypeFont(GetSkinFile("font.ttf"))
	font_big = Fonts.TruetypeFont(GetSkinFile("fonts/jackeyfont.ttf"))

	-- Song Select Banner
	InitSongSelectBanner()

	-- Song name and artist
	strSongName = StringObject2D()
	with(strSongName, {
		FontSize = 80,
		Font = font_big,
		X = TitleStart,
		Y = 180,
		Parent = Title.Transform
	})
	Title.strSongName = strSongName

    Engine:AddTarget(strSongName)

    strSongArtist = StringObject2D()
	with(strSongArtist, {
		FontSize = 50,
		Font = font_big,
		X = TitleStart,
		Y = strSongName.Y + 90,
		Parent = Title.Transform
	})
	Title.strSongArtist = strSongArtist

    Engine:AddTarget(strSongArtist)

	-- Difficulty list
	DifficultyList:Init()
	DifficultyList.Transform.X = TitleStart
	DifficultyList.Transform.Y = strSongArtist.Y + 80

	-- Wheel
	CreateWheelItems()
end

function updText()
	local sng = Global:GetSelectedSong()

	DifficultyList:SetSong(sng)
	Title.CurrentTime = 0

	if sng then
		-- local diff = Global:GetDifficulty(0)

        -- print(Song.Title)
		strSongName.Text = sng.Title
		strSongArtist.Text = sng.Author

	else
		strSongName.Text = ""
		strSongArtist.Text = ""
	end
end

function Cleanup()
end

function ScrollEvent(xoff, yoff)
	WheelOnScroll(yoff)
end

function Update(deltaTime)
	BackgroundAnimation:Update(deltaTime)
	UpdateWheel(deltaTime)
	DifficultyList:Update(deltaTime)

	Options:Update(deltaTime)

	Title.CurrentTime = Title.CurrentTime + deltaTime

	local animProgress = Title.Ease(clamp(Title.CurrentTime / Title.Duration, 0, 1))
	Title.Transform.X = mix(animProgress, Title.AnimationStartX, Title.AnimationEndX)
	Title.strSongArtist.Alpha = animProgress
	Title.strSongName.Alpha = animProgress
end
