game_require "utils"

IntroDuration = 0.5
ExitDuration = 0.5
Centre = (Screen.Height / 2 - 180)

Difference = Screen.Height - Centre


function UpdateIntro(frac, delta)
	frac = frac * frac
	nowLoading.Y = Centre * frac
	nowLoading.Alpha = frac
	LineL.Alpha = frac
	LineR.Alpha = frac
	
	songTitle.Alpha = frac
	songAuthor.Alpha = frac 
	songTitle.X = (songTitleCenter - songTitleStart) * frac + songTitleStart
	songAuthor.X = (songAuthorCenter - songAuthorStart) * frac + songAuthorStart
	Update(delta)
end

function UpdateExit(frac, delta)
	frac = 1 - frac
	frac = 1 - frac * frac
	nowLoading.Y = Centre + Difference * frac
	nowLoading.Alpha = 1 - frac
	
	
	songTitle.Alpha = 1 - frac
	songAuthor.Alpha = 1 - frac 
	
	songTitle.X = (Screen.Width - songTitleCenter) * (frac) + songTitleCenter
	songAuthor.X = (songAuthorEnd - songAuthorCenter) * (frac) + songAuthorCenter
	LineL.Alpha = 1 - frac
	LineR.Alpha = 1 - frac
	Update(delta)
end

function Init()
	font = Fonts.TruetypeFont(GetSkinFile("ftb_font.ttf"))
	
	nowLoading = StringObject2D()
	nowLoading.Font = font
	nowLoading.FontSize = 100
	nowLoading.Text = "Now loading..."
	nowLoading.X = Screen.Width / 2 - nowLoading.TextSize / 2
	nowLoading.Layer = 12
	
	Engine:AddTarget(nowLoading)
	
	songTitle = StringObject2D()
	songTitle.Font = font
	songTitle.FontSize = 60
	
	songTitle.Text = Global:GetSelectedSong().Title
	songTitle.Y = Screen.Height / 2 + 120
	Engine:AddTarget(songTitle)
	
	local len = (songTitle.TextSize)
	songTitleStart = -len
	songTitleCenter = Screen.Width / 2 - len / 2
	
	songAuthor = StringObject2D()
	songAuthor.Font = font
	songAuthor.FontSize = 40
	songAuthor.Text = Global:GetSelectedSong().Author
	songAuthor.Y = songTitle.Y + 85
	
	len = songAuthor.TextSize
	songAuthorStart = Screen.Width
	songAuthorCenter = Screen.Width / 2 - len / 2
	songAuthorEnd = -len
	Engine:AddTarget(songAuthor)
	
	LineL = Engine:CreateObject()
	LineL.Texture = "Global/white.png"
	LineL.X = 20
	LineL.Y = 0
	LineL.Width = 1
	LineL.Height = Screen.Height 
	
	LineR = Engine:CreateObject()
	LineR.Texture = "Global/white.png"
	LineR.X = Screen.Width - 20
	LineR.Y = 0
	LineR.Width = 1
	LineR.Height = Screen.Height
end

function Cleanup()
end

function Update(Delta)
	LineL.Y = LineL.Y + Delta * 800
	
	if LineL.Y > Screen.Height then
		LineL.Y = LineL.Y - Screen.Height * 2
	end
	
	LineR.Y = LineR.Y - Delta * 800
	
	if LineR.Y < -Screen.Height then
		LineR.Y = LineR.Y + Screen.Height * 2
	end

end
