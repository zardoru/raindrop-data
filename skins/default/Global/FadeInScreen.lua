game_require "librd"
skin_require "Global/Background"

function FadeInA1(frac)
	ScreenFade.Black.Alpha = frac
	return 1
end

function invert(f, frac)
	newf = function (frac)
		return f(1 - frac)
	end

	return newf
end

ScreenFade = { Duration = 0.45 }

function ScreenFade.Init()
	BackgroundAnimation:Init()
	ScreenFade.Black = Engine:CreateObject()
	ScreenFade.Black.Texture = "Global/filter.png"

	with(ScreenFade.Black, {
		Width = Screen.Width,
		Height = Screen.Height,
		Alpha = 0,
		Layer = 15
	})
	
	IFadeInA1 = invert(FadeInA1)
	return
	--[["Black1 = Engine:CreateObject()
	Black2 = Engine:CreateObject()
	
	Black1.Image = "Global/filter.png"
	Black2.Image = "Global/filter.png"
	
	Black1.Centered = 1
	Black2.Centered = 1
	
	Black1.X = Screen.Width/2
	Black2.X = Screen.Width/2
	
	Black1.Y = Screen.Width/4
	Black2.Y = Screen.Width*3/4
	
	Black1.Alpha = 1
	Black2.Alpha = 1
	
	Black1.Width = Screen.Width
	Black2.Width = Screen.Width
	
	Black1.Height = Screen.Height/2
	Black2.Height = Screen.Height/2
	Black1.Z = 15
	Black2.Z = 15
	
	IFadeInA1 = invert(FadeInA1)
	IFadeInA2 = invert(FadeInA2)
	]]
end

function ScreenFade.In(nobg)
	local Delay = 0
	
	if not nobg then
		BackgroundAnimation:In()
		Delay = BackgroundAnimation.Duration
	end
	
	return --[[ Lines beyond are previous implementation.
	]]
end

function ScreenFade.Out(nobg)
	
	if not nobg then
		BackgroundAnimation:Out()
	end
	
	return --[[
	]]
end
