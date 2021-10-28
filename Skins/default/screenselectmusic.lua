game_require "librd"
game_require "Animation"
skin_require "Global/Background"
skin_require "Global/FadeInScreen"

skin_require "song_wheel"
DifficultyList = skin_require "UI.difficultylist"

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

end

function Init()
	BackgroundAnimation:Init()
	ScreenFade.Init()

	DifficultyList:Init()

	font = Fonts.TruetypeFont(GetSkinFile("font.ttf"))
	font_big = Fonts.TruetypeFont(GetSkinFile("fonts/jackeyfont.ttf"))

    print(font_big)
	strSongName = StringObject2D()
	with(strSongName, {
		FontSize = 80,
		Font = font_big,
		X = TitleStart,
		Y = 150,
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

	DifficultyList.Transform.X = TitleStart
	DifficultyList.Transform.Y = strSongArtist.Y + 80

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

function Update(Delta)
	BackgroundAnimation:Update(Delta)
	UpdateWheel(Delta)
	DifficultyList:Update(Delta)

	Title.CurrentTime = Title.CurrentTime + Delta

	local animProgress = Title.Ease(clamp(Title.CurrentTime / Title.Duration, 0, 1))
	Title.Transform.X = mix(animProgress, Title.AnimationStartX, Title.AnimationEndX)
	Title.strSongArtist.Alpha = animProgress
	Title.strSongName.Alpha = animProgress
end
