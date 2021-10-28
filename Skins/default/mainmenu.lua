skin_require "Global/FadeInScreen"
game_require "Animation"

Preload = {
	"MainMenu/play.png",
	"MainMenu/quit.png"
}

IntroDuration = 0.5
ExitDuration = 1.5

function UpdateIntro(p, delta)
	local S = elastic(p)
  
  -- At 1/3rd of the screen, please.
	targBadge.Y = Screen.Height * 3/7 * (S) - targBadge.Height
	targLogo.Y = targBadge.Y
	Update(delta)
	BGAOut(p*p)
end

function OnRunningBegin()
	ScreenFade.Out()
end

function OnRestore()
	ScreenFade.Out()
end

function OnIntroBegin()
end

function OnExitBegin()
end

function UpdateExit(p, delta)
	local ease = p*p
	UpdateIntro(1-p, delta)
	FadeInA1(ease)
	BGAIn(ease)
end

function KeyEvent(k, c, mouse)
	print(k, c, mouse)
	if c then 
		Global:StartScreen("songselect")
	end
end

function Init()
  	elastic = Ease.ElasticSquare(1.5)
	ScreenFade:Init()
	Time = 0
		
	targLogo = ScreenObject {
		Texture = "MainMenu/FRONTs.png",
		X = Screen.Width / 2,
		Y = Screen.Height / 4,
		Centered = 1,
		Alpha = 1,
		Layer = 31
	}

	targBadge = ScreenObject {
		Texture = "MainMenu/BACKs.png",
		X = Screen.Width / 2,
		Y = Screen.Height / 4,
		Centered = 1,
		Layer = 31
	}
	
	font = Fonts.TruetypeFont(GetSkinFile("font.ttf"))

	s = "press any key..."
	title = with(StringObject2D(), {
		Font = font,
		Text = s,
		Z = 31,
		FontSize = 36
	})

	title.Position = Vec2(Screen.Width / 2 - title.TextSize / 2, Screen.Height * 3 / 4)

	Engine:AddTarget(title)

	-- Rocket UI not initialized yet...
end

function Cleanup()
end

badgeRotSpeed = 1080

function Update(Delta)
	Time = Time + Delta

	title.KernScale = 2 + 0.5 * sin(Time)

	local sc = sin(Time) * 0.2 + 1.2

	title.ScaleX = sc
	title.ScaleY = sc
	title.X = Screen.Width / 2 - title.TextSize * sc / 2
	badgeRotSpeed = math.max(badgeRotSpeed - Delta * 240, 120)
	targBadge.Rotation = targBadge.Rotation - badgeRotSpeed * Delta
	BackgroundAnimation:Update(Delta)
end
