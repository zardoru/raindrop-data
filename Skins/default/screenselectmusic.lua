game_require "librd"
skin_require "Global/Background"
skin_require "Global/FadeInScreen"

skin_require "song_wheel.lua"
DifficultyList = skin_require "UI/difficultylist.lua"


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
    strSongName.FontSize = 80
    strSongName.Font = font_big
    strSongName.X = 60
    strSongName.Y = 150
    Engine:AddTarget(strSongName)

    strSongArtist = StringObject2D()
    strSongArtist.FontSize = 50
    strSongArtist.Font = font_big
    strSongArtist.X = 60
    strSongArtist.Y = strSongName.Y + 90
    Engine:AddTarget(strSongArtist)

	DifficultyList.Transform.X = 60
	DifficultyList.Transform.Y = strSongArtist.Y + 80

	CreateWheelItems()
end

function updText()
	local sng = Global:GetSelectedSong()

	DifficultyList:SetSong(sng)

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
	-- print (yoff, Wheel.SelectedIndex, Wheel.SelectedIndex - yoff)
	Wheel.SelectedIndex = Wheel.SelectedIndex - yoff
	WheelOnScroll(yoff)
end

function Update(Delta)
	BackgroundAnimation:Update(Delta)
	UpdateWheel(Delta)
	DifficultyList:Update(Delta)
end
