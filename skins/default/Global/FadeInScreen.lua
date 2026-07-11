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
end

function ScreenFade.In(nobg)
	local Delay = 0
	
	if not nobg then
		BackgroundAnimation:In()
		Delay = BackgroundAnimation.Duration
	end
	ScreenFade.Tween = Tween:new(ScreenFade.Black, "Alpha", ScreenFade.Black.Alpha, 1,
		ScreenFade.Duration, Ease.Linear, Delay)
end

function ScreenFade.Out(nobg)
	
	if not nobg then
		BackgroundAnimation:Out()
	end
	ScreenFade.Tween = Tween:new(ScreenFade.Black, "Alpha", ScreenFade.Black.Alpha, 0,
		ScreenFade.Duration, Ease.Linear)
end

function ScreenFade.Update(delta)
	if ScreenFade.Tween and ScreenFade.Tween:update(delta) then
		ScreenFade.Tween = nil
	end
end
