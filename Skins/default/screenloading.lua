game_require "librd"
skin_require "Loading/phrases"
game_require "AnimationFunctions"

IntroDuration = 0.35
ExitDuration = 0.35
Acceleration = 0
badgeEase = Ease.ElasticSquare(1.5)


function UpdateIntro(frac, delta)
	targBadge.Scale = badgeEase(frac)
	targBadge.Rotation = 360 * frac 

	frac =  1 - math.pow(1 - frac, 2)

	if BG then
		BG.Alpha = frac
	end

	BgStuff.ScaleY = frac

	Phrases.Fade(frac)
	Update(delta)
end

function UpdateExit(frac, delta)
	UpdateIntro(1-frac, delta)
end

function Init()
	
	targBadge = Engine:CreateObject()
	
	targBadge.Texture = "Loading/loadingbadge.png"
	targBadge.Centered = 1
	targBadge.Width = 64
	targBadge.Height = 64
	
	wb = targBadge.Width

	targBadge.X = 48
	targBadge.Y = Screen.Height / 2 - 48
	targBadge.Layer = 16


	BgStuff = Transformation()

	targBackground = Engine:CreateObject()
	targBackground.Texture = "Global/white.png"
	with(targBackground, {
		Red = 0.03,
		Blue = 0.03,
		Green = 0.03,
		Alpha = 0.65,
		Height = Screen.Height / 3,
		Width = Screen.Width,
		Layer = 15,
		Y = 0,
		X = Screen.Width / 2,
		Centered = 1,
		ChainTransformation = BgStuff
	})
	
   local divideScreenHeightInto = 9
	local ls = 1 / divideScreenHeightInto * Screen.Height 
	local lx = Screen.Height / 2 - ls / 2
	local l1 = - 1 / divideScreenHeightInto * Screen.Height
	local l2 = 1 / divideScreenHeightInto * Screen.Height
   local textStart = targBadge.X + targBadge.Width / 2 + 38

	BgStuff.Y = lx

	local sng = Global:GetSelectedSong()
	local d = 10

	ldFont = Fonts.TruetypeFont(GetSkinFile("font.ttf"));
	strAuthor = StringObject2D()
	strAuthor.ChainTransformation = BgStuff
   
   strSong = StringObject2D()
	with (strSong, {
		Font = ldFont,
		FontSize = Screen.Height * 1 / 3 * 1 / 4,
		X = textStart,
		Y = l1 - ls * 2 / 3 + d,
		Layer = 16,
		Text = sng.Title,
		ChainTransformation = BgStuff
	})

	Engine:AddTarget(strSong)

	with (strAuthor, {
		Font = ldFont,
		FontSize = Screen.Height * 1 / 3 * 1 / 4,
		X = textStart,
		Y = strSong.Y + strSong.FontSize,
		Layer = 16,
		Text = sng.Author,
		ChainTransformation = BgStuff
	})

	Engine:AddTarget(strAuthor)

	local genre = Global:GetDifficulty(0).Genre 

	strGenre = StringObject2D()
   strGenre.Text = genre
	with (strGenre, {
		Font = ldFont,
		FontSize = Screen.Height * 1 / 3 * 1 / 3,
		X = Screen.Width - strGenre.TextSize - 10,
		Y = strAuthor.Y + strAuthor.FontSize,
		Layer = 16,
		ChainTransformation = BgStuff
	})

	Engine:AddTarget(strGenre)

	BG = Engine:CreateObject()
	BG.Texture = "STAGEFILE" -- special constant
	BG.Centered = 1
	BG.X = Screen.Width / 2
	BG.Y = Screen.Height / 2
	
	local HRatio = Screen.Height / BG.Height
	local VRatio = Screen.Width / BG.Width
	
	BG.ScaleX = math.max(HRatio, VRatio)
	BG.ScaleY = math.max(HRatio, VRatio)
	BG.Layer = 10
	BG.Alpha = 0
	
	Phrases.Init()
end

function Cleanup()
end

function Update(Delta)
	Acceleration = Acceleration + Delta

	
	targBadge.Rotation = targBadge.Rotation + (6) 
end
